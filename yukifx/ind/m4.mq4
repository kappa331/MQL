#property strict
#property indicator_chart_window

#property indicator_buffers 1
#property indicator_color1 clrWhite
#property indicator_width1 2

double Buf[];

input int MAPeriod = 25;
input ENUM_TIMEFRAMES TimePeriod = PERIOD_CURRENT;

int OnInit(){
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

    if(TimePeriod > _Period) limit = limit * (TimePeriod / _Period);

    for(int i = 0; i < limit; i++){
        Buf[i] = iMA(_Symbol, TimePeriod, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, iBarShift(_Symbol, TimePeriod, Time[i]));
    }

    return(rates_total - 1);
}