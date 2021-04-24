




class Circle {

  PVector location;
  PVector velocity;

  Circle(int x, int y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 1);
  }

  void draw() {

    ellipse(location.x, location.y, 16, 16);
    update();
  }

  void update() {

    location.add(velocity);

    if (location.x >= width || location.x <= 0) {
      velocity.x = velocity.x * -1;
    }
    if (location.y >= height || location.y <= 0) {
      velocity.y = velocity.y * -1;
    }
  }
  
  void changeVelocity(PVector acceleration){
    
    velocity.add(acceleration);
    velocity.limit(10);
    
  }
}

void mouseClicked(){
  fill(int(random(255)), int(random(150)), int(random(100, 255)));
}



void keyPressed(){
  
  if(key == CODED){
    if(keyCode == UP){
      acc.add(new PVector(0.2, 0));
    } else if(keyCode == DOWN){
      acc.add(new PVector(0.2, 0));
    }
  }
  
  
  changeCircleSpeed();
  
}

void changeCircleSpeed() {
  
  for(int i = 0; i< c.length; i++){
    
    c[i].changeVelocity(acc);
  }
}


Circle[] c = new Circle[0];
int sx = 3;
int sy = 3;
int count = 0;
PVector acc;

void setup() {
  size(500, 500);

  background(255);
  populateCircles();
  acc = new PVector(0, 0);
}




void draw() {
  updateArray();
}

void populateCircles() {
  Circle temp;
  for (int i = 0; i < width; i+=30) {
    for (int y = 0; y < height; y+=30) {
      if(i+y % 60 == 0){
        temp = new Circle(i, y);
        c = (Circle[])append(c, temp);
      }
    }
  }
}


void updateArray() {

  for (int i = 0; i < c.length; i++) {

    c[i].draw();
  }
}
