#include <iostream>

using namespace std;

int main()
{
   cout << "Hello World" << endl;
   float a = 2;
   float b = 1.4;
   //0.5 <= d0 <= 1

   // initial approx: 48/17 - 32/17*d0
   float x = 2.82353 - 1.88235*b;
   for(int i=0; i<80; i++){
       x = x*(2-b*x);
       cout << x << endl;
   }
   cout << a*x << endl;
   return 0;
}
