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

  //Bitmap Properties
  final String CELL_SHAPE = "cellShape";

  //Lemur Properties
  final String LEMUR_PADSIZE   = "lemurPadSize";
  final String LEMUR_PADADDR   = "lemurPadAddr";
  final String LEMUR_IPADDR    = "lemurIp";
  final String LEMUR_IN_PORT   = "lemurInPort";
  XML configXML;
  Config lemurConfig;

  Map<String, String> configProperties = new HashMap<String, String>();

  Config() {
  }

  Config(String configFile) {
    lemurConfig = new Config();    
    init(configFile);
    
//    lemurConfig.init();
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
    params = xml.getChildren(LEMUR_NODE);
    if( params!= null) {
      params = xml.getChildren(PARAM_NODE);
      
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
      throw new Exception("Configuration value not found for key:: " + aKey +"\n***\n\n");
    }
    return value;
  }
}

