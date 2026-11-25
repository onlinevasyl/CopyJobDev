CREATE TABLE [dbo].[green_tripdata_2017] (
    [VendorID]              BIGINT         NULL,
    [lpep_pickup_datetime]  DATETIME2 (6)  NULL,
    [lpep_dropoff_datetime] DATETIME2 (6)  NULL,
    [store_and_fwd_flag]    VARCHAR (8000) NULL,
    [RatecodeID]            BIGINT         NULL,
    [PULocationID]          BIGINT         NULL,
    [DOLocationID]          BIGINT         NULL,
    [passenger_count]       BIGINT         NULL,
    [trip_distance]         FLOAT (53)     NULL,
    [fare_amount]           FLOAT (53)     NULL,
    [extra]                 FLOAT (53)     NULL,
    [mta_tax]               FLOAT (53)     NULL,
    [tip_amount]            FLOAT (53)     NULL,
    [tolls_amount]          FLOAT (53)     NULL,
    [ehail_fee]             FLOAT (53)     NULL,
    [improvement_surcharge] FLOAT (53)     NULL,
    [total_amount]          FLOAT (53)     NULL,
    [payment_type]          BIGINT         NULL,
    [trip_type]             BIGINT         NULL,
    [congestion_surcharge]  FLOAT (53)     NULL,
    [source_file]           VARCHAR (8000) NULL
);


GO