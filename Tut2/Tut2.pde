Car test;

class Car {

  int x, y, theSize, offset;

  Car(int _x, int _y, int _theSize) {
    x = _x;
    y = _y;
    theSize = _theSize;
    offset = theSize/4;
  }


  void draw() {

    rectMode(CENTER);
    stroke(0);
    fill(175);
    rect(x, y, theSize, theSize/2);

    fill(0);
    rect(x - offset, y-offset, offset, offset/2);
    rect(x+offset, y-offset, offset, offset/2);
    rect(x-offset, y+offset, offset, offset/2);
    rect(x+offset, y+offset, offset, offset/2);
  }
}

float distance(float fx, float fy, float sx, float sy){
   float d = sqrt(pow((sx - fx), 2) + pow((sy - fy), 2));
   return d;
  
}

float rectArea(float w, float h){
 
  return w*h;
  
}

void mousePos(){
 
  text(mouseX, 150, 20, 30);
  text(mouseY, 170, 20);
  
}

void rollOverButton() {
   rectMode(CORNER);
  
  fill(0);
  if(mouseX > 100 && mouseX < 100+50 && mouseY < 100 + 50 && mouseY > 100){
   
    fill(255, 0, 0);
    
  }
  
  rect(100, 100, 50, 50);
  
  stroke(255);
  line(100, 100, 150, 150);
}

void setup() {

  size(200, 200);
  test = new Car(100, 100, 64);
}

void draw() {
  background(200);
  println(distance(3, 5, 3, 3));
  test.draw();
  rollOverButton();
  mousePos();
}
