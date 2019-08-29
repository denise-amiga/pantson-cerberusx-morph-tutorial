// ##################################################################
// Morph 105
// All work by Rich Hanson
// use at own risk
// tutorial:
// https://devdevandmoredev.blogspot.com/2019/08/morph-105-optimisation.html
// ##################################################################

PImage img1;
PImage img2;

point[] p1;
point[] p2; 

int w;
int h;

float counter;
float polygons;

void setup() {
  size(640, 480, P2D);
  
  w = 9;
  h = 11;
  
  img1 = loadImage("image1.png");
  img2 = loadImage("image2.png");
  
  // points of captain america
  p1 = loadMesh("image1.txt");
  // points of black widow
  p2 = loadMesh("image2.txt");
  
  polygons = 0;
}
  
void draw() {
  float t = sin(counter)/2.0  + 0.5;
  if (keyPressed) {
    if (key == ' ') {
        counter=counter+0.05;
    }
    if ((key == 'p') | (key =='P')) {
      polygons = 1 - polygons;
    }
  }
  int i,j;
      
  j=0;
  while (j < h-1) {
    i=0;
    while (i < w-1) {
      
      // this is for readability and copied from Morph 104
      float sx1 = p1[i + j*w].x;
      float sy1 = p1[i + j*w].y;
      float sx2 = p1[i + j*w +1].x;
      float sy2 = p1[i + j*w +1].y;
      float sx3 = p1[i + (j+1)*w].x;
      float sy3 = p1[i + (j+1)*w].y;
      float sx4 = p1[i + (j+1)*w +1].x;
      float sy4 = p1[i + (j+1)*w +1].y;
      
      float dx1 = p2[i + j*w].x;
      float dy1 = p2[i + j*w].y;
      float dx2 = p2[i + j*w +1].x;
      float dy2 = p2[i + j*w +1].y;
      float dx3 = p2[i + (j+1)*w].x;
      float dy3 = p2[i + (j+1)*w].y;
      float dx4 = p2[i + (j+1)*w +1].x;
      float dy4 = p2[i + (j+1)*w +1].y;
      
      // linear interpolation of the 4 vertices of the polygon
      float x1 = LI(sx1,dx1,t);
      float y1 = LI(sy1,dy1,t);
      float x2 = LI(sx2,dx2,t);
      float y2 = LI(sy2,dy2,t);
      float x3 = LI(sx3,dx3,t);
      float y3 = LI(sy3,dy3,t); 
      float x4 = LI(sx4,dx4,t);
      float y4 = LI(sy4,dy4,t); 

      // draw cap'
      tint(255);
      beginShape();
      texture(img1);
      vertex(x1, y1, sx1, sy1);
      vertex(x2, y2, sx2, sy2);
      vertex(x4, y4, sx4, sy4);
      vertex(x3, y3, sx3, sy3);
      endShape();
      
      // draw natalie
      tint(255,t*255.0);
      beginShape();
      texture(img2);
      vertex(x1, y1, dx1, dy1);
      vertex(x2, y2, dx2, dy2);
      vertex(x4, y4, dx4, dy4);
      vertex(x3, y3, dx3, dy3);
      endShape();

      if (polygons==1) {
        // draw polygions
        color c=color(0,0,0);
        fill(c);
        line(x1,y1,x2,y2);
        line(x1,y1,x3,y3);
      }
      i=i+1;
    }
    j=j+1;
  }
}

float LI(float v1,float v2,float t) {
  return v1 + (v2-v1)*t;
}

point[] loadMesh(String file) {
      
  String[] lines=loadStrings(file);
  point[] p = new point[lines.length/2];
      
  int i=0;
  while (i<lines.length) {
    if (lines[i].trim()!="") {
      p[int(i/2)] = new point();
      p[int(i/2)].x = float(lines[i].trim());
      p[int(i/2)].y = float(lines[i+1].trim());
    }
    i=i+2;
  }
  
  return p;
}

class point {
  point(){
  }
  
  float x;
  float y;
}
