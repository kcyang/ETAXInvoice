table 50104 "TAXInvoice Contacts"
{
    CaptionML = ENU='TAXInvoice Contacts',KOR='계산서 담당자';
    DataClassification = CustomerContent;
    Extensible = true;
    
    fields
    {
        field(1; "Account Type"; Enum "Account Type")
        {
            CaptionML = ENU='Account Type',KOR='거래처 유형';
            DataClassification = CustomerContent;
        }
        field(2; "No."; Code[25])
        {
            CaptionML = ENU='No.',KOR='거래처 번호';
            DataClassification = CustomerContent;
        }
        //TODO 아래 일련번호를 어떻게 넣을지 고민해봐야 함. 새로 넣을 때, 자동으로 일련번호를 입력해야 됨.
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU='Line No.',KOR='일련번호';
            DataClassification = CustomerContent;
        }
        field(4; "Contact Name"; Text[100])
        {
            CaptionML = ENU='Contact Name',KOR='담당자 이름';
            DataClassification = CustomerContent;
        }
        field(5; "Contact Dept"; Text[100])
        {
            CaptionML = ENU='Contact Dept',KOR='담당자 부서';
            DataClassification = CustomerContent;
        }
        field(6; "Contact Phone"; Text[20])
        {
            CaptionML = ENU='Contact Phone',KOR='담당자 전화번호';
            DataClassification = CustomerContent;
        }
        field(7; "Contact Fax"; Text[20])
        {
            CaptionML = ENU='Contact Fax',KOR='담당자 팩스';
            DataClassification = CustomerContent;
        }
        field(8; "Contact CellPhone"; Text[20])
        {
            CaptionML = ENU='Contact CellPhone',KOR='담당자 휴대전화';
            DataClassification = CustomerContent;
        }
        field(9; "Contact Email"; Text[100])
        {
            CaptionML = ENU='Contact Email',KOR='담당자 이메일';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Account Type","No.","Line No.")
        {
            Clustered = true;
        }
    }
    
}
//TODO Customer,Vendor 에 연결된 경우, 수정하면 함께 수정될 것. (key-no,line no 1)