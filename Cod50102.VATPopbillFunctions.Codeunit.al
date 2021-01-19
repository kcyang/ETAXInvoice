/*
POPBILL 연동을 위한 기능을 구현합니다.
2021.01.07
- 비밀키(SecretKey) : D+sDN004PZoJb8v4B8/WKWLrqFV58mdx1U9T+fjuoxw=
- 링크아이디(LinkID) : 2HC

FIXME SDK 에서 Datamember 형식의 클래스들에 get,set 추가
TODO SDK 에서 제공하는 전자세금계산서 관련 procedure 를 모두 추가할 것.
*/
dotnet
{
    assembly(Popbill)
    {
        type(Popbill.Taxinvoice.TaxinvoiceService; TaxinvoiceService) { }
        type(Popbill.Taxinvoice.Taxinvoice; Taxinvoice) { }
        type(Popbill.Taxinvoice.TaxinvoiceDetail; TaxinvoiceDetail) { }
        type(Popbill.Taxinvoice.TaxinvoiceAddContact; TaxinvoiceAddContact) { }
        type(Popbill.IssueResponse; IssueResponse) { }
        type(Popbill.CorpInfo; CorpInfo) { }
        type(Popbill.Response; Response) { }
    }
    assembly(mscorlib)
    {
        type(System.String; dstr) { }
    }
}
codeunit 50102 VATPopbillFunctions
{
    procedure GetCorpInfo()
    var
        popbill: DotNet TaxinvoiceService;
        corpinfo: DotNet CorpInfo;
        response: DotNet Response;
        skey: DotNet dstr;
        linkid: DotNet dstr;
        corpid: DotNet dstr;
        corpreg: DotNet dstr;
    begin
        Clear(skey);
        Clear(linkid);
        Clear(popbill);
        Clear(corpinfo);
        Clear(corpid);
        Clear(corpreg);
        Clear(response);
        skey := 'D+sDN004PZoJb8v4B8/WKWLrqFV58mdx1U9T+fjuoxw=';
        linkid := '2HC';
        popbill := popbill.TaxinvoiceService(linkid, skey);

        popbill.IsTest := true;
        popbill.IPRestrictOnOff := true;

        //corpreg := '3578700926';
        //corpid := 'gncons';
        corpinfo := popbill.GetCorpInfo('7558800637', '');
        //corpinfo := popbill.GetCorpInfo('3578700926','gncons');
        
        Message('대표자:%1 \\ 상호:%2 \\ 주소:%3', corpinfo.ceoname,corpinfo.corpName,corpinfo.addr);
        
        

    end;


}
/*
        private string LinkID = "TESTER";

        // 비밀키
        private string SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I=";

        // 세금계산서 서비스 객체 선언
        private TaxinvoiceService taxinvoiceService;

        private const string CRLF = "\r\n";

        public frmExample()
        {
            InitializeComponent();

            // 세금계산서 서비스 객체 초기화
            taxinvoiceService = new TaxinvoiceService(LinkID, SecretKey);

            // 연동환경 설정값, 개발용(true), 상업용(false)
            taxinvoiceService.IsTest = true;

            // 발급된 토큰에 대한 IP 제한기능 사용여부, 권장(true)
            taxinvoiceService.IPRestrictOnOff = true;

            // 로컬PC 시간 사용 여부 true(사용), false(기본값) - 미사용
            taxinvoiceService.UseLocalTimeYN = false;
        }
*/
/*
            try
            {
                CorpInfo corpInfo = taxinvoiceService.GetCorpInfo(txtCorpNum.Text, txtUserId.Text);

                string tmp = null;
                tmp += "ceoname (대표자명) : " + corpInfo.ceoname + CRLF;
                tmp += "corpNamem (상호명) : " + corpInfo.corpName + CRLF;
                tmp += "addr (주소) : " + corpInfo.addr + CRLF;
                tmp += "bizType (업태) : " + corpInfo.bizType + CRLF;
                tmp += "bizClass (종목) : " + corpInfo.bizClass + CRLF;

                MessageBox.Show(tmp, "회사정보 조회");
            }
            catch (PopbillException ex)
            {
                MessageBox.Show("응답코드(code) : " + ex.code.ToString() + "\r\n" +
                                "응답메시지(message) : " + ex.Message, "회사정보 조회");
            }
*/
