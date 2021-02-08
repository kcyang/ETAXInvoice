pageextension 50110 SalesCrMemoExt extends "Posted Sales Credit Memo"
{
    actions
    {
        addfirst(processing)
        {
            action(MakeStatements)
            {
                ApplicationArea = All;
                CaptionML = ENU='Create Statement',KOR='세금계산서/명세서 생성';
                Image = BankAccountStatement;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = '전자명세서/계산서를 생성합니다.생성된 명세서는 등록된 부가세기장 또는 전자세금계산서 발행에서 확인해 볼 수 있습니다.';

                trigger OnAction()
                var
                    VATLedgerEntries : Record "VAT Ledger Entries";
                    detailedVATLedgerEntries : Record "detailed VAT Ledger Entries";
                    SalesLines: Record "Sales Cr.Memo Line";                
                    LineNo: Integer;
                begin
                    VATLedgerEntries.Reset();
                    if Rec."Return Order No." <> '' then
                        VATLedgerEntries.SetFilter("Linked Document Type",'%1',VATLedgerEntries."Linked Document Type"::"Return Order")
                    else
                        VATLedgerEntries.SetFilter("Linked Document Type",'%1',VATLedgerEntries."Linked Document Type"::"Credit Memo");
                    VATLedgerEntries.SetFilter("Linked Document No.",'%1',Rec."No.");
                    if VATLedgerEntries.IsEmpty then
                    begin
                        if not Dialog.Confirm('발행된 계산서/명세서가 없습니다. 해당 문서를 생성하시겠습니까?',true) then
                            exit;                        
                        VATLedgerEntries.Init();
                        VATLedgerEntries.Insert(true);

                        VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Sales); //매출/청구
                        VATLedgerEntries.Validate("Account No.",Rec."Bill-to Customer No."); //청구처 입력.

                        VATLedgerEntries."VAT Date" := Rec."Posting Date";
                        VATLedgerEntries."VAT Category Code" :='V01'; 
                        if Rec."Return Order No." <> '' then
                            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::"Return Order"
                        else
                            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::"Credit Memo";

                        VATLedgerEntries."Linked Document No." := Rec."No.";
                        if Rec."Currency Code" <> '' then begin
                            VATLedgerEntries."Currency Code" := Rec."Currency Code";
                            VATLedgerEntries."Currency Factor" := Rec."Currency Factor";
                            VATLedgerEntries.Amount_FCY := Rec.Amount;
                        end;
                        //VATLedgerEntries."Statement Type" := VATLedgerEntries."Statement Type"::Estimate;
                        VATLedgerEntries.Modify();

                        SalesLines.Reset();
                        SalesLines.SetRange("Document No.",Rec."No.");

                        if SalesLines.FindSet() then
                        begin
                            repeat
                                LineNo += 10000;
                                detailedVATLedgerEntries.Init();
                                detailedVATLedgerEntries."VAT Document Date" := Rec."Posting Date";
                                detailedVATLedgerEntries."VAT Document No." := VATLedgerEntries."VAT Document No.";
                                detailedVATLedgerEntries."Line No." := LineNo;
                                detailedVATLedgerEntries.Quantity := SalesLines.Quantity;
                                detailedVATLedgerEntries."Unit price" := SalesLines."Unit Price";                                
                                detailedVATLedgerEntries."Actual Amount" := -SalesLines.Amount;
                                detailedVATLedgerEntries."Tax Amount" := -(SalesLines."Amount Including VAT" - SalesLines.Amount);
                                detailedVATLedgerEntries."Line Total Amount" := detailedVATLedgerEntries."Actual Amount"+detailedVATLedgerEntries."Tax Amount";
                                detailedVATLedgerEntries."Item Description" := SalesLines.Description+' '+SalesLines."Description 2";
                                detailedVATLedgerEntries.Insert(true);      
                            until SalesLines.Next() = 0;
                        end;
                        Commit();                                                                  
                    end else if VATLedgerEntries.Find('-') then
                    begin
                        if not Dialog.Confirm('이미 발행된 계산서/명세서가 있습니다. 해당 문서를 여시겠습니까?',true) then
                            exit;
                    end;
                    Page.RunModal(Page::"VAT Sales Document",VATLedgerEntries);                          
                end;
            }            
        }
    }    
}
