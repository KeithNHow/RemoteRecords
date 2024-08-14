/// <summary>
/// Permissions "KNH RemoteRecords" (ID 50100).
/// </summary>
permissionset 51910 "KNH RemoteRecords"
{
    Assignable = true;
    Caption = 'Remote Records', MaxLength = 30;
    Permissions =
        table "KNH Demo" = X,
        tabledata "KNH Demo" = RMID,
        codeunit "KNH Json Write" = X,
        Page "KNH Demo Card" = X;
}