#property strict

void OnStart()
{
    Print("証拠金通貨:", AccountInfoString(ACCOUNT_CURRENCY));
    Print("レバレッジ:", AccountInfoInteger(ACCOUNT_LEVERAGE));
    Print("残高:", AccountInfoDouble(ACCOUNT_BALANCE));
    Print("有効証拠金:", AccountInfoDouble(ACCOUNT_EQUITY));
    Print("必要証拠金:", AccountInfoDouble(ACCOUNT_MARGIN));
    Print("余剰証拠金", AccountInfoDouble(ACCOUNT_MARGIN_FREE));
    Print("証拠金維持率:", AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));
}