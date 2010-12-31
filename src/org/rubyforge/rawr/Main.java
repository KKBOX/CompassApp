package org.rubyforge.rawr;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;


import java.util.ArrayList;
import org.jruby.Ruby;
import org.jruby.RubyInstanceConfig;
import org.jruby.javasupport.JavaEmbedUtils;
import org.jruby.platform.Platform;

public class Main
{
  public static void main(String[] args) throws Exception
  {   
    RubyInstanceConfig config = new RubyInstanceConfig();
    config.setArgv(args);
    Ruby runtime = JavaEmbedUtils.initialize(new ArrayList(0), config);
    String mainRubyFile = "main";
   
    ArrayList<String> config_data = new ArrayList<String>();
    try{
      java.io.InputStream ins = Main.class.getClassLoader().getResourceAsStream("run_configuration");
      if (ins == null ) {
        System.err.println("Did not find configuration file 'run_configuration', using defaults.");
      } else {
        config_data = getConfigFileContents(ins);
      }
    }
    catch(IOException ioe)
    {
      System.err.println("Error loading run configuration file 'run_configuration', using defaults: " + ioe);
    }
    catch(java.lang.NullPointerException npe)
    {
      System.err.println("Error loading run configuration file 'run_configuration', using defaults: " + npe );
    }

    for(String line : config_data) {
        String[] parts = line.split(":");
        if("main_ruby_file".equals(parts[0].replaceAll(" ", ""))) {
            mainRubyFile = parts[1].replaceAll(" ", "");
        }
    }

    runtime.evalScriptlet("require '" + mainRubyFile + "'");
  }

  public static URL getResource(String path) {
      return Main.class.getClassLoader().getResource(path);
  }

  private static ArrayList<String> getConfigFileContents(InputStream input) throws IOException, java.lang.NullPointerException {
    BufferedReader reader = new BufferedReader(new InputStreamReader(input));
    String line;
    ArrayList<String> contents = new ArrayList<String>();

    while ((line = reader.readLine()) != null) {
      contents.add(line);
    }
    reader.close();
    return(contents);
  }
}
