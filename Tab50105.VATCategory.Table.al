table 50105 "VAT Category"
{
    CaptionML = ENU='VAT Category',KOR='부가세 과세형태 코드';
    DataClassification = CustomerContent;
    Extensible = true;
        
    fields
    {
        field(1; "Category No."; Code[10])
        {
            CaptionML = ENU='Category No.',KOR='카테고리 번호';
            DataClassification = CustomerContent;
        }
        field(2; "Category Name"; Text[100])
        {
            CaptionML = ENU='Category Name',KOR='카테고리 이름';
            DataClassification = CustomerContent;
        }
        field(3; Use; Boolean)
        {
            CaptionML = ENU='Use',KOR='사용여부';
            DataClassification = CustomerContent;
        }
        field(4; Taxation; Boolean)
        {
            CaptionML = ENU='Taxation',KOR='과세';
            DataClassification = CustomerContent;
        }
        field(5; "VAT Rates"; Decimal)
        {
            CaptionML = ENU='VAT Rates',KOR='부가세율';
            DataClassification = CustomerContent;
        }
        field(6; ZeroTax; Boolean)
        {
            CaptionML = ENU='Zero Tax',KOR='영세율여부';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Category No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Category No.", "Category Name")
        {
        }
    }    
}
