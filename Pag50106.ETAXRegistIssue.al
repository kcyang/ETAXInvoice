page 50106 "ETAX Regist Issue"
{
    
    ApplicationArea = All;
    CaptionML = ENU='ETAX Regist Issue',KOR='전자세금계산서 발행';
    PageType = List;
    SourceTable = "VAT Ledger Entries";
    UsageCategory = Lists;
    Editable = false;
    PromotedActionCategories = 'New,Process,Report';        
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("VAT Date"; Rec."VAT Date")
                {
                    ApplicationArea = All;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }
                field("Actual Amount"; Rec."Actual Amount")
                {
                    ApplicationArea = All;
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("VAT Document Type"; Rec."VAT Document Type")
                {
                    ApplicationArea = All;
                }
                field("ETAX Issue ID"; Rec."ETAX Issue ID")
                {
                    ApplicationArea = All;
                }
                field("ETAX Document Status"; Rec."ETAX Document Status")
                {
                    ApplicationArea = All;
                }
                field("VAT Claim Type"; Rec."VAT Claim Type")
                {
                    ApplicationArea = All;
                }
                field("VAT Document No."; Rec."VAT Document No.")
                {
                    ApplicationArea = All;
                }
                field("Linked Document Type"; Rec."Linked Document Type")
                {
                    ApplicationArea = All;
                }
                field("Linked Document No."; Rec."Linked Document No.")
                {
                    ApplicationArea = All;
                }
                field("Linked External Document No."; Rec."Linked External Document No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(OpenDocument)
            {
                CaptionML = ENU='Open Document',KOR='문서열기';
                Image = OpenJournal;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;

                trigger OnAction()
                begin
                    if Rec."VAT Issue Type" = Rec."VAT Issue Type"::Sales then
                        page.Run(page::"VAT Sales Document",Rec)
                    else if Rec."VAT Issue Type" = rec."VAT Issue Type"::Purchase then
                        page.Run(page::"VAT Purchase Document",Rec)
                    else
                        ;
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
        area(Processing)
        {
            action(RegistIssue)
            {
                CaptionML = ENU='Regist Issue',KOR='전자세금계산서 발행';
                Image = ElectronicRegister;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;              
                trigger OnAction()
                var
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    //1. 계산서 발행 대상인지 체크.
                    if Rec."ETAX Document Status" = Rec."ETAX Document Status"::Issued then
                        Error('이미 전자 계산서 발행이 완료된 건입니다.\문서를 확인하세요.');

                    //2. 계산서 발행.
                    popbill.RegistIssue(Rec);
                end;  
            }
        }
    }    
}
