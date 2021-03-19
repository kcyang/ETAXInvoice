pageextension 50140 ETAXNavigationArea extends "Order Processor Role Center"
{
    actions
    {
        addlast(Sections)
        {
            group("ETAX")
            {
                CaptionML = ENU='ETAX',KOR='📚 부가세 관리';
                action("VAT Company Information")
                {
                    CaptionML = ENU='VAT Company Information',KOR='🏢 부가세 회사정보';
                    Image = Home;
                    RunObject = page "VAT Company Information";
                    ApplicationArea = All;
                    ToolTip = '계산서 발행 및 부가세 관련 정보를 위한 회사정보를 등록합니다.';
                }
                action("VAT Ledger Entries")
                {
                    Image = Sales;
                    CaptionML = ENU='VAT Ledger Entries',KOR='🗞 등록된 부가세 기장';
                    RunObject = page "VAT Ledger Entries";
                    ApplicationArea = All;
                    ToolTip = '등록된 부가세 목록을 볼 수 있습니다.';
                }
                action("Regist ETAX Invoice")
                {
                    Image = Sales;
                    CaptionML = ENU='Regist Issue',KOR='🧾 전자세금계산서 발행';
                    RunObject = page "ETAX Regist Issue";
                    ApplicationArea = All;
                    ToolTip = '계산서 발행대상 목록을 보고 전자(세금)계산서를 발행합니다.';
                }
                action("VAT Category")
                {
                    CaptionML = ENU='VAT Categories',KOR='부가세 과세유형';
                    RunObject = page "VAT Category";
                    ApplicationArea = All;
                    ToolTip = '부가세 과세유형을 관리합니다.';
                }

                // Creates a sub-menu
                group("Regist VAT Documents")
                {
                    CaptionML = ENU='Regist VAT Documents',KOR='💵 매출/매입 등록';
                    action("Sales Document")
                    {
                        Image = Receivables;
                        CaptionML = ENU='Sales Document',KOR='매출 등록';
                        ApplicationArea = All;
                        RunObject = page "VAT Sales Document";
                        ToolTip = '매출 전표 등록을 합니다.';
                    }
                    action("Purchase Document")
                    {
                        Image = Payables;
                        CaptionML = ENU='Purchase Document',KOR='매입 등록';
                        ApplicationArea = All;
                        RunObject = page "VAT Purchase Document";
                        ToolTip = '매입 전표 등록을 합니다.';
                    }
                }

            }
        }
    }
}
