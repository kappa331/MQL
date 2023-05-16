#property strict

void OnStart()
{
    double a = 1.2, b = 2.5, c;

    c = MathMax(a, b);

    Print("c=", c);
}