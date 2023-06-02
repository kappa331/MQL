#property strict
#property indicator_chart_window

#property indicator_buffers 2

#property indicator_color1 clrWhite
#property indicator_width1 2

#property indicator_color2 clrWhite
#property indicator_width2 1

double Buf1[];
double Buf2[];

input int MAPeriod = 25;
input double Env = 50;

int OnInit(){
    SetIndexBuffer(0, Buf1);
    SetIndexBuffer(1, Buf2);

    SetIndexLabel(0, "移動平均線");
    SetIndexLabel(1, "乖離線+");

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
        Buf1[i] = iMA(_Symbol, _Period, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, i);
        Buf2[i] = Buf1[i] + Env * _Point * 10;
    }
    return(rates_total - 1);
}