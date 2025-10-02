# MariaDB Setup and Configuration Guide for Windows

This guide explains how to set up MariaDB, create a database, and Create Database User

## 1. Installing MariaDB

Installing MariaDB on Ubntu

```shell
apt update && apt install mariadb-server -y
```

## 2. Securing MariaDB

Open the Command Prompt as Administrator and run the following command to secure your installation:

```shell

mysql_secure_installation
```

Follow the prompts to:
Set a root password.
Remove insecure default users and test databases.
Disable remote root login.

## 3. Setting Up the Database

Open terminal and login to MariaDB:

```bash

mysql -u root -p
```

Enter the root password when prompted.

Create a new database and user:

```sql
CREATE DATABASE student_db;
GRANT ALL PRIVILEGES ON springbackend.* TO 'username'@'localhost' IDENTIFIED BY 'your_password';
```
Replace username and your_password with your desired username and password.

Exit MariaDB:

```sql

EXIT;
```

## 4. You will need Database Credentials to Connect Backend with Database
1. DB_HOST
2. DB_USER
3. DB_PASS
4. DB_PORT

5. DB_NAME


USE student_db;

CREATE TABLE `students` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `course` varchar(255) DEFAULT NULL,
  `student_class` varchar(255) DEFAULT NULL,
  `percentage` double DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `mobile_number` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;



<!-- 🗄️ Database Setup (MariaDB on AWS RDS)

This project uses a MariaDB database hosted on AWS RDS.

✅ Step 1: Create the RDS instance

If you haven’t already, create a MariaDB-compatible RDS instance via the AWS Console or using Terraform.

Engine: MariaDB

Port: 3306

Public access: Yes (or configure a proper VPC + security group if running privately)

Database username: e.g., admin

Password: e.g., yourpassword

✅ Step 2: Connect to the RDS instance

Use the MariaDB client to connect to your RDS instance:

mysql -h <RDS_ENDPOINT> -u admin -p


You’ll be prompted to enter the password.

✅ Step 3: Create the database

Once connected:

CREATE DATABASE student_db;


This will create the database used by the backend Spring Boot application.

⚠️ Make sure the name matches the value in the SPRING_DATASOURCE_URL (e.g., jdbc:mariadb://<RDS_ENDPOINT>:3306/student_db).

✅ Step 4: Grant access (optional)

If using a different DB user than admin, ensure it has privileges on the database:

GRANT ALL PRIVILEGES ON student_db.* TO 'your_user'@'%' IDENTIFIED BY 'your_password';
FLUSH PRIVILEGES;

📝 Notes:

Make sure the RDS security group allows inbound access on port 3306 from the IP or EC2/Jenkins host.

Ensure the RDS endpoint and credentials are added in Jenkins credentials:

database_url

database_user

database_password 

-->
