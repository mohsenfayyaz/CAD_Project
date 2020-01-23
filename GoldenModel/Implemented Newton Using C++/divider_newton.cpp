#include <iostream>

using namespace std;

int main()
{
    cout << "Hello World" << endl;
    float a = 1.40129846432481707092372958329e-45;
    float b = 1.40129846432481707092372958329e-45;  //-0.2329
    //0.5 <= D <= 1  ->  Exp = -1

    // initial approx: 48/17 - 32/17*d0
    float x = 2.82353 - 1.88235*b;
    x = 1.50706018714394176916788638316e38;
    cout << x << endl;
    for(int i=0; i<80; i++){
        cout << "---" << endl;
        cout << x << "|" << float(b)*x << "|" << 2-b*x << endl;
        x = x*(2-b*x);
        cout << x << "|" << float(b)*x << "|" << 2-float(b)*x << endl;
    }
    cout << a*x << endl;


   return 0;
}
