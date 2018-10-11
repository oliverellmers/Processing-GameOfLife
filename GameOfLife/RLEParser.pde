class RLEParser {
  Pattern p = Pattern.compile("(\\d*)([bo]?)!?");


  RLEPattern parse(String file) {
    RLEPattern rlePattern = new RLEPattern();

    ArrayList<ArrayList<Integer>> parseTree = new ArrayList();

    if ( file == null ) {
      println("no file to parse");
      return null;
    }

    BufferedReader reader = null;      
    try {
      String l = "";      

      reader = FileUtils.createReader(new File(file));

      //remember rle contains int and int[]
      while ( ( l = reader.readLine ()) != null) {
        //skip comments
        if (l.charAt(0) == '#') continue;

        //parse dimension
        if (l.contains(",") ) {
          String tokens[] = l.split(",");

          if (tokens.length > 2 ) {
            String xdim = tokens[0].split("=")[1].trim(); 
            String ydim = tokens[1].split("=")[1].trim();

            rlePattern.cols = Integer.parseInt(xdim);
            rlePattern.rows = Integer.parseInt(ydim);
          }
          //there should only be one line like this so continue with main parse loop
          continue;
        }

        //parse data
        l.trim();
        String dataLine = l;
        while ( ( l = reader.readLine () ) != null ) {
          l.trim();
          dataLine += l;
        }

        String dataTokens[] = dataLine.split("\\$");

        for (String rleLine : dataTokens ) {
          ArrayList<Integer> data = new ArrayList<Integer>();          

          Matcher m = p.matcher(rleLine);
          while (m.find ()) { 
            if (m.group(0).length() > 0 ) {          
              int count = 0;
              //parse count
              if (m.group(1).length() > 0) {
                count = Integer.parseInt(m.group(1));
              } 
              else {
                count = 1;
              }

              //parse cell type (dead or alive)
              if (m.group(2).length() > 0) {
                boolean isAlive = m.group(2).equals("o");
                
                for (int i=0; i<count; ++i) {
                  if (isAlive) {
                    data.add(1);
                  } 
                  else {
                    data.add(0);
                  }
                }
              } 
              else { // condition for ##$ e.g. blanklines
                //add the current line to the parseTree
                parseTree.add(data);

                for (int i=1; i < count-1; ++i ) {
                  data = new ArrayList<Integer>();
                  data.add(0);
                  parseTree.add(data);
                }
              }
            }
          }
          parseTree.add(data);
        }
      }
      for ( ArrayList<Integer> parseData : parseTree ) {
        rlePattern.addRow(parseData);
        //          println(rlePattern.debugRow(rowsParsed));            
      }
    }
    catch( Exception e ) {
      println("error parsing" + e);
    }
//    println("parsed pattern:\n"+rlePattern);
    return rlePattern;
  }
}
