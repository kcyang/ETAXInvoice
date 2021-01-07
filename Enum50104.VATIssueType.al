/*
50104 부가세 매출입 구분 enum type
2HC - KC
*/
enum 50104 "VAT Issue Type"
{
    Extensible = true;
    CaptionML = ENU='VAT Type',KOR='매출입 구분';
    
    value(0; Purchase)
    {
        CaptionML = ENU='Purchase',KOR='매입';
    }
    value(1; Sales)
    {
        CaptionML = ENU='Sales',KOR='매출';
    }
    
}
