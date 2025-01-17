/// <summary>
/// Table KNH API Table (ID 51910).
/// </summary>
table 51910 "KNH Demo"
{
    Caption = 'API Table';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                JsonWriteCU: Codeunit "KNH Json Write";
            begin
                JsonWriteCU.JsonRead(Rec);
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; "User Name"; Text[50])
        {
            Caption = 'User Name';
            DataClassification = CustomerContent;
        }
        field(4; Email; Text[100])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
        }
        field(8; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
        }
        field(9; Latitude; Text[30])
        {
            Caption = 'Latitude';
            DataClassification = CustomerContent;
        }
        field(10; Longtitude; Text[30])
        {
            Caption = 'Longtitude';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}