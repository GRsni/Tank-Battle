class HealthBar {//needs an X value, Y value and a Health value, and scale
  float x, y, i, maxSize, scl;

  HealthBar(float X, float Y, float I, float S) {
    i=I;
    x=X;
    y=Y;
    maxSize=i;
    scl=S;
  }

  void display() {
    fill(255);
    stroke(200);
    strokeWeight(1);
    rectMode(CORNER);
    rect(x, y, maxSize*scl, 20*scl, 1);
    noStroke();
    if (i<maxSize/5) {
      fill(255, 0, 0);//red
    } else if (i>=maxSize/5&&i<maxSize/2) {
      fill(230, 230, 0);//yellow
    } else if (i>=maxSize/2) {
      fill(0, 255, 0);//green
    }
    rect(x, y, i*scl, 20*scl, 1);
  } 

  void update(float X, float Y) {
    x=X;
    y=Y;
  }

  void reduce(float I) {
    if (i>0) {
      i-=I;
      //i--;
    }
  }

  void reset() {
    i=maxSize;
  }
}
