/*

*/
pageextension 50100 "Customer VAT Information" extends "Customer Card"
{
    layout
    {
        addlast(content)
        {
            group(VATInformation)
            {

                CaptionML = KOR = '부가세 정보';

                field(VATType; VATType)
                {
                    ToolTipML = KOR = '세금게산서 발행유형을 선택합니다.';
                    CaptionML = ENU = 'VAT Type', KOR = '부가세 발행유형';
                    ApplicationArea = All;
                    Importance = Promoted;
                    trigger OnValidate()
                    begin
                        changeFieldValue(3, VATType.AsInteger(), '');
                    end;
                }
                field(CustomerType; CustomerType)
                {
                    ToolTipML = KOR = '고객의 유형을 선택합니다.';
                    CaptionML = ENU = 'Customer Type', KOR = '고객유형';
                    ApplicationArea = All;
                    Importance = Promoted;
                    trigger OnValidate()
                    begin
                        changeFieldValue(4, CustomerType.AsInteger(), '');
                    end;

                }
                field(VATBusinessType; VATBusinessType)
                {
                    ToolTipML = KOR = '업태를 입력합니다. 50자까지만 가능합니다.';
                    CaptionML = ENU = 'Business Type', KOR = '사업 업태';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(5, 0, VATBusinessType);
                    end;
                }
                field(VATBusinessClass; VATBusinessClass)
                {
                    ToolTipML = KOR = '종목을 입력합니다. 50자까지만 가능합니다.';
                    CaptionML = ENU = 'Business Class', KOR = '사업 종목';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(6, 0, VATBusinessClass);
                    end;
                }
                //TODO VAT Basic Information 에 추가된 내용들 필드로 모두 추가할 것.

                //TODO 필드의 Priority 조절을 해서, Promoted 까지 처음에 안보이도록 할 것.
            }

        }
    }
    actions
    {
        //TODO 추가연락처 등록할 수 있는 버튼추가.
    }
    trigger OnAfterGetRecord()
    var
        VATBasicInformation: Record "VAT Basic Information";
    begin
        VATBasicInformation.Reset();
        VATBasicInformation.SetRange("Table ID", 18);
        VATBasicInformation.SetRange("No.", Rec."No.");
        IF VATBasicInformation.Find('-') then begin
            VATType := VATBasicInformation."VAT Type";
            CustomerType := VATBasicInformation."Customer Type";
            VATBusinessType := VATBasicInformation."Business Type";
            VATBusinessClass := VATBasicInformation."Business Class";
        end else begin
            VATBasicInformation.Init();
            VATBasicInformation."Table ID" := 18;
            VATBasicInformation."No." := Rec."No.";
            VATBasicInformation.Insert();
        end;
    end;
    #region working for fieldref.
    /*
    필드번호를 변수로 받아, 해당 필드의 값을 변경하는 프로시져.
    */
    /* OLDCODE
    VATBasicInformation.Reset();
    VATBasicInformation.SetRange("Table ID",18);
    VATBasicInformation.SetRange("No.",Rec."No.");
    IF VATBasicInformation.Find('-') then begin
        VATBasicInformation."Customer Type" := CustomerType;
        VATBasicInformation.Modify();
    end;        
    */
    local procedure changeFieldValue(fieldNo: Integer; fieldEnumValue: Integer; fieldTextValue: Text)
    var
        VATInforRecRef: RecordRef;
        VATInforFieldTableIDRef: FieldRef;
        VATInforFieldNoRef: FieldRef;
        VATInforValue: FieldRef;

    begin
        if fieldNo = 0 then
            exit;

        VATInforRecRef.Open(50100);
        VATInforFieldTableIDRef := VATInforRecRef.Field(1);
        VATInforFieldNoRef := VATInforRecRef.Field(2);

        VATInforFieldTableIDRef.Value := 18;
        VATInforFieldNoRef.Value := Rec."No.";

        if VATInforRecRef.Find('=') then begin
            VATInforValue := VATInforRecRef.Field(fieldNo);
//            Message('Type[%1] Value[%2]', VATInforValue.Type, VATInforValue.Value);
            if VATInforValue.Type = FieldType::Text then begin
                VATInforValue.Value := fieldTextValue;
                VATInforRecRef.Modify();
            end else
                if VATInforValue.Type = FieldType::Option then begin
                    VATInforValue.Value := fieldEnumValue;
                    VATInforRecRef.Modify()
                end;
        end;
    end;
    #endregion
    var
        VATBusinessType: Text[50]; //업태
        VATBusinessClass: Text[50]; //종목
        VATType: Enum "VAT Type";
        CustomerType: Enum "Customer Type";
}
