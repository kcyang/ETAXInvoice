codeunit 50103 PopbillCallback
{
    procedure Ping():Text
    begin
        exit('퐁');
    end;

    procedure Callback(ntsconfirmNum: Text;itemKey: Text;stateCode:Integer;corpNum:Text;stateDT:Text;invoicerMgtKey:Text;eventDT:Text;eventType:Text;stateMemo:Text/*;closeDownState:Integer;ntssendDT:Text*/):Text
    begin
        exit('OK');
    end;

/*
//TODO API 생성후, 테스트할 것.
 발행	
 {
"itemKey": "018081413254200001",
"stateCode": 300,
"corpNum": "6798700433",
"stateDT": "20180814132542",
"invoicerMgtKey": "20180814-03",
"eventDT": "20180814132542",
"eventType": "Issue",
"ntsconfirmNum": "20180814888888880000000f",
"stateMemo": "즉시발행 메모"
}
국세청처리.
{
"invoicerMgtKey": "df3452345",
"stateDT": "20200303174041",
"eventType": "NTS",
"closeDownState": 0,
"itemKey": "020030310220500001",
"ntsconfirmNum": "20200303888888880000007f",
"corpNum": "1234567890",
"ntssendDT": "20200303174050",
"stateCode": 303,
"eventDT": "20200303174050"
}
*/
}