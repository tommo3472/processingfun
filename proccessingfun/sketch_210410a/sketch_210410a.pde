Classic a, b, c, d;


class Classic{
   float w, h; 
   int x, y;
   float[] point_interval = new float[2];
   int[] pos = new int[2];
 
   Classic(float _w, float _h, int _x, int _y) {  
     w = _w;
     h = _h;
     pos[0] = _x;
     pos[1] = _y;
     point_interval[0] = w / 3;
     point_interval[1] = h / 3;
   
   }
 
   void update(){
     fill(0, 150, 255);
     square(float(pos[0]), float(pos[1]), w);
     line(point_interval[0] + pos[0], point_interval[1] + pos[1],
         w + pos[0], point_interval[1] + pos[1]);
     line(point_interval[0] + pos[0], point_interval[1] + pos[1],
         point_interval[0] + pos[0], h + pos[1]);
     
     line((point_interval[0] * 2) + pos[0], (point_interval[1] * 2) + pos[1],
          pos[0] + 0, (point_interval[1] * 2) + pos[1] );
     line((point_interval[0] * 2) + pos[0] , (point_interval[1] * 2) + pos[1] ,
         (point_interval[0] * 2) + pos[0] , 0 + pos[1]);
   }
}

void setup() {
  size(200, 200);
  a = new Classic(50, 50, 0, 0);
  b = new Classic(50, 50, 50, 0);
  c = new Classic(50, 50, 0, 50);
  d = new Classic(50, 50, 50, 50);
  
}


void draw() {
  a.update();
  b.update();
  c.update();
  d.update();
}
