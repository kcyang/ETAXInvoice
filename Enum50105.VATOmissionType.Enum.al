/*
50105 예정누락구분 - 카드매입과세시 필요함. enum type
2HC - KC
*/
enum 50105 "VAT Omission Type"
{
    Extensible = true;
    CaptionML = ENU= 'VAT Omission Type',KOR='예정누락 여부';

    value(0; "Without Omission")
    {
        CaptionML = ENU='Without Omission',KOR='예정누락아님';
    }
    value(1; Omission)
    {
        CaptionML = ENU='Omission',KOR='예정누락';
    }
    
}
