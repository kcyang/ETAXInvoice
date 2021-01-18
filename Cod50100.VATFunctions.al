/*
주문서에서, Posting 한 후 부가세 컨트롤.

TODO Purchase Order, Purchase Invoice
TODO Purchase Credit Memo, Purchase Retrun Order
TODO Service Order, Service Invoice
TODO Service Credit Memo, Service Return Order
*/
codeunit 50100 "VAT Functions"
{
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
          ///... 외 ..건 Description 을 위해 Sales Line 뒤지기.
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
        end;
        SalesDocumentType::"Credit Memo",SalesDocumentType::"Return Order":
        begin
          ///... 외 ..건 Description 을 위해 Sales Line 뒤지기.
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
        end; 
        else;
      END;

      Page.Run(Page::"VAT Sales Document",VATLedgerEntreis);

    end;
}
