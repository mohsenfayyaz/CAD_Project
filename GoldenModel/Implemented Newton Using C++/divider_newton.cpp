#include <iostream>

using namespace std;

int main()
{
   cout << "Hello World" << endl;
   float a = 1;
   float b = 4.292786;  //-0.2329
   //0.5 <= D <= 1  ->  Exp = -1

   // initial approx: 48/17 - 32/17*d0
   float x = 2.82353 - 1.88235*b;
   x = 0.26829913;
   cout << x << endl;
   for(int i=0; i<80; i++){
       x = x*(2-b*x);
       cout << x << "|" << float(b)*x << "|" << 2-float(b)*x << endl;
   }
   cout << a*x << endl;


   return 0;
}
