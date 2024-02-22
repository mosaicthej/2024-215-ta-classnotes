#include <stdio.h>

float time2(float x) {return 2*x;}

int main(void){
  float p = 3.14;
  float m = time2(p);
  int a = 1;
  a = a + 5;

  printf("%f", p);
  
  return 0;
}

