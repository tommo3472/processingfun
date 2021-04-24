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
  
  for(int i = 0; i<210; i+= 10){
    stroke(100);
    line(0, i, 200, i);
    line(i, 0, i, 200);
    
  }
}

void armX(int startX, int startY, int endX, int endY){
  
  float increments = (endX - startX) / 3;
  bezier(startX, startY, startX+increments, startY-increments, startX+(increments*2), startY+increments, endX, endY);  
  
}

void armY(int startX, int startY, int endX, int endY){
  
   float increments = (endY - startY) / 3;
   bezier(startX, startY, startX-increments, startY+increments, startX+increments, startY+(increments*2), endX, endY);
  
}

void armD(int startX, int startY, int endX, int endY){
  // do a variance of the percentage where the three points of the line lay.
  float len = distance(startX, startY, endX, endY);

  float xIncrements = len / 3;
  float yIncrements = len / 3;

  // x curve
  bezier(startX, startY, startX - xIncrements, startY + yIncrements, endX + xIncrements, endY - yIncrements, endX, endY);
}


void armsAsIs(){
  
  stroke(0, 150, 150);
 //Up
 for(int y = 0; y<=height; y+= 50){
    for(int x = 0; x<=width; x+= 50){
      armD(count, count, x, y);
   
 }
 
 count += speed;
 
 if(count == height){
   speed *= -1; 
 } else if (count == 0){
   speed *= -1;
 }
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
        bezier(i, y, i, y+s, i+s, y, i+s, y+s);
    }
  }
}

float distance(float fx, float fy, float sx, float sy){
   float d = sqrt(pow((sx - fx), 2) + pow((sy - fy), 2));
   return d;
  
}


int c = 5;
int speed = 1;
int count = 100;
int down = 200;
int up = 0;
int finisher = 0;
void draw() {
  
  background(255);
  stroke(200);
  drawBox();
  /*if(c%20 == 0){
    stroke(int(random(0, 255)), int(random(0, 255)), int(random(0, 255)));
  }*/
  //curve(250, 50, 50, 50, 100, 100, 150, 150);
  //curve(-150, 100, 100, 100, 150, 150, 100, 100);
  
  //drawCurvyLine(10, 10, c, 2);
  stroke(0);
  //line(100, 100, 200, 100);
  //bezier(100, 100, 133, 34, 166, 166, 200, 100);
  //arm(100, 100, 200, 100);
  
  stroke(255, 0, 0);
  /*
  for(int i = 0; i <= 200; i += 10){
    
    armX(100, 100, down, i);
    armX(100, 100, up, i);
    armY(100, 100, i, up);
    armY(100, 100, i, down);
    
    
  }
  */
  
  
  armsAsIs();


  
  down += speed * -1;
  up += speed;
  
  if(down == 0 || up == 200){
    speed *= - 1;
  }
  

}
