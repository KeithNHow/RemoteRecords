/// <summary>
/// This card page is used to test API connection and to create a Json file, based on the KNHDemo table. 
/// The page has two actions, one for creating a Json file and another for testing the Http connection.
/// </summary>
page 51910 KNHDemoCard
{
    Caption = 'Demo API page';
    PageType = Card;
    SourceTable = KNHDemo;
    UsageCategory = Lists;
    ApplicationArea = All;
    AboutText = 'With this Demo API page you can import records. Test the API connection and download a sample Json file. The Json file is based on the first record of the Customer table.';
    AboutTitle = 'About Demo API page';

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
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Code field.';
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
                Caption = 'Import Json to Demo record';
                ToolTip = 'Import a json record from a file.';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    JsonWriteCU: Codeunit KNHJsonFunctions;
                    ConfirmMsg: Label 'Do you want to download the json file?';
                    NoConfirmMsg: Label 'No Problem, Try next time.';
                begin
                    if Confirm(ConfirmMsg, false) then
                        JsonWriteCU.Run()
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
