pageextension 50149 POPBILLTEST extends "Customer List"
{
    actions
    {
        addfirst("&Customer")
        {
            action(POPBILL)
            {
                Caption = 'POPBILL';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category7;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //POPBILL.GetCorpInfo();
                    POPBILL.RegistIssue();
                end;
            }
        }
    }
    var
        POPBILL: Codeunit VATPopbillFunctions;
}
