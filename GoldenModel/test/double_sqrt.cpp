#include <iostream>
#include <stdio.h>
//#include <math.h>
#include <sstream>
#include <fstream>
#include <string>
#include<bitset>
#include <cmath>
#include <bits/stdc++.h>
#include <errno.h>
#include <cstdlib>
using namespace std;
string intToBinary(unsigned long long n, int i=32)
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

string doubleToBinary(double doubleValue){
    uint8_t *bytePointer = (uint8_t *)&doubleValue;
    string result = "";
    for(size_t index = 0; index < sizeof(double); index++)
    {
        uint8_t byte = bytePointer[index];

        for(int bit = 0; bit < 8; bit++)
        {
            //printf("%d", byte&1);
            if (byte&1)
                result += "1";
            else
                result += "0";
            byte >>= 1;
        }
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
	double input=1.0, output=1.0, sqrtInput;
    string sample;
    ifstream file;
    file.open("../../ModelSim/output/double_sqrt_output.txt");
    while (getline(file, sample))
    {
        stringstream ss(sample);
        ss >> in;
        ss >> out;
        *(unsigned long long*)&input = (unsigned long long) strtoull(in.c_str(), nullptr, 2);  // & gets the pointer to input memory, (int*) casts the address to int* and * at last gets it's value in int
        *(unsigned long long*)&output = (unsigned long long) strtoull(out.c_str(), nullptr, 2);
        sqrtInput = sqrt((double)input);


        cout << endl;
        double ff = sqrt((double)input);
        //float f = ff;
        //cout << "RRRRR    : " << intToBinary(*(unsigned long long*)&f) << endl;
        cout << "INPUT    : " <<  in << "|" << out << endl;
        cout << "CPP CODE : " << intToBinary(*(unsigned long long*)&input, 64) << "|" << intToBinary(*(unsigned long long*)&(sqrtInput), 64) << endl;
        cout << "DOUBLE VAL: " << input << "|" << output << "|" << sqrtInput << endl;

        if(*(long int*)&(sqrtInput) == *(long int*)&(output))
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
