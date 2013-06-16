public class LemurController extends AbstractLemurController {

  ArrayList<String> messageAddresses;
  ArrayList<AbstractLemurController> controllers;

  //MOVE TO MODEL
  Pattern padButtonRE; 
  Pattern controlButtonRE;


  LemurController() {
    messageAddresses = new ArrayList<String>();
    
    ControlButtonController cbc = new ControlButtonController();
    cbc.registerPattern(model.getAddrPattern(config.LEMUR_PLAY_BTN));
    cbc.registerPattern(model.getAddrPattern(config.LEMUR_PAUSE_BTN));
    cbc.registerPattern(model.getAddrPattern(config.LEMUR_CLEAR_BTN));
    
    println("---->>>"+model.getAddrPattern(config.LEMUR_PLAY_BTN));
    
    controllers = new ArrayList<AbstractLemurController>();
    controllers.add(  new SwitchPadController());
    controllers.add( cbc) ;//new ControlButtonController());
    controllers.add( new MenuController());
  } 


  boolean handleMessage(OscMessage msg) {
    for (AbstractLemurController lc : controllers ) {
      if (lc.canHandleMessage(msg) == true) {
//        println(" Controller is handling the message " + lc.handleMessage(msg));
        return lc.handleMessage(msg);
      }
    }
    return false;
  }



  public void addController(AbstractLemurController ctrl) {
    controllers.add(ctrl);
  }


  private class ControlButtonController extends AbstractLemurController {
    final int PLAY = 1;
    final int PAUSE = 0; 
    


    public boolean handleMessage(OscMessage msg) {
      boolean handled = false;
      String component = model.getComponentFromAddrPattern(msg.addrPattern());
      
      
      if( component.equals(config.LEMUR_PLAY_BTN) ) {
      //if ( msg.checkAddrPattern( model.getLemurPlayBtnAddr()) == true) {
        println("handling play button click");
        handled = handleLemurPlayBtn(msg);
      } 
      else if( component.equals(config.LEMUR_CLEAR_BTN) ) {
       println("handling clear button click"); 
      //if ( msg.checkAddrPattern( model.getLemurClearBtnAddr()) == true) {
        handled = handleLemurClearBtn(msg);
      }
      else if( component.equals(config.LEMUR_PAUSE_BTN) ) {
        println("handling pause button click");        
        //if (msg.checkAddrPattern( model.getLemurPauseBtnAddr()) == true) {
        handled = handleLemurPauseBtn(msg);
      }
//      else if(msg.checkAddrPattern( model.getLemurCloseFileLoadedBtnAddr()) == true ) {
//        handled = handleLemurCloseFileLoadedBtn();
//      }
      return handled;
    }    

    private boolean handleLemurPlayBtn(OscMessage msg) {   
        model.setPlaying(true);     
        model.setBitmapPixels( model.getCurrentLemurPattern() );
        return true;
    }

    private boolean handleLemurPauseBtn(OscMessage msg) {
      model.setPlaying(false);
      return true;
    }
    
    private boolean handleLemurClearBtn(OscMessage msg) {
      model.setPlaying(false);
      model.clearBitmap();
      return true;
    }
  }

  private class SwitchPadController extends AbstractLemurController {

    @Override
    public boolean canHandleMessage(OscMessage msg) {
      //if the message has the LemurBtn in it. It is for me
      boolean isButton = msg.addrPattern().indexOf( model.getLemurPadButtonRootAddress() ) >= 0;
     println("is a button = " + isButton + "  " + msg.addrPattern() + "   " + config.LEMUR_PAD_BTN_NAME); 
      return isButton;
    }
    
    public boolean handleMessage(OscMessage msg) {
      //find the button with the address of this message
      int st = msg.addrPattern().indexOf("/")+1;
      int en = msg.addrPattern().lastIndexOf("/");

      String find = msg.addrPattern().substring(st, en);

      int count = 0;
      for (LemurButton btn : model.getPad()) {
        if (btn.getName().equals(find)) {
          btn.setState( int(msg.get(0).floatValue()));
          model.setPatternPixel(count, btn.getState());
          println("SwitchPadController::handleMessage\n" + model.getCurrentLemurPattern());


          model.setBitmapPixelFromLemur(btn);          
          return true;
        }
        ++count;
      }
      return false;
    }
  }


  private class MenuController extends AbstractLemurController {
    public boolean handleMessage(OscMessage msg) {
      if (msg.checkAddrPattern(model.getLemurMenuAddrPattern()) == true) {

        int selection = int(msg.get(0).floatValue());
        println("GOT here Selection = " + selection );        
        parseFile( model.getPatternFile(selection));
        return true;
      }
      return false;
    }
  }


  public void loadFile() {
    String path = FileUtils.showFileDialog(
    frame, 
    "An RLE file to load...", 
    dataPath("") +"/rle", 
    new String[] { 
      ".rle", ".txt"
    }
    , 
    FileDialog.LOAD
      );   

    //String path = dataPath("") +"/rle/glider.rle";
  
    parseFile(path);
  }

  void parseFile(String path) {
    if (path != null) {
      println("parsing file: " + path );

      int gWidth = model.getGridWidth();
      int gHeight = model.getGridHeight();
      int rows = model.getRows();
      int cols = model.getCols();

      RLEPattern pattern;
      pattern = parser.parse(path);
      Bitmap p = new Bitmap(pattern, gWidth, gHeight, rows, cols, rows/2 - pattern.rows/2, cols/2 - pattern.cols/2);
      println("loaded Pattern:\n" + pattern );    

      model.getBitmap().setPixels(p.getPixels());    
      model.getBitmap().draw();
    }
  }
}

