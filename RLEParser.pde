class RLEParser {

  Bitmap parse(String file) {
    Bitmap bmp = new Bitmap();

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
          }
          
          //parsedata
            println(l);
            String dataTokens[] = l.split("\\$");
            println(dataTokens.length);
          
          //bmp.rows = Integer.parseInt(x.trim());
          //bmp.cols = Integer.parseInt(y.trim());

          //println(bmp.rows + " ," + bmp.cols);

          /*if (l.charAt(0) == '[') {
           int[] values = new int[2];
           String[] tokens = l.split(",");
           String text = tokens[0].replace("\n", "").replace("\r", "");
           values[0] = Integer.parseInt(text.substring(1, text.length()));
           
           text =  tokens[1].replace("\n", "").replace("\r", "");
           values[1] = Integer.parseInt(text.substring(0, text.length()-1));
           data.add(values);
           } 
           else {
           data.add(Integer.parseInt(l.replace("\n", "").replace("\r", "")));
           }*/
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

