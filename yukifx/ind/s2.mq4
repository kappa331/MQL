#property strict

#property indicator_separate_window
#property indicator_buffers 3

#property indicator_color1 clrWhite
#property indicator_width1 1

#property indicator_color2 clrYellow
#property indicator_width2 1

#property indicator_color3 clrMagenta
#property indicator_width3 1

#property indicator_minimum -100
#property indicator_maximum 100

#property indicator_level1 0
#property indicator_level2 80
#property indicator_level3 -80

#property indicator_levelcolor clrGray
#property indicator_levelstyle STYLE_DOT
#property indicator_levelwidth 1

double Buf1[], Buf2[], Buf3[];

struct struct_rci_data {
    datetime date_value;
    double rate_value;
    int rank_date;
    int rank_rate;
    double rank_adjust_rate;
};

enum ENUM_LINECOUNT {
    RCI_DISPLINE_1 = 1,  // 1本(短期のみ)
    RCI_DISPLINE_2,      // 2本(短期,中期)
    RCI_DISPLINE_3       // 3本(短期,中期,長期)
};

input int Period_S = 9; // 算出期間[短期]
input int Period_M = 26;  // 算出期間[中期]
input int Period_L = 52; // 算出期間[長期]
sinput ENUM_LINECOUNT LineCount = RCI_DISPLINE_3; // RCI表示本数

int OnInit()
{
    IndicatorSetString(INDICATOR_SHORTNAME, GetShortName());

    SetIndexBuffer(0, Buf1);
    SetIndexBuffer(1, Buf2);
    SetIndexBuffer(2, Buf3);

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
        Buf1[i] = CalRCI(Close, Period_S, i);
        if(LineCount >= RCI_DISPLINE_2) Buf2[i] = CalRCI(Close, Period_M, i);
        if(LineCount >= RCI_DISPLINE_3) Buf3[i] = CalRCI(Close, Period_L, i);
    }
    return(rates_total - 1);
}

double CalRCI(const double &array[], int time_period, int index)
{
    double ret = 0;

    int array_count = ArraySize(array);
    int end_index = index + time_period;

    if(end_index < array_count){
        struct_rci_data temp_st_rci[];
        int arrayst_count = ArrayResize(temp_st_rci, time_period, 0);

        int temp_rank = 1;
        int arr_count = 0;
        for(int i = index; i < end_index; i++){
            temp_st_rci[arr_count].date_value = Time[i];
            temp_st_rci[arr_count].rate_value = array[i];
            temp_st_rci[arr_count].rank_date = temp_rank;
            temp_rank++;
            arr_count++;
        }

        for(int i = 0; i < arrayst_count - 1; i++){
            for(int j = i + 1; j < arrayst_count; j++){
                if(temp_st_rci[i].rate_value < temp_st_rci[j].rate_value){
                    struct_rci_data temp_swap = temp_st_rci[i];
                    temp_st_rci[i] = temp_st_rci[j];
                    temp_st_rci[j] = temp_swap;
                }
            }
        }

        for(int i = 0; i < arrayst_count; i++){
            temp_st_rci[i].rank_rate = i + 1;
            temp_st_rci[i].rank_adjust_rate = (double)temp_st_rci[i].rank_rate;
        }

        for(int i = 0; i < arrayst_count - 1; i ++){
            double sum_rank = (double)temp_st_rci[i].rank_rate;
            int same_count = 0;

            for(int j = i + 1; j < arrayst_count; j++){
                if(temp_st_rci[i].rate_value == temp_st_rci[j].rate_value){
                    sum_rank += (double)temp_st_rci[j].rank_rate;
                    same_count++;
                } else {
                    break;
                }
            }

            if(same_count > 0){
                double set_adjust_rank = sum_rank / ((double)same_count + 1);
                for(int j = i; j < i + same_count; j++){
                    temp_st_rci[j].rank_adjust_rate = set_adjust_rank;
                }
                i += same_count;
            }
        }
        double sum_d = 0;
        double temp_diff = 0;
        for(int i = 0; i < arrayst_count; i++){
            temp_diff = (double)temp_st_rci[i].rank_date - temp_st_rci[i].rank_adjust_rate;
            sum_d += MathPow(temp_diff, 2);
        }

        int temp_div = time_period * ((int)MathPow(time_period, 2) - 1);

        if(temp_div > 0){
            ret = 100 * (1 - (6 * sum_d / (double)temp_div));
        }
    }
    return ret;
}

string GetShortName()
{
    string file_name;
    string str_array[];
    string input_str;
    string ret_name;
    int get_arraycount;

    get_arraycount = StringSplit(__FILE__, '.', str_array);

    if(get_arraycount > 0){
        file_name = str_array[0];
    }

    input_str = (string)Period_S;
    if(LineCount >= RCI_DISPLINE_2) input_str += StringFormat(",%d", Period_M);
    if(LineCount >= RCI_DISPLINE_3) input_str += StringFormat(",%d", Period_L);

    ret_name = StringFormat("%s(%s)", file_name, input_str);

    return ret_name;
}