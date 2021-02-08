table 50106 "VAT Ledger Cue Table"
{
    Caption = 'VAT Ledger Cue Table';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[25])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; SalesIssuedButNotSend; Integer)
        {
            Caption = 'SalesIssuedButNotSend';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(General),"VAT Issue Type" = filter(Sales),"ETAX Document Status" = filter(Saved)));
        }
        field(3; SalesSending; Integer)
        {
            Caption = 'SalesSending';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(General),"VAT Issue Type" = filter(Sales),"ETAX Document Status" = filter(Issued),"ETAX Status Code"=filter(303)));

        }
        field(4; SalesSent; Integer)
        {
            Caption = 'SalesSent';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(General),"VAT Issue Type" = filter(Sales),"ETAX Document Status" = filter(Issued),"ETAX Status Code"=filter(304)));
            
        }
        field(5; PurchIssuedButNotSend; Integer)
        {
            Caption = 'PurchIssuedButNotSend';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(General),"VAT Issue Type" = filter(Purchase),"ETAX Document Status" = filter(Saved)));
            
        }
        field(6; PurchSending; Integer)
        {
            Caption = 'PurchSending';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(General),"VAT Issue Type" = filter(Purchase),"ETAX Document Status" = filter(Issued),"ETAX Status Code"=filter(303)));
            
        }
        field(7; PurchSent; Integer)
        {
            Caption = 'PurchSent';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(General),"VAT Issue Type" = filter(Purchase),"ETAX Document Status" = filter(Issued),"ETAX Status Code"=filter(304)));
            
        }
        field(8; AmendedTaxOpen; Integer)
        {
            Caption = 'AmendedTaxOpen';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(Correction),"VAT Issue Type" = filter(Sales),"ETAX Document Status" = filter(Saved)));
            
        }
        field(9; AmendedTaxIssued; Integer)
        {
            Caption = 'AmendedTaxIssued';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(Correction),"VAT Issue Type" = filter(Sales),"ETAX Document Status" = filter(Issued),"ETAX Status Code"=filter('')));
            
        }
        field(10; AmendedTaxSending; Integer)
        {
            Caption = 'AmendedTaxSending';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(Correction),"VAT Issue Type" = filter(Sales),"ETAX Document Status" = filter(Issued),"ETAX Status Code"=filter(303)));
            
        }
        field(11; AmendedTaxSent; Integer)
        {
            Caption = 'AmendedTaxSent';
            FieldClass = FlowField;
            CalcFormula = count("VAT Ledger Entries" where("VAT Document Type" = filter(Correction),"VAT Issue Type" = filter(Sales),"ETAX Document Status" = filter(Issued),"ETAX Status Code"=filter(304)));
            
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    
}
