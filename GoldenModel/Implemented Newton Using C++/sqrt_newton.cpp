#include <iostream>

using namespace std;

int main()
{
   cout << "Hello World" << endl; 
   float x = 10;
   float a = 25;
   for(int i=0; i<80; i++){
       x = (a/x + x)/2;
       cout << x << endl;
   }
   return 0;
}