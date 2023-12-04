# CIS-4400-Journey

**Who we are**

![Screenshot 2023-12-04 182135](https://github.com/arya0042/CIS-4400-Journey/assets/145073688/1c922fdf-c6b7-4ee3-bf31-5f71fff90b02)

We are *Journey*, a Data Collection 


Data Sourcing
For the NYC taxi analysis project, spanning January to March 2023, data is sourced from the TLC website for taxi trip records and the Visual Crossing API for weather data. The TLC dataset, organized in monthly Parquet files, is securely stored in Microsoft Azure Storage Blob ('aryanstorage2' account, 'journeydata' container). The Python code efficiently uploads files, maintaining a clear dataset structure.

The weather data, fetched through the Visual Crossing API, is locally saved as 'weather_data.csv.' This dual-data approach combines taxi trip details and weather information, enriching the project's depth. For comprehensive understanding, Yellow and Green taxi data dictionaries are referenced. The Yellow Taxi Data Dictionary is available [here](https://github.com/arya0042/CIS-4400-Journey/blob/main/Yellow%20Taxi%20Data%20Dictionary), and the Green Taxi Data Dictionary is accessible [here](https://github.com/arya0042/CIS-4400-Journey/blob/main/Green%20Taxi%20Data%20Dictionary).

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

Access to the visualization file can be found [here](https://drive.google.com/file/d/1mff8vnrWLopUcI3tw_Wb_p_5kFnL5WrU/view?usp=sharing)
