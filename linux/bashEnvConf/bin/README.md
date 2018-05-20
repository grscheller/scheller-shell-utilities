# Bash Utilities:
Theses are the bash utilities I put into my Linux ~/bin directory.

### [path](path)
* Spreads $PATH out in a more user readable form.
* Output more appropriate for use as input to other commands.
```
   path | grep home
   realPath $(path)
```

### [pathTrim](pathTrim)
* Used in my .bash_profile.  Useful when $HOME and/or
  bash_profile are/is shared between several systems.
* Trims off duplicate entries and non-existant director $PATH
```
   Usage: pathTrim colen:separated:list
```
```
   Example: PATH=$(~/bin/pathTrim $PATH)
```

### [realPath](realPath)
* Resolve symlinks and print out the real path for each
  path given on the command line.
```
   Usage: realPath /path/to/first/item another/path/to/second/item
```
  Works well with whence:
```
   Example: realPath $(whence java javac scala python cc gcc ghc)
```

### [rt](rt)
* Launch rtorrent Bit-Torrent peer-to-peer ncurses based CLI program.

### [spin](spin)
* Spin a curser around.
* Handy to keep ssh connections alive
```
   Usage: spin
```
  Hit any key, except \<space\> or \<enter\>, to terminate.

### [viewJarManifest](viewJarManifest)
* View the manifest list of a *.jar file.
```
   Usage: viewJarManifest someJarFile.jar
```

### [whence](whence)
* Drill down through $PATH to look for files or directories.
* Like ksh builtin whence, except doesn't stop after finding
  first instance.
* Handles spaces in file names and directories.
* Shell patterns supported.
```
   Usage: whence file1 file2 ...
```
```
   Example: whence 'pyth*' 'ghc*' 'filename with spaces'
```