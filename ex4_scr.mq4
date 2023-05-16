#property strict

void OnStart()
{
    Print("通貨ペア=", _Symbol);
    Print("小数桁数=", _Digits);
    Print("最小値幅=", _Point);
    Print("タイムフレーム=", _Period);
}