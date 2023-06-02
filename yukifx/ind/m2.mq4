#property strict
#property indicator_chart_window

#property indicator_buffers 1
#property indicator_color1 clrWhite
#property indicator_width1 2

double Buf[];

input int MAPeriod = 25;

int OnInit()
{
    SetIndexBuffer(0, Buf);
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
        Buf[i] = iMA(_Symbol, _Period, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, i);
    }
    return(rates_total - 1);
}