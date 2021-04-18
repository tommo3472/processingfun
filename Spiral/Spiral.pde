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

void drawBox(){
  
  for(int i = 50; i<110; i+= 10){
    stroke(100);
    line(50, i, 100, i);
    line(i, 50, i, 100);
    
  }
}




void setup() {
  smooth();
  size(500, 500);
  noFill();
  
}

void drawCurvyLine(float start, float stop, float s, int len) {
  for(float i = start;i <= start*len; i += start){
    for(float y = stop; y <=stop*len; y += stop){
        stroke(random(0, 255));
        bezier(i, y, i, y+s, i+s, y, i+s, y+s);
    }
      

      
    }
  
  
  
}



int c = 5;
int speed = 1;

void draw() {
  background(255);
  //drawBox();
  stroke(0);
  //curve(250, 50, 50, 50, 100, 100, 150, 150);
  //curve(-150, 100, 100, 100, 150, 150, 100, 100);
  
  drawCurvyLine(10, 10, c, 30);
  
  c = c + speed;

  
  if(c == 500){
    speed *= -1;
  } else if(c == 5){
    speed *= -1;
  }
}
