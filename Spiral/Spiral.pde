/*

Idea is to create a spiral that can then spiral out at random.


*/




class Source{
  
  // the middle of the spiral that will propergate the spiral.
  
 Source(){
   
   
 }
  
  
}

class Arm{
  int start, stop;
  // The arms of the spiral
 
  Arm(){
    
    
    
  }
  
  void update(){
    
    
  }
  
  
}


void setup() {
  noFill();
  smooth();
  size(500, 500);
  
}


void draw() {
  line(50, 50, 100, 100);
  curve(50, 50, 73, 61, 15, 65, 15, 65);
  
}
