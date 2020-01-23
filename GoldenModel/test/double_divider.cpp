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


    string in1, in2, out;
	double input1=1.0, input2=1.0, output=1.0, divideInput;
    string sample;
    ifstream file;
    file.open("../../ModelSim/output/double_divider_output.txt");
    while (getline(file, sample))
    {
        stringstream ss(sample);
        ss >> in1;
        ss >> in2;
        ss >> out;
        *(unsigned long long*)&input1 = (unsigned long long) strtoull(in1.c_str(), nullptr, 2);  // & gets the pointer to input memory, (int*) casts the address to int* and * at last gets it's value in int
        *(unsigned long long*)&input2 = (unsigned long long) strtoull(in2.c_str(), nullptr, 2);
        *(unsigned long long*)&output = (unsigned long long) strtoull(out.c_str(), nullptr, 2);
        divideInput = ((double)input1)/((double)input2);


        cout << endl;
        cout << "INPUT    : " <<  in1 << "/" << in2 << " = " << out << endl;
        cout << "CPP CODE : " << intToBinary(*(unsigned long long*)&input1, 64) << "/" << intToBinary(*(unsigned long long*)&input2, 64) << " = " << intToBinary(*(unsigned long long*)&(divideInput), 64) << endl;
        cout << "DOUBLE VAL: " << input1 << "/" << input2 << " = " << output << "|" << divideInput << endl;

        if(*(long int*)&(divideInput) == *(long int*)&(output) || (isnan(output) && isnan(divideInput)) )
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
