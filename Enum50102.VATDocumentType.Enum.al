/*
50102 계산서 유형 enum type
2HC - KC
*/
enum 50102 "VAT Document Type"
{
    Extensible = true;
    CaptionML = ENU='VAT Document Type',KOR='계산서 유형';
    
    value(0; General)
    {
        CaptionML = ENU='General',KOR='일반';
    }
    value(1; Correction)
    {
        CaptionML = ENU='Correction',KOR='수정';
    }
    
}
