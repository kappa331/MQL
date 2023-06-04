#property strict

#property indicator_buffers 8

double Buf1[], Buf2[], Buf3[], Buf4[], Buf5[], Buf6[], Buf7[], Buf8[];

int OnInit()
{
    SetIndexBuffer(0, Buf1);
    SetIndexBuffer(1, Buf2);
    SetIndexBuffer(2, Buf3);
    SetIndexBuffer(3, Buf4);
    SetIndexBuffer(4, Buf5);
    SetIndexBuffer(5, Buf6);
    SetIndexBuffer(6, Buf7);
    SetIndexBuffer(7, Buf8);

    SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrRed);
    SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrRed);
    SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID, 5, clrRed);
    SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID, 5, clrRed);

    SetIndexStyle(4, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrAqua);
    SetIndexStyle(5, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrAqua);
    SetIndexStyle(6, DRAW_HISTOGRAM, STYLE_SOLID, 5, clrAqua);
    SetIndexStyle(7, DRAW_HISTOGRAM, STYLE_SOLID, 5, clrAqua);

    return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    int limit = rates_total - prev_calculated;

    for(int i = 0; i < limit; i++){
        if(Open[i] < Close[i]){
            Buf1[i] = High[i];
            Buf2[i] = Low[i];
            Buf3[i] = Open[i];
            Buf4[i] = Close[i];
        } else {
            Buf5[i] = High[i];
            Buf6[i] = Low[i];
            Buf7[i] = Open[i];
            Buf8[i] = Close[i];
        }
    }

    return(rates_total - 1);
}