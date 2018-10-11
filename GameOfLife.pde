import toxi.util.*;
import java.awt.FileDialog;
import java.io.File;
import java.util.Map;
import java.util.HashMap;

import java.util.regex.*;
import oscP5.*;
import netP5.*;

import codeanticode.syphon.*;


PGraphics canvas;
//SyphonServer server;

// -=-=-=-=--=-==-=-=-=-=-=-=
// -=-=- OUTPUT DATA -=-=--=-
// -=-=-=-=--=-==-=-=-=-=-=-=
boolean SAVE_OUTPUT = false;
boolean OSC_CONNECT  = true;

// -=-=-=-=--=-==-=-=-

String outputFile;
int outFileCounter = 0;

boolean DEBUG = false;

boolean canSaveFrame = false;


RLEParser parser = new RLEParser();


// -=-=-=-=--=-==-=-=-
OscP5 osc;
int listenPort = 8000;

// -=-=-=-=--=-==-=-=-
LemurController lemurController;
ConfigInterface lemurConfig;
AppModel model;

// -=-=-=-=--=-==-=-=-
String configurationFile = "data/config.xml";
Config config;


// -=-=-=-=--=-==-=-=--=-=-=-=--=-==-=-=--=-=-=-=--=-==-=-=-

// -=-=-=-=--=-==-=-=-
//  CODE
// -=-=-=-=--=-==-=-=-


void initialize() {
  config = new Config(configurationFile);
  lemurConfig = config.getLemurConfig();


  try {
    String[] matrixSize = config.getValue(config.APP_GMATRIXSIZE).split(",");
    model.setRows(Integer.parseInt(matrixSize[0]));  
    model.setCols(Integer.parseInt(matrixSize[1]));

    String[] configSize = config.getValue(config.APP_GSIZE).split(",");
    model.setGridWidth(Integer.parseInt(configSize[0]));
    model.setGridHeight(Integer.parseInt(configSize[1]));

    model.setRenderSpeed(Integer.parseInt(config.getValue( config.APP_RENDERSPEED)));
    //model.setRunSyphon( Boolean.valueOf(config.getValue(config.SYPHON)));
    //model.setSyphonServer( config.getValue( config.SYPHON_SERVER ) );
    model.initializeBitmap();      

    //BITMAP configuration
    drawAsRectangle = config.getValue(config.CELL_SHAPE).equals(config.RECTANGLE_CELL); 

    //LEMUR configuration
    // -- example pattern files configuration
    String patternFilePath = config.getValue(config.APP_RLE_PATH);

    String[] patternFiles = lemurConfig.getValue(config.PATTERN_FILE_NAME).split(",");
    for (int i=0; i < patternFiles.length; ++i) {
      patternFiles[i] = dataPath(patternFilePath) +"/" + patternFiles[i];
    }

    // --- lemur UI widget configuration and setup 
    model.setPatternFiles(patternFiles);
    model.addAddrPattern( config.LEMUR_PATTERN_MENU_ADDR, lemurConfig.getValue(config.LEMUR_PATTERN_MENU_ADDR), "selection" );
    model.addAddrPattern( config.LEMUR_FILE_LOADED_PLAY_BTN, lemurConfig.getValue(config.LEMUR_FILE_LOADED_PLAY_BTN), "x");    
    model.addAddrPattern(config.LEMUR_PLAY_BTN, lemurConfig.getValue(config.LEMUR_PLAY_BTN), "x");
    model.addAddrPattern(config.LEMUR_PAUSE_BTN, lemurConfig.getValue(config.LEMUR_PAUSE_BTN), "x");
    model.addAddrPattern(config.LEMUR_CLEAR_BTN, lemurConfig.getValue(config.LEMUR_CLEAR_BTN), "x");
    //    lemurIPInAddr = lemurConfig.getValue(config.LEMUR_IPADDR);
    //    lemurSendPort = Integer.parseInt(lemurConfig.getValue(config.LEMUR_IN_PORT));    


    // --- pad config
    String[] lemurPadSize = lemurConfig.getValue(config.LEMUR_PADSIZE).split(","); 
    int lemurRows = Integer.parseInt(lemurPadSize[0]);
    int lemurCols = Integer.parseInt(lemurPadSize[1]);   
    String padRootName = lemurConfig.getValue(config.LEMUR_PAD_BTN_NAME);    
    model.setLemurPadButtonRootAddress( padRootName );
    model.initializePad(lemurRows, lemurCols);

    //center the lemurPad grid on the Bitmap

    int insertRow = model.getRows() / 2 - lemurRows / 2; 
    int insertCol = model.getCols() / 2 - lemurCols / 2;    

    model.setLemurInsertIndex(insertRow * model.getBitmap().getCols() + insertCol);

    int offset = model.getBitmap().getCols() - model.getLemurCols() ;
    model.setLemurColOffset(offset );

    lemurController = new LemurController();
  } 
  catch (Exception e) {
    println(e);
    println(e.getStackTrace());
  }
}

void setup() {
  size(1920, 1280, P2D);
  frameRate(30);
  rectMode(CENTER);
  model = new AppModel();


  initialize();
  
  if (model.getRunSyphon() ) {
    //server = new SyphonServer(this, model.getSyphonServer());
    canvas = createGraphics(width, height, P2D);    
    //println(model.getSyphonServer());
  }  

  if (OSC_CONNECT) {
    osc = new OscP5(this, listenPort);
  }
  //  loadFile();
}


void draw() {
  if (model.getRunSyphon()) {
    canvas.beginDraw();
    canvas.background(0);
  } 
  else {
    background(0);
  }

  model.getBitmap().update();
  model.getBitmap().draw();

  if (frameCount % model.getRenderSpeed() == 0 && model.isPlaying() ) {
    calculateLifeValue(model.getBitmap());
    model.getBitmap().setPixels(model.getNextBitmap().getPixels());
  }        

  if (model.getRunSyphon()) {
    canvas.endDraw();
    image(canvas, 0, 0);
    //server.sendImage(canvas);
  }
   
  if(canSaveFrame == true){
    saveFrame("sequence/sequence_grab#####.png");
    
  }
  
} 



void randomBitmap() {
  for (int i=0; i < model.getBitmap().getPixelCount(); ++i ) {
    if (random(1.0) < 0.5 ) {
      model.getBitmap().getPixel(i).setValue(1);
    } 
    else {
      model.getBitmap().getPixel(i).setValue(0);
    }
  }
}


void mousePressed() {
  randomBitmap();
}

void keyPressed() {

  if (key == 's' || key == 'S') {
    println("saving frame = " + frame );
    saveFrame("screengrabs/grab#####.png");
  }
  
  if (key == 'v' || key == 'V') {
    println("start saving frame sequence");
    canSaveFrame = true;
  }
  
  if (key == 'b' || key == 'B') {
    println("stop saving frame sequence");
    canSaveFrame = false;
  }
  
  
  if (key == 'e' || key == 'E') {
    println("exporting bitmap to " + outputFile);
    model.getBitmap().save(outputFile);
  }
  else if ( key == 'o' || key =='O') {
    loadFile();
  }
  else if ( key  == 'p' || key =='P') {
    model.setPlaying( !model.isPlaying() );
  }
}



// -=-=-=-=-= Life ==-
// Rule B3/S23

void calculateLifeValue( Bitmap b ) {
  model.getNextBitmap().clear();
  int cols = b.getCols(); 

  //kernel array
  int[] kernel = {
    -(cols + 1), -cols, -(cols-1), 
    -1, 1, 
    (cols - 1), cols, (cols+1)
    };

    //convolution array
    int[] conv = new int[8];

  for ( int i=1; i < b.getRows()-1; ++i ) {
    for ( int j=1; j < cols-1; ++j ) {

      int neighborhood = 0;
      int index = i * b.getCols() + j;
      if (DEBUG)
        print("::"+i);

      for ( int k = 0; k < conv.length; ++k) {
        conv[k] = b.getPixel( kernel[k] + index ).getValue();
        neighborhood |= conv[k] << (conv.length - 1 - k);
      }    
      int score = scorePixel(neighborhood, b.getPixel(i, j));
      model.getNextBitmap().setPixel(j, i, score);

      if (DEBUG)
        print("    " + Integer.toBinaryString(neighborhood));
    }
  }
}


//Hamming Weight implementation - from stackoverflow -- 
//http://stackoverflow.com/questions/8871204/count-number-of-1s-in-binary-representation

int scorePixel(int neighborhood, BitmapCell bmp) {
  int score = -1;
  int count = 0;
  while ( neighborhood > 0 ) {
    count = count + 1;
    neighborhood = neighborhood & ( neighborhood - 1);
  }

  if ( bmp.getValue() == 1 ) { //alive
    if (count <= 1 || count > 3 ) { //death
      score = 0;
    } 
    else {
      score = 1;
    }
  } 
  else {
    if (count == 3) {
      score = 1;
    } 
    else {
      score  = 0;
    }
  } 
  return score;
}

void loadFile() {
  lemurController.loadFile();
}

//--=-=-=-=-=-=-=-=-=-=
//  OSC
//--=-=-=-=-=-=-=-=-=-=
void oscEvent(OscMessage msg) {
  //  println("### received an osc message with addrpattern "+msg.addrPattern()+" and typetag "+msg.typetag());  
  //println("Lemur controller can handle message: " + lemurController.canHandleMessage(msg));

  boolean handled = lemurController.handleMessage(msg);
  if (!handled) {
    println("** OSC message NOT handled ---> " );    
    msg.print();
  }
}


// -=-=-=-=--=-==-=-=-
//  Interfaces
// -=-=-=-=--=-==-=-=-
interface ConfigInterface {
  public String getValue(String configKey) throws Exception;
}

abstract class AbstractLemurController {
  protected ArrayList<String> myPatterns = new ArrayList<String>();
  protected ArrayList<String> components = new ArrayList<String>();

  abstract boolean handleMessage(OscMessage msg);

  public void registerPattern(String p) {
    myPatterns.add(p);
  }

  public void registerComponent(String c) {
    components.add(c);
  }

  public boolean canHandleMessage(OscMessage msg) {
    boolean ret = false;
    for ( String p : myPatterns ) {
      if (msg.checkAddrPattern(p) == true ) {
        ret = true;
        break;
      }
    }
    return ret;
  }
}

interface LifePattern {
  public int getCols();
  public int getRows();
  public ArrayList<Integer> getPixels();
}

// -=-=-=-=--=-==-=-=-
//  Static variables
// -=-=-=-=--=-==-=-=-
static boolean drawAsRectangle = true;
