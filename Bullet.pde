class Bullet {
  PVector pos;
  PVector dir;
  float l=10;
  boolean bad;

  Bullet(float x, float y, float dirX, float dirY, boolean t) {
    pos=new PVector(x, y);
    dir=new PVector(dirX, dirY);
    bad=t;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    if (bad) {
      stroke(255, 0, 0);
    } else {
      stroke(120, 30, 200);
    }
    strokeWeight(5);
    line(0, 0, l, 0);
    popMatrix();
  }

  void update() {
    PVector aux=dir.setMag(5);
    pos.add(aux);
    //println(pos.x, pos.y);
  }

  boolean edges() {
    if (pos.x<0||pos.x>width||pos.y<0||pos.y>height) {
      return true;
    } else {
      return false;
    }
  }

  boolean inside(Tank other) {
    if (dist(pos.x, pos.y, other.pos.x, other.pos.y)<15) {
      return true;
    } else {
      return false;
    }
  }
}
