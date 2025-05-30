Unit windowRedactorMaze;

interface

Uses GraphABC;
Uses UI, Window_Game, windowOpenMazeFromFolder;

var 
  isRedactorForNewMaze, isRedactorForGeneratedMaze: boolean;
  drawInputPanel: procedure();
  drawRedactor: procedure();
  WindowGame: procedure();

procedure drawWindowRedactorMaze();

implementation

/// Отрисовывает кнопку 'Готовый лабиринт'
procedure drawButtonReadyMaze();
var
  readyMaze: Button;
begin
  readyMaze := CreateButton(200, 50, 400, 100, 'Готовый лабиринт', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(readyMaze);
end;

/// Отрисовывает кнопку 'Новый лабиринт'
procedure drawButtonNewMaze();
var
  newMaze: Button;
begin
  newMaze := CreateButton(200, 200, 400, 100, 'Новый лабиринт', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(newMaze);
end;

/// Отрисовывает кнопку 'Сгенерировать лабиринт'
procedure drawButtonGenerateMaze();
var
  generateMaze: Button;
begin
  generateMaze := CreateButton(200, 350, 400, 100, 'Сгенерировать лабиринт', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(generateMaze);
end;

/// Отрисовывает кнопку 'Назад'
procedure drawButtonBack();
var 
  back: Button;
begin
  back := CreateButton(250, 500, 300, 50, 'Назад', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(back);
end;

/// Процедура для обработки нажатия на ЛКМ для кнопок 
/// 'Готовый лабиринт', 'Новый лабиринт', 'Назад'
procedure windowRedactorMazeOnMouseDown(x, y, mousebutton: integer);
begin
  
  /// Обработка кнопки 'Готовый лабиринт'
  if (mousebutton = 1) and (x > 200) and (x < 600) and (y > 50) and (y < 150) then
  begin
    drawWindowOpenMazeFromFolder();
  end;
  
  /// Обработка кнопки 'Новый лабиринт'
  if (mousebutton = 1) and (x > 200) and (x < 600) and (y > 200) and (y < 300) then
  begin
    isRedactorForNewMaze := True;
    drawInputPanel();
  end;
  
  /// Обработка кнопки 'Сгенерировать лабиринт'
  if (mousebutton = 1) and (x > 200) and (x < 600) and (y > 350) and (y < 450) then
  begin
    isRedactorForGeneratedMaze := True;
    drawInputPanel();
  end;
  
  /// Обработка кнопки 'Назад'
  if (mousebutton = 1) and (x > 250) and (x < 550) and (y > 500) and (y < 550) then
  begin
    ClearWindow();
    windowGame();
    isRedactorForNewMaze := False;
    isRedactorForGeneratedMaze := False;
  end;
end;

/// Отрисовка окна выбора режимы редактора: 
/// Готовый лабиринт / Новый лабиринт
procedure drawWindowRedactorMaze();
begin
  clearWindow();
  FillArea();
  drawButtonReadyMaze();
  drawButtonNewMaze();
  drawButtonGenerateMaze();
  drawButtonBack();
  
  OnMouseDown := windowRedactorMazeOnMouseDown;
end;
end.