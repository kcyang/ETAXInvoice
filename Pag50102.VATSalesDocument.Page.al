/*
부가세 매출 입력.
TODO 공급가액/세액 부분은 FixedGrid 로 진행할 것.
https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-arrange-fields-in-rows-and-columns-using-fixedlayout-control
위 링크 참조.
*/
page 50102 "VAT Sales Document"
{

    CaptionML = ENU = 'VAT Sales Document', KOR = '매출 부가세 등록';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Order,Request Approval,History,Print/Send,Navigate';
    SourceTable = "VAT Ledger Entries";
    RefreshOnActivate = true;
    Editable = true;
    SourceTableView = where("VAT Issue Type" = filter(Sales),"VAT Document Type" = filter(General));

    layout
    {
        area(content)
        {
            group(RegistType)
            {
                CaptionML = ENU = 'Type', KOR = '계산서 유형';
                Enabled = groupEditable;
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
                Enabled = groupEditable;
                field("VAT Date"; Rec."VAT Date")
                {
                    CaptionML = ENU = 'VAT Date', KOR = '계산서 발행일자';
                    ApplicationArea = ALL;
                    ToolTip = '계산서 발행일자 입니다.';
                }
                field("VAT Document No."; Rec."VAT Document No.")
                {
                    CaptionML = ENU = 'VAT Document No.', KOR = '문서번호';
                    ApplicationArea = ALL;
                    ToolTip = '부가세 문서번호입니다.';
                }
                field("Account No."; Rec."Account No.")
                {
                    CaptionML = ENU = 'Account No.', KOR = '거래처 번호';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 번호입니다.';
                }
                field(AccountRegID; Rec."Account Reg. ID")
                {
                    CaptionML = ENU = 'Customer Reg. ID', KOR = '등록번호';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 사업자등록번호 입니다.';
                }
                field(AccountName; Rec."Account Name")
                {
                    CaptionML = ENU = 'Customer Name', KOR = '상 호';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 상호입니다.';
                }
                field(AccountCEO; Rec."Account CEO Name")
                {
                    CaptionML = ENU = 'CEO Name', KOR = '대표자성명';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 대표자 이름입니다.';
                }
                field(AccountAddress; Rec."Account Address")
                {
                    CaptionML = ENU = 'Address', KOR = '사업장 주소';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 사업장 주소입니다.';
                }
                field(AccountBizType; Rec."Account Biz Type")
                {
                    CaptionML = ENU = 'Business Type', KOR = '업태';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 업태입니다.';
                }
                field("Account Biz Class"; Rec."Account Biz Class")
                {
                    CaptionML = ENU = 'Business Class', KOR = '종목';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 종목입니다.';
                }
                field("Account Contact Name"; Rec."Account Contact Name")
                {
                    CaptionML = ENU = 'Contact Name', KOR = '담당자';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 담당자입니다.';
                }
                field("Account Contact Phone"; Rec."Account Contact Phone")
                {
                    CaptionML = ENU = 'Contact Phone', KOR = '연락처';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 사업자등록번호 입니다.';
                }
                field("Account Contact Email"; Rec."Account Contact Email")
                {
                    CaptionML = ENU = 'Email', KOR = '이메일';
                    ApplicationArea = ALL;
                    ToolTip = '거래처 담당자 이메일입니다.';
                }
            }
            /*
            공급가액/세액표시
            */
            group("Ivoice Details")
            {
                CaptionML = ENU = 'Details', KOR = '공급가액/세액';
                Enabled = groupEditable;
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
                Enabled = groupEditable;
            }

            group(Statement)
            {
                CaptionML = ENU = 'Statement', KOR = '전자명세관련';
                Enabled = statementEditable;        
                field("Statement Type";Rec."Statement Type")
                {
                    CaptionML = ENU = 'Statement Type', KOR = '명세서 유형';
                    ApplicationArea = ALL;
                    ToolTip = '명세서 유형을 선택합니다.';
                }   
                field("Statement Status";Rec."Statement Status")
                {
                    CaptionML = ENU = 'Statement Status', KOR = '명세서 발행상태';
                    ApplicationArea = ALL;
                    ToolTip = '명세서의 발행상태를 나타냅니다.';
                    Enabled = false;
                }     
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(RegistIssue)
            {
                CaptionML = ENU = 'Regist Issue', KOR = '전자세금계산서 발행';
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
                    if Rec."ETAX Document Status" = Rec."ETAX Document Status"::Issued then
                        Error('이미 전자 계산서 발행이 완료된 건입니다.\문서를 확인하세요.');

                    //2. 계산서 발행.
                    popbill.RegistIssue(Rec,false);
                end;
            }
            action(OpenPopbill)
            {
                CaptionML = ENU='Open ETAX Document',KOR='세금계산서 보기';
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
                    popbill.GetPopUpURL(Rec."VAT Document No.",Rec."VAT Issue Type");
                end;                
            }            
        }
    }
    //신규버튼을 누르면, 매출인 경우 매출타입을 넣는다.
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate(Rec."VAT Issue Type", Rec."VAT Issue Type"::Sales);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."ETAX Document Status" = Rec."ETAX Document Status"::Issued then
            groupEditable := false
        else
            groupEditable := true;
        
        if (Rec."Statement Status" = Rec."Statement Status"::"Approval Pending") OR
        (Rec."Statement Status" = Rec."Statement Status"::Issued) then
            statementEditable := false
        else
            statementEditable := true;

    end;

    trigger OnInit()
    begin
        groupEditable := true;     
        statementEditable := true;   
    end;

    var
        groupEditable: Boolean;
        statementEditable: Boolean;
}
