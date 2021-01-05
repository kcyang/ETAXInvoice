/*
50100 VAT Basic Information
마스터테이블 (Customer,Vendor..등) 에 연결된 한국 부가세 정보테이블
*/
table 50100 "VAT Basic Information"
{
    Caption = 'VAT Basic Information';
    Extensible = true;
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(3; "VAT Type"; Enum "VAT Type")
        {
            Caption = 'VAT Type';
            DataClassification = CustomerContent;
        }
        field(4; "Customer Type"; Enum "Customer Type")
        {
            Caption = 'Customer Type';
            DataClassification = CustomerContent;
        }
        field(5; "Business Type"; Text[50])
        {
            Caption = 'Business Type';
            DataClassification = CustomerContent;
        }
        field(6; "Business Class"; Text[50])
        {
            Caption = 'Business Class';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Table ID","No.")
        {
            Clustered = true;
        }
    }
    
}
