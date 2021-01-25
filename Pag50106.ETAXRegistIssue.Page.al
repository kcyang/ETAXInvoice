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
                field("VAT Document Type"; Rec."VAT Document Type")
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
                    ApplicationArea = All;
                }
                field("ETAX Document Status"; Rec."ETAX Document Status")
                {
                    ApplicationArea = All;
                    Style = StrongAccent;
                    StyleExpr = StyleYN;
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
                field("ETAX Mod Issuer";Rec."ETAX Mod Issuer")
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
            action(AmendedRegistIssue)
            {
                CaptionML = ENU='Amended Tax Invoice Issue',KOR='수정세금계산서 발행';
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
                        VATLedger.Insert(true);                        
                        VATLedger.TransferFields(Rec,false);
                        VATLedger."VAT Document Type" := VATLedger."VAT Document Type"::Correction;
                        VATLedger."ETAX Before Document No." := Rec."VAT Document No.";
                        VATLedger."ETAX Document Status" := Rec."ETAX Document Status"::Saved;
                        VATLedger.Modify();

                        detailedVAT.Reset();
                        detailedVAT.SetRange("VAT Document No.",Rec."VAT Document No.");
                        if detailedVAT.FindSet() then
                        begin
                            repeat
                                destVAT.Init();
                                destVAT.TransferFields(detailedVAT,false);
                                destVAT."VAT Document No." := VATLedger."VAT Document No.";
                                destVAT.Insert();
                            until detailedVAT.Next() = 0;
                        end;

                        page.Run(page::"Amended tax invoices",AmendedVATLedger);
                    end;                        
                end;  
            }            
        }
    }    
    //Status 필드 강조효과.
    trigger OnAfterGetRecord()
    begin
        if Rec."ETAX Document Status" = Rec."ETAX Document Status"::Issued then
            StyleYN := true
        else
            StyleYN := false;
    end;
    var
        StyleYN: Boolean;
}
