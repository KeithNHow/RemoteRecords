permissionset 51910 KNHRemoteRecords
{
    Assignable = true;
    Caption = 'Remote Records', MaxLength = 30;
    Permissions =
        table KNHDemo = X,
        tabledata KNHDemo = RMID,
        codeunit KNHJsonFunctions = X,
        page KNHDemoCard = X;
}