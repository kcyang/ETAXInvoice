/*
50100 세금계산서 발행유형 enum type
2HC - KC
*/
enum 50100 "VAT Type"
{
    Extensible = true;
    CaptionML = ENU='VAT Type',KOR='세금계산서 발행유형';
    
    value(0; Line)
    {
        CaptionML = ENU='Line',KOR='건별';
    }
    value(1; Period)
    {
        CaptionML = ENU='Period',KOR='기간별';
    }    
}
