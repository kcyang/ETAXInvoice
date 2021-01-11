/*
부가세 매입 입력.
*/
page 50103 "VAT Purchase Document"
{
    
    Caption = 'VAT Purchase Document';
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
