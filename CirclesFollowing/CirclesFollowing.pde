
// We want three circles in a line and each cirlce will display its coords
// at a location in an array



/*

create a function that can find the points in the lines of in the fibonacci spiral



xcounter = 1


if XCounter < 2
 then positive x
 
if xCounter > 2
 then negative x
 
if xCounter > 4

if xCounter = 4
 then x = 1
 else x++


same with y but start at 0 and inverse negative and positive

also if y < 1
 then positive y


*/







int[] fibonacci = new int[8];
int f1, f2;
int[] xCoords;
int[] yCoords;
Circle[] c;

class Circle {
  int place;
  float x, y, size;
  int[] colour;

  Circle(int p, float _size) {
    place = p;
    colour = new int[3];
    size = _size;
    colour[0] = int(random(0, 255));
    colour[1] = 200;
    colour[2] = 255;
  }

  void update() {

    stroke(colour[0], colour[1], colour[2])
    fill(colour[0], colour[1], colour[2]);
    getCoords();
    ellipse(x, y, size, size);
  }

  void getCoords() {

    x = xCoords[place];
    y = yCoords[place];
  }
}

void numberOfCircles(int num) {
  println(num);
  xCoords = new int[num];
  yCoords = new int[num];
  c = new Circle[num];

  for (int i = 0; i < num; i++) {
    xCoords[i] = 0;
    yCoords[i] = 0;
    c[i] = new Circle(i, i + 10 * i);
  }
}

void updateArray() {
  // Shifting the values of the array rigth by one index
  // Then updating the starting index with current mouse coords
  for (int i = xCoords.length - 2; i >= 0; i--) {
    xCoords[i + 1] = xCoords[i];
    yCoords[i + 1] = yCoords[i];
  }

  xCoords[0] = mouseX;
  yCoords[0] = mouseY;
}

void updateCircles() {

  for (int i = c.length - 1; i >=0; i--) {

    c[i].update();
  }
}


int fib(){
 
  // Finding the next fib number
  int temp = f1 + f2;
  f1 = f2;
  f2 = temp;
  return temp;
  
}

void setupFibArray(){
 fibonacci[0] = 1;
 for(int i = 1; i < fibonacci.length; i++){
   fibonacci[i] = fib();
 }
}

void drawLines(){
  int x, y, xCounter, yCounter;
  x = 300;
  y = 300;
  xCounter = 1;
  yCounter = 0;
  int[] direction = new int[2];
  
  
  for(int i = 0; i < fibonacci.length; i++){
   
    if(xCounter <= 2){
      direction[0] = fibonacci[i]; 
    }
    
    if(xCounter > 2){
      direction[0] = fibonacci[i] * -1;
     
      if(xCounter == 4){
        xCounter = 1;
      }
    }
    
    if(yCounter < 1){
      direction[1] = fibonacci[i];
    
    } else if(yCounter <= 2){
      direction[1] = fibonacci[i] * -1; 
    }
    
    if(yCounter > 2){
      direction[1] = fibonacci[i];
     
      if(yCounter == 4){
        yCounter = 1;
      }
    }
      
    
    
      
     line(x, y, x + direction[0], y + direction[1]);
     xCounter++;
     yCounter++;
     x = x + direction[0];
     y = y + direction[1];
  }
 
  
  
}



void setup() {
  size(1000, 1000);
  numberOfCircles(30);
  f1 = 0;
  f2 = 1;
  setupFibArray();
  println(fibonacci);
}


void draw() {

  background(255);
  drawLines();
  updateArray();
  updateCircles();
  
}
