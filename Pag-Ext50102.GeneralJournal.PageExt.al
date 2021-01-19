pageextension 50102 "General Journal" extends "General Journal"
{
    actions
    {
        addfirst(processing)
        {
            action(TaxRegistration)
            {
                CaptionML = ENU='Tax Registration',KOR='부가세등록';
                Image = VATExemptionEntries;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                
                trigger OnAction()
                var
                    VATLedgerEntreis : Record "VAT Ledger Entries";
                    detailedVATLedgerEntreis : Record "detailed VAT Ledger Entries";                
                begin
                    VATLedgerEntreis.Reset();
                    VATLedgerEntreis.SetFilter("Linked Jnl. Template Name",'%1',Rec."Journal Template Name");
                    VATLedgerEntreis.SetFilter("Linked Jnl. Batch Name",'%1',Rec."Journal Batch Name");
                    VATLedgerEntreis.SetFilter("Linked Document No.",'%1',Rec."Document No.");
                    if VATLedgerEntreis.Find('-') then begin
                    end else begin
                        VATLedgerEntreis.Init();
                        VATLedgerEntreis.Insert(true);
                        if Rec."Gen. Posting Type" = Rec."Gen. Posting Type"::Purchase then begin
                            VATLedgerEntreis.Validate("VAT Issue Type",VATLedgerEntreis."VAT Issue Type"::Purchase); //매출/청구
                        end else if Rec."Gen. Posting Type" = Rec."Gen. Posting Type"::Sale then begin
                            VATLedgerEntreis.Validate("VAT Issue Type",VATLedgerEntreis."VAT Issue Type"::Sales); //매출/청구
                        end else begin
                        end;
                        if (Rec."Account Type" = Rec."Account Type"::Customer) OR
                            (Rec."Account Type" = Rec."Account Type"::Vendor) then
                            VATLedgerEntreis.Validate("Account No.",Rec."Account No."); //청구처 입력.

                        VATLedgerEntreis."VAT Date" := Rec."Posting Date";
                        VATLedgerEntreis."VAT Category Code" :='V01'; 
                        VATLedgerEntreis."Linked Document Type" := VATLedgerEntreis."Linked Document Type"::" ";
                        VATLedgerEntreis."Linked Document No." := Rec."Document No.";
                        VATLedgerEntreis."Linked Jnl. Template Name" := Rec."Journal Template Name";
                        VATLedgerEntreis."Linked Jnl. Batch Name" := Rec."Journal Batch Name";
                        VATLedgerEntreis."Linked Jnl. Line No." := Rec."Line No.";
                        if Rec."Currency Code" <> '' then begin
                            VATLedgerEntreis."Currency Code" := Rec."Currency Code";
                            VATLedgerEntreis."Currency Factor" := Rec."Currency Factor";
                            VATLedgerEntreis.Amount_FCY := Rec.Amount;
                        end;
                        VATLedgerEntreis.Modify();

                        detailedVATLedgerEntreis.Init();
                        detailedVATLedgerEntreis."VAT Document Date" := Rec."Posting Date";
                        detailedVATLedgerEntreis."VAT Document No." := VATLedgerEntreis."VAT Document No.";
                        detailedVATLedgerEntreis."Line No." := 10000;
                        detailedVATLedgerEntreis."Actual Amount" := Rec."Amount (LCY)";
                        //Actual 은 부가세 카테코리의 금액을 업데이트하므로, Validate 는 Tax 에 넣어서 진행한다.
                        detailedVATLedgerEntreis."Tax Amount" := Rec."VAT Amount (LCY)";
                        detailedVATLedgerEntreis."Line Total Amount" := detailedVATLedgerEntreis."Actual Amount"+detailedVATLedgerEntreis."Tax Amount";
                        detailedVATLedgerEntreis.Quantity := 1;
                        detailedVATLedgerEntreis."Item Description" := Rec.Description;
                        detailedVATLedgerEntreis.Insert(true);      
                    end;
                    
                    //생성된 부가세 기장번호를 외부문서 번호에 입력합니다.
                    //FIXME 불필요한 경우, 삭제할 것.
                    Rec."External Document No." := VATLedgerEntreis."VAT Document No.";
                    Rec.Modify();

                    if VATLedgerEntreis."VAT Issue Type" = VATLedgerEntreis."VAT Issue Type"::Purchase then
                        Page.Run(Page::"VAT Purchase Document",VATLedgerEntreis)
                    else
                        Page.Run(Page::"VAT Sales Document",VATLedgerEntreis);                          
                end;
            }
        }

    }
}
