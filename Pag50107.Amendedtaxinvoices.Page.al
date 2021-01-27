page 50107 "Amended tax invoices"
{

    CaptionML = ENU = 'Amended tax invoices', KOR = '수정세금계산서 발행';
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    SourceTable = "VAT Ledger Entries";
    RefreshOnActivate = true;
    Editable = true;
    SourceTableView = where("VAT Document Type" = filter(Correction));

    layout
    {
        area(content)
        {
            group(AmendedType)
            {
                CaptionML = ENU = 'Amended Type', KOR = '수정사유선택';
                Enabled = groupEditable;
                field(AmendedTaxType; Rec."ETAX Mod Code")
                {
                    Importance = Promoted;
                    CaptionML = ENU = 'Amended Tax Invoice Reason', KOR = '수정사유';
                    ApplicationArea = ALL;
                    ToolTip = '수정사유를 선택합니다.\수정사유에 따라 작성항목이 바뀝니다.';
                    trigger OnValidate()
                    begin
                        case Rec."ETAX Mod Code" of
                            Rec."ETAX Mod Code"::" ": //NULL
                                begin
                                    ModifyAmount('POSITIVE');
                                    VATDateEditable := false;
                                    LineEditable := false;
                                    Difference := false;
                                end;
                            Rec."ETAX Mod Code"::"1": //기재사항 착오정정
                                begin
                                    ModifyAmount('POSITIVE');
                                    LineEditable := true; //금액변경.
                                    VATDateEditable := false; //날자는 발행일 그대로.
                                    Difference := false;
                                end;
                            Rec."ETAX Mod Code"::"2": //공급가액 변동
                                begin
                                    ModifyAmount('ZERO');
                                    LineEditable := false; //공급자 차액만큼 입력.
                                    VATDateEditable := true; //변동 발행일자 입력.
                                    Difference := true;
                                end;
                            Rec."ETAX Mod Code"::"3": //환입
                                begin
                                    ModifyAmount('ZERO');
                                    LineEditable := false; //환입된 금액만큼 입력.
                                    VATDateEditable := true; //환입일자 입력
                                    Difference := true;
                                end;
                            Rec."ETAX Mod Code"::"4": //계약의 해제
                                begin
                                    ModifyAmount('NEGATIVE');
                                    LineEditable := false; //자동 (-)금액입력.
                                    VATDateEditable := true; //계약의 해제일자입력.
                                    Difference := false;
                                end;
                            Rec."ETAX Mod Code"::"5": //내국신용장 사후개설
                                begin
                                    ModifyAmount('POSITIVE');
                                    LineEditable := true;  //신용장발행금액만 입력.
                                    VATDateEditable := false; //날짜는 발행일.
                                    Difference := false;
                                    //FIXME 영세라고 입력....??
                                end;
                            Rec."ETAX Mod Code"::"6": //착오에 의한 이중발급
                                begin
                                    ModifyAmount('NEGATIVE');
                                    LineEditable := false; //금액(-)자동입력.
                                    VATDateEditable := false; //날짜는 발행일.
                                    Difference := false;
                                end;
                            else
                                ;
                        end;
                    end;
                }
                field("ETAX Before Document No."; Rec."ETAX Before Document No.")
                {
                    CaptionML = ENU = 'Before Document No.', KOR = '수정대상 문서번호';
                    ApplicationArea = ALL;
                    ToolTip = '수정 대상에 대한 이전 국세청승인번호입니다.';
                    Enabled = false;
                }
                field("ETAX Issue ID"; Rec."ETAX Issue ID")
                {
                    CaptionML = ENU = 'ETAX Before Issued ID', KOR = '이전 국세청 승인번호';
                    ApplicationArea = ALL;
                    ToolTip = '수정 대상에 대한 이전 국세청승인번호입니다.';
                    Enabled = false;
                }
                field("ETAX Status Code";Rec."ETAX Status Code")
                {
                    CaptionML = ENU = 'ETAX Sending Status', KOR = '국세청 전송상태';
                    ApplicationArea = ALL;
                    ToolTip = '국세청에 전송중인 상태를 보여줍니다.현재 상태를 보시려면 문서를 열거나 목록에서 새로고침하시면 됩니다.';
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;                             
                }
            }
            group(RegistType)
            {
                CaptionML = ENU = 'Type', KOR = '계산서 유형';
                Enabled = false;
                grid(TypeGrid)
                {
                    group(GeneralInformation)
                    {
                        CaptionML = ENU = 'Account Type', KOR = '거래처유형';
                        field(VATType; Rec."VAT Issue Type")
                        {
                            Importance = Promoted;
                            CaptionML = ENU = 'Issue Type', KOR = '거래 유형';
                            ApplicationArea = ALL;
                            ToolTip = '거래 유형입니다.';
                        }
                        field("Account Type"; Rec."Account Type")
                        {
                            Importance = Promoted;
                            CaptionML = ENU = 'Account Type', KOR = '거래처유형';
                            ApplicationArea = ALL;
                            ToolTip = '거래처 유형입니다.';
                        }

                    }
                    group(TypeInformation)
                    {
                        CaptionML = ENU = 'VAT Type', KOR = '과세형태';
                        field("VAT Category Code"; Rec."VAT Category Code")
                        {
                            CaptionML = ENU = 'VAT Category', KOR = '부가세 유형';
                            ApplicationArea = ALL;
                            ToolTip = '부가세 유형코드입니다.';
                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field("VAT Category Name"; Rec."VAT Category Name")
                        {
                            CaptionML = ENU = ' ', KOR = ' ';
                            ApplicationArea = ALL;
                            Editable = false;
                            Style = StrongAccent;
                            StyleExpr = TRUE;
                            Importance = Promoted;
                            ToolTip = '부가세 유형이름입니다.';
                        }
                    }

                }
            }
            /*
            일반정보, 공급자/공급받는자 요약 정보
            비고1
            */
            group(General)
            {
                CaptionML = ENU = 'General', KOR = '매출 세금계산서';
                field("VAT Date"; Rec."VAT Date")
                {
                    CaptionML = ENU = 'VAT Date', KOR = '계산서 발행일자';
                    ApplicationArea = ALL;
                    ToolTip = '계산서 발행일자 입니다.';
                    Enabled = VATDateEditable;
                }
                field("VAT Document No."; Rec."VAT Document No.")
                {
                    CaptionML = ENU = 'VAT Document No.', KOR = '문서번호';
                    ApplicationArea = ALL;
                    ToolTip = '부가세 문서번호입니다.';
                    Enabled = false;
                }
                field("Account No."; Rec."Account No.")
                {
                    CaptionML = ENU = 'Account No.', KOR = '거래처 번호';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 번호입니다.';
                    Enabled = false;
                }
                field(AccountRegID; Rec."Account Reg. ID")
                {
                    CaptionML = ENU = 'Customer Reg. ID', KOR = '등록번호';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 사업자등록번호 입니다.';
                    Enabled = false;
                }
                field(AccountName; Rec."Account Name")
                {
                    CaptionML = ENU = 'Customer Name', KOR = '상 호';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 상호입니다.';
                    Enabled = false;
                }
                field(AccountCEO; Rec."Account CEO Name")
                {
                    CaptionML = ENU = 'CEO Name', KOR = '대표자성명';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 대표자 이름입니다.';
                    Enabled = false;
                }
                field(AccountAddress; Rec."Account Address")
                {
                    CaptionML = ENU = 'Address', KOR = '사업장 주소';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 사업장 주소입니다.';
                    Enabled = false;
                }
                field(AccountBizType; Rec."Account Biz Type")
                {
                    CaptionML = ENU = 'Business Type', KOR = '업태';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 업태입니다.';
                    Enabled = false;
                }
                field("Account Biz Class"; Rec."Account Biz Class")
                {
                    CaptionML = ENU = 'Business Class', KOR = '종목';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 종목입니다.';
                    Enabled = false;
                }
                field("Account Contact Name"; Rec."Account Contact Name")
                {
                    CaptionML = ENU = 'Contact Name', KOR = '담당자';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 담당자입니다.';
                    Enabled = false;
                }
                field("Account Contact Phone"; Rec."Account Contact Phone")
                {
                    CaptionML = ENU = 'Contact Phone', KOR = '연락처';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 사업자등록번호 입니다.';
                    Enabled = false;
                }
                field("Account Contact Email"; Rec."Account Contact Email")
                {
                    CaptionML = ENU = 'Email', KOR = '이메일';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 담당자 이메일입니다.';
                    Enabled = false;
                }
            }
            /*
            공급가액/세액표시
            */
            group("Ivoice Details")
            {
                CaptionML = ENU = 'Details', KOR = '공급가액/세액';
                //Enabled = groupEditable;
                field("Difference Amount"; Rec."Difference Amount")
                {
                    CaptionML = ENU = 'Difference Amount', KOR = '차액(공급가/환입)';
                    ApplicationArea = ALL;
                    Enabled = Difference;
                    Editable = groupEditable;
                    ToolTip = '수정세금계산서 사유가 공급가/환입의 경우 차액에 대해서 증가면 (+) 금액을\감소면 (-) 금액을 입력합니다.';
                    trigger OnValidate()
                    var
                        detailedVATLedger: Record "detailed VAT Ledger Entries";
                    begin
                        detailedVATLedger.Reset();
                        detailedVATLedger.SetRange("VAT Document No.", Rec."VAT Document No.");
                        if detailedVATLedger.Find('-') then begin
                            detailedVATLedger.Validate("Actual Amount",Rec."Difference Amount");
                            detailedVATLedger.Modify();
                            CurrPage.Update();
                        end;
                    end;
                }
                field("Actual Amount"; Rec."Actual Amount")
                {
                    CaptionML = ENU = 'Actual Amount', KOR = '공급가액';
                    ApplicationArea = ALL;
                    Editable = false;
                    ToolTip = '공급가입니다.';
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    CaptionML = ENU = 'Tax Amount', KOR = '세  액';
                    ApplicationArea = ALL;
                    Editable = false;
                    ToolTip = '세액입니다.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    CaptionML = ENU = 'Total Amount', KOR = '합  계';
                    ApplicationArea = ALL;
                    Editable = false;
                    ToolTip = '합계 금액입니다.';
                }
                field("ETAX Remark1"; Rec."ETAX Remark1")
                {
                    CaptionML = ENU = 'Remark1', KOR = '비고1/외국인등록번호/여권번호';
                    ApplicationArea = ALL;
                    ToolTip = '비고입니다.외국인의 경우 이 항목에 등록번호또는 여권번호를 입력합니다.';
                }
            }
            /*
            품목,규격,수량,단가,공급가액,세액,비고
            */
            part(VATSalesLines; "VAT Sales Listpart")
            {
                CaptionML = ENU = 'Sales Lines', KOR = '항목';
                ApplicationArea = All;
                Editable = true;
                SubPageLink = "VAT Document No." = FIELD("VAT Document No.");
                UpdatePropagation = Both;
                Enabled = LineEditable;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(RegistIssue)
            {
                CaptionML = ENU = 'Regist Issue', KOR = '수정전자세금계산서 발행';
                Image = ElectronicRegister;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;
                Enabled = groupEditable;
                trigger OnAction()
                var
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    //1. 계산서 발행 대상인지 체크.
                    if Rec."VAT Document Type" <> Rec."VAT Document Type"::Correction then
                        Error('수정 전자 세금계산서가 아닙니다.\문서를 확인하세요.');

                    //2. 계산서 발행.
                    popbill.RegistIssue(Rec, true);
                end;
            }
            action(OpenPopbill)
            {
                CaptionML = ENU = 'Open ETAX Document', KOR = '세금계산서 보기';
                Image = LaunchWeb;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;

                trigger OnAction()
                var
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    if Rec."ETAX Document Status" <> Rec."ETAX Document Status"::Issued then
                        Error('전자세금계산서가 발행(요청)되지 않았습니다.\계산서를 열 수 없습니다.');
                    popbill.GetPopUpURL(Rec."VAT Document No.", Rec."VAT Issue Type");
                end;
            }
            action(OpenPreDocument)
            {
                CaptionML = ENU = 'Open Pre Document', KOR = '수정대상 문서보기';
                Image = OpenJournal;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;

                trigger OnAction()
                var
                    VATLedger: Record "VAT Ledger Entries";
                begin
                    if Rec."ETAX Before Document No." <> '' then begin
                        VATLedger.Reset();
                        VATLedger.SetRange("VAT Document No.", Rec."ETAX Before Document No.");
                        if VATLedger.FindSet() then begin
                            if Rec."VAT Issue Type" = Rec."VAT Issue Type"::Purchase then
                                page.Run(page::"VAT Purchase Document", VATLedger)
                            else
                                if Rec."VAT Issue Type" = Rec."VAT Issue Type"::Sales then
                                    page.Run(page::"VAT Sales Document", VATLedger);
                        end;
                    end else
                        Message('이 문서는 수정대상 문서가 존재하지 않습니다.');

                end;
            }
            action(getPreDocumentAmount)
            {
                CaptionML = ENU = 'Get Pre Document Amount', KOR = '수정문서 금액다시불러오기';
                Image = GetLines;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;           
                Enabled = groupEditable;     
                trigger OnAction()
                var
                    detailedVATLedger: Record "detailed VAT Ledger Entries";
                    xDetailedVATLedger: Record "detailed VAT Ledger Entries";                
                begin
                    xDetailedVATLedger.Reset();
                    xDetailedVATLedger.SetRange("VAT Document No.",Rec."ETAX Before Document No.");
                    if xDetailedVATLedger.FindSet() then
                    begin
                        repeat
                            detailedVATLedger.Reset();
                            detailedVATLedger.SetRange("VAT Document No.",Rec."VAT Document No.");
                            detailedVATLedger.SetRange("Line No.",xDetailedVATLedger."Line No.");
                            if detailedVATLedger.find('-') then
                            begin
                                detailedVATLedger."Actual Amount" := xDetailedVATLedger."Actual Amount";
                                detailedVATLedger."Tax Amount" := xDetailedVATLedger."Tax Amount";
                                detailedVATLedger."Line Total Amount" := xDetailedVATLedger."Line Total Amount";
                                detailedVATLedger.Modify();
                                CurrPage.Update();
                            end;
                        until xDetailedVATLedger.Next() = 0;
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if Rec."ETAX Document Status" = Rec."ETAX Document Status"::Issued then
            groupEditable := false
        else
            groupEditable := true;
        
        if (Rec."ETAX Mod Code" = "ETAX Mod Code"::"2") OR 
        (Rec."ETAX Mod Code" = "ETAX Mod Code"::"3") then
            Difference := true
        else
            Difference := false;

    end;

    trigger OnInit()
    begin
        groupEditable := true;
        VATDateEditable := false;
        LineEditable := false;
        Difference := false;
    end;

    local procedure ModifyAmount(ModifyType: Code[10])
    var
        detailedVATLedger: Record "detailed VAT Ledger Entries";
    begin
        if ModifyType = '' then
            Error('Internal Error:: 금액수정유형이 입력되지 않았습니다.Page 50107 <<개발자에게 전달바랍니다.');

        detailedVATLedger.Reset();
        detailedVATLedger.SetRange("VAT Document No.", Rec."VAT Document No.");
        if detailedVATLedger.FindSet() then begin
            if ModifyType = 'POSITIVE' then begin
                if detailedVATLedger."Actual Amount" < 0 then begin
                    detailedVATLedger."Actual Amount" := detailedVATLedger."Actual Amount" * -1;
                    detailedVATLedger."Tax Amount" := detailedVATLedger."Tax Amount" * -1;
                    detailedVATLedger."Line Total Amount" := detailedVATLedger."Line Total Amount" * -1;
                    detailedVATLedger.Modify(true);
                    CurrPage.Update();
                end;
            end else if ModifyType = 'NEGATIVE' then begin
                if detailedVATLedger."Actual Amount" > 0 then begin
                    detailedVATLedger."Actual Amount" := detailedVATLedger."Actual Amount" * -1;
                    detailedVATLedger."Tax Amount" := detailedVATLedger."Tax Amount" * -1;
                    detailedVATLedger."Line Total Amount" := detailedVATLedger."Line Total Amount" * -1;
                    detailedVATLedger.Modify(true);
                    CurrPage.Update();
                end;
            end else if ModifyType = 'ZERO' then begin
                detailedVATLedger."Actual Amount" := 0;
                detailedVATLedger."Tax Amount" := 0;
                detailedVATLedger."Line Total Amount" := 0;
                detailedVATLedger.Modify(true);
                CurrPage.Update();
            end;
        end;
    end;

    var
        groupEditable: Boolean;
        VATDateEditable: Boolean;
        LineEditable: Boolean;
        Difference: Boolean;
}
