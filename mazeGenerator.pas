unit mazeGenerator;

interface

Uses GraphABC;
Uses UI, mazeData, Window_Game;

procedure generateMaze();

implementation

Uses inputPanel;

/// Процедура удаление рандомных стен из лабиринта
procedure removeRandomWalls();
var
  i, n: integer;
  x, y: integer;
  good: boolean;
begin
  n := width * height div 35;
  for i := 1 to n do
  begin
    x := random(1, inputWidth - 1) * 2;
    y := random(1, inputHeight - 1) * 2;
    if not ((x div 2) = 1) and not ((y div 2) = 1) then
    begin
      if random(0, 1) = 1 then
        x += 1
      else
        y += 1;
      if maze[x, y] = 0 then
      begin
        good := (maze[x - 1, y] <> 0) and (maze[x + 1, y] <> 0) and (maze[x, y + 1] = 0) and (maze[x, y - 1] = 0);
        good := good or (maze[x - 1, y] = 0) and (maze[x + 1, y] = 0) and (maze[x, y + 1] <> 0) and (maze[x, y - 1] <> 0);
        if good then
          maze[x, y] := integer.MaxValue DIV 2;
      end;
    end;
  end;
end;

/// Процедура генерации лабиринта
procedure generateMaze();
var
  k, n, x, y, countCell, offsetX: integer;
  dirs: array[1..4] of integer;
  dirscount: integer;
begin
  sx := random(0, inputWidth - 1) * 2 + 1;
  sy := random(0, inputHeight - 1) * 2 + 1;
  offsetX := Trunc((ScreenWidth - (width + 2) * Size) / 2);
  width := inputWidth * 2;
  height := inputHeight * 2;
  onResize := redraw;
  for k := 0 to WIDTH do
    for n := 0 to HEIGHT do
      maze[k, n] := 0;
  countCell := 1;
  x := sx;
  y := sy;
  maze[x, y] := countCell;
  repeat
    dirscount := 0;
    if ((y - 2) >= 1) and (maze[x, y - 2] = 0) then
    begin
      dirscount += 1;
      dirs[dirscount] := 2;
    end;
    if ((y + 2) <= HEIGHT) and (maze[x, y + 2] = 0) then
    begin
      dirscount += 1;
      dirs[dirscount] := 1;
    end;
    if ((x - 2) >= 1) and (maze[x - 2, y] = 0) then
    begin
      dirscount += 1;
      dirs[dirscount] := 4;
    end;
    if ((x + 2) <= WIDTH) and (maze[x + 2, y] = 0) then
    begin
      dirscount += 1;
      dirs[dirscount] := 3;
    end;
    if dirscount = 0 then
    begin
      if ((y - 2) >= 1) and (maze[x, y - 2] = countCell - 1) then
      begin
        y -= 2;
        countCell -= 1;
      end
      else if ((y + 2) <= HEIGHT) and  (maze[x, y + 2] = countCell - 1) then
      begin
        y += 2;
        countCell -= 1;
      end
      else if ((x - 2) >= 1) and (maze[x - 2, y] = countCell - 1) then
      begin
        x -= 2;
        countCell -= 1;
      end
      else if ((x + 2) <= WIDTH) and (maze[x + 2, y] = countCell - 1) then
      begin
        x += 2;
        countCell -= 1;
      end;
    end
    else
    begin
      case dirs[random(1, dirscount)] of
        1:
          begin
            maze[x, y + 1] := countCell + 1;
            maze[x, y + 2] := countCell + 1;
            y += 2;
          end;
        2:
          begin
            maze[x, y - 1] := countCell + 1;
            maze[x, y - 2] := countCell + 1;
            y -= 2;
          end;
        3:
          begin
            maze[x + 1, y] := countCell + 1;
            maze[x + 2, y] := countCell + 1;
            x += 2;
          end;
        4:
          begin
            maze[x - 1, y] := countCell + 1;
            maze[x - 2, y] := countCell + 1;
            x -= 2;
          end;
      end;
      countCell += 1;
    end;
  until not (maze[x, y] <> 1);
  removeRandomWalls();
  if isRedactor then
  begin
    for k := 0 to width do
    begin
      for n := 0 to height do
      begin
        if maze[k, n] <> 0 then
          maze[k, n] := 1
      end;
    end;
  end;
end;
begin
  offsetX := Trunc((ScreenWidth - (width + 2) * size) / 2) - (width * size); /// смещение лабиринта по оси X
end.