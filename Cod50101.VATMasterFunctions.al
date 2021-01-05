/*
VAT Master 와 연계된 VAT Basic Information 테이블에 데이터를 업데이트하는 것.
*/
codeunit 50101 "VAT Master Functions"
{
    /*
    Customer Table에서 No. 가 변경되었을 때, 이벤트를 처리함.
    */
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateCustomerNo(var Rec: Record Customer; var xRec: Record Customer)
    begin
        //Message('Customer [%1] Number[%2]-->[%3]', Rec.Name, xRec."No.", Rec."No.");
        ModifyCustomerVATBasicInformation(Rec, xRec);
    end;
    /*
    Customer Table에서 레코드가 인서트 될 때, 이벤트를 처리함.
    */
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertCustomerNo(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        //Message('Customer [%2][%1] Inserted',Rec.Name, Rec."No.");
        InsertCustomerVATBasicInformation(Rec);
    end;
    /*
    마스터 항목에, 값이 들어갈 때 VAT Information 에 값을 동일하게 집어넣는것.
    */
    local procedure InsertCustomerVATBasicInformation(var Rec: Record Customer)
    var
        VATBasicInformation: Record "VAT Basic Information";
        RecID: RecordId;
    begin
        RecID := Rec.RecordId;
        VATBasicInformation.RESET;
        VATBasicInformation.SetRange("Table ID", RecID.TableNo);
        VATBasicInformation.SetRange("No.", Rec."No.");

        IF VATBasicInformation.Find('-') then begin

        end else begin
            VATBasicInformation.Init();
            VATBasicInformation."Table ID" := RecID.TableNo;
            VATBasicInformation."No." := Rec."No.";
            VATBasicInformation.Insert();
        end;
    end;
    /*
    마스터 항목에, No. 가 변경되었을 때 VAT Information 에 값을 동일하게 변경 해 넣는것.
    */
    local procedure ModifyCustomerVATBasicInformation(var Rec: Record Customer; var xRec: Record Customer)
    var
        VATBasicInformation: Record "VAT Basic Information";
        RecID: RecordId;
    begin
        RecID := Rec.RecordId;
        VATBasicInformation.RESET;
        VATBasicInformation.SetRange("Table ID", RecID.TableNo);
        VATBasicInformation.SetRange("No.", xRec."No.");

        IF VATBasicInformation.Find('-') then begin
            //키값이기 때문에, Rename 으로 처리함.
            VATBasicInformation.Rename(18,Rec."No.")
        end else begin
            VATBasicInformation.Init();
            VATBasicInformation."Table ID" := RecID.TableNo;
            VATBasicInformation."No." := Rec."No.";
            VATBasicInformation.Insert();
        end;
    end;
}
