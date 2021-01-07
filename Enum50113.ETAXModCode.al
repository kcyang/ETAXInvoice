enum 50113 "ETAX Mod Code"
{
    Extensible = true;
    CaptionML = ENU='ETAX Amended Tax Invoice Code',KOR='수정세금계산서 사유코드';
    
    value(0; "1")
    {
        CaptionML = ENU='기재사항 착오정정',KOR='기재사항 착오정정';
    }
    value(1; "2")
    {
        CaptionML = ENU='공급가액 변동',KOR='공급가액 변동';
    }
    value(2; "3")
    {
        CaptionML = ENU='환입',KOR='환입';
    }
    value(3; "4")
    {
        CaptionML = ENU='계약의 해제',KOR='계약의 해제';
    }
    value(4; "5")
    {
        CaptionML = ENU='내국신용장 사후개설',KOR='내국신용장 사후개설';
    }
    value(5; "6")
    {
        CaptionML = ENU='착오에 의한 이중발급',KOR='착오에 의한 이중발급';
    }
    
}
