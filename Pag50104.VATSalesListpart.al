/*
매출 부가세 상세페이지.
*/
page 50104 "VAT Sales Listpart"
{
    
    Caption = 'VAT Sales Listpart';
    PageType = ListPart;
    SourceTable = "detailed VAT Ledger Entries";
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("VAT Document No."; Rec."VAT Document No.")
                {
                    ApplicationArea = All;
                }
                field("VAT Document Date"; Rec."VAT Document Date")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(Spec; Rec.Spec)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit price"; Rec."Unit price")
                {
                    ApplicationArea = All;
                }
                field("Actual Amount"; Rec."Actual Amount")
                {
                    ApplicationArea = All;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    
}
