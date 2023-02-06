/// <summary>
/// Permissions "KNH RemoteRecords" (ID 50100).
/// </summary>
permissionset 51910 RemoteRecords
{
    Assignable = true;
    Caption = 'Remote Records', MaxLength = 30;
    Permissions =
        table "API Table" = X,
        tabledata "API Table" = RMID,
        codeunit JsonWrite = X,
        codeunit "Translate API" = X;
}