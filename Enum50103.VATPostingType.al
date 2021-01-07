/*
50103 부가세 발행유형 enum type
2HC - KC
*/
enum 50103 "VAT Posting Type"
{
    Extensible = true;
    CaptionML = ENU='VAT Posting Type',KOR='부가세 발행유형';
    
    value(0; Journal)
    {
        CaptionML = ENU='Journal',KOR='분개장';
    }
    value(1; Document)
    {
        CaptionML = ENU='Document',KOR='문서';
    }
    value(2; Collective)
    {
        CaptionML = ENU='Collective',KOR='취합';
    }
    value(3; Manual)
    {
        CaptionML = ENU='Manual',KOR='수기';
    }
    
}
