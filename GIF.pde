// Based off of a template written by Golan Levin. 
// Modified by Sebastian Carpenter

// This is a template for creating a looping animation in Processing/Java. 
// When you press the 'F' key, this program will export a series of images
// into a "frames" directory located in its sketch folder. 
// These can then be combined into an animated gif. 
// Known to work with Processing 3.4
// Prof. Golan Levin, January 2018
 
//===================================================
// Global variables. 
String  myNickname = "Spoon"; 
int     nFramesInLoop = 180;
int     nElapsedFrames;
boolean bRecording; 

//===================================================
void setup() {
  size (640, 640); 
  bRecording = false;
  nElapsedFrames = 0;
}

//===================================================
void keyPressed() {
  if ((key == 'f') || (key == 'F')) {
    bRecording = true;
    nElapsedFrames = 0;
  }
}
 
//===================================================
void draw() {
 
  // Compute a percentage (0...1) representing where we are in the loop.
  float percentCompleteFraction = 0; 
  if (bRecording) {
    percentCompleteFraction = (float) nElapsedFrames / (float)nFramesInLoop;
  } else {
    percentCompleteFraction = (float) (frameCount % nFramesInLoop) / (float)nFramesInLoop;
  }
 
  // Render the design, based on that percentage. 
  renderMyDesign (percentCompleteFraction);
 
  // If we're recording the output, save the frame to a file. 
  if (bRecording) {
    saveFrame("frames/" + myNickname + "_frame_" + nf(nElapsedFrames, 4) + ".png");
    nElapsedFrames++; 
    if (nElapsedFrames >= nFramesInLoop) {
      bRecording = false;
    }
  }
}


//===================================================
void renderMyDesign (float percent) {
  //
  // YOUR ART GOES HERE.
  // This is an example of a function that renders a temporally looping design. 
  // It takes a "percent", between 0 and 1, indicating where we are in the loop. 
  // This example uses two different graphical techniques. 
  // Use or delete whatever you prefer from this example. 
  // Remember to SKETCH FIRST!
 
  //----------------------
  // here, I set the background and some other graphical properties
  background (0, 0, 0);
  noStroke();
  fill (75, 75, 75);
  rect (0, height / 4 - 15, width, 2 * height / 4);
  smooth(); 
  noStroke(); 
 
  //----------------------
  // Here, I assign some handy variables. 
  float cx = 100;
  float cy = 100;
 
 //----------------------
  int quantity = 8;
  float reducedPercent = map(percent < 0.75 ? 0 : percent - 0.75, 0, 0.25, 0, 1);
  float invertedPercent = percent <= .5 ? percent + 0.5 : percent - 0.5;
  float invertedReducedPercent = map(invertedPercent < 0.75 ? 0 : invertedPercent - 0.75, 0, 0.25, 0, 1);
  float multiplier1 = function_DoubleEllipticSigmoid(reducedPercent, 0.8, 0.4);
  float invertedMultiplier1 = function_DoubleEllipticSigmoid(invertedReducedPercent, 0.8, 0.4);
  float multiplier2 = function_AdjustableCenterCosineWindow(percent, 0.8);
  float invertedMultiplier2 = function_AdjustableCenterCosineWindow(invertedPercent, 0.8);
  float positionMultiplier = map(function_DoubleOddPolynomialOgee (percent > 0.15 ? percent - 0.15 : percent + 0.85, 0.5, 0.5, 6),
        0, 1, 0, 0.25);
  for(int i = -quantity; i <= quantity; i++) {
    if(i % 2 == 0) {
      fill(map(percent, 0, 1, 255, 150), map(percent, 0, 1, 198, 0), map(percent, 0, 1, 0, 35));
      ellipse(i * width / quantity + map(positionMultiplier, 0, 1, width, 0), map(multiplier1, 0, 1, 30, -height / 2 + 30), 50, 50);
      fill(map(percent, 0, 1, 150, 255), map(percent, 0, 1, 0, 198), map(percent, 0, 1, 35, 0));
      ellipse(i * width / quantity + map(positionMultiplier, 0, 1, width, 0), map(multiplier1, 0, 1, height / 2 + 30, 30), 50, 50);
      fill(map(percent, 0, 1, 255, 150), map(percent, 0, 1, 198, 0), map(percent, 0, 1, 0, 35));
      ellipse(i * width / quantity + map(positionMultiplier, 0, 1, width, 0), map(multiplier1, 0, 1, height + 30, height / 2 + 30), 50, 50);
    } else {
      fill(map(invertedPercent, 0, 1, 255, 150), map(invertedPercent, 0, 1, 198, 0), map(invertedPercent, 0, 1, 0, 35));
      ellipse(i * width / quantity + map(positionMultiplier, 0, 1, width, 0), map(invertedMultiplier1, 0, 1, 30, -height / 2 + 30), 50, 50);
      fill(map(invertedPercent, 0, 1, 150, 255), map(invertedPercent, 0, 1, 0, 198), map(invertedPercent, 0, 1, 35, 0));
      ellipse(i * width / quantity + map(positionMultiplier, 0, 1, width, 0), map(invertedMultiplier1, 0, 1, height / 2 + 30, 30), 50, 50);
      fill(map(invertedPercent, 0, 1, 255, 150), map(invertedPercent, 0, 1, 198, 0), map(invertedPercent, 0, 1, 0, 35));
      ellipse(i * width / quantity + map(positionMultiplier, 0, 1, width, 0), map(invertedMultiplier1, 0, 1, height + 30, height / 2 + 30), 50, 50);
    }
  }
   
  //----------------------
  for(int i = -quantity; i <= quantity; i++) {
    if(i % 2 == 0) {
      fill(map(multiplier2, 0, 1, 150, 255));
      drawCenteredRectangleFromBottom(i * width / quantity + map(positionMultiplier, 0, 1, 0, width), height, 
                                    map(multiplier2, 0, 1, 75, 50), 100 - map(multiplier2, 0, 1, 50, 0));
      drawCenteredRectangleFromBottom(i * width / quantity + map(positionMultiplier, 0, 1, 0, width), height / 2, 
                                    map(multiplier2, 0, 1, 50, 75), 100 - map(multiplier2, 0, 1, 0, 50));
    } else {
      fill(map(invertedMultiplier2, 0, 1, 150, 255));
      drawCenteredRectangleFromBottom(i * width / quantity + map(positionMultiplier, 0, 1, 0, width), height, 
                                    map(invertedMultiplier2, 0, 1, 75, 50), 100 - map(invertedMultiplier2, 0, 1, 50, 0));
      drawCenteredRectangleFromBottom(i * width / quantity + map(positionMultiplier, 0, 1, 0, width), height / 2, 
                                    map(invertedMultiplier2, 0, 1, 50, 75), 100 - map(invertedMultiplier2, 0, 1, 0, 50));
    }
  }
}
 
//===================================================
// Functions I wrote that are called in renderMyFunction

void drawCenteredRectangleFromBottom(float x, float y, float width, float height) {
  float upperLeftX = x - (width / 2);
  float upperLeftY = y - height;
  rect(upperLeftX, upperLeftY, width, height);
}
 
//===================================================
// Mathematical functions called in renderMyDesign
// Taken from https://github.com/golanlevin/Pattern_Master

float function_AdjustableCenterCosineWindow (float x, float a) {
  // functionName = "Adjustable Center Cosine Window";
  
  float ah = a/2.0; 
  float omah = 1.0 - ah;

  float y = 1.0;
  if (x <= a) {
    y = 0.5 * (1.0 + cos(PI* ((x/a) - 1.0)));
  } 
  else {
    y = 0.5 * (1.0 + cos(PI* (((x-a)/(1.0-a))  )));
  } 
  return y;
}

float function_DoubleEllipticSigmoid (float x, float a, float b){
  // functionName = "Double-Elliptic Sigmoid";

  float y = 0;
  if (x<=a){
    if (a <= 0){
      y = 0;
    } else {
      y = b * (1.0 - (sqrt(sq(a) - sq(x))/a));
    }
  } 
  else {
    if (a >= 1){
      y = 1.0;
    } else {
      y = b + ((1.0-b)/(1.0-a))*sqrt(sq(1.0-a) - sq(x-1.0));
    }
  }
  return y;
}

float function_DoubleOddPolynomialOgee (float x, float a, float b, int n) {
  //functionName = "Double Odd-Polynomial Ogee";

  float min_param_a = 0.0 + EPSILON;
  float max_param_a = 1.0 - EPSILON;
  float min_param_b = 0.0;
  float max_param_b = 1.0;

  a = constrain(a, min_param_a, max_param_a); 
  b = constrain(b, min_param_b, max_param_b); 
  int p = 2*n + 1;
  float y = 0;
  if (x <= a) {
    y = b - b*pow(1-x/a, p);
  } 
  else {
    y = b + (1-b)*pow((x-a)/(1-a), p);
  }
  return y;
}
