[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "holidaydatacontainer_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "countryOrRegion", DestinationColumnName = "countryOrRegion"], [SourceColumnName = "holidayName", DestinationColumnName = "holidayName"], [SourceColumnName = "normalizeHolidayName", DestinationColumnName = "normalizeHolidayName"], [SourceColumnName = "isPaidTimeOff", DestinationColumnName = "isPaidTimeOff"], [SourceColumnName = "countryRegionCode", DestinationColumnName = "countryRegionCode"], [SourceColumnName = "date", DestinationColumnName = "date"]}], DynamicSchema = false, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared holidaydatacontainer = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = WorkspaceId]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = LakehouseId]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "holidaydatacontainer", ItemKind = "Table"]}[Data],
  #"Filtered rows" = Table.SelectRows(#"Navigation 2", each [countryOrRegion] = Region)
in
  #"Filtered rows";
shared WorkspaceId = let
    Source = Variable.ValueOrDefault("$(/**/dataflow-variables/WorkspaceId)", "Your Workspace ID")
in
    Source;
shared LakehouseId = let
    Source = Variable.ValueOrDefault("$(/**/dataflow-variables/LakehouseId)", "Your Lakehouse ID")
in
    Source;
shared Region = let
    Source = Variable.ValueOrDefault("$(/**/dataflow-variables/Region)", "Your Region"),
  Custom = Source
in
    Custom;
shared holidaydatacontainer_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = true, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "fc806946-335a-445e-babf-761f54e38f78"]}[Data],
  Navigation_2 = Navigation_1{[warehouseId = "adfa253d-1aae-469f-8d61-c1f388511dfb"]}[Data],
  Navigation_3 = Navigation_2{[Schema = "dbo"]}[Data],
  TableNavigation = Navigation_3{[Name = "holidaydatacontainer"]}?[Data]?
in
  TableNavigation;
