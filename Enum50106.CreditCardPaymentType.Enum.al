/*
50106 신용카드결제유형. enum type
2HC - KC
*/
enum 50106 "Credit Card Payment Type"
{
    Extensible = true;
    CaptionML = ENU='Credit Card Payment Type',KOR='신용카드결제유형';
    
    value(0; General)
    {
        CaptionML = ENU='General',KOR='일반';
    }
    value(1; VAT)
    {
        CaptionML = ENU='VAT',KOR='과세';
    }
    value(2; "Non-VAT")
    {
        CaptionML = ENU='Non-VAT',KOR='면세';
    }
    
}
