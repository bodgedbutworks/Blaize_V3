import processing.opengl.*; //<>// //<>// //<>//
import java.awt.event.KeyEvent;
import processing.video.*;
import java.awt.AWTException;
import processing.core.*;
import processing.net.*;
import java.net.InetAddress;

Server s;
Client CC;
InetAddress inet;

kreis[] spotlight = new kreis[101];
rectbutton[] S = new rectbutton[50];
onoffbutton[] O = new onoffbutton[15];
slider[] X = new slider[10];

int[] ranX = new int[1001]; 
int[] ranY = new int[1001];
ArrayList<PVector> presetPos = new ArrayList<PVector>();

PImage[] pix = new PImage[60];

PrintWriter FileOutput;

PGraphics page1presetPix, page2presetPix, QuadPhaseLED;

color presetColor   = color(0, 0, 255);
color multiColorclr = color(255);

final long bpmConstant = 238740;         // Constant used for BPM auto mode

final int LMZxpos  = 5;                  // "Line Move Zone"
final int LMZypos  = 5*85+5;
final int LMZxsize = 460;
final int LMZysize = 340;

int presetNumber = 0;                    // 0 - 15
int presetSpeed      = 30;               // 0 - 100
int presetSizeDestination = 50;          // easing
int presetBrightnessDestination = 100;   // easing
int presetStrobing   = 0;                // 0 - 100
int a, b, c, d = 0;                      // Counters used for Random Numbers
int frameSizeX = 970;                    // width of drawin zone only (without (!) command window, 'cmdWindowWidth' pixels wide)
int frameSizeY = 1000;                   // height of window
int cmdWindowWidth = 630;                // width of command window
int shadeAmount = 0;
int bpm = 128;
int upperPage = 0;
int lowerPage = 0;
int bpmSwitchCounter = -1;
int fromWiFi_X = 8, fromWiFi_Y = 8;

long strobeTime, time = 0;
long bpmSTLtime = 0;
long time2 = 0;
long lastMouseMovedTime = 0;

float m, v;                   // Counters used for Rotation etc.
float translateCounter;
float presetBrightness = 100;  // 0 - 100
float presetSize       =  50;  // 0 - 100

boolean onoff;
boolean multiColor = false;
boolean drawTranslateMode = false;
boolean rec = false;
boolean bpmSTLmode = false;
boolean lockscreen = false;
boolean flag = false;
boolean editFramePos = false;
boolean editFrameSize = false;
boolean dontShowStartupScreenAnymore = false;
boolean hideControlWindow = false;
boolean licenseOK = false;

String pass = "";
String realPass = "BodgedButWorks";
String PCname;
String myIP;

PImage miniImage;
PImage AeroTraxBall;





void setup() {
  fullScreen(2);                 // Start on primary Display, Remove Window Frame/Border
  surface.setSize(frameSizeX+cmdWindowWidth, frameSizeY);

  //surface.setTitle("Blaize V3 by AeroTrax");

  hint(DISABLE_DEPTH_TEST);      // Ignore Z coordinates (optical glitches, maybe caused by push/popMatrix ?), draw everything on top of each other

  frameRate(60);
  ellipseMode(CENTER);
  rectMode(CORNER);
  textAlign(CENTER, CENTER);

  miniImage = createImage(frameSizeX, height, RGB);

  for (int n=0; n<21; n++) {
    spotlight[n] = new kreis();
  }

  try {  
    s = new Server(this, 12345);
  }
  catch(Exception e) {
  }

  for (int a=0; a<4; a++) {
    for (int b=0; b<4; b++) {
      S[4*b+a] = new rectbutton(color(200), a*155+5, b*85+5, 150, 80, 4*b+a, "PRESET");
    }
  }        //upperPage 0

  for (int a=0; a<4; a++) {
    for (int b=0; b<4; b++) {
      S[4*b+a+16] = new rectbutton(color(200), a*155+5, b*85+5, 150, 80, 4*b+a+16, "PRESET");
    }
  }  //upperPage 1

  pix[0]   = loadImage("Blaize presets -1.png");  //images 150x80
  pix[1]   = loadImage("Blaize presets -2.png");
  pix[2]   = loadImage("Blaize presets -3.png");
  pix[3]   = loadImage("Blaize presets -4.png");
  pix[4]   = loadImage("Blaize presets -5.png");
  pix[5]   = loadImage("Blaize presets -6.png");
  pix[6]   = loadImage("Blaize presets -7.png");
  pix[7]   = loadImage("Blaize presets -8.png");
  pix[8]   = loadImage("Blaize presets -9.png");
  pix[9]   = loadImage("Blaize presets -10.png");
  pix[10]  = loadImage("Blaize presets -11.png");
  pix[11]  = loadImage("Blaize presets -12.png");
  pix[12]  = loadImage("Blaize presets -13.png");
  pix[13]  = loadImage("Blaize presets -14.png");
  pix[14]  = loadImage("Blaize presets -15.png");
  pix[15]  = loadImage("Blaize presets -17.png");
  pix[16]  = loadImage("Blaize presets -18.png");
  pix[17]  = loadImage("Blaize presets -19.png");
  pix[18]  = loadImage("Blaize presets -20.png");
  pix[19]  = loadImage("Blaize presets -21.png");
  pix[20]  = loadImage("Blaize presets -23.png");
  pix[21]  = loadImage("Blaize presets -24.png");
  pix[22]  = loadImage("Blaize presets -25.png");
  pix[23]  = loadImage("Blaize presets -26.png");
  pix[24]  = loadImage("Blaize presets -27.png");
  pix[25]  = loadImage("Blaize presets -28.png");
  pix[26]  = loadImage("Blaize presets -30.png");
  pix[27]  = loadImage("Blaize presets -32.png");
  pix[28]  = loadImage("Blaize presets -35.png");
  pix[29]  = loadImage("Blaize presets -36.png");
  pix[30]  = loadImage("Blaize presets -15.png");
  pix[31]  = loadImage("Blaize presets -15.png");
  AeroTraxBall = loadImage("AeroTrax Sphere Logo.png");


  //Fusion of 16 small images to one large in a separate canvas, which is later "pasted" as an image with image(page1presetPix, x, y)
  page1presetPix = createGraphics(cmdWindowWidth, frameSizeY);
  page1presetPix.beginDraw();

  for (int a=0; a<4; a++) {
    for (int b=0; b<4; b++) {
      page1presetPix.image(pix[4*b+a], a*155+5, b*85+5, 150, 80);
    }
  }

  page1presetPix.endDraw();


  page2presetPix = createGraphics(cmdWindowWidth, frameSizeY);
  page2presetPix.beginDraw();

  for (int a=0; a<4; a++) {
    for (int b=0; b<4; b++) {
      page2presetPix.image(pix[4*b+a+16], a*155+5, b*85+5, 150, 80);
    }
  }

  page2presetPix.endDraw();

  //QuadPhaseLED = createGraphics(20, 20);


  S[32] = new rectbutton(color(255, 0, 0), 0*(cmdWindowWidth-10)/8+5, 4*85+5, (cmdWindowWidth)/8, 80, 0, "COLOR");    // Red
  S[33] = new rectbutton(color(255, 255, 0), 1*(cmdWindowWidth-10)/8+5, 4*85+5, (cmdWindowWidth)/8, 80, 0, "COLOR");    // Yellow
  S[34] = new rectbutton(color(  0, 255, 0), 2*(cmdWindowWidth-10)/8+5, 4*85+5, (cmdWindowWidth)/8, 80, 0, "COLOR");    // Green
  S[35] = new rectbutton(color(  0, 255, 255), 3*(cmdWindowWidth-10)/8+5, 4*85+5, (cmdWindowWidth)/8, 80, 0, "COLOR");    // Türkis
  S[36] = new rectbutton(color(  0, 0, 255), 4*(cmdWindowWidth-10)/8+5, 4*85+5, (cmdWindowWidth)/8, 80, 0, "COLOR");    // Blue
  S[37] = new rectbutton(color(255, 0, 255), 5*(cmdWindowWidth-10)/8+5, 4*85+5, (cmdWindowWidth)/8, 80, 0, "COLOR");    // Violet
  S[38] = new rectbutton(color(255, 255, 255), 6*(cmdWindowWidth-10)/8+5, 4*85+5, (cmdWindowWidth)/8, 80, 0, "COLOR");    // White
  S[39] = new rectbutton(color(          120), 7*(cmdWindowWidth-10)/8+5, 4*85+5, (cmdWindowWidth)/8, 80, 1, "COLOR");    // Random

  X[0] = new slider(color(30), color(80), 0*155+5, 5*85+5, 460, 80, "Speed");
  X[1] = new slider(color(30), color(80), 0*155+5, 6*85+5, 460, 80, "Size");
  X[2] = new slider(color(30), color(80), 0*155+5, 7*85+5, 460, 80, "Brightness");
  X[3] = new slider(color(30), color(80), 0*155+5, 8*85+5, 460, 80, "Strobing");
  //X[4] = new slider(color(30),color(80),0*155+5,6*85+5,460,80,"Threshold");
  //X[5] = new slider(color(30),color(80),0*155+5,7*85+5,460,80,"Dynamic");
  X[6] = new slider(color(30), color(80), 0*155+5, 6*85+5, 460, 80, "Shading");

  X[0].value = 30;   
  X[1].value = 50;   
  X[2].value = 100;   
  X[3].value = 0;   
  X[6].value = 0; 

  O[0] = new onoffbutton(color(255, 0, 0), 0*155+5, 4*85+5, 150, 80, 0, "Multicolor");
  O[1] = new onoffbutton(color(255, 0, 0), 0*155+5, 5*85+5, 150, 80, 0, "Blackout");
  O[2] = new onoffbutton(color(255, 0, 0), 1*155+5, 4*85+5, 150, 80, 0, "BPM");
  O[3] = new onoffbutton(color(255, 0, 0), 2*155+5, 4*85+5, 150, 38, 0, "+");
  O[4] = new onoffbutton(color(255, 0, 0), 2*155+5, 4*85+47, 150, 38, 0, "-");
  O[5] = new onoffbutton(color(255, 0, 0), 0*155+5, 4*85+5, 150, 80, 0, "Line Move");
  O[6] = new onoffbutton(color(255, 0, 0), 2*155+5, 5*85+5, 150, 80, 0, "Nudge +");
  O[7] = new onoffbutton(color(255, 0, 0), 1*155+5, 5*85+5, 150, 80, 0, "Nudge -");
  //O[8] = new onoffbutton(color(255,0,0),1*155+5,4*85+5,150,80,0,"Hide (h)");

  checkLicense();  //sets "licenseOK" variable to true or false.
} 












void draw() { 
  fill(0, map((mousePressed && !lockscreen && mouseX<frameSizeX ? 100 : shadeAmount), 0, 100, 255, 10)); 
  noStroke();
  rect(0, 0, frameSizeX, height);        // background of Beamer without (!) command window


  pushMatrix();

  if (mousePressed && !lockscreen) {
    noStroke(); 
    fill(255);
    if (mouseX < frameSizeX) {
      for (int i=0; i<10; i++) {
        ellipse(mouseX-i*(mouseX-pmouseX)/10, mouseY-i*(mouseY-pmouseY)/10, height/10, height/10);
      }
    }
  }


  //easing
  if (!O[1].buttonState) {      // if no Blackout
    presetBrightness += 0.2*(presetBrightnessDestination-presetBrightness);
  }

  presetSize += 0.14*(presetSizeDestination-presetSize);


  fill  (presetColor, presetBrightness*255/100);
  stroke(presetColor, presetBrightness*255/100);


  //Line moving
  if (drawTranslateMode  &&  presetPos.size() >= 3) {
    translateCounter += 1.0;
    if (translateCounter >= presetPos.size()) {  
      translateCounter = 0;
    }
    translate(map(presetPos.get(int(translateCounter)).x, LMZxpos+frameSizeX, LMZxpos+frameSizeX+LMZxsize, -frameSizeX, frameSizeX), map(presetPos.get(int(translateCounter)).y, LMZypos, LMZypos+LMZysize, -height, height));
  }

  //translate(map(fromWiFi_X, 0, 16, -frameSizeX/3, frameSizeX/3), map(fromWiFi_Y, 0, 16, -height/3, height/3));  //Coordinates from Smartphone


  //BPM Sound-To-Light
  if (bpmSTLmode) {
    if (millis()-bpmSTLtime >= bpmConstant/bpm) {
      bpmSwitchCounter++;
      bpmSTLtime = millis();

      int t = int(random(10, 95));     // No easing, instant size change
      X[1].value = t;
      presetSize = t;
      presetSizeDestination = t;

      do {  
        presetColor = color(random(0, 255), random(0, 255), random(0, 255));
      } while (brightness(presetColor) < 120);

      if (bpmSwitchCounter >= 8) {
        bpmSwitchCounter = 0;
        do {
          presetNumber = (int) random(0, 31);
          if (presetNumber == 8) {        // Mini-Dots-Discoball neu initialisieren
            for (int x=0; x<1000; x++) {
              ranX[x] = int(random(-0.71*frameSizeX, 0.71*frameSizeX));
              ranY[x] = int(random(-0.71*frameSizeX, 0.71*frameSizeX));
            }
          }
        } while (presetNumber==15 || presetNumber==23);
      }
    }
  }

  if (millis()-strobeTime >= 200-1.8*presetStrobing) {  
    onoff = !onoff; 
    strobeTime = millis();
  }
  if (presetStrobing == 0) {  
    onoff = true;
  }

  if (onoff) {
    switch(presetNumber) {
      /* 1 Kreis-Ring (Sinus) */
    case 0:  
      noStroke();
      for (float i=0; i<18; i++) {
        if (multiColor  && i%2 == 0) {  
          fill(presetColor, presetBrightness*255/100);
        } else if (multiColor) {  
          fill(multiColorclr, presetBrightness*255/100);
        }
        ellipse(frameSizeX/2+((0.9*presetSize+10)*height/240)*sin(i*v), height/2+((0.9*presetSize+10)*height/240)*cos(i*v), 0.8*(0.9*presetSize+10), 0.8*(0.9*presetSize+10));  
        v += float(presetSpeed)/360000;
      }
      break;
      /* 1 Kreis-Ring (Konstant) */
    case 1:  
      noStroke();
      translate(frameSizeX/2, height/2);
      rotate(v); 
      v += float(presetSpeed)/2000;
      for (float i=0; i<18; i++) {
        if (multiColor  && i%2 == 0) {  
          fill(presetColor, presetBrightness*255/100);
        } else if (multiColor) {  
          fill(multiColorclr, presetBrightness*255/100);
        }
        ellipse(((0.9*presetSize+10)*height/240)*sin(i*PI/9), ((0.9*presetSize+10)*height/240)*cos(i*PI/9), 0.8*(0.9*presetSize+10), 0.8*(0.9*presetSize+10));
      }
      break;
      /* 3 Kreis-Ringe */
    case 2:  
      noStroke();
      translate(frameSizeX/2, height/2);
      rotate(v); 
      v += float(presetSpeed)/3000;
      for (float i=0; i<18; i++) {
        if (multiColor  && i%2 == 0) {  
          fill(presetColor, presetBrightness*255/100);
        } else if (multiColor) {  
          fill(multiColorclr, presetBrightness*255/100);
        }
        ellipse(((0.9*presetSize+10)*height/240)*sin(i*PI/9), ((0.9*presetSize+10)*height/240)*cos(i*PI/9), 0.4*(0.9*presetSize+10), 0.4*(0.9*presetSize+10));
      }
      for (float i=0; i<18; i++) {
        if (multiColor  && i%2 == 0) {  
          fill(presetColor, presetBrightness*255/100);
        } else if (multiColor) {  
          fill(multiColorclr, presetBrightness*255/100);
        }
        ellipse(((0.9*presetSize+10)*height/800)*sin(i*PI/9), ((0.9*presetSize+10)*height/800)*cos(i*PI/9), 0.1*(0.9*presetSize+10), 0.1*(0.9*presetSize+10));
      }
      rotate(-2*v);
      for (float i=0; i<18; i++) {
        if (multiColor  && i%2 == 0) {  
          fill(presetColor, presetBrightness*255/100);
        } else if (multiColor) {  
          fill(multiColorclr, presetBrightness*255/100);
        }
        ellipse(((0.9*presetSize+10)*height/400)*sin(i*PI/9), ((0.9*presetSize+10)*height/400)*cos(i*PI/9), 0.2*(0.9*presetSize+10), 0.2*(0.9*presetSize+10));
      }                 
      break;
      /* Random Linien */
    case 3:  
      strokeWeight(1.4*presetSize+10);
      if (multiColor) {
        line(a, b, a+((c-a)/3), b+((d-b)/3));
        line(a+(2*(c-a)/3), b+(2*(d-b)/3), c, d);
        stroke(multiColorclr, presetBrightness*255/100);
        line(a+((c-a)/3), b+((d-b)/3), a+(2*(c-a))/3, b+(2*(d-b)/3));
      } else {
        line(a, b, c, d);
      }
      if (millis()-time >= 1000-10*presetSpeed  &&  presetSpeed != 0) {
        time = millis();
        a = int(random(50, frameSizeX-50));
        b = int(random(50, height-50));
        c = int(random(50, frameSizeX-50));
        d = int(random(50, height-50));
      }
      break;
      /* Random Ringe groß & schmal */
    case 4:  
      noFill();
      strokeWeight(map(presetSize, 0, 100, 5, 60));
      if (multiColor) {
        for (float l=0; l<=7; l++) {
          if (l%2 == 0) {  
            stroke(presetColor, presetBrightness*255/100);
          } else {  
            stroke(multiColorclr, presetBrightness*255/100);
          }
          arc(a, b, 500, 500, l*PI/4+c, (l+1)*PI/4+c, OPEN);
        }
      } else {
        ellipse(a, b, 500, 500);
      }
      if (millis()-time >= 1000-10*presetSpeed  &&  presetSpeed != 0) {
        time = millis();
        a = int(random(150, frameSizeX-150));
        b = int(random(150, height-150));
      }
      break;
      /* Sinus */
    case 5:  
      noStroke();
      for (float f=0; f<frameSizeX/16; f++) {
        if (multiColor) {
          if (f%20 <= 10) {  
            fill(presetColor, presetBrightness*255/100);
          } else {  
            fill(multiColorclr, presetBrightness*255/100);
          }
        }
        ellipse(16*f, height/2+ 4.5*presetSize*sin(v - f/15 /*NumOfPeriods*/), 70, 70);  
        v += float(presetSpeed)/90000;
      }
      break;
      /* Sinus-Blöcke */
    case 6:  
      noStroke();
      for (float f=0; f<frameSizeX/90; f++) {
        if (multiColor) {
          if (f%2 == 0) {  
            fill(presetColor, presetBrightness*255/100);
          } else {  
            fill(multiColorclr, presetBrightness*255/100);
          }
        }
        rect(100*f, 0.45*height+100*sin(v - f/1)+presetSize*height*0.005, 60, height/10);
        rect(100*f, 0.45*height-100*sin(v - f/1)-presetSize*height*0.005, 60, height/10);  
        v += float(presetSpeed)/15000;
      }
      break;
      /* Dreh-Kreuz */
    case 7:  
      strokeWeight(1.5*presetSize);
      translate(frameSizeX/2, height/2);
      rotate(v); 
      v += float(presetSpeed)/1000;
      if (multiColor) {
        for (float i=0; i<10; i++) {
          if (multiColor  && i%2 == 0) {  
            stroke(presetColor, presetBrightness*255/100);
          } else if (multiColor) {  
            stroke(multiColorclr, presetBrightness*255/100);
          }
          line(0, (i-5)*height/5, 0, (i-4)*height/5);  
          line((i-5)*frameSizeX/5, 0, (i-4)*frameSizeX/5, 0);
        }
      } else {
        line(0, -height, 0, height);
        line(-frameSizeX, 0, frameSizeX, 0);
      }
      break; 
      /* Mini-dots-discoball */
    case 8:  
      noStroke();
      translate(frameSizeX/2, height/2);
      rotate(v);  
      v += float(presetSpeed)/5000;
      for (int x=0; x<1000; x++) {
        if (multiColor && x>500) {  
          fill(multiColorclr, presetBrightness*255/100);
        }
        ellipse(ranX[x], ranY[x], presetSize/8, presetSize/8);
      }
      break;
      /* Random Kreise */
    case 9:  
      noStroke();
      for (int x=0; x<(presetSize+10)/10; x++) {
        if (multiColor && x>presetSize/20) {  
          fill(multiColorclr, presetBrightness*255/100);
        }
        ellipse(ranX[x], ranY[x], 300-2.7*presetSize, 300-2.7*presetSize);
      }
      if (millis()-time >= 1000-9.5*presetSpeed  &&  presetSpeed != 0) {
        time = millis();
        for (int x=0; x<(presetSize+10)/10; x++) {
          ranX[x] = int(random((300-2.7*presetSize)/2, frameSizeX-(300-2.7*presetSize)/2));
          ranY[x] = int(random((300-2.7*presetSize)/2, height    -(300-2.7*presetSize)/2));
        }
      }
      break;
      /* Random Ringe */
    case 10: 
      noFill();
      strokeWeight(60-0.5*presetSize);
      for (int x=0; x<(presetSize+10)/10; x++) {
        if (multiColor && x>presetSize/20) {  
          stroke(multiColorclr, presetBrightness*255/100);
        }
        ellipse(ranX[x], ranY[x], 500-4*presetSize, 500-4*presetSize);
      }
      if (millis()-time >= 1000-9.5*presetSpeed  &&  presetSpeed != 0) {
        time = millis();
        for (int x=0; x<(presetSize+10)/10; x++) {
          ranX[x] = int(random((300-2.7*presetSize)/2, frameSizeX-(300-2.7*presetSize)/2));
          ranY[x] = int(random((300-2.7*presetSize)/2, height    -(300-2.7*presetSize)/2));
        }
      }
      break;
      /* Scanner seitlich */
    case 11: 
      strokeWeight(1.5*presetSize);
      translate((frameSizeX/2.4)*sin(v)+frameSizeX/2, 0); 
      v += float(presetSpeed)/1000;
      if (multiColor) {
        line(0, 0, 0, height/3);
        line(0, 2*height/3, 0, height);
        stroke(multiColorclr, presetBrightness*255/100);
        line(0, height/3, 0, 2*height/3);
      } else {
        line(0, 0, 0, height);
      }
      break;
      /* Scanner hoch/runter */
    case 12: 
      strokeWeight(1.5*presetSize);
      translate(0, (height/2.4)*sin(v)+height/2); 
      v += float(presetSpeed)/1000;
      if (multiColor) {
        line(0, 0, frameSizeX/3, 0);
        line(2*frameSizeX/3, 0, frameSizeX, 0);
        stroke(multiColorclr, presetBrightness*255/100);
        line(frameSizeX/3, 0, 2*frameSizeX/3, 0);
      } else {
        line(0, 0, frameSizeX, 0);
      }
      break;
      /* 2 Scanner */
    case 13: 
      strokeWeight(1.5*presetSize);
      translate((frameSizeX/2.4)*sin(v*1.2)+frameSizeX/2, (height/2.4)*sin(v*0.8)+height/2); 
      v += float(presetSpeed)/1000;
      if (multiColor) {
        for (float i=0; i<10; i++) {
          if (multiColor  && i%2 == 0) {  
            stroke(presetColor, presetBrightness*255/100);
          } else if (multiColor) {  
            stroke(multiColorclr, presetBrightness*255/100);
          }
          line(0, (i-5)*height/5, 0, (i-4)*height/5);  
          line((i-5)*frameSizeX/5, 0, (i-4)*frameSizeX/5, 0);
        }
      } else {
        line(0, -height, 0, height);
        line(-frameSizeX, 0, frameSizeX, 0);
      }
      break;
      /* PingPong-Kreise */
    case 14: 
      noStroke();
      for (int m=0; m<(presetSize+4)/5; m++) {
        if (multiColor && m>(presetSize+4)/10) {  
          fill(multiColorclr, presetBrightness*255/100);
        }
        spotlight[m].move();
      }
      break;
      /* Maus-Verfolger-Spot */
    case 15: 
      noStroke();
      image(AeroTraxBall, (drawTranslateMode ? frameSizeX/2 : mouseX)-3*presetSize, (drawTranslateMode ? height/2 : mouseY)-3*presetSize, 6*presetSize, 6*presetSize);
      break;
      /* Multiscanner seitlich */
    case 16: 
      strokeWeight(presetSize);
      for (int r=-4; r<=4; r++) {
        if (multiColor) {
          if (r%2 == 0) {  
            stroke(presetColor, presetBrightness*255/100);
          } else {  
            stroke(multiColorclr, presetBrightness*255/100);
          }
        }
        line(m+r*frameSizeX/4, 0, m+r*frameSizeX/4, height);
      }
      m = m + float(presetSpeed)/3;
      if (m >= frameSizeX-50) {  
        m = -50;
      }
      break;
      /* Multiscanner runter */
    case 17: 
      strokeWeight(presetSize);
      for (int r=-4; r<=4; r++) {
        if (multiColor) {
          if (r%2 == 0) {  
            stroke(presetColor, presetBrightness*255/100);
          } else {  
            stroke(multiColorclr, presetBrightness*255/100);
          }
        }
        line(0, m+r*height/4, frameSizeX, m+r*height/4);
      }
      m = m + float(presetSpeed)/3;
      if (m >= height-50) {  
        m = -50;
      }
      break;
      /* Sinus-Mini-Multiscanner seitlich */
    case 18: 
      strokeWeight(80);
      translate(0, (height/3)*sin(v)); 
      v += float(presetSpeed)/5000;
      for (int r=-4; r<=4; r++) {
        if (multiColor) {
          if (r%2 == 0) {  
            stroke(presetColor, presetBrightness*255/100);
          } else {  
            stroke(multiColorclr, presetBrightness*255/100);
          }
        }
        line(m+r*frameSizeX/4, map(presetSize, 0, 100, height/2, 200), m+r*frameSizeX/4, map(presetSize, 0, 100, height/2, height-200));
      }
      m = m + float(presetSpeed)/4;
      if (m >= frameSizeX-50) {  
        m = -50;
      }
      break;
      /* Sinus-Mini-Multiscanner runter */
    case 19: 
      strokeWeight(80);
      translate((frameSizeX/3)*sin(v), 0); 
      v += float(presetSpeed)/5000;
      for (int r=-4; r<=4; r++) {
        if (multiColor) {
          if (r%2 == 0) {  
            stroke(presetColor, presetBrightness*255/100);
          } else {  
            stroke(multiColorclr, presetBrightness*255/100);
          }
        }
        line(map(presetSize, 0, 100, frameSizeX/2, 200), m+r*height/4, map(presetSize, 0, 100, frameSizeX/2, frameSizeX-200), m+r*height/4);
      }
      m = m + float(presetSpeed)/4;
      if (m >= height-50) {  
        m = -50;
      }
      break;
      /* Halbkreise */
    case 20: 
      noFill(); 
      strokeWeight(presetSize);
      if (multiColor && a<14) {  
        stroke(multiColorclr, presetBrightness*255/100);
      }
      if     (a<=10 &&  b<=10) {  
        arc(frameSizeX, height/2, c, c, v*PI/50-HALF_PI, v*PI/50+HALF_PI, OPEN);
      } else if (a<=10 &&  b> 10) {  
        arc(frameSizeX/2, height, c, c, v*PI/50, v*PI/50+PI, OPEN);
      } else if (a> 10 &&  b<=10) {  
        arc(0, height/2, c, c, v*PI/50+HALF_PI, v*PI/50+3*HALF_PI, OPEN);
      } else if (a> 10 &&  b> 10) {  
        arc(frameSizeX/2, 0, c, c, v*PI/50-PI, v*PI/50, OPEN);
      }
      v = v + float(presetSpeed)/20;  
      if (v >= 100) {
        v = 0;
        a = int(random(0, 21));
        b = int(random(0, 21));
        c = int(random(350, height-50));
      }
      break;      
      /* Sinus mit Strahlen */
    case 21: 
      noStroke();
      for (float f=0; f<frameSizeX/16; f++) {
        if (f%14 < 1) {
          fill(multiColorclr, 255);
        } else {
          fill(presetColor, presetBrightness*255/200);
        }
        ellipse(16*f, height/2+4.5*presetSize*sin(v - f/15 /*NumOfPeriods*/), 80, 80); 
        v += float(presetSpeed)/90000;
      }
      break;
      /* Rotierende Lines */
    case 22: 
      strokeWeight(50+0.5*presetSize);
      translate(frameSizeX/2, height/2);
      rotate(v); 
      v += float(presetSpeed)/3000;
      for (int r=-8; r<=8; r++) {
        if (multiColor) {
          if (r%2 == 0) {  
            stroke(presetColor, presetBrightness*255/100);
          } else {  
            stroke(multiColorclr, presetBrightness*255/100);
          }
        }
        line(m+r*frameSizeX/8-frameSizeX/2, -presetSize*height/200+30, m+(r+1)*frameSizeX/8-frameSizeX/2, -presetSize*height/200+30);
      }
      rotate(-2*v);
      for (int r=-8; r<=8; r++) {
        if (multiColor) {
          if (r%2 == 0) {  
            stroke(presetColor, presetBrightness*255/100);
          } else {  
            stroke(multiColorclr, presetBrightness*255/100);
          }
        }
        line(m+r*frameSizeX/8-frameSizeX/2, presetSize*height/200-30, m+(r+1)*frameSizeX/8-frameSizeX/2, presetSize*height/200-30);
      }
      m += 1;
      if (m >= frameSizeX-50) {  
        m = -50;
      }
      break;
      /* Fullscreen-Farbe */
    case 23: 
      noStroke();
      rect(0, 0, frameSizeX, height);
      break;
      /* 4 Scanner-Linien */
    case 24: 
      strokeWeight(0.8*presetSize);
      line(frameSizeX/4+(presetSize*height/240)*sin(500*v), height/4-(presetSize*height/240)*cos(500*v), frameSizeX/4-(presetSize*height/240)*sin(500*v), height/4-(presetSize*height/240)*cos(500*v));
      line(3*frameSizeX/4+(presetSize*height/240)*sin(500*v), 3*height/4-(presetSize*height/240)*cos(500*v), 3*frameSizeX/4-(presetSize*height/240)*sin(500*v), 3*height/4-(presetSize*height/240)*cos(500*v));
      if (multiColor) {  
        stroke(multiColorclr, presetBrightness*255/100);
      }
      line(3*frameSizeX/4-(presetSize*height/240)*sin(500*v), height/4+(presetSize*height/240)*cos(500*v), 3*frameSizeX/4-(presetSize*height/240)*sin(500*v), height/4-(presetSize*height/240)*cos(500*v));
      line(frameSizeX/4-(presetSize*height/240)*sin(500*v), 3*height/4+(presetSize*height/240)*cos(500*v), frameSizeX/4-(presetSize*height/240)*sin(500*v), 3*height/4-(presetSize*height/240)*cos(500*v));
      v += float(presetSpeed)/360000;
      break;
      /* 4 rotierende Linien */
    case 25: 
      strokeWeight(0.8*presetSize);
      line(frameSizeX/4+(presetSize*height/240)*sin(500*v), height/4+(presetSize*height/240)*cos(500*v), frameSizeX/4-(presetSize*height/240)*sin(500*v), height/4-(presetSize*height/240)*cos(500*v));
      line(3*frameSizeX/4+(presetSize*height/240)*sin(500*v), 3*height/4+(presetSize*height/240)*cos(500*v), 3*frameSizeX/4-(presetSize*height/240)*sin(500*v), 3*height/4-(presetSize*height/240)*cos(500*v));
      if (multiColor) {  
        stroke(multiColorclr, presetBrightness*255/100);
      }
      line(3*frameSizeX/4+(presetSize*height/240)*cos(500*v), height/4+(presetSize*height/240)*sin(500*v), 3*frameSizeX/4-(presetSize*height/240)*cos(500*v), height/4-(presetSize*height/240)*sin(500*v));
      line(frameSizeX/4+(presetSize*height/240)*cos(500*v), 3*height/4+(presetSize*height/240)*sin(500*v), frameSizeX/4-(presetSize*height/240)*cos(500*v), 3*height/4-(presetSize*height/240)*sin(500*v));
      v += float(presetSpeed)/360000;
      break;
      /* 4 rotierende Kreis-Ringe */
    case 26: 
      noStroke();
      for (int r=0; r<=3; r++) {
        pushMatrix();
        switch(r) {
        case 0:  
          translate(frameSizeX/4, height/4);   
          rotate(v);   
          break;
        case 1:  
          translate(3*frameSizeX/4, height/4);   
          rotate(-v);  
          break;
        case 2:  
          translate(frameSizeX/4, 3*height/4); 
          rotate(-v);  
          break;
        case 3:  
          translate(3*frameSizeX/4, 3*height/4); 
          rotate(v);   
          break;
        }
        for (float i=0; i<18; i++) {
          if (multiColor  && i%2 == 0) {  
            fill(presetColor, presetBrightness*255/100);
          } else if (multiColor) {  
            fill(multiColorclr, presetBrightness*255/100);
          }
          ellipse(((presetSize*0.6+3)*height/120)*sin(i*PI/9), ((presetSize*0.6+3)*height/120)*cos(i*PI/9), 0.5*presetSize+6, 0.5*presetSize+6);
        }
        popMatrix();
      }
      v += float(presetSpeed)/4000;
      break;
      /* 4 crazy Kreis-Ringe */
    case 27: 
      noStroke();
      for (int xx=0; xx<=1; xx++) {
        for (int yy=0; yy<=1; yy++) {
          rotate(v); 
          v += float(presetSpeed)/20000;
          for (float i=0; i<18; i++) {
            if (multiColor  && i%2 == 0) {  
              fill(presetColor, presetBrightness*255/100);
            } else if (multiColor) {  
              fill(multiColorclr, presetBrightness*255/100);
            }
            ellipse((2*xx+1)*(frameSizeX/4)+((presetSize+40)*height/240)*sin(i*PI/9), (2*yy+1)*(height/4)+((presetSize+40)*height/240)*cos(i*PI/9), 0.3*(presetSize+40), 0.3*(presetSize+40));
          }
        }
      }
      break;
      /* Kreisring-spot-scan-Dings */
    case 28: 
      noStroke();
      translate(frameSizeX/2, height/2);
      ellipse(-presetSize*((frameSizeX-45)/250)*cos(v), presetSize*((height-45)/250)*sin(v), 45, 45);
      if (multiColor) {  
        fill(multiColorclr, presetBrightness*255/100);
      }
      ellipse( presetSize*((frameSizeX-60)/190)*cos(v), presetSize*((height-60)/190)*sin(v), 60, 60);
      v += float(presetSpeed)/800;
      break;
      /* Tunnelrechteck */
    case 29: 
      noFill();
      translate(frameSizeX/2, height/2);

      if (m >= 110) {
        strokeWeight(max(0, (presetSize+1)*(220-m)/110));  
        stroke(multiColorclr, presetBrightness*255/100);
        rect(-(220-m)*frameSizeX/200, -(220-m)*height/200, max(0, (220-m)*frameSizeX/100), max(0, (220-m)*height/100));
      } else {
        strokeWeight((presetSize+1)*m/110);
        rect(-m*frameSizeX/200, -m*height/200, m*frameSizeX/100, m*height/100);
      }

      m += float(presetSpeed)/40;
      if (m >= 220) {  
        m = 0;
      }
      break;
      /* Dot-Scanner */
    case 30: 
      noStroke();
      for (int i=0; i<=9; i++) {
        for (int j=0; j<=9; j++) {
          if (multiColor) {
            if ((i+j)%2 == 0) {  
              fill(presetColor, constrain(-100+355*sin(v+31*float(i+j)), 0, presetBrightness*255/100));
            } else {              
              fill(multiColorclr, constrain(-100+355*sin(v+31*float(i+j)), 0, presetBrightness*255/100));
            }
          } else {
            fill(presetColor, constrain(-100+355*sin(v+31*float(i+j)), 0, presetBrightness*255/100));
          }

          ellipse(i*frameSizeX/10 + frameSizeX/30, j*frameSizeX/10 + frameSizeX/30, map(presetSize, 0, 100, 10, frameSizeX/18), map(presetSize, 0, 100, 10, frameSizeX/18));
        }
      }
      v += float(presetSpeed)/1200;
      break;

    case 31: /*QuadPhaseLED.beginDraw();
       rectMode(CORNERS);
       int _x = 10; int _y = 10;
       if(red(  presetColor) > 0  ||  red(  multiColorclr) > 0){ fill(255, 0, 0); QuadPhaseLED.rect(_x-10, _y-10, _x, _y); }
       if(green(presetColor) > 0  ||  green(multiColorclr) > 0){ fill(0, 255, 0); QuadPhaseLED.rect(_x, _y-10, _x+10, _y); }
       if(blue( presetColor) > 0  ||  blue( multiColorclr) > 0){ fill(0, 0, 255); QuadPhaseLED.rect(_x-10, _y, _x, _y+10); }
       if(red(presetColor)>0 && green(presetColor)>0 && blue(presetColor)>0){ fill(255); QuadPhaseLED.rect(_x, _y, _x+10, _y+10); }
       noStroke();
       QuadPhaseLED.endDraw();
       image(QuadPhaseLED, 400, 400);*/
      int LEN = 5*height/40;
      rectMode(CORNERS);
      noStroke();
      for (int b=0; b<=2; b++) {
        float BRIGHT = presetBrightness;      // BRIGHT and presetBrightness = [0, 100]
        final float THRESH = 0.2;           // Controls flash style of the 3 circles
        final float BLINKSPD = 3.0;
        pushMatrix();
        switch(b) {
        case 0: 
          translate(14*frameSizeX/40, 4*height/12);
          rotate(v);
          if (sin(BLINKSPD*v) > THRESH) {
            BRIGHT = map(sin(BLINKSPD*v), THRESH, 1.0, 100, 0);
          }
          break;
        case 1: 
          translate(26*frameSizeX/40, 4*height/12);
          rotate(v);
          if (sin(BLINKSPD*v+2*PI/3) > THRESH) {
            BRIGHT = map(sin(BLINKSPD*v+2*PI/3), THRESH, 1.0, 100, 0);
          }
          break;
        case 2: 
          translate(frameSizeX/2, 8*height/12);
          rotate(v);
          if (sin(BLINKSPD*v+4*PI/3) > THRESH) {
            BRIGHT = map(sin(BLINKSPD*v+4*PI/3), THRESH, 1.0, 100, 0);
          }
          break;
        }

        for (int e=0; e<=4; e++) {
          for (int f=0; f<=4; f++) {
            if (!(e==0&&f==0)  &&  !(e==4&&f==0)  &&  !(e==0&&f==4)  &&  !(e==4&&f==4)  &&  !(e==2&&f==2)) {
              drawQuadLED(LEN*e-2*LEN, LEN*f-2*LEN, round(BRIGHT*presetBrightness/100));
            }
          }
        }
        popMatrix();
      }

      v += map(float(presetSpeed), 0, 100, -0.06, 0.06);
      rectMode(CORNER);
      break;

    default: 
      break;
    }
  } 

  popMatrix();

  if (!hideControlWindow) {
    thread("getMiniImage");   //Copy animation for mini image in control window, do this in a seperate thread
  }





  fill(editFrameSize ? 255 : 0); 
  noStroke();
  rect(frameSizeX, 0, cmdWindowWidth, height);  // background of Control Window
  lockscreen = false;


  if (!pass.equals(realPass)) {     // Start (Lock-) screen
    lockscreen = true;
    textAlign(CENTER);
    textSize(78); 
    fill(0, 200, 255);
    text("Blaize 3", frameSizeX+310, 180);
    //textSize(40);
    //text("©", frameSizeX+480, 140);
    textSize(27); 
    fill(255);
    text("Spice up your Beamer.", frameSizeX+314, 208);
    textSize(20); 
    fill(255);
    text("Please subscribe to\nBodgedButWorks on YouTube\nand follow me on instagram!\n", frameSizeX+320, 350);
    //text("www.aerotrax.de", frameSizeX+320, 380);
    textSize(20); 
    fill(0, 200, 255);

    for (int u=0; u<pass.length(); u++) {
      text(random(0, 100)>50 ? "|||" : "||", frameSizeX+230+15*u, 500);
    }

    text("Please enter Password", frameSizeX+320, 550);

    if (!licenseOK) {
      textSize(frameSizeY/30); 
      fill(255, 0, 0);
      text("! License Error !", frameSizeX/2, frameSizeY/2);
      noLoop();
    }

    try {                                // Get IP Adress, Handle Exceptions
      inet = InetAddress.getLocalHost();
      myIP = inet.getHostAddress();
    }
    catch (Exception e) {
      e.printStackTrace();
      myIP = "IP not available";
    }

    textSize(20); 
    fill(0, 200, 255);
    text("IP: " + myIP, frameSizeX+315, 590);
    pushMatrix();
    rotate(-HALF_PI);
    textSize(40); 
    fill(255);
    text("An AeroTrax application", -355, frameSizeX+120);
    stroke(255); 
    strokeWeight(5);
    line(-592, frameSizeX+140, -120, frameSizeX+140);
    popMatrix();
    time2 = millis();
    textAlign(CENTER, CENTER);
  } else if (millis()-time2 < 8000  &&  dontShowStartupScreenAnymore == false) {
    flag = false;
    textAlign(CENTER);
    textSize(78); 
    fill(0, 200, 255);
    text("Blaize 3", frameSizeX+310, 180);
    //textSize(40);
    //text("©", frameSizeX+480, 140);
    textSize(27); 
    fill(255);
    text("Spice up your Beamer.", frameSizeX+314, 208);
    textSize(20); 
    fill(255);
    text("Please subscribe to\nBodgedButWorks on YouTube\nand follow me on instagram!", frameSizeX+320, 350);
    //text("www.aerotrax.de", frameSizeX+320, 380);
    textSize(20); 
    fill(0, 200, 255);
    text("Strg + <^v>:  Change window size", frameSizeX+345, 550);
    //text("Shift + arrow keys: "    ,frameSizeX+325,590);
    text("Click to continue", frameSizeX+256, 590);
    pushMatrix();
    rotate(-HALF_PI);
    textSize(40); 
    fill(255);
    text("An AeroTrax application", -355, frameSizeX+120);
    stroke(255); 
    strokeWeight(5);
    line(-592, frameSizeX+140, -120, frameSizeX+140);
    popMatrix();

    if (mousePressed) {
      dontShowStartupScreenAnymore = true;
    }
    textAlign(CENTER, CENTER);
  } else {
    if (millis()-lastMouseMovedTime >= 5000) {    // Auto-hide
      hideControlWindow = true;
    }

    if (!hideControlWindow) {
      if (upperPage == 0) {
        image(page1presetPix, frameSizeX, 0);
        for (int i=0; i<=15; i++) {  
          S[i].display();
        }
      } else if (upperPage == 1) {
        image(page2presetPix, frameSizeX, 0);
        for (int i=16; i<=31; i++) {  
          S[i].display();
        }
      }

      if (lowerPage == 0) {
        for (int i=32; i<=39; i++) {  
          S[i].display();
        }
        for (int i=0; i<=3; i++) {  
          X[i].display();
        }
      } else if (lowerPage == 1) {
        for (int v=0; v<=4; v++) {  
          O[v].display();
        }
        for (int v=6; v<=7; v++) {  
          O[v].display();
        }
        for (int v=6; v<=6; v++) {  
          X[v].display();
        }
      } else if (lowerPage == 2) {
        for (int v=5; v<=5; v++) {  
          O[v].display();
        }

        fill(30); 
        noStroke();
        rect(LMZxpos+frameSizeX, LMZypos, LMZxsize, LMZysize);     // "Line Move Zone"
        fill(80);
        rect(LMZxpos+frameSizeX+LMZxsize/4, LMZypos+LMZysize/4, LMZxsize/2, LMZysize/2);

        if (mousePressed && mouseButton == LEFT && mouseX>LMZxpos+frameSizeX && mouseX<(LMZxpos+frameSizeX+LMZxsize) && mouseY>LMZypos && mouseY<(LMZypos+LMZysize)
        /*&& dist(mouseX, mouseY, presetPos.get(max(presetPos.size()-2, 0)).x, presetPos.get(max(presetPos.size()-2, 0)).y) >= 2*/          ) {
          presetPos.add(new PVector(mouseX, mouseY));
        }

        stroke(0); 
        strokeWeight(4);
        for (int u=1; u<presetPos.size(); u++) {
          line(presetPos.get(u-1).x, presetPos.get(u-1).y, presetPos.get(u).x, presetPos.get(u).y);
        }
      }
    }




    // NETWORKING __________________________________________________________________________________________________________________________________  
    try {  
      CC = s.available();
    }   // Receive data from WiFi Console
    catch(Exception e) {
    }

    if (CC != null) {
      String input = CC.readString();
      String[] vals1 = splitTokens(input, "C\n");

      int _adress = -1;
      int _data   = -1;

      for (int k=0; k<vals1.length; k++) {
        String[] vals2 = split(vals1[k], 'V');
        if (vals2.length == 2) {
          _adress = int(vals2[0]);
          _data   = int(vals2[1]);
        } else {
          _adress = -1;
          _data   = -1;
        }


        if (_adress <= 31  &&  _data == 0) {                                                 // 0-31 Presets, 32-35 Color buttons
          S[_adress].doStuff();
        } else if (_adress == 32  &&  _data >= 0  &&  _data <= 7) {                            // Color Buttons 0-7
          S[32+_data].doStuff();
        }

        //adress 33, 34, 35 now free (formerly Color Buttons Green, Blue, Random)

        else if (_adress >= 36  &&  _adress <= 42) {                                         // onoffbuttons
          if (_data == 1) {  
            O[_adress-36].buttonState =  true; 
            O[_adress-36].doStuff();
          }
          if (_data == 0) {  
            O[_adress-36].buttonState = false; 
            O[_adress-36].doStuff();
          }
        }

        // Adress 43 is currently free

        else if (_adress >= 44  &&  (_adress != 48  &&  _adress != 49)  &&  _adress <= 50  &&  _data >= 0  &&  _data <= 100) {       // Sliders
          X[_adress-44].value = _data;
          X[_adress-44].doStuff();
        } else if (_adress >= 51  &&  _adress <= 52) {                                         // Nudge +  &  Nudge -
          if (_data == 1) {  
            O[_adress-45].buttonState =  true; 
            O[_adress-45].doStuff();
          }
        } else if (_adress == 254  &&  _data >= 60  &&  _data <= 180) {                        // bpm set value
          bpm = _data;
        } else if (_adress == 255) {                                                           // XY translation control
          //println(binary(_data)); println(_data); print(" "); println(_data >> 16);
          fromWiFi_X = 0;
          fromWiFi_Y = 0;
        }  //Aufteilung von 32 bit auf 2 x 16 bit (0-32768) für X & Y
      }
    }
  }
}









//________________________ Functions for extra Threads _______________________________//
void getMiniImage() {
  miniImage = get(0, 0, frameSizeX, height);
}





void mousePressed() {
  if (mouseButton == LEFT) {
    flag  = true;

    if (lowerPage == 2 && mouseX>LMZxpos+frameSizeX && mouseX<(LMZxpos+frameSizeX+LMZxsize) && mouseY>LMZypos && mouseY<(LMZypos+LMZysize)) {  
      presetPos.clear();
    }
  } else if (mouseButton == RIGHT) {
    flag = false;

    if (mouseY <= 340) {
      upperPage++;
      if (upperPage == 2) {  
        upperPage = 0;
      }
    } else {
      lowerPage++;
      if (lowerPage == 3) {  
        lowerPage = 0;
      }
    }
  } else if (mouseButton == CENTER) {
    if (mouseY <= 340) {
      upperPage = 0;
    } else {
      lowerPage = 0;
    }
  }
}


void mouseReleased() {
  O[1].buttonState = false;    // Blackout off

  if (mouseX>(O[1].xpos+frameSizeX+10) && mouseX<(O[1].xpos+frameSizeX+O[1].xsize-10) && mouseY>(O[1].ypos+10) && mouseY<(O[1].ypos+O[1].ysize-10)) {
    O[1].doStuff();
  }
}


void mouseMoved() {              // Mouse moved while not clicked
  hideControlWindow = false;
  lastMouseMovedTime = millis();
}


void mouseDragged() {            // Mouse moved while clicked
  hideControlWindow = false;
  lastMouseMovedTime = millis();
}


void keyPressed() {
  if (key != CODED) {

    if (key == ESC) {
      key = 0;
    } else if (key == 8) {     //backspace
      pass = "";
    } else if (key >= 32  &&  key <= 126  &&  lockscreen == true) {
      pass = pass + key;
    } else if (lockscreen == false  &&  (key == 'h'  ||  key == 'H')) {
      O[6].buttonState = !O[6].buttonState;
      O[6].doStuff();
    }
  }

  if (key == CODED) {
    if (keyCode == KeyEvent.VK_END) {
      pass = "";
      lockscreen = true;
    }

    //else if(keyCode == SHIFT){
    //  editFramePos = true;
    //}
    
    else if (keyCode == CONTROL  ||  keyCode == KeyEvent.VK_META) {
      editFrameSize = true;
    }

    //if(editFramePos == true  &&  lockscreen == false){
    //  if     (keyCode == LEFT) { framePosX = framePosX-10; }
    //  else if(keyCode == RIGHT){ framePosX = framePosX+10; }
    //  else if(keyCode == UP)   { framePosY = framePosY-10; }
    //  else if(keyCode == DOWN) { framePosY = framePosY+10; }
    
    } if (editFrameSize) {
      if(keyCode == LEFT) { 
        frameSizeX = frameSizeX-10;
      } else if (keyCode == RIGHT) { 
        frameSizeX = frameSizeX+10;
      } else if (keyCode == UP) { 
        frameSizeY = frameSizeY-10;
      } else if (keyCode == DOWN) { 
        frameSizeY = frameSizeY+10;
      }
      surface.setSize(frameSizeX+cmdWindowWidth, frameSizeY);
    }
  //}
}


void keyReleased() {
  if (key == CODED) {

    //if(keyCode == SHIFT){
    //  editFramePos = false;  }

    if (keyCode == CONTROL  ||  keyCode == KeyEvent.VK_META) {
      editFrameSize = false;
    }
  }
}




void drawQuadLED(int _x, int _y, int _bright) {
  int SIZE = round(8*(presetSize+50)/100);
  if (red(  presetColor) > 0  ||  (multiColor ? red(  multiColorclr) : -1) > 0) { 
    fill(255, 0, 0, _bright*255/100); 
    rect(_x-SIZE-1, _y-SIZE-1, _x-1, _y-1);
  }
  if (green(presetColor) > 0  ||  (multiColor ? green(multiColorclr) : -1) > 0) { 
    fill(0, 255, 0, _bright*255/100); 
    rect(_x+1, _y-SIZE-1, _x+SIZE+1, _y-1);
  }
  if (blue( presetColor) > 0  ||  (multiColor ? blue( multiColorclr) : -1) > 0) { 
    fill(0, 0, 255, _bright*255/100); 
    rect(_x-SIZE-1, _y+1, _x-1, _y+SIZE+1);
  }
  if (red(presetColor) > 0  &&  green(presetColor) > 0  &&  blue(presetColor) > 0) { 
    fill(255, 255, 255, _bright*255/100); 
    rect(_x+1, _y+1, _x+SIZE+1, _y+SIZE+1);
  }
}






































class kreis {    // PingPong-Spotlight-Balls
  float posX;
  float posY;
  float spdX;
  float spdY;

  kreis() {
    posX = random(200, frameSizeX-200);
    posY = random(200, height-200);
    spdX = random(10, 30);
    spdY = random(10, 30);
  }

  void move() {
    int ballSize = int(map(presetSize+1, 0, 100, 300, 40));

    if (posX <= ballSize/2) {                          // Wall bounceback
      posX = ballSize/2;
      spdX = -spdX;
    } else if (posX >= frameSizeX-ballSize/2) {
      posX = frameSizeX-ballSize/2;
      spdX = -spdX;
    }
    if (posY <= ballSize/2) {
      posY = ballSize/2;
      spdY = -spdY;
    } else if (posY >= height-ballSize/2) {
      posY = height-ballSize/2;
      spdY = -spdY;
    }

    posX += map(presetSpeed+1, 0, 100, 0, 1)*spdX;     // Move according to presetSpeed & direction
    posY += map(presetSpeed+1, 0, 100, 0, 1)*spdY;
    ellipse(posX, posY, ballSize, ballSize);
  }
}






class rectbutton {
  color clr;
  int xpos, ypos, xsize, ysize, xmiddle, ymiddle, index;
  String modifier;
  boolean mouseOver = false;

  rectbutton(color _clr, int _xpos, int _ypos, int _xsize, int _ysize, int _index, String _modifier) {
    clr      = _clr;
    xpos     = _xpos;
    ypos     = _ypos;
    xsize    = _xsize;
    ysize    = _ysize;
    xmiddle  = _xpos + _xsize/2;
    ymiddle  = _ypos + _ysize/2;
    index    = _index;
    modifier = _modifier;
  }



  void display() {
    if (modifier == "PRESET") {
      if (presetNumber == index) {
        fill(0); 
        stroke(255); 
        strokeWeight(1);
        rect(xpos+frameSizeX, ypos, xsize, ysize);
        //image(miniImage, xpos+frameSizeX+1, ypos+1, constrain(ysize*(xpos+frameSizeX)/height, 10, 150)-1, ysize-1);
      }
    }

    if (mouseX>(xpos+frameSizeX+10) && mouseX<(xpos+frameSizeX+xsize-10) && mouseY>(ypos+10) && mouseY<(ypos+ysize-10)) {
      if (flag == true  &&  mousePressed) {
        flag = false;
        doStuff();
      }

      if (modifier == "PRESET") {       // Mouseover @ Preset buttons
        stroke(255); 
        strokeWeight(1);
      } else if (modifier == "COLOR") {
        noStroke();
        mouseOver = true;
      }
    } else {      // no Mouseover
      noStroke();
      mouseOver = false;
    }

    if (modifier == "PRESET") {
      noFill();
    } else {
      fill(clr);
    }

    rect(xpos+frameSizeX, ypos, xsize, ysize);
    fill(0); 
    textSize(2*ysize/3);

    if (!multiColor) {
      if (clr == presetColor) {
        text("1", xmiddle+frameSizeX, ymiddle-6);
      }
    } else if (multiColor) {
      if (clr == multiColorclr) {
        text("1", xmiddle+frameSizeX, ymiddle-6);
      } else if (clr == presetColor) {
        text("2", xmiddle+frameSizeX, ymiddle-6);
      }
    }

    if (mouseOver) {
      fill(100);
      text(multiColor ? "2" : "1", xmiddle+frameSizeX, ymiddle-6);
    }
  }



  void doStuff() {
    if (modifier == "PRESET") {
      presetNumber = index;
      v = random(0.1, 1);
      m = 0;

      if (index == 8) {    //mini-dots-discoball
        for (int x=0; x<1000; x++) {
          ranX[x] = int(random(-0.71*frameSizeX, 0.71*frameSizeX));
          ranY[x] = int(random(-0.71*frameSizeX, 0.71*frameSizeX));
        }
      }
    } else if (modifier == "COLOR") {
      if (index==0) {
        //presetColor = clr;
        presetColor = presetColor==clr ? color(255) : clr;
      } else {
        do {  
          presetColor = color(random(0, 254), random(0, 254), random(0, 254));
        } while (brightness(presetColor) < 100);
      }
    }
  }
}






class onoffbutton {
  color clr;
  int xpos, ypos, xsize, ysize, xmiddle, ymiddle, index;
  String modifier;
  boolean buttonState = false;

  onoffbutton(color _clr, int _xpos, int _ypos, int _xsize, int _ysize, int _index, String _modifier) {
    clr    = _clr;
    xpos   = _xpos;
    ypos   = _ypos;
    xsize  = _xsize;
    ysize  = _ysize;
    xmiddle  = _xpos + _xsize/2;
    ymiddle  = _ypos + _ysize/2;
    index  = _index;
    modifier = _modifier;
  }

  void display() {
    if (mouseX>(xpos+frameSizeX+10) && mouseX<(xpos+frameSizeX+xsize-10) && mouseY>(ypos+10) && mouseY<(ypos+ysize-10)) {
      if (flag == true  &&  mousePressed) {
        flag = false;
        buttonState = !buttonState;
        doStuff();
      }

      stroke(0);
    } else {  
      noStroke();
    }

    if (buttonState  &&  modifier != "+"  &&  modifier != "-"  &&  modifier != "Hide (h)"  &&  modifier != "Nudge +"  &&  modifier != "Nudge -") {
      fill(80);
    } else {
      fill(50);
    }
    strokeWeight(10);
    rect(xpos+frameSizeX, ypos, xsize, ysize);
    textSize(ysize/6+10); 
    fill(0);
    if (modifier == "BPM") {  
      text("BPM " + bpm, xmiddle+frameSizeX, ymiddle-4);
    } else {  
      text(modifier, xmiddle+frameSizeX, ymiddle-4);
    }
  }

  void doStuff() {
    if     (modifier == "Multicolor") {  
      multiColor = buttonState; 
      multiColorclr = presetColor;
    } else if (modifier == "Line Move" ) {  
      drawTranslateMode = buttonState; 
      fromWiFi_X = 8; 
      fromWiFi_Y = 8;
    }  //also reset the extra translation by Smartphone
    else if (modifier == "BPM"       ) {  
      bpmSTLmode = buttonState; 
      bpmSTLtime = 0; 
      bpmSwitchCounter = -1;
    } else if (modifier == "Blackout"  ) {  
      presetBrightness = buttonState ? 0 : 100;
      X[2].value = buttonState ? 0 : 100;
    } else if (modifier == "+"         ) {  
      bpm = constrain(bpm+1, 60, 150);
    } else if (modifier == "-"         ) {  
      bpm = constrain(bpm-1, 60, 150);
    } else if (modifier == "Hide (h)"  ) {  
      hideControlWindow = buttonState;
    } else if (modifier == "Nudge +"   ) {  
      bpmSTLtime -= bpmConstant/(20*bpm);
    } else if (modifier == "Nudge -"   ) {  
      bpmSTLtime += bpmConstant/(20*bpm);
    }
  }
}








class slider {
  color bgclr, clr;
  int xpos, ypos, xsize, ysize, xmiddle, ymiddle;
  int value = 50;
  String modifier;

  slider(color _bgclr, color _clr, int _xpos, int _ypos, int _xsize, int _ysize, String _modifier) {
    bgclr  = _bgclr;
    clr    = _clr;
    xpos   = _xpos;
    ypos   = _ypos;
    xsize  = _xsize;
    ysize  = _ysize;
    xmiddle  = _xpos + _xsize/2;
    ymiddle  = _ypos + _ysize/2;
    modifier = _modifier;
  }

  void display() {
    noStroke(); 
    fill(bgclr);
    rect(xpos+frameSizeX, ypos, xsize, ysize);
    fill(clr); 
    textSize(ysize/3.5);
    text(modifier, xpos+frameSizeX+540, ypos+45);

    if (mouseX>xpos+frameSizeX && mouseX<(xpos+frameSizeX+xsize) && mouseY>ypos && mouseY<(ypos+ysize)) {
      fill(clr);
      rect(xpos+frameSizeX, ypos, xsize*constrain(map(mouseX, xpos+frameSizeX, xpos+frameSizeX+xsize, 0, 100), 0, 100)/101, ysize);
      textSize(ysize/3); 
      fill(130);
      text(int(constrain(map(mouseX, xpos+frameSizeX, xpos+frameSizeX+xsize, -5, 105), 0, 100)), xmiddle+frameSizeX, ymiddle-4);
      if (mousePressed  &&  mouseButton == LEFT) {
        flag = false;
        value = int(constrain(map(mouseX, xpos+frameSizeX, xpos+frameSizeX+xsize, -5, 105), 0, 100));
        doStuff();
      }
    } else {  
      fill(clr);
      rect(xpos+frameSizeX, ypos, xsize*value/101, ysize);
      textSize(ysize/3); 
      fill(130);
      text(value, xmiddle+frameSizeX, ymiddle-4);
    }
  }

  void doStuff() {
    if     (modifier == "Speed"      ) {  
      presetSpeed      = value;
    } else if (modifier == "Size"       ) {  
      presetSizeDestination       = value;
    } else if (modifier == "Brightness" ) {  
      presetBrightnessDestination = value;
    } else if (modifier == "Strobing"   ) {  
      presetStrobing   = value;
    } else if (modifier == "Shading"    ) {  
      shadeAmount      = value;
    }
  }
}
