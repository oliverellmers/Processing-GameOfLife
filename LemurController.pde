public class LemurController extends AbstractLemurController {

  ArrayList<String> messageAddresses;
  ArrayList<AbstractLemurController> controllers;

  //MOVE TO MODEL
  Pattern padButtonRE; 
  Pattern controlButtonRE;


  LemurController() {
    messageAddresses = new ArrayList<String>();
    controllers = new ArrayList<AbstractLemurController>();
    
    ControlButtonController cbc = new ControlButtonController();
    cbc.registerPattern(model.getAddrPattern(config.LEMUR_PLAY_BTN));
    cbc.registerPattern(model.getAddrPattern(config.LEMUR_PAUSE_BTN));
    cbc.registerPattern(model.getAddrPattern(config.LEMUR_CLEAR_BTN));
    cbc.registerPattern(model.getAddrPattern(config.LEMUR_FILE_LOADED_PLAY_BTN));
    controllers.add( cbc);
    
    MenuController mc = new MenuController();    
    mc.registerPattern( model.getAddrPattern(config.LEMUR_PATTERN_MENU_ADDR));
    
    controllers.add( mc ); //new MenuController());

    
    controllers.add(  new SwitchPadController());
    
    
  } 


  boolean handleMessage(OscMessage msg) {
    for (AbstractLemurController lc : controllers ) {
      if (lc.canHandleMessage(msg) == true) {
        println(" Controller is handling the message " + lc.handleMessage(msg));
        return lc.handleMessage(msg);
      }
    }
    return false;
  }



  public void addController(AbstractLemurController ctrl) {
    controllers.add(ctrl);
  }

  private class ControlButtonController extends AbstractLemurController {
    public boolean handleMessage(OscMessage msg) {
      boolean handled = false;
      String component = model.getComponentFromAddrPattern(msg.addrPattern());


      if ( component.equals(config.LEMUR_PLAY_BTN) ) {
        handled = handleLemurPlayBtn(msg);
      } 
      else if ( component.equals(config.LEMUR_CLEAR_BTN) ) {
        handled = handleLemurClearBtn(msg);
      }
      else if ( component.equals(config.LEMUR_PAUSE_BTN) ) {
        handled = handleLemurPauseBtn(msg);
      }
      else if( component.equals(config.LEMUR_FILE_LOADED_PLAY_BTN) ) {
        handled = handleLemurCloseFileLoadedBtn(msg);
      }
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
    
    private boolean handleLemurCloseFileLoadedBtn(OscMessage msg) {
      model.setPlaying(true);
      return true;
    }
  }

  private class SwitchPadController extends AbstractLemurController {

    @Override
      public boolean canHandleMessage(OscMessage msg) {
      boolean isButton = msg.addrPattern().indexOf( model.getLemurPadButtonRootAddress() ) >= 0;
      return isButton;
    }

    public boolean handleMessage(OscMessage msg) {
      //find the button with the address of this message
      int st = msg.addrPattern().indexOf("/");
      int en = msg.addrPattern().lastIndexOf("/");

      String find = msg.addrPattern().substring(st, en);

      int count = 0;
      for (LemurButton btn : model.getPad()) {
        println(btn.getName());
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
      String component = model.getComponentFromAddrPattern(msg.addrPattern());      
      
      if( component.equals(config.LEMUR_PATTERN_MENU_ADDR)) {
        int selection = int(msg.get(0).floatValue());
              
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

