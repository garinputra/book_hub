This project demonstrates the design and development of a robust database system for BookHub, a mobile-based e-commerce platform that enables users to explore, purchase, and borrow physical books and e-books. The project integrates SQL for database management and JDBC (Java Database Connectivity) for seamless interaction between the Java application and the database. By combining SQL’s power with the dynamic capabilities of JDBC, the system enables real-time transaction management and secure data handling for an enhanced user experience.
Project Aim:
To design, implement, and optimize a scalable database system that supports BookHub's core functions: user management, book inventory control, transaction processing, and payment handling, using SQL for data management and JDBC for real-time Java application integration.

Objectives:
Create a normalized relational database using SQL to handle book orders, borrowing, payments, and user interactions.
Integrate JDBC to enable the Java application to dynamically interact with the database, performing operations like book searches, user registration, and payment processing in real-time.
Implement security best practices with JDBC by using prepared statements and transaction management to ensure data integrity and protection against SQL injection.
Provide a scalable solution that can be expanded for future features such as analytics, personalized book recommendations, and real-time inventory updates.
Steps and Methodologies:
Database Design (ERD & ERM):

Designed the database using an Entity-Relationship Model (ERM), identifying key entities (users, books, orders, payments) and their relationships.
Created an Entity-Relationship Diagram (ERD) to visualize the connections between tables such as users, admins, books, orders, borrowings, and payments.
SQL Implementation (DDL & DML):

Used Data Definition Language (DDL) to create and define the tables, including constraints for data validation (e.g., primary key, foreign key, and check constraints).
Applied Data Manipulation Language (DML) to insert, update, and delete data in the database. Examples include inserting new user registrations, updating book status, and processing orders.
Normalized the database to Third Normal Form (3NF) to ensure minimal redundancy and better performance.
JDBC Integration:

Integrated JDBC into the project to allow the Java application to interact directly with the database. This included executing SQL queries, handling user inputs, and fetching real-time data such as book availability and transaction history.
Used Prepared Statements in JDBC to prevent SQL injection and ensure safe query execution. For instance, adding new orders or fetching user details based on search parameters was made secure through parameterized queries.
Managed database transactions using JDBC, ensuring atomicity for operations like processing payments and order completion, where multiple operations need to be executed as a single unit.
Implemented ResultSet for retrieving and displaying query results in the Java application, such as available books, user orders, and pending payments.
Activity Diagram:

Developed an activity diagram to map the flow of user interactions on BookHub, including registration, book browsing, placing orders, borrowing books, and making payments.
Views:

Created SQL views to simplify data retrieval for frequently used queries, such as available_books for books in stock and PendingPaymentView to track pending transactions.
Key Insights:
Real-time Data Management: The integration of JDBC allows for real-time data handling, enabling dynamic responses to user actions such as browsing books, placing orders, and checking payment statuses.
Enhanced Security: The use of prepared statements and transaction management with JDBC improves data integrity and protection from security vulnerabilities like SQL injection.
Modular and Scalable Design: The combination of SQL and JDBC allows the system to be easily extended with additional features like personalized book recommendations, detailed order tracking, and comprehensive user analytics.
Conclusion:
This project successfully combines SQL and JDBC to create a flexible and secure e-commerce platform that can handle BookHub’s core operations efficiently. The system supports real-time transactions, dynamic data manipulation, and a scalable structure, ensuring that BookHub is well-positioned for growth. By integrating Java’s JDBC API, the project provides a seamless connection between the application and the database, improving both performance and user experience.
