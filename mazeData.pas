unit mazeData;

interface

Uses GraphABC, Window_Game;

const
  size = 12; /// размер клетки
  offsetY = Trunc(ScreenHeight / 9); /// смещение лабиринта по оси Y
  MAXWIDTH = 300; /// максимальная длина лабиринта
  MAXHEIGHT = 300; /// максимальная ширина лабиринта

var
  sx, sy, fx, fy: integer;
  offsetX: integer;
  width, height: integer;
  maze: array[0..MAXWIDTH, 0..MAXHEIGHT] of integer;

procedure drawMaze();
procedure drawMazeGrid();
procedure drawMazeStart(fx, fy: integer);
procedure drawMazeFinish(sx, sy: integer);
procedure fillCell(x, y: integer; clBrush: Color);

implementation

Uses inputPanel;

/// Процедура закрашивания клетки
procedure fillCell(x, y: integer; clBrush: Color);
begin
  SetPenWidth(0);
  SetBrushColor(clBrush);
  Rectangle(x * Size + offsetX, y * Size + offsetY, (x + 1) * Size + offsetX, (y + 1) * Size + offsetY);
end;

/// Процедура отрисовки лабиринта
procedure drawMaze();
var
  i, j, maxCell: integer;
begin
  offsetX := Trunc((ScreenWidth - (WIDTH + 2) * Size) / 2);
  LockDrawing();
  fillCell(sx, sy, clBlue);
  for i := 0 to WIDTH do
  begin
    for j := 0 to HEIGHT do
    begin
      if maze[i, j] = 0 then
      begin
        SetBrushColor(clBlack);
      end
      else 
      begin
        SetBrushColor(clWhite);
      end;
      FillRect(i * Size + offsetX, j * Size + offsetY, (i + 1) * Size + offsetX, (j + 1) * Size + offsetY);
    end;
  end;
  unLockDrawing();
end;

/// Процедура отрисовки старта
procedure drawMazeStart(fx, fy: integer);
begin
  fillCell(fx, fy, clRed);
  FloodFill(0, 0, RGB(138, 149, 151));
end;

/// Процедура установки финиша
procedure drawMazeFinish(sx, sy: integer);
begin
  fillCell(sx, sy, clBlue);
  FloodFill(0, 0, RGB(138, 149, 151));
end;

/// Процедура отрисовки сетки лабиринта
procedure drawMazeGrid();
var
  i, j: integer;
begin
  LockDrawing();
  for i := 0 to (WIDTH + 1) do
  begin
    Line(i * size + offsetX, offsetY, i * size + offsetX, (Height + 1) * size + offsetY);
  end;
  for j := 0 to (HEIGHT + 1) do
  begin
    Line(offsetX, j * size + offsetY, (Width + 1) * size + offsetX, j * size + offsetY);  
  end;
  unLockDrawing();
  SetPenColor(clBlack);
end;
end. 