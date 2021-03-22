int positionOfDot;
ArrayList<Dot> fallingDots;

class Dot{
  int x, y, speed;
  int[] direction = new int[2];
  int[] colour = new int[3];
  
 Dot(int _x, int _y, int _directionX, int _directionY, int _speed, int[] rgb){
   x = _x;
   y = _y;
   direction[0] = _directionX;
   direction[1] = _directionY;
   speed = _speed;
   colour = rgb;
 }
 
 void update(){
  stroke(colour[0], colour[1], colour[2]);
  println(colour);
  line(x, y, x+ (direction[0] * 5), y+ (direction[1] * 5)); 
 }
 
 void move(){
   
   x = x + (direction[0] * speed);
   y = y + (direction[1] * speed);
   
 }
 
 boolean delete(){
   
   if(x > width || x < 0 || y > height || y < 0){
     
     if(direction[0] == 1 && direction[1] == 1){
       fallingDots.add(new Dot(x, y, -1, -1, speed, colour));
       
     } else if(direction[0] == 0 && direction[1] == 1) {
       fallingDots.add(new Dot(x, y, 0, -1, speed, colour));
       
     } else if(direction[0] == -1 && direction[1] == 1) {
       fallingDots.add(new Dot(x, y, 1, -1, speed, colour));
       
     } else if(direction[0] == 1 && direction[1] == -1) {
       fallingDots.add(new Dot(x, y, -1, 1, speed, colour));
       
     } else if(direction[0] == 1 && direction[1] == 0) {
       fallingDots.add(new Dot(x, y, -1, 0, speed, colour));
       
     } else if(direction[0] == -1 && direction[1] == -1) {
       fallingDots.add(new Dot(x, y, 1, 1, speed, colour));
     } else if(direction[0] == -1 && direction[1] == 0) {
       fallingDots.add(new Dot(x, y, 1, 0, speed, colour));
     } else if(direction[0] == 0 && direction[1] == -1) {
       fallingDots.add(new Dot(x, y, 0, 1, speed, colour));
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
  int[] rgb = new int[3];
  for(int x = 0; x < width; x++){
    for(int y = 0; y < height; y++){
      
      if((y + offset) % 75 == 0){
        rgb[0] = 0;
        rgb[1] = (int)random(0, 200);
        rgb[2] = (int)random(255);
        println(rgb);
        
        fallingDots.add(new Dot(x, y, -1, 0, 3, rgb));
        fallingDots.add(new Dot(y, x, 0, -1, 3, rgb));
        fallingDots.add(new Dot(x, y, 1, 0, 3, rgb));
        fallingDots.add(new Dot(y, x, 0, 1, 3, rgb));
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
  size(800, 800);
  
  fallingDots = new ArrayList<Dot>();
  noSmooth();
  positionOfDot = 1;
  createDot();
}

void draw(){
  background(255);
  
  
  updateDotList();

}
