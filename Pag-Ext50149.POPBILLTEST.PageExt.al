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
                    VATLedger: Record "VAT Ledger Entries";
                begin
                    //POPBILL.GetCorpInfo();
                    //POPBILL.RegistIssue();
                    //SampleText := '010-9999-92929290-2-2-2';
                    //message('%1', DelChr(SampleText, '=', '-'));
                    //Message('%1', Format(WorkDate(), 0, '<Year4><Month,2><Day,2>'));
                    VATLedger.Reset();
                    VATLedger.SetRange("VAT Document No.",'VAT21000031');
                    if VATLedger.Find('-') then
                    begin
                        //VATLedger."VAT Document Type" := VATLedger."VAT Document Type"::Correction;
                        VATLedger."ETAX Document Status" := VATLedger."ETAX Document Status"::Issued;
                        VATLedger.Modify();
                        Message('Done!');
                    end;
                end;
            }
        }
    }
    var
    //POPBILL: Codeunit VATPopbillFunctions;
}
