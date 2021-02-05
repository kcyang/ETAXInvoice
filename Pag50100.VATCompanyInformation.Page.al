page 50100 "VAT Company Information"
{
    CaptionML = ENU='VAT Company Information',KOR='부가세 회사정보';
    DeleteAllowed = true;
    PageType = Card;
    SourceTable = "VAT Company";
    PromotedActionCategories = 'New,Process,Report,Application Settings,System Settings,Regional Settings';
    Editable = true;
    UsageCategory = Administration;
    ApplicationArea = All;
    
    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU='General',KOR='회사 일반정보';
                field("Corp No."; Rec."Corp No.")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }                                
                field("Corp Name"; Rec."Corp Name")
                {
                    ApplicationArea = All;
                }

                field("Corp RegID"; Rec."Corp RegID")
                {
                    ApplicationArea = All;
                }                
                field("CEO Name"; Rec."CEO Name")
                {
                    ApplicationArea = All;
                }
                field("Corp Addr"; Rec."Corp Addr")
                {
                    ApplicationArea = All;
                }
                field("Corp BizClass"; Rec."Corp BizClass")
                {
                    ApplicationArea = All;
                }
                field("Corp BizType"; Rec."Corp BizType")
                {
                    ApplicationArea = All;
                }
                field("Corp SubTaxRegID"; Rec."Corp SubTaxRegID")
                {
                    ApplicationArea = All;
                }                
                field("Corp FaxNo"; Rec."Corp FaxNo")
                {
                    ApplicationArea = All;
                }
                field("Corp PhoneNo"; Rec."Corp PhoneNo")
                {
                    ApplicationArea = All;
                }
                field("Corp PostCode"; Rec."Corp PostCode")
                {
                    ApplicationArea = All;
                }
            }
            group(Contact){
                CaptionML = ENU='Contact Information',KOR='회사담당자 연락처';
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = All;
                }
                field("Contact TEL"; Rec."Contact TEL")
                {
                    ApplicationArea = All;
                }                
                field("Contact Dept"; Rec."Contact Dept")
                {
                    ApplicationArea = All;
                }
                field("Contact Email"; Rec."Contact Email")
                {
                    ApplicationArea = All;
                }
                field("Contact HP"; Rec."Contact HP")
                {
                    ApplicationArea = All;
                }

            }       

            group(ETAX)
            {
                CaptionML = ENU = 'ETAX', KOR='전자세금계산서/명세서 관련';
                field("Invoice Abbreviates";Rec."Invoice Abbreviates")
                {
                    ApplicationArea = All;
                }
                field("Statements Abbreviates";Rec."Statements Abbreviates")
                {
                    ApplicationArea = All;
                }                
                field("Include Comments";Rec."Include Comments")
                {
                    Visible = false;
                    ApplicationArea = All;                    
                }
            }         
        }
    } 
}
