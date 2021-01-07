enum 50112 "ETAX Document Status"
{
    Extensible = true;
    CaptionML = ENU='ETaX Document Status',KOR='전자세금계산서 문서상태';
    
    value(0; Saved)
    {
        CaptionML = ENU='Saved',KOR='임시저장';
    }
    value(1; Issued)
    {
        CaptionML = ENU='Issued',KOR='발행완료';
    }
    value(2; Canceled)
    {
        CaptionML = ENU='Canceled',KOR='발행취소';
    }
    
}
