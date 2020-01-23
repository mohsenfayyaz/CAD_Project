#include <iostream>
#include <stdio.h>
//#include <math.h>
#include <sstream>
#include <fstream>
#include <string>
#include<bitset>
#include <cmath>
using namespace std;
string intToBinary(long int n, int i=32)
{
    string result = "";
    // Prints the binary representation
    // of a number n up to i-bits.
    int k;
    for (k = i - 1; k >= 0; k--) {
        /*if (i == 32 && k == 22){
            result += ".";
        }
        if(i == 64 && k == 51){
            result += ".";
        }*/
        if ((n >> k) & 1)
            result += "1";
        else
            result += "0";
    }
    return result;
}

int main()
{
    /*cout << "Hello world!" << endl;
    float f = 1.0;
	unsigned int a, b, i;
    *(int*)&f = 0b00010010000101010011010100100100;
    cout << f << endl << sqrt(f) << endl;
    i = *(int*)&f;
    printf("%b\n", f);*/


    string in, out;
	float input=1.0, output=1.0, sqrtInput;
    string sample;
    ifstream file;
    file.open("../../ModelSim/output/single_sqrt_output.txt");
    while (getline(file, sample))
    {
        stringstream ss(sample);
        ss >> in;
        ss >> out;
        *(int*)&input = (int) bitset<64>(in).to_ulong();  // & gets the pointer to input memory, (int*) casts the address to int* and * at last gets it's value in int
        *(int*)&output = (int) bitset<64>(out).to_ulong();
        sqrtInput = sqrt((double)input);


        cout << endl;
        double ff = sqrt((double)input);
        float f = ff;
        //cout << "RRRRR    : " << intToBinary(*(int*)&f) << endl;
        cout << "INPUT    : " <<  in << "|" << out << endl;
        cout << "CPP CODE : " << intToBinary(*(int*)&input) << "|" << intToBinary(*(int*)&(sqrtInput)) << endl;
        cout << "FLOAT VAL: " << input << "|" << output << "|" << sqrtInput << endl;

        if(*(int*)&(sqrtInput) == *(int*)&(output) || (isnan(output) && isnan(sqrtInput)))
        {
            cout << "OK" << endl;
        }
        else
        {
            cout << "ERROR ----------------------------!!!!" << endl;
        }
    }

    cout << endl << endl << "Press any key to continue." << endl;
    getchar();
    return 0;
}
