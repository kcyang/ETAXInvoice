enum 50109 "VAT Regist Type"
{
    Extensible = true;
    CaptionML = ENU='VAT Regist Type',KOR='부가세 등록유형';
    
    value(0; "By Invoice")
    {
        CaptionML = ENU='By Invoice',KOR='건별';
    }
    value(1; "Collective Invoice")
    {
        CaptionML = ENU='Collective Invoice',KOR='기간별';
    }
    
}
