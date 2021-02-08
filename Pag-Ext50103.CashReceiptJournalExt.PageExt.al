pageextension 50103 CashReceiptJournalExt extends "Cash Receipt Journal"
{
    actions
    {
        addfirst(processing)
        {
            action(TaxRegistration)
            {
                CaptionML = ENU='Tax Registration',KOR='계산서/부가세등록';
                Image = VATExemptionEntries;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                
                trigger OnAction()
                var
                    VATLedgerEntries : Record "VAT Ledger Entries";
                    iVATLedgerEntries : Record "VAT Ledger Entries";
                    detailedVATLedgerEntries : Record "detailed VAT Ledger Entries";                
                begin
                    iVATLedgerEntries.Reset();
                    iVATLedgerEntries.SetFilter("Linked Jnl. Template Name",'%1',Rec."Journal Template Name");
                    iVATLedgerEntries.SetFilter("Linked Jnl. Batch Name",'%1',Rec."Journal Batch Name");
                    iVATLedgerEntries.SetFilter("Linked Document No.",'%1',Rec."Document No.");
                    if iVATLedgerEntries.IsEmpty then
                    begin
                        VATLedgerEntries.Init();
                        VATLedgerEntries.Insert(true);

                        if (Rec."Gen. Posting Type" = Rec."Gen. Posting Type"::Purchase) OR 
                        (Rec."Account Type" = Rec."Account Type"::Vendor) then 
                        begin
                            VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Purchase); //매출/청구
                        end else if (Rec."Gen. Posting Type" = Rec."Gen. Posting Type"::Sale) OR 
                        (Rec."Account Type" = Rec."Account Type"::Customer) then 
                        begin
                            VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Sales); //매출/청구
                        end;

                        if (Rec."Account Type" = Rec."Account Type"::Customer) OR
                            (Rec."Account Type" = Rec."Account Type"::Vendor) then
                            VATLedgerEntries.Validate("Account No.",Rec."Account No."); //청구처 입력.

                        VATLedgerEntries."VAT Date" := Rec."Posting Date";
                        VATLedgerEntries."VAT Category Code" :='V01'; 
                        VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::" ";
                        VATLedgerEntries."Linked Document No." := Rec."Document No.";
                        VATLedgerEntries."Linked Jnl. Template Name" := Rec."Journal Template Name";
                        VATLedgerEntries."Linked Jnl. Batch Name" := Rec."Journal Batch Name";
                        VATLedgerEntries."Linked Jnl. Line No." := Rec."Line No.";
                        if Rec."Currency Code" <> '' then begin
                            VATLedgerEntries."Currency Code" := Rec."Currency Code";
                            VATLedgerEntries."Currency Factor" := Rec."Currency Factor";
                            VATLedgerEntries.Amount_FCY := Rec.Amount;
                        end;
                        VATLedgerEntries.Modify();

                        detailedVATLedgerEntries.Init();
                        detailedVATLedgerEntries."VAT Document Date" := Rec."Posting Date";
                        detailedVATLedgerEntries."VAT Document No." := VATLedgerEntries."VAT Document No.";
                        detailedVATLedgerEntries."Line No." := 10000;
                        detailedVATLedgerEntries."Actual Amount" := Rec."Amount (LCY)";
                        //Actual 은 부가세 카테코리의 금액을 업데이트하므로, Validate 는 Tax 에 넣어서 진행한다.
                        detailedVATLedgerEntries."Tax Amount" := Rec."VAT Amount (LCY)";
                        detailedVATLedgerEntries."Line Total Amount" := detailedVATLedgerEntries."Actual Amount"+detailedVATLedgerEntries."Tax Amount";
                        detailedVATLedgerEntries.Quantity := 1;
                        detailedVATLedgerEntries."Item Description" := Rec.Description;
                        detailedVATLedgerEntries.Insert(true);      

                        //생성된 부가세 기장번호를 외부문서 번호에 입력합니다.
                        Rec."External Document No." := VATLedgerEntries."VAT Document No.";
                        Rec.Modify();
                        
                        Commit();
                        if VATLedgerEntries."VAT Issue Type" = VATLedgerEntries."VAT Issue Type"::Purchase then
                            Page.RunModal(Page::"VAT Purchase Document",VATLedgerEntries)
                        else
                            Page.RunModal(Page::"VAT Sales Document",VATLedgerEntries);                        
                    end else 
                    begin
                        if iVATLedgerEntries."VAT Issue Type" = iVATLedgerEntries."VAT Issue Type"::Purchase then
                            Page.RunModal(Page::"VAT Purchase Document",iVATLedgerEntries)
                        else
                            Page.RunModal(Page::"VAT Sales Document",iVATLedgerEntries);
                    end;
                        
                end;
            }
        }

    }    
}
