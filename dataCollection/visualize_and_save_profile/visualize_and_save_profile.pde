import processing.serial.*;

PImage bg;
PFont font;


int lf = 10;    // Linefeed in ASCII
int value;
String myString = null;
Serial myPort;  // The serial port
String s = "";

StringList[] inventory = new StringList[4];
String[] aspirations = new String[4];
String a = " ";
String b = " ";
String c = " ";
String n = " ";
int counter = 0;
String[] A_in;
String[] I_in;
void setup() {
  size(1024, 768);
  //font = loadFont("cBook.vlw");
  //textFont(font, 52);
  bg = loadImage("bg2-02.jpg");
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Keyspan adaptor, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[1], 9600);
  myPort.clear();
  // Throw out the first reading, in case we started reading 
  // in the middle of a string from the sender.
  myString = myPort.readStringUntil(lf);
  myString = null;

  A_in = loadStrings("data/aspirations.txt");
  I_in = loadStrings("data/interests.txt");
  for (int i = 0; i < inventory.length; i++) {
    inventory[i] = new StringList();
    aspirations[i] = "";
    println(inventory[i]);
  }

textSize(12);

  fill(0);
}

void draw() {
  background(255);
  image(bg, 0, 0);

  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      myString = trim(myString);
      //value = int(myString);
      //println(myString);
      String[] list = split(myString, ',');
      if (list[0].equals("I") == true) {
        println(list[1]);
        //s = "hi there";
        inventory[counter].append(I_in[int(list[1])]);
      } else if (list[0].equals("A") == true) {
        println(list[1]);
        //s = "hello there"; 
        aspirations[counter]= A_in[int(list[1])];
      } else if (list[0].equals("C") == true) {
        //println("VICTORY");
        counter++;
        if (counter > 3) {
          counter = 0;
        }
      } else if (list[0].equals("S") == true) {
        saveProfile("data/data.txt");
      } else if (list[0].equals("N") == true) {
        n = "Goran Sabah                                             +49 1152279234";
      }
    }
  }

  text(n, 40, 20);


  for (int j = 0; j < inventory.length; j++) {
    text(aspirations[j], 40, 130 + (j*143));
    for (int i = 0; i < inventory[j].size(); i++) {
      if (inventory[j].size() > 0) {
        text(inventory[j].get(i), 40 + (i*245), 185 + (j*143));
      }
    }
  }
}

void keyPressed() {

  //if (key == 'i') {

  //  inventory[counter].append(I_in[int(random(14))]);
  //  for (int i = 0; i<inventory.length; i++) {
  //    println(inventory[i]);
  //  }
  //}

  //if (key == 'a') {

  //  aspirations[counter]= A_in[int(random(5))];
  //}


  //if (key == 'c') {
  //  counter++;
  //  if (counter > 3) {
  //    counter = 0;
  //  }
  //}

  if (key == 's') saveProfile("data/data.txt");
}

void saveProfile(String fileName) {
  String out = "";
  out += n;
  out += "\n";
  for (int j=0; j<inventory.length; j++) {
    out += aspirations[j] + " | ";
    for (int i = 0; i < inventory[j].size(); i++) {
      out += inventory[j].get(i) + ",";
    }
    out += "\n";
  }
  saveStrings(fileName, out.trim().split("\n"));  
  println("saved " + inventory.length + " rows...");
}