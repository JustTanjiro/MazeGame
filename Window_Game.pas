Unit Window_Game;

interface

Uses GraphABC;
Uses UI;

var 
  isGame, isRedactor: boolean;
  drawInputPanel: procedure();
  drawWindowRedactorMaze: procedure();
  drawWindowGameMode: procedure();

procedure WindowGame();

implementation

Uses Menu;

/// Процедура отрисовки кнопки 'Играть'
procedure drawButtonGameMaze();
var 
  generateMaze: Button;
begin
  generateMaze := CreateButton(200, 50, 400, 100, 'Играть', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(generateMaze);
end;
  
/// Процедура отрисовки кнопки 'Редактор лабиринта'  
procedure drawButtonRedactorMaze();
var 
  redactorMaze: Button;
begin
  redactorMaze := CreateButton(200, 200, 400, 100, 'Редактор лабиринта', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(redactorMaze);
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
/// 'Играть', 'Редактор лабиринта', 'Назад'
procedure windowGameOnMouseDown(x, y, mousebutton: integer);
begin
  
  // Обработка кнопки 'Играть'
  if (mousebutton = 1) and (x > 200) and (x < 600) and (y > 50) and (y < 150) then
  begin
    isGame := True;
    isRedactor := False;
    drawWindowGameMode();
  end;
    
  // Обработка кнопки 'Редактор лабиринта'
  if (mousebutton = 1) and (x > 200) and (x < 600) and (y > 200) and (y < 300) then
  begin
    isRedactor := True;
    isGame := False;
    drawWindowRedactorMaze();
  end;
    
  // Обработка кнопки 'Назад'
  if (mousebutton = 1) and (x > 250) and (x < 550) and (y > 500) and (y < 550) then
  begin
    clearwindow;
    drawMenu();
  end;
end;

/// Отрисовка окна выбора режима: 
/// Игра/Редактор
procedure WindowGame();
begin
  FillArea();
  drawButtonGameMaze();
  drawButtonRedactorMaze();
  drawButtonBack();
  OnMouseDown := windowGameOnMouseDown;
end;
end.