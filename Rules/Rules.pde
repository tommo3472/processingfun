// currentlocation PVector
// where we want to be Pvector
// from that we need to find a speed and normalize?




ArrayList<Flying> f = new ArrayList<Flying>();




class Flying{
  float x, y;
  int timer, spawnAmount, r, d, speed;
  float[] move;
  float angle;
  boolean spawn;
  int[] boundingCircle = new int[3];
  PVector destination, location, direction;
  
  
 
  Flying(float _x, float _y, int _r, int _d){
    location = new PVector(_x, _y);
    direction = new PVector(int(random(-2, 2)), int(random(-2,2)));
    println(direction);
    print(location);
    r = 100;
    timer = 0;
    angle = 0;
    spawn = true;
    spawnAmount = int(random(360));
    if(_d == 1){
      d = 1;
    } else{
      d = -1;
    }
    speed = 10;
    
    boundingCircle[2] = r;
  }
  
  
  void update(){
    
    
   location.add(direction);
   if(location.x < 0 || location.x > width){
     direction.x *= -1;

   }
   if(location.y < 0 || location.y > height){
     direction.y *= -1;


   }
    
    
    move = findPointOnCircle(location.x, location.y, radians(angle), r);
    boundingCircleUpdate(move[0], move[1]);
    //drawCircle(); // test function
    //timerCheck();
    
    
    strokeWeight(20);
    stroke(0, 150, 150);
    point(move[0], move[1]);
    
    //timer += 2;
    if(d == 1){
      angle += 1;
    } else {
      angle -= 1;
    }
    
    
    
  }
  
  /*void timerCheck(){
   
    if(timer > spawnAmount && spawn == true){
      f.add(new Flying(move[0] - 25, move[1], r, int(random(2))));
      spawn = false;
    }
  }*/
  
  void boundingCircleUpdate(float newX, float newY){
    
    boundingCircle[0] = int(newX);
    boundingCircle[1] = int(newY);
  }
  
  void drawCircle(){
    fill(255, 0, 0, 20);
    strokeWeight(0);
    ellipse(boundingCircle[0], boundingCircle[1], r, r);
  }
  
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


//boolean detectHit(int[] outerBox, int[] innerBox) {


  /*
  
   Checks to see if the corner points of the innerBox are inside of 
   the outerBox corner points. The box is just the cords for a 
   rectangle that we compare against the other rectangle
   given to use in the parameters
   
   This only works if the inner box is smaller or the outerBox is 
   position over a corner when the collision detection is called.
   
   parameters:
   - int[] outerBox (the main box)
   - int[] innerBox (seeing if this box falls within the main one)
   
   the values in each of the arrays are:
   [0] - x
   [1] - y
   [2] - width
   [3] - height
   
   
   return: boolean
   */

/*

  // Top Left Corner
  if (innerBox[0] > outerBox[0] && innerBox[0] < outerBox[0] + outerBox[2] &&
    innerBox[1] > outerBox[1] && innerBox[1] < outerBox[1] + outerBox[3]) {
    return true;
  }

  // Bottom Right Corner
  if (innerBox[0] + innerBox[2] < outerBox[0] + outerBox[2] && innerBox[0]
                              + innerBox[2] > outerBox[0] + 5 &&

    innerBox[1] + innerBox[3] < outerBox[1] + outerBox[3] && innerBox[1]
                              + innerBox[3] > outerBox[1]) {
    return true;
  }

  // Bottom Left Corner
  if (innerBox[0] > outerBox[0] && innerBox[0] < outerBox[0] + outerBox[2] &&
    innerBox[1] + innerBox[3] > outerBox[1] && innerBox[1] + innerBox[3]
                                      < outerBox[1] + outerBox[3]) {
    return true;
  }

  // Top Right Corner

  if (innerBox[0] + innerBox[2] < outerBox[0] + outerBox[2] && innerBox[0] 
                                + innerBox[2] > outerBox[0] &&
                                
    innerBox[1] < outerBox[1] + outerBox[3] && innerBox[1] > outerBox[1]) {
    return true;
  }
  return false;
}

*/


boolean detectHit(int[] circle1, int[] circle2) {
  
  int dx = circle1[0] - circle2[0];
  int dy = circle1[1] - circle2[1];
  float distance = sqrt((dx *dx) + (dy * dy));
  
  
  if(distance < circle1[2] + circle2[2]){
    return true;
  }
  
  return false;
  
}


void hitArray(){
  Flying temp1;
  Flying temp2;
  stroke(236, 190, 20);
  strokeWeight(4);
  for(int i = 0; i< f.size(); i++){
    temp1 = f.get(i);
    
     
    for(int x = 0; x< f.size(); x++){
      temp2 = f.get(x);
      
      
      if(detectHit(temp1.boundingCircle, temp2.boundingCircle)){
         line(temp1.boundingCircle[0], temp1.boundingCircle[1], temp2.boundingCircle[0], temp2.boundingCircle[1]);
      }
      
      
    }
    
    
  }
  
}


void mousePressed(){
 
  int x = mouseX;
  int y = mouseY;
  
  
  f.add(new Flying(x, y, 50, 1));
  
  
}

void updateArray(){
  Flying temp;
  int[] t = {100, 100, width -100, height- 100};
  stroke(0, 150, 150);
  strokeWeight(10);
  for(int i = 0; i< f.size(); i++){
    temp = f.get(i);
    temp.update(); 

  }
  
  /*for(int i = f.size()-1; i > 0; i--){
    temp = f.get(i);
    if(!detectHit(t, temp.boundingCircle)){
      f.remove(i); 
    }
  }*/
}

void setup(){
  size(1000, 1000);
  stroke(0, 150, 150);
  strokeWeight(10);
  f.add(new Flying(int(width/2), int(height/2), 25, 1));
  
  smooth();
}


void draw(){
  background(255);
  hitArray();
  updateArray();
}
