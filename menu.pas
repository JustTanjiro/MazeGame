unit Menu;

interface

uses graphABC;
uses UI;
Uses Window_Game, windowHelper;

procedure drawMenu();

implementation

/// Процедура установки имени окна главного меню
procedure drawTitle();
begin
  OnKeyDown := nil;
  CenterWindow();
  SetWindowIsFixedSize(true);
end;

/// Процедура отрисовки кнопки 'Игра'
procedure drawButtonGame();
var
  game: Button;
begin
  game := CreateButton(200, 100, 400, 100, 'Игра', RGB(0, 102, 51), RGB(24, 21, 19), 28);
  drawButton(game);
end;

/// Процедура отрисовки кнопки 'Справка'
procedure drawButtonHelp();
var
  help: Button;
begin
  help := CreateButton(275, 225, 250, 80, 'Справка', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(help);
end;

/// Процедура отрисовки кнопки 'Выход'
procedure drawButtonExit();
var
  exite: Button;
begin
  exite := CreateButton(275, 325, 250, 80, 'Выход', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(exite);
end;

/// Процедура для обработки нажатия на ЛКМ для кнопок
/// 'Нет', 'Да'
procedure exitOnMouseDown(x, y, mousebutton: integer);
begin
  
  /// Обработка кнопки 'Нет'
  if (mousebutton = 1) and (x > 275) and (x < 525) and (y > 225) and (y < 305) then
  begin
    clearwindow;
    drawMenu();
  end;
  
  /// Обработка кнопки 'Да'
  if (mousebutton = 1) and (x > 275) and (x < 525) and (y > 325) and (y < 405) then
  begin
    Halt();
  end;
  
end;

/// Процедура отрисовки окна выхода из программы
procedure drawButtonWarning();
var
  warning, yes, no: Button;
begin
  ClearWindow();
  fillArea();
  OnMouseDown := exitOnMouseDown;
  warning := CreateButton(200, 100, 400, 100, 'Вы уверены?', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(warning);
  no := CreateButton(275, 225, 250, 80, 'Нет', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(no);
  yes := CreateButton(275, 325, 250, 80, 'Да', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(yes);
end;

/// Процедура для обработки нажатия на ЛКМ для кнопок
/// 'Игра', 'Настройки', 'Справка', 'Выход'
procedure MenuOnMouseDown(x, y, mousebutton: integer);
begin
  
  /// Обработка кнопки 'Игра'
  if (mousebutton = 1) and (x > 200) and (x < 600) and (y > 100) and (y < 200) then
  begin
    clearwindow;
    WindowGame();
  end;
  
  /// Обработка кнопки 'Справка'
  if (mousebutton = 1) and (x > 275) and (x < 525) and (y > 225) and (y < 305) then
  begin
    clearwindow;
    drawWindowHelper();
  end;
  
  /// Обработка кнопки 'Выход'
  if (mousebutton = 1) and (x > 275) and (x < 525) and (y > 325) and (y < 405) then
  begin
    drawButtonWarning();
  end;
end;

/// Процедура отрисовки главного меню
procedure drawMenu();
begin
  drawTitle();
  FillArea();
  drawButtonGame();
  drawButtonHelp();
  drawButtonExit();
  OnMouseDown := MenuOnMouseDown;
end;

end.
