
/*

creates a cannon class to track users position on the mouse and create a missle when the user
has pressed a mouse button.


Things to do:
  - detenate missle when it has reach the intended destination.
  - create explosion animation.
  - create a hit box for that explosion.



*/


class Missle {


  /*
  
   missle for constructing a player shoot missle.
   it will take a location and a destination PVector
   
   when the missle is at the destination it should blow up and create
   a circle like explosion with mini squares that also continues to get large
   with its hit detection.
   
   
   */

  PVector location, destination, direction;

  Missle(PVector _location, PVector _destination) {
    // Need the starting location and destination 

    this.location = _location;
    this.destination = _destination;
    this.direction = new PVector(this.destination.x - this.location.x, 
                                 this.destination.y - this.location.y);
    this.direction.normalize();
  }

  void update() {

    move();
    drawMissle();
  }

  void move() {

    this.location.add(direction);
  }

  void drawMissle() {

    rect(location.x, location.y, generalWidth, generalHeight);
  }
}


class Cannon {

  /*

   handles the crosshair of the players mouse,
   the logic to shoot the a missle,
   and remaining ammo.
   
   */

  int mX, mY;
  PVector location, mouseLocation;
  int[] size;


  Cannon(int posX, int posY) {

    this.location = new PVector(posX, posY);
    this.mouseLocation = new PVector(0, 0);
    this.size = new int[]{generalWidth, generalHeight};
  }


  void update() {
    getMousePos();
    drawCrossHair();
    drawCannon();
    checkForShot();
  }

  void drawCannon() {
    rectMode(CENTER);
    rect(this.location.x, this.location.y, size[0] * 2, size[1] * 2);
  }


  void drawCrossHair() {

    line(this.mouseLocation.x - size[0], this.mouseLocation.y, this.mouseLocation.x + size[0], this.mouseLocation.y);
  }

  void getMousePos() {
    this.mouseLocation.x = mouseX;
    this.mouseLocation.y = mouseY;
  }

  void checkForShot() {
    if (mousePressed == true) {
      missles.add(new Missle(new PVector(location.x, location.y), this.mouseLocation));
    }
  }
}



Cannon player;
int generalWidth, generalHeight;
ArrayList<Missle> missles;


void displayingMissle() {
  Missle temp;
  for (int i = 0; i < missles.size(); i++) {

    temp = missles.get(i);
    temp.update();
  }
}


void setup() {


  size(displayWidth, displayHeight);
  generalWidth = int(width/ 64);
  generalHeight = int(height/ 64);

  player = new Cannon(int(width/2), int((height/8)*5));
  missles = new ArrayList<Missle>();
  noCursor();
}


void draw() {
  
  rectMode(CORNER);
  fill(255, 10);
  rect(0, 0, width, height);
  rectMode(CENTER);

  player.update();
  
  
  if(missles.size() > 0){
    displayingMissle();
  }
}
