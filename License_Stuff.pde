void checkLicense(){
  String[] fromFile;
  PCname = System.getenv("COMPUTERNAME");
  try{
    fromFile = loadStrings("lib/hub/file/set/prog.blz");
  }
  catch(Exception e){
    println("SVB: " + e);
    fromFile = null;
  }
    
  if(fromFile == null){  // There is no license file (first startup) --> Generate one!
    FileOutput = createWriter("lib/hub/file/set/prog.blz");
    String tempStr1 = "";
    String tempStr2 = "";
    for(int z=0; z<10000; z++){
      tempStr1 += char(round(random(48, 253)));
    }
    for(int z=0; z<15402; z++){
      tempStr2 += char(round(random(48, 253)));
    }    
    FileOutput.print(tempStr1 + PCname + tempStr2);
    FileOutput.flush();
    FileOutput.close();
    licenseOK = true;
  }
  
  else{    // There is a license file --> Read saved PC name from file
    if(match(fromFile[0], PCname) != null){  // PC name matches saved string in .blz file
      licenseOK = true;
    }
    
    else{  // Content does not match PC name
      licenseOK = false;
    }
  }
}