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
                    detail: Record "detailed VAT Ledger Entries";
                    popbill: Codeunit VATPopbillFunctions;
                begin
                    //popbill.TestFunction();
                    //POPBILL.GetCorpInfo();
                    //POPBILL.RegistIssue();
                    //SampleText := '010-9999-92929290-2-2-2';
                    //message('%1', DelChr(SampleText, '=', '-'));
                    //Message('%1', Format(WorkDate(), 0, '<Year4><Month,2><Day,2>'));
                    VATLedger.Reset();
                    VATLedger.SetRange("VAT Document No.",'VAT21000049');
                    if VATLedger.Find('-') then
                    begin
                        //VATLedger."VAT Document Type" := VATLedger."VAT Document Type"::Correction;
                        //VATLedger."ETAX Document Status" := VATLedger."ETAX Document Status"::Issued;
                        //VATLedger."ETAX Status Code" := VATLedger."ETAX Status Code"::"Temporary Save";
                        //VATLedger."Statement Issue Date" := Today; //날짜를 입력함.
                        //VATLedger."Statement Status" := "Statement Status"::"Approval Pending"; //승인대기.
                        //VATLedger.Statement := true; //명세서가 발행되면, 체크표시                        
                        //VATLedger.Modify();
                        Message('Done!');
                    end;
/*
                    detail.Reset();
                    detail.SetRange("VAT Document No.",'VAT21000035');
                    if detail.FindSet() then
                    begin
                        detail.Rename('VAT21000035',10000);
                        detail.Modify();
                    end;
*/
                                        
                end;
            }
        }
    }
    var
    //POPBILL: Codeunit VATPopbillFunctions;
}
