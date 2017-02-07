
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// sample simple processing / processing.js file from Andy Johnson - CS 422 - Spring 2017

// one current issue is dealing with sounds between Processing and Processing.js
// without compiler directives its hard to easily comment in and out the two different versions

// the external sound library (Sketch / Import Library / Sound) will work in processing but not in processing.js
// uncomment these two lines to get audio in Processing
//import processing.sound.*;
//SoundFile beepSound;

// here is a processing.js solution from http://aaron-sherwood.com/processingjs/circleSound.html
// uncomment this line to get audio in Processing.js
Audio beepSound = new Audio();

// also note the soundfile needs to be in the data folder for processing and outside that folder for Processing.js
// sounds are also a bit slowerer to start up in Processing.js

// some buttons
int ydiff = 30;
int[][] buttons = { {50, 100 + ydiff}, {50, 200 + ydiff}, {50, 300 + ydiff} , {200,600 + ydiff}, {300,600 + ydiff}};
int[][] modeButtons = { {320, 400 + ydiff, 200, 200}, 
                        {480, 200 + ydiff, 200, 200}, 
                        {640, 400 + ydiff, 200, 200}, 
                        {800, 200 + ydiff, 200, 200},
                        {960, 400 + ydiff, 200, 200}};
int xdiff = 120;
int ydiffe = 120;
int topLeftx = 700;
int topLefty = 200;
int[][] numberButtons = { {topLeftx, topLefty, 100, 100}, {topLeftx+ xdiff, topLefty, 100, 100}, {topLeftx+ xdiff*2, topLefty, 100, 100}, 
                          {topLeftx, topLefty + ydiffe, 100, 100}, {topLeftx+ xdiff, topLefty + ydiffe, 100, 100}, {topLeftx+ xdiff*2, topLefty + ydiffe, 100, 100},
                          {topLeftx, topLefty + ydiffe*2, 100, 100}, {topLeftx+ xdiff, topLefty + ydiffe*2, 100, 100}, {topLeftx+ xdiff*2, topLefty + ydiffe*2, 100, 100},
                          {topLeftx, topLefty + ydiffe*3, 100, 100}, {topLeftx+ xdiff, topLefty + ydiffe*3, 100, 100}, {topLeftx+ xdiff*2, topLefty + ydiffe*3, 100, 100}};
String[] modeLabels = { "WARM" , "BAKE", "BROIL", "PIZZA" , "TOAST" };
String[] modeIconNames = { "warmIcon.png" , "bakeIcon.png" , "broilIcon.png" , "pizzaIcon.png", "toastIcon.png"};
PImage[] modeIcons = new PImage[modeIconNames.length];

PImage inside;


toasterOvenSetting currentSetting;
CircleButton[] modeCircleButtons = new CircleButton[modeIconNames.length];
CircleButton[] numberPadButtons = new CircleButton[numberButtons.length]; // 0-9, Clear,
CircleButton degree;
CircleButton start;
CircleButton save;
CircleButton stop;

String degreeText = "";
String timerText = "";
String timerTextWithColons = "";

color currentcolor;
int showView = 0;

int startSecond = 0;
int startMinute = 0;
int startHour = 0;
int startTime = 0;
//////////////// not used
// Constants
int mode = -1;
color bg, offWhite, saffron, green, red;

int buttonX = 100;
int buttonY = 75;

// no buttons / mode currently selected
int selectedOne = -1;
PFont f;
/////////////////////////////////////////////////////

void loadSounds(){
  // beep soundfile shortened from http://soundbible.com/2158-Text-Message-Alert-5.html
  //Processing load sound
  //beepSound = new SoundFile(this, "bing.mp3");
  // processing.js load sound
  beepSound.setAttribute("src","bing.mp3");
}

void playBeep() {
  // play audio in processing or processing.js
  beepSound.play();
}

/////////////////////////////////////////////////////

void setup() {
  // set the canvas size
  size(1280, 800);

  // Define colors
  red = color(146, 40, 10);
  green = color(97, 132, 25);
  bg = color(15, 24, 37);
  offWhite =  color(255, 250, 250);
  saffron =  color(249, 191, 59);
  currentSetting = new toasterOvenSetting();
  
  // Load images for the modes
  for (int i=0; i < modeIconNames.length; i++){
    modeIcons[i] = loadImage(modeIconNames[i],"png");
    modeIcons[i].loadPixels();
    
    // Create Mode Buttons
    int x = modeButtons[i][0];
    int y = modeButtons[i][1];
    
    fill(bg);
    stroke(offWhite); 
    modeCircleButtons[i]  = new CircleButton(x , y, modeButtons[i][2], bg, offWhite);
    modeCircleButtons[i].name = modeLabels[i] ;
  }
  
  // Create Number Pad
  for (int i=0; i < numberPadButtons.length; i++){
    int x = numberButtons[i][0];
    int y = numberButtons[i][1];
    
    fill(bg);
    stroke(offWhite); 
    numberPadButtons[i]  = new CircleButton(x , y , numberButtons[i][2], bg, offWhite);
    if( i == 11 ) {
      numberPadButtons[i].name = "X";
      numberPadButtons[i].basecolor = red;
    }
    else if( i == 10 ) numberPadButtons[i].name = "" + 0;
    else if(i == 9 ) {
      numberPadButtons[i].name = "enter";
      numberPadButtons[i].basecolor = green;
    }
    else numberPadButtons[i].name = "" + (i + 1);
  }

  degree = new CircleButton(550, 325, 50, bg, offWhite);
  degree.name = "ºF";  
  
  start = new CircleButton(1180, 532, 100, green, green);
  start.name = "Start";
  save = new CircleButton(1180, 665, 100, offWhite, saffron);
  save.name = "Save to Quick Cook"; 
  
  
  stop = new CircleButton(1280/2, 800/2, 100, offWhite, red);
  stop.name = "stop"; 
  
  inside = loadImage("inside2.png","png");
  inside.loadPixels();
  //for the labels
  f = createFont("Arial",64,true);
  loadSounds();
}

/////////////////////////////////////////////////////
// Run in a loop

void draw() {
  background(bg);
  strokeWeight( 5 );
  displayCurrent();
  
    switch( showView ){
      case 0 : 
          textFont(f);
          textSize(60);
          fill(offWhite);
          textAlign(LEFT);
          text("Choose Mode", 40, 70); // Create space for the icons
          // show Mode Buttons with their labels and images
          for (int i=0; i < buttons.length; i++){
            int x = modeButtons[i][0];
            int y = modeButtons[i][1];
            
            modeCircleButtons[i].display();
            
            // Labeling the Mode Buttons  
            textFont(f);
            textSize(36);
            fill(offWhite);
            textAlign(CENTER);
            text(modeLabels[i], x , y + 75); // Create space for the icons
            
            imageMode(CENTER);
            modeCircleButtons[i].icon = modeIcons[i];
            modeIcons[i].resize(100, 100);
            image(modeIcons[i], x , y - 20);
          }
        break;
      case 1 : // showing Settings
         
        switch( currentSetting.mode){
          case "BAKE": 
            textFont(f);
            textSize(60);
            fill(offWhite);
            textAlign(LEFT);
            text("Choose Temperature", 40, 70); 
            
            displayNumberPad();
            
            // Write text box
            fill(bg);
            stroke(offWhite);
            rectMode(CENTER);
            rect(400, 325, 200, 55, 7);
            textFont(f);
            
            // Selected degree
            textSize(36);
            fill(offWhite);
            textAlign(LEFT);
            text(degreeText,325,335);
            
            // Degree F/C
            degree.display();
            textFont(f);
            textSize(30);
            fill(offWhite);
            textAlign(LEFT);
            text(degree.name, 535, 335); 

            break;
          case "BROIL":
            // Labeling the Mode Buttons  
            textFont(f);
            textSize(36);
            fill(offWhite);
            textAlign(CENTER);
            text("Display the settings for broil", 600 ,600); // Create space for the icons
            break;
        }
        break;
      case 2 : // showing Timer
        textFont(f);
        textSize(60);
        fill(offWhite);
        textAlign(LEFT);
        text("Set Time", 40, 70); 
        
        displayNumberPad();
    
        // Write text box
        fill(bg);
        stroke(offWhite);
        rectMode(CENTER);
        rect(400, 325, 200, 55, 7);
        textFont(f);
        
        
        textSize(36);
        fill(offWhite);
        textAlign(RIGHT);
        text("   :    :    ",480,335);
        text(timerTextWithColons,480,335);
        break;
      case 3: // show confirmation view with save option
         // show inside
        imageMode(CORNER);
        inside.resize(1100, 800);
        image(inside, 0 , 0);
      
       // start button
        if( millis()/500 % 2 == 0)
          start.highlightcolor = saffron;
        else
          start.highlightcolor = green;
        start.display();
        
        textSize(textSize);
        fill(225);
        textAlign(CENTER);
        text("START",1180,532 + 20);
        
        // Save Button
        save.display();
        
        fill(saffron);
        text("SAVE",1180,665+20);        break;
     case 4: // user pressed start, begin countdown
        //currentSetting.seconds = currentSetting.seconds - abs((second() - startSecond));
        //int changeInMinutes = (minute() - startMinute);
        //int changeInHours = (hour() - startHour);
        
        // show inside
        imageMode(CORNER);
        inside.resize(1100, 800);
        image(inside, 0 , 0);
        
        int t = startTime + currentSetting.seconds*1000 + currentSetting.minutes*60000 + currentSetting.hours*3600000 - millis();
                
        int seconds = floor( (t/1000) % 60 );
        int minutes = floor( (t/1000/60) % 60 );
        int hours = floor( (t/(1000*60*60)) % 24 );
        
        if( seconds + minutes + hours  <= 0){
          showView = 5;
          
        }
        // Rectangle
        stroke(offWhite);
        fill(bg);
        rectMode(CENTER);
        rect(640, 532+ 10, 690, 60, 10, 10, 10, 10);
        
        textSize(30);
        fill(225);
        textAlign(CENTER);
        text(" " + seconds + "s" ,960,532 + 20);
        
        textSize(30);
        fill(225);
        textAlign(CENTER);
        text(" " + minutes + "m",640,532 + 20);
        
        textSize(30);
        fill(225);
        textAlign(CENTER);
        text(" " + hours + "h" ,320,532 + 20);
        
        
        break;
     case 5:
         if( millis()/500 % 2 == 0){
            playBeep();
            stop.highlightcolor = saffron;
         }else{
            stop.highlightcolor = offWhite;
         }
         
         stop.display();
        
  }  
}

void displayNumberPad(){
     // show number pad for temperatrue setting
    for (int i=0; i < numberPadButtons.length; i++){ 
      numberPadButtons[i].display();
        // Labeling the Mode Buttons  
      textFont(f);
      textSize(36);
      fill(offWhite);
      textAlign(CENTER);
      text(numberPadButtons[i].name, numberPadButtons[i].x ,numberPadButtons[i].y + 10); // Create space for the icons
    }
}

int xd = 0;
int xy = 0;

CircleButton selectedMode = new CircleButton(1180, 133 ,100, bg, saffron);
CircleButton selectedSetting = new CircleButton(1180, 266 ,100, saffron, offWhite);
CircleButton selectedTime = new CircleButton(1180, 399, 100, saffron, offWhite);

String[] selected = new String[3];
int textSize = 20;
void displayCurrent(){

  
  // Display current Settings that have been picked
  if( !(currentSetting.mode == null)){
    selectedMode.basecolor  = saffron;
    selectedMode.highlightcolor = offWhite;
    selectedMode.icon = currentSetting.icon;
    selectedMode.display();

    textFont(f);
    textSize(textSize);
    fill(offWhite);
    textAlign(CENTER);
    selected[0] = "" + currentSetting.mode;
    text( selected[0],selectedMode.x, selectedMode.y + 20); // Create space for the icons 
  }
  
  if( !(currentSetting.setting == null)){
    selectedSetting.basecolor  = saffron;
    selectedSetting.highlightcolor = offWhite;
    selectedSetting.icon = currentSetting.icon;
    selectedSetting.display();

    textFont(f);
    textSize(textSize);
    fill(offWhite);
    textAlign(CENTER);
    selected[1] = "" + currentSetting.setting;
    text( selected[1],selectedSetting.x, selectedSetting.y + 20); // Create space for the icons 
  }
  
  if( !((currentSetting.seconds + currentSetting.minutes + currentSetting.hours )== 0)){
    selectedTime.basecolor  = saffron;
    selectedTime.highlightcolor = offWhite;
    selectedTime.icon = currentSetting.icon;
    selectedTime.display();

    textFont(f);
    textSize(textSize);
    fill(offWhite);
    textAlign(CENTER);
    selected[2] = "" + currentSetting.hours + "hs" + currentSetting.minutes + "m" + currentSetting.seconds + "s";
    text( selected[2],selectedTime.x, selectedTime.y + 20); // Create space for the icons 
  }
}

/////////////////////////////////////////////////////

// if the mouse button is released inside a known button keep track of which button was pressed
// and play a confirmation sound

void mouseReleased() {
  switch( showView ){
    case 0 : // showing Modes
      //check if back button was pressed
      if( selectedSetting.overCircle(selectedSetting.x, selectedSetting.y, 50)){
        showView = 1; // show mode
      }
      
      // check if any of the mode buttons were clicked
      for( CircleButton b : modeCircleButtons){
        if( b.overCircle(b.x, b.y, 100) ==  true){ // changed radius to 100 for some reason
            currentSetting.mode = b.name;
            currentSetting.icon = b.icon;
            showView = 1; // show Settings next
            break;
        } 
      }
      break;
    case 1 : // showing Settings
      //check if back button was pressed
      if( selectedMode.overCircle(selectedMode.x, selectedMode.y, 50)){
        showView = 0; // show mode
      }
      
            //check if back button was pressed
      if( selectedSetting.overCircle(selectedSetting.x, selectedSetting.y, 50)){
        showView = 1; // show mode
      }
      
      if( degree.overCircle(degree.x, degree.y, 20)){
        if(degree.name == "ºC")
          degree.name = "ºF";//change degree setting
        else
           degree.name = "ºC";
      }
      
      for( CircleButton b : numberPadButtons){
        if( b.overCircle(b.x, b.y, 50) ==  true){ // changed radius to 100 for some reason
          if(degreeText.equals("0"))
            degreeText = "";
            
          if(b.name == "X"){
            int temp = parseInt(degreeText );
            int newTemp = temp/10;
            degreeText = ""+ newTemp;
          }else if( b.name == "enter"){
            currentSetting.setting = degreeText + " " + degree.name;
            showView = 2;
          }else{
            degreeText = degreeText+b.name;
            break;
          }
        } 
      }
      // Each setting is different for each mode
      break;
    case 2 : // showing Timer
      //check if back button was pressed
      if( selectedMode.overCircle(selectedMode.x, selectedMode.y, 50)){
        showView = 0; // show mode
      }
      //check if back button was pressed
      if( selectedSetting.overCircle(selectedSetting.x, selectedSetting.y, 50)){
        showView = 1; // show mode
      }
      
      for( CircleButton b : numberPadButtons){
        if( b.overCircle(b.x, b.y, 50) ==  true){ // changed radius to 100 for some reason
          if(timerText.equals("0"))
            timerText = "";
            
          if(b.name == "X"){
            int time = parseInt(timerText );
            int newTime = time/10;
            timerText = ""+ newTime;
          }else if( b.name == "enter"){
            int time = parseInt(timerText );
            println("parsedtime: " + time);
            currentSetting.seconds = time%100;
            currentSetting.minutes = time/100%100;
            currentSetting.hours = time/10000%100;
            println("your time is now hours: " + currentSetting.hours + " Mintues: " + currentSetting.minutes + " seconds:" + currentSetting.seconds);
            showView = 3; // change to 3
          }else{
            timerText = timerText+b.name;
            break;
          }
        } 
      }
      
      timerTextWithColons = "";
      for( int i = 0; i < timerText.length();i++){
        if( i ==  timerText.length() - 2 || i ==  timerText.length() - 4){
          timerTextWithColons = timerTextWithColons + " ";
        }
        timerTextWithColons = timerTextWithColons + timerText.charAt(i);
      }
      break;
    case 3: // check if user picked any of the buttons
      //check if back button was pressed
      if( selectedMode.overCircle(selectedMode.x, selectedMode.y, 50)){
        showView = 0; // show mode
      }
      //check if Setting button was pressed
      if( selectedSetting.overCircle(selectedSetting.x, selectedSetting.y, 50)){
        showView = 1; // show mode
      }
      //check if Time button was pressed
      if( selectedTime.overCircle(selectedTime.x, selectedTime.y, 50)){
        showView = 2; // show mode
      }
      
      //check if start button was pressed
      if( start.overCircle(start.x, start.y, 50)){
        startTime = millis();
        startSecond = second();
        startMinute = minute();
        startHour = hour();
        
        showView = 4; // show mode
      }
      //check if save button was pressed
      if( save.overCircle(save.x, save.y, 50)){
        showView = 6; // show mode
      }
      break;
    case 4:
      break;
    case 5:
      if( stop.overCircle(stop.x, stop.y, 50)){
        showView = 0; // show mode
        setup();
      }
  }
 
}
