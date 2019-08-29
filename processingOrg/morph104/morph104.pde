// ##################################################################
// Morph 104
// All work by Rich Hanson
// use at own risk
// tutorial:
// https://devdevandmoredev.blogspot.com/2019/08/morph-104-drawing-polygons.html
// ##################################################################

PImage img1;
PImage img2;
PImage dstimg;

point[] p1;
point[] p2; 

int w;
int h;

float counter;
float polygons;

void setup() {
  size(640, 480);
  
  w = 9;
  h = 11;
  
  img1 = loadImage("https://github.com/pantson/pantson-cerberusx-morph-tutorial/raw/master/105.data/image1.png");
  img2 = loadImage("https://github.com/pantson/pantson-cerberusx-morph-tutorial/raw/master/105.data/image2.png");
  dstimg = createImage(640,480,RGB);
  
  // points of captain america
  p1 = loadMesh("https://raw.githubusercontent.com/pantson/pantson-cerberusx-morph-tutorial/master/105.data/image1.txt");
  // points of black widow
  p2 = loadMesh("https://raw.githubusercontent.com/pantson/pantson-cerberusx-morph-tutorial/master/105.data/image2.txt");
  
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
      
      int xstep = int(max(max(abs(sx2-sx1),abs(sx4-sx3)),max(abs(dx2-dx1),abs(dx4-dx3))));
      int ystep = int(max(max(abs(sy3-sy1),abs(sy4-sy2)),max(abs(dy3-dy1),abs(dy4-dy2))));
        
      int x = 0;
      while (x<xstep+1) {
        float slx1 = LI(sx1,sx2,x/float(xstep));
        float sly1 = LI(sy1,sy2,x/float(xstep));
        float slx2 = LI(sx3,sx4,x/float(xstep));
        float sly2 = LI(sy3,sy4,x/float(xstep));

        float dlx1 = LI(dx1,dx2,x/float(xstep));
        float dly1 = LI(dy1,dy2,x/float(xstep));
        float dlx2 = LI(dx3,dx4,x/float(xstep));
        float dly2 = LI(dy3,dy4,x/float(xstep));

        float plx1 = LI(x1,x2,x/float(xstep));
        float ply1 = LI(y1,y2,x/float(xstep));
        float plx2 = LI(x3,x4,x/float(xstep));
        float ply2 = LI(y3,y4,x/float(xstep));
        
        int y = 0;
        while (y<ystep+1) {
          float sx = LI(slx1,slx2,y/float(ystep));
          float sy = LI(sly1,sly2,y/float(ystep));
          color src_col = img1.get(int(sx),int(sy));
          
          float dx = LI(dlx1,dlx2,y/float(ystep));
          float dy = LI(dly1,dly2,y/float(ystep));
          color dst_col = img2.get(int(dx),int(dy));

          float px = LI(plx1,plx2,y/float(ystep));
          float py = LI(ply1,ply2,y/float(ystep));
          
          dstimg.set(int(px),int(py),lerpColor(src_col, dst_col, t));
          y=y+1;
        }

        x=x+1;
      }

      if (polygons==1) {
        // draw polygions
        color c=color(0,0,0);
        drawline(dstimg,x1,y1,x2,y2,c);
        drawline(dstimg,x1,y1,x3,y3,c);
      }
      i=i+1;
    }
    j=j+1;
  }
  
  image(dstimg,0,0);
}

float LI(float v1,float v2,float t) {
  return v1 + (v2-v1)*t;
}

void drawline(PImage img, float x1,float y1,float x2,float y2, color c) {
  int m=int(max(abs(x2-x1),abs(y2-y1)));
  
  int i=0;
  while (i<m+1) {
    float t = i/float(m);
    img.set(int(LI(x1,x2,t)),int(LI(y1,y2,t)),c);
    i=i+1;
  }
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
