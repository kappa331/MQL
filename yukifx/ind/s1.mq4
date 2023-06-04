#property strict

#property indicator_separate_window

#property indicator_buffers 1
#property indicator_color1 clrWhite
#property indicator_width1 2

#property indicator_minimum 0
#property indicator_maximum 100

#property indicator_level1 30
#property indicator_level2 70

#property indicator_levelcolor clrGray
#property indicator_levelstyle STYLE_DOT
#property indicator_levelwidth 1

double Buf[];

input int RSIPeriod = 25;

int OnInit()
{
    string file_name;
    string str_array[];
    string temp_indname;
    int get_arraycount;

    get_arraycount = StringSplit(__FILE__, '.', str_array);

    if(get_arraycount > 0){
        file_name = str_array[0];
    }

    temp_indname = StringFormat("%s(%d)", file_name, RSIPeriod);

    IndicatorSetString(INDICATOR_SHORTNAME, temp_indname);

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
        Buf[i] = iRSI(_Symbol, _Period, RSIPeriod, PRICE_CLOSE, i);
    }

    return(rates_total - 1);
}