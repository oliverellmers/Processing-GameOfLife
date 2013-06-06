class RLELoader {
  RLECodec codec = new RLECodec();



  public ArrayList<Integer> loadFile() {
    ArrayList<Integer> ret = null;

    String path = FileUtils.showFileDialog(
    frame, 
    "An RLE file to load...", 
    dataPath(""), 
    new String[] { 
      ".rle", ".txt"
    }
    , 
    FileDialog.LOAD
      );

    if ( path != null ) {
      BufferedReader reader = null;
      String l = "";
      ArrayList data = new ArrayList();    
      try {
        reader = FileUtils.createReader(new File(path));

        //remember rle contains int and int[]
        while ( ( l = reader.readLine ()) != null) {
          if (l.charAt(0) == '[') {
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
          }
        }
      } 
      catch( IOException e ) {
        println("error parsing");
        println(e);
      }
      catch (Exception e) {
        println("Error opening file: "); 
        println(e);
      }
      ret = codec.decode(data);
    }
    return ret;
  }

  public void writeFile(RLECodec encoder, ArrayList<Integer> pixels, String fileName ) {
    PrintWriter output = createWriter(fileName);
    ArrayList dat = encoder.encode(pixels);
    for (int i =0; i < dat.size(); ++i ) {
      if (dat.get(i) instanceof int[] ) {
        output.print("[");
        output.print(((int[])dat.get(i))[0]); 
        output.print(","); 
        output.print(((int[])dat.get(i))[1]);
        output.println("]");
      }
      else {
        output.println(dat.get(i));
      }
    }
    output.flush();
    output.close();
    println("wrote out RLE file " + fileName);
  }
}

