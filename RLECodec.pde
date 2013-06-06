class RLECodec{

  public ArrayList encode(ArrayList<Integer> stream) {
    ArrayList a = new ArrayList();

    int val = stream.get(0); 
    int next = -1;    
    int cnt = 1;     

    for ( int i = 1; i < stream.size(); ++i ) {
      next = stream.get(i);
      if ( val == next ) {
        ++cnt;
      } 
      else {
        if (cnt > 1) {
          int[] entry = {
            cnt, val
          };
          a.add(entry);
        } 
        else {
          a.add(val);
        }
        //          a.add(cnt); a.add(val);
        val = next;
        cnt = 1;
      }
    }
    if (cnt > 1) {
      int[] entry = {
        cnt, val
      };
      a.add(entry);
    } 
    else {
      a.add(val);
    }
    return a;
  }


  public ArrayList<Integer> decode(ArrayList stream) {
    ArrayList<Integer> a = new ArrayList<Integer>();
    for (int i=0; i < stream.size(); ++i) {
      if ( stream.get(i) instanceof int[]) {
        int count = ((int[])stream.get(i))[0];
        int val = ((int[])stream.get(i))[1];
        for (int j=0; j < count; ++j) {
          a.add(val);
        }
      } 
      else {
        a.add( (Integer)stream.get(i));
      }
    }     
    return a;
  }

  public boolean validate(ArrayList<Integer> rle, ArrayList<Integer> original ) {
    ArrayList decoded = decode(rle);
    boolean ret = true;
    if ( original.size() != decoded.size() ) {
      ret = false;
    } 
    else {
      for (int i=0; i < decoded.size(); ++i ) {
        if ( decoded.get(i) != original.get(i) ) {
          ret = false;
          break;
        }
      }
    }
    return ret;
  }
}

