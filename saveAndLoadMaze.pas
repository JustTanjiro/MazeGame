Unit saveAndLoadMaze;

interface

Uses GraphABC;
Uses mazeData;

procedure saveMazeToFile(fileName: string);
procedure loadMazeFromFile(fileName: string);

implementation

/// Процедура сохранения лабиринта в файл
procedure saveMazeToFile(fileName: string);
var
  f: TextFile;
  x, y: Integer;
begin
  AssignFile(f, GetCurrentDir + '\Лабиринты\' + fileName);
  Rewrite(f);
  
  // записываем размеры лабиринта в первую строку файла
  Writeln(f, width, ' ', height);
  // записываем значения ячеек лабиринта построчно
  for x := 0 to width do
  begin
    for y := 0 to height do
    begin  
      Write(f, maze[x, y], ' ');
    end;
    WriteLn(f);  
  end;
  CloseFile(f);
  
  AssignFile(f, GetCurrentDir + '\Лабиринты\Список лабиринтов.txt');
  Append(f);
  
  Writeln(f, fileName);
  
  CloseFile(f);
end;

/// Процедура загрузки лабиринта из файла
procedure loadMazeFromFile(fileName: string);
var
  f: TextFile;
  x, y: integer;
  line: string;
begin
  AssignFile(f, GetCurrentDir + '\Лабиринты\' + fileName);
  Reset(f);
  
  // считываем размеры лабиринта из первой строки файла
  Readln(f, width, height);
  // считываем значения ячеек лабиринта построчно
  for x := 0 to width do
    for y := 0 to height do
      Read(f, maze[x, y]);
  
  CloseFile(f);
end;
end.