Unit gameInterface;

interface

Uses GraphABC;
Uses UI;
Uses mazeGenerator, mazeData, windowGameMode;

procedure drawGameInterface;
procedure drawButtonCounter(text: string);
procedure finalGame();

var
  strPlayerPath, strShortestPath, strPersentResult: string;
  WindowGame: procedure();

implementation

var
  isWarning: boolean;

/// Отрисовывает кнопку 'Выход'
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

/// Отрисовывает кнопку 'Предупреждение' (отрисовывается при нажатии на кнопку 'Выход')
procedure drawButtonWarning();
var
  warning, buttonYes, buttonNo: Button;
  x, y, w, h: integer;
begin
  SetBrushColor(RGB(138, 149, 151));
  FillRect(Trunc(ScreenWidth / 50), Trunc(ScreenHeight / 50), Trunc(ScreenWidth / 50) * 8 + 1, Trunc(ScreenHeight / 50) * 5 + 1);
  
  /// Отрисовка кнопки 'Вы уверены?'
  x := Trunc(ScreenWidth / 50);
  y := Trunc(ScreenHeight / 50);
  w := x * 7;
  h := y * 2;
  warning := CreateButton(x, y, w, h, 'Вы уверены?', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(warning);
  
  /// Отрисовка кнопки 'Да'
  x := Trunc(ScreenWidth / 50);
  y := Trunc(ScreenHeight / 50) * 3;
  w := Trunc(x / 2) * 7;
  h := Trunc(y / 3) * 2;
  buttonYes := CreateButton(x, y, w, h, 'Да', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(buttonYes);
  
  /// Отрисовка кнопки 'Нет'
  x := Trunc((ScreenWidth / 50) / 2) * 9;
  y := Trunc(ScreenHeight / 50) * 3;
  w := Trunc(x / 9) * 7;
  h := Trunc(y / 3) * 2;
  buttonNo := CreateButton(x, y, w, h, 'Нет', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(buttonNo);
end;

/// Отрисовывает кнопку 'Счетчик ходов'
procedure drawButtonCounter(text: string);
var
  counter: Button;
  x, y, w, h: integer;
begin
  x := Trunc(ScreenWidth / 50) * 9;
  y := Trunc(ScreenHeight / 50);
  w := Trunc(x / 3 * 2);
  h := y * 4;
  counter := CreateButton(x, y, w, h, text, RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(counter);
end;

/// Отрисовывает кнопку 'Победа'
procedure drawButtonWin();
var
  win: Button;
  x, y, w, h: integer;
begin
  x := Trunc(ScreenWidth / 2) - Trunc(ScreenWidth / 6);
  y := Trunc(ScreenHeight / 50);
  w := Trunc(ScreenWidth / 6);
  h := y * 4;
  win := CreateButton(x, y, w, h, 'Ты победил!', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(win);
end;

/// Отрисовывает кнопку 'Путь игрока'
procedure drawButtonPlayerPath(text: string);
var
  PlayerPath: Button;
  x, y, w, h: integer;
begin
  x := Trunc(ScreenWidth / 2);
  y := Trunc(ScreenHeight / 50);
  w := Trunc(ScreenWidth / 6);
  h := y * 2;
  PlayerPath := CreateButton(x, y, w, h, text, RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(PlayerPath);
end;

/// Отрисовывает кнопку 'Кратчайший путь'
procedure drawButtonShortestPath(text: string);
var
  ShortestPath: Button;
  x, y, w, h: integer;
begin
  x := Trunc(ScreenWidth / 2);
  y := Trunc(ScreenHeight / 50) * 3;
  w := Trunc(ScreenWidth / 6);
  h := Trunc(ScreenHeight / 50) * 2;
  ShortestPath := CreateButton(x, y, w, h, text, RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(ShortestPath);
end;

/// Отрисовывает кнопку 'Неоптимальность пути'
procedure drawButtonPersentResult(text: string);
var
  persentResult: Button;
  x, y, w, h: integer;
begin
  x := Trunc(ScreenWidth / 2) + Trunc(ScreenWidth / 4);
  y := Trunc(ScreenHeight / 50);
  w := Trunc(ScreenWidth / 6);
  h := y * 2;
  persentResult := CreateButton(x, y, w, h, 'Неоптимальность пути:', RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(persentResult);
  
  x := Trunc(ScreenWidth / 2) + Trunc(ScreenWidth / 4);
  y := Trunc(ScreenHeight / 50) * 3;
  w := Trunc(ScreenWidth / 6);
  h := Trunc(ScreenHeight / 50) * 2;
  persentResult := CreateButton(x, y, w, h, text, RGB(0, 102, 51), RGB(24, 21, 19), 16);
  drawButton(persentResult);
end;

/// Процедура для обработки нажатия на ЛКМ для кнопок 
/// 'Предупреждение', 'Предупреждение / да', 'Предупреждение / нет'
procedure gameInterfaceOnMouseDown(x, y, mousebutton: integer);
begin
  
  /// Обработка кнопки 'Предупреждение'
  if (mousebutton = 1) and (not isWarning) 
  and (x > Trunc(ScreenWidth / 50)) 
  and (x < Trunc(ScreenWidth / 50) * 8)
  and (y > Trunc(ScreenHeight / 50)) 
  and (y < Trunc(ScreenHeight / 50) * 5) then
  begin
    isWarning := true;
    drawButtonWarning();
  end
  
  /// Обработка кнопки 'Предупреждение / да'
  else if (mousebutton = 1) and (isWarning)
  and (x > Trunc(ScreenWidth / 50))
  and (x < (Trunc(ScreenWidth / 50) + Trunc(ScreenWidth / 50) / 2 * 7))
  and (y > (ScreenHeight / 50) * 3)
  and (y < (Trunc(ScreenHeight / 50) * 3 + Trunc(ScreenHeight / 50) * 3 / 3 * 2)) then
  begin
    ClearWindow();
    strPlayerPath := '';
    NormalizeWindow();
    drawWindowGameMode();
    isWarning := False;
  end
  
  /// Обработка кнопки 'Предупреждение / нет'
  else if (mousebutton = 1) and (isWarning)
  and (x > (Trunc((ScreenWidth / 50) / 2) * 9))
  and (x < ((Trunc((ScreenWidth / 50) / 2) * 9) + Trunc((Trunc((ScreenWidth / 50) / 2) * 9) / 9) * 7))
  and (y > Trunc(ScreenHeight / 50) * 3)
  and (y < (Trunc(ScreenHeight / 50) * 3 + Trunc(ScreenHeight / 50) * 3 / 3 * 2)) then
  begin
    drawButtonExit();
    isWarning := false;
  end;
end;

/// Процедура отрисовки игрового интерфейса
procedure drawGameInterface();
begin
  ClearWindow();
  MaximizeWindow();
  FillArea(); 
  drawButtonExit();
  drawButtonCounter('Ходов: 0');
  OnMouseDown := gameInterfaceOnMouseDown;
end;

/// Процедура отрисовки результатов игры 
procedure finalGame();
begin
  SetBrushColor(RGB(138, 149, 151));
  FillRect(Trunc(ScreenWidth / 50) * 9, Trunc(ScreenHeight / 50), Trunc(Trunc(ScreenWidth / 50) * 9 * 5 / 3), Trunc(ScreenHeight / 50) * 5);
  drawButtonWin();
  drawButtonPlayerPath(concat('Твой путь: ', strPlayerPath));
  drawButtonShortestPath(concat('Кратчайший: ', strShortestPath));
  drawButtonPersentResult(concat(strPersentResult, ' %'));
end;

begin
end.