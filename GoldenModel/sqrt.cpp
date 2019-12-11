#include <iostream>
#include <sstream>
#include <fstream>
using namespace std;
double root(double n)
{
    double lo = 0, hi = n, mid;
    for (int i = 0; i < 1000; i++)
    {
        mid = (lo + hi) / 2;
        if (mid * mid == n)
            return mid;
        if (mid * mid > n)
            hi = mid;
        else
            lo = mid;
    }
    return mid;
}



int main()
{
    double input;
    double output;
    string sample;
    ifstream file;
    file.open("input.txt");
    while (getline(file, sample))
    {
        stringstream ss(sample);
        ss >> input;
        ss >> output;
        cout << input << " " << output << " " << root(input) << endl;
        if (root(input) == output)
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