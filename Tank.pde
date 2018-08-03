class Tank {
  PVector pos;
  PVector vel= new PVector(0, 0);
  PVector acc=new PVector(0, 0);
  boolean moveUp, moveDown, moveLeft, moveRight;
  boolean enemy;
  int shotCount, lastShotTime, cannonUpgrade, healthUpgrade, magazineUpgrade;
  float speedUpgrade;
  boolean inCD, moving;
  float speed=3.5, speedX, speedY, tankSize=20, rotationAngle=PI/2;
  HealthBar healthB;
  int type=floor(random(1, 4));

  Tank( float pX, float pY, boolean e) {
    pos= new PVector(pX, pY);
    enemy=e;
    //cannonUpgrade=1000;
    //speedUpgrade=.5;
    //healthUpgrade=10000;
    //magazineUpgrade=100;
    healthB= new HealthBar(pos.x, pos.y, 100+healthUpgrade, .3);
  }

  Tank(boolean e, Tank t) {
    enemy=e;
    pos=choosePos(t);
    healthB=new HealthBar(pos.x, pos.y, 100, .3);
  }

  void show() {
    pushStyle();
    if (enemy) {
      if (type==1) {
        stroke(255, 0, 0);
      } else if (type==2) {
        stroke(255, 255, 0);
      } else if (type==3) {
        stroke( #FFA703);
      }

      rectMode(CENTER);
      noFill();
      strokeWeight(4);
      rect(pos.x, pos.y, tankSize, tankSize);
      ellipse(pos.x, pos.y, 8, 8);
      //follow(player);

      PVector dir=follow(player);

      pushMatrix();
      translate(pos.x, pos.y);
      rotate(dir.heading());
      line(0, 0, 20, 0);
      popMatrix();
    } else {
      stroke(0, 0, 255);

      rectMode(CENTER);
      noFill();
      strokeWeight(4);
      rect(pos.x, pos.y, tankSize, tankSize);
      ellipse(pos.x, pos.y, 8, 8);
      PVector dir= new PVector(mouseX-pos.x, mouseY-pos.y);
      pushMatrix();
      translate(pos.x, pos.y);

      //println(dir);

      rotate(dir.heading());
      line(0, 0, 20, 0);
      popMatrix();
    }
    //drawTracks();
    popStyle();
  }

  void update() {
    manageCD();
    if (!enemy) {
      if (!moveUp&&!moveDown&&!moveLeft&&!moveRight) {
        moving=false;
      } else { 
        moving=true;
      }
      if (moveUp) {
        pos.y-=speed+speedUpgrade;
      }
      if (moveDown) {
        pos.y+=speed+speedUpgrade;
      }
      if (moveLeft) {
        pos.x-=speed+speedUpgrade;
      }
      if (moveRight) {
        pos.x+=speed+speedUpgrade;
      }
    } else {
      if (speedX==0&&speedY==0) {
        moving=false;
      } else {
        moving=true;
      }
      pos.x+=speedX; 
      pos.y+=speedY;
    }
    pos.x=constrain(pos.x, borderWidth+tankSize/2, width-borderWidth-tankSize/2);
    pos.y=constrain(pos.y, borderHeight+tankSize/2, height-borderHeight-tankSize/2);

    float yOffset=-30;
    if (pos.y<borderHeight+50) yOffset=30;
    healthB.update(pos.x-15, pos.y+yOffset);
  }


  void manageCD() {
    if (!inCD) {
      if (millis()-lastShotTime>1000) {
        if (shotCount>0) shotCount--;
      }
      if (shotCount>9+magazineUpgrade) {
        inCD=true;
        blinkA=PI/4;
      }
    } else {
      if (millis()-lastShotTime>5000) {
        shotCount=0;
        inCD=false;
      }
    }
  }


  PVector choosePos(Tank other) {
    return new PVector(width-other.pos.x, other.pos.y);
  }


  PVector follow(Tank other) {
    PVector aux=new PVector(other.pos.x-pos.x, other.pos.y-pos.y);
    return aux;
  }

  void moveVertical(float stp) {
    speedY=stp;
  }

  void moveHorizontal(float stp) {
    speedX=stp;
  }

  boolean collision(Tank other) {
    return (pos.x+tankSize/2>other.pos.x-other.tankSize/2&&
      pos.x-tankSize/2<other.pos.x-other.tankSize/2&&
      pos.y+tankSize/2>other.pos.y-other.tankSize/2&&
      pos.y-tankSize/2<other.pos.y+other.tankSize/2
      );
  }

  boolean take(Pack h) {
    return dist(pos.x, pos.y, h.pos.x, h.pos.y)<15;
  }

  void heal(int num) {
    if (healthB.i<healthB.maxSize-num) {
      healthB.reduce(-num);
    } else healthB.i=healthB.maxSize;
  }

  void reset(Tank other) {
    healthB.reset();
    type=floor(random(1, 4));
    pos=choosePos(other);
    healthB.update(pos.x, pos.y);
    speedX=0;
    speedY=0;
  }
}
