#include <cstdint>
#include <iostream>
#include <fstream>
#define MAXLEN 100
#ifndef LENGTH
#define LENGTH 3
#endif

int16_t lab1(int16_t a, int16_t b) {
    //initialize
    int16_t A =a;
    int16_t B =b;
    int16_t Result =0;
    int16_t I =1;
    //calculation
    for(int16_t i =0 ; i-B <0 ; i++ ){
        if( (I & A) != 0 )
            Result ++;
        I = I + I;
    }
    //return value
    return Result;
}
int16_t lab2(int16_t p, int16_t q, int16_t n) {
    //initialize
    int16_t Result = 0;
    int16_t P = p - 1;
    int16_t Q = q;
    int16_t F0 = 0;     //F0 = F_{N-1}
    int16_t F1 = 1;     //F1 = F_{N}
    int16_t N = n;
    //calculation
    while (N!=0){
        int16_t T0 = F0;
        int16_t T1 = F1;
        T0 = T0 & P;
        for( ; T1 >=0 ; ){
            T1 = T1 - Q;
        }
        T1 = T1 + Q;
        F0 = F1;
        F1 = T0 + T1;
        N--;
    }
    Result = F1;
    //return value
    return Result;
}
int16_t lab3(int16_t n, char s[]) {
    //initialize
    int16_t Result = 0;
    int16_t N = n;
    int16_t Ml = 1;
    int16_t i = 0;
    char S0,S1;

    //calculation
    while( N != 0 ){
        S0 = s[i];
        S1 = s[i+1];
        if( S0 == S1 ){
            Ml ++;
        }
        else{
            if( Ml > Result)
                Result = Ml;
            Ml = 1;
        }
        i++;
        N--;
    }
    if( Ml > Result )
        Result = Ml;
    //return value
    return Result;
}
void lab4(int16_t score[], int16_t *a, int16_t *b) {
    //initialize
    int16_t A = 0;
    int16_t B = 0;
    //calculation
    for( int16_t i = 0 ; i < 16 ; i++ ){
        for( int16_t j = 0 ; j < 16 - i ; j++ ){
            if( score[j] > score[j+1] ){
                int16_t tem = score[j];
                score[j] = score[j+1];
                score[j+1] = tem;
            }
        }
    }
    for( int16_t i = 15 ; i > 7 ; i-- ){
        if( score[i] >= 85 ){
            if( i > 11 )
                A++;
            else
                B++;
        }
        else if ( score[i] >= 75 ){
            B++;
        }
    }
    //return value
    * a = A;
    * b = B;
}
int main() {
    std :: fstream file;
    file.open("test.txt", std :: ios :: in);
    //lab1
    int16_t a = 0, b = 0;
    for (int i = 0; i < LENGTH; ++i) {
        file >> a >> b;
        std :: cout << lab1(a, b) << std :: endl;
    }

    //lab2
    int16_t p = 0, q = 0, n = 0;
    for (int i = 0; i < LENGTH; ++i) {
        file >> p >> q >> n;
        std :: cout << lab2(p, q, n) << std :: endl;
    }

    //lab3
    char s[MAXLEN];
    for (int i = 0; i < LENGTH; ++i) {
        file >> n >> s;
        std :: cout << lab3(n, s) << std :: endl;
    }

    //lab4
    int16_t score[16];
    for (int i = 0; i < LENGTH; ++i) {
        for (int j = 0; j < 16; ++j) {
            file >> score[j];
        }
        lab4(score, &a, &b);
        for (int j = 0; j < 16; ++j) {
            std :: cout << score[j] << " ";
        }
        std :: cout << std :: endl << a << " " << b << std :: endl;
    }
    file.close();
    return 0;
}