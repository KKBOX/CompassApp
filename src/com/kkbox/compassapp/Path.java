package com.kkbox.compassapp;

public class Path {
  public String getJarPath() {
    return getClass().getProtectionDomain().getCodeSource().getLocation().getPath();
  }
}

