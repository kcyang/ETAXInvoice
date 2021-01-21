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
                var
                    SampleText: Text;
                begin
                    //POPBILL.GetCorpInfo();
                    //POPBILL.RegistIssue();
                    SampleText := '010-9999-92929290-2-2-2';
                    //message('%1', DelChr(SampleText, '=', '-'));
                    Message('%1', Format(WorkDate(), 0, '<Year4><Month,2><Day,2>'));

                end;
            }
        }
    }
    var
    //POPBILL: Codeunit VATPopbillFunctions;
}
