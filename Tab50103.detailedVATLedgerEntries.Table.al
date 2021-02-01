table 50103 "detailed VAT Ledger Entries"
{
    CaptionML = ENU='detailed VAT Ledger Entries',KOR='한국 부가세기장 상세';
    DataClassification = CustomerContent;
    Extensible = true;
    
    fields
    {
        field(1; "VAT Document No."; Code[25])
        {
            CaptionML = ENU='VAT Document No.',KOR='부가세 문서번호';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU='Line No.',KOR='라인번호';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(3; "VAT Document Date"; Date)
        {
            CaptionML = ENU='VAT Document Date',KOR='거래일자';
            DataClassification = CustomerContent;
        }
        field(4; "Item No."; Code[50])
        {
            CaptionML = ENU='Item No.',KOR='품목코드';
            DataClassification = CustomerContent;
        }
        field(5; "Item Description"; Text[100])
        {
            CaptionML = ENU='Item Description',KOR='품명';
            DataClassification = CustomerContent;
        }
        field(6; Spec; Text[60])
        {
            CaptionML = ENU='Spec',KOR='규격';
            DataClassification = CustomerContent;
        }
        field(7; Quantity; Decimal)
        {
            CaptionML = ENU='Quantity',KOR='수량';
            DataClassification = CustomerContent;
        }
        field(8; "Unit price"; Decimal)
        {
            CaptionML = ENU='Unit price',KOR='단가';
            DataClassification = CustomerContent;
        }
        field(9; "Actual Amount"; Decimal)
        {
            CaptionML = ENU='Actual Amount',KOR='공급가액';
            DataClassification = CustomerContent;
            //공급가액을 입력하면, 문서의 부가세율에 따라, 세액을 자동으로 계산하고, 문서에 업데이트합니다.
            trigger OnValidate()
            begin
                UpdateRecordAmount();
            end;
        }
        field(10; "Tax Amount"; Decimal)
        {
            CaptionML = ENU='Tax Amount',KOR='세액';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Line Total Amount" := "Actual Amount"+"Tax Amount";
                Modify();
            end;            
        }
        field(11; Remark; Text[100])
        {
            CaptionML = ENU='Remark',KOR='비고';
            DataClassification = CustomerContent;
        }
        field(12;"Line Total Amount";Decimal)
        {
            CaptionML = ENU='Line Total Amount',KOR='라인 합계';
            DataClassification = CustomerContent;            
        }
    }
    keys
    {
        key(PK; "VAT Document No.","Line No.")
        {
            Clustered = true;
        }
    }
    //숫자 관련된 값이 바뀌면, 문서상의 금액을 변경합니다.
    local procedure UpdateRecordAmount()
    var
        VATDocument: Record "VAT Ledger Entries";
    begin
        VATDocument.Reset();
        if VATDocument.Get(Rec."VAT Document No.") then begin
            VATDocument.CalcFields("VAT Rates");
            if VATDocument."VAT Rates" <> 0 then
                "Tax Amount" := "Actual Amount"*(VATDocument."VAT Rates"/100)
            else
                "Tax Amount" := 0;
        end else 
            "Tax Amount" := 0;
        "Line Total Amount" := "Actual Amount"+"Tax Amount";
        Modify();
    end;   
}
