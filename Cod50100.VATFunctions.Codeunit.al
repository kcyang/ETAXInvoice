/*
주문서에서, Posting 한 후 부가세 컨트롤.

TODO Service Order, Service Invoice
TODO Service Credit Memo, Service Return Order
*/
codeunit 50100 "VAT Functions"
{
/*  //아래 procedure 는, posting 후에 라인을 삭제하는 경우에도 동작하기 때문에,
    //FIXME disable 하고, 추후에 다른 기능으로 진행할 것.
    //General Journal 에서 라인을 삭제하는 경우, 관련 내용이 있는경우, 삭제한다.
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteJournalLine(var Rec: Record "Gen. Journal Line")
    var
      VATLedgerEntries: Record "VAT Ledger Entries";
    begin
      VATLedgerEntries.Reset();
      VATLedgerEntries.SetFilter("Linked Jnl. Template Name",'%1',Rec."Journal Template Name");
      VATLedgerEntries.SetFilter("Linked Jnl. Batch Name",'%1',Rec."Journal Batch Name");
      VATLedgerEntries.SetFilter("Linked Jnl. Line No.",'%1',Rec."Line No.");
      VATLedgerEntries.SetFilter("Linked Document No.",'%1',Rec."Document No.");
      if VATLedgerEntries.FindSet() then begin
      repeat
        VATLedgerEntries.Delete(true);
      until VATLedgerEntries.Next() = 0;
      end;
    end;
*/
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Document No.', false, false)]
    local procedure OnAfterValidateGeneralJournalLineEvent(var Rec: Record "Gen. Journal Line";var xRec: Record "Gen. Journal Line")
    var
      VATLedgerEntries: Record "VAT Ledger Entries";
    begin
      VATLedgerEntries.Reset();
      VATLedgerEntries.SetFilter("Linked Jnl. Template Name",'%1',Rec."Journal Template Name");
      VATLedgerEntries.SetFilter("Linked Jnl. Batch Name",'%1',Rec."Journal Batch Name");
      VATLedgerEntries.SetFilter("Linked Jnl. Line No.",'%1',Rec."Line No.");
      //변경되기 전 문서번호를 찾아야 함.
      VATLedgerEntries.SetFilter("Linked Document No.",'%1',xRec."Document No.");
      if VATLedgerEntries.Find('-') then begin
        VATLedgerEntries."Linked Document No." := Rec."Document No.";
        VATLedgerEntries."VAT Date" := Rec."Posting Date";
        VATLedgerEntries.Modify();
      end;      
    end;

    //Sales Order, Sales Invoice
    //SalesPost 가 마무리 된 후, invoice 문서에 대해서..
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '',false,false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
    var
      VATInformation: Record "VAT Basic Information";   
      SalesInvoice: Record "Sales Invoice Header"; 
      SalesCrMemo: Record "Sales Cr.Memo Header";
      VATCompany: Record "VAT Company";
    begin
      VATCompany.Reset();
      if VATCompany.Find('-') then
      begin
        //송장처리할 때, 처리하도록 함.
        if ((SalesInvHdrNo <> '') OR (SalesCrMemoHdrNo <> '')) AND VATCompany.InvoiceIssued then 
        begin
          VATInformation.Reset();
          VATInformation.SetRange("Table ID",Database::Customer);
          //계산서 발행은, 청구처를 기준으로.
          VATInformation.SetRange("No.",SalesHeader."Bill-to Customer No.");

          //하나만 찾으면 됨.
          if VATInformation.Find('-') then begin
            if VATInformation."VAT Type" = VATInformation."VAT Type"::Line then begin
              if Dialog.Confirm('%1 고객에 대해 계산서 발행을 위한 부가정보를 등록하시겠습니까?',true,SalesHeader."Bill-to Name") then begin
                case SalesHeader."Document Type" of
                  SalesHeader."Document Type"::Order,SalesHeader."Document Type"::Invoice:
                    begin
                      SalesInvoice.Reset();
                      if SalesInvoice.get(SalesInvHdrNo) then
                        CreateSalesVATLedgerEntries(SalesHeader."Document Type",SalesInvoice,SalesCrMemo,VATInformation);
                    end;
                  SalesHeader."Document Type"::"Credit Memo",SalesHeader."Document Type"::"Return Order":
                    begin
                      SalesCrMemo.Reset();
                      if SalesCrMemo.get(SalesCrMemoHdrNo) then
                        CreateSalesVATLedgerEntries(SalesHeader."Document Type",SalesInvoice,SalesCrMemo,VATInformation);
                    end;
                  else;
                end; //CASE End;
              end; //Dialog Confirm
            end; //VAT Type::Line
          end; //VATInformation.Find()      
        end;
      end else 
        ;
    end; //End Procedure.

    //Purchase Order, Purchase Invoice
    //Purchase Post 가 마무리 된 후, invoice 문서에 대해서..    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
      VATInformation: Record "VAT Basic Information";   
      PurchInvoice: Record "Purch. Inv. Header"; 
      PurchCrMemo: Record "Purch. Cr. Memo Hdr.";
      VATCompany: Record "VAT Company";      
    begin
      VATCompany.Reset();
      if VATCompany.Find('-') then
      begin      
        //송장처리할 때에만 동작하도록 함.
        if ((PurchInvHdrNo <> '') OR (PurchCrMemoHdrNo <> '')) AND VATCompany.InvoiceIssued then 
        begin
          VATInformation.Reset();
          VATInformation.SetRange("Table ID",Database::Vendor);
          //계산서 발행은, 청구처를 기준으로.
          VATInformation.SetRange("No.",PurchaseHeader."Pay-to Vendor No.");

          //하나만 찾으면 됨.
          if VATInformation.Find('-') then begin
            if VATInformation."VAT Type" = VATInformation."VAT Type"::Line then begin
              if Dialog.Confirm('%1 고객에 대해 계산서 발행을 위한 부가정보를 등록하시겠습니까?',true,PurchaseHeader."Pay-to Name") then begin
                case PurchaseHeader."Document Type" of
                  PurchaseHeader."Document Type"::Order,PurchaseHeader."Document Type"::Invoice:
                    begin
                      PurchInvoice.Reset();
                      if PurchInvoice.get(PurchInvHdrNo) then
                        CreatePurchVATLedgerEntries(PurchaseHeader."Document Type",PurchInvoice,PurchCrMemo,VATInformation);
                    end;
                  PurchaseHeader."Document Type"::"Credit Memo",PurchaseHeader."Document Type"::"Return Order":
                    begin
                      PurchCrMemo.Reset();
                      if PurchCrMemo.get(PurchCrMemoHdrNo) then
                        CreatePurchVATLedgerEntries(PurchaseHeader."Document Type",PurchInvoice,PurchCrMemo,VATInformation);
                    end;
                  else;
                end; //CASE End;
              end; //Dialog Confirm
            end; //VAT Type::Line
          end; //VATInformation.Find()      
        end;
      end;
    end; //End Procedure.
    
    
    /// <summary>
    /// 매출 주문,송장에 대한 부가세Entry 를 입력하는 procedure.
    /// </summary>
    /// <param name="SalesDocumentType">매출 문서유형에 따라, 가져올 대상을 정합니다.</param>
    /// <param name="SalesHeader">Sales Order, Sales Invoice 인 경우, 이 레코드 값을 취합니다.</param>
    /// <param name="SalesCrMemo">Sales Credit Memo, Sales Return Order 인 경우, 이 레코드 값을 취합니다.</param>
    /// <param name="VATInformation">부가세 관련정보가 있는 마스터항목입니다.</param>
    local procedure CreateSalesVATLedgerEntries(SalesDocumentType: Enum "Sales Document Type";SalesHeader: Record "Sales Invoice Header";SalesCrMemo: Record "Sales Cr.Memo Header";VATInformation: Record "VAT Basic Information")
    var
      VATLedgerEntries : Record "VAT Ledger Entries";
      detailedVATLedgerEntries : Record "detailed VAT Ledger Entries";
      SalesLines: Record "Sales Invoice Line";
      SalesCrLines: Record "Sales Cr.Memo Line";
      SalesLineCnt: Integer;
      SalesLineDescription: Text[300];
      LineNo: Integer;
    begin
      Clear(SalesLineCnt);
      Clear(SalesLineDescription);
      Clear(LineNo);

      CASE SalesDocumentType of
        SalesDocumentType::Order,SalesDocumentType::Invoice:
        begin
          VATLedgerEntries.Init();
          VATLedgerEntries.Insert(true); //VAT No. / VAT Company Information 입력.      
          VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Sales); //매출/청구
          VATLedgerEntries.Validate("Account No.",SalesHeader."Bill-to Customer No."); //청구처 입력.
          VATLedgerEntries."VAT Category Code" :='V01'; ///FIXME 설정으로 처리할 방법은 없는가? 
          if SalesDocumentType = SalesDocumentType::Order then
            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::Order
          else
            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::Invoice;
          VATLedgerEntries."Linked Document No." := SalesHeader."No.";
          VATLedgerEntries."Linked External Document No." := SalesHeader."External Document No.";
          VATLedgerEntries.Modify();

          //Line 항목 넣기.
          SalesLines.Reset();
          SalesLines.SetRange("Document No.",SalesHeader."No.");
          if SalesLines.FindSet() then
          begin
            LineNo := 0;
            repeat
              LineNo += 10000;
              detailedVATLedgerEntries.Init();
              detailedVATLedgerEntries."VAT Document Date" := SalesHeader."Posting Date";
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
        SalesDocumentType::"Credit Memo",SalesDocumentType::"Return Order":
        begin
          VATLedgerEntries.Init();
          VATLedgerEntries.Insert(true); //VAT No. / VAT Company Information 입력.      
          VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Sales); //매출/청구
          VATLedgerEntries.Validate("Account No.",SalesCrMemo."Bill-to Customer No."); //청구처 입력.
          VATLedgerEntries."VAT Category Code" :='V01'; ///FIXME 설정으로 처리할 방법은 없는가? 
          if SalesDocumentType = SalesDocumentType::"Credit Memo" then
            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::"Credit Memo"
          else
            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::"Return Order";
          VATLedgerEntries."Linked Document No." := SalesCrMemo."No.";
          VATLedgerEntries."Linked External Document No." := SalesCrMemo."External Document No.";
          VATLedgerEntries.Modify();

          SalesCrLines.Reset();
          SalesCrLines.SetRange("Document No.",SalesCrMemo."No.");
          if SalesCrLines.FindSet() then
          begin
            LineNo := 0;
            repeat
              LineNo += 10000;
              detailedVATLedgerEntries.Init();
              detailedVATLedgerEntries."VAT Document Date" := SalesCrMemo."Posting Date";
              detailedVATLedgerEntries."VAT Document No." := VATLedgerEntries."VAT Document No.";
              detailedVATLedgerEntries."Line No." := LineNo;
              detailedVATLedgerEntries.Quantity := SalesCrLines.Quantity;
              detailedVATLedgerEntries."Unit price" := SalesCrLines."Unit Price";                                
              detailedVATLedgerEntries."Actual Amount" := -SalesCrLines.Amount;
              detailedVATLedgerEntries."Tax Amount" := -(SalesCrLines."Amount Including VAT" - SalesCrLines.Amount);
              detailedVATLedgerEntries."Line Total Amount" := detailedVATLedgerEntries."Actual Amount"+detailedVATLedgerEntries."Tax Amount";
              detailedVATLedgerEntries."Item Description" := SalesCrLines.Description+' '+SalesCrLines."Description 2";
              detailedVATLedgerEntries.Insert(true);                
            until SalesCrLines.Next() = 0;
          end;          
        end; 
        else;
      END;

      Page.Run(Page::"VAT Sales Document",VATLedgerEntries);

    end;

    /// <summary>
    /// 매입 주문,송장에 대한 부가세Entry 를 입력하는 procedure.
    /// </summary>
    /// <param name="PurchDocumentType">매입 문서유형에 따라, 가져올 대상을 정합니다.</param>
    /// <param name="PurchHeader">Pruchase Order, Pruchase Invoice 인 경우, 이 레코드 값을 취합니다.</param>
    /// <param name="PurchCrMemo">Pruchase Credit Memo, Pruchase Return Order 인 경우, 이 레코드 값을 취합니다.</param>
    /// <param name="VATInformation">부가세 관련정보가 있는 마스터항목입니다.</param>
    local procedure CreatePurchVATLedgerEntries(PurchDocumentType: Enum "Purchase Document Type";PurchHeader: Record "Purch. Inv. Header";PurchCrMemo: Record "Purch. Cr. Memo Hdr.";VATInformation: Record "VAT Basic Information")
    var
      VATLedgerEntries : Record "VAT Ledger Entries";
      detailedVATLedgerEntries : Record "detailed VAT Ledger Entries";
      PurchLines: Record "Purch. Inv. Line";
      PurchCrLines: Record "Purch. Cr. Memo Line";
      PurchLineCnt: Integer;
      PurchLineDescription: Text[300];
      LineNo: Integer;
    begin
      Clear(PurchLineCnt);
      Clear(PurchLineDescription);
      Clear(LineNo);

      CASE PurchDocumentType of
        PurchDocumentType::Order,PurchDocumentType::Invoice:
        begin
          VATLedgerEntries.Init();
          VATLedgerEntries.Insert(true); //VAT No. / VAT Company Information 입력.      
          VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Purchase); //매출/청구
          VATLedgerEntries.Validate("Account No.",PurchHeader."Pay-to Vendor No."); //매입처 입력.
          VATLedgerEntries."VAT Category Code" :='V01'; ///FIXME 설정으로 처리할 방법은 없는가? 
          if PurchDocumentType = PurchDocumentType::Order then
            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::Order
          else
            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::Invoice;
          VATLedgerEntries."Linked Document No." := PurchHeader."No.";
          VATLedgerEntries."Linked External Document No." := PurchHeader."Vendor Invoice No.";
          VATLedgerEntries.Modify();

          PurchLines.Reset();
          PurchLines.SetRange("Document No.",PurchHeader."No.");
          if PurchLines.FindSet() then 
          begin
            LineNo := 0;
            repeat
              LineNo += 10000;
              detailedVATLedgerEntries.Init();
              detailedVATLedgerEntries."VAT Document Date" := PurchHeader."Posting Date";
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
        end;
        PurchDocumentType::"Credit Memo",PurchDocumentType::"Return Order":
        begin
          VATLedgerEntries.Init();
          VATLedgerEntries.Insert(true); //VAT No. / VAT Company Information 입력.      
          VATLedgerEntries.Validate("VAT Issue Type",VATLedgerEntries."VAT Issue Type"::Purchase); //매출/청구
          VATLedgerEntries.Validate("Account No.",PurchCrMemo."Pay-to Vendor No."); //청구처 입력.
          VATLedgerEntries."VAT Category Code" :='V01'; ///FIXME 설정으로 처리할 방법은 없는가? 
          if PurchDocumentType = PurchDocumentType::"Credit Memo" then
            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::"Credit Memo"
          else
            VATLedgerEntries."Linked Document Type" := VATLedgerEntries."Linked Document Type"::"Return Order";
          VATLedgerEntries."Linked Document No." := PurchCrMemo."No.";
          VATLedgerEntries."Linked External Document No." := PurchCrMemo."Vendor Cr. Memo No.";
          VATLedgerEntries.Modify();

          PurchCrLines.Reset();
          PurchCrLines.SetRange("Document No.",PurchCrMemo."No.");
          if PurchCrLines.FindSet() then 
          begin
            LineNo := 0;
            repeat
              LineNo += 10000;
              detailedVATLedgerEntries.Init();
              detailedVATLedgerEntries."VAT Document Date" := PurchCrMemo."Posting Date";
              detailedVATLedgerEntries."VAT Document No." := VATLedgerEntries."VAT Document No.";
              detailedVATLedgerEntries."Line No." := LineNo;
              detailedVATLedgerEntries.Quantity := PurchCrLines.Quantity;
              detailedVATLedgerEntries."Unit price" := PurchCrLines."Unit Cost (LCY)";                                
              detailedVATLedgerEntries."Actual Amount" := -PurchCrLines.Amount;
              detailedVATLedgerEntries."Tax Amount" := -(PurchCrLines."Amount Including VAT" - PurchCrLines.Amount);
              detailedVATLedgerEntries."Line Total Amount" := detailedVATLedgerEntries."Actual Amount"+detailedVATLedgerEntries."Tax Amount";
              detailedVATLedgerEntries."Item Description" := PurchCrLines.Description+' '+PurchCrLines."Description 2";
              detailedVATLedgerEntries.Insert(true);     
            until PurchCrLines.Next() = 0;
          end;
        end; 
        else;
      END;
      Page.Run(Page::"VAT Purchase Document",VATLedgerEntries);

    end;
}
