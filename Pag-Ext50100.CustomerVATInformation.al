pageextension 50100 "Customer VAT Information" extends "Customer Card"
{
    layout{
        addlast(content){
            group(VATInformation){
                
                CaptionML = KOR='부가세 정보';

                field(VATType; VATType)
                {
                    ToolTipML = KOR='세금게산서 발행유형을 선택합니다.';
                    CaptionML = ENU='VAT Type',KOR='부가세 발행유형';
                    ApplicationArea = All;
                    Importance = Promoted;
                    trigger OnValidate()
                    var
                        VATBasicInformation : Record "VAT Basic Information";
                    begin
                        VATBasicInformation.Reset();
                        VATBasicInformation.SetRange("Table ID",18);
                        VATBasicInformation.SetRange("No.",Rec."No.");
                        IF VATBasicInformation.Find('-') then begin
                            VATBasicInformation."VAT Type" := VATType;
                            VATBasicInformation.Modify();
                        end;                        
                    end;
                }
                field(CustomerType; CustomerType)
                {
                    ToolTipML = KOR='고객의 유형을 선택합니다.';
                    CaptionML = ENU='Customer Type',KOR='고객유형';
                    ApplicationArea = All;
                    Importance = Promoted;
                    trigger OnValidate()
                    var
                        VATBasicInformation : Record "VAT Basic Information";
                    begin
                        VATBasicInformation.Reset();
                        VATBasicInformation.SetRange("Table ID",18);
                        VATBasicInformation.SetRange("No.",Rec."No.");
                        IF VATBasicInformation.Find('-') then begin
                            VATBasicInformation."Customer Type" := CustomerType;
                            VATBasicInformation.Modify();
                        end;                        
                    end;                    
                }
                field(VATBusinessType; VATBusinessType)
                {
                    ToolTipML = KOR='업태를 입력합니다. 50자까지만 가능합니다.';
                    CaptionML = ENU='Business Type',KOR='사업 업태';
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        VATBasicInformation : Record "VAT Basic Information";
                    begin
                        VATBasicInformation.Reset();
                        VATBasicInformation.SetRange("Table ID",18);
                        VATBasicInformation.SetRange("No.",Rec."No.");
                        IF VATBasicInformation.Find('-') then begin
                            VATBasicInformation."Business Type" := VATBusinessType;
                            VATBasicInformation.Modify();
                        end;                        
                    end;                    
                }
                field(VATBusinessClass; VATBusinessClass)
                {
                    ToolTipML = KOR='종목을 입력합니다. 50자까지만 가능합니다.';
                    CaptionML = ENU='Business Class',KOR='사업 종목';
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        VATBasicInformation : Record "VAT Basic Information";
                    begin
                        VATBasicInformation.Reset();
                        VATBasicInformation.SetRange("Table ID",18);
                        VATBasicInformation.SetRange("No.",Rec."No.");
                        IF VATBasicInformation.Find('-') then begin
                            VATBasicInformation."Business Class" := VATBusinessClass;
                            VATBasicInformation.Modify();
                        end;                        
                    end;                    
                }
            }

        }
    }
    actions{

    }
    trigger OnAfterGetRecord()
    var
        VATBasicInformation : Record "VAT Basic Information";
    begin
        VATBasicInformation.Reset();
        VATBasicInformation.SetRange("Table ID",18);
        VATBasicInformation.SetRange("No.",Rec."No.");
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

    var
        VATBusinessType: Text[50]; //업태
        VATBusinessClass: Text[50]; //종목
        VATType: Enum "VAT Type";
        CustomerType: Enum "Customer Type";            
}
