# Add-On Packer
The new smart way to pack an Add-On without having to manually manage files, names and the sometimes annoying namecheck.txt. It is made to be universally used on any platform that may use Blockland.

## DISCLAIMER
These scripts have only been tested on Windows and Linux. It is not guarenteed to work every time.

## Requirements
The scripts require the system to install 7-Zip. It maybe downloaded from their [site](http://www.7-zip.org/download.html), but for unix systems it can be downloaded through a package manager.

## Installation
Download the three script files `pack.cmd`, `pack.bat` and `pack.sh` along with the exclude file `exclude.txt` and put them in an appropriate folder.

## Usage
The most simple way to use it is through `pack.cmd`. Just drag one or more folders onto the file and it will package everything in respective folder and add a `namecheck.txt` file where it is needed. Keep in mind that when there is a `namecheck.txt` in a folder, it will take that name and put it on the archive. However, if there is none, then it will take the folder name instead.

A folder is the root for an Add-On and adding more will create one archive for each folder.

*Note: Currently there is no check to validate Add-On name.*

## Advanced
When installtion, pick one of the `pack.sh` or `pack.bat` depending on your platform along with the `exclude.txt` and put them in an appropriate folder.
