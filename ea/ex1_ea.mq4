#property strict

input int MomPeriod = 20; // モメンタムの期間
input double Lots = 0.1; // 売買ロット数

int Ticket = 0; // チケット番号

// ティック時実行関数
void OnTick()
{
    // 1本前のモメンタム
    double mom1 = iMomentum(_Symbol, 0, MomPeriod, PRICE_CLOSE, 1);

    int pos = 0; // ポジションの状態
    // 未決済ポジションの有無
    if(OrderSelect(Ticket, SELECT_BY_TICKET) && OrderCloseTime() == 0)
    {
        if(OrderType() == OP_BUY) pos = 1; // 買いポジション
        if(OrderType() == OP_SELL) pos = -1; // 売りポジション
    }

    bool ret; // 決済状況
    if(mom1 > 100) // 買いシグナル
    {
        // 売りポジションがあれば決済注文
        if(pos < 0)
        {
            ret = OrderClose(Ticket, OrderLots(), OrderClosePrice(), 0);
            if(ret) pos = 0; // 決済成功すればポジションなしに
        }
        if(pos == 0) Ticket = OrderSend(_Symbol, OP_BUY, Lots, Ask, 0, 0, 0);
    }

    if(mom1 < 100) // 売りシグナル
    {
        // 買いポジションがあれば決済注文
        if(pos > 0)
        {
            ret = OrderClose(Ticket, OrderLots(), OrderClosePrice(), 0);
            if(ret) pos = 0; // 決済成功すればポジションなしに
        }
        if(pos == 0) Ticket = OrderSend(_Symbol, OP_SELL, Lots, Bid, 0, 0, 0);
    }
}