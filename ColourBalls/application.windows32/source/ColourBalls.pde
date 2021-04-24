




class Circle {

  PVector location;
  PVector velocity;

  Circle(int x, int y, int sx, int sy) {
    location = new PVector(x, y);
    velocity = new PVector(sx, sy);
  }

  void draw() {

    ellipse(location.x, location.y, 16, 16);
    update();
  }

  void update() {

    location.add(velocity);

    if (location.x >= width || location.x <= 0) {
      velocity.x = velocity.x * -1;
    } else if (location.y >= height || location.y <= 0) {
      velocity.y = velocity.y * -1;
    }
  }
}

void mouseClicked(){
  fill(int(random(255)), int(random(150)), int(random(100, 255)));
}


Circle[] c = new Circle[0];
int sx = 3;
int sy = 3;
int count = 0;

void setup() {
  size(500, 500);

  background(255);
  populateCircles();
}




void draw() {
  updateArray();
}

void populateCircles() {
  Circle temp;
  for (int i = 0; i < width; i+=30) {
    for (int y = 0; y < height; y+=30) {
      temp = new Circle(i, y, sx, sy);
      c = (Circle[])append(c, temp);
    }
  }
}


void updateArray() {

  for (int i = 0; i < c.length; i++) {

    c[i].draw();
  }
}
