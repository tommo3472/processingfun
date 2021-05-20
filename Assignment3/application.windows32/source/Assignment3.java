import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Assignment3 extends PApplet {

 //<>//
/*

 
 Things to do:
 - Add a Header
 - Comment The Code
 - Sounds
 
 */


/*

 -------------------------------------------------------------------------
 Directory
 -------------------------------------------------------------------------
 
 // Add the sections in the code and which line they start at.
 
 
 
 
 
 */


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
ArrayList<SmartBallisticMissile> smartBallisticMissiles;
ArrayList<City> cities;
ArrayList<City> citiesClone;
ArrayList<Score> midGameScore;
int globalScore = 0;
int levelTimer = 0;
int state, Timer, amountOfMissiles, level, maxSpeed, bonusTimer;
int[] colour = {0xFFa81ee1, 0xFF2f8cd0, 0xFF4cb390, 0xFFbcbb43, 0xFF82857a};
float speedRange;
int skyCol;
int mountainCol;


/*
-------------------------------------------------------------------------
 Classes
 -------------------------------------------------------------------------
 */


class City {
  /*
  
   Class for the city object, draws the object to the screen.
   Keeps track of if its hit and if it is hit plays an death animation.
   
   paramters:
   - boundingBox: float list > for holding postion and size variables
   for hit detection.
   - position: PVector > for the x and y position on the screen.
   - alive: boolean > a check for removing the object for the game.
   - w: float > width of object
   - h: float > height of object
   - count: int > counter for the death animation
   - size: int > size of the death animation
   
   */

  float[] boundingBox;
  PVector position;
  boolean alive;
  float w, h;
  int count, size;

  City(PVector _position, float _w, float _h) {

    position = _position;
    w = _w;
    h = _h;
    boundingBox = new float[]{position.x-10, position.y-20, _w, _h};
    alive = true;
  }


  public void update() {
    /*
    the update function for the city object. Draws the object and
     death animation if alive = false.
     
     
     return: void
     */

    drawShape();
    if (!alive) {
      deathAnimation();
    }

    //drawBox();
  }

  public void deathAnimation() {
    /*
    Draws the death animation over the city a box that is the same colour as
     the background. Keeps track of how long the the city has been hit and
     the size of the box is a third of that time. Creats a sliding effect.
     
     return: void
     */

    size = count/3;
    fill(skyCol);
    rectMode(CORNER);
    rect(boundingBox[0], boundingBox[1]-20, boundingBox[2], size);
    rectMode(CENTER);
    count += 1;
    if (count > 150) {
      count = 150;
    }
  }

  public void reviveCity() {
    /*
    When called sets the city back alive and resets
     the count and size of the death animation box.
     
     return: void
     */
    alive = true;
    count = 0;
    size = 0;
  }

  public void drawShape() {
    /*
    Calls the drawCities function which acts as the sprite for
     the City Object.
     
     return: void
     */
    drawCities(position.x, position.y);
  }

  public void drawBox() {
    /*
    A test void for check where the boundingBox zone is
     around the City.
     
     return: void
     */
    fill(255, 0, 0, 50);
    rectMode(CORNER);
    rect(boundingBox[0], boundingBox[1], boundingBox[2], boundingBox[3]);
    rectMode(CENTER);
  }
}


class Missile {


  /*
  
   Missile class for a projectile sent out by the player. When the player clicks
   this will be spawned at the cannons location and have a destination of the
   mouse at the time of the click. When the Missile gets to its location it
   will despawn and spawn a Bomb.
   
   parameters:
   - location: PVector > Current location of the Missile
   - destination: PVector > The destination of where the Missile is going to
   go
   - direction: PVector > A Normalized version of how far away the location.
   is from the desitination
   - epsilon: float > for checking the location and destination.
   - boom: boolean > Check for when the missile has reached its location
   and to be deleted while spawning a Bomb.
   
   
   arguments:
   
   
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

  public void update() {
    /*
    Called every frame that the object is in the game. Moves the 
     Missile, draws the Sprite and checks to see if the Missile has
     reached its location.
     
     return: void
     */

    targetReachedDestinationCheck();
    move();
    drawMissile();
    //drawTargetLocation();
  }

  public void drawTargetLocation() {
    /*
    test function for seeing where the missile should stop at.
     
     return: void
     */

    line(location.x, location.y, destination.x, destination.y);
  }

  public void move() {
    /*
    Adds the direction to the Missile to move it in the direction
     of the destination.
     
     return: void
     */

    location.add(direction);
  }

  public void drawMissile() {
    /*
    Draws the sprite for the Missile, giving it the colour
     of the mountain background.
     
     return: void
     */
    strokeWeight(5);
    stroke(0);
    fill(mountainCol);
    rect(location.x, location.y, generalWidth, generalHeight);
    strokeWeight(1);
  }

  public void targetReachedDestinationCheck() {
    /*
    
     Checks if the location x and y are close enough to the destination x and y.
     Sets boom to false so that the object can be removed. Creates a Bomb object
     for the explosion.
     
     return: void
     */

    if (abs(destination.x - location.x) <= epsilon && abs(destination.y - location.y) <= epsilon) {
      boom = true; 
      bombs.add(new Bomb(new PVector(destination.x, destination.y)));
    }
  }
}

class Score {
  /*
  The Score class creates a object that allows for text to be shown on screen
   for a duration of time. Used for when Ballistic Missiles are destoried.
   
   paramters:
   - remove: boolean > 
   For checking if the object should be removed
   - aliveTime: int > 
   Keeps track of how long the object has been in the game for
   - s: String >
   The string that will be displayed for this object
   - x: float >
   x position in the game
   - y: float >
   y position in the game
   - score: int >
   The amount of score that has been awarded to be added to the string
   
   
   
   */

  boolean remove;
  int aliveTime;
  String s;
  float x, y;
  int score;
  Score(String _s, int _score, float _x, float _y) {
    remove = false;
    s = _s;
    x = _x;
    y = _y;
    score = _score;
    aliveTime = 0;
  }

  public void update() {
    /*
    Checks whether the object has been around for 100 frame and if so
     flags it for removal. Draws the object to the game and increments
     the aliveTime.
     
     return: void
     */
    if (aliveTime == 100) {
      remove = true;
    }
    displayScore(s, score, x, y);
    aliveTime++;
  }
}

class Cannon {

  /*
  The Cannon class handles the 
   
   
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


  public void update(boolean allowShot) {
    getMousePos();

    drawCannon();
    resetAmmoWithClip();
    if (allowShot) {
      checkForShot();
      drawCrossHair();
    }
  }

  public void drawCannon() {
    fill(220, 220, 220);
    rectMode(CENTER);
    rect(location.x, location.y, size[0] * 2, size[1]);
  }

  public void resetAmmoWithClip() {
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


  public void drawCrossHair() {
    fill(220, 220, 220);
    rect(mouseLocation.x, mouseLocation.y, 30, 4);
  }

  public void getMousePos() {
    mouseLocation.x = mouseX;
    mouseLocation.y = mouseY;
  }

  public void checkForShot() {
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
  int w, h, aliveTime, colourSelector, change;
  boolean fizzle, expand;
  float[] boundingCircle; // x, y, d

  Bomb(PVector _location) {
    location = _location;
    w = 1;
    h = 1;
    fizzle = false;
    expand = true;
    aliveTime = 1;
    change = 1;
    colourSelector = 1;
    boundingCircle = new float[]{location.x, location.y, w * 1.3f};
  }

  public void update() {
    /*
    A check for 
     
     
     return: void
     */

    if (w % 3 == 0) {
      if (w % 15 == 0) {
        colourSelector = floor(random(4.9f));
      }
      noStroke();

      fill(colour[colourSelector]);
      drawExplosion();
      stroke(0);
      fill(255);
    }

    updateBounding();
    //drawBounding();
    checkIfFinished();

    if (expand) {
      w += 2;
      h += 2;
      aliveTime += 2;
    } else {
      w -= 2;
      h -= 2;
      aliveTime -= 2;
    }
  }

  public void drawExplosion() {

    if (change % 2 == 0) {
      rect(location.x, location.y, w*1.2f, h);
      rect(location.x, location.y, w, h*1.2f);
      rect(location.x, location.y, w*0.8f, h*1.4f);
      rect(location.x, location.y, w*1.4f, h*0.8f);
    } else if (change % 3 == 0) {
      rect(location.x, location.y, w*1, h);
      rect(location.x, location.y, w, h*1.3f);
      rect(location.x, location.y, w*0.6f, h*1.6f);
      rect(location.x, location.y, w*1.5f, h*0.7f);
    } else {

      rect(location.x, location.y, w*1.3f, h*1.1f);
      rect(location.x, location.y, w*1.5f, h*0.5f);
      rect(location.x, location.y, w*1.3f, h*0.8f);
      rect(location.x, location.y, w*1.2f, h*0.9f);
    }
    change += 1;
  }

  public void updateBounding() {

    boundingCircle[2] = (w * 1.3f);
  }

  public void drawBounding() {

    fill(255, 0, 0, 10);
    ellipse(location.x, location.y, boundingCircle[2], boundingCircle[2]);
    fill(255);
  }

  public void checkIfFinished() {
    /*
   checks whether the object has been alive long enough to be destoried eg. the explosion 
     has done its thing.
     
     return: void
     */

    if (aliveTime == 101) {

      expand = false;
    }

    if (aliveTime == -1) {
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

  public void update() {

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
  PVector missile_speed;
  boolean direction, hit, spawn; // true = right, false = left;
  int[] tail_colour, missile_colour;
  PVector[] tail_pos;
  float[] boundingBox;
  int spawnTime; 



  BallisticMissile(int _spawnTime, int _speed) {
    tail_colour =  new int[]{0, 0, 255};
    boundingBox = new float[]{0, 0, 10, 10};
    missile_colour = new int[]{0, 255, 255};

    theta = calulateAngles();
    missile_start_pos = new PVector(random(20, width - 20), 0);
    missile_pos = new PVector(missile_start_pos.x, missile_start_pos.y);
    missile_speed =  new PVector(tan(radians(theta)), ceil(random(0, _speed)));
    hit = false;
    spawnTime = PApplet.parseInt(random(_spawnTime));
    spawn = false;

    if (missile_start_pos.x < width/2) {
      direction = true;
    } else {
      direction = false;
    }
  }

  public void update() {
    if (spawn) {
      calc_pos();

      drawObject();
      updateBox();
      //boundingCircle();
      deleteAtScreenLimit();
    }
  }

  public void deleteAtScreenLimit() {

    if (missile_pos.y > 910) {

      hit = true;
    }
  }

  public void updateBox() {

    boundingBox[0] = missile_pos.x;
    boundingBox[1] = missile_pos.y;
  }

  public void drawObject() {


    stroke(tail_colour[0], tail_colour[1], tail_colour[2]);
    strokeWeight(3);
    if (direction) {
      line(missile_pos.x, missile_pos.y, missile_pos.x - (missile_speed.x * 50), 
        missile_pos.y - (missile_speed.y * 50)); // Missile Tail.
    } else {
      line(missile_pos.x, missile_pos.y, missile_pos.x + (missile_speed.x * 50), 
        missile_pos.y - (missile_speed.y * 50)); // Missile Tail.
    }
    stroke(missile_colour[0], missile_colour[1], missile_colour[2]);
    ellipse(missile_pos.x, missile_pos.y, 10, 10); // Missile Head
    stroke(0);
    strokeWeight(1);
  }

  /*void boundingCircle() {
   noStroke();
   fill(255, 0, 0, 50);
   ellipse(missile_pos.x, missile_pos.y, diameter, diameter);
   }*/

  public void calc_pos() {

    if (direction) {
      missile_pos.x += missile_speed.x;
    } else {
      missile_pos.x -= missile_speed.x;
    }
    missile_pos.y +=  missile_speed.y;
  }
}

class SmartBallisticMissile extends BallisticMissile {
  // create a missile that will have a auto lock on to the
  // player or a city.

  PVector target, direction;
  SmartBallisticMissile(int _spawnTime, int _speed) {
    super(_spawnTime, _speed);
    target = getTarget();
    direction =  new PVector(target.x - missile_pos.x, target.y - missile_pos.y);
    direction.normalize();
    direction.mult(ceil(random(_speed)));
  }

  public void update() {
    if (spawn) {
      calc_pos();
      updateBox();
      drawObject();
      deleteAtScreenLimit();
    }
  }

  public void drawObject() {

    line(missile_pos.x -5, missile_pos.y, missile_pos.x + 5, missile_pos.y);
    line(missile_pos.x -5, missile_pos.y, missile_pos.x + 5, missile_pos.y-1);
    line(missile_pos.x -5, missile_pos.y, missile_pos.x + 5, missile_pos.y+1);
  }


  public void calc_pos() {

    missile_pos.add(direction);
  }


  public PVector getTarget() {
    // find a target out of the cities
    // return: PVector

    int i = floor(random(5.1f));
    City temp = cities.get(i);
    PVector tempVector = new PVector(temp.position.x, temp.position.y);
    tempVector.x += temp.w/2;

    return tempVector;
  }
}


public boolean detectHitCirlce(float[] circle1, float[] circle2) {
  /*
  Checks if two circles are touching.
  each Array should consist of
  X, Y, Diameter
  
  return: boolean
  */

  float dx = circle1[0] - circle2[0];
  float dy = circle1[1] - circle2[1];
  float distance = sqrt((dx *dx) + (dy * dy));


  if (distance < (circle1[2] / 2) + (circle2[2] / 2)) {
    return true;
  }

  return false;
}

public boolean detectHitRect(float[] rect1, float[] rect2) {
  /*
  Checks if two rectangle are touching.
  each Array given should consist of an
  X, Y, Width, Height variable
  
  arguments:
  - rect1: float Array >
  the first rectangle
  - rect2: float Array >
  the second rectangle
  
  return: boolean
  */
  if (rect1[0] < rect2[0] + rect2[2] &&
    rect1[0] + rect1[2] > rect2[0] &&
    rect1[1] < rect2[1] + rect2[3] &&
    rect1[1] + rect1[3] > rect2[1]) {
    // collision detected!
    return true;
  }

  return false;
}

/*

 -------------------------------------------------------------------------
 Drawing background
 -------------------------------------------------------------------------
 
 */
public void drawSky(int skyHeight, int skyWidth) {
  /*
  Draws the Sky part of the background
  
  return: void
  */
  noStroke();
  fill(skyCol);
  rectMode(CORNER);
  rect(0, 0, skyWidth, skyHeight);
  rectMode(CENTER);
}
// Draws mountains with random colour values
public void drawMountains() {
  /*
  draws the mountain part of the background
  
  return: void
  */
  rectMode(CORNER);
  fill(mountainCol);
  rect(0, height - 75, width, 75); // Floor base
  rect(0, height - 100, 50, 75); // Left block
  rect(width - 50, height - 100, 50, 75); // Right Block
  rect(width / 2 - 80, height - 80, 200, 200); // Middle mountain
  rect(width / 2 - 70, height - 84, 180, 180);
  rect(width / 2 - 62, height - 88, 160, 160);
  rect(width / 2 - 54, height - 92, 140, 140);
  rect(width / 2 - 46, height - 96, 120, 120);
  rect(width / 2 - 38, height - 100, 100, 100);
  rect(width / 2 - 30, height - 104, 80, 80);
  rect(width / 2 - 22, height - 108, 60, 60);
  rect(width / 2 - 14, height - 112, 40, 40);
  rect(width / 2 - 6, height - 116, 20, 20);
  rectMode(CENTER);
}
// Draw cities, fixed colour
public void drawCities(float x, float y) {
  /*
  Draws the City sprite at the position given and is used
  for the City object as it sprite
  
  arguments:
  - x: float >
  x location in the game
  - y: float >
  y location in the game
  
  */
  rectMode(CORNER);
  noStroke();
  fill(255);
  rect(x + 25, y -25, 10, 40);
  fill(0);
  rect(x + 27, y - 23, 2, 2);
  rect(x + 31, y - 23, 2, 2);
  rect(x + 27, y - 19, 2, 2);
  rect(x + 31, y - 19, 2, 2);
  rect(x + 27, y - 15, 2, 2);
  rect(x + 31, y - 15, 2, 2);
  rect(x + 27, y - 11, 2, 2);
  rect(x + 31, y - 11, 2, 2);
  rect(x + 27, y - 7, 2, 2);
  rect(x + 31, y - 7, 2, 2);
  rect(x + 27, y - 3, 2, 2);
  rect(x + 31, y - 3, 2, 2);
  rect(x + 27, y + 1, 2, 2);
  rect(x + 31, y + 1, 2, 2);
  fill(125);
  rect(x + 5, y - 10, 2.5f, 20);
  fill(255);
  rect(x, y, 20, 15);
  fill(175);
  rect(x - 5, y + 5, 30, 10);
  fill(0);
  rect(x + 3, y + 2.5f, 2, 2);
  rect(x + 8, y + 2.5f, 2, 2);
  rect(x + 13, y + 2.5f, 2, 2);
  rectMode(CENTER);
}


public void drawBackground() {


  drawSky(height, width);
  drawMountains();
}





/*
-------------------------------------------------------------------------
 Drawing And Destruction of Objects
 -------------------------------------------------------------------------
 */

public void displayingMissile() {
  Missile temp;
  for (int i = 0; i < missiles.size(); i++) {

    temp = missiles.get(i);
    temp.update();
  }
}

public void destructionOfMissiles() {
  /*
  checks whether any of the missiles have been flagged for deletion
  and if so removes them from the Array List
   
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


public void displayingBomb() {
  /*
  loops though all Bomb objects in the bombs array and
   runs the update() function for that object.
   
   
   also checking for hit detection with targets.
   
   
   return: void
   */
  Bomb temp;
  BallisticMissile tempTarget;
  SmartBallisticMissile tempSmartTarget;
  for (int i = 0; i < bombs.size(); i++) {

    temp = bombs.get(i);
    if (temp.aliveTime % 3 == 0) { // Check every third frame maybe delet on the main game.
      for (int t = 0; t < ballisticMissiles.size(); t++) {
        tempTarget = ballisticMissiles.get(t);
        if (detectHitCirlce(temp.boundingCircle, tempTarget.boundingBox)) {

          tempTarget.hit = true;
          // Ballistic Missile Taken Out
          addScore(100);
          midGameScore.add(new Score("+", 100, tempTarget.missile_pos.x, tempTarget.missile_pos.y));
        }
      }
      for (int t = 0; t < smartBallisticMissiles.size(); t++) {
        tempSmartTarget = smartBallisticMissiles.get(t);
        if (detectHitCirlce(temp.boundingCircle, tempSmartTarget.boundingBox)) {

          tempSmartTarget.hit = true;
          // Ballistic Missile Taken Out
          addScore(200);
          midGameScore.add(new Score("+", 200, tempSmartTarget.missile_pos.x, tempSmartTarget.missile_pos.y));
        }
      }
    }
    temp.update();
  }
}


public void destructionOfBombs() {
  /*
  Goes though all the Bomb objects and jects if they have
  been flagged for removal
   
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

public void createTargets() {

  for (int x = 10; x < width - 10; x += 100) {
    for (int y = 10; y < height - 10; y += 100) {

      targets.add(new circleTarget( x, y));
    }
  }
}

public void displayingBallisticMissiles() {
  /*
  Goes though all the Ballistic Missile Objects and runs the 
  update function.
  
  It also checks The hit detection between itself and the other 
  City objects. If a hit was detected it flags itself for deletion
  and the city for death animation.
  
  
  return void
  */
  BallisticMissile temp;
  City tempCity;
  for (int i = 0; i< ballisticMissiles.size(); i++) {
    temp = ballisticMissiles.get(i);
    if (levelTimer == temp.spawnTime) {
      temp.spawn = true;
    }

    for (int x = 0; x< cities.size(); x++) {
      tempCity = cities.get(x);
      if (tempCity.alive == true) {
        if (detectHitRect(temp.boundingBox, tempCity.boundingBox)) {
          temp.hit = true;
          tempCity.alive = false;
        }
      }
    }
    temp.update();
  }
}

public void destructionBallisticMissiles() {
  /*
  Checks whether a Ballistic Missile has been flagged for
  removal and if it is removes it from the Array List
  
  return void
  */

  BallisticMissile temp;
  for (int i = ballisticMissiles.size()-1; i >= 0; i--) {

    temp = ballisticMissiles.get(i);
    if (temp.hit == true) {
      ballisticMissiles.remove(i);
    }
  }
}


public void displayingSmartBallisticMissiles() {
  /*
  Goes though all the Smart Ballistic Missile Objects and runs the 
  update function.
  
  It also checks The hit detection between itself and the other 
  City objects. If a hit was detected it flags itself for deletion
  and the city for death animation.
  
  
  return void
  */
  SmartBallisticMissile temp;
  City tempCity;
  for (int i = 0; i< smartBallisticMissiles.size(); i++) {
    temp = smartBallisticMissiles.get(i);
    if (levelTimer == temp.spawnTime) {
      temp.spawn = true;
    }
    for (int x = 0; x< cities.size(); x++) {
      tempCity = cities.get(x);
      if (tempCity.alive == true) {
        if (detectHitRect(temp.boundingBox, tempCity.boundingBox)) {
          temp.hit = true;
          tempCity.alive = false;
        }
      }
    }
    temp.update();
  }
}

public void destructionSmartBallisticMissiles() {

  SmartBallisticMissile temp;
  for (int i = smartBallisticMissiles.size()-1; i >= 0; i--) {

    temp = smartBallisticMissiles.get(i);
    if (temp.hit == true) {
      smartBallisticMissiles.remove(i);
    }
  }
}

public void displayingCities() {
  /*
  Goes though all the City Objects within the cities Array List
  and runs the update function
  
  
  return void
  */

  City temp;
  for (int i = 0; i< cities.size(); i++) {
    temp = cities.get(i);
    temp.update();
  }
}


public void handlingScore() {
  /*
  Goes though all the Score Objects within the cities Array List
  and runs the update function
  
  Also checks if A score object has been flagged for removal and
  if so removes it from the Array List
  
  return void
  */

  Score temp;
  for (int i = 0; i < midGameScore.size(); i++) {
    temp = midGameScore.get(i);
    temp.update();
  }

  for (int i = midGameScore.size() - 1; i > -1; i--) {
    temp = midGameScore.get(i);
    if (temp.remove) {
      midGameScore.remove(i);
    }
  }
}


public void drawingAmmo(int xPos, int yPos, int ammo, int spacing) {


  

  /*
  
  Draws the player amount of Ammo to the screen in a cascading 
  way like a pyramid.
   
   
   return: void
   */
   
  int internalX, startLoop;

  startLoop = 4;

  fill(skyCol);
  for (int stack_height = 0; stack_height < 4; stack_height++) {
    internalX = xPos + ((spacing/2) * stack_height);
    for (int i = 0; i < startLoop && ammo > 0; i++) {
      rect(internalX, yPos, 10, 10);
      internalX += spacing;
      ammo -= 1;
    }
    yPos -= spacing/2;
    startLoop -= 1;
  }
}

public void resetPlayerAmmo() {
  /*
  resets the players ammo and clips at the end of a level
   
   return: void
   
   */
  player.currentAmmo = 10;
  player.ammoClips = 2;
}

public void drawingClips(int xPos, int yPos, int clips, int spacing) {
  /*
  Draws the Clips sprite to the screen
  
  
  return: void
  */

  for (int i = 0; i < clips; i++) {
    rect(xPos, yPos, 10, 10);
    xPos += spacing;
  }
}

public boolean testLength(PVector One, PVector Two, int epsilon) {
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


public void addMissile( int amount, int time, int _speed) {
  /*
  initalizes the missiles for the level and places them in
  the ballisticMissiles ArrayList.
  
  arguments:
    - amount: int >
    The amount of Ballistic Missiles to be created
    - time: int >
    The time in which the missile will spawn during the level
    - _speed: int >
    the speed for the BallisticMissile
  
  */
  for (int i = 0; i < amount; i++) {
    ballisticMissiles.add(new BallisticMissile(time, _speed));
  }

  if (level > 5) {
    for (int i = 0; i < ceil(amount/20); i++) {
      smartBallisticMissiles.add(new SmartBallisticMissile(time, _speed));
    }
  }
}


public float calulateAngles() {
  /*
  gives a angleBetween minAngle and maxAngle
  
  return: float
  */

  float minAngle = 0;
  float maxAngle = 55;

  return PApplet.parseInt(random(minAngle, maxAngle));
}

public void populateCities() {

  // initializes all of the city objects at the start of the game.
  // at a increasing x position 
  
  // return: void
  
  PVector tempLocation;

  for (int i = 100; i < 950; i += 100) {
    tempLocation = new PVector(i, 910);
    cities.add(new City(tempLocation, 55, 35));
    if (i == 300) {
      i += 250;
    }
  }
}


public boolean gameOver() {
  /*
  
  Checks if there are any City objects alive,
  If there are returns true if not returns false.
  
  return: boolean
  */
  int counter = 0;
  City temp;
  for (int i = 0; i < cities.size(); i++) {

    temp = cities.get(i);
    if (temp.alive == true) {
      counter += 1;
    }
  }

  if (counter == 0) {
    return true;
  }

  return false;
}


public void reviveCity() {
  /*
  Called at the start of a level and randomly revives a
  City
  
  return: void
  */
  int city = floor(random(5.1f));
  City temp = cities.get(city);
  temp.alive = true;
}





/*
-------------------------------------------------------------------------
 Score
 -------------------------------------------------------------------------
 */


public void displayScore(String _text, int score, float x, float y) {
  /*
  Displaies a text object onto the screen.
   Arguments:
   - _text: String >
   The string that will be attached to the score that will be displayed
   on the screen.
   - score: int >
   The score that will be displayed.
   - x: float >
   x position on the screen.
   - f: float >
   y position on the screen.
   
   */
  fill(0);
  textSize(24);
  text((_text + score), x, y);
}


public void addScore(int score) {
  /*
  Adds the paramter int to the globalScore
   
   
   return void
   */
  globalScore += score;
}


public void bounsScore() {

  /*
    Goes though all the Player ammo and City and grants extra
    bonus score for each one left at the end of the level. giving
    a delay inbetween and changing the state to 2 when there are no
    ammo or cities left.
   
   
   return: void
   */



  player.update(false);

  if (player.currentAmmo != 0) {

    // add score for ammo and minus and ammo from the player
    // display a 100; on the screen around then ammo;
    player.currentAmmo -= 1;
    globalScore += 25;
    displayScore("+", 25, width/2, height/2);
    delay(100);
    return;
  }

  if (citiesClone.size() != 0) {
    City temp = citiesClone.get(0);
    if (temp.alive == true) {
      // add score for city
      // display a score above the city
      // remove the city from the clone arrayList
      globalScore += 100;
      displayScore("+", 100, temp.position.x, temp.position.y);
    }
    delay(250);
    citiesClone.remove(0);
    return;
  }

  // finished with the bonus 
  level += 1;
  state = 2;
}



/*
-------------------------------------------------------------------------
 Level Handling
 -------------------------------------------------------------------------
 States:
 - 0 : Start Screen
 - 1 : Game Setup
 - 2 : Loading Level
 - 3 : Playing Level
 - 4 : Bonus Score
 - 5 : Death Screen
 
 */


public void gamePathway() {
  /*
  A state machinge that
   Controls the flow of the game depending on the 'state' variable
   
   return: void
   */


  drawBackground();



  if (state == 0) {
    startScreen();
  } else if (state == 1) {
    gameSetup();
  } else if (state == 2) {
    loadingLevel();
    reviveCity();
  } else if (state == 3) {
    playingLevel();
  } else if (state == 4) {
    drawGameObjects();
    bounsScore();
  } else if (state == 5) {
    deathScreen();
  }
}



public void loadingLevel() {

  /*
  Gets everything ready for the next level.
   
   >Refreshs the ArrayList of some objects
   >selects new colours for the background.
   >Refreshes the players ammo
   >Sets the amount and speed of missiles
   >Sets the state of the game to 3
   
   
   */
  reloadArrayList();
  skyCol = color(random(1, 255), random(1, 255), random(1, 255));
  mountainCol = color(random(1, 255), random(1, 255), random(1, 255));
  resetPlayerAmmo();
  levelTimer = 0;
  bonusTimer = 0;

  amountOfMissiles = amountOfMissiles + 1;
  if (amountOfMissiles > 30) {
    amountOfMissiles = 30;
  }

  speedRange += 0.2f;
  if (speedRange > maxSpeed) {
    // Limits the speed range to go above max speed for the game.
    speedRange = maxSpeed;
  }
  println(speedRange);
  addMissile(amountOfMissiles, Timer, floor(speedRange));
  state = 3;
}

public void gameSetup() {
  /*
  The games Setup function so that we can load
   the variables after the start screen. The start
   settings of the game and be can be changed here.
   
   sets the state of the game to 2
   return: void
   */
  player = new Cannon(PApplet.parseInt(width/2 +5), 881);
  missiles = new ArrayList<Missile>();
  bombs = new ArrayList<Bomb>();
  targets = new ArrayList<circleTarget>();
  ballisticMissiles = new ArrayList<BallisticMissile>();
  smartBallisticMissiles = new ArrayList<SmartBallisticMissile>();
  cities = new ArrayList<City>();
  citiesClone = new ArrayList<City>();
  midGameScore =  new ArrayList<Score>();
  bonusTimer = 0;
  globalScore = 0;


  Timer = 1000;
  amountOfMissiles = 10;
  maxSpeed = 5;
  level = 1;
  speedRange = 1;

  populateCities();
  state = 2;
}   

public void playingLevel() {


  drawGameObjects();
  player.update(true);

  levelTimer++;

  if (smartBallisticMissiles.size() < 1 && ballisticMissiles.size() < 1) {
    reloadArrayList();
    state = 4;
  }

  if (gameOver()) {


    state = 5;
    reloadArrayList();
  }
}

public void deathScreen() {
  /*
  The Death screen of the game shown when a player
   has lost all the cities, shows the Stats for the game and
   allows the player to quite or retry with 'f' or 'r' 
   repectfully
   
   return: void
   */

  fill(255, 200);
  textSize(32);
  text("You lost!", width/2-75, height/2 - 100);
  text("Your score was: "+ globalScore, width/2 - 125, height/2-50);
  text("You made it to level: " + level, width/2 - 175, height/2 );
  text("Press 'r'  to go again or 'f' to rage quit", width/2 - 275, height/2+ 50);

  if (keyPressed) {

    if (key == 'r') {
      state = 0;
    } else if (key == 'f') {
      exit();
    }
  }
}

public void startScreen() {
  /*
  A simple start screen for the game that gives the player
   a little animation and can be bypassed by pressing the 'y'
   keyboard key
   
   sets state = 1
   return: void
   */
  rectMode(CORNER);
  fill(255, 200);
  textSize(32);
  fill(mountainCol);
  float third = height/3;
  rect(0, 0, width, third);
  rect(0, third*2, width, third);
  fill(skyCol);
  rect(0, third, width, third);
  rectMode(CENTER);

  fill(255, 220);
  text("Welcome to the JANK Missile Command Game", width/2-350, height/2 - 100);
  text("You are tasked with defending the cities and if they fall,", width/2 - 475, height/2-50);
  text("all will be lost! The controls are simple. Aim your Cannon with", width/2 - 475, height/2+ 0);
  text("the mouse, send out a missile with the left mouse button.", width/2 - 475, height/2+50 );
  text("Good luck, when you are ready hit 'y'.", width/2 - 300, height/2+ 100);

  if (keyPressed && key == 'y') {
    state = 1;
  }
}

public void reloadArrayList() {
  /*
  Resets some of the ArrayList of the game so that
   objects arent transfered across levels.
   
   return: void
   */
  citiesClone = new ArrayList<City>(cities);
  ballisticMissiles = new ArrayList<BallisticMissile>();
  smartBallisticMissiles = new ArrayList<SmartBallisticMissile>();
  missiles = new ArrayList<Missile>();
  bombs = new ArrayList<Bomb>();
}

public void drawGameObjects() {
  /*
  Draws the assets of the game to the screen and also
   checks if objects need to be removed.
   
   return: void
   */
  rectMode(CENTER); // just for everything else, but should relocate this call.

  displayingCities();

  if (ballisticMissiles.size() > 0) {
    displayingBallisticMissiles();
    destructionBallisticMissiles();
    strokeWeight(1);
  }



  if (smartBallisticMissiles.size() > 0) {
    displayingSmartBallisticMissiles();
    destructionSmartBallisticMissiles();
  }

  if (missiles.size() > 0) {
    displayingMissile();
    destructionOfMissiles();
  }

  if (bombs.size() > 0) {
    displayingBomb();
    destructionOfBombs();
  }

  drawingAmmo(width/2 - 30, 940, player.currentAmmo, 25);
  drawingClips(100, 950, player.ammoClips, 25);

  displayScore("Score:", globalScore, 500, 50);
  handlingScore();
}


public void setup() {
  /*
  The setup of the program with some of the starting variables need
   There is a later function that will initialize other variables.
   
   return: void
   */

  
  generalWidth = PApplet.parseInt(width / 64);
  generalHeight = PApplet.parseInt(height / 64);
  skyCol = color(random(1, 255), random(1, 255), random(1, 255));
  mountainCol = color(random(1, 255), random(1, 255), random(1, 255));
  noCursor();

  state = 0;
}


public void draw() {
  /*
  Main loop of the game simply runs the gamePathway function
   to see which way the program should run.
   */
  gamePathway();
}
  public void settings() {  size(1000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Assignment3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
