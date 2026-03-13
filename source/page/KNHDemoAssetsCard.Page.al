/// <summary>
/// This card page is used to test API connection and to create a Json file, based on the KNHDemo table. 
/// The page has two actions, one for creating a Json file and another for testing the Http connection.
/// </summary>
page 51910 KNHDemoAssetsCard
{
    Caption = 'Demo Assets Card';
    DataCaptionFields = Id, Name;
    PageType = Card;
    SourceTable = KNHDemoAsset;
    UsageCategory = Lists;
    ApplicationArea = All;

    Editable = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Id field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("CPU Model"; Rec."CPU Model")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CPU Model field.';
                }
                field("Hard Disk Size"; Rec."Hard Disk Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ExportJson)
            {
                Caption = 'Export Customer to Json';
                ToolTip = 'Export customer details to a json file.';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    JsonWriteCU: Codeunit KNHJsonFunctions;
                    ConfirmMsg: Label 'Do you want to download customer details to a json file?';
                    NoConfirmMsg: Label 'No Problem, Try next time.';
                begin
                    if Confirm(ConfirmMsg, false) then
                        JsonWriteCU.JsonExport()
                    else
                        Message(NoConfirmMsg);
                end;
            }
            action(ImportJson)
            {
                Caption = 'Import Json to Demo';
                ToolTip = 'Import a Json record from a file.';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    JsonFunctions: Codeunit KNHJsonFunctions;
                    ConfirmMsg: Label 'Do you want to import the json record?';
                    NoConfirmMsg: Label 'No Problem, Try next time.';
                begin
                    if Confirm(ConfirmMsg, false) then
                        JsonFunctions.JsonRead()
                    else
                        Message(NoConfirmMsg);
                end;
            }
            action(HttpConnect)
            {
                Caption = 'Http Connect';
                ToolTip = 'View json file on http site.';
                Image = View;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    JsonWriteCU: Codeunit KNHJsonFunctions;
                begin
                    JsonWriteCU.HttpTest();
                end;
            }
        }
    }
}
