

/*

 6, 109, 139 - Main
 48, 145, 145
 52, 181, 170
 111, 168, 75 - green
 236, 190, 20 - yellow
 
 
 */




int[]r = {6, 48, 52, 111, 239};
int[]g = {109, 145, 181, 168, 190};
int[]b = {139, 145, 170, 75, 20};

int[] fibonacci = new int[8];
int f1, f2, deg, orbit, direction, speed, waitTime, muddy, setTimeToWait, velocity;
int spacyCounter, secondSpacyCounter;
float[] xCoords;
float[] yCoords;
float[] spacyCoords, fp;
Circle[] c;
CrossHair[] crossHair;


class Circle {
  int place;
  float x, y, size;
  int[] colour;

  Circle(int p, float _size, int c) {
    place = p;
    colour = new int[3];
    size = _size;
    colour[0] = r[c];
    colour[1] = g[c];
    colour[2] = b[c];
  }

  void update() {
    strokeWeight(1);
    stroke(255);
    //stroke(colour[0], colour[1], colour[2]);
    fill(colour[0], colour[1], colour[2]);
    getCoords();
    ellipse(x, y, size, size);
  }

  void getCoords() {

    x = xCoords[place];
    y = yCoords[place];
  }
}

class CrossHair {
  float[] location;
  int counter, x, y, picker;
  boolean direction, different;
  int[] colour = new int[3];
  float[] seg = new float[2];
  float tempx, tempy;


  CrossHair(int startTurn, boolean _direction, boolean _different, int picker) {
    x = int(width/2);
    y = int(height/2);
    counter = startTurn;
    direction = _direction;
    colour[0] = r[picker];
    colour[1] = g[picker];
    colour[2] = b[picker];
    different = _different;
  }

  void update() {
    strokeWeight(10);
    stroke(colour[0], colour[1], colour[2]);

    if (different==false) {


      
      location = findPointOnCircle(x, y, radians(counter), 50);
      line(x, y, location[0], location[1]);
      location = findPointOnCircle(location[0], location[1], radians(counter), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter), 50);
      line(tempx, tempy, location[0], location[1]);

      location = findPointOnCircle(x, y, radians(counter + 90), 50);

      line(x, y, location[0], location[1]);
      location = findPointOnCircle(location[0], location[1], radians(counter + 90), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter + 90), 50);
      line(tempx, tempy, location[0], location[1]);


      location = findPointOnCircle(x, y, radians(counter + 180), 50);
      line(x, y, location[0], location[1]);
      location = findPointOnCircle(location[0], location[1], radians(counter + 180), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter + 180), 50);
      line(tempx, tempy, location[0], location[1]);

      location = findPointOnCircle(x, y, radians(counter + 270), 50);
      line(x, y, location[0], location[1]);
      location = findPointOnCircle(location[0], location[1], radians(counter + 270), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter + 270), 50);
      line(tempx, tempy, location[0], location[1]);
    } else {


      location = findPointOnCircle(x, y, radians(counter), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter), 50);
      line(tempx, tempy, location[0], location[1]);
      location = findPointOnCircle(location[0], location[1], radians(counter), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter), 50);
      line(tempx, tempy, location[0], location[1]);

      location = findPointOnCircle(x, y, radians(counter + 90), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter + 90), 50);
      line(tempx, tempy, location[0], location[1]);
      location = findPointOnCircle(location[0], location[1], radians(counter + 90), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter + 90), 50);
      line(tempx, tempy, location[0], location[1]);

      location = findPointOnCircle(x, y, radians(counter + 180), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter + 180), 50);
      line(tempx, tempy, location[0], location[1]);
      location = findPointOnCircle(location[0], location[1], radians(counter + 180), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter + 180), 50);
      line(tempx, tempy, location[0], location[1]);

      location = findPointOnCircle(x, y, radians(counter + 270), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter + 270), 50);
      line(tempx, tempy, location[0], location[1]);
      location = findPointOnCircle(location[0], location[1], radians(counter + 270), 50);
      tempx = location[0];
      tempy = location[1];
      location = findPointOnCircle(location[0], location[1], radians(counter + 270), 50);
      line(tempx, tempy, location[0], location[1]);
    }


    if (direction) {
      counter++;
    } else {
      counter--;
    }
  }
}

void numberOfCircles(int num, int sizeVar) {
  int size = 400;
  println(num);
  xCoords = new float[num];
  yCoords = new float[num];
  c = new Circle[num];
  int counter = 1;
  int seg = int(num/5);
  int colour;

  // divide circles by 2
  // if counter < than half
  //    then spawn each circle great than the last
  // if counter > half spawn cirles small than the last by 5,

  for (int i = 0; i < num; i++) {
    xCoords[i] = -300;
    yCoords[i] = -300;
    colour = colourPicker(i, seg);
    if (counter < (num / 2) - 5) {
      println("smaller to larger");
      c[i] = new Circle(i, sizeVar * (i + 1), colour);
      size = (sizeVar*(i + 1));
    } else {
      println("larger to smaller");
      c[i] = new Circle(i, size, colour);
      if (counter > num /2) {
        size = size - sizeVar;
      }
    }

    counter++;
  }
}

void updateArray() {
  // Shifting the values of the array rigth by one index
  // Then updating the starting index with current mouse coords
  for (int i = xCoords.length - 2; i >= 0; i--) {
    xCoords[i + 1] = xCoords[i];
    yCoords[i + 1] = yCoords[i];
  }
  points = findPointOnCircle(int(width/2), int(height/2), radians(deg), orbit);
  xCoords[0] = points[0];
  yCoords[0] = points[1];
}

void updateCircles() {

  for (int i = c.length - 1; i >=0; i--) {

    c[i].update();
  }
}


int colourPicker(int i, int segment) {
  int p;

  if (i > segment * 4) {
    p = 4;
  } else if (i > segment * 3) {
    p = 3;
  } else if (i > segment * 2) {
    p = 2;
  } else if (i > segment * 1) {
    p = 1;
  } else {
    p = 0;
  }

  return p;
}


float[] findPointOnCircle(float startingLocationX, float startingLocationY, float angle, float radius) {

  float[] temp = new float[2];
  // y = r * sin(angle);
  // x = r * cos(angle);
  // r = 50;
  // angle = 50


  temp[0] = startingLocationX + (radius * cos(angle));
  temp[1] = startingLocationY + (radius * sin(angle));

  return temp;
}


void keyPressed() {

  if (key == CODED) {
    if (keyCode == UP) {
      speed++;
    } else if (keyCode == DOWN) {
      speed--;
    }
  }

  if (speed < 1) {
    speed = 1;
  }


  if (key == 's' && muddy > 2) {
    muddy = muddy - 2;
  }

  if (key == 'w' && muddy < 250) {
    muddy = muddy + 2;
  }
}

void location() {

  if (deg == 360) {
    deg = 0;
  } else {

    deg += speed;
  }
}


void autoSpeed() {

  if (speed > 30) {
    direction = -1;
  } else if (speed < 1) {
    direction = 1;
    speed = speed + (direction * velocity);
    waitTime = 0;
  }

  if (waitTime < setTimeToWait) {
    speed -= (direction * velocity);
  }

  waitTime++;
  speed = speed + (direction * velocity);
}

void Spacy() {
  stroke(255);
  fp = findPointOnCircle(int(width/2), int(height/2), radians(spacyCounter), 350);
  spacyCoords = findPointOnCircle(fp[0], fp[1], radians(secondSpacyCounter), 100);
  fill(r[3], g[3], b[3]);
  ellipse(spacyCoords[0], spacyCoords[1], 20, 20);
  fill(r[2], g[2], b[2]);
  ellipse(spacyCoords[0], spacyCoords[1], 15, 15);
  fill(r[1], g[1], b[1]);
  ellipse(spacyCoords[0], spacyCoords[1], 10, 10);
  fill(r[4], g[4], b[4]);
  ellipse(spacyCoords[0], spacyCoords[1], 5, 5);




  spacyCounter += 2;
  secondSpacyCounter += 10;
}

void ring(){
  float[] location;
  float[] location2;
  strokeWeight(10);
  stroke(r[3], g[3], b[3]);
  for(int i = 0; i < 360; i+=60){
    location = findPointOnCircle(int(width/2), int(height/2), radians(spacyCounter + i), 240);
    location2 = findPointOnCircle(int(width/2), int(height/2), radians(spacyCounter + i + 60), 240);
    line(location[0], location[1], location2[0], location2[1]);
  }
  
}



void setup() {
  size(displayWidth, displayHeight );
  numberOfCircles(50, 25);
  crossHair = new CrossHair[2];
  crossHair[0] =  new CrossHair(0, false, true, 0);
  crossHair[1] = new CrossHair(45, true, false, 4);
  f1 = 0;
  f2 = 1;
  orbit = 700;
  speed = 2;
  deg = 0;
  direction = 1;
  waitTime = 5;
  muddy = 250;
  setTimeToWait = 50;
  velocity = 2;
  spacyCounter = 0;
  secondSpacyCounter = 0;
}

float[] points;
void draw() {

  fill(0, muddy);
  rect(0.1, 0.1, float(width), float(height));
  crossHair[0].update();
  crossHair[1].update();
  //drawLines();
  updateArray();
  updateCircles();
  location();
  //autoSpeed();
  Spacy();
  ring();
}
