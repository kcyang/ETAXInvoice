/*
부가세 기장 테이블. 계산서 발행을 위한 부가정보와 금액 및 모든 정보는 이 페이지를 통해 조회할 수 있음.

TODO 거래내역 가져오기를 해서, 계산서를 발행하는 것도 확인할 것.
*/
page 50101 "VAT Ledger Entries"
{
    
    ApplicationArea = All;
    CaptionML = ENU='VAT Ledger Entries',KOR='매출 부가세 조회';
    PageType = List;
    SourceTable = "VAT Ledger Entries";
    UsageCategory = Lists;
    Editable = true;
    PromotedActionCategories = 'New,Process,Report';    
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("VAT Document No."; Rec."VAT Document No.")
                {
                    ApplicationArea = All;
                }
                field("Account No.";Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                }                
                field("VAT Document Type"; Rec."VAT Document Type")
                {
                    ApplicationArea = All;
                }                
                field("VAT Posting Type"; Rec."VAT Posting Type")
                {
                    ApplicationArea = All;
                }       
                field("VAT Issue Type"; Rec."VAT Issue Type")
                {
                    ApplicationArea = All;
                }                         
                field("VAT Date"; Rec."VAT Date")
                {
                    ApplicationArea = All;
                }                
                field("VAT Category Code"; Rec."VAT Category Code")
                {
                    ApplicationArea = All;
                }
                field("VAT Category Name"; Rec."VAT Category Name")
                {
                    ApplicationArea = All;
                }                
                field("VAT Omission"; Rec."VAT Omission")
                {
                    ApplicationArea = All;
                }
                field("VAT Claim Type"; Rec."VAT Claim Type")
                {
                    ApplicationArea = All;
                }                
                field("VAT Rates"; Rec."VAT Rates")
                {
                    ApplicationArea = All;
                }                
                field("Actual Amount"; Rec."Actual Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }         
                field("Tax Amount"; Rec."Tax Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }                   
                field("Total Amount"; Rec."Total Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }   
                field("Tax Issue Date"; Rec."Tax Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Tax Issue ID"; Rec."Tax Issue ID")
                {
                    ApplicationArea = All;
                }      
                field("Linked GL Entry No."; Rec."Linked GL Entry No.")
                {
                    ApplicationArea = All;
                }           
                field("Account Contact Name"; Rec."Account Contact Name")
                {
                    ApplicationArea = All;
                }                                    
                field("Account Contact Phone"; Rec."Account Contact Phone")
                {
                    ApplicationArea = All;
                }                            
                field("Account Contact Email"; Rec."Account Contact Email")
                {
                    ApplicationArea = All;
                }            
                field("VAT Regist Type"; Rec."VAT Regist Type")
                {
                    ApplicationArea = All;
                }               
                field("VAT Company Code"; Rec."VAT Company Code")
                {
                    ApplicationArea = All;
                }        
                field("Corp Contact Name"; Rec."Corp Contact Name")
                {
                    ApplicationArea = All;
                }           
                field("Corp Contact Phone"; Rec."Corp Contact Phone")
                {
                    ApplicationArea = All;
                }                     
                field("Corp Contact Email"; Rec."Corp Contact Email")
                {
                    ApplicationArea = All;
                }               
                field("Zerotax rate Type"; Rec."Zerotax rate Type")
                {
                    ApplicationArea = All;
                }                
                field("Related Document Name"; Rec."Related Document Name")
                {
                    ApplicationArea = All;
                }                    
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }                          
                field(Issuer; Rec.Issuer)
                {
                    ApplicationArea = All;
                }                
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;
                }                
                field(DateofShipment; Rec.DateofShipment)
                {
                    ApplicationArea = All;
                }                
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;
                }                
                field(Amount_FCY; Rec.Amount_FCY)
                {
                    ApplicationArea = All;
                }
                field(Amount_LCY; Rec.Amount_LCY)
                {
                    ApplicationArea = All;
                }                
                field("Zerotax rate remark"; Rec."Zerotax rate remark")
                {
                    ApplicationArea = All;
                }            
                field("Line Description"; Rec."Line Description")
                {
                    ApplicationArea = All;
                }
                field("Line Spec"; Rec."Line Spec")
                {
                    ApplicationArea = All;
                }
                field("Line Quantity"; Rec."Line Quantity")
                {
                    ApplicationArea = All;
                }             
                field("Line Unit Price"; Rec."Line Unit Price")
                {
                    ApplicationArea = All;
                }                   
                field("Line Remark"; Rec."Line Remark")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Document Status"; Rec."ETAX Document Status")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Issue ID"; Rec."ETAX Issue ID")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Mod Code"; Rec."ETAX Mod Code")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Mod Issue ID"; Rec."ETAX Mod Issue ID")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Before Issue ID"; Rec."ETAX Before Issue ID")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Remark1"; Rec."ETAX Remark1")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Remark2"; Rec."ETAX Remark2")
                {
                    ApplicationArea = All;
                }
                field("ETAX Remark3"; Rec."ETAX Remark3")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Status Code"; Rec."ETAX Status Code")
                {
                    ApplicationArea = All;
                }
                field("ETAX Status Name"; Rec."ETAX Status Name")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Res. Code"; Rec."ETAX Res. Code")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Email Sending"; Rec."ETAX Email Sending")
                {
                    ApplicationArea = All;
                }
                field("ETAX FAX Sending"; Rec."ETAX FAX Sending")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Issuer"; Rec."ETAX Issuer")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Issue Date"; Rec."ETAX Issue Date")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Sending Status"; Rec."ETAX Sending Status")
                {
                    ApplicationArea = All;
                }                
                field("ETAX Detailed Res. Msg"; Rec."ETAX Detailed Res. Msg")
                {
                    ApplicationArea = All;
                }                
                field("Account Address"; Rec."Account Address")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account Biz Class"; Rec."Account Biz Class")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account Biz Type"; Rec."Account Biz Type")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account CEO Name"; Rec."Account CEO Name")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account Contact Confirm Date"; Rec."Account Contact Confirm Date")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account Contact Confirm"; Rec."Account Contact Confirm")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account Contact Email2"; Rec."Account Contact Email2")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }

                field("Account Contact Name2"; Rec."Account Contact Name2")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }

                field("Account Contact Phone2"; Rec."Account Contact Phone2")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account Reg. ID"; Rec."Account Reg. ID")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account remark1"; Rec."Account remark1")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account SubTaxRegID"; Rec."Account SubTaxRegID")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Credit Card No."; Rec."Credit Card No.")
                {
                    ApplicationArea = All;
                }
                field("Credit Card Payment Type"; Rec."Credit Card Payment Type")
                {
                    ApplicationArea = All;
                }
                field("ETAX Res. Msg"; Rec."ETAX Res. Msg")
                {
                    ApplicationArea = All;
                }
                field("ETAX SMS Sending"; Rec."ETAX SMS Sending")
                {
                    ApplicationArea = All;
                }
                field("ETAX Status"; Rec."ETAX Status")
                {
                    ApplicationArea = All;
                }
                field("Export Declaration No."; Rec."Export Declaration No.")
                {
                    ApplicationArea = All;
                }
                field("Linked Account Name"; Rec."Linked Account Name")
                {
                    ApplicationArea = All;
                }
                field("Linked Account No."; Rec."Linked Account No.")
                {
                    ApplicationArea = All;
                }
                field("Linked Document No."; Rec."Linked Document No.")
                {
                    ApplicationArea = All;
                }
                field("Linked Document Type"; Rec."Linked Document Type")
                {
                    ApplicationArea = All;
                }
                field("Linked External Document No."; Rec."Linked External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Linked Jnl. Batch Name"; Rec."Linked Jnl. Batch Name")
                {
                    ApplicationArea = All;
                }
                field("Linked Jnl. Line No."; Rec."Linked Jnl. Line No.")
                {
                    ApplicationArea = All;
                }
                field("Linked Jnl. Template Name"; Rec."Linked Jnl. Template Name")
                {
                    ApplicationArea = All;
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                }
            }
            /*
            품목,규격,수량,단가,공급가액,세액,비고
            */
/*현재는 필요없어 보임.            
            part(VATSalesLines;"VAT Sales Listpart")
            {
                CaptionML = ENU='Sales Lines',KOR='항목';
                ApplicationArea = All;
                Editable = true;
                SubPageLink = "VAT Document No." = FIELD("VAT Document No.");
                UpdatePropagation = Both;                
            }            
*/            
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
