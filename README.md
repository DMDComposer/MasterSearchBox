# Master Search Box

Gui Search Box to run custom user commands.  
![](images/ex_MSB_01.png)  
This is v1, modified & forked originally from [plul's AutoHotkey Launcher ](https://github.com/plul/Public-AutoHotKey-Scripts).

## What's changed from the original fork?

- Added selectable autocomplete for search commands using AHK Sift function.
  - ![](images/ex_MSB_02.png)
- Use of **Switch** instead of if/else
  - _use of if/else is greater than 5, than switch will yield greater performance._
- Added notifications when commands used using Maestrith's Notify Class
- Gave the UI a little upgrade visually.

## Master Search Box v2 aka Master Script Commands

- Utilizes G33kdude's neutron class to add JS, Html, & CSS for gui
- Use Elasticlunr js search engine which is superior to Sift's function
- Added quick access to run a AHK Command from MSC edit field.
