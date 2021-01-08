/*
50100 VAT Basic Information
마스터테이블 (Customer,Vendor..등) 에 연결된 한국 부가세 정보테이블
*/
table 50100 "VAT Basic Information"
{
    CaptionML = ENU='VAT Basic Information',KOR='부가세 거래처 기본정보';
    Extensible = true;
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Table ID"; Integer)
        {
            CaptionML = ENU='Table ID',KOR='테이블번호';
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[20])
        {
            CaptionML = ENU='No.',KOR='번호';
            DataClassification = CustomerContent;
        }
        field(3; "VAT Type"; Enum "VAT Type")
        {
            CaptionML = ENU='VAT Type',KOR='부가세 발행유형';
            DataClassification = CustomerContent;
        }
        field(4; "Customer Type"; Enum "Customer Type")
        {
            CaptionML = ENU='Customer Type',KOR='사업자 구분';
            DataClassification = CustomerContent;
        }
        field(5; "Business Type"; Text[50])
        {
            CaptionML = ENU='Business Type',KOR='업태';
            DataClassification = CustomerContent;
        }
        field(6; "Business Class"; Text[50])
        {
            CaptionML = ENU='Business Class',KOR='종목';
            DataClassification = CustomerContent;
        }
        field(7;SubTaxRegID; Text[4])
        {
            CaptionML = ENU='SubTaxRegID',KOR='종사업장코드';
            DataClassification = CustomerContent;
        }
        field(8; "CEO Name"; Text[100])
        {
            CaptionML = ENU='CEO Name',KOR='대표자 성명';
            DataClassification = CustomerContent;
        }
        //TODO 아래 담당자는 TAXInvoiceContact 에 디폴트값으로 넣을것(Line 1)
        //     - 값이 변경되면, 항상 같이 변경되도록 할 것.
        field(9; "Contact Name"; Text[100])
        {
            CaptionML = ENU='Contact Name',KOR='담당자 성명';
            DataClassification = CustomerContent;
        }
        field(10; "Dept Name"; Text[100])
        {
            CaptionML = ENU='Dept Name',KOR='담당자 부서명';
            DataClassification = CustomerContent;
        }
        field(11; TEL; Text[20])
        {
            CaptionML = ENU='TEL',KOR='담당자 연락처';
            DataClassification = CustomerContent;
        }
        field(12; HP; Text[20])
        {
            CaptionML = ENU='HP',KOR='담당자 휴대폰';
            DataClassification = CustomerContent;
        }
        field(13; Email; Text[100])
        {
            CaptionML = ENU='Email',KOR='담당자 이메일';
            DataClassification = CustomerContent;
        }
        //TODO 아래 담당자는 TAXInvoiceContact 에 디폴트값으로 넣을것(Line 2)
        //     - 값이 변경되면, 항상 같이 변경되도록 할 것.        
        field(14; "Contact Name2"; Text[100])
        {
            CaptionML = ENU='Contact Name2',KOR='부담당자 성명';
            DataClassification = CustomerContent;
        }
        field(15; "Dept Name2"; Text[100])
        {
            CaptionML = ENU='Dept Name2',KOR='부담당자 부서명';
            DataClassification = CustomerContent;
        }
        field(16; TEL2; Text[20])
        {
            CaptionML = ENU='TEL2',KOR='부담당자 연락처';
            DataClassification = CustomerContent;
        }
        field(17; HP2; Text[20])
        {
            CaptionML = ENU='HP2',KOR='부담당자 휴대폰';
            DataClassification = CustomerContent;
        }
        field(18; Email2; Text[100])
        {
            CaptionML = ENU='Email2',KOR='부담당자 이메일';
            DataClassification = CustomerContent;
        }
        field(19; remark1; Text[150])
        {
            CaptionML = ENU='remark1',KOR='외국인등록번호/여권번호';
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
