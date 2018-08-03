//gameStates
//pause text
//buttons

Tank player;
Tank enemy;
ArrayList<Pack> packs= new ArrayList<Pack>();
ArrayList<Bullet> shots= new ArrayList<Bullet>();

int score=0, money=10000, pauseTime, roundTime, packSpawnDelay;
float borderWidth=50, borderHeight=50;
int gameState=0;//0 start screen, 1 game, 2 game over screen, 3 shop screen, 4 settings?
float blinkA;
boolean clicked, paused;
PGraphics floor;
Button start, shop, cannon, speed, magazine, health, back;


void setup() {
  size(800, 600);
  background(255);
  initializeFloor();
  //player= new Tank(width/2+random(-100, 100), height/2+random(-100, 100), false);
  //enemy= new Tank(true, player);
  resetGame();
  loadButtons();
}

void draw() {
  //println(clicked);
  blinkA+=0.1;
  if (gameState==0) {

    background(200);
    pushStyle();
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text("TANK BATTLE", width/2, height/2-150);

    start.show();
    shop.show();
    if (start.click(mouseX, mouseY, true)) {
      roundTime=millis();
      gameState=1;
    }
    if (shop.click(mouseX, mouseY, true)) {
      gameState=3;
    }
    popStyle();
  } else if (gameState==1) {//main game====================================================================================================
    //while (packs.size()<1000) {
      spawnHPacks();
    //}
    //background(255);
    image(floor, 0, 0);
    stroke(50);
    strokeWeight(3);
    noFill();
    rectMode(CORNER);
    rect(borderWidth, borderHeight, width-borderWidth*2, height-borderHeight*2);
    fill(0);
    textSize(20);
    //textAlign(CENTER);

    text("Tanks destroyed: "+score, 400, 30);
    text("Money: "+money, 600, 30); 
    textSize(10);
    text("roundTime: "+(millis()-roundTime)/1000, 10, height-20);
    text("spawn pack delay "+packSpawnDelay, 10, height-40);
    text("player health "+player.healthB.i, 10, height-60);
    text("enemy health "+enemy.healthB.i, 10, height-80);
    player.update();
    enemy.update();


    if (player.collision(enemy)) {
      println("collision");
      enemy.healthB.reduce(2);
      player.healthB.reduce(2);
      if (enemy.healthB.i<1) {//increment score by 1, reset player pos, reset enemy tank, start pause time
        killEnemy();
      }
    }


    player.show();
    drawTracks(player);
    enemy.show();
    drawTracks(enemy);
    enemy.healthB.display();
    player.healthB.display();
    displayCDBar(player);
    for (int i=packs.size()-1; i>=0; i--) {
      Pack p=packs.get(i);
      p.show();
      if (player.take(p)) {
        player.heal(p.health);
        packs.remove(i);
      }
      if (enemy.take(p)) {

        enemy.heal(p.health);
        packs.remove(i);
      }
    }


    for (int i=shots.size()-1; i>=0; i--) {
      if (!shots.isEmpty()) {
        Bullet b=shots.get(i);
        b.show();
        b.update();
        if (b.edges()) {
          shots.remove(i);
        }
        if (b.inside(enemy)&&!b.bad) {

          shots.remove(i);
          enemy.healthB.reduce(10+player.cannonUpgrade);
          if (enemy.healthB.i<1) {//kill the enemy tank
            killEnemy();
            //enemy.choosePos(player);
          }
        }

        if (b.inside(player)&&b.bad) {
          shots.remove(i);
          player.healthB.reduce(10+enemy.cannonUpgrade);
        }
      }
    }
    if (!paused) {
      AI(enemy, player);
      checkEndGame();
    } else {
      if (millis()-pauseTime>5000) {
        paused=false;
        roundTime=millis();
      }
      pauseClock(true);
    }
  } else if (gameState==2) {//shop tab======================================================================================================
    fill(50, 0, 0);
    background(50, 0, 0);  
    //rect(0, 0, width, height);
    fill(255);
    text("You lose", width/2, height/2);
  } else if (gameState==3) {//upgardes shop=============================================================================================
    background(180);
    fill(0);
    text("Upgrades shop", width/2, 50);
    text("Money: "+money, 600, 500);

    cannon.show();
    textSize(15);
    text("Current damage: "+(10+player.cannonUpgrade), 160, 155);
    text("Cost: "+(5+floor(pow(player.cannonUpgrade, 1.5))), 160, 195);
    if (cannon.click(mouseX, mouseY, true)) {
      if (money>=5+floor(pow(player.cannonUpgrade, 1.5))) {
        money-=5+floor(pow(player.cannonUpgrade, 1.5));
        player.cannonUpgrade++;
        clicked=true;
      }
    }
    speed.show();
    magazine.show();
    health.show();
    back.show();
    if (back.click(mouseX, mouseY, true)) {
      gameState=0;
    }
  }
}


void keyPressed() {
  if (!paused) {
    if (key==' ') {
    }
    if (key=='a'||key=='A') {//left
      player.moveLeft=true;
    }
    if (key=='w'||key=='W') {//up
      player.moveUp=true;
    }
    if (key=='d'||key=='D') {//right
      player.moveRight=true;
    }
    if (key=='s'||key=='S') {//down
      player.moveDown=true;
    }
  }

  if (gameState==2&&key==' ') {
    gameState=1;
    resetGame();
  } 
  if (gameState==1) {
    if (!paused) {
      if (key==ESC) {
        key=0;
        gameState=5; 
        pauseClock(false);
        //paused=true;
      }
    }
  }
  if (gameState==5) {
    if (key==ESC) {
      key=0;
      gameState=1;
      //paused=false;
    }
  }
}


void keyReleased() {
  if (key=='a'||key=='A') {//left
    player.moveLeft=false;
  }
  if (key=='w'||key=='W') {//up
    player.moveUp=false;
  }
  if (key=='d'||key=='D') {//right
    player.moveRight=false;
  }
  if (key=='s'||key=='S') {//down
    player.moveDown=false;
  }
}


void mousePressed() {
  clicked=true;
  if (gameState==1&&!paused) {
    if (!player.inCD) {
      shots.add(new Bullet(player.pos.x, player.pos.y, mouseX-player.pos.x, mouseY-player.pos.y, false));
      player.shotCount++;
      player.lastShotTime=millis();
    }
  }
}

void mouseReleased() {
  if (clicked) {
    clicked=false;
  }
}


void displayCDBar(Tank t) {
  pushStyle();
  colorMode(RGB);
  noFill();
  stroke(200);
  rect(50, 20, 300, 25, 2);
  if (!t.inCD) fill(t.shotCount<5+player.magazineUpgrade/2?#00FF00:#FFFF00);
  else {
    pushStyle();
    fill(#AA0000, map(sin(blinkA), -1, 1, 0, 255));
    textSize(20);
    textAlign(LEFT, CENTER);
    text("OVERHEATED", 360, 30);
    popStyle();
    fill(#FF0000);
  }
  noStroke();
  rect(51, 21, map(t.shotCount, 0, 10+player.magazineUpgrade, 0, 299), 24, 2); 
  //fill(col);
  popStyle();
}

void drawTracks(Tank t) {
  PVector movingDir=new PVector(0, 0);
  floor.beginDraw();
  floor.pushStyle();
  floor.pushMatrix();
  floor.noStroke();
  floor.fill(50, 50);
  if (t.moving) {
    if (frameCount%6==0) {
      if (t.enemy) {
        movingDir=new PVector(t.speedX, t.speedY);
      } else {
        float speedX=0;
        float speedY=0;
        //println(t.moveUp, t.moveRight, t.moveDown, t.moveLeft);        
        if (t.moveRight) {
          speedX=t.speed+t.speedUpgrade;
        } else if (t.moveLeft) {
          speedX=-(t.speed+t.speedUpgrade);
        }
        if (t.moveDown) {
          speedY=t.speed+t.speedUpgrade;
        } else if (t.moveUp) {
          speedY=-(t.speed+t.speedUpgrade);
        }
        movingDir=new PVector(speedX, speedY);
        //println(movingDir);
      }
      //println(movingDir);
      floor.translate(t.pos.x, t.pos.y);
      floor.rotate(movingDir.heading());
      floor.rect(-1, -10, 3, 4);
      floor.rect(-1, 5, 3, 4);
    }
  } 

  floor.popStyle();
  floor.popMatrix();
  floor.endDraw();
}
