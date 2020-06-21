int radius = 300;
float nScale = 200;
float a = 1;

float zCoor = 500;
float xCoor = 0;

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
AudioMetaData meta;
BeatDetect beat;

float noiseMulti = 300;

void setup() {
  size(1000, 1000, P2D);
  background(0);
  frameRate(60);
  smooth();
  init("sample.mp3");
}

void init(String songName) {
  minim = new Minim(this);
  player = minim.loadFile(songName);
  player.loop();
  meta = player.getMetaData();
  beat = new BeatDetect(player.bufferSize(), player.sampleRate());
  beat.setSensitivity(300);
}

void draw() {
  noStroke();
  fill(0);
  rect(0, 0, width, height);
  translate(width/2, height/2);

  beat.detect(player.mix);
  if (beat.isKick()) {
    noiseMulti = 300;
    nScale = 150;
  } else {
    if (nScale > 100) nScale *= 0.9;
    noiseMulti *= 0.5;
  }


  // Trig angles around a circle
  stroke(random(200, 255));
  for (int lat = -90; lat<90; lat ++) {
    for (int lng = 0; lng<180; lng++) {
      float _lat = radians(lat);
      float _lng = radians(lng);

      float n = noise(_lat * noiseMulti, _lng * noiseMulti);

      float x = (radius + n * nScale) * cos(_lat) * cos(_lng);
      float y = (radius + n * nScale) * sin(_lat) * -1;
      float z = (radius + n * nScale) * cos(_lat) * cos(_lng);

      point(x, y, x);
    }
  }
  a++;
}

void mousePressed() {
  player.close();
  init("In Love With Myself.mp3");
}

void stop()
{
  player.close();
}
