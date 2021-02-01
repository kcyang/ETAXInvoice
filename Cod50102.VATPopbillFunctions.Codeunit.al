/*
POPBILL 연동을 위한 기능을 구현합니다.
2021.01.07
- 비밀키(SecretKey) : D+sDN004PZoJb8v4B8/WKWLrqFV58mdx1U9T+fjuoxw=
- 링크아이디(LinkID) : 2HC

TODO !!!역발행 처리. (맨 마지막에.)
TODO SDK 에서 제공하는 전자세금계산서 관련 procedure 를 모두 추가할 것.
TODO 상세내역이 여러건인 경우 처리 필요.
*/
dotnet
{
    assembly(Popbill)
    {
        type(Popbill.Taxinvoice.TaxinvoiceService; TaxinvoiceService) { }
        type(Popbill.Taxinvoice.Taxinvoice; Taxinvoice) { }
        type(Popbill.Taxinvoice.TaxinvoiceInfo; TaxinvoiceInfo) {}
        type(Popbill.Taxinvoice.TaxinvoiceDetail; TaxinvoiceDetail) { }
        type(Popbill.Taxinvoice.TaxinvoiceAddContact; TaxinvoiceAddContact) { }
        
        type(Popbill.IssueResponse; IssueResponse) { }
        type(Popbill.CorpInfo; CorpInfo) { }
        type(Popbill.Response; Response) { }
        type(Popbill.Taxinvoice.MgtKeyType; TaxIvnoiceMgtKeyType) { }
    }
    assembly(mscorlib)
    {
        type(System.String; dstr) { }
        type("System.Collections.Generic.List`1"; dlist) { }
    }
}
codeunit 50102 VATPopbillFunctions
{
    procedure TestFunction()
    var
        popbill: DotNet TaxinvoiceService;
        taxinvoice: DotNet Taxinvoice;
        taxdeail: DotNet TaxinvoiceDetail;
        taxcontact: DotNet TaxinvoiceAddContact;
        skey: DotNet dstr;
        linkid: DotNet dstr;        
        ListofTax: DotNet dlist;
    begin
        ClearAll();
        skey := 'D+sDN004PZoJb8v4B8/WKWLrqFV58mdx1U9T+fjuoxw=';
        linkid := '2HC';
        popbill := popbill.TaxinvoiceService(linkid, skey);
        popbill.IsTest := true;
        popbill.IPRestrictOnOff := true;

        taxinvoice := taxinvoice.Taxinvoice();
        ListofTax := taxinvoice.GetTaxinvoiceDetails();

        taxdeail := taxdeail.TaxinvoiceDetail();
        taxdeail.serialNum := 1;
        taxdeail.purchaseDT := Format(Today, 0, '<Year4><Month,2><Day,2>');
        taxdeail.itemName := 'Description.';
        taxdeail.spec := 'Spec';
        taxdeail.qty := '1';
        taxdeail.unitCost := '10000';
        taxdeail.supplyCost := '10000';
        taxdeail.tax := '1000';
        taxdeail.remark := 'Remark';        
        ListofTax.Add(taxdeail);

        taxdeail := taxdeail.TaxinvoiceDetail();
        taxdeail.serialNum := 2;
        taxdeail.purchaseDT := Format(Today, 0, '<Year4><Month,2><Day,2>');
        taxdeail.itemName := '두번째 아이템이름';
        taxdeail.spec := '스펙';
        taxdeail.qty := '3';
        taxdeail.unitCost := '20000';
        taxdeail.supplyCost := '20000';
        taxdeail.tax := '2000';
        taxdeail.remark := '비고비고비고';        
        ListofTax.Add(taxdeail);             

        taxinvoice.issueType := '정발행';
        taxinvoice.taxType := '과세';
        taxinvoice.chargeDirection := '정과금';
        taxinvoice.writeDate := '20210128';
        taxinvoice.purposeType := '청구';
        taxinvoice.supplyCostTotal := '30000';
        taxinvoice.taxTotal := '3000';
        taxinvoice.totalAmount := '33000';
        taxinvoice.invoicerCorpNum := '7558800637';
        taxinvoice.invoicerCorpName := '(주)투에이치컨설팅';
        taxinvoice.invoicerCEOName := '한주영';
        taxinvoice.invoicerMgtKey := 'TESTVAT000002';
        taxinvoice.invoiceeType := '사업자';
        taxinvoice.invoiceeCorpNum := '3578700926';
        taxinvoice.invoiceeCorpName := '주식회사 지앤컨설팅';
        taxinvoice.invoiceeCEOName := '양광철';

        taxinvoice.detailList := ListofTax;

        popbill.Register('7558800637',taxinvoice,'',false);

    end;
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
        corpinfo := popbill.GetCorpInfo('7558800637', '');
        Message('대표자:%1 \\ 상호:%2 \\ 주소:%3', corpinfo.ceoname, corpinfo.corpName, corpinfo.addr);
    end;
    procedure GetInfo(var VATLedger: Record "VAT Ledger Entries")
    var
        popbill: DotNet TaxinvoiceService;
        taxinfo: DotNet TaxinvoiceInfo;
        MgtKeyType: DotNet TaxIvnoiceMgtKeyType;
        skey: DotNet dstr;
        linkid: DotNet dstr;
        VATCompanyInformation: Record "VAT Company";
        CorpRegID: Text;
        statusCode: Integer;
        //ETAXDocumentType: Enum "ETAX Status";
    begin
        Clear(skey);
        Clear(linkid);
        Clear(popbill);
        Clear(taxinfo);
        Clear(CorpRegID);
        Clear(statusCode);

        skey := 'D+sDN004PZoJb8v4B8/WKWLrqFV58mdx1U9T+fjuoxw=';
        linkid := '2HC';
        popbill := popbill.TaxinvoiceService(linkid, skey);
        popbill.IsTest := true;
        popbill.IPRestrictOnOff := true;        

        VATCompanyInformation.Reset();
        if VATCompanyInformation.FindFirst() then begin
            CorpRegID := DelChr(VATCompanyInformation."Corp RegID", '=', '-');
        end else
            Error('부가세 회사정보가 정의되지 않았습니다.\부가세회사를 먼저 정의하세요.');

        //일단, 대상인 경우.
        if (VATLedger."ETAX Document Status" = VATLedger."ETAX Document Status"::Issued) AND 
        (VATLedger."ETAX Status Code" <> VATLedger."ETAX Status Code"::"Successfully Sent") then
        begin
            if VATLedger."VAT Issue Type" = VATLedger."VAT Issue Type"::Sales then 
            begin
                taxinfo := popbill.GetInfo(CorpRegID,MgtKeyType::SELL,VATLedger."VAT Document No.");
            end else if VATLedger."VAT Issue Type" = VATLedger."VAT Issue Type"::Purchase then
            begin
                taxinfo := popbill.GetInfo(CorpRegID,MgtKeyType::BUY,VATLedger."VAT Document No.");
            end;

            statusCode := taxinfo.stateCode;
            if VATLedger."ETAX Status Code".AsInteger() <> statusCode then
            begin
                VATLedger."ETAX Status Code" := "ETAX Status".FromInteger(statusCode);
                VATLedger.Modify();
            end;
        end;
    end;

    procedure GetPopUpURL(VATDocumentNo: Text; VATIssueType: Enum "VAT Issue Type")
    var
        popbill: DotNet TaxinvoiceService;
        skey: DotNet dstr;
        linkid: DotNet dstr;
        mgtkeytype: DotNet TaxIvnoiceMgtKeyType;
        urlInfor: Text;
        VATCompanyInformation: Record "VAT Company";
        CorpRegID: Text;
    begin
        Clear(skey);
        Clear(linkid);
        Clear(popbill);
        Clear(mgtkeytype);
        Clear(urlInfor);
        Clear(CorpRegID);
        skey := 'D+sDN004PZoJb8v4B8/WKWLrqFV58mdx1U9T+fjuoxw=';
        linkid := '2HC';
        popbill := popbill.TaxinvoiceService(linkid, skey);
        popbill.IsTest := true;
        popbill.IPRestrictOnOff := true;

        VATCompanyInformation.Reset();
        if VATCompanyInformation.FindFirst() then begin
            CorpRegID := DelChr(VATCompanyInformation."Corp RegID", '=', '-');
        end else
            Error('부가세 회사정보가 정의되지 않았습니다.\부가세회사를 먼저 정의하세요.');

        if VATIssueType = VATIssueType::Purchase then
            urlInfor := popbill.GetPopUpURL(CorpRegID, mgtkeytype::BUY, VATDocumentNo, '')
        else
            urlInfor := popbill.GetPopUpURL(CorpRegID, mgtkeytype::SELL, VATDocumentNo, '');
        //OPEN URL.
        Hyperlink(urlInfor);
    end;
    
    //세금계산서를 즉시발행.
    procedure RegistIssue(var VATLedger: Record "VAT Ledger Entries";Amended: boolean)
    var
        popbill: DotNet TaxinvoiceService;
        taxinvoice: DotNet Taxinvoice;
        taxinvoicedetail: DotNet TaxinvoiceDetail;
        taxinvoicecontact: DotNet TaxinvoiceAddContact;
        response: DotNet IssueResponse;
        skey: DotNet dstr;
        linkid: DotNet dstr;
        ListofTax: DotNet dlist;
        ListofContact: DotNet dlist;

        VATCompanyInformation: Record "VAT Company";
        VATCategory: Record "VAT Category";
        detailedVATLedger: Record "detailed VAT Ledger Entries";
        VATContacts: Record "TAXInvoice Contacts";
        CorpRegID: Text;
        AccountRegID: Text;
        kwon: Integer;
        ho: Integer;
        SerialNum: Integer;
        window: Dialog;
        windowMessage: Text;
    begin
        //0. dotnet initialize
        Clear(skey);
        Clear(linkid);
        Clear(popbill);
        Clear(response);
        Clear(taxinvoice);
        Clear(taxinvoicedetail);
        Clear(taxinvoicecontact);
        Clear(ListofContact);
        Clear(ListofTax);

        Clear(CorpRegID);
        Clear(AccountRegID);
        Clear(kwon);
        Clear(ho);
        Clear(SerialNum);
        //2H Consulting - Security Key & Linkid (변경할 일 없음.)
        skey := 'D+sDN004PZoJb8v4B8/WKWLrqFV58mdx1U9T+fjuoxw=';
        linkid := '2HC';

        windowMessage := '계산서를 등록하고 전송중입니다...';
        Window.Open(windowMessage);
        //1. 넘어온 키/레코드에 대한 값 체크.
        //2. 키/레코드에 대한 필요한 값 체크.        
        if VATLedger."VAT Date" > Today then
            if not Dialog.Confirm('신고일자가 오늘 보다 미래입니다. 그래도 진행하시겠습니까?', true) then
                exit;

        VATCompanyInformation.Reset();
        if VATCompanyInformation.Get(VATLedger."VAT Company Code") then begin
            CorpRegID := DelChr(VATCompanyInformation."Corp RegID", '=', '-');
            AccountRegID := DelChr(VATLedger."Account Reg. ID", '=', '-');
        end else
            Error('부가세 회사정보가 정의되지 않았습니다.\부가세회사를 먼저 정의하세요.');

        //TODO 사업자등록번호 유효체크하는 기능추가 필요.
        if (CorpRegID = '') then
            Error('부가세 회사정보에 공급자 사업자번호가 정의되지 않았습니다.\공급자 사업자번호를 정의하세요.');

        if (STRLEN(CorpRegID) <> 10) then
            Error('부가세 회사정보에 공급자 사업자번호가 유효하지 않습니다.\공급자 사업자번호를 확인하세요.');

        if (VATCompanyInformation."Corp Name" = '') then
            Error('부가세 회사정보에 공급자 대표자 성명이 정의되지 않았습니다.\공급자 대표자 성명을 입력하세요.');

        //FIXME 거래처의 사업자 번호가 없는 경우, Master 에서 다시 복사하고 유효성 검사를 할 것.!!!
        if (AccountRegID = '') OR (StrLen(AccountRegID) <> 10) then
            Error('공급받는자 또는 공급자의 사업자등록번호가 정의되지 않거나, 유효하지 않습니다.\거래처의 사업자번호를 확인하세요.');

        if (VATLedger."Account Name" = '') then
            Error('공급받는자 또는 공급자의 상호가 정의되지 않았습니다.\거래처의 상호를 확인하세요.');

        if (VATLedger."VAT Claim Type" = VATLedger."VAT Claim Type"::Receipt) AND (VATLedger."VAT Document No." = '') then
            Error('부가세 번호가 누락되었습니다.\부가세 번호를 확인하세요.');

        if (VATLedger."Account CEO Name" = '') then
            Error('공급받는자 대표자 성명이 정의되지 않았습니다.\거래처의 대표자 성명을 입력하세요.');

        if (VATLedger."Account Contact Email" = '') then
            Error('공급받는자의 이메일 주소가 입력되지 않았습니다.\거래처 담당자에게 이메일이 발송되지 않습니다.\거래처의 담당자 이메일 주소를 확인하세요.');

        if (VATLedger."Actual Amount" = 0) then
            Error('공급가액이 0원입니다. \전자세금계산서 발행을 진행할 수 없습니다.');

        VATCategory.Reset();
        if VATCategory.get(VATLedger."VAT Category Code") then begin
            if VATCategory.Use = false then
                Error('사용하지 않는 부가세카테고리로 지정되었습니다.\문서의 부가세카테고리를 확인하세요.');

            if VATCategory.Taxation = true then
                if VATLedger."Tax Amount" = 0 then
                    Error('과세 유형의 계산서이나 세액이 0원입니다.\세액을 확인하세요.');
        end;

        if (VATLedger."VAT Document Type" = VATLedger."VAT Document Type"::Correction) AND (VATLedger."ETAX Mod Code" = VATLedger."ETAX Mod Code"::" ") then
            Error('수정세금계산서의 경우, 수정사유가 정의되어야 합니다. \수정발급사유를 확인하시고 다시 진행해 주세요.');

        //FIXME 담당자에게 이메일 보내는 여부체크 기능추가. (담당자 별로)

        //3. 필요한 값 셋업.

        // 세금계산서 서비스 객체 초기화
        popbill := popbill.TaxinvoiceService(linkid, skey);

        // 연동환경 설정값, 개발용(true), 상업용(false)
        popbill.IsTest := true;

        // 발급된 토큰에 대한 IP 제한기능 사용여부, 권장(true)
        popbill.IPRestrictOnOff := true;

        // 로컬PC 시간 사용 여부 true(사용), false(기본값) - 미사용
        popbill.UseLocalTimeYN := false;

        //taxinvoice - 전달객체(json format을 위해 serialization을 위한 객체에 값 전달.)
        taxinvoice := taxinvoice.Taxinvoice();

        //---------------------------------------------------------------------------

        // [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
        taxinvoice.writeDate := Format(VATLedger."VAT Date", 0, '<Year4><Month,2><Day,2>');
        // [필수] 과금방향, {정과금, 역과금}중 선택
        // - 정과금(공급자과금), 역과금(공급받는자과금)
        // - 역과금은 역발행 세금계산서를 발행하는 경우만 가능        
        taxinvoice.chargeDirection := '정과금';

        // [필수] 발행형태, {정발행, 역발행, 위수탁} 중 기재 
        // [필수] {영수, 청구} 중 기재
        // 위수탁발행은 대상에 넣지 않음.
        // 영수인 경우, 역발행.
        if VATLedger."VAT Claim Type" = VATLedger."VAT Claim Type"::Receipt then begin
            taxinvoice.issueType := '역발행';
            taxinvoice.purposeType := '영수';
        end else begin
            taxinvoice.issueType := '정발행'; //청구는 정발행.
            taxinvoice.purposeType := '청구';
        end;

        // [필수] 과세형태, {과세, 영세, 면세} 중 기재
        if VATCategory.Get(VATLedger."VAT Category Code") then begin
            if VATCategory.ZeroTax = true then
                taxinvoice.taxType := '영세'
            else
                if VATCategory.Taxation = true then
                    taxinvoice.taxType := '과세'
                else
                    taxinvoice.taxType := '면세';
        end;

        //청구일때, 공급자(VAT Company Information) 공급받는자(Account/Customer)
        if VATLedger."VAT Claim Type" = VATLedger."VAT Claim Type"::Claim then begin
            /*****************************************************************
            *                         공급자 정보                             *
            * 청구유형, 매출청구 / VAT Company Information             *
            *****************************************************************/
            // [필수] 공급자 사업자번호, '-' 제외 10자리
            taxinvoice.invoicerCorpNum := CorpRegID; //공급자사업자번호.
            // 공급자 종사업자 식별번호. 필요시 기재. 형식은 숫자 4자리.
            taxinvoice.invoicerTaxRegID := '';
            // [필수] 공급자 상호
            taxinvoice.invoicerCorpName := VATCompanyInformation."Corp Name";
            // [필수] 공급자 문서번호, 숫자, 영문, '-', '_' 조합으로 1~24자리까지 사업자번호별 중복없는 고유번호 할당
            taxinvoice.invoicerMgtKey := VATLedger."VAT Document No.";
            // [필수] 공급자 대표자 성명
            taxinvoice.invoicerCEOName := VATCompanyInformation."CEO Name";
            // 공급자 주소 
            taxinvoice.invoicerAddr := VATCompanyInformation."Corp Addr";
            // 공급자 종목
            taxinvoice.invoicerBizClass := VATCompanyInformation."Corp BizClass";
            // 공급자 업태
            taxinvoice.invoicerBizType := VATCompanyInformation."Corp BizType";
            // 공급자 담당자 성명 
            taxinvoice.invoicerContactName := VATCompanyInformation."Contact Name";
            // 공급자 담당자 메일주소
            taxinvoice.invoicerEmail := VATCompanyInformation."Contact Email";
            // 공급자 담당자 연락처
            taxinvoice.invoicerTEL := VATCompanyInformation."Contact TEL";
            // 공급자 담당자 휴대폰번호
            taxinvoice.invoicerHP := VATCompanyInformation."Contact HP";
            // 발행시 알림문자 전송여부
            // - 공급받는자 담당자 휴대폰번호(invoiceeHP1)로 전송
            //FIXME 부가세회사 정보에 담당자에게 연락여부를 추가할 것.
            taxinvoice.invoicerSMSSendYN := false;

            /*********************************************************************
            *                         공급받는자 정보                              *
            * Account / Customer /                                               *
            *********************************************************************/
            // [필수] 공급받는자 구분, {사업자, 개인, 외국인} 중 기재 
            CASE VATLedger."Account Type" of
                VATLedger."Account Type"::Corporate:
                    taxinvoice.invoiceeType := '사업자';
                VATLedger."Account Type"::Individual, VATLedger."Account Type"::Personal:
                    taxinvoice.invoiceeType := '개인';
                VATLedger."Account Type"::Foreigner:
                    taxinvoice.invoiceeType := '외국인';
                else
            END;
            // [필수] 공급받는자 사업자번호, '-'제외 10자리
            taxinvoice.invoiceeCorpNum := AccountRegID;
            // [필수] 공급받는자 상호
            taxinvoice.invoiceeCorpName := VATLedger."Account Name";
            // [역발행시 필수] 공급받는자 문서번호, 숫자, 영문, '-', '_' 조합으로 1~24자리까지 사업자번호별 중복없는 고유번호 할당
            taxinvoice.invoiceeMgtKey := '';
            // [필수] 공급받는자 대표자 성명 
            taxinvoice.invoiceeCEOName := VATLedger."Account CEO Name";
            // 공급받는자 주소 
            taxinvoice.invoiceeAddr := VATLedger."Account Address";
            // 공급받는자 종목
            taxinvoice.invoiceeBizClass := VATLedger."Account Biz Class";
            // 공급받는자 업태 
            taxinvoice.invoiceeBizType := VATLedger."Account Biz Type";

            // 공급받는자 담당자 연락처
            taxinvoice.invoiceeTEL1 := VATLedger."Account Contact Phone";
            // 공급받는자 담당자명 
            taxinvoice.invoiceeContactName1 := VATLedger."Account Contact Name";
            // 공급받는자 담당자 메일주소 
            // 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
            // 실제 거래처의 메일주소가 기재되지 않도록 주의
            taxinvoice.invoiceeEmail1 := VATLedger."Account Contact Email";

            //**********************************************/
            //테스트할 때에는 Fix.
            taxinvoice.invoiceeEmail1 := 'kc.yang@2hc.co.kr';
            //**********************************************/

            // 공급받는자 담당자 휴대폰번호 
            taxinvoice.invoiceeHP1 := VATLedger."Account Contact Phone";

            //**********************************************/
            //테스트할 때에는 Fix.
            taxinvoice.invoiceeHP1 := '010-8732-4043';
            //**********************************************/

            /*
            * 부 담당자가 입력된 경우 (이름/이메일주소가 있는경우)
            */
            if (VATLedger."Account Contact Name2" <> '') AND
            (VATLedger."Account Contact Email2" <> '') then
            begin
                // 공급받는자 담당자 연락처
                taxinvoice.invoiceeTEL2 := VATLedger."Account Contact Phone2";
                // 공급받는자 담당자명 
                taxinvoice.invoiceeContactName2 := VATLedger."Account Contact Name2";
                // 공급받는자 담당자 메일주소 
                // 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
                // 실제 거래처의 메일주소가 기재되지 않도록 주의
                taxinvoice.invoiceeEmail2 := VATLedger."Account Contact Email2";
                //**********************************************/
                //FIXME 테스트할 때에는 Fix.
                taxinvoice.invoiceeEmail2 := 'kc.yang@2hc.co.kr';
                //**********************************************/
                // 공급받는자 담당자 휴대폰번호 
                taxinvoice.invoiceeHP2 := VATLedger."Account Contact Phone2";
                //**********************************************/
                //FIXME 테스트할 때에는 Fix.
                taxinvoice.invoiceeHP2 := '010-8732-4043';
                //**********************************************/
            end;
            // 역발행시 알림문자 전송여부 
            taxinvoice.invoiceeSMSSendYN := false;
        end
        //영수일때, 공급자(Account/Vendor) 공급받는자(VAT Company Information)
        else
            if VATLedger."VAT Claim Type" = VATLedger."VAT Claim Type"::Receipt then begin
                Error('현재는, 매입계산서(역발행)에 대한 계산서 발행은 구현되지 않았습니다.\팝빌사이트에서 매입(역발행)을 등록하세요.');
                /*****************************************************************
                *                         공급자 정보                             *
                * Account / Vendor /                                               *
                *****************************************************************/
                /*
                                // [필수] 공급자 사업자번호, '-' 제외 10자리
                                taxinvoice.invoicerCorpNum := AccountRegID; //공급자사업자번호.
                                                                            // 공급자 종사업자 식별번호. 필요시 기재. 형식은 숫자 4자리.
                                taxinvoice.invoicerTaxRegID := '';
                                // [필수] 공급자 상호
                                taxinvoice.invoicerCorpName := VATLedger."Account Name";
                                // [필수] 공급자 문서번호, 숫자, 영문, '-', '_' 조합으로 1~24자리까지 사업자번호별 중복없는 고유번호 할당
                                taxinvoice.invoicerMgtKey := VATLedger."Linked External Document No.";
                                // [필수] 공급자 대표자 성명
                                taxinvoice.invoicerCEOName := VATLedger."Account CEO Name";
                                // 공급자 주소 
                                taxinvoice.invoicerAddr := VATLedger."Account Address";
                                // 공급자 종목
                                taxinvoice.invoicerBizClass := VATLedger."Account Biz Class";
                                // 공급자 업태
                                taxinvoice.invoicerBizType := VATLedger."Account Biz Type";
                                // 공급자 담당자 성명 
                                taxinvoice.invoicerContactName := VATLedger."Account Contact Name";
                                // 공급자 담당자 메일주소
                                taxinvoice.invoicerEmail := VATLedger."Account Contact Email";
                                // 공급자 담당자 연락처
                                taxinvoice.invoicerTEL := VATLedger."Account Contact Phone";
                                // 공급자 담당자 휴대폰번호
                                taxinvoice.invoicerHP := VATLedger."Account Contact Phone";
                                // 발행시 알림문자 전송여부
                                // - 공급받는자 담당자 휴대폰번호(invoiceeHP1)로 전송
                                taxinvoice.invoicerSMSSendYN := false;


                                //
                                // 공급받는자 정보                              
                                // VAT Company Information.
                                //
                                // [필수] 공급받는자 구분, {사업자, 개인, 외국인} 중 기재 
                                taxinvoice.invoiceeType := '사업자';
                                // [필수] 공급받는자 사업자번호, '-'제외 10자리
                                taxinvoice.invoiceeCorpNum := CorpRegID;
                                // [필수] 공급받는자 상호
                                taxinvoice.invoiceeCorpName := VATCompanyInformation."Corp Name";
                                // [역발행시 필수] 공급받는자 문서번호, 숫자, 영문, '-', '_' 조합으로 1~24자리까지 사업자번호별 중복없는 고유번호 할당
                                taxinvoice.invoiceeMgtKey := VATLedger."VAT Document No.";
                                // [필수] 공급받는자 대표자 성명 
                                taxinvoice.invoiceeCEOName := VATCompanyInformation."CEO Name";
                                // 공급받는자 주소 
                                taxinvoice.invoiceeAddr := VATCompanyInformation."Corp Addr";
                                // 공급받는자 종목
                                taxinvoice.invoiceeBizClass := VATCompanyInformation."Corp BizClass";
                                // 공급받는자 업태 
                                taxinvoice.invoiceeBizType := VATCompanyInformation."Corp BizType";
                                // 공급받는자 담당자 연락처
                                taxinvoice.invoiceeTEL1 := VATCompanyInformation."Contact TEL";
                                // 공급받는자 담당자명 
                                taxinvoice.invoiceeContactName1 := VATCompanyInformation."Contact Name";
                                // 공급받는자 담당자 메일주소 
                                // 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
                                // 실제 거래처의 메일주소가 기재되지 않도록 주의
                                taxinvoice.invoiceeEmail1 := VATCompanyInformation."Contact Email";
                                // 공급받는자 담당자 휴대폰번호 
                                taxinvoice.invoiceeHP1 := VATCompanyInformation."Contact HP";
                                // 역발행시 알림문자 전송여부 
                                taxinvoice.invoiceeSMSSendYN := false;
                */
            end;


        /*********************************************************************
        *                          세금계산서 정보                          *
        *********************************************************************/

        // [필수] 공급가액 합계
        taxinvoice.supplyCostTotal := Format(VATLedger."Actual Amount");
        // [필수] 세액 합계
        taxinvoice.taxTotal := Format(VATLedger."Tax Amount");

        // [필수] 합계금액,  공급가액 합계 + 세액 합계
        taxinvoice.totalAmount := Format(VATLedger."Total Amount");
        // 기재상 일련번호 항목 
        taxinvoice.serialNum := '1';
        // 기재상 현금 항목 
        taxinvoice.cash := '';
        // 기재상 수표 항목
        taxinvoice.chkBill := '';
        // 기재상 어음 항목
        taxinvoice.note := '';
        // 기재상 외상미수금 항목
        taxinvoice.credit := '';
        // 기재상 비고 항목
        taxinvoice.remark1 := VATLedger."ETAX Remark1";
        taxinvoice.remark2 := VATLedger."ETAX Remark2";
        taxinvoice.remark3 := VATLedger."ETAX Remark3";

        Evaluate(kwon, Format(Today, 0, '<Year,4>'));
        Evaluate(ho, Format(Today, 0, '<Month,2>'));

        // 기재상 권 항목, 최대값 32767
        // 미기재시 taxinvoice.kwon := null;
        // 권은 년도로 입력되도록 함. 2HC
        taxinvoice.kwon := kwon;
        // 기재상 호 항목, 최대값 32767
        // 미기재시 taxinvoice.ho := null;
        // 호는 월로 입력되도록 함. 2HC
        taxinvoice.ho := ho;
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
        if Amended = true then 
        begin
            if VATLedger."ETAX Mod Code" = VATLedger."ETAX Mod Code"::" " then
                Error('수정세금계산서 발급사유가 선택되지 않았습니다.\세금계산서 사유를 선택하고 사유에 따른 정확한 금액을 확인바랍니다.');
            taxinvoice.modifyCode := VATLedger."ETAX Mod Code".AsInteger();
            // 수정세금계산서 작성시 원본세금계산서의 국세청승인번호
            if VATLedger."ETAX Issue ID" = '' then
                Error('이전 국세청승인번호가 존재하지 않습니다.\이미 발행된 국세청 승인번호가 없으면 수정세금계산서를 발행할 수 없습니다.');
            taxinvoice.orgNTSConfirmNum := VATLedger."ETAX Issue ID";
        end;
        //*************************************************************************/

        detailedVATLedger.Reset();
        detailedVATLedger.SetRange("VAT Document No.", VATLedger."VAT Document No.");
        SerialNum := 0;
        if detailedVATLedger.FindSet() then begin
            ListofTax := taxinvoice.GetTaxinvoiceDetails(); //List<TaxinvoiceDetail> 을 가져오는 구문.            
            repeat
                SerialNum += 1;
                taxinvoicedetail := taxinvoicedetail.TaxinvoiceDetail();
                taxinvoicedetail.serialNum := SerialNum;
                taxinvoicedetail.purchaseDT := Format(VATLedger."VAT Date", 0, '<Year4><Month,2><Day,2>');
                taxinvoicedetail.itemName := detailedVATLedger."Item Description";
                taxinvoicedetail.spec := detailedVATLedger.Spec;
                taxinvoicedetail.qty := Format(detailedVATLedger.Quantity);
                taxinvoicedetail.unitCost := Format(detailedVATLedger."Unit price");
                taxinvoicedetail.supplyCost := Format(detailedVATLedger."Actual Amount");
                taxinvoicedetail.tax := Format(detailedVATLedger."Tax Amount");
                taxinvoicedetail.remark := detailedVATLedger.Remark;
                ListofTax.Add(taxinvoicedetail); //Detail List 집어넣기.
            until detailedVATLedger.Next() = 0;
            taxinvoice.detailList := ListofTax; //SET List<TaxinvoiceDetial>...            
        end;

        /*
        * 추가 담당자가 있을 경우, 최대 5명까지 입력.
        */
        VATContacts.Reset();
        if VATLedger."VAT Issue Type" = VATLedger."VAT Issue Type"::Sales then
            VATContacts.SetRange("Account Type","Account Type"::Customer)
        else
            VATContacts.SetRange("Account Type","Account Type"::Vendor);

        VATContacts.SetRange("No.",VATLedger."Account No.");

        //추가 담당자가 있을때만, 값을 입력함.
        if VATContacts.FindSet() then
        begin
            ListofContact := taxinvoice.GetTaxinvoiceAddContacts();
            repeat
                taxinvoicecontact := taxinvoicecontact.TaxinvoiceAddContact();
                taxinvoicecontact.serialNum := VATContacts."Line No.";
                taxinvoicecontact.contactName := VATContacts."Contact Name";
                taxinvoicecontact.email := VATContacts."Contact Email";
                ListofContact.Add(taxinvoicecontact);
            until VATContacts.Next() = 0;
            taxinvoice.addContactList := ListofContact;
        end;

        //4. popbill 연동.
        response := popbill.RegistIssue(CorpRegID,taxinvoice,false,'',false,'','');
#region IMSI
/*      //임시로 사용했던 Function.     
        response := popbill.RegistOneIssue(CorpRegID, taxinvoice,
            taxinvoicedetail.serialNum,
            taxinvoicedetail.purchaseDT,
            taxinvoicedetail.itemName,
            taxinvoicedetail.spec,
            taxinvoicedetail.qty,
            taxinvoicedetail.unitCost,
            taxinvoicedetail.supplyCost,
            taxinvoicedetail.tax,
            taxinvoicedetail.remark,
            false, '', false, '', '');
*/
#endregion
        //5. 결과값 받기.
        //6. 넘어온 키/레코드에 관련 값 업데이트.        
        //정상발행 건의 경우,
        if Amended = false then
        begin
            VATLedger."ETAX Document Status" := VATLedger."ETAX Document Status"::Issued;
            VATLedger."ETAX Issue ID" := response.ntsConfirmNum;
            VATLedger."ETAX Issuer" := UserId;
            VATLedger."ETAX Issue Date" := Today;
            VATLedger."ETAX Res. Code" := Format(response.code);
            VATLedger.Modify();
        end else if Amended = true then 
        begin
        //수정세금계산서 발행의 경우.
            VATLedger."ETAX Document Status" := VATLedger."ETAX Document Status"::Issued;
            VATLedger."ETAX Mod Issue ID" := response.ntsConfirmNum;
            VATLedger."ETAX Mod Issuer" := UserId;
            VATLedger."ETAX Mod Issue Date" := Today;
            VATLedger."ETAX Res. Code" := Format(response.code);
            VATLedger.Modify();
        end;

        window.Close();
        Message('전자세금 계산서가 발행요청되었습니다.!\상세 상태는 등록된 부가세문서에서 확인하세요.');

        //Message('응답코드:%1 \ 응답메시지 %2 \ 국세청승인번호 %3', response.code, response.message, response.ntsConfirmNum);
    end;
}