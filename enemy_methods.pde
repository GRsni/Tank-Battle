void AI(Tank p, Tank e) {
  PVector betweenTanks=new PVector(e.pos.x-p.pos.x, e.pos.y-p.pos.y);
  PVector nearestBullet=getNearestBullet(p.pos);
  PVector nearestPack=getNearestPack(p.pos);
  switch(p.type) {
  case 1://(red)super aggresive moves towards player indefinetily, doenst care about bullets, fires till overheat
    if (frameCount%(20)==0) {
      if (!p.inCD) {
        enemyShootBullet(1, p, e);
      }
    }

    if (frameCount%6==0) {
      PVector betweenTanksNormalized= betweenTanks.setMag(3).rotate(random(-PI/8, PI/8));
      p.speedX=betweenTanksNormalized.x;
      p.speedY=betweenTanksNormalized.y;
    }
    break;
  case 2://(yellow)balanced fire rate, stays at a distance, cares for bullets, if low on health goes for a health pack+
    if (p.shotCount<5) {
      if (frameCount%30==0) {
        enemyShootBullet(1, p, e);
      }
    }
    nearestBullet=getNearestBullet(p.pos);
    nearestPack=getNearestPack(p.pos);

    if (frameCount%15==0) {
      //println(degrees(betweenTanks.heading()));
      PVector finalMove=betweenTanks.setMag(2.5);
      if (frameCount%120==0) {
        enemy.rotationAngle*=-1;
      }
      finalMove.rotate(p.rotationAngle);
      if (nearestBullet.mag()<p.tankSize*2) {
        finalMove=nearestBullet.rotate(PI/2+(-1+ceil(random(1)*2))*PI).setMag(2.5);
      } else if (p.healthB.i<31&&nearestBullet.mag()>=p.tankSize*2) {
        finalMove=nearestPack.setMag(3);
      }
      p.speedX=finalMove.x;
      p.speedY=finalMove.y;
    }
    break;
  case 3://(orange)stays in the middle, fires in bursts of three bullets, always at near max health, doesnt avoid bullets very well
    if (frameCount%65==0) { 
      enemyShootBullet(3, p, e);
    }
    PVector toMiddle= new PVector(width/2+random(-50, 50)-p.pos.x, height/2+random(-50, 50)-p.pos.y);

    nearestBullet=getNearestBullet(p.pos);
    nearestPack=getNearestPack(p.pos);
    if (frameCount%15==0) {
      PVector finalMove=toMiddle.setMag(2.5);

      if (enemy.healthB.i<80&&packs.size()>0) {
        finalMove=nearestPack.setMag(2.5);
      }

      if (frameCount%45==0) {
        if (nearestBullet.mag()<p.tankSize*1.5) {
          finalMove=nearestBullet.rotate(PI/2+(-1+ceil(random(1)*2))*PI).setMag(2.5);
        }
      }
      p.speedX=finalMove.x;
      p.speedY=finalMove.y;
    }

    break;
  }
}

PVector getNearestBullet(PVector pos) {
  PVector out=new PVector(MAX_FLOAT, MAX_FLOAT);
  for (Bullet b : shots) {//get the closest bullet
    if (!b.bad) {
      if (dist(pos.x, pos.y, b.pos.x, b.pos.y)<out.mag()) {
        out=new PVector(b.pos.x-enemy.pos.x, b.pos.y-enemy.pos.y);
      }
    }
  }
  return out;
}

PVector getNearestPack(PVector pos) {
  PVector out=new PVector(MAX_FLOAT, MAX_FLOAT);
  for (Pack p : packs) {//get the closest pack
    if (dist(pos.x, pos.y, enemy.pos.x, enemy.pos.y)<out.mag()) {
      out=new PVector(p.pos.x-enemy.pos.x, p.pos.y-enemy.pos.y);
    }
  }
  return out;
}

void enemyShootBullet(int ammount, Tank p, Tank e) {
  if (ammount==1) {
    shots.add(new Bullet(p.pos.x, p.pos.y, e.pos.x-p.pos.x, e.pos.y-p.pos.y, true));
    p.shotCount++;
  } else {
    int counter=0;
    while (counter<ammount) {
      PVector dir=new PVector(e.pos.x-p.pos.x, e.pos.y-p.pos.y);
      dir.rotate(radians(-5+10*counter/ammount));
      shots.add(new Bullet(p.pos.x, p.pos.y, dir.x, dir.y, true));
      p.shotCount++;
      counter++;
    }
  }
  p.lastShotTime=millis();
}
