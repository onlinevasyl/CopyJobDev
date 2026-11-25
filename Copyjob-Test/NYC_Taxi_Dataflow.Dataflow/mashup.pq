[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared green_tripdata_2022 = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "fc806946-335a-445e-babf-761f54e38f78"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "6a339dfb-e199-4ce5-993a-82618a70b3f1"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "green_tripdata_2022", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"lpep_pickup_datetime", type datetime}}),
  #"Filtered rows" = Table.SelectRows(#"Changed column type", each ([store_and_fwd_flag] = "Y")),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Filtered rows", {{"lpep_pickup_datetime", type date}}),
  #"Filtered rows 1" = Table.SelectRows(#"Changed column type 1", each [lpep_pickup_datetime] >= #date(2022, 1, 1) and [lpep_pickup_datetime] <= #date(2022, 1, 31)),
  #"Filtered rows 2" = Table.SelectRows(#"Filtered rows 1", each [PULocationID] > PUlocationID)
in
  #"Filtered rows 2";
shared nyc_taxi_green_discounts = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "fc806946-335a-445e-babf-761f54e38f78"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "6a339dfb-e199-4ce5-993a-82618a70b3f1"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "nyc_taxi_green_discounts", ItemKind = "Table"]}[Data],
  #"Promoted headers" = Table.PromoteHeaders(#"Navigation 2", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"VendorID", Int64.Type}, {"2015-01-01", Int64.Type}, {"2015-01-02", Int64.Type}, {"2015-01-03", Int64.Type}, {"2015-01-04", Int64.Type}, {"2015-01-05", Int64.Type}, {"2015-01-06", Int64.Type}, {"2015-01-07", Int64.Type}, {"2015-01-08", Int64.Type}, {"2015-01-09", Int64.Type}, {"2015-01-10", Int64.Type}, {"2015-01-11", Int64.Type}, {"2015-01-12", Int64.Type}, {"2015-01-13", Int64.Type}, {"2015-01-14", Int64.Type}, {"2015-01-15", Int64.Type}, {"2015-01-16", Int64.Type}, {"2015-01-17", Int64.Type}, {"2015-01-18", Int64.Type}, {"2015-01-19", Int64.Type}, {"2015-01-20", Int64.Type}, {"2015-01-21", Int64.Type}, {"2015-01-22", Int64.Type}, {"2015-01-23", Int64.Type}, {"2015-01-24", Int64.Type}, {"2015-01-25", Int64.Type}, {"2015-01-26", Int64.Type}, {"2015-01-27", Int64.Type}, {"2015-01-28", Int64.Type}, {"2015-01-29", Int64.Type}, {"2015-01-30", Int64.Type}, {"2015-01-31", Int64.Type}}),
  #"Unpivoted other columns" = Table.UnpivotOtherColumns(#"Changed column type", {"VendorID"}, "Date", "Discount"),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Unpivoted other columns", {{"Date", type date}}),
  #"Divided column" = Table.TransformColumns(#"Changed column type 1", {{"Discount", each _ / 100, type number}})
in
  #"Divided column";
[BindToDefaultDestination = true]
shared Output = let
  Source = Table.NestedJoin(green_tripdata_2022, {"VendorID"}, nyc_taxi_green_discounts, {"VendorID"}, "nyc_taxi_green_discounts", JoinKind.LeftOuter),
  #"Expanded nyc_taxi_green_discounts" = Table.ExpandTableColumn(Source, "nyc_taxi_green_discounts", {"Date", "Discount"}, {"Date", "Discount"}),
  #"Added custom" = Table.TransformColumnTypes(Table.AddColumn(#"Expanded nyc_taxi_green_discounts", "TotalAfterDiscount", each if [tolls_amount] > 0 then [tolls_amount] * ( 1 - [Discount] ) else [tolls_amount]), {{"TotalAfterDiscount", Currency.Type}}),
  #"Inserted rounding" = Table.AddColumn(#"Added custom", "Inserted rounding", each Number.Round([TotalAfterDiscount], 2), type number),
  #"Changed column type" = Table.TransformColumnTypes(#"Inserted rounding", {{"lpep_pickup_datetime", type datetime}}),
  #"Choose columns" = Table.SelectColumns(#"Changed column type", {"VendorID", "lpep_pickup_datetime", "lpep_dropoff_datetime", "store_and_fwd_flag", "PULocationID", "DOLocationID", "passenger_count", "fare_amount", "extra", "mta_tax", "tip_amount", "tolls_amount", "ehail_fee", "improvement_surcharge", "total_amount", "payment_type", "trip_type", "congestion_surcharge", "source_file", "Date", "Discount", "TotalAfterDiscount", "Inserted rounding"}),
  #"Removed columns" = Table.RemoveColumns(#"Choose columns", {"passenger_count"}),
  #"Grouped rows" = Table.Group(#"Removed columns", {"VendorID", "lpep_pickup_datetime", "fare_amount"}, {{"Count", each List.Sum([tip_amount]), type nullable number}, {"File", each List.Count(List.Distinct([source_file])), Int64.Type}})
in
  #"Grouped rows";
shared PUlocationID = 244 meta [IsParameterQuery = true, IsParameterQueryRequired = false, Type = type number];
shared DefaultDestination = let
  Source = Lakehouse.Contents([HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true, CreateNavigationProperties = false, EnableFolding = false]),
  #"Navigation 1" = Source{[workspaceId = "fc806946-335a-445e-babf-761f54e38f78"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "6a339dfb-e199-4ce5-993a-82618a70b3f1"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "dbo", ItemKind = "Schema"]}[Data]
in
  #"Navigation 3";
