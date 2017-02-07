#Dice Game - Assembly

This program is using Microsoft Macro Assembler (MASM) for x86 Processors with the [Kip Irvine](http://asmirvine.com/) library for Visual Studio.

There are two players in this dice game.

It first displays the start screen and then asks for the players' names.

<center>![Game Start](https://github.com/jaime-trejo/MASM/blob/master/GameStartScreen.PNG)</center>
<center>![Player Promp](https://github.com/jaime-trejo/MASM/blob/master/PlayerPromptScreen.PNG)</center>

A die will then be rolled and the outcome of the match will be shown.

<ul>
<li>RED - win</li>
<li>YELLOW - lose</li>
<li>BLUE - tie</li>
</ul>


<center>![Screen1](https://github.com/jaime-trejo/MASM/blob/master/GameSimulationScreen.PNG)</center>

<center>![Screen2](https://github.com/jaime-trejo/MASM/blob/master/GameSimulationScreen2.PNG)</center>

The players are then asked if they would want to play another match.
If they choose not to then the game will end and thank the players.

<center>![End](https://github.com/jaime-trejo/MASM/blob/master/ExitScreen.PNG)</center>


There are 3 macros  - one that reads a string, displays a message and displays a name.

There are 3 procedures
  <ul>
  <li>GamePageStart: Sets up the start screen display.</li>
  <li>RollDie: Generates a value for the die roll (1-6)</li>
  <li>Game name1:PTR BYTE,name2:PTR BYTE : Takes in the players' names,calls the RollDie PROC and more<li>
  <ul><li>There is a proto and an invoke for the Game PROC</li></ul>
  </ul>
