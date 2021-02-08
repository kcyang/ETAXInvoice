pageextension 50109 "Purchase Invoice Ext" extends "Posted Purchase Invoice"
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
                    PurchLines: Record "Purch. Inv. Line";                
                    LineNo: Integer;
                begin
                    VATLedgerEntries.Reset();
                    VATLedgerEntries.SetFilter("Linked Document Type",'%1',VATLedgerEntries."Linked Document Type"::Order);
                    VATLedgerEntries.SetFilter("Linked Document No.",'%1',Rec."No.");
                    if VATLedgerEntries.IsEmpty then
                    begin
                        if not Dialog.Confirm('발행된 계산서/명세서가 없습니다. 해당 문서를 생성하시겠습니까?',true) then
                            exit;                        
                        VATLedgerEntries.Init();
                        VATLedgerEntries.Insert(true);

                        VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Purchase); //매출/청구
                        VATLedgerEntries.Validate("Account No.",Rec."Pay-to Vendor No."); //청구처 입력.

                        VATLedgerEntries."VAT Date" := Rec."Posting Date";
                        VATLedgerEntries."VAT Category Code" :='V01'; 
                        VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::Order;
                        VATLedgerEntries."Linked Document No." := Rec."No.";
                        if Rec."Currency Code" <> '' then begin
                            VATLedgerEntries."Currency Code" := Rec."Currency Code";
                            VATLedgerEntries."Currency Factor" := Rec."Currency Factor";
                            VATLedgerEntries.Amount_FCY := Rec.Amount;
                        end;
                        //VATLedgerEntries."Statement Type" := VATLedgerEntries."Statement Type"::Estimate;
                        VATLedgerEntries.Modify();

                        PurchLines.Reset();
                        PurchLines.SetRange("Document No.",Rec."No.");

                        if PurchLines.FindSet() then
                        begin
                            repeat
                                LineNo += 10000;
                                detailedVATLedgerEntries.Init();
                                detailedVATLedgerEntries."VAT Document Date" := Rec."Posting Date";
                                detailedVATLedgerEntries."VAT Document No." := VATLedgerEntries."VAT Document No.";
                                detailedVATLedgerEntries."Line No." := LineNo;
                                detailedVATLedgerEntries.Quantity := PurchLines.Quantity;
                                detailedVATLedgerEntries."Unit price" := PurchLines."Unit Cost (LCY)";                                
                                detailedVATLedgerEntries."Actual Amount" := PurchLines.Amount;
                                detailedVATLedgerEntries."Tax Amount" := PurchLines."Amount Including VAT" - PurchLines.Amount;
                                detailedVATLedgerEntries."Line Total Amount" := detailedVATLedgerEntries."Actual Amount"+detailedVATLedgerEntries."Tax Amount";
                                detailedVATLedgerEntries."Item Description" := PurchLines.Description+' '+PurchLines."Description 2";
                                detailedVATLedgerEntries.Insert(true);      
                            until PurchLines.Next() = 0;
                        end;
                        Commit();                                                                  
                    end else if VATLedgerEntries.Find('-') then
                    begin
                        if not Dialog.Confirm('이미 발행된 계산서/명세서가 있습니다. 해당 문서를 여시겠습니까?',true) then
                            exit;
                    end;
                    Page.RunModal(Page::"VAT Purchase Document",VATLedgerEntries);                          
                end;
            }            
        }
    }    
}
