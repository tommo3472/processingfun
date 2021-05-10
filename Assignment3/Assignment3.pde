 //<>//
/*

 
 Things to do:
 - Update explosion animation to be a little bit more retro.
 - Bonus Score
 - Flow of the program update
 - Ballistic Missile hit detection 
 - 
 
 
 */




/*
-------------------------------------------------------------------------
 Classes
 -------------------------------------------------------------------------
 */


class City {
  /*
  
   when destoried change height variable and stop hit detection.
   
   
   
   */

  float[] boundingBox;
  PVector position;
  boolean alive;
  float w, h;

  City(PVector _position, float _w, float _h) {

    position = _position;
    w = _w;
    h = _h;
    boundingBox = new float[]{position.x, position.y, _w, _h};
    alive = true;
  }


  void update() {
    // might have to get the variables from Dane's background.

    drawShape();
  }

  void drawShape() {

    rect(position.x, position.y, w, h);
  }

  void resize(String command) {
    // A function to resize the city depending on it been hit or respawning at the end
    // of the level.
    if (command == "respawn") {
      h /= 4;
    } else {
      h *= 4;
    }
  }
}

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
  boolean boom, spawn;

  Missile(PVector _location, PVector _destination, int speed) {
    // Need the starting location and destination 

    location = _location;
    destination = _destination;
    direction = new PVector(destination.x - location.x, 
      destination.y - location.y);


    direction.normalize();
    direction.mult(speed);
    epsilon = 6;
    boom = false;
  }

  void update() {

    targetReachedDestinationCheck();
    move();
    drawMissile();
    drawTargetLocation();
  }

  void drawTargetLocation() {
    /*
    test function for seeing where the missile should stop at.
     
     return: void
     */

    line(location.x, location.y, destination.x, destination.y);
  }

  void move() {

    location.add(direction);
  }

  void drawMissile() {
    rect(location.x, location.y, generalWidth, generalHeight);
  }

  void targetReachedDestinationCheck() {
    /*
    
     see if the location x and y are close enough to the destination x and y.
     call destruction of missile object with a varriable to check in another function
     call creation of explosion.
     calls explosion effect.
     
     return: void
     
     */

    if (abs(destination.x - location.x) <= epsilon && abs(destination.y - location.y) <= epsilon) {
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

  int mX, mY, currentAmmo, ammoClips;
  PVector location, mouseLocation;
  int[] size;
  boolean alreadyShot;


  Cannon(int posX, int posY) {

    location = new PVector(posX, posY);
    mouseLocation = new PVector(0, 0);
    size = new int[]{generalWidth, generalHeight};
    alreadyShot = false;
    currentAmmo = 10;
    ammoClips = 2;
  }


  void update(boolean allowShot) {
    getMousePos();
    drawCrossHair();
    drawCannon();
    resetAmmoWithClip();
    if (allowShot) {
      checkForShot();
    }
  }

  void drawCannon() {
    rectMode(CENTER);
    rect(location.x, location.y, size[0] * 2, size[1] * 2);
  }

  void resetAmmoWithClip() {
    /*
    if currentAmmo is 0 and you have more than 0 backup ammoClips,
     your currentAmmo will be refilled to max(10). ammoClips will also be
     deincremented by 1
     
     return: void
     
     */

    if (currentAmmo == 0 && ammoClips > 0) {

      currentAmmo = 10;
      ammoClips -= 1;
    }
  }


  void drawCrossHair() {

    line(mouseLocation.x - size[0], mouseLocation.y, mouseLocation.x + size[0], mouseLocation.y);
  }

  void getMousePos() {
    mouseLocation.x = mouseX;
    mouseLocation.y = mouseY;
  }

  void checkForShot() {
    /*
    checks for a mouse button input that is the left mouse button
     then creates a new missile with the cannon location and the destination as the mouseX, and mouse<y locations
     if no shot has been proccessed on this press.
     
     return: void
     */
    if (mousePressed == true && alreadyShot == false && currentAmmo > 0) {
      missiles.add(new Missile(new PVector(location.x, location.y), new PVector(mouseLocation.x, mouseLocation.y), 6));
      alreadyShot = true;
      currentAmmo -= 1;
    }

    if (mousePressed == false) {
      alreadyShot = false;
    }
  }
}

class Bomb {

  /*
  this class will be call once a player missile has reached
   its location. The bomb will create an explosion effect and hitbox
   that will continuely get bigger untill it fades out to delete itself.
   
   paramters
   PVector location :
   - The x and y values in a PVector of the destination of the missile.
   
   
   */

  PVector location;
  int w, h, aliveTime;
  boolean fizzle;
  float[] boundingCircle; // x, y, d

  Bomb(PVector _location) {
    location = _location;
    w = 1;
    h = 1;
    fizzle = false;
    aliveTime = 0;
    boundingCircle = new float[]{location.x, location.y, w * 1.3};
  }

  void update() {

    if (w % 3 == 0) {
      drawExplosion();
    }
    updateBounding();
    drawBounding();
    checkIfFinished();

    w += 1;
    h += 1;
    aliveTime += 1;
  }

  void drawExplosion() {


    fill(255, 10);
    rect(location.x, location.y, w*1.3, h);
    rect(location.x, location.y, w, h*1.3);
  }

  void updateBounding() {

    boundingCircle[2] = (w * 1.3);
  }

  void drawBounding() {

    fill(255, 0, 0, 10);
    ellipse(location.x, location.y, boundingCircle[2], boundingCircle[2]);
    fill(255);
  }

  void checkIfFinished() {
    /*
   checks whether the object has been alive long enough to be destoried eg. the explosion 
     has done its thing.
     
     return: void
     */



    if (aliveTime == 100) {
      fizzle = true;
    }
  }
}

class circleTarget {

  /*
  
   simple class for checking hit detection on the current player missiles.
   
   
   */
  int circleRad;
  PVector location;
  float[] boundingCircle;
  boolean hit;



  circleTarget(int _x, int _y) {

    location = new PVector( _x, _y);
    circleRad = 5;

    boundingCircle =  new float[]{_x, _y, circleRad};
    hit = false;
  }

  void update() {

    ellipse(boundingCircle[0], boundingCircle[1], circleRad * 2, circleRad * 2);
  }
}

class BallisticMissile {
  /*
  - creates a missile at a random location on the very top of the screen.
   - selects an angle of direction between 0, 55.(This is to  be changed to take into account the proximity
   of the missile to the centre of the screen) 
   - The missile is assigned a speed between 1,3.
   - The path of the missile is calulated by the y pos and the angle to find the new x pos?(I think this is how this works)
   - It then draws a line from the starting pos and the current one for its tail and with a different colour a point at the
   current location for its head.
   
   
   
   */
  float theta;
  PVector missile_start_pos;
  PVector missile_pos;
  int missile_y_speed;
  boolean direction, hit, spawn; // true = right, false = left;
  int[] tail_colour, missile_colour;
  float[] bounding_circle;
  int spawnTime; 


  BallisticMissile(int _spawnTime, int _speed) {
    tail_colour =  new int[]{0, 0, 255};
    bounding_circle = new float[]{0, 0, 10};
    missile_colour = new int[]{255, 255, 0};

    theta = calulateAngles();
    missile_start_pos = new PVector(random(20, width - 20), 0);
    missile_pos = new PVector(missile_start_pos.x, missile_start_pos.y);
    missile_y_speed =  ceil(random(0, _speed));
    hit = false;
    spawnTime = int(random(_spawnTime));
    spawn = false;

    if (missile_start_pos.x < width/2) {
      direction = true;
    } else {
      direction = false;
    }
  }

  void update() {
    println(theta);
    println(missile_pos);
    println(missile_y_speed);
    if (spawn) {
      calc_pos();

      drawObject();
      updateBox();
      //boundingCircle();
    }
  }

  void updateBox() {

    bounding_circle[0] = missile_pos.x;
    bounding_circle[1] = missile_pos.y;
  }

  void drawObject() {


    stroke(tail_colour[0], tail_colour[1], tail_colour[2]);
    strokeWeight(3);
    line(missile_start_pos.x, missile_start_pos.y, missile_pos.x, missile_pos.y);
    stroke(missile_colour[0], missile_colour[1], missile_colour[2]);
    point(missile_pos.x, missile_pos.y);
    stroke(0);
  }

  /*void boundingCircle() {
   noStroke();
   fill(255, 0, 0, 50);
   ellipse(missile_pos.x, missile_pos.y, diameter, diameter);
   }*/

  void calc_pos() {

    if (direction) {
      missile_pos.x += tan(radians(theta));
    } else {
      missile_pos.x -= tan(radians(theta));
    }
    missile_pos.y += missile_y_speed;
  }
}

boolean detectHit(float[] circle1, float[] circle2) {

  float dx = circle1[0] - circle2[0];
  float dy = circle1[1] - circle2[1];
  float distance = sqrt((dx *dx) + (dy * dy));


  if (distance < (circle1[2] / 2) + (circle2[2] / 2)) {
    return true;
  }

  return false;
}

/*
-------------------------------------------------------------------------
 Drawing And Destruction of Objects
 -------------------------------------------------------------------------
 */

void displayingMissile() {
  Missile temp;
  for (int i = 0; i < missiles.size(); i++) {

    temp = missiles.get(i);
    temp.update();
  }
}

void destructionOfMissiles() {
  /*
  checks whether any of the missiles are ok to destroy
   
   return: void
   */
  Missile temp;
  for (int i = missiles.size()-1; i >= 0; i--) {

    temp = missiles.get(i);
    if (temp.boom == true) {
      missiles.remove(i);
    }
  }
}


void displayingBomb() {
  /*
  loops though all Bomb objects in the bombs array and
   runs the update() function for that object.
   
   
   also checking for hit detection with targets.
   
   
   return: void
   */
  Bomb temp;
  BallisticMissile tempTarget;
  for (int i = 0; i < bombs.size(); i++) {

    temp = bombs.get(i);
    if (temp.aliveTime % 3 == 0) { // Check every third frame maybe delet on the main game.
      for (int t = 0; t < ballisticMissiles.size(); t++) {
        tempTarget = ballisticMissiles.get(t);
        if (detectHit(temp.boundingCircle, tempTarget.bounding_circle)) {

          tempTarget.hit = true;
          // Ballistic Missile Taken Out
          addScore(100);
        }
      }
    }
    temp.update();
  }
}


void destructionOfBombs() {
  /*
  checks whether any of the missiles are ok to destroy
   
   return: void
   */
  Bomb temp;
  for (int i = bombs.size()-1; i >= 0; i--) {

    temp = bombs.get(i);
    if (temp.fizzle == true) {
      bombs.remove(i);
    }
  }
}

void createTargets() {

  for (int x = 10; x < width - 10; x += 100) {
    for (int y = 10; y < height - 10; y += 100) {

      targets.add(new circleTarget( x, y));
    }
  }
}

void displayingBallisticMissiles() {
  BallisticMissile temp;
  for (int i = 0; i< ballisticMissiles.size(); i++) {
    temp = ballisticMissiles.get(i);
    if (levelTimer == temp.spawnTime) {
      temp.spawn = true;
    }
    temp.update();
  }
}

void destructionBallisticMissiles() {

  BallisticMissile temp;
  for (int i = ballisticMissiles.size()-1; i >= 0; i--) {

    temp = ballisticMissiles.get(i);
    if (temp.hit == true) {
      ballisticMissiles.remove(i);
    }
  }
}

void displayingCities() {

  City temp;
  for (int i = 0; i< aliveCities.size(); i++) {
    temp = aliveCities.get(i);
    temp.update();
  }

  for (int i = 0; i < deadCities.size(); i++) {

    temp = deadCities.get(i);
    temp.update();
  }
}


void drawingAmmo(int xPos, int yPos, int ammo, int spacing) {
  rect(150, 100, 200, 200); // Simple background for testing


  int internalX, startLoop;

  startLoop = 4;

  //TODO
  // Clips, might put in its own Function.


  // draw ammo with a for loop?
  /*
  ------setup-----
   *
   * *
   * * *
   * * * *
   
   */
  for (int stack_height = 0; stack_height < 4; stack_height++) {
    internalX = xPos + ((spacing/2) * stack_height);
    for (int i = 0; i < startLoop && ammo > 0; i++) {
      rect(internalX, yPos, 10, 10);
      internalX += spacing;
      ammo -= 1;
    }
    yPos -= spacing;
    startLoop -= 1;
  }
}

void resetPlayerAmmo() {
  /*
  resets the players ammo and clips at the end of a level
   
   return: void
   
   */
  player.currentAmmo = 10;
  player.ammoClips = 2;
}

void drawingClips(int xPos, int yPos, int clips, int spacing) {

  for (int i = 0; i < clips; i++) {
    rect(xPos, yPos, 10, 10);
    xPos += spacing;
  }
}

boolean testLength(PVector One, PVector Two, int epsilon) {
  /*
  checks whether the PVectors are within a certain range and returns
   true if so and false if not.
   
   return boolean;
   */

  if ( sqrt(pow(One.x - Two.x, 2)  + pow(One.y - Two.y, 2)) < epsilon) {

    return true;
  }

  return false;
}


void addMissile( int amount, int time, int _speed) {
  for (int i = 0; i < amount; i++) {
    ballisticMissiles.add(new BallisticMissile(time, _speed));
  }
}


float calulateAngles() {
  // come back and try and achieve a different max angle depending on the closeness of the missile to the centre of the screen.

  float minAngle = 0;
  float maxAngle = 55;

  return int(random(minAngle, maxAngle));
}

void populateCities() {

  // initializes all of the city objects at the start of the game.
  PVector tempLocation;

  for (int i = 100; i < 700; i += 100) {
    tempLocation = new PVector(i, 200);
    aliveCities.add(new City(tempLocation, 10, 30));
  }
}




/*
-------------------------------------------------------------------------
 Score
 -------------------------------------------------------------------------
 */


void displayScore(String _text, int score, float x, float y) {
  fill(0);
  textSize(24);
  text(("Score: " + globalScore), 400, 50);
}


void addScore(int score) {
  globalScore += score;
}


void bounsScore(ArrayList cityClone) {

  /*
    TODO: this function will loop though everything adding score for all of the bonuses
   at the end of the level (Cities alive, ammo left over), while redrawing and adding
   a delay;
   
   
   return: int
   */


  // display background
  player.update(false);

  if (player.currentAmmo != 0) {

    // add score for ammo and minus and ammo from the player
    // display a 100; on the screen around then ammo;


    return;
  }

  for (int i = 0; i < citiesClone.size(); i++) {
    City temp = citiesClone.get(i);
    if (temp.alive == true) {
      // add score for city
      // display a score above the city
      // remove the city from the clone arrayList
      citiesClone.remove(i);
      return;
    }
  }
  
  // finished will bonus 
  state = 2;
}



/*
-------------------------------------------------------------------------
 Level Handling
 -------------------------------------------------------------------------
 States:
 - 0 : Fresh Game
 - 1 : Start Screen
 - 2 : Loading Level
 - 3 : Playing Level
 - 4 : Bonus Score
 - 5 : Death Screen
 
 */


void gamePathway() {

  if (state == 0) {
    freshGame();
  } else if (state == 1) {
    startScreen();
  } else if (state == 2) {
    loadingLevel();
  } else if (state == 3) {
    playingLevel();
  } else if (state == 4) {
    bounsScore(citiesClone);
  } else if (state == 5) {
    deathScreen();
  }
}


void startScreen() {
  // create some buttons to exit or to star a game. 
  println("we are on the start screen now");
}

void loadingLevel() {

  /*
  
   Things that need to happen on loading a level
   depending on the difficulty the player will have less time,
   more rockets and a faster top speed;
   
   
   */

  resetPlayerAmmo();
  levelTimer = 0;

  amountOfMissile = amountOfMissile += 5;
  if (level % 2 == 0) {
    speedRange++;
  }
  if (speedRange > maxSpeed) {
    // Limits the speed range to go above max speed for the game.
    speedRange--;
  }
  addMissile(amountOfMissile, Timer, speedRange);
  state = 3;
}

void freshGame() {

  // Set at game start or on reset
  player = new Cannon(int(width/2), int((height/8)*5));
  missiles = new ArrayList<Missile>();
  bombs = new ArrayList<Bomb>();
  targets = new ArrayList<circleTarget>();
  ballisticMissiles = new ArrayList<BallisticMissile>();
  cities = new ArrayList<City>();
  citiesClone = new ArrayList<City>();


  Timer = 2000;
  amountOfMissile = 10;
  maxSpeed = 5;
  level = 1;
  speedRange = 1;

  populateCities();
  state = 2;
}   

void playingLevel() {

  player.update(true);

  if (ballisticMissiles.size() > 0) {
    displayingBallisticMissiles();
    destructionBallisticMissiles();
    strokeWeight(1);
  }

  if (missiles.size() > 0) {
    displayingMissile();
    destructionOfMissiles();
  }

  if (bombs.size() > 0) {
    displayingBomb();
    destructionOfBombs();
  }

  displayingCities();

  drawingAmmo(100, 100, player.currentAmmo, 25);
  drawingClips(100, 150, player.ammoClips, 25);

  displayScore();
  levelTimer++;

  if(levelTimer > 3000){
    citiesClone = new ArrayList<City>(cities);
    state = 4;
  }
  // if player hasnt died and missile arraylist is 0 then move onto points tallying.
}

void deathScreen() {


  for (int i = 0; i < 1000; i++) {
    println("sucker");
  }
  state = 0;
}


void keyReleased() {


  if (key == 'x') {
    state += 1;
  }
}





/*
-------------------------------------------------------------------------
 Global Variables
 -------------------------------------------------------------------------
 */


Cannon player;
int generalWidth, generalHeight;
ArrayList<Missile> missiles;
ArrayList<Bomb> bombs;
ArrayList<circleTarget> targets;
ArrayList<BallisticMissile> ballisticMissiles;
ArrayList<City> cities;
ArrayList<City> citiesClone;
int globalScore = 0;
int levelTimer = 0;
int state, Timer, amountOfMissile, speedRange, level, maxSpeed;





void setup() {


  size(1000, 1000);
  generalWidth = int(width / 64);
  generalHeight = int(height / 64);

  noCursor();


  // Set at level start;




  state = 0;
}


void draw() {

  rectMode(CORNER);
  fill(255);
  rect(0, 0, width, height);
  rectMode(CENTER); // just for everything else, but should relocate this call.


  gamePathway();
  println(state);
}
