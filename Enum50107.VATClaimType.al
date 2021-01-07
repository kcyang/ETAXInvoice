enum 50107 "VAT Claim Type"
{
    Extensible = true;
    CaptionML = ENU='VAT Claim Type',KOR='부가세 청구유형';
    
    value(0; Claim)
    {
        CaptionML = ENU='Claim',KOR='청구';
    }
    value(1; Receipt)
    {
        CaptionML = ENU='Receipt',KOR='영수';
    }
    value(2; None)
    {
        CaptionML = ENU='None',KOR='없음';
    }
    
}
