enum 50111 "Related Document Name"
{
    Extensible = true;
    CaptionML = ENU='Related Document Name',KOR='관련서류명';
    
    value(0; " ")
    {
        CaptionML = ENU=' ',KOR=' ';
    }
    value(1; ExportPermit)
    {
        CaptionML = ENU='ExportPermit',KOR='수출신고필증';
    }
    value(2; Invoice)
    {
        CaptionML = ENU='Invoice',KOR='인보이스';
    }
    value(3; Certificate)
    {
        CaptionML = ENU='Certificate',KOR='외국환매입증명서';
    }
    value(4; LC)
    {
        CaptionML = ENU='LC',KOR='내국신용장';
    }
    value(5; Approval)
    {
        CaptionML = ENU='Approval',KOR='구매확인서';
    }
    value(6; CurrCertificate)
    {
        CaptionML = ENU='CurrCertificate',KOR='외화입금증명서';
    }
    
}
