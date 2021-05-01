
/*

creates a cannon class to track users position on the mouse and create a Missile when the user
has pressed a mouse button.


Things to do:
  - detenate Missile when it has reach the intended destination.
  - create explosion animation.
  - create a hit box for that explosion.



*/


class Missile {


  /*
  
   Missile for constructing a player shoot Missile.
   it will take a location and a destination PVector
   
   when the Missile is at the destination it should blow up and create
   a circle like explosion with mini squares that also continues to get large
   with its hit detection.
   
   
   */

  PVector location, destination, direction;
  float epsilon;
  boolean boom;

  Missile(PVector _location, PVector _destination) {
    // Need the starting location and destination 

    this.location = _location;
    this.destination = _destination;
    this.direction = new PVector(this.destination.x - this.location.x, 
                                 this.destination.y - this.location.y);
    this.direction.normalize();
    epsilon = 0.900;
    boom = false;
  }

  void update() {
    targetReachedDestinationCheck();
    move();
    drawMissile();
    drawTargetLocation();
  }
  
  void drawTargetLocation(){
    /*
    test function for seeing where the missile should stop at.
    
    return: void
    */
    
    line(location.x, location.y, destination.x, destination.y);
  }

  void move() {

    this.location.add(direction);
  }

  void drawMissile() {
    rect(location.x, location.y, generalWidth, generalHeight);
  }
  
  void targetReachedDestinationCheck(){
    /*
    
    see if the location x and y are close enough to the destination x and y.
    call destruction of missile object with a varriable to check in another function
    call creation of explosion.
    calls explosion effect.
    
    return: void
    
    */
    
    if(abs(destination.x - location.x) <= epsilon && abs(destination.y - location.y) <= epsilon){
       boom = true; 
       bombs.add(new Bomb(new PVector(destination.x, destination.y)));
      
    }
    
  }
}

class Cannon {

  /*

   handles the crosshair of the players mouse,
   the logic to shoot the a Missile,
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
    /*
    checks for a mouse button input.
    then creates a new missile with the cannon location and the destination as the mouseX, and mouse<y locations.
    
    return: void
    */
    if (mousePressed == true) {
      missiles.add(new Missile(new PVector(location.x, location.y), new PVector(mouseLocation.x, mouseLocation.y)));
    }
  }
}

class Bomb{
 
  /*
  this class will be call once a player missile has reached
  its location. The bomb will create an explosion effect and hitbox
  that will continuely get bigger untill it fades out to delete itself.
  
  paramters
  PVector location :
    - The x and y values in a PVector of the destination of the missile.
    
    
    */
  
  PVector location;
  int w, h;
  
  Bomb(PVector _location){
    location = _location;
    w = 1;
    h = 1;
    
  }
  
  void update(){
    
    if(w % 2 == 0){
      drawExplosion();
    }
    
    
    w = w + 1;
    h = h + 1;
    
  }
  
  void drawExplosion(){
   
    rect(location.x, location.y, w*1.3, h);
    rect(location.x, location.y, w, h*1.3);
    
    
  }
  
}



Cannon player;
int generalWidth, generalHeight;
ArrayList<Missile> missiles;
ArrayList<Bomb> bombs;


void displayingMissile() {
  Missile temp;
  for (int i = 0; i < missiles.size(); i++) {

    temp = missiles.get(i);
    temp.update();
  }
}

void displayingBomb() {
  Bomb temp;
  for (int i = 0; i < bombs.size(); i++) {

    temp = bombs.get(i);
    temp.update();
  }
}


void destructionOfMissiles() {
  Missile temp;
  for(int i = missiles.size()-1; i >= 0; i--){
   
    temp = missiles.get(i);
    if(temp.boom == true){
      missiles.remove(i);
    }
    
  }
  
}


void setup() {


  size(displayWidth, displayHeight);
  generalWidth = int(width/ 64);
  generalHeight = int(height/ 64);

  player = new Cannon(int(width/2), int((height/8)*5));
  missiles = new ArrayList<Missile>();
  bombs = new ArrayList<Bomb>();
  noCursor();
}


void draw() {
  
  rectMode(CORNER);
  fill(255, 10);
  rect(0, 0, width, height);
  rectMode(CENTER);

  player.update();
  
  
  
  if(missiles.size() > 0){
    displayingMissile();
    destructionOfMissiles();
  }
  
  if(bombs.size() > 0){
    displayingBomb();
  }
}
