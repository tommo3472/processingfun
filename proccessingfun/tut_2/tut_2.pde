


int[] numbers = {3,2,4,1,1,234,124,1,12,312312,3,234};


int squareNumber(int a){
  a = a * a;
  return a; 
}


for(int i=0;i < numbers.length; i++){
  numbers[i] = squareNumber(numbers[i]);
}



println(numbers);
