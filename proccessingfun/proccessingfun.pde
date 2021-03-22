int positionOfDot;
ArrayList<Dot> fallingDots;
int topSpeed;

class Dot{
  int x, y, speed;
  int[] direction = new int[2];
  ArrayList<Integer> colour;
  
 Dot(int _x, int _y, int _directionX, int _directionY, int _speed, ArrayList<Integer> _rgb){
   x = _x;
   y = _y;
   direction[0] = _directionX;
   direction[1] = _directionY;
   speed = _speed;
   colour = _rgb;
 }
 
 void update(){
  stroke(colour.get(0), colour.get(1), colour.get(2));
  line(x, y, x+ (direction[0] * 5), y+ (direction[1] * 5)); 
 }
 
 void move(){
   
   x = x + (direction[0] * speed);
   y = y + (direction[1] * speed);
   
 }
 
 boolean delete(){
   
   if(x > width || x < 0 || y > height || y < 0){
     
     if(direction[0] == 1 && direction[1] == 1){
       fallingDots.add(new Dot(x, y, -1, -1, speed, this.colour));
       
     } else if(direction[0] == 0 && direction[1] == 1) {
       fallingDots.add(new Dot(x, y, 0, -1, speed, this.colour));
       
     } else if(direction[0] == -1 && direction[1] == 1) {
       fallingDots.add(new Dot(x, y, 1, -1, speed, this.colour));
       
     } else if(direction[0] == 1 && direction[1] == -1) {
       fallingDots.add(new Dot(x, y, -1, 1, speed, this.colour));
       
     } else if(direction[0] == 1 && direction[1] == 0) {
       fallingDots.add(new Dot(x, y, -1, 0, speed, this.colour));
       
     } else if(direction[0] == -1 && direction[1] == -1) {
       fallingDots.add(new Dot(x, y, 1, 1, speed, this.colour));
     } else if(direction[0] == -1 && direction[1] == 0) {
       fallingDots.add(new Dot(x, y, 1, 0, speed, this.colour));
     } else if(direction[0] == 0 && direction[1] == -1) {
       fallingDots.add(new Dot(x, y, 0, 1, speed, this.colour));
     }
     
     return true;
   }
   else{
     return false;
   }
 }
  
}

void createDot(){
  int offset = 0;
  ArrayList<Integer> rgb = new ArrayList<Integer>() {
    {
    add(0);
    add(0);
    add(0);
    }
  };
    
  for(int x = 0; x < width; x++){
    for(int y = 0; y < height; y++){
      
      
      if((y + offset) % 50 == 0){
        rgb.set(0, 0);
        rgb.set(1, (int)random(0, 200));
        rgb.set(2, (int)random(255));
        println(rgb);
        
        fallingDots.add(new Dot(x, y, -1, 0, (int)random(1,topSpeed), rgb));
        fallingDots.add(new Dot(y, x, 0, -1, (int)random(1,topSpeed), rgb));
        fallingDots.add(new Dot(x, y, 1, 0, (int)random(1,topSpeed), rgb));
        fallingDots.add(new Dot(y, x, 0, 1, (int)random(1,topSpeed), rgb));
      }
    }
    
    offset++;
  }
}

void deleteDots(){
   for(int i = fallingDots.size() - 1; i > 0; i--){
     Dot obj = fallingDots.get(i);
     if(obj.delete()){
       fallingDots.remove(obj);
     }
  }
}

void updateDotList(){
  
  for(int i = 0; i < fallingDots.size(); i++){
    Dot obj = fallingDots.get(i);
    obj.move();
    obj.update();
  }
  deleteDots();
  
}


void setup(){
  size(100, 100);
  
  fallingDots = new ArrayList<Dot>();
  noSmooth();
  positionOfDot = 1;
  createDot();
  topSpeed = 10;
}

void draw(){
  background(255);
  
  
  updateDotList();

}
