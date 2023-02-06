/// <summary>
/// Page KNH API Table Card (ID 51910).
/// </summary>
page 51910 "KNH API Table Card"
{
    Caption = 'API Table Card';
    PageType = Card;
    SourceTable = "API Table";
    UsageCategory = Lists;
    ApplicationArea = All;
    AboutText = 'With this test API page you import records into D365 Business Central.';
    AboutTitle = 'About API Table Card';

    layout
    {
        area(content)
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
                field("Original Text"; Rec."Original Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the text to be translated.';
                }
                field("Translated Text"; Rec."Translated Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the translated text.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CreateJson)
            {
                Caption = 'Download Sample Json';
                ToolTip = 'Create a download sample json file.';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    JsonWriteCU: Codeunit JsonWrite;
                    ConfirmMsg: label 'Do you want to download the json file?';
                    ElseMsg: label 'No Problem, Try next time.';
                begin
                    if Confirm(ConfirmMsg, false) then
                        JsonWriteCU.Run()
                    else
                        Message(ElseMsg);
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
                    JsonWriteCU: Codeunit JsonWrite;
                begin
                    JsonWriteCU.APIConnect();
                end;
            }
        }
    }
}
