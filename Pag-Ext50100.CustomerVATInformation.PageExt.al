/*
Custome Card 에 한국 부가세 매출입력을 위한 부가 정보를 입력하도록 합니다.
해당 정보는 VAT Basic Information 테이블에 저장됩니다.
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
                    ShowMandatory = true;
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
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        changeFieldValue(6, 0, VATBusinessClass);
                    end;
                }
                field(SubTaxRegID; SubTaxRegID)
                {
                    ToolTipML = KOR = '종사업장코드를 입력합니다. 4자까지만 가능합니다.';
                    CaptionML = ENU='SubTaxRegID',KOR='종사업장코드';
                    Importance = Additional;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(7, 0, SubTaxRegID);
                    end;
                }
                field(CEOName; CEOName)
                {
                    ToolTipML = KOR = '대표자성명을 입력합니다. 100자까지만 가능합니다.';
                    CaptionML = ENU='CEO Name',KOR='대표자 성명';
                    ShowMandatory = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(8, 0, CEOName);
                    end;
                }
                field(ContactName1; ContactName)
                {
                    ToolTipML = KOR = '주담당자 성명을 입력합니다. 100자까지만 가능합니다.';
                    CaptionML = ENU='Contact Name',KOR='담당자 성명';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        changeFieldValue(9, 0, ContactName);
                    end;
                }
                field(DeptName; DeptName)
                {
                    ToolTipML = KOR = '주담당자 부서를 입력합니다. 100자까지 가능합니다.';
                    CaptionML = ENU='Dept Name',KOR='담당자 부서명';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(10, 0, DeptName);
                    end;
                }
                field(TEL; TEL)
                {
                    ToolTipML = KOR = '주담당자 전화번호를 입력합니다. 20자까지만 가능합니다.';
                    CaptionML = ENU='Phone',KOR='담당자 연락처';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        changeFieldValue(11, 0, TEL);
                    end;
                }
                field(HP; HP)
                {
                    ToolTipML = KOR = '주담당자 휴대전화번호를 입력합니다. 20자까지만 가능합니다.';
                    CaptionML = ENU='Cell Phone',KOR='담당자 휴대폰';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(12, 0, HP);
                    end;
                }
                field(Email;Email)
                {
                    ToolTipML = KOR = '주담당자 이메일 주소를 입력합니다. 100자까지만 가능합니다.';
                    CaptionML = ENU='Email',KOR='담당자 이메일';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        changeFieldValue(13, 0, Email);
                    end;
                }
                field(ContactName2; ContactName2)
                {
                    ToolTipML = KOR = '부담당자 성명을 입력합니다. 100자까지만 가능합니다.';
                    CaptionML = ENU='Sub Contact Name',KOR='부담당자 성명';
                    Importance = Additional;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(14, 0, ContactName2);
                    end;
                }
                field(DeptName2; DeptName2)
                {
                    ToolTipML = KOR = '부담당자 부서를 입력합니다. 100자까지 가능합니다.';
                    CaptionML = ENU='Sub Dept Name',KOR='부담당자 부서명';
                    Importance = Additional;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(15, 0, DeptName2);
                    end;
                }
                field(TEL2; TEL2)
                {
                    ToolTipML = KOR = '부담당자 전화번호를 입력합니다. 20자까지만 가능합니다.';
                    CaptionML = ENU='Sub Phone',KOR='부담당자 연락처';
                    Importance = Additional;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(16, 0, TEL2);
                    end;
                }
                field(HP2; HP2)
                {
                    ToolTipML = KOR = '부담당자 휴대전화번호를 입력합니다. 20자까지만 가능합니다.';
                    CaptionML = ENU='Sub Cell Phone',KOR='부담당자 휴대폰';
                    Importance = Additional;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(17, 0, HP2);
                    end;
                }
                field(Email2;Email2)
                {
                    ToolTipML = KOR = '부담당자 이메일 주소를 입력합니다. 100자까지만 가능합니다.';
                    CaptionML = ENU='Sub Email',KOR='부담당자 이메일';
                    Importance = Additional;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(18, 0, Email2);
                    end;
                }
                field(remark1; remark1)
                {
                    ToolTipML = KOR = '비고란입니다. 외국인의경우 외국인등록번호/여권번호를 입력합니다. 150자까지 가능합니다.';
                    CaptionML = ENU='remark1',KOR='비고/외국인등록번호/여권번호';
                    Importance = Additional;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        changeFieldValue(19, 0, remark1);
                    end;
                }                                                
            }

        }
    }
    actions
    {
        addfirst("&Customer")
        {
            action(AdditionalContacts)
            {
                ApplicationArea = All;
                CaptionML = ENU='Additional Contacts',KOR='추가 부가세담당자';
                Image = ContactPerson;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "VAT Contacts";
                RunPageLink = "Account Type" = filter(Customer),
                              "No." = field("No.");
                ToolTip = '추가 계산서 담당자를 입력합니다. 부가세 정보탭에서 2명까지는 바로 입력하시면 됩니다. 5명까지 유효합니다.';
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        VATBasicInformation: Record "VAT Basic Information";
    begin
        VATBasicInformation.Reset();
        VATBasicInformation.SetRange("Table ID", 18);
        VATBasicInformation.SetRange("No.", Rec."No.");
        IF VATBasicInformation.Find('-') then begin
            //현재 레코드를 가져와서 화면에 보여주기 전에, Var 에 값을 넣어줍니다.
            VATType := VATBasicInformation."VAT Type";
            CustomerType := VATBasicInformation."Customer Type";
            VATBusinessType := VATBasicInformation."Business Type";
            VATBusinessClass := VATBasicInformation."Business Class";
            SubTaxRegID := VATBasicInformation.SubTaxRegID;
            CEOName := VATBasicInformation."CEO Name";
            ContactName := VATBasicInformation."Contact Name";
            DeptName := VATBasicInformation."Dept Name";
            TEL := VATBasicInformation.TEL;
            HP := VATBasicInformation.HP;
            Email := VATBasicInformation.Email;
            ContactName2 := VATBasicInformation."Contact Name2";
            DeptName2 := VATBasicInformation."Dept Name2";
            TEL2 := VATBasicInformation.TEL2;
            HP2 := VATBasicInformation.HP2;
            Email2 := VATBasicInformation.Email2;     
            remark1 := VATBasicInformation.remark1;       
        end else begin
            //만약 현재 값이 존재하지 않으면, 현재 값에 해당하는 레코드를 새로 입력합니다.
            VATBasicInformation.Init();
            VATBasicInformation."Table ID" := 18;
            VATBasicInformation."No." := Rec."No.";
            VATBasicInformation."Account Name" := rec.Name;
            VATBasicInformation."Account Address" := rec.Address+' '+rec."Address 2";
            VATBasicInformation."Account Reg. ID" := Rec."VAT Registration No.";
            VATBasicInformation.Insert();
        end;
    end;
    #region working for fieldref.
    /*
    필드번호를 변수로 받아, 해당 필드의 값을 변경하는 프로시져.
    */
    local procedure changeFieldValue(fieldNo: Integer; fieldEnumValue: Integer; fieldTextValue: Text)
    var
        VATInforRecRef: RecordRef;
        VATInforFieldTableIDRef: FieldRef;
        VATInforFieldNoRef: FieldRef;
        VATInforValue: FieldRef;
    begin
        //field 번호가 잘못 들어오면 에러.
        if fieldNo = 0 then
            exit;

        //VAT Basic Infomation 테이블을 가져옵니다.
        VATInforRecRef.Open(Database::"VAT Basic Information");

        //키값에 해당하는 Field Reference 를 가져옵니다.
        VATInforFieldTableIDRef := VATInforRecRef.Field(1);
        VATInforFieldNoRef := VATInforRecRef.Field(2);

        //Field Reference 에 키값을 넣어줍니다.
        VATInforFieldTableIDRef.Value := 18;
        VATInforFieldNoRef.Value := Rec."No.";

        //Key 값에 해당하는 레코드를 찾습니다.
        if VATInforRecRef.Find('=') then begin

            //업데이트를 원하는 Field 번호를 입력하여, FieldRef 를 찾습니다.
            VATInforValue := VATInforRecRef.Field(fieldNo);
//            Message('Type[%1] Value[%2]', VATInforValue.Type, VATInforValue.Value);

            //Field Type 에 따라서, 원하는 값을 입력합니다.
            if VATInforValue.Type = FieldType::Text then begin
                VATInforValue.Value := fieldTextValue;
                VATInforRecRef.Modify();
            end else if VATInforValue.Type = FieldType::Option then begin
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
        SubTaxRegID: Text[4];
        CEOName: Text[100];
        ContactName: Text[100];
        DeptName: Text[100];
        TEL: Text[20];
        HP: Text[20];
        Email: Text[100];
        ContactName2: Text[100];
        DeptName2: Text[100];
        TEL2: Text[20];
        HP2: Text[20];
        Email2: Text[100];
        remark1: text[150];
}
