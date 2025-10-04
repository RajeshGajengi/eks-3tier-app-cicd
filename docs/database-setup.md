# 📦 Database Setup (MariaDB on AWS RDS)

This project uses **MariaDB hosted on AWS RDS** for persistent storage.

## Step 1: Create RDS Instance
- Engine: MariaDB
- Port: 3306
- Public access: Yes (or configure a proper VPC + security group if running privately)
- Database username: e.g., `admin`
- Password: e.g., `secure-password`

<!-- - Public access: **No** (preferred) → use VPC + Security Groups -->
<!-- Terraform option (recommended): see `terraform/rds.tf`. -->


## Step 2: Connect to the RDS instance
Use the MariaDB client to connect to your RDS instance:
```bash
mysql -h <RDS_ENDPOINT> -u admin -p
```
You’ll be prompted to enter the password.

## Step 3: Create the database
Once connected:
```sql
CREATE DATABASE student_db;
```
This will create the database used by the backend Spring Boot application.
> ⚠️ Make sure the name matches the value in the `SPRING_DATASOURCE_URL` (e.g., `jdbc:mariadb://<RDS_ENDPOINT>:3306/student_db`).

## Step 4: Grant access (optional)
If using a different DB user than admin, ensure it has privileges on the database:
```sql
GRANT ALL PRIVILEGES ON student_db.* TO 'your_user'@'%' IDENTIFIED BY 'your_password';
FLUSH PRIVILEGES;
```

## Step 5: Security Group Rules

- Allow inbound on port 3306 only from:
    - EKS worker nodes
    - Jenkins server (if needed)


## Best Practices
- Use AWS Secrets Manager for DB credentials.
- Rotate passwords periodically.
- Avoid exposing RDS publicly.

## Note 
- Ensure the RDS endpoint and credentials are added in Jenkins credentials:
    - `database_url`
    - `database_user`
    - `database_password`
<!-- 
> 💡 If you're provisioning RDS via Terraform, refer to your Terraform config (e.g., `terraform/rds.tf`) for the actual DB name, username, and endpoint. -->
