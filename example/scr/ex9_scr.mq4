#property strict
#property script_show_confirm // 実行前に確認ウィンドウ表示

void OnStart()
{
    int ticket; // チケット番号
    ticket = OrderSend(_Symbol, OP_SELL, 0.1, Bid, 3, 0, 0); // 新規売り注文
    MessageBox("チケット番号=" + ticket);
}