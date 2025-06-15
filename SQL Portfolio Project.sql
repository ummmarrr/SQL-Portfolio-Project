--1. Management wants to see all the users that did not login in the past 5 months Tables
--return: username.
--2024-06-28 15:45:00.000 --> latest date

select l.USER_ID,max(u.USER_NAME) name
from LOGINS l
inner join users u on l.USER_ID=u.USER_ID
group by l.USER_ID
having DATEDIFF(month,max(LOGIN_TIMESTAMP),'2024-06-28 15:45:00.000') >=5
------------------------------------------------------------------------------------------
--2. For the business units' quarterly analysis, calculate how many users and how many sessions were at each quarter 
--order by quarter from newest to oldest.
--Return: first day of the quarter, user_cnt, session_cnt.

select DATEPART(quarter,LOGIN_TIMESTAMP) which_quarter
,DATETRUNC(quarter,min(LOGIN_TIMESTAMP)) first_date_of_quarter
,count(distinct USER_ID) user_count, count(distinct SESSION_ID) session_count
from logins
group by DATEPART(quarter,LOGIN_TIMESTAMP)
order by DATEPART(quarter,LOGIN_TIMESTAMP) 

------------------------------------------------------------------------------------------
--3. Display user id's that Log-in in January 2024 and did not Log-in on November 2023.
--Return: User_id
select distinct USER_ID
from logins
where login_timestamp between '2024-01-01' AND '2024-01-31' 
Except
select distinct USER_ID
from logins
where login_timestamp between '2023-11-01' AND '2023-11-30'

------------------------------------------------------------------------------------------
--4. Add to the query from 2 the percentage change in sessions from last quarter.
--Return: first day of the quarter, session_cnt, session_cnt_prev, Session_percent_change.
with cte as(
select DATEPART(quarter,LOGIN_TIMESTAMP) which_quarter
,DATETRUNC(quarter,min(LOGIN_TIMESTAMP)) first_date_of_quarter
,count(distinct SESSION_ID) session_count
from logins
group by DATEPART(quarter,LOGIN_TIMESTAMP))
--
select *
,LAG(session_count,1)over(order by first_date_of_quarter) prev_session_count
,(session_count- LAG(session_count,1)over(order by first_date_of_quarter))*100.0/LAG(session_count,1)over(order by first_date_of_quarter) session_percent_change
from cte

------------------------------------------------------------------------------------------
--5. Display the user that had the highest session score (max) for each day
--Return: Date, username, score
with cte as(
select user_id,cast(login_timestamp as date) day,SUM(session_score) score
from logins
group by user_id,cast(login_timestamp as date))
--
,cte_2 as(
select * from(
select *, ROW_NUMBER()over(partition by day order by score desc) rn
from cte
) c
where rn=1)
--
select c.user_id,c.day,c.score,u.USER_NAME
from cte_2 c
inner join users u on u.USER_ID=c.user_id

------------------------------------------------------------------------------------------
--6. To identify our best users Return the users that had a session on every single day since their first login
--(make assumptions if needed).
--Return: User_id

select * from users
select * from logins
--optimized query
select user_id ,cast(min(login_timestamp)as date) firstlogin , count(session_id) total_session_done
,datediff(day,cast(min(login_timestamp)as date),'2024-06-28')+1 total_session_req
from logins
group by USER_ID
having count(session_id) = datediff(day,cast(min(login_timestamp)as date),'2024-06-28')+1

--first query (non-optimized)
--with cte as(
--select user_id,count(session_id) total_session
--from logins
--group by user_id)
--, mindate as(
--select user_id,min(login_timestamp) as firstdate
--from logins
--group by user_id)
--, sess as (
--select l.user_id,max(c.total_session) session,min(m.firstdate) first_session
--from logins l
--inner join mindate m on m.user_id = l.user_id
--inner join cte c on c.user_id = l.user_id
--group by l.user_id)


--select *
--,case when DATEDIFF(day, first_session,'2024-06-28')+1=session THEN 'Y' ELSE 'N' END as imp
--from sess
------------------------------------------------------------------------------------------


--7. On what dates there were no Log-in at all?
--Return: Login_dates

select * from logins
--first-date = 2023-07-15 09:30:00.000
--last date = 2024-06-28 15:45:00.000

with rec_cte as(
	select cast('2023-07-15' as date) as date --initialization
	union all
	select DATEADD(day,1,date) from rec_cte  --loop
	where 	date <= cast('2024-06-28' as date)	--termination condition
	)
, alldate as(
select * from rec_cte)

select date
from alldate 
where date not in (select login_timestamp
				   from logins
				  )
OPTION (MAXRECURSION 0)

