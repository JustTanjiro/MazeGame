Unit windowListWithMazes;

interface

Uses GraphABC, UI, workWithMazeInFolder, saveAndLoadMaze, Window_game, windowOpenMazeFromFolder, gameLogic;

const
  buttonX = 200;
  buttonY = 75;
  stepX = buttonX + 50;
  stepY = buttonY + 50;
  MAZES_PER_PAGE = 12;
  MAZES_PER_LINE = 3;
  
  x0 = 50;
  y0 = 25;

type
  TPoint = record
    x, y: integer;
  end;

var
  buttons: array[1..20] of TPoint;
  drawWindowOpenMazeFromFolder: procedure();
  listMazes: array[1..100] of string;
  currentPage, totalPages: integer;
  mazes: integer;
  
procedure drawWindowListWithMazes(currentPage: integer);

implementation

/// Процедура отрисовки кнопки 'Выйти'
procedure drawButtonExit();
var
  exite: Button;
begin
  exite := CreateButton(250, 525, 300, 50, 'Выйти', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(exite);
end;

/// Процедура отрисовки кнопки 'Назад'
procedure drawButtonBack();
var
  back: Button;
begin
  back := CreateButton(50, 525, 150, 50, 'Назад', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(back);
end;

/// Процедура отрисовки кнопки 'Вперёд'
procedure drawButtonNext();
var
  next: Button;
begin
  next := CreateButton(600, 525, 150, 50, 'Вперёд', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(next);
end;

function countMazes(): integer;
var
  f: TextFile;
  lineCount: Integer;
  line: string;
begin
  AssignFile(f, GetCurrentDir + '\Лабиринты\Список лабиринтов.txt');
  Reset(f);
  lineCount := 0;
  while not Eof(f) do
  begin
    ReadLn(f, line);
    lineCount += 1;
  end;
  CloseFile(f);
  countMazes := lineCount;
end;

procedure fillListMazes(mazes: integer);
var
  f: TextFile;
  x: integer;
begin
  mazes := countMazes();
  AssignFile(f, GetCurrentDir + '\Лабиринты\Список лабиринтов.txt');
  Reset(f);
  
  for x := 1 to mazes do
  begin
    Readln(f, listMazes[x]);
  end;
  
  CloseFile(f);
end;

procedure windowListWithMazesOnMouseDown(x, y, mousebutton: integer);
var
  i, btX, btY, btN: integer;
begin
  
  if (currentPage = 0) then
    currentPage := 1;
  
  /// Выход
  if (mousebutton = 1) and (x > 250) and (x < 550) and 
  (y > 525) and (y < 575) then
  begin
    drawWindowOpenMazeFromFolder();
  end;
  
  /// Назад
  if (mousebutton = 1) and (x > 50) and (x < 200) and 
  (y > 525) and (y < 575) and (currentPage > 1) then
  begin
    currentPage := currentPage - 1;
    drawWindowListWithMazes(currentPage);
  end;
  
  /// Вперёд
  if (mousebutton = 1) and (x > 600) and (x < 750) and 
  (y > 525) and (y < 575) and (currentPage < totalPages) then
  begin
    currentPage := currentPage + 1;
    drawWindowListWithMazes(currentPage);
  end;
  
  for i := (currentPage - 1) * MAZES_PER_PAGE + 1 to min(currentPage * MAZES_PER_PAGE, mazes) do
  begin
      
    btN := (i - 1) mod MAZES_PER_PAGE;
    btX := x0 + stepX * (btN mod MAZES_PER_LINE);
    btY := y0 + stepY * (btN div MAZES_PER_LINE);
    
    if (mousebutton = 1) and (x > btX) and (x < btX + buttonX) and (y > btY) and (y < btY + buttonY) then
    begin
      loadMazeFromFile(listMazes[i]);
      if isGame then
      begin
        findStartAndFinishForMazeFromFile();
        gameForMazeFromFile();
        isWritingFileName := False;
        fileName := '';
      end
      else if isRedactor then
      begin
        drawLastMaze();
        isWritingFileName := False;
        fileName := '';
      end;
      break;
    end;
  end;
end;
  
procedure drawWindowListWithMazes(currentPage: integer);
var
  i, x, y: integer;
  bt: Button;
  
begin
  
  mazes := countMazes();
  totalPages := ceil(mazes / MAZES_PER_PAGE);
  
  x := x0;
  y := y0;
  
  if (currentPage = 0) then
    currentPage := 1;
  
  clearWindow();
  fillArea();
  drawButtonBack();
  drawButtonExit();
  drawButtonNext();
  onMouseDown := windowListWithMazesOnMouseDown;
  
  fillListMazes(mazes);
  
  for i := (currentPage - 1) * MAZES_PER_PAGE + 1 to min(currentPage * MAZES_PER_PAGE, mazes) do
  begin
    bt := CreateButton(x, y, buttonX, buttonY, listMazes[i], RGB(0, 102, 51), RGB(24, 21, 19), 20);
    drawButton(bt);
  
    x := x + stepX;
    if x > 800 - buttonX then
    begin
      x := x0;
      y := y + stepY;
    end;
  end;
end;
end.