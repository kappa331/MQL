#property strict

input int FastMAPeriod = 10; // 短期移動平均の期間
input int SlowMAPeriod = 40; // 長期移動平均の期間
input double Lots = 0.1; // 売買ロット数

int Ticket = 0; // チケット番号

// カスタム評価関数
double OnTester()
{
    // (リカバリーファクター)-(プロフィットファクター)
    return(TesterStatistics(STAT_PROFIT)/TesterStatistics(STAT_BALANCE_DD) - TesterStatistics(STAT_PROFIT_FACTOR));
}

// ティック時実行関数
void OnTick()
{
    // 1本前の移動平均
    double FastMA1 = iMA(_Symbol, 0, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
    double SlowMA1 = iMA(_Symbol, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);

    // 2本前の移動平均
    double FastMA2 = iMA(_Symbol, 0, FastMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
    double SlowMA2 = iMA(_Symbol, 0, SlowMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);

    int pos = 0; // ポジションの状態
    // 未決済ポジションの有無
    if(OrderSelect(Ticket, SELECT_BY_TICKET) && OrderCloseTime() == 0)
    {
        if(OrderType() == OP_BUY) pos = 1; // 買いポジション
        if(OrderType() == OP_SELL) pos = -1; // 売りポジション
    }

    bool ret; // 決済状況
    if(FastMA2 <= SlowMA2 && FastMA1 > SlowMA1) // 買いシグナル
    {
        // 売りポジションがあれば決済注文
        if(pos < 0)
        {
            ret = OrderClose(Ticket, OrderLots(), OrderClosePrice(), 0);
            if(ret) pos = 0; // 決済成功すればポジションなしに
        }
        // ポジションがなければ買い注文
        if(pos == 0) Ticket = OrderSend(_Symbol, OP_BUY, Lots, Ask, 0, 0, 0);
    }
    if(FastMA2 >= SlowMA2 && FastMA1 < SlowMA1) // 売りシグナル
    {
        // 買いポジションがあれば決済注文
        if(pos > 0)
        {
            ret = OrderClose(Ticket, OrderLots(), OrderClosePrice(), 0);
            if(ret) pos = 0; // 決済成功すればポジションなしに
        }
        // ポジションがなければ売り注文
        if(pos == 0) Ticket = OrderSend(_Symbol, OP_SELL, Lots, Bid, 0, 0, 0);
    }
}