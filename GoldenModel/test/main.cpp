#include <iostream>
#include <stdio.h>
#include "ieee.cpp"
#include <math.h>
#include <sstream>
#include <fstream>
#include <string>
#include<bitset>
using namespace std;
string intToBinary(int n, int i=32)
{
    string result = "";
    // Prints the binary representation
    // of a number n up to i-bits.
    int k;
    for (k = i - 1; k >= 0; k--) {

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
    file.open("../../ModelSim/output.txt");
    while (getline(file, sample))
    {
        stringstream ss(sample);
        ss >> in;
        ss >> out;
        *(int*)&input = (int) bitset<64>(in).to_ulong();
        *(int*)&output = (int) bitset<64>(out).to_ulong();
        sqrtInput = sqrt(input);

        cout << endl;
        cout << "INPUT    : " <<  in << "|" << out << endl;
        cout << "CPP CODE : " << intToBinary(*(int*)&input) << "|" << intToBinary(*(int*)&(sqrtInput)) << endl;
        cout << "FLOAT VAL: " << input << "|" << output << "|" << sqrt(input) << endl;

        if(*(int*)&(sqrtInput) == *(int*)&(output))
        {
            cout << "OK" << endl;
        }
        else
        {
            cout << "not OK" << endl;
        }
    }

    return 0;
}
