enum 50117 "Statement Status"
{
    Extensible = true;
    
    value(100; "Saved")
    {
        CaptionML = ENU='Saved',KOR='임시저장';
    }
    value(200; "Approval Pending")
    {
        CaptionML = ENU='Approval Pending',KOR='승인대기';
    }
    value(300; "Issued")
    {
        CaptionML = ENU='Issued',KOR='발행완료';
    }
    value(400; "Rejected")
    {
        CaptionML = ENU='Rejected',KOR='승인거부';
    }
    value(500; "Canceled")
    {
        CaptionML = ENU='Canceled',KOR='취소';
    }
    value(600; "Issue Canceled")
    {
        CaptionML = ENU='Issue Canceled',KOR='발행취소';
    }
    value(900; "Cancellation Request")
    {
        CaptionML = ENU='Cancellation Request',KOR='발행취소요청';
    }    
    
}
