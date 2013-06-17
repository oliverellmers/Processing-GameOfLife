class Config implements ConfigInterface {
  private final String PARAM_NODE = "param";
  private final String KEY_NODE = "key";
  private final String VALUE_NODE = "value";
  
  private final String LEMUR_NODE="lemurConfig";
  
  public final String RECTANGLE_CELL = "rectangle";
  public final String ELLIPSE_CELL = "ellipse";  

  //Application Properties
  final String APP_GMATRIXSIZE = "gridMatrixSize";
  final String APP_GSIZE = "gridSize";
  final String APP_RENDERSPEED = "renderSpeed";  
  final String APP_RLE_PATH = "rlePath";
  final String SYPHON = "runSyphon";
  final String SYPHON_SERVER = "syphonServer";

  //Bitmap Properties
  final String CELL_SHAPE = "cellShape";

  //Lemur Key Names from Config file 
  final String LEMUR_PAD_BTN_NAME           = "padButtonName";  
  final String LEMUR_PADSIZE                = "padDimensions";
  final String LEMUR_IPADDR                 = "lemurIp";
  final String LEMUR_IN_PORT                = "lemurInPort";
  final String LEMUR_PLAY_BTN               = "playButton";
  final String LEMUR_PAUSE_BTN               = "pauseButton";
  final String LEMUR_CLEAR_BTN              = "clearButton";
  final String LEMUR_PATTERN_MENU_ADDR     = "patternMenuAddr";
  final String LEMUR_MENU_SELECTION        = "patternMenuSelection";  
  final String PATTERN_FILE_NAME            = "patternFileNames";
  final String LEMUR_FILE_LOADED_PLAY_BTN =  "playFileLoadedButton";
  
  XML configXML;
  Config lemurConfig;

  Map<String, String> configProperties = new HashMap<String, String>();

  Config() {
  }

  Config(String configFile) {
    lemurConfig = new Config();    
    init(configFile);
  }

  private void init(String file) {
    try {
      configXML = loadXML(file);
    } 
    catch (Exception e) {
      println("error parsing xml file");
    }

    if (configXML == null) {
      println("error parsing xml file");
      return;
    }
    
    parseXMLData(configXML);
  }
  
  private void parseXMLData(XML xml) {
  
     //parse application section
    XML[] params = xml.getChildren(PARAM_NODE);

    for (int i = 0; i < params.length; i++) {
      String configKey   = params[i].getChild(KEY_NODE).getContent();
      String configValue = params[i].getChild(VALUE_NODE).getContent();
      configProperties.put(configKey, configValue);
    }
    
    //parse lemur config
    XML[] lemurParams = xml.getChildren(LEMUR_NODE);
    if( lemurParams != null ) {
      params = lemurParams[0].getChildren(PARAM_NODE);      
      
      for (int i = 0; i < params.length; i++) {
        String configKey   = params[i].getChild(KEY_NODE).getContent();
        String configValue = params[i].getChild(VALUE_NODE).getContent();
        lemurConfig.configProperties.put(configKey, configValue);
      } 
    }
    
    
  }

  public void init(XML xml) {
   parseXMLData(xml);
  }
  
  public ConfigInterface getLemurConfig() {
    return lemurConfig;
  }
  
  public String getValue(String aKey) throws Exception {
    String value = null;
    if (configProperties.containsKey(aKey) ) {
      value = configProperties.get(aKey);
    } 
    else {
      println("**UNKNOWN KEY = " + aKey );
    }

    if ( value == null ) {
      throw new Exception("Configuration value not found for key:: " + aKey +"\n***");
    }
    return value;
  }
}

