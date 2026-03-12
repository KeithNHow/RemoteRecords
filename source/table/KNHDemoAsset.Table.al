/// <summary>
/// New table for demo, which will be used for API test. The OnValidate trigger of Id field is used to call JsonRead method in KNH Json Write codeunit, which will read the record and write to a json file in the server.
/// </summary>
table 51910 KNHDemoAsset
{
    Caption = 'Demo Table';
    DataClassification = CustomerContent;
    AllowInCustomizations = AsReadWrite;

    fields
    {
        field(1; Id; Code[20])
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                JsonWriteCU: Codeunit KNHJsonFunctions;
            begin
                JsonWriteCU.JsonRead();
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; Year; Integer)
        {
            Caption = 'Year';
            DataClassification = CustomerContent;
        }
        field(4; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
        }
        field(5; "CPU Model"; Text[50])
        {
            Caption = '';
            DataClassification = CustomerContent;
        }
        field(6; "Hard Disk Size"; Text[50])
        {
            Caption = 'Hard Disk Size';
            DataClassification = CustomerContent;
        }
        field(7; Colour; Text[20])
        {
            Caption = 'Colour';
            DataClassification = CustomerContent;
        }
        field(8; Capacity; Text[20])
        {
            Caption = 'Capacity';
            DataClassification = CustomerContent;
        }
        field(9; Generation; Text[30])
        {
            Caption = 'Generation';
            DataClassification = CustomerContent;
        }
        field(10; "Case Size"; Text[20])
        {
            Caption = 'Case Size';
            DataClassification = CustomerContent;
        }
        field(11; Description; Text[20])
        {
            Caption = 'Description';
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