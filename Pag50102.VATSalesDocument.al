/*
부가세 매출 입력.
*/
page 50102 "VAT Sales Document"
{
    
    Caption = 'VAT Sales Document';
    PageType = Document;
    SourceTable = "VAT Ledger Entries";
    
    layout
    {
        area(content)
        {
            group(General)
            {
            }
        }
    }
    
}
