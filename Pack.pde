class Pack {
  PVector pos;
  int health=(int)random(10, 20);

  Pack(float X, float Y) {
    pos= new PVector(X, Y);
  }


  void show() {
    noStroke();
    fill(0, 255, 0);
    rectMode(CENTER);
    rect(pos.x, pos.y, map(health, 10, 20, 10, 15), map(health, 10, 20, 10, 15));
  }
}
