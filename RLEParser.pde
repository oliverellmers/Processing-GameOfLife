class RLEParser {

  Bitmap parse(String file) {
    Bitmap bmp = new Bitmap();
    //    Pattern p = Pattern.compile("(\\d*)([bo]?)(\\d*)([bo]?).*");
    Pattern p = Pattern.compile("(\\d*)([bo]?)");    

    if ( file != null ) {
      BufferedReader reader = null;      

      try {
        String l = "";      
        ArrayList data = new ArrayList();    

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
              bmp.rows = Integer.parseInt(xdim);
              bmp.cols = Integer.parseInt(ydim);
            }
            continue;
          }

          //parsedata
          println(l);
          String dataTokens[] = l.split("\\$");
          int cursor = 0;

          for (String dat : dataTokens ) {
            Matcher m = p.matcher(dat);
            println(dat);

            while (m.find ()) { 
              if (m.group(0).length() > 0 ) {
                int count = 0;

                //parse number
                if (m.group(1).length() > 0) {
                  count = Integer.parseInt(m.group(1));
                } else {
                  count = 1;
                }

                //parse cell type (dead or alive initially)
                if (m.group(2).length() > 0) {
                  if (m.group(2).equals("b")) {
                    println("dead cells");
                    cursor += count;
                  } 
                  else if (m.group(2).equals("o")) {
                    //enter in live cells starting at the current cursor location
                    println("adding " + count + " live cells");
                  }
                }
                print("overall length = " + m.group(0).length() +"  #1: " + m.group(1).length() +" #2: " + m.group(2).length() + " ");
              }
              cursor = 0;
              println();
              println("\t: " + dat);
            }
          }
        } 
      }
        catch( IOException e ) {
          println("error parsing");
          println(e);
        }
      }
      return bmp;
    }
  }

