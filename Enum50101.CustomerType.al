/*
50101 사업자 구분 enum type
2HC - KC
*/
enum 50101 "Customer Type"
{
    Extensible = true;
    CaptionML = ENU='Customer Type',KOR='사업자 구분';
    
    value(0; Corporate)
    {
        CaptionML = ENU='Corporate',KOR='법인';
    }
    value(1; Personal)
    {
        CaptionML = ENU='Personal',KOR='개인';
    }
    
}
