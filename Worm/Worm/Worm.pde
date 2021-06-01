/*
This project is trying to recreate the worm from terraria,

The worm will try and redirct itself when in the ground to target the player and gain
speed

when in the air the worm will stop gaining speed and continue to trave in the same
direction while gravity will be applied.

*/





class Ground{
  /*
  This will be the ground object 
  
  */
  
  float x, y, w, h;
  float[] box;
  
  Ground(float _x, float _y, float _w, float _h){
    
    
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    box = new float[]{x, y, w, h};
    
  }
  
  void drawSprite(){
   
    fill(0, 255, 0);
    rect(x, y, w, h);
    
  }
  
  
}

class Target{
  // The target of the worm
  float x, y, size;
  PVector location;
  Target(){
    x = 400;
    y = 700;
    size = 40;
    location = new PVector(x, y);
  }
  
  void drawSprite(){
    fill(0, 0, 255);
    ellipse(location.x, location.y, size, size);
    
  }
  
  void moveWithMouse(){
   
    location.set(mouseX, mouseY);
    
  }
  
}

class WorldEater{
  float size;
  float xSpeed, ySpeed;
  float angle;
  float angleToTarget;
  PVector location;
  PVector destination, targetLocation, direction;
  PVector[] body;
  int speed;
  boolean ground;
  Target target;
  float[] box;
  
  
  WorldEater(Target t, int spawnX, int spawnY){
    location = new PVector(spawnX, spawnY);
    speed = 2;
    size = 15;
    body = new PVector[5];
    ground = true;
    target = t;
    targetLocation = t.location.copy();
    xSpeed = 5;
    ySpeed = 1;
    ground = false;
    box = new float[]{location.x, location.y, 5, 5};
  }
  
  void drawSprite(){
    fill(255, 0, 0);
    try{
      for(int i = 0; i < body.length; i++){
        
        ellipse(body[i].x, body[i].y, size, size);
        
      } 
    }catch (Exception e){
        println(e);
    }
  }
  
  void newTarget(){
   
    targetLocation = target.location.copy();
    
  }
    
  
  void findDirection(){
    /*
    
    to move we want to go in the direction of the angle gaining speed, then change the angle to try and reaach the target.
    
    
    new to find the angle of the target
    
    
    angle = arccos[
    ((x2 - x1) * (x4 - x3) + 
    (y2 - y1) * (y4 - y3)) /
    (√((x2 - x1)2 + (y2 - y1)2) *
    √((x4 - x3)2 + (y4 - y3)2))
    ]
    
    */
    
    destination = findPointOnCircle(location, radians(angle), 30);
    
    direction = new PVector(targetLocation.x -location.x, targetLocation.y - location.y);
    direction.normalize();
    xSpeed += direction.x;
    ySpeed += direction.y;
    

    float[] d = destination.array();
    float[] l = location.array();
    float[] t = targetLocation.array();
    line(d[0], d[1], l[0], l[1]);
    line(t[0], t[1], l[0], l[1]);
    fill(0);
    ellipse(d[0], d[1], 10, 10);
    
    angleToTarget = PVector.angleBetween(targetLocation, location);
    if (targetLocation.y <= location.y) { angleToTarget = angleToTarget; } else { angleToTarget = angleToTarget + 2*(PI-angleToTarget); }
    println(int(degrees(angleToTarget)));
    
    
    

    
   
    
  }
  
  void gravity(){
   
    ySpeed += 1;
    
    
  }
  
  void move(){
    
    if(xSpeed > 10){
      xSpeed = 10;
    }
    if(xSpeed < -10){
      xSpeed = -10;
    }
    if(ySpeed > 20){
      ySpeed = 20;
    }
    
    location.x +=xSpeed;
    location.y += ySpeed;
    body[0] = location.copy(); 
    box[0] = location.x;
    box[1] = location.y;
    
    
  }
  
  PVector findPointOnCircle(PVector location, float angle, float radius) {

    PVector temp = new PVector();
    // y = r * sin(angle);
    // x = r * cos(angle);
    // r = 50;
    // angle = 50
  
  
    temp.x = location.x + (radius * cos(angle));
    temp.y = location.y + (radius * sin(angle));
  
    return temp;
  }
  
  
  void shiftBodyRight(){
    
    for(int i = body.length - 1; i > 0; i--){
      body[i] = body[i - 1];     
    }
  } 
}


boolean detectHitRect(float[] rect1, float[] rect2) {
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

void WorldStuff(WorldEater a){
  a.move();
  
  a.drawSprite();
  a.shiftBodyRight();
  a.newTarget();
  
  
}

WorldEater b;
WorldEater c;
WorldEater d;
WorldEater e;
Target target;
Ground[] ground = new Ground[3];

void setup(){
  size(1000,1000);
 
  ground[0] = new Ground(0 - width * 2, 800, width * 5, height * 3);
  ground[1] = new Ground(100, 300, 800, 50);
  ground[2] = new Ground(100, 600, 800, 100);
  target = new Target();
  b = new WorldEater(target, 400, 900);
  c = new WorldEater(target, 600, 900);
  d = new WorldEater(target, 800, 900);
  e = new WorldEater(target, 200, 900);
}


void draw(){
  background(255);
  
  
  for(int i = 0; i< ground.length; i++){
    if(detectHitRect(e.box, ground[i].box)){
      e.ground = true;
    }
    ground[i].drawSprite();
  }
  
  if(e.ground){
    e.findDirection();
  } else {
    e.gravity();
  }
  e.ground = false;
  target.drawSprite();
  target.moveWithMouse();
  WorldStuff(b);
  WorldStuff(c);
  WorldStuff(d);
  WorldStuff(e);
  
  
}
