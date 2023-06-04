#property strict

#property indicator_chart_window

#property indicator_buffers 2
#property indicator_color1 clrWhite
#property indicator_width1 3
#property indicator_type1 DRAW_ARROW

#property indicator_color2 clrWhite
#property indicator_width2 3
#property indicator_type2 DRAW_ARROW

double Buf1[];
double Buf2[];

int OnInit()
{
    SetIndexBuffer(0, Buf1);
    SetIndexBuffer(1, Buf2);

    SetIndexArrow(0, 218);
    SetIndexArrow(1, 217);

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
        double lower = iFractals(_Symbol, _Period, MODE_LOWER, i);
        double upper = iFractals(_Symbol, _Period, MODE_UPPER, i);

        if(lower > 0){
            lower = GetOffsetRate(lower, 10);
            Buf1[i] = lower;
        }
        if(upper > 0){
            upper = GetOffsetRate(upper, -10);
            Buf2[i] = upper;
        }
    }
    return(rates_total - 1);
}

double GetOffsetRate(double rate,
                     int offset_pixel)
{
    double ret = rate;
    double move_rate;
    datetime dummy_time;
    int base_axis_x;
    int base_axis_y;
    int get_window_no;
    int disp_pixel;

    if(ChartTimePriceToXY(0, 0, Time[0], rate, base_axis_x, base_axis_y)){
        disp_pixel = base_axis_y + offset_pixel;
        if(ChartXYToTimePrice(0, base_axis_x, disp_pixel, get_window_no, dummy_time, move_rate)){
            ret = move_rate;
        }
    }

    return ret;
}