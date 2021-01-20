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
        type("System.Collections.Generic.List`1"; dlist) {}
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

    //세금계산서를 즉시발행.
    procedure RegistIssue()
    var
        popbill: DotNet TaxinvoiceService;
        taxinvoice: DotNet Taxinvoice;
        taxinvoicedetail: DotNet TaxinvoiceDetail;
        response: DotNet IssueResponse;
        skey: DotNet dstr;
        linkid: DotNet dstr;
        listOfTaxdetailList: DotNet dlist;
    begin
        //0. dotnet initialize
        Clear(skey);
        Clear(linkid);
        Clear(popbill);
        Clear(response);
        Clear(taxinvoice);
        Clear(taxinvoicedetail);
        Clear(listOfTaxdetailList);
        skey := 'D+sDN004PZoJb8v4B8/WKWLrqFV58mdx1U9T+fjuoxw=';
        linkid := '2HC';
        popbill := popbill.TaxinvoiceService(linkid, skey);

        popbill.IsTest := true;
        popbill.IPRestrictOnOff := true;        

        //popbill testing. START...
        taxinvoice := taxinvoice.Taxinvoice();
        // [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
        taxinvoice.writeDate := '20210120';
        // [필수] 과금방향, {정과금, 역과금}중 선택
        // - 정과금(공급자과금), 역과금(공급받는자과금)
        // - 역과금은 역발행 세금계산서를 발행하는 경우만 가능        
        taxinvoice.chargeDirection := '정과금';
        // [필수] 발행형태, {정발행, 역발행, 위수탁} 중 기재 
        taxinvoice.issueType := '정발행';
        // [필수] {영수, 청구} 중 기재
        taxinvoice.purposeType := '청구';
        // [필수] 과세형태, {과세, 영세, 면세} 중 기재
        taxinvoice.taxType := '과세';

        /*****************************************************************
        *                         공급자 정보                             *
        *****************************************************************/

        // [필수] 공급자 사업자번호, '-' 제외 10자리
        taxinvoice.invoicerCorpNum := '7558800637'; //공급자사업자번호.

        // 공급자 종사업자 식별번호. 필요시 기재. 형식은 숫자 4자리.
        taxinvoice.invoicerTaxRegID := '';

        // [필수] 공급자 상호
        taxinvoice.invoicerCorpName := '(주)투에이치컨설팅';

        // [필수] 공급자 문서번호, 숫자, 영문, '-', '_' 조합으로 1~24자리까지 사업자번호별 중복없는 고유번호 할당
        taxinvoice.invoicerMgtKey := 'VAT0000001';

        // [필수] 공급자 대표자 성명
        taxinvoice.invoicerCEOName := '한주영';

        // 공급자 주소 
        taxinvoice.invoicerAddr := '';
        // 공급자 종목
        taxinvoice.invoicerBizClass := '';
        // 공급자 업태
        taxinvoice.invoicerBizType := '';
        // 공급자 담당자 성명 
        taxinvoice.invoicerContactName := '';
        // 공급자 담당자 메일주소
        taxinvoice.invoicerEmail := '';
        // 공급자 담당자 연락처
        taxinvoice.invoicerTEL := '';
        // 공급자 담당자 휴대폰번호
        taxinvoice.invoicerHP := '';
        // 발행시 알림문자 전송여부
        // - 공급받는자 담당자 휴대폰번호(invoiceeHP1)로 전송
        taxinvoice.invoicerSMSSendYN := false;

        /*********************************************************************
        *                         공급받는자 정보                              *
        *********************************************************************/
        // [필수] 공급받는자 구분, {사업자, 개인, 외국인} 중 기재 
        taxinvoice.invoiceeType := '사업자';

        // [필수] 공급받는자 사업자번호, '-'제외 10자리
        taxinvoice.invoiceeCorpNum := '3578700926';

        // [필수] 공급받는자 상호
        taxinvoice.invoiceeCorpName := '주식회사 지앤컨설팅';

        // [역발행시 필수] 공급받는자 문서번호, 숫자, 영문, '-', '_' 조합으로 1~24자리까지 사업자번호별 중복없는 고유번호 할당
        taxinvoice.invoiceeMgtKey := '';

        // [필수] 공급받는자 대표자 성명 
        taxinvoice.invoiceeCEOName := '양광철';

        // 공급받는자 주소 
        taxinvoice.invoiceeAddr := '';

        // 공급받는자 종목
        taxinvoice.invoiceeBizClass := '';

        // 공급받는자 업태 
        taxinvoice.invoiceeBizType := '';

        // 공급받는자 담당자 연락처
        taxinvoice.invoiceeTEL1 := '';

        // 공급받는자 담당자명 
        taxinvoice.invoiceeContactName1 := '';

        // 공급받는자 담당자 메일주소 
        // 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
        // 실제 거래처의 메일주소가 기재되지 않도록 주의
        taxinvoice.invoiceeEmail1 := 'kc.yang@2hc.co.kr';

        // 공급받는자 담당자 휴대폰번호 
        taxinvoice.invoiceeHP1 := '010-8732-4043';

        // 역발행시 알림문자 전송여부 
        taxinvoice.invoiceeSMSSendYN := false;

        /*********************************************************************
        *                          세금계산서 정보                          *
        *********************************************************************/

        // [필수] 공급가액 합계
        taxinvoice.supplyCostTotal := '100000';

        // [필수] 세액 합계
        taxinvoice.taxTotal := '10000';

        // [필수] 합계금액,  공급가액 합계 + 세액 합계
        taxinvoice.totalAmount := '110000';

        // 기재상 일련번호 항목 
        taxinvoice.serialNum := '123';

        // 기재상 현금 항목 
        taxinvoice.cash := '';

        // 기재상 수표 항목
        taxinvoice.chkBill := '';

        // 기재상 어음 항목
        taxinvoice.note := '';

        // 기재상 외상미수금 항목
        taxinvoice.credit := '';

        // 기재상 비고 항목
        taxinvoice.remark1 := '비고1';
        taxinvoice.remark2 := '비고2';
        taxinvoice.remark3 := '비고3';

        // 기재상 권 항목, 최대값 32767
        // 미기재시 taxinvoice.kwon := null;
        taxinvoice.kwon := 1;

        // 기재상 호 항목, 최대값 32767
        // 미기재시 taxinvoice.ho := null;
        taxinvoice.ho := 1;


        // 사업자등록증 이미지 첨부여부
        taxinvoice.businessLicenseYN := false;

        // 통장사본 이미지 첨부여부 
        taxinvoice.bankBookYN := false;

        /**************************************************************************
            *        수정세금계산서 정보 (수정세금계산서 작성시에만 기재             *
            * - 수정세금계산서 관련 정보는 연동매뉴얼 또는 개발가이드 링크 참조      *
            * - [참고] 수정세금계산서 작성방법 안내 - http://blog.linkhub.co.kr/650  *
            *************************************************************************/

        // 수정사유코드, 1~6까지 선택기재.
        //taxinvoice.modifyCode := 0;

        // 수정세금계산서 작성시 원본세금계산서의 국세청승인번호
        taxinvoice.orgNTSConfirmNum := '';

        taxinvoicedetail := taxinvoicedetail.TaxinvoiceDetail();
        taxinvoicedetail.serialNum := 1;
        taxinvoicedetail.purchaseDT := '20210120';
        taxinvoicedetail.itemName := '';
        taxinvoicedetail.spec := '';
        taxinvoicedetail.qty := '';
        taxinvoicedetail.unitCost := '';
        taxinvoicedetail.supplyCost := '';
        taxinvoicedetail.tax := '';
        taxinvoicedetail.remark := '';

        //taxinvoice.AddTaxDetail(taxinvoicedetail);

        //response := popbill.RegistIssue('',taxinvoice,false,'',false,'','');
        response := popbill.RegistOneIssue('7558800637',taxinvoice,
            taxinvoicedetail.serialNum,
            taxinvoicedetail.purchaseDT,
            taxinvoicedetail.itemName,
            taxinvoicedetail.spec,
            taxinvoicedetail.qty,
            taxinvoicedetail.unitCost,
            taxinvoicedetail.supplyCost,
            taxinvoicedetail.tax,
            taxinvoicedetail.remark,
            false,'',false,'','');

        Message('응답코드:%1 \ 응답메시지 %2 \ 국세청승인번호 %3',response.code,response.message,response.ntsConfirmNum);

        //popbill testing. END...


        //1. 넘어온 키/레코드에 대한 값 체크.
        //2. 키/레코드에 대한 필요한 값 체크.
        //3. 필요한 값 셋업.
        //4. popbill 연동.
        //5. 결과값 받기.
        //6. 넘어온 키/레코드에 관련 값 업데이트.
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
