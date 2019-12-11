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


    string in1, in2, out;
	float input1, input2, output, divideResult;
    string sample;
    ifstream file;
    file.open("../../ModelSim/single_divider_output.txt");
    while (getline(file, sample))
    {
        stringstream ss(sample);
        ss >> in1;
        ss >> in2;
        ss >> out;
        *(int*)&input1 = (int) bitset<64>(in1).to_ulong();
        *(int*)&input2 = (int) bitset<64>(in2).to_ulong();
        *(int*)&output = (int) bitset<64>(out).to_ulong();
        divideResult = input1/input2;

        cout << endl;
        cout << "INPUT    : " <<  in1 << "/" << in2 << "=" << out << endl;
        cout << "CPP CODE : " << intToBinary(*(int*)&input1) << "/" << intToBinary(*(int*)&(input2)) << "=" << intToBinary(*(int*)&(divideResult)) << endl;
        cout << "FLOAT VAL: " << input1 << "/" << input2 << "=" << output << "|" << divideResult << endl;

        if(*(int*)&(divideResult) == *(int*)&(output))
        {
            cout << "OK" << endl;
        }
        else
        {
            cout << "ERROR ----------------------------!!!!" << endl;
        }
    }

    return 0;
}

