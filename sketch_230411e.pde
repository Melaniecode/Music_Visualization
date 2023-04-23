import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import ddf.minim.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*; 

Minim minim;
AudioPlayer music;
float voice;

int nbCircles =50;  
Circle[] circles;
MyColor myColor;
float rMax,dMin;

void setup()
{
  size(1280,750,P2D);
  frameRate(30);
  fill(0,60);
  rMax = min(width, height)/3;
  dMin = max(width, height)/3;
  
  circles = new Circle[nbCircles];
  
  for (int i = 0; i < nbCircles; i++)
  {
    circles[i] = new Circle(random(rMax), 0, 0); 
  }
  myColor = new MyColor();
  
  //music
  minim = new Minim(this);
  music = minim.loadFile("sweet dreams.mp3", 2048);
  music.loop(); 
}

void draw()
{
  noStroke();
  rect(0, 0, width, height);
  translate(width/2, height/2);
  myColor.update(); //change colors
  

  for(int j = 0; j<nbCircles; j++)
  {
     circles[j].update();      //change location
     for(int i=j+1; i<nbCircles; i++)
     {
       connect(circles[j], circles[i]);
     }
  }
}

void connect(Circle c1, Circle c2)
{
  float d, x1, y1, x2, y2, r1 = c1.radius, r2 = c2.radius;
  float rCoeff = map(min(abs(r1), abs(r2)), 0, rMax, 0.08, 1);
  int n1 = c1.nbLines, n2 = c2.nbLines;
  int step = music.bufferSize() / 1000;
  for(int i=0; i<n1-step; i+=step)
  {
     x1 = c1.x + r1 * cos(i * TWO_PI / n1 + c1.theta)*(music.mix.get(i)/70);
     y1 = c1.y + r1 * sin(i * TWO_PI / n1 + c1.theta)*(music.mix.get(i)*70);
     for(int j=0; j<n2-step; j+=step)
     {
       x2 = c2.x + r2 * cos(j * TWO_PI / n2 + c2.theta)*(music.mix.get(i)*70);
       y2 = c2.y + r2 * sin(j * TWO_PI / n2 + c2.theta)*(music.mix.get(i)/70);
        
       d = dist(x1, y1, x2, y2);
       if(d < dMin)
       {
           stroke(myColor.R + r2/1.5, myColor.G +r2/2.2, myColor.B + r2/1.5, map(d, 0, dMin, 140, 0)*rCoeff);
           line(x1, y1, x2, y2);        
       }
     }
  }
}


class Circle
{
  float x, y, radius, theta = 0;
  int nbLines = (int)random(3,25);
  float rotSpeed = (random(1) < 0.5 ? 1 : -1) * random(0.005, 0.034);
  float radSpeed = (random(1) < 0.5 ? 1 : -1) * random(0.3, 1.4);
  
  Circle(float p_radius, float p_x, float p_y)
  {
    radius =p_radius;
    x = p_x;
    y = p_y;
  }
  
  void update()
  {
    theta += rotSpeed;
    radius += radSpeed;
    radSpeed *= abs(radius) > rMax ? -1 : 1;
  }
}

class MyColor
{
  float R, G, B, Rspeed, Gspeed, Bspeed;
  float minSpeed = 0.2;
  float maxSpeed = 0.8;
  MyColor()
  {
    R = random(20, 255);
    G = random(20, 255);
    B = random(20, 255);
    Rspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Gspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
    Bspeed = (random(1) > .5 ? 1 : -1) * random(minSpeed, maxSpeed);
  }
  void update()
  {
    Rspeed = ((R += Rspeed) > 255 || (R < 20)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > 255 || (G < 20)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > 255 || (B < 20)) ? -Bspeed : Bspeed;
  }
}
