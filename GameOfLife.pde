import toxi.util.*;
import java.awt.FileDialog;
import java.io.File;
import java.util.regex.*;

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
int rows = 50, cols = 50;
int gWidth = 800, gHeight = 800;
RLECodec encoder = new RLECodec();
RLELoader rleLoader = new RLELoader();
RLEParser parser = new RLEParser();

void setup() {
  size(800, 800);
  rectMode(CENTER);
  outputDirectory = sketchPath("") + "out";
  outputFile = outputDirectory +"/" +fileName;

  bitmap = new Bitmap(width/2 - gWidth/2, height/2 - gHeight/2, gWidth, gHeight, rows, cols);
  loadFile();
}

void draw() {
  background(0);
  bitmap.draw();

  if (frameCount % 30 == 0 ) {
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
  if(key == 's' || key == 'S') {
   println("saving frame = " + frame );
   saveFrame("screengrabs/grab#####.png"); 
  }
  if (key == 'e' || key == 'E') {
    println("exporting bitmap to " + outputFile);
    bitmap.save(outputFile);
  }
  else if ( key == 'o' || key =='O') {
  }
}

private void handleFileLoaded() {
}


// -=-=-=-=-= Output to file -=-=-=-=-==-


// -=-=-=-=-= Output to OSC ==-


// -=-=-=-=-= Life ==-
// Rule B3/S23

ArrayList<Integer> calculateLifeValue( Bitmap b ) {
  int p = 0;
  // add 2 for the extra columns of the border
  int cols = int(b.cols) + 2; 
  ArrayList<Integer> borderPixels = b.getBorderPixelArray();
  ArrayList<Integer> pixels = b.getPixels();
  ArrayList<Integer> next = new ArrayList<Integer>(b.getPixelCount());

  int[] k = {
    -(cols + 1), -cols, -(cols-1), 
    -1, 1, 
    (cols - 1), cols, (cols+1)
    };

    int[] conv = new int[8];

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

  RLEPattern pattern;
  pattern = parser.parse(path);
  Bitmap p = new Bitmap(pattern, gWidth, gHeight, rows, cols, rows/2 - pattern.rows/2, cols/2 - pattern.cols/2);
  bitmap.setPixels(p.getPixels());
  bitmap.draw();
}

