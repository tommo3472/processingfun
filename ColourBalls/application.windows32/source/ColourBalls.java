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

public class ColourBalls extends PApplet {






class Circle {

  PVector location;
  PVector velocity;

  Circle(int x, int y, int sx, int sy) {
    location = new PVector(x, y);
    velocity = new PVector(sx, sy);
  }

  public void draw() {

    ellipse(location.x, location.y, 16, 16);
    update();
  }

  public void update() {

    location.add(velocity);

    if (location.x >= width || location.x <= 0) {
      velocity.x = velocity.x * -1;
    } else if (location.y >= height || location.y <= 0) {
      velocity.y = velocity.y * -1;
    }
  }
}

public void mouseClicked(){
  fill(PApplet.parseInt(random(255)), PApplet.parseInt(random(150)), PApplet.parseInt(random(100, 255)));
}


Circle[] c = new Circle[0];
int sx = 3;
int sy = 3;
int count = 0;

public void setup() {
  

  background(255);
  populateCircles();
}




public void draw() {
  updateArray();
}

public void populateCircles() {
  Circle temp;
  for (int i = 0; i < width; i+=30) {
    for (int y = 0; y < height; y+=30) {
      temp = new Circle(i, y, sx, sy);
      c = (Circle[])append(c, temp);
    }
  }
}


public void updateArray() {

  for (int i = 0; i < c.length; i++) {

    c[i].draw();
  }
}
  public void settings() {  size(500, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "ColourBalls" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
