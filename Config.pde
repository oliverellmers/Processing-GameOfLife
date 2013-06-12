class Config implements ConfigInterface {
  private final String PARAM_NODE = "param";
  private final String KEY_NODE = "key";
  private final String VALUE_NODE = "value";
  
  //Properties
  static final String APP_GMATRIXSIZE = "gridMatrixSize";
  static final String APP_GSIZE = "gridSize";
  static final String APP_RENDERSPEED = "renderSpeed";  
  
  
  Map<String, String> configProperties = new HashMap<String, String>();

  Config(String configFile) {
    init(configFile);
  }

  private void init(String file) {
    XML xml = null;
    try {
      xml = loadXML(file);
    } 
    catch (Exception e) {
      println("error parsing xml file");
    }

    if (xml == null) {
      println("error parsing xml file");
      return;
    }

    XML[] params = xml.getChildren(PARAM_NODE);

    for (int i = 0; i < params.length; i++) {
      String configKey   = params[i].getChild(KEY_NODE).getContent();
      String configValue = params[i].getChild(VALUE_NODE).getContent();
      configProperties.put(configKey,configValue);
    }
  }

  public String getValue(String aKey) throws Exception{
    String value = null;
    if (configProperties.containsKey(aKey) ) {
      value = configProperties.get(aKey);
    } else {
      println("**UNKNOWN KEY = " + aKey );
    }
    
    if( value == null ) {
      throw new Exception("Configuration value not found for key" + aKey);
    }
    return value;
  }

}

