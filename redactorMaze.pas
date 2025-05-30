unit redactorMaze;

interface

Uses GraphABC;
Uses UI, mazeData, gameLogic, mazeGenerator, windowRedactorMaze;

var
  drawWindowRedactorMaze: procedure;
  drawWindowSaveMaze: procedure;
  isSetStart, isSetFinish: boolean;
  isWayinMaze: boolean;

procedure drawRedactor();
procedure drawLastMaze();

implementation

const
  xMode = Trunc(ScreenWidth / 2) - 7 * Trunc(ScreenWidth / 64);
  yMode = Trunc(ScreenWidth / 48);
  wMode = 2 * Trunc(ScreenWidth / 64);
  hMode = Trunc(ScreenWidth / 36);

var
  isMode1, isMode2, isMode3, isMode4: boolean;
  isWarning: boolean;

/// Процедура отрисовки кнопки 'Выход'
procedure drawButtonExit();
var
  exite: Button;
  x, y, w, h: integer;
begin
  x := Trunc(ScreenWidth / 50);
  y := Trunc(ScreenHeight / 50);
  w := x * 7;
  h := y * 4;
  exite := CreateButton(x, y, w, h, 'Выход', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(exite);
end;

/// Процедура отрисовки кнопки 'Сохранить'
procedure drawButtonSave();
var
  save: Button;
  x, y, w, h: integer;
begin
  x := ScreenWidth - 8 * Trunc(ScreenWidth / 50);
  y := Trunc(ScreenHeight / 50);
  w := 7 * Trunc(ScreenWidth / 50);
  h := y * 4;
  save := CreateButton(x, y, w, h, 'Сохранить', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(save);
end;

/// Процедура отрисовки кнопки 'Предупреждение'
procedure drawButtonWarning();
var
  warning, buttonYes, buttonNo: Button;
  x, y, w, h: integer;
begin
  SetBrushColor(RGB(138, 149, 151));
  FillRect(Trunc(ScreenWidth / 50), Trunc(ScreenHeight / 50), Trunc(ScreenWidth / 50) * 8, Trunc(ScreenHeight / 50) * 5);
  
  x := Trunc(ScreenWidth / 50);
  y := Trunc(ScreenHeight / 50);
  w := x * 7;
  h := y * 2;
  warning := CreateButton(x, y, w, h, 'Вы уверены?', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(warning);
  
  x := Trunc(ScreenWidth / 50);
  y := Trunc(ScreenHeight / 50) * 3;
  w := Trunc(x / 2) * 7;
  h := Trunc(y / 3) * 2;
  buttonYes := CreateButton(x, y, w, h, 'Да', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(buttonYes);
  
  x := Trunc((ScreenWidth / 50) / 2) * 9;
  y := Trunc(ScreenHeight / 50) * 3;
  w := Trunc(x / 9) * 7;
  h := Trunc(y / 3) * 2;
  buttonNo := CreateButton(x, y, w, h, 'Нет', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(buttonNo);
end;

/// Процедура отрисовки кнопок выбора режима редактирования
procedure drawButtonsForRedaction();
var
  path, wall, start, finish: Button;
  x: integer;
begin
  x := xMode;
  SetPenWidth(10);
  
  /// свободная клетка
  SetPenColor(clWhite);
  path := CreateButton(x, yMode, wMode, hMode, '', clWhite, RGB(24, 21, 19), 20);
  drawButton(path);
  
  /// стена
  SetPenColor(clBlack);
  x += 4 * Trunc(ScreenWidth / 64);
  wall := CreateButton(x, yMode, wMode, hMode, '', clBlack, RGB(24, 21, 19), 20);
  drawButton(wall);
  
  /// старт
  SetPenColor(clBlue);
  x += 4 * Trunc(ScreenWidth / 64);
  start := CreateButton(x, yMode, wMode, hMode, '', clBlue, RGB(24, 21, 19), 20);
  drawButton(start);
  
  /// финиш
  SetPenColor(clRed);
  x += 4 * Trunc(ScreenWidth / 64);
  finish := CreateButton(x, yMode, wMode, hMode, '', clRed, RGB(24, 21, 19), 20);
  drawButton(finish);
  
  SetPenWidth(0);
  SetPenColor(clBlack);
end;

/// Процедура выделения выбранного режима редактирования
procedure drawingSelectedMode(x, mode: integer);
var
  choosedMode: Button;
  cl: Color;
begin
  drawButtonsForRedaction();
  case mode of
    1: cl := clWhite;
    2: cl := clBlack;
    3: cl := clBlue;
    4: cl := clRed;
  end;
  
  SetPenWidth(10);
  SetPenColor(RGB(138, 149, 151));
  
  choosedMode := CreateButton(x, yMode, wMode, hMode, '', cl, clRed, 20);
  drawButton(choosedMode);
  
  SetPenWidth(0);
  SetPenColor(clBlack);
end;

/// Функция, определяющая, есть ли выход из лабиринта
function isWay(): boolean;
var
  minWay: integer;
begin
  minWay := dijkstra(sx, sy, fx, fy);
  if (not(minWay = INF) and not(minWay = 0)) then
  begin
    isWay := True;
  end
  else
  begin
    isWay := False;
  end;
end;

/// Процедура выбора режима редактирования
procedure selectedMode(mode: integer);
var
  modes: array[1..4] of boolean;
begin
  modes[mode] := True;
  isMode1 := modes[1];
  isMode2 := modes[2];
  isMode3 := modes[3];
  isMode4 := modes[4];
end;

/// Процедура закраски редактируемой клетки
procedure ceilCell(ceilX, ceilY: integer);
begin
  if isMode1 then
  begin
    maze[ceilX, ceilY] := 1;
    fillCell(ceilX, ceilY, clWhite);
    
    if (isSetStart) and (sx = ceilX) and (sy = ceilY) then
    begin
      isSetStart := False;
      maze[sx, sy] := 1;
      fillCell(sx, sy, clWhite);
    end;
    
    if (isSetFinish) and (fx = ceilX) and (fy = ceilY) then
    begin
      isSetFinish := False;
      maze[fx, fy] := 1;
      fillCell(fx, fy, clWhite);
    end;
  end;
  
  if isMode2 then
  begin
    maze[ceilX, ceilY] := 0;
    fillCell(ceilX, ceilY, clBlack);
    
    if (isSetStart) and (sx = ceilX) and (sy = ceilY) then
    begin
      isSetStart := False;
      maze[sx, sy] := 1;
      fillCell(sx, sy, clWhite);
    end;
    
    if (isSetFinish) and (fx = ceilX) and (fy = ceilY) then
    begin
      isSetFinish := False;
      maze[fx, fy] := 1;
      fillCell(fx, fy, clWhite);
    end;
  end;
  
  if isMode3 then
  begin
    if (isSetFinish) and (fx = ceilX) and (fy = ceilY) then
      isSetFinish := False;
    if (not isSetStart) or ((isSetStart) and ((sx <> ceilX) or (sy <> ceilY))) then
    begin
      if isSetStart then
      begin
        maze[sx, sy] := 1;
        fillCell(sx, sy, clWhite);
      end;
      sx := ceilX;
      sy := ceilY;
      maze[ceilX, ceilY] := 2;
      fillCell(ceilX, ceilY, clBlue);
      isSetStart := True;
      
      if (isSetFinish) and (fx = ceilX) and (fy = ceilY) then
      begin
        isSetFinish := False;
        maze[fx, fy] := 1;
        fillCell(fx, fy, clWhite);
      end;
    end;
  end
  
  else if isMode4 then
  begin
    if (isSetStart) and (sx = ceilX) and (sy = ceilY) then
      isSetStart := False;
    if (not isSetFinish) or ((isSetFinish) and ((sx <> ceilX) or (sy <> ceilY))) then
    begin
      if isSetFinish then
      begin
        maze[fx, fy] := 1;
        fillCell(fx, fy, clWhite);
      end;
      fx := ceilX;
      fy := ceilY;
      maze[ceilX, ceilY] := 3;
      fillCell(ceilX, ceilY, clRed);
      isSetFinish := True;
      
      if (isSetStart) and (sx = ceilX) and (sy = ceilY) then
      begin
        isSetStart := False;
        maze[sx, sy] := 1;
        fillCell(sx, sy, clWhite);
      end;
    end;
  end;
end;

/// Процедура очистки массива лабиринта
procedure clearMaze();
var
  x, y: integer;
begin
  for x := 0 to MAXHEIGHT do
    for y := 0 to MAXHEIGHT do
      maze[x, y] := 0
end;

/// Процедура, реализующая механизм установки клетки
/// определенного значения (проход, стена, старт, финиш)
procedure redactorMazeOnMouseDown(x, y, mousebutton: integer);
var
  ceilX, ceilY, xModeStep: integer;
begin
  xModeStep := 4 * Trunc(ScreenWidth / 64);
  
  /// Заполнение ячейки
  if (mousebutton = 1) and (x > offsetX + size) and (x < offsetX + width * size)
  and (y > offsetY + size) and (y < offsetY + height * size) then
  begin
    ceilX := (x - offsetX) div size; 
    ceilY := (y - offsetY) div size; 
    ceilCell(ceilX, ceilY);
  end;
  
  /// Включить мод 1 (проход)
  if (mousebutton = 1) and (x > xMode) and (x < xMode + wMode)
  and (y > yMode) and (y < yMode + hMode) then
  begin
    selectedMode(1);
    drawingSelectedMode(xMode, 1);
  end;
  
  /// Включить мод 2 (стенка)
  if (mousebutton = 1) and (x > xMode + xModeStep) and (x < xMode + xModeStep + wMode)
  and (y > yMode) and (y < yMode + hMode) then
  begin
    selectedMode(2);
    drawingSelectedMode(xMode + xModeStep, 2);
  end;
  
  /// Включить мод 3 (старт)
  if (mousebutton = 1) and (x > xMode + 2 * xModeStep) and (x < xMode + 2 * xModeStep + wMode)
  and (y > yMode) and (y < yMode + hMode) then
  begin
    selectedMode(3);
    drawingSelectedMode(xMode + 2 * xModeStep, 3);
  end;
  
  /// Включить мод 4 (финиш)
  if (mousebutton = 1) and (x > xMode + 3 * xModeStep) and (x < xMode + 3 * xModeStep + wMode)
  and (y > yMode) and (y < yMode + hMode) then
  begin
    selectedMode(4);
    drawingSelectedMode(xMode + 3 * xModeStep, 4);
  end;
  
  /// Сохранить
  if (mousebutton = 1) and (x > ScreenWidth - 8 * Trunc(ScreenWidth / 50))
  and (x < ScreenWidth - 1 * Trunc(ScreenWidth / 50))
  and (y > Trunc(ScreenHeight / 50))
  and (y < 5 * Trunc(ScreenHeight / 50)) then
  begin
    isWayinMaze := isWay();
    drawWindowSaveMaze();
    exit;
  end;
  
  /// Выход/предупреждение
  if (mousebutton = 1) and (not isWarning) 
  and (x > Trunc(ScreenWidth / 50)) 
  and (x < Trunc(ScreenWidth / 50) * 8)
  and (y > Trunc(ScreenHeight / 50)) 
  and (y < Trunc(ScreenHeight / 50) * 5) then
  begin
    isWarning := True;
    isRedactorForNewMaze := False;
    isRedactorForGeneratedMaze := False;
    drawButtonWarning();
  end
  
  /// Выход/да
  else if (mousebutton = 1) and (isWarning)
  and (x > Trunc(ScreenWidth / 50))
  and (x < (Trunc(ScreenWidth / 50) + Trunc(ScreenWidth / 50) / 2 * 7))
  and (y > (ScreenHeight / 50) * 3)
  and (y < (Trunc(ScreenHeight / 50) * 3 + Trunc(ScreenHeight / 50) * 3 / 3 * 2)) then
  begin
    ClearWindow();
    NormalizeWindow();
    drawWindowRedactorMaze();
    clearMaze();
    isWarning := False;
    isSetStart := False;
    isSetFinish := False;
    isRedactorForNewMaze := False;
    isRedactorForGeneratedMaze := False;
  end
  
  /// Выход/нет
  else if (mousebutton = 1) and (isWarning)
  and (x > (Trunc((ScreenWidth / 50) / 2) * 9))
  and (x < ((Trunc((ScreenWidth / 50) / 2) * 9) + Trunc((Trunc((ScreenWidth / 50) / 2) * 9) / 9) * 7))
  and (y > Trunc(ScreenHeight / 50) * 3)
  and (y < (Trunc(ScreenHeight / 50) * 3 + Trunc(ScreenHeight / 50) * 3 / 3 * 2)) then
  begin
    drawButtonExit();
    isWarning := False;
  end
end;

/// Процедура создания пустого лабиринта
procedure createEmptyMaze();
var
  x, y: integer;
begin
  for x := 1 to width - 1 do
    for y := 1 to height - 1 do
    begin
      maze[x, y] := 1
    end;
  for x := 0 to width  do
  begin
    maze[x, 0] := 0;
    maze[x, height] := 0;
  end;
  for y := 0 to height  do
  begin
    maze[width, y] := 0;
    maze[0, y] := 0;
  end;
end;

/// Процедура отрисовки последнего состояния лабиринта
procedure drawLastMaze();
var
  x, y: integer;
begin
  for x := 1 to width - 1 do
  begin
    for y := 1 to height - 1 do
    begin
      if maze[x, y] = 2 then
      begin;
        sx := x;
        sy := y;
      end;
      if maze[x, y] = 3 then
      begin;
        fx := x;
        fy := y;
      end;
    end;
  end;
  isSetFinish := True;
  isSetStart := True;
  
  ClearWindow();
  MaximizeWindow();
  FillArea(); 
  drawMaze();
  drawMazeStart(fx, fy);
  drawMazeFinish(sx, sy);
  drawMazeGrid();
  drawButtonExit();
  drawButtonsForRedaction();
  drawButtonSave();
  
  OnMouseDown := redactorMazeOnMouseDown;
end;

/// Процедура отрисовки меню редактирования лабиринта
procedure drawRedactor();
begin
  ClearWindow();
  MaximizeWindow();
  FillArea(); 
  if isRedactorForNewMaze then
  begin
    createEmptyMaze();
    drawMaze();
  end;
  if isRedactorForGeneratedMaze then
  begin
    generateMaze();
    isSetFinish := True;
    isSetStart := True;
    setupFinishForRandomGeneratedMap();
    drawMaze();
    drawMazeStart(fx, fy);
    drawMazeFinish(sx, sy);
    maze[sx, sy] := 2;
    maze[fx, fy] := 3;
  end;
  drawMazeGrid();
  drawButtonExit();
  drawButtonsForRedaction();
  drawButtonSave();
  OnMouseDown := redactorMazeOnMouseDown;
end;
end.