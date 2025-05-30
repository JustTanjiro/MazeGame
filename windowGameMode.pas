Unit windowGameMode;
  
interface

Uses GraphABC;
Uses UI, Window_Game;

var
  drawInputPanel: procedure();
  windowGame: procedure();
  drawWindowOpenMazeFromFolder: procedure();

procedure drawwindowGameMode;

implementation

/// Процедура отрисовки кнопки 'Открыть готовый лабиринт'
procedure drawButtonReadyMaze();
var 
  readyMaze: Button;
begin
  readyMaze := CreateButton(200, 50, 400, 100, 'Открыть готовый лабиринт', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(readyMaze);
end;
  
/// Процедура отрисовки кнопки 'Сгенерировать лабиринт'
procedure drawButtonGenerateMaze();
var 
  GenerateMaze: Button;
begin
  GenerateMaze := CreateButton(200, 200, 400, 100, 'Сгенерировать лабиринт', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(GenerateMaze);
end;

/// Процедура отрисовки кнопки 'Назад'
procedure drawButtonBack();
var 
  back: Button;
begin
  back := CreateButton(250, 500, 300, 50, 'Назад', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(back);
end;

/// Процедура для обработки нажатия на ЛКМ для кнопок 
/// 'Открыть готовый лабиринт', 'Сгенерировать лабиринт', 'Назад'
procedure windowGameModeOnMouseDown(x, y, mousebutton: integer);
begin
  
  /// Обработка кнопки 'Открыть готовый лабиринт'
  if (mousebutton = 1) and (x > 200) and (x < 600) and (y > 50) and (y < 150) then
    begin
      drawWindowOpenMazeFromFolder();
    end;
  
  /// Обработка кнопки 'Сгенерировать лабиринт'
  if (mousebutton = 1) and (x > 200) and (x < 600) and (y > 200) and (y < 300) then
    begin
      drawInputPanel();
    end;
    
  /// Обработка кнопки 'Назад'
  if (mousebutton = 1) and (x > 250) and (x < 550) and (y > 500) and (y < 550) then
    begin
      clearwindow;
      windowGame();
      isGame := False;
    end;
end;

/// Отрисовка окна выбора режимы игры: 
/// Готовый лабиринт / Сгенерировать лабиринт
procedure drawWindowGameMode();
begin
  clearWindow();
  FillArea();
  drawButtonReadyMaze();
  drawButtonGenerateMaze();
  drawButtonBack();
  OnMouseDown := windowGameModeOnMouseDown;
end;
end.