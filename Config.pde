class Config implements ConfigInterface {
  private final String PARAM_NODE = "param";
  private final String KEY_NODE = "key";
  private final String VALUE_NODE = "value";
  private final String TYPE_NODE = "type";
  
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
      String configType  = params[i].getChild(TYPE_NODE).getContent();
  
      println(configKey + " " + configValue + "  " + configType);
      configProperties.put(configKey,configValue);
    }
  }

  public String getValue(String key) {
    String value = null;
    if (configProperties.containsKey(key) ) {
      value = configProperties.get(key);
    }
    return value;
  }
}

