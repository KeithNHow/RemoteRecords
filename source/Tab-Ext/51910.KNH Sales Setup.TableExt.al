/// <summary>
/// TableExtension KNH Sales Setup (ID 51910) extends Record Sales + Receivables Setup.
/// </summary>
tableextension 51910 "Sales Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "KNH Authentication Key"; Text[50])
        {
            Caption = 'Authentication Key';
            DataClassification = CustomerContent;
        }
        field(50101; "KNH Host Key"; Text[50])
        {
            Caption = 'Host Key';
            DataClassification = CustomerContent;
        }
    }
}
