package com.handlino.compassapp;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;


import java.util.ArrayList;
import org.jruby.Ruby;
import org.jruby.RubyInstanceConfig;
import org.jruby.javasupport.JavaEmbedUtils;

public class Main {
  public static void debuggery(String message) {
    System.err.println("DEBUGGERY:" + message); // JGBDEBUG
  }

  public static void main(String[] args) throws Exception {   
    RubyInstanceConfig config = new RubyInstanceConfig();
    config.setArgv(args);
    Ruby runtime = JavaEmbedUtils.initialize(new ArrayList(0), config);
    String mainRubyFile  = "main";
    String runConfigFile = "run_configuration";

    ArrayList<String> config_data = new ArrayList<String>();
    try{
      java.io.InputStream ins = Main.class.getClassLoader().getResourceAsStream(runConfigFile);
      if (ins == null ) {
        System.err.println("Did not find configuration file '" + runConfigFile + "', using defaults.");
      } else {
        config_data = getConfigFileContents(ins);
      }
    }
    catch(IOException ioe) {
      System.err.println("Error loading run configuration file '" + runConfigFile + "', using defaults: " + ioe);
    }
    catch(java.lang.NullPointerException npe) {
      System.err.println("Error loading run configuration file '" + runConfigFile + "', using defaults: " + npe );
    }

    for(String line : config_data) {

      String[] parts = line.split(":");
      if("main_ruby_file".equals(parts[0].replaceAll(" ", ""))) {
        mainRubyFile = parts[1].replaceAll(" ", "");
      }

      if("source_dirs".equals(parts[0].replaceAll(" ", ""))) {
        String[] source_dirs = parts[1].split(";");

        for(String s : parts[1].split(";") ){
          String d = s.replaceAll(" ", "");
          runtime.evalScriptlet( "$: << '"+d+"/'" );
        }
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
