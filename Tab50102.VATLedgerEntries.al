/*
부가세 기장.
TODO 수량,단가 입력시, 공급가/세액/합계 계산.
TODO 공급가 입력시 세율에 따른 세액/합계 계산.
TODO 송장에서 입력시, 라인의 내용을 합쳐서, Description 외 x 건. 수량은 1, 단가는 공급가, 공급가,세액 자동입력.
TODO 디테일 라인의 내용에 따라, 부가세 기장상의 내용 가져오기.(해당 내용은, 라인으로 대체할지 고민좀 해보자.)
*/
table 50102 "VAT Ledger Entries"
{
    CaptionML = ENU='VAT Ledger Entries',KOR='한국 부가세 기장';
    DataClassification = CustomerContent;
    Extensible = true;

    
    fields
    {
        field(1; "VAT Document No."; Code[25])
        {
            CaptionML = ENU='VAT Document No.',KOR='부가세 문서번호';
            DataClassification = CustomerContent;
        }
        field(2; "VAT Document Type"; Enum "VAT Document Type")
        {
            CaptionML = ENU='VAT Document Type',KOR='계산서 유형';
            DataClassification = CustomerContent;
        }
        field(3; "VAT Posting Type"; Enum "VAT Posting Type")
        {
            CaptionML = ENU='VAT Posting Type',KOR='부가세 발행유형';
            DataClassification = CustomerContent;
        }
        field(4; "VAT Issue Type"; Enum "VAT Issue Type")
        {
            CaptionML = ENU='VAT Issue Type',KOR='매출입 구분';
            DataClassification = CustomerContent;
            //매출인경우 청구, 매입인 경우 영수를 자동으로 입력하도록 한다.
            trigger OnValidate()
            begin
                if "VAT Issue Type" = "VAT Issue Type"::Sales then
                    "VAT Claim Type" := "VAT Claim Type"::Claim
                else if "VAT Issue Type" = "VAT Issue Type"::Purchase then
                    "VAT Claim Type" := "VAT Claim Type"::Receipt
                else
                    "VAT Claim Type" := "VAT Claim Type"::None;
            end;
        }
        field(5; "VAT Date"; Date)
        {
            CaptionML = ENU='VAT Date',KOR='부가세 일자';
            DataClassification = CustomerContent;
        }
        field(6; "VAT Category Code"; Code[10])
        {
            CaptionML = ENU='VAT Category Code',KOR='부가세 유형';
            DataClassification = CustomerContent;
            TableRelation = "VAT Category";     

            trigger OnValidate()
            begin
                //CalcFields("VAT Category Name");
                //CalcFields("VAT Rates");
                //부가세율이 바뀌므로, detailed 항목을 세액을 변경합니다.
                OnChangeVATCategory(Rec,xRec);
            end;       

        }
        field(7; "VAT Category Name"; Text[100])
        {
            CaptionML = ENU='VAT Category Name',KOR='부가세 유형이름';
            FieldClass = FlowField;
            //Category Name 은, VAT Category 테이블에서 가져와서 그냥 보여준다.
            CalcFormula = lookup("VAT Category"."Category Name" where("Category No." = field("VAT Category Code")));
        }
        field(8; "VAT Omission"; Enum "VAT Omission Type")
        {
            CaptionML = ENU='VAT Omission',KOR='예정누락';
            DataClassification = CustomerContent;
        }
        field(9; "Credit Card No."; Code[19])
        {
            CaptionML = ENU='Credit Card No.',KOR='신용카드번호';
            DataClassification = CustomerContent;
        }
        field(10; "Credit Card Payment Type"; Enum "Credit Card Payment Type")
        {
            CaptionML = ENU='Credit Card Payment Type',KOR='신용카드결제유형';
            DataClassification = CustomerContent;
        }
        field(11; "VAT Claim Type"; Enum "VAT Claim Type")
        {
            CaptionML = ENU='VAT Claim Type',KOR='부가세 청구유형';
            DataClassification = CustomerContent;
        }
        field(12; "VAT Rates"; Decimal)
        {
            CaptionML = ENU='VAT Rates',KOR='부가세율';
            FieldClass = FlowField;
            //VAT Rates 은, VAT Category 테이블에서 가져와서 그냥 보여준다.
            CalcFormula = lookup("VAT Category"."VAT Rates" where("Category No." = field("VAT Category Code")));            
        }
        field(13; "Table ID"; Integer)
        {
            CaptionML = ENU='Table ID',KOR='테이블ID';
            DataClassification = CustomerContent;
        }
        field(14; "Linked Account No."; Code[20])
        {
            CaptionML = ENU='Linked Account No.',KOR='계정번호';
            DataClassification = CustomerContent;
        }
        field(15; "Linked Account Name"; Text[250])
        {
            CaptionML = ENU='Linked Account Name',KOR='계정명';
            DataClassification = CustomerContent;
        }
        field(16; "Linked Jnl. Template Name"; Code[10])
        {
            CaptionML = ENU='Linked Jnl. Template Name',KOR='분개 템플릿명';
            DataClassification = CustomerContent;
        }
        field(17; "Linked Jnl. Batch Name"; Code[10])
        {
            CaptionML = ENU='Linked Jnl. Batch Name',KOR='분개 배치명';
            DataClassification = CustomerContent;
        }
        field(18; "Linked Jnl. Line No."; Integer)
        {
            CaptionML = ENU='Linked Jnl. Line No.',KOR='분개라인번호';
            DataClassification = CustomerContent;
        }
        field(19; "Linked Document Type"; Enum "Linked Document Type")
        {
            CaptionML = ENU='Linked Document Type',KOR='문서유형';
            DataClassification = CustomerContent;
        }
        field(20; "Linked Document No."; Code[20])
        {
            CaptionML = ENU='Linked Document No.',KOR='문서번호';
            DataClassification = CustomerContent;
        }
        field(21; "Actual Amount"; Decimal)
        {
            CaptionML = ENU='Actual Amount',KOR='공급가액';
            FieldClass = FlowField;
            CalcFormula = sum("detailed VAT Ledger Entries"."Actual Amount" where ("VAT Document No."=field("VAT Document No.")));
        }
        field(22; "Tax Amount"; Decimal)
        {
            CaptionML = ENU='Tax Amount',KOR='세액';
            FieldClass = FlowField;
            CalcFormula = sum("detailed VAT Ledger Entries"."Tax Amount" where ("VAT Document No."=field("VAT Document No.")));
        }
        field(23; "Total Amount"; Decimal)
        {
            CaptionML = ENU='Total Amount',KOR='합계금액';
            FieldClass = FlowField;
            CalcFormula = sum("detailed VAT Ledger Entries"."Line Total Amount" where ("VAT Document No."=field("VAT Document No.")));
        }
        field(24; "Tax Issue Date"; Date)
        {
            CaptionML = ENU='Tax Issue Date',KOR='계산서발행일자';
            DataClassification = CustomerContent;
        }
        field(25; "Tax Issue ID"; Code[20])
        {
            CaptionML = ENU='Tax Issue ID',KOR='계산서 발행ID';
            DataClassification = CustomerContent;
        }
        field(26; "Linked GL Entry No."; Integer)
        {
            CaptionML = ENU='Linked GL Entry No.',KOR='연결된GL 번호';
            DataClassification = CustomerContent;
        }
        field(27; "Linked External Document No."; Code[35])
        {
            CaptionML = ENU='Linked External Document No.',KOR='외부문서번호';
            DataClassification = CustomerContent;
        }
        field(28; "Account Name"; Text[200])
        {
            CaptionML = ENU='Account Name',KOR='거래처명';
            DataClassification = CustomerContent;
        }
        field(29; "Account Address"; Text[300])
        {
            CaptionML = ENU='Account Address',KOR='거래처주소';
            DataClassification = CustomerContent;
        }
        field(30; "Account Biz Type"; Text[100])
        {
            CaptionML = ENU='Account Biz Type',KOR='거래처업태';
            DataClassification = CustomerContent;
        }
        field(31; "Account Biz Class"; Text[100])
        {
            CaptionML = ENU='Account Biz Class',KOR='거래처종목';
            DataClassification = CustomerContent;
        }
        field(32; "Account Type"; Enum "Customer Type")
        {
            CaptionML = ENU='Account Type',KOR='거래처사업자구분';
            DataClassification = CustomerContent;
        }
        field(33; "Account CEO Name"; Text[100])
        {
            CaptionML = ENU='Account CEO Name',KOR='거래처대표자명';
            DataClassification = CustomerContent;
        }
        field(34; "Account Reg. ID"; Text[20])
        {
            CaptionML = ENU='Account Reg. ID',KOR='거래처사업자등록번호';
            DataClassification = CustomerContent;
        }
        field(35; "Account SubTaxRegID"; Text[4])
        {
            CaptionML = ENU='Account SubTaxRegID',KOR='거래처종사업장코드';
            DataClassification = CustomerContent;
        }
        field(36; "Account remark1"; Text[150])
        {
            CaptionML = ENU='Account remark1',KOR='거래처비고1';
            DataClassification = CustomerContent;
        }
        field(37; "Account Contact Name"; Text[100])
        {
            CaptionML = ENU='Account Contact Name',KOR='거래처담당자이름';
            DataClassification = CustomerContent;
        }
        field(38; "Account Contact Phone"; Text[20])
        {
            CaptionML = ENU='Account Contact Phone',KOR='거래처담당자전화번호';
            DataClassification = CustomerContent;
        }
        field(39; "Account Contact Email"; Text[100])
        {
            CaptionML = ENU='Account Contact Email',KOR='거래처담당자이메일';
            DataClassification = CustomerContent;
        }
        field(40; "Account Contact Name2"; Text[100])
        {
            CaptionML = ENU='Account Contact Name2',KOR='거래처담당자2이름';
            DataClassification = CustomerContent;
        }
        field(41; "Account Contact Phone2"; Text[20])
        {
            CaptionML = ENU='Account Contact Phone2',KOR='거래처담당자2전화번호';
            DataClassification = CustomerContent;
        }
        field(42; "Account Contact Email2"; Text[100])
        {
            CaptionML = ENU='Account Contact Email2',KOR='거래처담당자2이메일';
            DataClassification = CustomerContent;
        }
        field(43; "VAT Regist Type"; Enum "VAT Type")
        {
            CaptionML = ENU='VAT Regist Type',KOR='부가세등록유형';
            DataClassification = CustomerContent;
        }
        field(44; "VAT Company Code"; Code[20])
        {
            CaptionML = ENU='VAT Company Code',KOR='부가세회사코드';
            DataClassification = CustomerContent;
            //회사코드가 입력되면, 관련정보를 가져와 입력해 놓는다.
            trigger OnValidate()
            var
                VATCompany: Record "VAT Company";
            begin
                VATCompany.Reset();
                if VATCompany.get("VAT Company Code") then begin
                    "Corp Contact Name" := VATCompany."Contact Name";
                    "Corp Contact Phone" := VATCompany."Contact TEL";
                    "Corp Contact Email" := VATCompany."Contact Email";
                end else
                    Error('부가세 회사가 정의되지 않았습니다. 부가세 회사를 먼저 정의하세요.');;
            end;
        }
        field(45; "Corp Contact Name"; Text[100])
        {
            CaptionML = ENU='Corp Contact Name',KOR='세금계산서담당자이름';
            DataClassification = CustomerContent;
        }
        field(46; "Corp Contact Phone"; Text[20])
        {
            CaptionML = ENU='Corp Contact Phone',KOR='세금계산서담당자전화번호';
            DataClassification = CustomerContent;
        }
        field(47; "Corp Contact Email"; Text[100])
        {
            CaptionML = ENU='Corp Contact Email',KOR='세금계산서담당자이메일';
            DataClassification = CustomerContent;
        }
        field(48; "Zerotax rate Type"; Enum "Zerotax rate Type")
        {
            CaptionML = ENU='Zerotax rate Type',KOR='영세율 구분';
            DataClassification = CustomerContent;
        }
        field(49; "Related Document Name"; Enum "Related Document Name")
        {
            CaptionML = ENU='Related Document Name',KOR='서류명';
            DataClassification = CustomerContent;
        }
        field(50; "Currency Code"; Code[20])
        {
            CaptionML = ENU='Currency Code',KOR='통화';
            DataClassification = CustomerContent;
        }
        field(51; Issuer; Text[50])
        {
            CaptionML = ENU='Issuer',KOR='발급자';
            DataClassification = CustomerContent;
        }
        field(52; "Issue Date"; Date)
        {
            CaptionML = ENU='Issue Date',KOR='발급일';
            DataClassification = CustomerContent;
        }
        field(53; DateofShipment; Date)
        {
            CaptionML = ENU='DateofShipment',KOR='선적일';
            DataClassification = CustomerContent;
        }
        field(54; "Currency Factor"; Decimal)
        {
            CaptionML = ENU='Currency Factor',KOR='환율';
            DataClassification = CustomerContent;
        }
        field(55; Amount_FCY; Decimal)
        {
            CaptionML = ENU='Amount_FCY',KOR='외화금액';
            DataClassification = CustomerContent;
        }
        field(56; Amount_LCY; Decimal)
        {
            CaptionML = ENU='Amount_LCY',KOR='원화금액';
            DataClassification = CustomerContent;
        }
        field(57; "Zerotax rate remark"; Text[250])
        {
            CaptionML = ENU='Zerotax rate remark',KOR='영세율 비고';
            DataClassification = CustomerContent;
        }
        field(58; "Export Declaration No."; Text[30])
        {
            CaptionML = ENU='Export Declaration No.',KOR='수출신고번호';
            DataClassification = CustomerContent;
        }
        field(59; "Line Description"; Text[100])
        {
            CaptionML = ENU='Line Description',KOR='품목';
            DataClassification = CustomerContent;
        }
        field(60; "Line Spec"; Text[10])
        {
            CaptionML = ENU='Line Spec',KOR='규격';
            DataClassification = CustomerContent;
        }
        field(61; "Line Quantity"; Decimal)
        {
            CaptionML = ENU='Line Quantity',KOR='수량';
            DataClassification = CustomerContent;
        }
        field(62; "Line Unit Price"; Decimal)
        {
            CaptionML = ENU='Line Unit Price',KOR='단가';
            DataClassification = CustomerContent;
        }
        field(63; "Line Remark"; Text[100])
        {
            CaptionML = ENU='Line Remark',KOR='라인 비고';
            DataClassification = CustomerContent;
        }
        field(64; "ETAX Document Status"; Enum "ETAX Document Status")
        {
            CaptionML = ENU='ETAX Document Status',KOR='전자세금계산서 문서상태';
            DataClassification = CustomerContent;
        }
        field(65; "ETAX Issue ID"; Text[24])
        {
            CaptionML = ENU='ETAX Issue ID',KOR='국세청전송 일련번호';
            DataClassification = CustomerContent;
        }
        field(66; "ETAX Mod Code"; Enum "ETAX Mod Code")
        {
            CaptionML = ENU='ETAX Mod Code',KOR='수정세금계산서 사유코드';
            DataClassification = CustomerContent;
        }
        field(67; "ETAX Mod Issue ID"; Text[24])
        {
            CaptionML = ENU='ETAX Mod Issue ID',KOR='수정전세금계산서 발행일련번호';
            DataClassification = CustomerContent;
        }
        field(68; "ETAX Before Issue ID"; Text[24])
        {
            CaptionML = ENU='ETAX Before Issue ID',KOR='수정전세금계산서 국세청전송일련번호';
            DataClassification = CustomerContent;
        }
        field(69; "ETAX Remark1"; Text[250])
        {
            CaptionML = ENU='ETAX Remark1',KOR='비고1';
            DataClassification = CustomerContent;
        }
        field(70; "ETAX Remark2"; Text[250])
        {
            CaptionML = ENU='ETAX Remark2',KOR='비고2';
            DataClassification = CustomerContent;
        }
        field(71; "ETAX Remark3"; Text[250])
        {
            CaptionML = ENU='ETAX Remark3',KOR='비고3';
            DataClassification = CustomerContent;
        }
        field(72; "ETAX Status Code"; Code[20])
        {
            CaptionML = ENU='ETAX Status Code',KOR='응답 상태코드';
            DataClassification = CustomerContent;
        }
        field(73; "ETAX Status Name"; Text[50])
        {
            CaptionML = ENU='ETAX Status Name',KOR='응답 상태이름';
            DataClassification = CustomerContent;
        }
        field(74; "ETAX Res. Code"; Code[20])
        {
            CaptionML = ENU='ETAX Res. Code',KOR='응답코드';
            DataClassification = CustomerContent;
        }
        field(75; "ETAX Res. Msg"; Text[50])
        {
            CaptionML = ENU='ETAX Res. Msg',KOR='응답메세지';
            DataClassification = CustomerContent;
        }
        field(76; "ETAX Email Sending"; Boolean)
        {
            CaptionML = ENU='ETAX Email Sending',KOR='Email 발행요청';
            DataClassification = CustomerContent;
        }
        field(77; "ETAX SMS Sending"; Boolean)
        {
            CaptionML = ENU='ETAX SMS Sending',KOR='SMS발행요청';
            DataClassification = CustomerContent;
        }
        field(78; "ETAX FAX Sending"; Boolean)
        {
            CaptionML = ENU='ETAX FAX Sending',KOR='FAX발행요청';
            DataClassification = CustomerContent;
        }
        field(79; "ETAX Issuer"; Code[30])
        {
            CaptionML = ENU='ETAX Issuer',KOR='전자세금계산서 전송 ID';
            DataClassification = CustomerContent;
        }
        field(80; "ETAX Status"; Code[20])
        {
            CaptionML = ENU='ETAX Status',KOR='전자 세금계산서 상태';
            DataClassification = CustomerContent;
        }
        field(81; "ETAX Issue Date"; Date)
        {
            CaptionML = ENU='ETAX Issue Date',KOR='국세청 전송일자';
            DataClassification = CustomerContent;
        }
        field(82; "ETAX Sending Status"; Enum "ETAX Sending Status")
        {
            CaptionML = ENU='ETAX Sending Status',KOR='국세청 전송상태';
            DataClassification = CustomerContent;
        }
        field(83; "ETAX Detailed Res. Msg"; Text[250])
        {
            CaptionML = ENU='ETAX Detailed Res. Msg',KOR='응답메세지 상세';
            DataClassification = CustomerContent;
        }
        field(84; "Account Contact Confirm"; Boolean)
        {
            CaptionML = ENU='Account Contact Confirm',KOR='청구처 담당자 확인 여부';
            DataClassification = CustomerContent;
        }
        field(85; "Account Contact Confirm Date"; Date)
        {
            CaptionML = ENU='Account Contact Confirm Date',KOR='청구처 담당자 확인 일자';
            DataClassification = CustomerContent;
        }
        field(86; "Account No."; code[20])
        {
            CaptionML = ENU='Account No.',KOR='거래처번호';
            DataClassification = CustomerContent;
            //매출,매입구분에 따라 Vendor 또는 Customer 와 연동합니다.
            //각 매출,매입처 중에 잠김(Blocked)처리된 항목은 보여지지 않습니다.
            TableRelation = if("VAT Issue Type" = const(Purchase)) Vendor where(Blocked = filter(' '))
                            else if ("VAT Issue Type" = const(Sales)) Customer where(Blocked = filter(' '));         
            //값이 변경되었을 때,
            trigger onValidate()
            var
                LV_VATMaster: Record "VAT Basic Information";
            begin
                LV_VATMaster.Reset();                
                //매입의 경우, Vendor 의 값을 가져오고,
                if "VAT Issue Type" = "VAT Issue Type"::Purchase then begin
                    LV_VATMaster.SetRange("Table ID",Database::Vendor);
                //매출의 경우, Customer 의 값을 가져갑니다.    
                end else if "VAT Issue Type" = "VAT Issue Type"::Sales then begin
                    LV_VATMaster.SetRange("Table ID",Database::Customer);
                end else
                    Error('거래처에 등록되지 않은 번호를 입력하셨습니다.다시 확인하고 입력해 주세요.');

                LV_VATMaster.SetRange("No.",Rec."Account No.");
                if LV_VATMaster.Find('-') then begin
                    "Account Reg. ID" := LV_VATMaster."Account Reg. ID";
                    "Account Name" := LV_VATMaster."Account Name";
                    "Account Address" := LV_VATMaster."Account Address";
                    "VAT Regist Type" := LV_VATMaster."VAT Type";
                    "Account Type" := LV_VATMaster."Customer Type";
                    "Account Biz Class" := LV_VATMaster."Business Class";
                    "Account Biz Type" := LV_VATMaster."Business Type";
                    "Account SubTaxRegID" := LV_VATMaster.SubTaxRegID;
                    "Account CEO Name" := LV_VATMaster."CEO Name";
                    "Account Contact Name" := LV_VATMaster."Contact Name";
                    "Account Contact Phone" := LV_VATMaster.TEL;
                    "Account Contact Email" := LV_VATMaster.Email;
                    "Account Contact Name2" := LV_VATMaster."Contact Name2";
                    "Account Contact Phone2" := LV_VATMaster.TEL2;
                    "Account Contact Email2" := LV_VATMaster.Email2;
                    Modify();
                end;
            end;   
        }        
    }
    keys
    {
        //부가세 번호 주키
        key(PK; "VAT Document No.")
        {
            Clustered = true;
        }
        //거래처별 부가세 번호
        key(ListbyAccount; "Account No.","VAT Document No."){}
    }
    trigger OnInsert()
    var
        myNos: code[20];
        VATCompany: Record "VAT Company";
    begin
        //번호 입력한다.
        //FIXME 번호시리즈는 부가세 설정에서 확인하도록 수정해야 됨.
        NoSeriesMgt.InitSeries('KVAT',myNos,0D,"VAT Document No.",myNos);
        //부가세 일자는 작업일자를 넣는다.
        "VAT Date" := WorkDate();
        //회사코드는 기본코드를 자동으로 입력하도록 한다.
        VATCompany.Reset();
        if VATCompany.FindFirst() then 
            VALIDATE("VAT Company Code",VATCompany."Corp No.")
        else
            Error('부가세 회사가 정의되지 않았습니다. 부가세 회사정보를 먼저 설정하세요.!');
    end;

    //VAT Category 가 변경되면, 부가세율 변경을 위해 이벤트를 발생시킵니다.
    [IntegrationEvent(false, false)]
    local procedure OnChangeVATCategory(var Rec: Record "VAT Ledger Entries";var xRec:Record "VAT Ledger Entries")
    begin
    end;
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
