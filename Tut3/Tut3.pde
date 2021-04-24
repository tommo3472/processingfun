int car1Position = 550;
int car2Position = 550;
int car3Position = 550;
int car4Position = 550;
boolean finished = false;
boolean start = false;
boolean lights = false;
String result;
int countDown = 0;
void setup(){
   size(300, 600); 
   smooth();
}

void race(){
  if(finished == false){
    car1Position = car1Position - int(random(1.0,3.0));
    car2Position = car2Position - int(random(1.0,3.0));
    car3Position = car1Position - int(random(1.0,3.0));
    car4Position = car2Position - int(random(1.0,3.0));
    if (car1Position <= 20 ){
       finished = true;
       result = "Car 1 has won!";
    }else if (car2Position <= 20){
       result = "Car 2 has won!";
       finished = true; 
    }else if (car3Position <= 20){
       result = "Car 3 has won!";
       finished = true; 
    }else if (car4Position <= 20){
       result = "Car 4 has won!";
       finished = true; 
    }
  }else{
     fill(255,0,0);
     text(result,5,15); 
  }
}

boolean mouseInBox(){
  if(mouseX < width/2 + 50 && mouseX > width/2 -50 &&
     mouseY < height/2 + 50 && mouseY > height/2 - 50){
       return true;
    }
    return false;
}

void mouseClicked(){
  if(mouseInBox()){
    start = true;
  }
}
void lightsOut(){
  
  if(countDown < 30){
    fill(255, 0, 0);
    rect(250, 250, 50, 50);
  } else if (countDown < 60){
    fill(255, 0, 0);
    rect(250, 250, 50, 50);
    fill(255, 255, 0);
    rect(250, 300, 50, 50);
  } else if (countDown < 90){
    fill(255, 0, 0);
    rect(250, 250, 50, 50);
    fill(255, 255, 0);
    rect(250, 300, 50, 50);
    fill(0, 255, 0);
    rect(250, 350, 50, 50);
  } else if(countDown < 120){
     lights = true; 
  }
  
  countDown++;
}

void drawBox(){
  rectMode(CENTER);
  fill(100);
  if(mouseInBox()){
    fill(0);
  }
  rect(width/2, height/2, 100, 100);
  fill(255);
  
  text("Start Race", width/2 - 25, height/2);
  
  
}


void draw(){
  background(255);
  
  rectMode(CORNER);
    drawRoad();
    drawCar(120,car2Position);
    drawCar(165,car3Position);
    drawCar(210,car4Position);
    drawCar(74, car1Position);
    
   if(start == true){
     lightsOut(); 
   }
  
  if(lights == false){
    drawBox();
  }
  
  
  
  if(lights == true){
    
    race();
  }
  
}

void drawRoad(){
  fill(50);
  noStroke();
  rect(50, 0, 200,600);
  stroke(255);
  strokeWeight(4);
  line(152,0,152,600);
  line(102, 0, 102, 600);
  line(202, 0, 202, 600);
}
void drawCar(int x, int y){
  stroke(0);
  strokeWeight(1);
  fill(0);
  rect(x-5, y+5, 30, 10);
  rect(x-5, y+25, 30, 10);
  fill(255,0,0);
  rect(x, y, 20, 40);
  fill(0,0,255);
  ellipse(x+10, y+30,10,5);
  ellipse(x+10, y+15,10,15);  
}
