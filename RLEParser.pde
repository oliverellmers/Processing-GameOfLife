class RLEParser {
  Pattern p = Pattern.compile("(\\d*)([bo]?)!?");


  RLEPattern parse(String file) {
    RLEPattern rlePattern = new RLEPattern();



    BufferedReader reader = null;      

    try {
      String l = "";      


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


            //              int insertRow = destRows / 2 - rows / 2;
            //              int insertCol = destCols / 2 - cols / 2;
            //              insertionIndex = insertRow * destCols + insertCol;
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
          println(rleLine);
          Matcher m = p.matcher(rleLine);
          ArrayList<Integer> data = new ArrayList<Integer>();

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
                String status = isAlive ? "o" : "b";
                for (int i=0; i<count; ++i) {
                  if (isAlive) {
                    data.add(1);
                  } 
                  else {
                    data.add(0);
                  }
                }
              }
            }
          }
          parseTree.add(data);
//          rlePattern.addRow(data);
//          println(rlePattern.debugRow(rowsParsed));            
//          ++rowsParsed;
        }
      }
      int rowsParsed = 0;
      for( ArrayList<Integer> parseData : parseTree ) {
        rlePattern.addRow(parseData);
          println(rlePattern.debugRow(rowsParsed));            
          ++rowsParsed;        
      }
    }
    catch( Exception e ) {
      println("error parsing" + e);
    }
    
    
    println("parsed pattern:\n"+rlePattern);
    return rlePattern;
  }
}

