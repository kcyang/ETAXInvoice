/*
국세청 연동 및 전송상태 코드.
*/
enum 50116 "ETAX Status"
{
    Extensible = true;
    value(100; "Temporary Save")
    {
        CaptionML = ENU='Temporary Save',KOR='임시 저장';
    }
    value(200; "Awaiting")
    {
        CaptionML = ENU='Awaiting',KOR='발행 대기';
    }
    value(300; "Issue Registered")
    {
        CaptionML = ENU='Issue Registered',KOR='발행 등록완료';
    }
    value(301; "Before Sending")
    {
        CaptionML = ENU='Before Sending',KOR='국세청 전송전';
    }
    value(302; "Await Sending")
    {
        CaptionML = ENU='Await Sending',KOR='국세청 전송대기';
    }
    value(303; "Sending")
    {
        CaptionML = ENU='Sending',KOR='국세청 전송중';
    }
    value(304; "Successfully Sent")
    {
        CaptionML = ENU='Successfully Sent',KOR='국세청 전송완료';
    }
    value(305; "Sending Failed")
    {
        CaptionML = ENU='Sending Failed',KOR='국세청 전송실패';
    }
    value(400; "Refused")
    {
        CaptionML = ENU='Refused',KOR='거부';
    }
    value(500; "Canceled")
    {
        CaptionML = ENU='Canceled',KOR='취소';
    }
    value(600; "Issue Canceled")
    {
        CaptionML = ENU='Issue Canceled',KOR='발행 취소';
    }        

}
