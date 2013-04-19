// Meng Shi
// lolaee@gmail.com
// I am teaching Mr. Android how to dance via my iphone.
// It is implemented in processing with the help of TouchOSC.
// The android model is several “stl” files, which I edited them in rhino.
// http://youtu.be/9wrsJe-O9yI


import processing.opengl.*;

// Sligthly adapted Toxiclibs STLImportTest example to WETriangleMesh
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;

import peasy.*;

//libs for communication with cellphone
import oscP5.*;
import netP5.*;
OscP5 oscP5;

float v_body = 0.0f;
float v_head = 0.0f;
float v_leftHand = 0.0f;
float v_rightHand = 0.0f;
float v_leftToggle = 0.0f;
float v_rightToggle = 0.0f;

PeasyCam cam;

WETriangleMesh leftHand;
WETriangleMesh rightHand;
WETriangleMesh body;
WETriangleMesh head;

ToxiclibsSupport gfx;

// motion control variables
float rhRotateRadias;
float lhRotateRadias;
float headRotateRadias;
int d;

// color variables
color g = color(35, 229, 7);  // Define color 'normal'
color r = color(255, 0, 0);  // Define color 'abnormal'
color myColor = color(35, 229, 7);
float n=0;

void setup() {

  size(600, 600, OPENGL);
  // set up communication with TouchOSC
  oscP5 = new OscP5(this, 8000);

  // left hand
  leftHand = new WETriangleMesh();
  leftHand = (WETriangleMesh) new STLReader().loadBinary(sketchPath("data/android_left_hand.stl"), STLReader.WEMESH);
  leftHand.scale(10);

  // right hand
  rightHand = new WETriangleMesh();
  rightHand = (WETriangleMesh) new STLReader().loadBinary(sketchPath("data/android_right_hand.stl"), STLReader.WEMESH);
  rightHand.scale(10);

  // left body
  body = new WETriangleMesh();
  body = (WETriangleMesh) new STLReader().loadBinary(sketchPath("data/android_body.stl"), STLReader.WEMESH);
  body.scale(10);

  //  head
  head = new WETriangleMesh();
  head = (WETriangleMesh) new STLReader().loadBinary(sketchPath("data/android_head.stl"), STLReader.WEMESH);
  head.scale(10);

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  gfx=new ToxiclibsSupport(this);
}

void draw() {
  noStroke();

  background(51);
  // to show the light and axis
  lights();
  gfx.origin(new Vec3D(), 200);

  //leftHand
  pushMatrix();
  noStroke();
  fill(g);
  rotateX(v_leftHand/180*PI);
  gfx.mesh(leftHand, false, 0);
  popMatrix();

  // rightHand
  pushMatrix();
  noStroke();
  fill(g);
  rotateX(v_rightHand/180*PI);
  gfx.mesh(rightHand, false, 0);
  popMatrix();

  // body
  pushMatrix();
  noStroke();
  fill(g);
  rotateY( v_body/180*PI/2);
  gfx.mesh(body, false, 0);
  popMatrix();


  // head
  pushMatrix();  
  fill(myColor);
  rotateY( v_head/180*PI);
  gfx.mesh(head, false, 0);
  popMatrix();

  //
  if(v_rightToggle == 1.0f) {
    myColor = lerpColor(g, r, n);
    n += (1-n)* 0.05;
  }
    if(v_leftToggle == 1.0f) {
    myColor = g;
    n=0;
  }

  // rightHand
}
//communication with OSC
void oscEvent(OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();
  float  val  = theOscMessage.get(0).floatValue();

  if (addr.equals("/body")) { 
    v_body = val;
  }
  else if (addr.equals("/leftHand")) { 
    v_leftHand = val;
  }
  else if (addr.equals("/rightHand")) { 
    v_rightHand = val;
  }
  else if (addr.equals("/head")) { 
    v_head= val;
  }
  else if (addr.equals("/rightToggle")) { 
    v_rightToggle = val;
  }
  else if (addr.equals("/leftToggle")) { 
    v_leftToggle = val;
  }
}

