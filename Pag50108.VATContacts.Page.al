page 50108 "VAT Contacts"
{
    DelayedInsert = true;
    Caption = 'VAT Contacts';
    PageType = List;
    SourceTable = "TAXInvoice Contacts";
    AutoSplitKey = true;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = All;
                }
                field("Contact CellPhone"; Rec."Contact CellPhone")
                {
                    ApplicationArea = All;
                }
                field("Contact Email"; Rec."Contact Email")
                {
                    ApplicationArea = All;
                }
                field("Contact Dept"; Rec."Contact Dept")
                {
                    Visible = false;
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Contact Fax"; Rec."Contact Fax")
                {
                    Visible = false;
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Contact Phone"; Rec."Contact Phone")
                {
                    Visible = false;
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    Visible = false;
                    Importance = Additional;
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Account Type"; Rec."Account Type")
                {
                    Visible = false;
                    Importance = Additional;
                    ApplicationArea = All;
                    Enabled = false;
                }
            }
        }
    }
    
}
