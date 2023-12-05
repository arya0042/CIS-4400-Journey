# CIS-4400-Journey

---
Business Problem

![Screenshot 2023-12-04 182135](https://github.com/arya0042/CIS-4400-Journey/assets/145073688/1c922fdf-c6b7-4ee3-bf31-5f71fff90b02)

We are *Journey*, a data collection company specializing in transportation analytics. Our company is based in New York City, and our work is always busy due to the ever-changing landscape that is NYC road infrastructure. 

Traffic has been one of the biggest issues in NYC, especially for taxi drivers in recent years, compounded by new laws and competition that seem to be evergrowing. That is why we have a new focus, which is to gather data from the Taxi & Limousine Commission (TLC) and present it to clients wishing to invest in taxi medallions and know more info regarding the activity of NYC taxis, or perhaps even used for application development for enterprising companies. 

**Requirements**
- Yellow and Green taxi filter
- Borough filter
- Total trips by taxi type
- Total trips by borough
- Total trips organized by month and by day
- Revenue by borough

These requirements are for customers and potential companies to fully utilize our curated data. 

---
Business Impact

Although the risk in expenditure to acquire this data is small, seeing as the data is free to be gathered on the TLC website, there are definite outside risks in this project as laws and competition grow, as well as the ever-worsening traffic crisis. We may not see as much interest in the business of yellow and green taxis as time continues, which would mean less interest in the data that we worked hard to produce. But the benefits to our company are worth the risk if we can sell any of the curated data, which would be a great benefit to our company in increasing our revenue. However, the best-case scenario would be if our data could better the taxi industry with further investments, increasing interest in the foreseeable future, and having more customers buy from us.

---
Business Persona

The people who will use this system are envisioned to be mainly investors. Investors who either live in or come from outside of New York and are interested in placing their funds into the taxi business. The requirements we have so far should give any user an idea of what the statistics are and help them decide whether or not to invest, whether they are knowledgeable of the NYC area or don't even live in it. Some organizations could be those developing transport applications and need access to this information, perhaps even the taxi company itself could utilize this curated data.

---
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

To make the data warehouse accessible to the team, an Azure database named `akhan00142` was created. You can find images of the database, including the key and screenshots from Azure, [here](https://github.com/arya0042/CIS-4400-Journey/blob/main/Database%20Images%20with%20key%20and%20azure.png).

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

Section 14: Read Green Taxi Data
```python
file_path_green_jan = r'C:\Users\khand\OneDrive\Desktop\STA 3000\january_green_taxidata.parquet'
file_path_green_feb = r'C:\Users\khand\OneDrive\Desktop\STA 3000\feburary_green_taxidata.parquet'
file_path_green_march = r'C:\Users\khand\OneDrive\Desktop\STA 3000\march_green_taxidata.parquet'

df_green_jan = pd.read_parquet(file_path_green_jan)
df_green_feb = pd.read_parquet(file_path_green_feb)
df_green_march = pd.read_parquet(file_path_green_march)
```
Reads green taxi data from three different Parquet files for January, February, and March and stores them in separate DataFrames.

Section 15: Read Weather Data
```python
weather_data = pd.read_csv('C:/Users/khand/OneDrive/Desktop/STA 3000/weather_data.csv', parse_dates=['datetime'])
```
Reads weather data from a CSV file and parses the 'datetime' column as dates.

Section 16: Specify Columns to Remove from Green Taxi Data
```python
columns_to_remove_green = [list of column names]
```
Specifies a list of columns that need to be removed from the green taxi data.

Section 17: Drop Specified Columns from Green Taxi Data
```python
df_green_jan = df_green_jan.drop(columns=columns_to_remove_green)
df_green_feb = df_green_feb.drop(columns=columns_to_remove_green)
df_green_march = df_green_march.drop(columns=columns_to_remove_green)
```
Drops specified columns from each green taxi DataFrame.

Section 18: Concatenate Green Taxi DataFrames Vertically
```python
df_green = pd.concat([df_green_jan, df_green_feb, df_green_march], ignore_index=True)
```
Concatenates the three green taxi DataFrames vertically, creating a combined DataFrame `df_green`.

Section 19: Rename the 'lpep_pickup_datetime' Column to 'tpep_pickup_datetime'
```python
df_green = df_green.rename(columns={'lpep_pickup_datetime': 'tpep_pickup_datetime'})
```
Renames the 'lpep_pickup_datetime' column to 'tpep_pickup_datetime' in the green taxi DataFrame.

Section 20: Add a New Column 'Taxi_Color' with Each Cell Filled with 'Green'
```python
df_green['Taxi_Color'] = 2
```
Adds a new column 'Taxi_Color' to `df_green` and fills each cell with the value 'Green' (represented as 2).

Section 21: Convert 'tpep_pickup_datetime' to Datetime Format
```python
df_green['tpep_pickup_datetime'] = pd.to_datetime(df_green['tpep_pickup_datetime'])
```
Converts the 'tpep_pickup_datetime' column in `df_green` to datetime format if it's not already.

Section 22: Define the Date Range for Green Taxi
```python
start_date_green = '2023-01-01'
end_date_green = '2023-03-31'
```
Specifies the start and end dates for the desired date range for green taxi data.

Section 23: Filter out Rows Outside the Specified Date Range for Green Taxi
```python
df_green = df_green[(df_green['tpep_pickup_datetime'] >= start_date_green) & (df_green['tpep_pickup_datetime'] <= end_date_green)]
```
Filters out rows in `df_green` that fall outside the specified date range.

Section 24: Reset the Index After Filtering for Green Taxi
```python
df_green.reset_index(drop=True, inplace=True)
```
Resets the index of `df_green` after filtering, dropping the old index.

Section 25: Add a New Column 'Taxi_Color' with Each Cell Filled with 'Green'
```python
df_green['Taxi_Color'] = 2
```
Adds a new column 'Taxi_Color' to `df_green` and fills each cell with the value 'Green' (represented as 2).

Section 26: Merge Green Taxi DataFrame with Location Information DataFrame
```python
df_green = pd.merge(df_green, location_info_df, left_on='PULocationID', right_on='LocationID', how='left')
```
Merges `df_green` with `location_info_df` based on the 'PULocationID' and 'LocationID' columns, using a left join.

Section 27: Drop Redundant Columns for Green Taxi
```python
df_green = df_green.drop(columns=['LocationID'])
```
Drops specified redundant columns from the merged green taxi DataFrame.

Section 28: Concatenate Yellow and Green Taxi DataFrames Vertically
```python
df_combined = pd.concat([df_yellow, df_green], ignore_index=True)
df_combined = df_combined.drop(columns=['service_zone'])
```
Concatenates the yellow and green taxi DataFrames vertically, creating a combined DataFrame `df_combined`. Drops the 'service_zone' column from the combined DataFrame.

Section 29: Remove Rows with PULocationID of Either 265 or 264
```python
df_combined = df_combined[(df_combined['PULocationID'] != 265) & (df_combined['PULocationID'] != 264)]
```
Removes rows in `df_combined` where the 'PULocationID' is either 265 or 264.

Section 30: Reset Index After Removing Rows
```python
df_combined.reset_index(drop=True, inplace=True)
```
Resets the index of `df_combined` after removing rows, dropping the old index.

Section 31: Display the First 10 Rows of the Combined DataFrame
```python
print(df_combined.head(10))
```
Displays the first 10 rows of the final combined DataFrame `df_combined`.
Section 32: Import Libraries
```python
import pandas as pd
from azure.storage.blob import BlobServiceClient, ContainerClient
from io import BytesIO
```
This section imports necessary libraries, including Pandas for data manipulation, Azure Storage Blob for interacting with Azure storage, and BytesIO for handling binary data.

Section 33: Azure Storage Account Details
```python
account_name = 'journeygroup'
account_key = '2MVcmcztJuQBAB2QkioYpHDfWwQbYgMK4dCxpM59RKa2nUU4TtMs7eoDSymhiSbYdc9aBoFAoqhW+ASte7GP7g=='
container_name = 'journeydata'
```
Defines the Azure Storage Account details, including the account name, account key, and container name.

Section 34: Save to CSV and Upload to Azure Storage Blob
```python
def save_to_csv_and_upload(data, csv_filename, blob_filename):
    # Save to CSV
    data.to_csv(csv_filename, index=False)

    # Upload to Azure Storage Blob
    upload_csv_to_blob(csv_filename, blob_filename)
```
Defines a function `save_to_csv_and_upload` that takes a DataFrame, saves it to a CSV file, and then uploads the CSV file to Azure Storage Blob.

Section 35: Upload CSV to Azure Storage Blob
```python
def upload_csv_to_blob(csv_filename, blob_filename):
    # Read CSV content
    with open(csv_filename, 'rb') as file:
        csv_bytes = file.read()

    # Create a connection to Azure Storage Blob
    blob_service_client = BlobServiceClient(account_url=f"https://{account_name}.blob.core.windows.net", credential=account_key)
    container_client = blob_service_client.get_container_client(container_name)
    blob_client = container_client.get_blob_client(blob_filename)

    # Upload the CSV file to Azure Storage Blob
    blob_client.upload_blob(csv_bytes, overwrite=True)

    print(f"File uploaded to Azure Storage Blob: {blob_filename}")
```
Defines a function `upload_csv_to_blob` that reads the content of a CSV file and uploads it to Azure Storage Blob.

Section 36: Save Location Table Data to CSV
```python
location_table = location_info_df[['LocationID', 'Borough', 'Zone']].copy()
location_table.columns = ['location_id', 'borough', 'zone']
save_to_csv_and_upload(location_table, 'LocationTable.csv', 'journeydata/LocationTable.csv')
```
Extracts location-related columns from `location_info_df`, renames the columns, and saves/upload this information as the Location Table.

Section 37: Save TaxiColor Table Data to CSV
```python
taxi_color_table = pd.DataFrame({'taxi_color_id': [1, 2], 'color_name': ['Yellow', 'Green']})
save_to_csv_and_upload(taxi_color_table, 'TaxiColorTable.csv', 'journeydata/TaxiColorTable.csv')
```
Creates a TaxiColor Table DataFrame and saves/upload it.

Section 38: Save DateInfo Table Data to CSV
```python
date_info_table = df_combined[['tpep_pickup_datetime']].copy()
date_info_table['tpep_pickup_datetime'] = pd.to_datetime(date_info_table['tpep_pickup_datetime']).dt.date
date_info_table = date_info_table.drop_duplicates().reset_index(drop=True)
date_info_table.reset_index(inplace=True)
date_info_table.columns = ['date_id', 'full_date']
save_to_csv_and_upload(date_info_table, 'DateInfoTable.csv', 'journeydata/DateInfoTable.csv')
```
Extracts date-related information from `df_combined`, processes it, and saves/upload it as the DateInfo Table.

Section 39: Save Trips Table Data to CSV
```python
trips_table = df_combined[['total_amount', 'Taxi_Color', 'PULocationID', 'tpep_pickup_datetime']].copy()
trips_table.columns = ['total_amount', 'taxi_color_id', 'location_id', 'full_date']
trips_table['full_date'] = pd.to_datetime(trips_table['full_date']).dt.date

# Assuming date_info_table is available, merge to get date_id
trips_table = pd.merge(trips_table, date_info_table, left_on='full_date', right_on='full_date', how='left')
trips_table = trips_table[['total_amount', 'taxi_color_id', 'location_id', 'date_id']]

# Add a new column 'trip_id' with sequential values starting from 1
trips_table['trip_id'] = range(1, len(trips_table) + 1)

# Reorder columns with 'trip_id' at the beginning
trips_table = trips_table[['trip_id', 'total_amount', 'taxi_color_id', 'location_id', 'date_id']]

save_to_csv_and_upload(trips_table, 'TripsTable.csv', 'journeydata/TripsTable.csv')
```
Processes the trips-related information from `df_combined`, merges it with date information, adds a sequential trip_id, and saves/upload it as the Trips Table.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

We employed Azure Data Factory to seamlessly transfer data from Azure Storage Blob to our designated tables. Leveraging the robust capabilities of Data Factory, we orchestrated an efficient data movement process, ensuring a smooth and reliable data flow. Once the data was successfully extracted, transformed, and loaded into our respective tables, we utilized Power BI to create insightful visualizations and reports. Power BI's intuitive interface and powerful analytical features facilitated our exploration and presentation of the data, allowing for a comprehensive understanding of key trends and patterns. This integrated approach, combining Azure Data Factory for data orchestration and Power BI for visualization, empowered us to derive meaningful insights from the stored information and make informed decisions based on the presented data.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Visualization**
We utilized Power BI to create Visualization
<img width="593" alt="Power Bi Visualization" src="https://github.com/arya0042/CIS-4400-Journey/assets/43891695/700eb080-eae2-4e08-9ac2-ba04e4802df1">


