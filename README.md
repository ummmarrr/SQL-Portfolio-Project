# User Login Analysis SQL Project


## 📊 Overview
This project contains a collection of SQL queries focused on analyzing user login data to identify activity patterns, calculate engagement metrics, and derive actionable business insights.

The key objectives of this analysis include:
- Identifying inactive users
- Analyzing quarterly login trends
- Discovering high-performing users
- Detecting system downtime or anomalies

---

## 🗃️ Database Schema

![Table](https://github.com/user-attachments/assets/7cf852d8-aee7-4015-840f-60f7009a4be2)


### **users Table**

| Column     | Type     | Description                          |
|------------|----------|--------------------------------------|
| USER_ID    | int      | Unique user identifier (Primary Key) |
| USER_NAME  | varchar  | User's display name                  |

---

### **logins Table**

| Column          | Type       | Description                                  |
|-----------------|------------|----------------------------------------------|
| SESSION_ID      | int        | Unique session identifier (Primary Key)      |
| USER_ID         | int        | Reference to users table (Foreign Key)       |
| LOGIN_TIMESTAMP | datetime   | Timestamp of user login                      |
| SESSION_SCORE   | decimal    | Numeric value representing session quality   |

## SQL Queries
1. Management wants to see all the users that did not login in the past 5 months Tables
   ![Q1](https://github.com/user-attachments/assets/c508117a-df83-411f-b7aa-b74759ec9e5f)


3. For the business units' quarterly analysis, calculate how many users and how many sessions were at each quarter
   ![Q2](https://github.com/user-attachments/assets/a7eb9ddd-af65-42d7-a5b9-350e05b894a1)

4. Display user id's that Log-in in January 2024 and did not Log-in on November 2023
  ![Q3](https://github.com/user-attachments/assets/e54b294f-cbda-4738-8dfe-4f45aa40ac34)

5. Add to the query from 2 the percentage change in sessions from last quarter
  ![Q4](https://github.com/user-attachments/assets/3451deec-41e6-413f-8f26-41b41c9f3d9d)

6. Display the user that had the highest session score (max) for each day
  ![Q5](https://github.com/user-attachments/assets/3bf35656-2eb4-4944-b6eb-426567bafd20)

7. To identify our best users Return the users that had a session on every single day since their first login
  ![Q6](https://github.com/user-attachments/assets/485fb65e-29c6-43bc-8fc0-ca8fd9503bc7)

8. On what dates there were no Log-in at all?
  ![Q7](https://github.com/user-attachments/assets/8929d792-1606-4d53-8923-ec82d2f230b3)



