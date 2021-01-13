page 50105 "VAT Category"
{
   
    ApplicationArea = All;
    CaptionML = ENU='VAT Category',KOR='부가세 과세유형';
    PageType = List;
    SourceTable = "VAT Category";
    UsageCategory = Lists;
    Editable = true;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Category No."; Rec."Category No.")
                {
                    CaptionML = ENU='Category No.',KOR='카테코리 코드';
                    ApplicationArea = All;
                }
                field("Category Name"; Rec."Category Name")
                {
                    CaptionML = ENU='Category Name',KOR='카테고리 이름';
                    ApplicationArea = All;
                }
                field(Use; Rec.Use)
                {
                    CaptionML = ENU='Use',KOR='사용여부';
                    ApplicationArea = All;
                }
                field(Taxation; Rec.Taxation)
                {
                    CaptionML = ENU='Taxation',KOR='과세';
                    ApplicationArea = All;
                }
                field("VAT Rates";Rec."VAT Rates")
                {
                    ToolTip = '부가세율을 지정합니다. 해당 카테고리를 선택한 내용에 따라 세액을 계산합니다.';
                    CaptionML = ENU='VAT Rates',KOR='부가세율';
                    ApplicationArea = All;                    
                }
            }
        }
    }
    
}
