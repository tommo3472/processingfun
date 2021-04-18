


int[] numbers = {5,4,2,7,6,8,5,2,8,14};;


void squareIntArray(int[] array){
  
  int[] tempArray = new int[array.length];
  for(int i=0;i < array.length; i++){
    tempArray[i] = array[i] * array[i];
  }
  
  println(tempArray);
}

void addRandomInt(int[] array){
  int[] tempArray = new int[array.length];
  for(int i=0;i < array.length; i++){
    tempArray[i] = array[i] + int(random(1, 11));
  }
  
  println(tempArray);
  
}

void addNextNumber(int[] array){
  int[] tempArray = new int[array.length];
  
  for(int i=0;i < array.length - 1; i++){
    tempArray[i] = array[i] + array[i+1];
  }
  
  println(tempArray);
  
}

void sumOfArray(int[] array){
  
  int count = 0;
  for(int i=0;i < array.length; i++){
    count = count + array[i] ;
  }
  
  print(count);
  
}

void averageOfArray(int[] array){
  
  int count = 0;
  for(int i=0;i < array.length; i++){
    count = count + array[i] ;
  }
  
  print(count / array.length);
  
}




void setup(){
  squareIntArray(numbers);
  addRandomInt(numbers);
  addNextNumber(numbers);
  sumOfArray(numbers);
  averageOfArray(numbers);
}
