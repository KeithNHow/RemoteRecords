/// <summary>
/// Permissions "KNH RemoteRecords" (ID 50100).
/// </summary>
permissionset 51910 "KNH_RemoteRecords"
{
    Assignable = true;
    Caption = 'Remote Records', MaxLength = 30;
    Permissions =
        table "KNHAPI_Table" = X,
        tabledata "KNHAPI_Table" = RMID,
        codeunit KNHJsonWrite = X,
        Page KNHAPI_Table_Card = X;
}