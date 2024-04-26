-- SQL queries to set up schemas in BigQuery
The steps followed to set-up the SQLite3 enviroment schema 
to update all the requested SQL tasks are as below:

Step 1:
Open Command Prompt and navigate to the root directory.
command used > cd\

Step 2:
Navigate to the relevant folder to create a sql database.
command used > cd <name_of_the_folder>
            cd sqlite3

Step 3:
Create a sql database in sqlite3.
Command used > sqlite3 ps_sql_db

Step 4:
Check if the db is correctly created.
command used > .databases

Step 5:
To load the CSV file within the SQL DB it can be done in 2 ways:
Method 1. directly setup the mode to csv and define a table
       and import the file into the database table
Method 2. create a table in the database first with all columns defined with relevant
       data type and then import the csv file into that database table
Below are the command used for both ways but I preferred working with method 2.
because I was not dropping any column from my orginal file.
If I could breakdown the main file into multiple files and could create a star
schema with primary key as 'Order ID' I would have preferred method 1.

Command used for Method 1.:
Create table <name_of_the_table> (column_name data_type, column_name data_type);

Create table ps_table (Region text, Country text, Item_Type text, Sales_Channel text
, Order_Priority text, Order_Date date, Order_id integer, Ship_Date date, Units_sold integer
, Unit_price integer, Unit_cost integer, Total_revenue integer, Total_cost integer
, Total_profit integer);

Check if the table is created correctly by the command .tables

Change the mode to CSV and import the CSV file to the database table.
Command used: .mode csv
              .import c:\sqlite3\File_Sales_Records.csv ps_table
              select * from ps_table;

Command used for Method 2. :
.mode csv ps_table
.import c:\sqlite3\File_Sales_Records.csv ps_table
select * from ps_table;

