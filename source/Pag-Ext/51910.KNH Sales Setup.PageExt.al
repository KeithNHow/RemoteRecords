/// <summary>
/// PageExtension KNH Sales Setup (ID 51910) extends Record Sales + Receivables Setup.
/// </summary>
pageextension 51910 "Sales Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("KNH Authentication Key"; Rec."KNH Authentication Key")
            {
                ApplicationArea = All;
                ToolTip = 'Authentication Key';
            }
            field("KNH Host Key"; Rec."KNH Host Key")
            {
                ApplicationArea = All;
                ToolTip = 'Host Key';
            }
        }
    }
}
