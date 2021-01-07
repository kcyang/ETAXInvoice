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
        CaptionML = ENU='Corporate Business',KOR='법인사업자';
    }
    value(1; Individual)
    {
        CaptionML = ENU='Individual Business',KOR='개인사업자';
    }
    value(2; Personal)
    {
        CaptionML = ENU='Personal',KOR='개인';
    }

    
}
