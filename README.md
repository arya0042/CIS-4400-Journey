# CIS-4400-Journey

**Who we are**

![Screenshot 2023-12-04 182135](https://github.com/arya0042/CIS-4400-Journey/assets/145073688/1c922fdf-c6b7-4ee3-bf31-5f71fff90b02)

We are *Journey*, a Data Collection 


Data Sourcing
For the NYC taxi analysis project, spanning January to March 2023, data is sourced from the TLC website for taxi trip records and the Visual Crossing API for weather data. The TLC dataset, organized in monthly Parquet files, is securely stored in Microsoft Azure Storage Blob ('aryanstorage2' account, 'journeydata' container). The Python code efficiently uploads files, maintaining a clear dataset structure.

The weather data, fetched through the Visual Crossing API, is locally saved as 'weather_data.csv.' This dual-data approach combines taxi trip details and weather information, enriching the project's depth.  For comprehensive understanding, Yellow and Green taxi data dictionaries are referenced. The Yellow Taxi Data Dictionary is available [here](https://github.com/arya0042/CIS-4400-Journey/blob/main/Yellow%20Taxi%20Data%20Dictionary), and the Green Taxi Data Dictionary is accessible [here](https://github.com/arya0042/CIS-4400-Journey/blob/main/Green%20Taxi%20Data%20Dictionary)
To further enhance clarity, the Weather Data Dictionary is also available [here](https://github.com/arya0042/CIS-4400-Journey/blob/main/Weather%20Data%20Dictionary). Utilizing Azure Storage Blob ensures a scalable and secure storage solution, facilitating seamless data retrieval and analysis.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Storage
As of December 4, 2023, the data for the NYC taxi analysis project is securely stored in Microsoft Azure Storage Blob. The TLC dataset, comprising monthly Parquet files from January to March 2023, is housed within the 'journeydata' container of the 'aryanstorage2' Azure Storage account. This structured storage system ensures efficient organization, allowing for seamless retrieval and analysis.
For a visual overview of the stored data, one can explore the Azure Storage Blob through the 'aryanstorage2' account. The contents, including Yellow and Green taxi Parquet files, can be viewed within the 'journeydata' container. Photo images of that can be viewd on Github. Additionally, the Yellow Taxi Data Dictionary, Green Taxi Data Dictionary, and Weather Data Dictionary serve as valuable references for a comprehensive understanding of the datasets. This storage infrastructure not only provides a scalable and secure foundation for ongoing exploration and analysis but also offers a transparent glimpse into the contents via the Azure Storage Blob interface.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Modeling

In the process of modeling the data warehouse for the NYC taxi analysis project, I utilized a combination of Microsoft Access for visualization and Microsoft SQL Server Management Studio (SSMS) for creating the actual database. The Access model, which can be viewed [here](https://github.com/arya0042/CIS-4400-Journey/blob/main/Aryan%20Khandelwal%20SQL%20relationship%20Model.png), served as a visual guide.

The database schema includes key dimension and fact tables. Here's a brief description of the tables:

Dimension Table: Location
```sql
CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    borough VARCHAR(255) NOT NULL,
    zone VARCHAR(255) NOT NULL
);
```

Dimension Table: TaxiColor
```sql
CREATE TABLE TaxiColor (
    taxi_color_id INT PRIMARY KEY,
    color_name VARCHAR(255) UNIQUE NOT NULL
);
```

Dimension Table: DateInfo
```sql
CREATE TABLE DateInfo (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    tempmax DECIMAL
);
```

Fact Table: Trips
```sql
CREATE TABLE Trips (
    trip_id INT PRIMARY KEY,
    total_amount DECIMAL NOT NULL,
    taxi_color_id INT,
    location_id INT,
    date_id INT,
    FOREIGN KEY (taxi_color_id) REFERENCES TaxiColor(taxi_color_id),
    FOREIGN KEY (location_id) REFERENCES Location(location_id),
    FOREIGN KEY (date_id) REFERENCES DateInfo(date_id)
);
```

Additionally, the SQL script includes an alteration to the `DateInfo` table:

```sql
ALTER TABLE DateInfo
ADD tempmax DECIMAL;
```

To make the data warehouse accessible to the team, an Azure database named `akhan00142` was created. You can find images of the database, including the key and screenshots from Azure, [here](https://github.com/arya0042/CIS-4400-Journey/blob/main/Database%20Images%20with%20key%20and%20azure).

The Git repository has been updated to reflect these changes, ensuring that all team members have access to the latest scripts and database schema. The SQL scripts for creating the data warehouse, as well as the scripts from previous steps, have been updated accordingly. The fact and dimension tables are defined with surrogate keys for efficient data management and analysis. The deliverables include the data model documentation, SQL scripts, and a fully accessible data warehouse for collaborative team usage.

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Section 1: Import Libraries
```python
import pandas as pd
```
This section imports the Pandas library and assigns it the alias "pd" for easier use in the code.

Section 2: Read Location Information from CSV
```python
file_path_location = r'C:\Users\khand\OneDrive\Desktop\STA 3000\ID_Data.csv'
location_info_df = pd.read_csv(file_path_location)
```
Reads location information from a CSV file and stores it in the `location_info_df` DataFrame.

Section 3: Read Yellow Taxi Data
```python
file_path_yellow_jan = r'C:\Users\khand\OneDrive\Desktop\STA 3000\january_yellow_taxidata.parquet'
file_path_yellow_feb = r'C:\Users\khand\OneDrive\Desktop\STA 3000\feburary_yellow_taxidata.parquet'
file_path_yellow_march = r'C:\Users\khand\OneDrive\Desktop\STA 3000\march_yellow_taxidata.parquet'

df_yellow_jan = pd.read_parquet(file_path_yellow_jan)
df_yellow_feb = pd.read_parquet(file_path_yellow_feb)
df_yellow_march = pd.read_parquet(file_path_yellow_march)
```
Reads yellow taxi data from three different Parquet files for January, February, and March and stores them in separate DataFrames.

Section 4: Specify Columns to Remove from Yellow Taxi Data
```python
columns_to_remove_yellow = [list of column names]
```
Specifies a list of columns that need to be removed from the yellow taxi data.

Section 5: Drop Specified Columns from Yellow Taxi Data
```python
for col in columns_to_remove_yellow:
    # Drop columns if they exist in each month's DataFrame
```
Iterates through the specified columns and removes them from each yellow taxi DataFrame if they exist.

Section 6: Concatenate Yellow Taxi DataFrames Vertically
```python
df_yellow = pd.concat([df_yellow_jan, df_yellow_feb, df_yellow_march], ignore_index=True)
```
Concatenates the three yellow taxi DataFrames vertically, creating a combined DataFrame `df_yellow`.

Section 7: Add a New Column 'Taxi_Color' with Each Cell Filled with 'Yellow'
```python
df_yellow['Taxi_Color'] = 1
```
Adds a new column 'Taxi_Color' to `df_yellow` and fills each cell with the value 'Yellow' (represented as 1).

Section 8: Convert 'tpep_pickup_datetime' to Datetime Format
```python
df_yellow['tpep_pickup_datetime'] = pd.to_datetime(df_yellow['tpep_pickup_datetime'])
```
Converts the 'tpep_pickup_datetime' column in `df_yellow` to datetime format if it's not already.

Section 9: Define the Date Range for Yellow Taxi
```python
start_date_yellow = '2023-01-01'
end_date_yellow = '2023-03-31'
```
Specifies the start and end dates for the desired date range for yellow taxi data.

Section 10: Filter out Rows Outside the Specified Date Range for Yellow Taxi
```python
df_yellow = df_yellow[(df_yellow['tpep_pickup_datetime'] >= start_date_yellow) & (df_yellow['tpep_pickup_datetime'] <= end_date_yellow)]
```
Filters out rows in `df_yellow` that fall outside the specified date range.

 Section 11: Merge Yellow Taxi DataFrame with Location Information DataFrame
```python
df_yellow = pd.merge(df_yellow, location_info_df, left_on='PULocationID', right_on='LocationID', how='left')
```
Merges `df_yellow` with `location_info_df` based on the 'PULocationID' and 'LocationID' columns, using a left join.

Section 12: Drop Redundant Columns
```python
df_yellow = df_yellow.drop(columns=['LocationID', 'Airport_fee', 'service_zone'])
```
Drops specified redundant columns from the merged DataFrame.

 Section 13: Display the First 10 Rows of the Resulting DataFrame
```python
df_yellow.head(10)
```
Displays the first 10 rows of the final DataFrame `df_yellow`.


Access to the visualization file can be found [here](https://drive.google.com/file/d/1mff8vnrWLopUcI3tw_Wb_p_5kFnL5WrU/view?usp=sharing)


