Unit inputPanel;

interface

Uses GraphABC;
Uses UI;
Uses gameLogic;
Uses mazeGenerator, mazeData, Window_Game, windowGameMode;

procedure drawInputPanel;

var
  inputWidth, inputHeight: integer;
  strWidth, strHeight: string;
  WindowGame: procedure;
  drawRedactor: procedure;

implementation

var
  isWritingWidth, isWritingHeight, warningVisible: boolean;
  maxStrWidth, maxStrHeight, text: string;
  maxWidth, maxHeight: integer;

/// Отрисовывает кнопку 'Ввод длины'
procedure drawButtonWidth();
var
  widthButton: Button;
begin
  widthButton := CreateButton(100, 50, 250, 75, 'Введите длину:', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(widthButton);
end;

/// Отрисовывает кнопку 'Ввод ширины'
procedure drawButtonHeight();
var
  buttonHeight: Button;
begin
  buttonHeight := CreateButton(450, 50, 250, 75, 'Введите ширину:', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(buttonHeight);
end;

/// Отрисовывает кнопку 'Ввод длины', закрашенную в определенный цвет при нажатии на нее
procedure drawButtonInputWidth(text: string);
var
  InputWidth: Button;
  cl: Color;
begin
  if isWritingWidth then
    cl := RGB(200, 200, 0)
  else
    cl := RGB(0, 102, 51);
  InputWidth := CreateButton(100, 150, 250, 75, text, cl, RGB(24, 21, 19), 20);
  drawButton(InputWidth);
end;

/// Отрисовывает кнопку 'Ввод ширины', закрашенную в определенный цвет при нажатии на нее
procedure drawButtonInputHeight(text: string);
var
  InputHeight: Button;
  cl: Color;
begin
  if isWritingHeight then
    cl := Rgb(200, 200, 0)
  else
    cl := RGB(0, 102, 51);
  InputHeight := CreateButton(450, 150, 250, 75, text, cl, RGB(24, 21, 19), 20);
  drawButton(InputHeight);
end;

/// Отрисовывает кнопку 'Сгенерировать'
procedure drawButtonStartGame();
var
  StartGame: Button;
begin
  StartGame := CreateButton(250, 250, 300, 100, 'Сгенерировать', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(StartGame);
end;

/// Отрисовывает кнопку 'Назад'
procedure drawButtonBack();
var
  Back: Button;
begin
  Back := CreateButton(250, 500, 300, 50, 'Назад', RGB(0, 102, 51), RGB(24, 21, 19), 20);
  drawButton(Back);
end;

/// Процедура для обработки нажатия на ЛКМ для кнопок 
/// 'Введите длину', 'Введите ширину', 'Сгенерировать', 'Назад'
procedure inputPanelOnMouseDown(x, y, mousebutton: integer);
var
  errWidth, errHeight: integer;
begin
  
  /// Обработка кнопки 'Назад'
  if (mousebutton = 1) and (x > 250) and (x < 550) and (y > 500) and (y < 550) then
  begin
    strWidth := '';
    strHeight := '';
    ClearWindow();
    if isGame then
      drawWindowGameMode()
    else if isRedactor then
      drawWindowRedactorMaze();
    isWritingWidth := False;
    isWritingHeight := False;
    exit;
  end;
  
  /// Обработка кнопки 'Введите длину'
  if (mousebutton = 1) and (x > 100) and (x < 350) and (y > 150) and (y < 225) then
  begin
    isWritingWidth := True;
    drawButtonInputWidth(strWidth);
    if isWritingHeight then
    begin
      isWritingHeight := False;
      if strHeight = '' then
        drawButtonInputHeight(concat('Максимум - ', maxStrHeight))
      else
        drawButtonInputHeight(strHeight);
    end;
  end
  
  /// Обработка кнопки 'Введите ширину'
  else if (mousebutton = 1) and (x > 450) and (x < 600) and (y > 150) and (y < 225) then
  begin
    isWritingHeight := True;
    drawButtonInputHeight(strHeight);
    if isWritingWidth then
    begin
      isWritingWidth := False;
      if strWidth = '' then
        drawButtonInputWidth(concat('Максимум - ', maxStrWidth))
      else
        drawButtonInputWidth(strWidth);
    end;
  end
  
  /// Обработка кнопки 'Сгенерировать' для режима Игры и Редактирования
  else if (length(strWidth) <> 0) and (length(strHeight) <> 0) and (mousebutton = 1) 
  and (x > 250) and (x < 550) and (y > 250) and (y < 350) then
  begin
    
    val(strWidth, inputWidth, errWidth); 
    val(strHeight, inputHeight, errHeight);
    
    WIDTH := inputWidth * 2;
    HEIGHT := inputHeight * 2;
      
    if ((width <= 8) or (height <= 8)) then
    begin
      if (width <= 8) then
      begin
        strWidth := '';
        drawButtonInputWidth('Минимум - 5');
      end;
      if (height <= 8) then
      begin
        strHeight := '';
        drawButtonInputHeight('Минимум - 5');
      end;
    end
    
    else if (inputWidth <= maxWidth) and (inputHeight <= maxHeight) then
    begin
      
      /// Начинаем игру, если выбран режим 'Игра'
      if isGame then
      begin
        ClearWindow();
        game();
        strWidth := '';
        strHeight := '';
        isWritingWidth := False;
        isWritingHeight := False;
        exit;
      end
      
      /// Начинаем редактирование, если выбран режим 'Редактирование'
      else if isRedactor then
      begin
        ClearWindow();
        drawRedactor();
        strWidth := '';
        strHeight := '';
        isWritingWidth := False;
        isWritingHeight := False;
        exit;
      end
    end
    
    /// Обнуляем строку в вводе, если вводимая длина/ширина больше максимальных
    else
    begin
      if (inputWidth > maxWidth) then
      begin
        drawButtonInputWidth(concat('Максимум - ', maxStrWidth));
        strWidth := '';
      end;
      if (inputHeight > maxHeight) then
      begin
        drawButtonInputHeight(concat('Максимум - ', maxStrHeight));
        strHeight := '';
      end;
    end;
  end
  
  /// Обновление содержимого кнопки 'Ввод длины' при вводе нового символа
  else
  begin    
  if isWritingWidth then
    begin
      isWritingWidth := False;
      if strWidth = '' then
        drawButtonInputWidth(concat('Максимум - ', maxStrWidth))
      else
        drawButtonInputWidth(strWidth);
    end;
        if isWritingHeight then
    begin
      isWritingHeight := False;
      if strHeight = '' then
        drawButtonInputHeight(concat('Максимум - ', maxStrHeight))
      else
        drawButtonInputHeight(strHeight);
    end;
  end;
end;

/// Заполнение полей ввода длины/ширины
procedure fillInputBox(ch: char);
var
  textWidth, textHeight: string;
begin
  if (isWritingWidth = True) then
  begin
    if ((ch in ['1'..'9']) and (length(strWidth) = 0)) 
    or ((ch in ['0'..'9']) and (length(strWidth) = 1)) then
    begin
      textWidth += strWidth + ch;
      drawButtonInputWidth(textWidth);
      strWidth := textWidth;
    end;
  end;
  if (isWritingHeight = True) then
  begin
    if ((ch in ['1'..'9']) and (length(strHeight) = 0))
    or ((ch in ['0'..'9']) and (length(strHeight) = 1)) then
    begin
      textHeight += strHeight + ch;
      drawButtonInputHeight(textHeight);
      strHeight := textHeight;
    end;
  end;
end;

/// Процедура удаления и конца ввода в кнопках
/// 'Ввод длины' и 'Ввод ширины'              
procedure exitInputBox(key: integer);
begin
  if (isWritingWidth = True) then
  begin
    if (key = VK_Back) then
    begin
      Delete(strWidth, length(strWidth), 1);
      drawButtonInputWidth(strWidth);
    end;
    if (key = VK_Enter) then
    begin
      isWritingWidth := False;
    end;
  end;
  if (isWritingHeight = True) then
  begin
    if (key = VK_Back) then
    begin
      Delete(strHeight, length(strHeight), 1);
      drawButtonInputHeight(strHeight);
    end;
    if (key = VK_Enter) then
    begin
      isWritingHeight := False;
    end;
  end;
end;

/// Отрисовка окна Панели Ввода
procedure drawInputPanel();
begin
  maxWidth := Trunc(ScreenWidth / (size * 2)) - 2;
  maxHeight := Trunc(ScreenHeight / (size * 2)) - Trunc(offsetY / (size + 1));
  Str(maxWidth, maxStrWidth);
  Str(maxHeight, maxStrHeight);
  ClearWindow();
  FillArea();
  drawButtonWidth();
  drawButtonHeight();
  drawButtonInputWidth(concat('Максимум - ', maxStrWidth));
  drawButtonInputHeight(concat('Максимум - ', maxStrHeight));
  drawButtonStartGame();
  drawButtonBack();
  OnMouseDown := inputPanelOnMouseDown;
  OnKeyPress := fillInputBox;
  OnKeyDown := exitInputBox;
end;
end. 