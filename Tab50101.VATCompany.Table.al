/*
50101 VAT Company
한국 부가세 회사정보 테이블.
*/
table 50101 "VAT Company"
{
    CaptionML = ENU='VAT Company',KOR='부가세 회사정보';
    DataClassification = CustomerContent;
    Extensible = true;
    
    fields
    {
        field(1; "Corp No."; Code[20])
        {
            CaptionML = ENU='Corp No.',KOR='부가세 회사코드';
            DataClassification = CustomerContent;
        }
        field(2; "Corp RegID"; Text[10])
        {
            CaptionML = ENU='Corp RegID',KOR='공급자 사업자번호';
            DataClassification = CustomerContent;
        }
        field(3; "Corp SubTaxRegID"; Text[4])
        {
            CaptionML = ENU='Corp SubTaxRegID',KOR='공급자 종사업장 식별코드';
            DataClassification = CustomerContent;
        }
        field(4; "Corp Name"; Text[200])
        {
            CaptionML = ENU='Corp Name',KOR='공급자 상호';
            DataClassification = CustomerContent;
        }
        field(5; "CEO Name"; Text[100])
        {
            CaptionML = ENU='CEO Name',KOR='공급자 대표자 성명';
            DataClassification = CustomerContent;
        }
        field(6; "Corp Addr"; Text[300])
        {
            CaptionML = ENU='Corp Addr',KOR='공급자 주소';
            DataClassification = CustomerContent;
        }
        field(7; "Corp PostCode"; Text[10])
        {
            CaptionML = ENU='Corp PostCode',KOR='공급자 우편번호';
            DataClassification = CustomerContent;
        }
        field(8; "Corp BizType"; Text[100])
        {
            CaptionML = ENU='Corp BizType',KOR='공급자 업태';
            DataClassification = CustomerContent;
        }
        field(9; "Corp BizClass"; Text[100])
        {
            CaptionML = ENU='Corp BizClass',KOR='공급자 종목';
            DataClassification = CustomerContent;
        }
        field(10; "Corp PhoneNo"; Text[30])
        {
            CaptionML = ENU='Corp PhoneNo',KOR='회사 전화번호';
            DataClassification = CustomerContent;
        }
        field(11; "Corp FaxNo"; Text[30])
        {
            CaptionML = ENU='Corp FaxNo',KOR='회사 팩스번호';
            DataClassification = CustomerContent;
        }
        field(12; "Contact Name"; Text[100])
        {
            CaptionML = ENU='Contact Name',KOR='주담당자 성명';
            DataClassification = CustomerContent;
        }
        field(13; "Contact Dept"; Text[100])
        {
            CaptionML = ENU='Contact Dept',KOR='주담당자 부서';
            DataClassification = CustomerContent;
        }
        field(14; "Contact TEL"; Text[100])
        {
            CaptionML = ENU='Contact TEL',KOR='주담당자 연락처';
            DataClassification = CustomerContent;
        }
        field(15; "Contact HP"; Text[20])
        {
            CaptionML = ENU='Contact HP',KOR='주담당자 휴대폰';
            DataClassification = CustomerContent;
        }
        field(16; "Contact Email"; Text[100])
        {
            CaptionML = ENU='Contact Email',KOR='주담당자 이메일';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Corp No.")
        {
            Clustered = true;
        }
    }
    
}
