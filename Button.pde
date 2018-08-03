class Button {//Asks whether changes color, for an X, Y, xlength, y length, corner radius, strokeWeight, inside fill, stroke color, text inside, text color 
  float x;
  float y;
  float Xl;
  float Yl;
  float corners;
  int rimWidth;
  color in;
  color out;
  color inside;
  color border;
  String content;
  color letterC;
  int fontSize=25;
  boolean change;

  Button(boolean Ch, float x_, float y_, float Xlength, float Ylength, float c, int stroke, color inside, color rim) {
    x=x_;
    y=y_;
    Xl=Xlength;
    Yl=Ylength;
    corners=c;
    rimWidth=stroke;
    change=Ch;

    in=inside;
    out=rim;
    content="";
    letterC=0;
  }
  Button(boolean Ch, float x_, float y_, float Xlength, float Ylength, float c, int stroke, color inside, color rim, String words, color l) {
    x=x_;
    y=y_;
    Xl=Xlength;
    Yl=Ylength;
    corners=c;
    change=Ch;
    rimWidth=stroke;
    in=inside;
    out=rim;
    content=words;
    letterC=l;
  }


  void show() {
    pushStyle();
    textSize(30);
    stroke(out);
    if (rimWidth==0) {
      noStroke();
    } else {
      strokeWeight(rimWidth);
    }

    fill(in);
    if (change) {
      //pushStyle();
      colorMode(HSB);
      if (mouseX>x&&mouseX<x+Xl&&mouseY>y&&mouseY<y+Yl) {
        color c=in+100;
        fill(c);
      }
      //popStyle();
    }
    rect(x, y, Xl, Yl, corners);
    colorMode(RGB);
    if (content.length()>0) {
      fill(letterC);
      if(content.length()*25>Xl){
       fontSize=(int)(Xl/content.length());
      }
      textAlign(CENTER, CENTER);
      textSize(fontSize);
      text(content, x, y, Xl, Yl);
    }

    popStyle();
  }

  boolean click(float X_, float Y_, boolean c) {
    if (!c) {
      if (X_>x&&X_<(x+Xl)) {
        if (Y_>y&&Y_<(y+Yl)) {
          return true;
        }
      } 
      return false;
    } else {
      if (X_>x&&X_<(x+Xl)) {
        if (Y_>y&&Y_<(y+Yl)) {
          if (mousePressed) {

            return true;
          }
        }
      } 
      return false;
    }
  }
}
