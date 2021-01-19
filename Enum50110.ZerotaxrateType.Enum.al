enum 50110 "Zerotax rate Type"
{
    Extensible = true;
    CaptionML = ENU='Zerotax rate Type',KOR='영세율 구분';
    
    value(0; " ")
    {
        CaptionML = ENU=' ',KOR=' ';
    }
    value(1; GoodsExport)
    {
        CaptionML = ENU='GoodsExport',KOR='재화수출';
    }
    value(2; ZeroRate)
    {
        CaptionML = ENU='ZeroRate',KOR='영세율';
    }
    
}
