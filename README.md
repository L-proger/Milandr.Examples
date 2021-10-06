# Milandr.Examples
Example C++ projects for Russian "Milandr" (MDR) microcontrollers

## Notes
 The Milandr SPL/CMSIS libraries patched for GCC compatibility (+ custom LinkerScript and startup files). Use GNU Arm Embedded Toolchain to build sources.

## Building with Eclipse
 - Install Eclipse
 - Install and configure *"Eclipse Embedded CDT"* plugin
 - Import project in Eclipse workspace and build it

## Flashing and Debugging with SEGGER J-Link on Windows 10
 - Install Pythion 2.7. Python 3+ didn't work for me.
 - Add *PYTHONHOME* environment variable pointing to Python installation directory, for example *C:\Python27*
 - Add *PYTHONPATH* environment variable pointing to Python Lib directory, for example *C:\Python27/Lib*
 - Follow these instructions: https://github.com/in4lio/mdr1986x-JFlash
 


