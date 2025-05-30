program main;

Uses GraphABC;
Uses menu;
Uses startScreen, windowHelper, Window_Game, inputPanel, gameInterface, windowRedactorMaze, 
windowGameMode, redactorMaze, windowSaveMaze, windowOpenMazeFromFolder, windowListWithMazes;

begin
  /// Функция отрисовки главного меню
  drawStartScreen();
  
  windowHelper.drawMenu := menu.drawMenu;
  Window_Game.drawInputPanel := inputPanel.drawInputPanel;
  inputPanel.WindowGame := Window_Game.WindowGame;
  gameInterface.WindowGame := Window_Game.WindowGame;
  windowRedactorMaze.windowGame := Window_Game.WindowGame;
  Window_Game.drawWindowRedactorMaze := windowRedactorMaze.drawWindowRedactorMaze;
  windowGameMode.windowGame := Window_Game.windowGame;
  Window_Game.drawWindowGameMode := windowGameMode.drawWindowGameMode;
  windowRedactorMaze.drawRedactor := redactorMaze.drawRedactor;
  redactorMaze.drawWindowRedactorMaze := windowRedactorMaze.drawWindowRedactorMaze;
  windowGameMode.drawInputPanel := inputPanel.drawInputPanel;
  windowSaveMaze.drawRedactor := redactorMaze.drawRedactor;
  redactorMaze.drawWindowSaveMaze := windowSaveMaze.drawWindowSaveMaze;
  inputPanel.drawRedactor := redactorMaze.drawRedactor;
  windowRedactorMaze.drawInputPanel := inputPanel.drawInputPanel;
  windowOpenMazeFromFolder.drawWindowRedactorMaze := windowRedactorMaze.drawWindowRedactorMaze;
  windowGameMode.drawWindowOpenMazeFromFolder := windowOpenMazeFromFolder.drawWindowOpenMazeFromFolder;
  windowOpenMazeFromFolder.drawLastMaze := redactorMaze.drawLastMaze;
  windowListWithMazes.drawWindowOpenMazeFromFolder := windowOpenMazeFromFolder.drawWindowOpenMazeFromFolder;
  windowOpenMazeFromFolder.drawWindowListWithMazes := windowListWithMazes.drawWindowListWithMazes
end.