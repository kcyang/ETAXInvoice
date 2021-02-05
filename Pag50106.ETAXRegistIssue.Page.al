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
                field(Statement;Rec.Statement)
                {
                    ApplicationArea = All;
                }
                field("VAT Document Type"; Rec."VAT Document Type")
                {
                    ApplicationArea = All;
                }                
                field("VAT Issue Type";Rec."VAT Issue Type")
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
                field("ETAX Issue ID"; Rec."ETAX Issue ID")
                {
                    Visible = false;
                    ApplicationArea = All;
                    //HideValue = true;
                }
                field("ETAX Document Status"; Rec."ETAX Document Status")
                {
                    ApplicationArea = All;
                    Style = StrongAccent;
                    StyleExpr = StyleYN;
                }
                field("ETAX Status Code";Rec."ETAX Status Code")
                {
                    ApplicationArea = All;
                    Style = StrongAccent;
                }
                field("Statement Type";"Statement Type")
                {
                    ApplicationArea = All;
                }
                field("Statement Issue Date";"Statement Issue Date")
                {
                    ApplicationArea = All;
                }
                field("Statement Status";"Statement Status")
                {
                    ApplicationArea = All;
                    Style = StandardAccent;                    
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
                field("ETAX Mod Issue Date";Rec."ETAX Mod Issue Date")
                {
                    ApplicationArea = All;
                }
                field("ETAX Mod Code";Rec."ETAX Mod Code")
                {
                    ApplicationArea = All;                    
                }
                field("ETAX Mod Issuer";Rec."ETAX Mod Issuer")
                {
                    ApplicationArea = All;
                }
                field("ETAX Before Document No.";Rec."ETAX Before Document No.")
                {
                    ApplicationArea = All;                    
                }
                field("ETAX Mod Issue ID";Rec."ETAX Mod Issue ID")
                {
                    Visible = false;
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
                    //이전문서가 있으면, 수정세금 계산서문서이므로, 수정계산서 문서로 표시함.
                    if (Rec."VAT Document Type" = Rec."VAT Document Type"::Correction)
                      AND (Rec."ETAX Before Document No." <> '') then
                    begin
                        page.Run(page::"Amended tax invoices",Rec);
                    end else
                    begin
                        //그 외 문서는 일반적인 문서, 매출/매입에 따라 문서 열기.
                        if Rec."VAT Issue Type" = Rec."VAT Issue Type"::Sales then
                            page.Run(page::"VAT Sales Document",Rec)
                        else if Rec."VAT Issue Type" = rec."VAT Issue Type"::Purchase then
                            page.Run(page::"VAT Purchase Document",Rec)
                        else
                            ;
                    end;                        
                end;
            }            
            action(OpenRelatedDocument)
            {
                CaptionML = ENU='Open Related Document',KOR='관련 문서열기';
                Image = OpenJournal;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;
                trigger OnAction()
                var
                    postedSalesInvoice: Record "Sales Invoice Header";
                    postedSalesCrMemo: Record "Sales Cr.Memo Header";
                    postedPurchInvoice: Record "Purch. Inv. Header";
                    postedPurchCrMemo: Record "Purch. Cr. Memo Hdr.";
                begin
                    if Rec."Linked Document No." <> '' then
                    begin
                        if Rec."VAT Issue Type" = Rec."VAT Issue Type"::Purchase then
                        begin
                            CASE Rec."Linked Document Type" of
                                Rec."Linked Document Type"::Order,Rec."Linked Document Type"::Invoice:
                                begin
                                    if postedPurchInvoice.get(Rec."Linked Document No.") then
                                        page.Run(page::"Posted Purchase Invoice",postedPurchInvoice);
                                end;
                                Rec."Linked Document Type"::"Return Order",Rec."Linked Document Type"::"Credit Memo":
                                begin
                                    if postedPurchCrMemo.get(Rec."Linked Document No.") then
                                        page.Run(page::"Posted Purchase Credit Memo",postedPurchCrMemo);
                                end;
                                else
                                ;
                            END;
                        end else if Rec."VAT Issue Type" = Rec."VAT Issue Type"::Sales then
                        begin
                            CASE Rec."Linked Document Type" of
                                Rec."Linked Document Type"::Order,Rec."Linked Document Type"::Invoice:
                                begin
                                    if postedSalesInvoice.get(Rec."Linked Document No.") then
                                        page.Run(page::"Posted Sales Invoice",postedSalesInvoice);
                                end;
                                Rec."Linked Document Type"::"Return Order",Rec."Linked Document Type"::"Credit Memo":
                                begin
                                    if postedSalesCrMemo.get(Rec."Linked Document No.") then
                                        page.Run(page::"Posted Sales Credit Memo",postedSalesCrMemo);
                                end;
                                else
                                ;
                            END;
                        end;                       
                    end else
                        Message('관련 문서가 없는 계산서 입니다.\문서열기를 통해 문서를 확인하세요.');
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
            action(OpenAmendedDocument)
            {
                //해당 문서에 수정문서가 존재하면, 그 문서를 여는 것.
                CaptionML = ENU='Open Amended Document',KOR='수정계산서 문서열기';
                Image = OpenJournal;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;

                trigger OnAction()
                var
                    AmendedVAT : Record "VAT Ledger Entries";
                begin
                    AmendedVAT.Reset();
                    AmendedVAT.SetFilter("ETAX Before Document No.",Rec."VAT Document No.");
                    if AmendedVAT.Find('-') then
                        page.Run(page::"Amended tax invoices",AmendedVAT)
                    else
                        Message('문서에 해당하는 수정세금계산서가 없습니다.\수정세금계산서 발행버튼을 눌러 진행하세요.');

                end;
            }  
            action(OpenStatementPopbill)
            {
                CaptionML = ENU='Open Statement Document',KOR='명세서 보기';
                Image = LaunchWeb;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;

                trigger OnAction()
                var
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    if Rec.Statement = false then
                        Error('명세서가 발행(요청)되지 않았습니다.\명세서를 열 수 없습니다.');
                    popbill.GetStatementPopUpURL(Rec."VAT Document No.",Rec."Statement Type");
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
                    if (Rec."VAT Document Type" = Rec."VAT Document Type"::Correction) AND
                    (Rec."ETAX Before Document No." <> '') then
                        Error('이 문서는 수정세금계산서 문서입니다.\문서열기를 통해 계산서를 발행하세요.');
                    //2. 계산서 발행.
                    popbill.RegistIssue(Rec,false);
                end;  
            }
            action(RegistStatementIssue)
            {
                CaptionML = ENU='Regist Statement Issue',KOR='전자명세서 발행';
                Image = ElectronicVATExemption;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;              
                trigger OnAction()
                var
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    if Rec."Statement Type".AsInteger() = 0 then
                        Error('전자명세서 유형을 먼저 정의하고 발행하세요.');
                    //1. 계산서 발행 대상인지 체크.
                    if (Rec."Statement Status" = Rec."Statement Status"::"Approval Pending") OR 
                    (Rec."Statement Status" = Rec."Statement Status"::Issued) then
                        Error('이미 전자 명세서 발행이 요청/완료된 건입니다.\문서를 확인하세요.');
                    if (Rec."VAT Document Type" = Rec."VAT Document Type"::Correction) AND
                    (Rec."ETAX Before Document No." <> '') then
                        Error('이 문서는 수정세금계산서 문서입니다.\문서열기를 통해 계산서를 발행하세요.');
                    //2. 명세서 발행.
                    popbill.RegistStatementIssue(Rec);
                end;  
            }           
            action(CancelStatementIssue)
            {
                CaptionML = ENU='Cancel Statement Issue',KOR='전자명세서 발행취소';
                Image = VoidAllElectronicDocuments;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;              
                trigger OnAction()
                var
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    //1. 계산서 발행 대상인지 체크.
                    if Rec.Statement = false then
                        Error('명세서가 발행된 건이 아닙니다.\문서를 확인하세요.');        
                    if (Rec."Statement Status" = Rec."Statement Status"::Canceled) then
                        Error('전자 명세서가 이미 삭제된 건입니다.\문서를 확인하세요.');
                    //2. 명세서 발행.
                    popbill.CancelStatementIssue(Rec);
                end;  
            }                   
            action(DeleteStatementIssue)
            {
                CaptionML = ENU='Delete Statement Issue',KOR='전자명세서 삭제';
                Image = VoidAllElectronicDocuments;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;              
                trigger OnAction()
                var
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    //1. 계산서 발행 대상인지 체크.
                    if Rec.Statement = false then
                        Error('명세서가 발행된 건이 아닙니다.\문서를 확인하세요.');

                    if (Rec."Statement Status" <> Rec."Statement Status"::"Issue Canceled") AND
                    (Rec."Statement Status" <> Rec."Statement Status"::Rejected) AND
                    (Rec."Statement Status" <> Rec."Statement Status"::Saved) then
                        Error('전자 명세서 상태가 발행취소,승인거부,임시저장 인 건에 대해서 삭제 할 수 있습니다.\문서를 확인하세요.');

                    if (Rec."VAT Document Type" = Rec."VAT Document Type"::Correction) AND
                    (Rec."ETAX Before Document No." <> '') then
                        Error('이 문서는 수정세금계산서 문서입니다.\문서열기를 통해 계산서를 발행하세요.');
                    
                    //2. 명세서 삭제.
                    popbill.DeleteStatementIssue(Rec);
                end;  
            }                
            action(AmendedRegistIssue)
            {
                CaptionML = ENU='Amended Tax Invoice Issue',KOR='수정세금계산서 작성';
                Image = VoidElectronicDocument;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;              
                trigger OnAction()
                var
                    AmendedVATLedger : Record "VAT Ledger Entries";
                    VATLedger : Record "VAT Ledger Entries";
                    detailedVAT : Record "detailed VAT Ledger Entries";
                    destVAT : Record "detailed VAT Ledger Entries";
                begin
                    //1. 계산서 발행 대상인지 체크.
                    if Rec."ETAX Document Status" <> Rec."ETAX Document Status"::Issued then
                        Error('수정세금계산서는 이미 발행 완료된 건에 대해 진행하실 수 있습니다.\문서를 확인하세요.');
                    if Rec."VAT Issue Type" = Rec."VAT Issue Type"::Purchase then
                        Error('역발행(매입)계산서는 역발행 요청취소를 통해 처리하시기 바랍니다.'); 
                    //FIXME 수정세금계산서를 또 수정할 수 있음. 안되는 경우를 제외하고 진행할 수 있도록 수정해야 함.    
                    if (Rec."VAT Document Type" = Rec."VAT Document Type"::Correction) AND
                    (Rec."ETAX Before Document No." <> '') then
                        Error('이 문서는 수정세금계산서 문서입니다.\문서를 확인하시고 진행하시기 바랍니다.');

                    //2. 계산서 발행.
                    AmendedVATLedger.Reset();
                    AmendedVATLedger.SetFilter("ETAX Before Document No.",Rec."VAT Document No.");
                    if AmendedVATLedger.Find('-') then
                    begin
                        //기존에 발행된, 수정세금계산서가 있으면,
                        page.Run(page::"Amended tax invoices",AmendedVATLedger);
                    end else 
                    begin
                        //기존에 발행된, 수정세금계산서가 없으면,
                        VATLedger.Init();
                        VATLedger.Insert(true); //신규번호작성후 생성.                        
                        VATLedger.TransferFields(Rec,false); //기존 내용그대로 복사.
                        //수정세금계산서 관련 초기값 셋업.
                        VATLedger."VAT Document Type" := VATLedger."VAT Document Type"::Correction; //수정
                        VATLedger."ETAX Before Document No." := Rec."VAT Document No."; //이전 부가세문서번호
                        VATLedger."ETAX Document Status" := Rec."ETAX Document Status"::Saved; //문서 임시저장
                        VATLedger."ETAX Status Code" := VATLedger."ETAX Status Code"::"Temporary Save"; //전송상태 임시저장
                        VATLedger.Modify();

                        detailedVAT.Reset();
                        detailedVAT.SetRange("VAT Document No.",Rec."VAT Document No.");
                        if detailedVAT.FindSet() then
                        begin
                            repeat
                                destVAT.Init();
                                destVAT.TransferFields(detailedVAT,false);
                                destVAT."VAT Document No." := VATLedger."VAT Document No.";
                                destVAT."Line No." := detailedVAT."Line No.";
                                destVAT.Insert();
                            until detailedVAT.Next() = 0;
                        end;

                        page.Run(page::"Amended tax invoices",AmendedVATLedger);
                    end;                        
                end;  
            }        
            action(CancelRegistIssue)
            {
                CaptionML = ENU='Cancel Purchase Issue',KOR='역발행(매입)문서 발행취소';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;              
                trigger OnAction()
                var
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    //1. 계산서 발행 대상인지 체크.
                    if Rec."VAT Issue Type" = Rec."VAT Issue Type"::Sales then
                        Error('역발행취소 요청은, 매입(역발행)문서에 대해서 요청이 가능합니다.');

                    if (Rec."ETAX Document Status" <> Rec."ETAX Document Status"::Issued) then
                        Error('역발행요청된 문서에 대해서만 취소요청을 하실 수 있습니다.\문서를 확인하세요.');

                    if (Rec."VAT Document Type" = Rec."VAT Document Type"::Correction) AND
                    (Rec."ETAX Before Document No." <> '') then
                        Error('이 문서는 수정세금계산서 문서입니다.\문서를 확인하세요.');
                    
                    //2. 명세서 삭제.
                    popbill.CancelPurchaseIssue(Rec);
                end;  
            }                
            action(DeleteRegistIssue)
            {
                CaptionML = ENU='Delete Purchase Issue',KOR='역발행(매입)문서 삭제요청';
                Image = DeleteQtyToHandle;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;              
                trigger OnAction()
                var
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    //1. 계산서 발행 대상인지 체크.
                    if Rec."VAT Issue Type" = Rec."VAT Issue Type"::Sales then
                        Error('역발행삭제 요청은, 매입(역발행)문서에 대해서 요청이 가능합니다.');

                    if (Rec."ETAX Status Code" <> Rec."ETAX Status Code"::"Issue Canceled") then
                        Error('역발행취소된 문서에 대해서만 삭제요청을 하실 수 있습니다.\먼저 취소요청을 진행하세요.');

                    if (Rec."VAT Document Type" = Rec."VAT Document Type"::Correction) AND
                    (Rec."ETAX Before Document No." <> '') then
                        Error('이 문서는 수정세금계산서 문서입니다.\문서를 확인하세요.');
                    
                    //2. 명세서 삭제.
                    popbill.DeletePurchaseIssue(Rec);
                end;  
            }                
            action(Reload)
            {
                CaptionML = ENU='Reload',KOR='화면새로고침';
                Image = RelatedInformation;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = ALL;    
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;                 
            }    
        }
    }    
    //Status 필드 강조효과.
    trigger OnAfterGetRecord()
    var
        popbill: Codeunit VATPopbillFunctions;
    begin
        if Rec."ETAX Document Status" = Rec."ETAX Document Status"::Issued then
        begin
            if (Rec."ETAX Status Code" = Rec."ETAX Status Code"::"Await Sending") OR
            (Rec."ETAX Status Code" = Rec."ETAX Status Code"::Awaiting) OR
            (Rec."ETAX Status Code" = Rec."ETAX Status Code"::"Before Sending") OR
            (Rec."ETAX Status Code" = Rec."ETAX Status Code"::"Issue Registered") OR
            (Rec."ETAX Status Code" = Rec."ETAX Status Code"::"Issue Canceled") OR
            (Rec."ETAX Status Code" = Rec."ETAX Status Code"::Sending) OR
            (Rec."ETAX Status Code" = Rec."ETAX Status Code"::"Temporary Save") then
                popbill.GetInfo(Rec);
            StyleYN := true;
        end else
            StyleYN := false;
        
        if ((Rec."Statement Status" = Rec."Statement Status"::"Approval Pending") OR 
        (Rec."Statement Status" = Rec."Statement Status"::"Cancellation Request")) AND
        (Rec.Statement = true) then
        begin
            popbill.GetStatementInfo(Rec);
        end;
    end;
    var
        StyleYN: Boolean;
}
