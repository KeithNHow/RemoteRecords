permissionset 51910 KNHRemoteRecords
{
    Assignable = true;
    Caption = 'Remote Records', MaxLength = 30;
    Permissions =
        table KNHDemoAsset = X,
        tabledata KNHDemoAsset = RMID,
        codeunit KNHJsonFunctions = X,
        page KNHDemoAssetsCard = X;
}