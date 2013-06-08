import toxi.util.*;
import java.awt.FileDialog;
import java.io.File;
import java.util.regex.*;
import oscP5.*;
import netP5.*;

// -=-=-=-=--=-==-=-=-=-=-=-=
// -=-=- OUTPUT DATA -=-=--=-
// -=-=-=-=--=-==-=-=-=-=-=-=
boolean SAVE_OUTPUT = false;

//data file
String outputDirectory = "out";
String filePattern ="(.*)###(.*)";
String fileName = "outputImage_";
String fileExtension = ".png";
// -=-=-=-=--=-==-=-=-

String outputFile;
int outFileCounter = 0;

boolean DEBUG = false;

// -=-=-=-=--=-==-=-=-

Bitmap bitmap, fileInput;
int rows = 60, cols = 60;
int gWidth = 1024, gHeight = 1024;
RLEParser parser = new RLEParser();

boolean paused = false;

// -=-=-=-=--=-==-=-=-
OscP5 osc;
int listenPort = 8000;

// -=-=-=-=--=-==-=-=-
LemurController lemur;
int lemurSize = 9;  //number of rows = number of cols
Pattern padButtonRE = Pattern.compile("\\/CustomButton(\\d+)\\/x");
Pattern controlButtonRE = Pattern.compile("\\/Control\\/play");


// -=-=-=-=--=-==-=-=--=-=-=-=--=-==-=-=--=-=-=-=--=-==-=-=-

// -=-=-=-=--=-==-=-=-
//  CODE
// -=-=-=-=--=-==-=-=-

void setup() {
  size(1024, 1024);
  rectMode(CENTER);
  outputDirectory = sketchPath("") + "out";
  outputFile = outputDirectory +"/" +fileName;
  
  osc = new OscP5(this,listenPort);
  lemur = new LemurController(lemurSize);
  
  bitmap = new Bitmap(width/2 - gWidth/2, height/2 - gHeight/2, gWidth, gHeight, rows, cols);
  loadFile();
}

void draw() {
  background(0);
  bitmap.draw();

  if (frameCount % 10 == 0 && !paused ) {
    bitmap.setPixels(calculateLifeValue(bitmap));    

    if (SAVE_OUTPUT) {
      String f = String.format(outputFile + "%05d" + fileExtension, outFileCounter);
      saveFrame(f);
      ++outFileCounter;
      println("saving bitmap to " + f);
    }
  }
}

void saveData() {
  //to save to a new file each write

  String f = dataPath("") + "\\"+
    outputFile.replaceAll(filePattern, "$1" + String.format("%03d", outFileCounter) + "$2");
  bitmap.save(f);
  ++outFileCounter;
}


void randomBitmap() {
  ArrayList<Integer> a = new ArrayList<Integer>();
  for (int i=0; i < bitmap.getPixelCount(); ++i ) {
    if (random(1.0) < 0.5 ) {
      a.add(1);
    } 
    else {
      a.add(0);
    }
  }  
  bitmap.setPixels(a);
}


void mousePressed() {
  randomBitmap();
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    println("saving frame = " + frame );
    saveFrame("screengrabs/grab#####.png");
  }
  if (key == 'e' || key == 'E') {
    println("exporting bitmap to " + outputFile);
    bitmap.save(outputFile);
  }
  else if ( key == 'o' || key =='O') {
    loadFile();
  }
  else if ( key  == 'p' || key =='P') {
    paused = !paused;
  }
}



// -=-=-=-=-= Life ==-
// Rule B3/S23

ArrayList<Integer> calculateLifeValue( Bitmap b ) {
  int p = 0;
  // add 2 for the extra columns of the border
  int cols = int(b.cols) + 2; 
  ArrayList<Integer> borderPixels = b.getBorderPixelArray();
  ArrayList<Integer> pixels = b.getPixels();
  ArrayList<Integer> next = new ArrayList<Integer>(b.getPixelCount());

  //kernel array
  int[] k = {
    -(cols + 1), -cols, -(cols-1), 
    -1, 1, 
    (cols - 1), cols, (cols+1)
    };

    //convolution array
    int[] conv = new int[8];
  //use the border pixels array to run algorithm
  //this accounts for the pixels on the edge of the image
  for ( int i=0; i < b.getPixelCount(); ++i ) {
    int offset = b.getBorderedOffset( i );

    int neighborhood = 0;

    if (DEBUG)
      print("::"+i);

    for ( int j = 0; j < conv.length; ++j) {
      conv[j] = borderPixels.get(k[j] + offset);
      neighborhood |= conv[j] << (conv.length - 1 - j);
    }    

    if (DEBUG)
      print("    " + Integer.toBinaryString(neighborhood));

    //Hamming Weight implementation - from stackoverflow -- 
    //http://stackoverflow.com/questions/8871204/count-number-of-1s-in-binary-representation
    int count = 0;
    while ( neighborhood > 0 ) {
      count = count + 1;
      neighborhood = neighborhood & ( neighborhood - 1);
    }
    String result = "";
    if ( pixels.get(i) == 1 ) { //alive
      if (count <= 1 || count > 3 ) { //death
        result = "death";
        next.add(0);
      } 
      else {
        result = "survive";
        next.add(1);
      }
    } 
    else {
      if (count == 3) {
        result = "born";
        next.add(1);
      } 
      else {
        next.add(0);
      }
    }
    if (DEBUG) {
      print(" count = " + count); 
      println("   result = " + result);
    }
  }
  return next;
}



void loadFile() {
  String path = FileUtils.showFileDialog(
  frame, 
  "An RLE file to load...", 
  dataPath(""), 
  new String[] { 
    ".rle", ".txt"
  }
  , 
  FileDialog.LOAD
    );   

  if (path != null) {
    RLEPattern pattern;
    pattern = parser.parse(path);
    Bitmap p = new Bitmap(pattern, gWidth, gHeight, rows, cols, rows/2 - pattern.rows/2, cols/2 - pattern.cols/2);
    bitmap.setPixels(p.getPixels());
    bitmap.draw();
  }
}


//--=-=-=-=-=-=-=-=-=-=
//  OSC
//--=-=-=-=-=-=-=-=-=-=
void oscEvent(OscMessage msg) {
  /* get and print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message with addrpattern "+msg.addrPattern()+" and typetag "+msg.typetag());
//  lemur.handleMessage(theOscMessage);

    String addr = msg.addrPattern();
    Matcher m = padButtonRE.matcher(addr);
      
    if (m.matches()) {
      lemur.setPadState(Integer.parseInt(m.group(1)), int(msg.get(0).floatValue()));
    }
    m = controlButtonRE.matcher(addr);
    if(m.matches() ) {
      if(msg.get(0).floatValue() == 1 ) {
        println("PLAY");
        lemur.setPattern();
      } else {
        println("STOP");
      }
    }

  
  msg.print();
}
