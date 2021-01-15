/*
주문서에서, Posting 한 후 부가세 컨트롤.
*/
codeunit 50100 "VAT Functions"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnAfterPost', '', false, false)]
    local procedure OnAfterSalesPost(var SalesHeader: Record "Sales Header")
    begin
        //Sales Posting 이 끝났을 때,
        //Confirm 메시지 부가세 등록할래?
    end;
/*

IF LVRE_KPACKSetup.GET THEN BEGIN
  IF LVRE_KPACKSetup."BSE_Use Post Sales" THEN BEGIN
    CLEAR(LVCU_RegisterSalesVAT);
    LVRE_Customer.GET("Sell-to Customer No.");
    IF (LVRE_Customer."BSE_Registeration Type" = LVRE_Customer."BSE_Registeration Type"::"By Invoice") AND
    //INCDEV »ùÇÃÀÏ°æ¿ì Á¦¿Ü 20170922 JASON
    ("No." <> 'SAMP*') THEN BEGIN
      CASE
        "Document Type" OF "Document Type"::Order,"Document Type"::Invoice : BEGIN
          IF Invoice AND (SalesInvHeader."No." <> '') THEN BEGIN
            IF GUIALLOWED THEN BEGIN //BSF
              IF CONFIRM(LOTC_Text001, FALSE) = TRUE THEN BEGIN
                //ºÎ°¡¼¼ »ý¼º ÄÚµå »ðÀÔ
                LVCU_RegisterSalesVAT.BSEF_CreateSalesVATDocEntry(SalesInvHeader);
              END;
            END ELSE //BSF
              LVCU_RegisterSalesVAT.BSEF_CreateSalesVATDocEntry(SalesInvHeader);
          END;
        END;
        "Document Type"::"Credit Memo","Document Type"::"Return Order" : BEGIN
          IF Invoice AND (SalesCrMemoHeader."No." <> '') THEN BEGIN
            IF GUIALLOWED THEN BEGIN //BSF
              IF CONFIRM(LOTC_Text002, FALSE) = TRUE THEN BEGIN
                //ºÎ°¡¼¼ »ý¼º ÄÚµå »ðÀÔ
                LVCU_RegisterSalesVAT.BSEF_CreateSalesCrVATDocEntry(SalesCrMemoHeader);
              END;
            END ELSE //BSF
              LVCU_RegisterSalesVAT.BSEF_CreateSalesCrVATDocEntry(SalesCrMemoHeader);
          END;
        END;
      END;
    END;
  END;
END;

//KVAT001 END
*/
}
