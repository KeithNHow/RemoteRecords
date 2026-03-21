namespace KNHRemoteRecords;
using Microsoft.Foundation.Attachment;

page 51911 KNHDemoAssetsList
{
    ApplicationArea = Basic, Suite;
    Caption = 'Demo Assets List';
    CardPageId = KNHDemoAssetsCard;
    Editable = false;
    PageType = List;
    QueryCategory = 'Demo Assets List';
    SourceTable = KNHDemoAsset;
    UsageCategory = Lists;
    AdditionalSearchTerms = 'Demo Assets';
    AboutTitle = 'About Demo page';
    AboutText = 'With this Demo page you can import records. Test the API connection and download a sample Json file. The Json file is based on the first record of the Customer table.';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
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
        area(FactBoxes)
        {
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::KNHDemoAsset),
                              "No." = field(Id);
                Visible = not this.IsOfficeAddin;
            }
        }
    }
    var
        IsOfficeAddin: Boolean;
}