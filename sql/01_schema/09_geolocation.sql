/*
===============================================================================
Table        : geolocation
Description  : Stores geographic information for Brazilian ZIP code prefixes,
               including latitude, longitude, city, and state.
Source File  : olist_geolocation_dataset.csv
Dependencies : None
===============================================================================
*/

CREATE TABLE geolocation
(
    geolocation_zip_code_prefix INTEGER NOT NULL,
    geolocation_lat DECIMAL(10,8) NOT NULL,
    geolocation_lng DECIMAL(11,8) NOT NULL,
    geolocation_city VARCHAR(50) NOT NULL,
    geolocation_state CHAR(2) NOT NULL
);

-- Constraints

-- Notes