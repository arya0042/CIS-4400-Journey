-- Dimension Table: Location
CREATE TABLE Location (
    location_id INT PRIMARY KEY,
    borough VARCHAR(255) NOT NULL,
    zone VARCHAR(255) NOT NULL
);

-- Dimension Table: TaxiColor
CREATE TABLE TaxiColor (
    taxi_color_id INT PRIMARY KEY,
    color_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE DateInfo (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL
);


-- Fact Table: Trips
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
-- Modify tempmax column to be NOT NULL
ALTER TABLE DateInfo
ALTER COLUMN tempmax DECIMAL NOT NULL;
