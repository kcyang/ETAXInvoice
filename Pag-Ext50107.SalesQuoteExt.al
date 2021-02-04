pageextension 50107 "Sales Quote Ext." extends "Sales Quote"
{
    actions
    {
        addfirst(processing)
        {
            action(MakeStatements)
            {
                ApplicationArea = All;
                CaptionML = ENU='Create Statement',KOR='전자 명세서 생성';
                Image = BankAccountStatement;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = '전자명세서를 생성합니다.생성된 명세서는 등록된 부가세기장 또는 전자세금계산서 발행에서 확인해 볼 수 있습니다.';

                trigger OnAction()
                var
                    VATLedgerEntries : Record "VAT Ledger Entries";
                    detailedVATLedgerEntries : Record "detailed VAT Ledger Entries";
                    SalesLines: Record "Sales Line";                
                    LineNo: Integer;
                begin
                    VATLedgerEntries.Reset();
                    //견적.
                    VATLedgerEntries.SetFilter("Linked Document Type",'%1',VATLedgerEntries."Linked Document Type"::Quote);
                    //견적 번호.
                    VATLedgerEntries.SetFilter("Linked Document No.",'%1',Rec."No.");
                    if VATLedgerEntries.IsEmpty then
                    begin
                        VATLedgerEntries.Init();
                        VATLedgerEntries.Insert(true);

                        VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Sales); //매출/청구
                        VATLedgerEntries.Validate("Account No.",Rec."Bill-to Customer No."); //청구처 입력.

                        VATLedgerEntries."VAT Date" := Rec."Order Date";
                        VATLedgerEntries."VAT Category Code" :='V01'; 
                        VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::Quote;
                        VATLedgerEntries."Linked Document No." := Rec."No.";
                        if Rec."Currency Code" <> '' then begin
                            VATLedgerEntries."Currency Code" := Rec."Currency Code";
                            VATLedgerEntries."Currency Factor" := Rec."Currency Factor";
                            VATLedgerEntries.Amount_FCY := Rec.Amount;
                        end;
                        VATLedgerEntries."Statement Type" := VATLedgerEntries."Statement Type"::Estimate;
                        VATLedgerEntries.Modify();

                        SalesLines.Reset();
                        SalesLines.SetRange("Document No.",Rec."No.");

                        if SalesLines.FindSet() then
                        begin
                            repeat
                                LineNo += 10000;
                                detailedVATLedgerEntries.Init();
                                detailedVATLedgerEntries."VAT Document Date" := Rec."Order Date";
                                detailedVATLedgerEntries."VAT Document No." := VATLedgerEntries."VAT Document No.";
                                detailedVATLedgerEntries."Line No." := LineNo;
                                detailedVATLedgerEntries.Quantity := SalesLines.Quantity;
                                detailedVATLedgerEntries."Unit price" := SalesLines."Unit Price";                                
                                detailedVATLedgerEntries."Actual Amount" := SalesLines.Amount;
                                detailedVATLedgerEntries."Tax Amount" := SalesLines."Amount Including VAT" - SalesLines.Amount;
                                detailedVATLedgerEntries."Line Total Amount" := detailedVATLedgerEntries."Actual Amount"+detailedVATLedgerEntries."Tax Amount";
                                detailedVATLedgerEntries."Item Description" := SalesLines.Description+' '+SalesLines."Description 2";
                                detailedVATLedgerEntries.Insert(true);      
                            until SalesLines.Next() = 0;
                        end;
                    end else if VATLedgerEntries.Find('-') then
                    begin
                        if VATLedgerEntries.Statement then
                        begin
                            Message('이미 발행요청된 명세서가 있습니다. 작성/수정은 되지 않고 해당 문서를 엽니다.');
                        end else begin
                            VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Sales); //매출/청구
                            VATLedgerEntries.Validate("Account No.",Rec."Bill-to Customer No."); //청구처 입력.
                            VATLedgerEntries."Statement Type" := VATLedgerEntries."Statement Type"::Estimate;
                            VATLedgerEntries."VAT Date" := Rec."Order Date";
                            VATLedgerEntries."VAT Category Code" :='V01'; 
                            if Rec."Currency Code" <> '' then begin
                                VATLedgerEntries."Currency Code" := Rec."Currency Code";
                                VATLedgerEntries."Currency Factor" := Rec."Currency Factor";
                                VATLedgerEntries.Amount_FCY := Rec.Amount;
                            end;
                            VATLedgerEntries.Modify();

                            detailedVATLedgerEntries.Reset();
                            detailedVATLedgerEntries.SetRange("VAT Document No.",VATLedgerEntries."VAT Document No.");
                            detailedVATLedgerEntries.DeleteAll();

                            SalesLines.Reset();
                            SalesLines.SetRange("Document No.",Rec."No.");

                            if SalesLines.FindSet() then
                            begin
                                repeat
                                    LineNo += 10000;
                                    detailedVATLedgerEntries.Init();
                                    detailedVATLedgerEntries."VAT Document Date" := Rec."Order Date";
                                    detailedVATLedgerEntries."VAT Document No." := VATLedgerEntries."VAT Document No.";
                                    detailedVATLedgerEntries."Line No." := LineNo;
                                    detailedVATLedgerEntries.Quantity := SalesLines.Quantity;
                                    detailedVATLedgerEntries."Unit price" := SalesLines."Unit Price";                                                                                                
                                    detailedVATLedgerEntries."Actual Amount" := SalesLines.Amount;
                                    detailedVATLedgerEntries."Tax Amount" := SalesLines."Amount Including VAT" - SalesLines.Amount;
                                    detailedVATLedgerEntries."Line Total Amount" := detailedVATLedgerEntries."Actual Amount"+detailedVATLedgerEntries."Tax Amount";
                                    detailedVATLedgerEntries."Item Description" := SalesLines.Description+' '+SalesLines."Description 2";
                                    detailedVATLedgerEntries.Insert(true);      
                                until SalesLines.Next() = 0;
                            end;
                        end;
                    end;
                    Commit();                                                                  
                    Page.RunModal(Page::"VAT Sales Document",VATLedgerEntries);                          
                end;
            }
        }
    }    
}
