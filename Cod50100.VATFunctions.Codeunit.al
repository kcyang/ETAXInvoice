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
                      CreateSalesVATLedgerEntreis(SalesHeader."Document Type",SalesInvoice,SalesCrMemo,VATInformation);
                  end;
                SalesHeader."Document Type"::"Credit Memo",SalesHeader."Document Type"::"Return Order":
                  begin
                    SalesCrMemo.Reset();
                    if SalesCrMemo.get(SalesCrMemoHdrNo) then
                      CreateSalesVATLedgerEntreis(SalesHeader."Document Type",SalesInvoice,SalesCrMemo,VATInformation);
                  end;
                else;
              end; //CASE End;
            end; //Dialog Confirm
          end; //VAT Type::Line
        end; //VATInformation.Find()      
    end; //End Procedure.

    //Purchase Order, Purchase Invoice
    //Purchase Post 가 마무리 된 후, invoice 문서에 대해서..    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
      VATInformation: Record "VAT Basic Information";   
      PurchInvoice: Record "Purch. Inv. Header"; 
      PurchCrMemo: Record "Purch. Cr. Memo Hdr.";
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
                      CreatePurchVATLedgerEntreis(PurchaseHeader."Document Type",PurchInvoice,PurchCrMemo,VATInformation);
                  end;
                PurchaseHeader."Document Type"::"Credit Memo",PurchaseHeader."Document Type"::"Return Order":
                  begin
                    PurchCrMemo.Reset();
                    if PurchCrMemo.get(PurchCrMemoHdrNo) then
                      CreatePurchVATLedgerEntreis(PurchaseHeader."Document Type",PurchInvoice,PurchCrMemo,VATInformation);
                  end;
                else;
              end; //CASE End;
            end; //Dialog Confirm
          end; //VAT Type::Line
        end; //VATInformation.Find()      
    end; //End Procedure.
    
    
    /// <summary>
    /// 매출 주문,송장에 대한 부가세Entry 를 입력하는 procedure.
    /// </summary>
    /// <param name="SalesDocumentType">매출 문서유형에 따라, 가져올 대상을 정합니다.</param>
    /// <param name="SalesHeader">Sales Order, Sales Invoice 인 경우, 이 레코드 값을 취합니다.</param>
    /// <param name="SalesCrMemo">Sales Credit Memo, Sales Return Order 인 경우, 이 레코드 값을 취합니다.</param>
    /// <param name="VATInformation">부가세 관련정보가 있는 마스터항목입니다.</param>
    local procedure CreateSalesVATLedgerEntreis(SalesDocumentType: Enum "Sales Document Type";SalesHeader: Record "Sales Invoice Header";SalesCrMemo: Record "Sales Cr.Memo Header";VATInformation: Record "VAT Basic Information")
    var
      VATLedgerEntreis : Record "VAT Ledger Entries";
      detailedVATLedgerEntreis : Record "detailed VAT Ledger Entries";
      SalesLines: Record "Sales Invoice Line";
      SalesCrLines: Record "Sales Cr.Memo Line";
      SalesLineCnt: Integer;
      SalesLineDescription: Text[300];
    begin
      Clear(SalesLineCnt);
      Clear(SalesLineDescription);

      CASE SalesDocumentType of
        SalesDocumentType::Order,SalesDocumentType::Invoice:
        begin
#region - 라인축약을 위한 구분.          
          //... 외 ..건 Description 을 위해 Sales Line 뒤지기.
          SalesLines.Reset();
          SalesLines.SetRange("Document No.",SalesHeader."No.");
          SalesLines.SetFilter(Type,'%1..%2',SalesLines.Type::"G/L Account",SalesLines.Type::"Fixed Asset");

          if SalesLines.FindSet() then begin
          repeat
            SalesLineCnt += 1;
            if SalesLineCnt = 1 then
              SalesLineDescription := SalesLines.Description;
          until SalesLines.Next() = 0; 
          end;
          SalesLineDescription += StrSubstNo('외 %1건',SalesLineCnt);          
#endregion
          VATLedgerEntreis.Init();
          VATLedgerEntreis.Insert(true); //VAT No. / VAT Company Information 입력.      
          VATLedgerEntreis.Validate("VAT Issue Type",VATLedgerEntreis."VAT Issue Type"::Sales); //매출/청구
          VATLedgerEntreis.Validate("Account No.",SalesHeader."Bill-to Customer No."); //청구처 입력.
          VATLedgerEntreis."VAT Category Code" :='V01'; ///FIXME 설정으로 처리할 방법은 없는가? 
          if SalesDocumentType = SalesDocumentType::Order then
            VATLedgerEntreis."Linked Document Type" := VATLedgerEntreis."Linked Document Type"::Order
          else
            VATLedgerEntreis."Linked Document Type" := VATLedgerEntreis."Linked Document Type"::Invoice;
          VATLedgerEntreis."Linked Document No." := SalesHeader."No.";
          VATLedgerEntreis."Linked External Document No." := SalesHeader."External Document No.";
          VATLedgerEntreis.Modify();

          SalesHeader.CalcFields(Amount,"Amount Including VAT");
#region - 디테일라인 입력구간
          detailedVATLedgerEntreis.Init();
          detailedVATLedgerEntreis."VAT Document Date" := SalesHeader."Posting Date";
          detailedVATLedgerEntreis."VAT Document No." := VATLedgerEntreis."VAT Document No.";
          detailedVATLedgerEntreis."Line No." := 10000;
          detailedVATLedgerEntreis."Actual Amount" := SalesHeader.Amount;
          //Actual 은 부가세 카테코리의 금액을 업데이트하므로, Validate 는 Tax 에 넣어서 진행한다.
          detailedVATLedgerEntreis."Tax Amount" := SalesHeader."Amount Including VAT" - SalesHeader.Amount;
          detailedVATLedgerEntreis."Line Total Amount" := detailedVATLedgerEntreis."Actual Amount"+detailedVATLedgerEntreis."Tax Amount";
          detailedVATLedgerEntreis.Quantity := 1;
          detailedVATLedgerEntreis."Item Description" := SalesLineDescription;
          detailedVATLedgerEntreis.Insert(true);          
#endregion
        end;
        SalesDocumentType::"Credit Memo",SalesDocumentType::"Return Order":
        begin
#region - 라인축약을 위한 구분.          
          //... 외 ..건 Description 을 위해 Sales Line 뒤지기.
          SalesCrLines.Reset();
          SalesCrLines.SetRange("Document No.",SalesCrMemo."No.");
          SalesCrLines.SetFilter(Type,'%1..%2',SalesCrLines.Type::"G/L Account",SalesCrLines.Type::"Fixed Asset");

          if SalesCrLines.FindSet() then begin
          repeat
            SalesLineCnt += 1;
            if SalesLineCnt = 1 then
              SalesLineDescription := SalesCrLines.Description;
          until SalesCrLines.Next() = 0; 
          end;
          SalesLineDescription += StrSubstNo('외 %1건',SalesLineCnt);
#endregion
          VATLedgerEntreis.Init();
          VATLedgerEntreis.Insert(true); //VAT No. / VAT Company Information 입력.      
          VATLedgerEntreis.Validate("VAT Issue Type",VATLedgerEntreis."VAT Issue Type"::Sales); //매출/청구
          VATLedgerEntreis.Validate("Account No.",SalesCrMemo."Bill-to Customer No."); //청구처 입력.
          VATLedgerEntreis."VAT Category Code" :='V01'; ///FIXME 설정으로 처리할 방법은 없는가? 
          if SalesDocumentType = SalesDocumentType::"Credit Memo" then
            VATLedgerEntreis."Linked Document Type" := VATLedgerEntreis."Linked Document Type"::"Credit Memo"
          else
            VATLedgerEntreis."Linked Document Type" := VATLedgerEntreis."Linked Document Type"::"Return Order";
          VATLedgerEntreis."Linked Document No." := SalesCrMemo."No.";
          VATLedgerEntreis."Linked External Document No." := SalesCrMemo."External Document No.";
          VATLedgerEntreis.Modify();

          SalesCrMemo.CalcFields(Amount,"Amount Including VAT");
#region - 디테일라인 입력구간
          detailedVATLedgerEntreis.Init();
          detailedVATLedgerEntreis."VAT Document Date" := SalesCrMemo."Posting Date";
          detailedVATLedgerEntreis."VAT Document No." := VATLedgerEntreis."VAT Document No.";
          detailedVATLedgerEntreis."Line No." := 10000;
          detailedVATLedgerEntreis."Actual Amount" := -SalesCrMemo.Amount;
          //Actual 은 부가세 카테코리의 금액을 업데이트하므로, Validate 는 Tax 에 넣어서 진행한다.
          detailedVATLedgerEntreis."Tax Amount" := -(SalesCrMemo."Amount Including VAT" - SalesCrMemo.Amount);
          detailedVATLedgerEntreis."Line Total Amount" := -(SalesCrMemo."Amount Including VAT");
          detailedVATLedgerEntreis.Quantity := 1;
          detailedVATLedgerEntreis."Item Description" := SalesLineDescription;
          detailedVATLedgerEntreis.Insert(true);               
#endregion          
        end; 
        else;
      END;

      Page.Run(Page::"VAT Sales Document",VATLedgerEntreis);

    end;

    /// <summary>
    /// 매입 주문,송장에 대한 부가세Entry 를 입력하는 procedure.
    /// </summary>
    /// <param name="PurchDocumentType">매입 문서유형에 따라, 가져올 대상을 정합니다.</param>
    /// <param name="PurchHeader">Pruchase Order, Pruchase Invoice 인 경우, 이 레코드 값을 취합니다.</param>
    /// <param name="PurchCrMemo">Pruchase Credit Memo, Pruchase Return Order 인 경우, 이 레코드 값을 취합니다.</param>
    /// <param name="VATInformation">부가세 관련정보가 있는 마스터항목입니다.</param>
    local procedure CreatePurchVATLedgerEntreis(PurchDocumentType: Enum "Purchase Document Type";PurchHeader: Record "Purch. Inv. Header";PurchCrMemo: Record "Purch. Cr. Memo Hdr.";VATInformation: Record "VAT Basic Information")
    var
      VATLedgerEntreis : Record "VAT Ledger Entries";
      detailedVATLedgerEntreis : Record "detailed VAT Ledger Entries";
      PurchLines: Record "Purch. Inv. Line";
      PurchCrLines: Record "Purch. Cr. Memo Line";
      PurchLineCnt: Integer;
      PurchLineDescription: Text[300];
    begin
      Clear(PurchLineCnt);
      Clear(PurchLineDescription);

      CASE PurchDocumentType of
        PurchDocumentType::Order,PurchDocumentType::Invoice:
        begin
          ///... 외 ..건 Description 을 위해 Sales Line 뒤지기.
          PurchLines.Reset();
          PurchLines.SetRange("Document No.",PurchHeader."No.");
          PurchLines.SetFilter(Type,'%1..%2',PurchLines.Type::"G/L Account",PurchLines.Type::"Fixed Asset");

          if PurchLines.FindSet() then begin
          repeat
            PurchLineCnt += 1;
            if PurchLineCnt = 1 then
              PurchLineDescription := PurchLines.Description;
          until PurchLines.Next() = 0; 
          end;
          PurchLineDescription += StrSubstNo('외 %1건',PurchLineCnt);          
          VATLedgerEntreis.Init();
          VATLedgerEntreis.Insert(true); //VAT No. / VAT Company Information 입력.      
          VATLedgerEntreis.Validate("VAT Issue Type",VATLedgerEntreis."VAT Issue Type"::Purchase); //매출/청구
          VATLedgerEntreis.Validate("Account No.",PurchHeader."Pay-to Vendor No."); //매입처 입력.
          VATLedgerEntreis."VAT Category Code" :='V01'; ///FIXME 설정으로 처리할 방법은 없는가? 
          if PurchDocumentType = PurchDocumentType::Order then
            VATLedgerEntreis."Linked Document Type" := VATLedgerEntreis."Linked Document Type"::Order
          else
            VATLedgerEntreis."Linked Document Type" := VATLedgerEntreis."Linked Document Type"::Invoice;
          VATLedgerEntreis."Linked Document No." := PurchHeader."No.";
          VATLedgerEntreis."Linked External Document No." := PurchHeader."Vendor Invoice No.";
          VATLedgerEntreis.Modify();

          PurchHeader.CalcFields(Amount,"Amount Including VAT");
          detailedVATLedgerEntreis.Init();
          detailedVATLedgerEntreis."VAT Document Date" := PurchHeader."Posting Date";
          detailedVATLedgerEntreis."VAT Document No." := VATLedgerEntreis."VAT Document No.";
          detailedVATLedgerEntreis."Line No." := 10000;
          detailedVATLedgerEntreis."Actual Amount" := PurchHeader.Amount;
          //Actual 은 부가세 카테코리의 금액을 업데이트하므로, Validate 는 Tax 에 넣어서 진행한다.
          detailedVATLedgerEntreis."Tax Amount" := PurchHeader."Amount Including VAT" - PurchHeader.Amount;
          detailedVATLedgerEntreis."Line Total Amount" := detailedVATLedgerEntreis."Actual Amount"+detailedVATLedgerEntreis."Tax Amount";
          detailedVATLedgerEntreis.Quantity := 1;
          detailedVATLedgerEntreis."Item Description" := PurchLineDescription;
          detailedVATLedgerEntreis.Insert(true);          
        end;
        PurchDocumentType::"Credit Memo",PurchDocumentType::"Return Order":
        begin
          ///... 외 ..건 Description 을 위해 Sales Line 뒤지기.
          PurchCrLines.Reset();
          PurchCrLines.SetRange("Document No.",PurchCrMemo."No.");
          PurchCrLines.SetFilter(Type,'%1..%2',PurchCrLines.Type::"G/L Account",PurchCrLines.Type::"Fixed Asset");

          if PurchCrLines.FindSet() then begin
          repeat
            PurchLineCnt += 1;
            if PurchLineCnt = 1 then
              PurchLineDescription := PurchCrLines.Description;
          until PurchCrLines.Next() = 0; 
          end;
          PurchLineDescription += StrSubstNo('외 %1건',PurchLineCnt);
          VATLedgerEntreis.Init();
          VATLedgerEntreis.Insert(true); //VAT No. / VAT Company Information 입력.      
          VATLedgerEntreis.Validate("VAT Issue Type",VATLedgerEntreis."VAT Issue Type"::Purchase); //매출/청구
          VATLedgerEntreis.Validate("Account No.",PurchCrMemo."Pay-to Vendor No."); //청구처 입력.
          VATLedgerEntreis."VAT Category Code" :='V01'; ///FIXME 설정으로 처리할 방법은 없는가? 
          if PurchDocumentType = PurchDocumentType::"Credit Memo" then
            VATLedgerEntreis."Linked Document Type" := VATLedgerEntreis."Linked Document Type"::"Credit Memo"
          else
            VATLedgerEntreis."Linked Document Type" := VATLedgerEntreis."Linked Document Type"::"Return Order";
          VATLedgerEntreis."Linked Document No." := PurchCrMemo."No.";
          VATLedgerEntreis."Linked External Document No." := PurchCrMemo."Vendor Cr. Memo No.";
          VATLedgerEntreis.Modify();

          PurchCrMemo.CalcFields(Amount,"Amount Including VAT");
          detailedVATLedgerEntreis.Init();
          detailedVATLedgerEntreis."VAT Document Date" := PurchCrMemo."Posting Date";
          detailedVATLedgerEntreis."VAT Document No." := VATLedgerEntreis."VAT Document No.";
          detailedVATLedgerEntreis."Line No." := 10000;
          detailedVATLedgerEntreis."Actual Amount" := -PurchCrMemo.Amount;
          //Actual 은 부가세 카테코리의 금액을 업데이트하므로, Validate 는 Tax 에 넣어서 진행한다.
          detailedVATLedgerEntreis."Tax Amount" := -(PurchCrMemo."Amount Including VAT" - PurchCrMemo.Amount);
          detailedVATLedgerEntreis."Line Total Amount" := -(PurchCrMemo."Amount Including VAT");
          detailedVATLedgerEntreis.Quantity := 1;
          detailedVATLedgerEntreis."Item Description" := PurchLineDescription;
          detailedVATLedgerEntreis.Insert(true);               
        end; 
        else;
      END;

      Page.Run(Page::"VAT Purchase Document",VATLedgerEntreis);

    end;
}
