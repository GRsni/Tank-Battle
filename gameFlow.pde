void loadButtons() {
  start=new Button(true, width/2-150, height/2+50, 300, 75, 0, 0, #aaaaaa, #aaaaaa, "Start battle", #ffffff);
  shop=new Button(true, width/2-150, height/2+150, 300, 75, 0, 0, #aaaaaa, #aaaaaa, "Enter shop", #ffffff);
  cannon=new Button(true, 100, 150, 50, 50, 4, 3, #AABB00, #AABB00, "C", #000000);
  speed=new Button(true, 100, 400, 50, 50, 4, 3, #ffaa22, #ffaa22, "S", #000000);
  magazine=new Button(true, 400, 150, 50, 50, 4, 3, #123456, #123456, "M", #000000);
  health=new Button(true, 400, 400, 50, 50, 4, 3, #00DD00, #00DD00, "H", #000000);
  back=new Button(true, 50, 500, 25, 25, 0, 0, #000000, #000000);
}

void initializeFloor() {
  floor=createGraphics(width, height);
  floor.beginDraw();
  floor.background(255);
  floor.endDraw();
}

void checkEndGame() {
  if (player.healthB.i<1) {
    gameState=2;
  }
}

void clearField() {
  packs=new ArrayList<Pack>();
  shots=new ArrayList<Bullet>();
  floor.beginDraw();
  floor.clear();
  floor.background(255);
  floor.endDraw();
}

void resetGame() {
  player= new Tank(random(1)>.5?200:width-200, height/2, false);
  enemy= new Tank(true, player); 
  clearField();
  score=0;
}

void killEnemy() {
  money+=25+100-roundTime/1000;
  player.pos.x=(random(1)>1?200:width-200);
  player.pos.y=height/2;
  player.healthB.reset();
  enemy=new Tank(true, player);
  score++;
  paused=true;
  clearField();
  pauseTime=millis();
  player.moveDown=false;
  player.moveUp=false;
  player.moveLeft=false;
  player.moveRight=false;
}
void spawnHPacks() {
  if (/*packs.size()<2&&*/millis()-packSpawnDelay>2500) {
  packSpawnDelay=millis();
  PVector pos=packSpawnPos(player, enemy);
  packs.add(new Pack(pos.x, pos.y));
  }
}

PVector packSpawnPos(Tank p, Tank e) {
  PVector out=new PVector(random(borderWidth+30, width-borderWidth-30), random(borderHeight+30, height-borderHeight-30));
  boolean validPos=false;
  while (!validPos) {
    if (dist(p.pos.x, p.pos.y, out.x, out.y)>100&&dist(e.pos.x, e.pos.y, out.x, out.y)>100) {
      validPos=true;
    } else {
      out=new PVector(random(borderWidth+30, width-borderWidth-30), random(borderHeight+30, height-borderHeight-30));
    }
  }
  return out;
}

void pauseClock(boolean withTime) {

  pushStyle();
  if (withTime) {
    fill(255, 0, 0);
    textSize(40);
    textAlign(CENTER, CENTER);
    float remainingTime=5.5-(millis()-pauseTime)/1000.0;
    //println(remainingTime);
    if (remainingTime<1) {
      text("Fight", width/2, height/2-50);
    }
    if (remainingTime>1.00001) {
      text(int(remainingTime), width/2, height/2);
    } else {
      text(nf(remainingTime, 0, 1), width/2, height/2);
    }
  } else {
    noStroke();
    fill(100, 100);
    rectMode(CORNER);
    rect(0, 0, width, height);
    fill(255, 0, 0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("Paused", width/2, height/2);
  }
  popStyle();
}
