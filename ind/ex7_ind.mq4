#property strict
#property indicator_separate_window // 別ウィンドウに表示
#property indicator_buffers 1 // 指標バッファの数
#property indicator_type1 DRAW_LNIE // 指標の種類
#property indicator_color1 clrRed // ラインの色
#property indicator_width1 2 // ラインの太さ
#property indicator_style1 STYLE_SOLID // ラインの種類
#property indicator_level1 100 // 指標のレベル
#property indicator_levelcolor clrBlue // レベルの色
#property indicator_levelwidth 1 // レベルの太さ
#property indicator_levelstyle STYLE_DASH // レベルの種類

double Buf[]; // 指標バッファ用の配列の宣言

input int MomPeriod = 10; // モメンタムの期間

// 初期化関数
int OnInit(){
    SetIndexBuffer(0, Buf); // 配列を指標バッファに関連付ける
    return(INIT_SUCCEEDED);
}

// 指標計算関数
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
    int limit = rates_total - prev_calculated; // プロットするバーの数

    for(int i = 0; i < limit; i++){
        Buf[i] = iMomentum(_Symbol, 0, MomPeriod, PRICE_CLOSE, i);
    }
    return(rates_total - 1);
}