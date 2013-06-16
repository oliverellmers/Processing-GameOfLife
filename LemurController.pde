public class LemurController implements InterfaceLemurController {

  ArrayList<String> messageAddresses;
  ArrayList<InterfaceLemurController> controllers;

  //MOVE TO MODEL
  Pattern padButtonRE; 
  Pattern controlButtonRE;


  LemurController() {
    messageAddresses = new ArrayList<String>();
    controllers = new ArrayList<InterfaceLemurController>();
    controllers.add(  new SwitchPadController());
    controllers.add( new ControlButtonController());
    controllers.add( new MenuController());
  } 


  boolean handleMessage(OscMessage msg) {
    for (InterfaceLemurController lc : controllers ) {
      if (lc.handleMessage(msg) == true) {
        return true;
      }
    }
    return false;
  }



  public void addController(InterfaceLemurController ctrl) {
    controllers.add(ctrl);
  }


  private class ControlButtonController implements InterfaceLemurController {
    final int PLAY = 1;
    final int PAUSE = 0;

    public boolean handleMessage(OscMessage msg) {
      boolean handled = false;
      if ( msg.checkAddrPattern( model.getLemurPlayBtnAddr()) == true) {
        handled = handleLemurPlayBtn(msg);
      } 
      else if ( msg.checkAddrPattern( model.getLemurClearBtnAddr()) == true) {
        handled = handleLemurClearBtn(msg);
      }
      else if (msg.checkAddrPattern( model.getLemurPauseBtnAddr()) == true) {
        handled = handleLemurPauseBtn(msg);
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
  }

  private class SwitchPadController implements InterfaceLemurController {

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


  private class MenuController implements InterfaceLemurController {
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

