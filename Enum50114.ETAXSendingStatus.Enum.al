enum 50114 "ETAX Sending Status"
{
    Extensible = true;
    CaptionML = ENU='ETAX Sending Status',KOR='국세청 전송상태';
    value(0; "-")
    {
        CaptionML = ENU='-',KOR='-';
    }
    value(1; "Before Issue")
    {
        CaptionML = ENU='Before Issue',KOR='전송전';
    }
    value(2; Pending)
    {
        CaptionML = ENU='Pending',KOR='전송대기';
    }
    value(3; Issuing)
    {
        CaptionML = ENU='Issuing',KOR='전송중';
    }
    value(4; Succeed)
    {
        CaptionML = ENU='Succeed',KOR='전송성공';
    }
    value(5; Failed)
    {
        CaptionML = ENU='Failed',KOR='전송실패';
    }
    
}
