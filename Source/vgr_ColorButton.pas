{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2003 by vtkTools      }
{                                          }
{******************************************}

{ Contains @link(TvgrColorButton) - component used for represents a button that lets users select a color.
  Use TvgrColorButton to provide the 
  user with a button with drop down panel from which to select a color.
See also:
vgr_FontComboBox,vgr_ControlBar,vgr_Label}

unit vgr_ColorButton;

{$I vtk.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, vgr_Button;

const
  { Count of color buttons per width of drop down panel. }
  ColorPerX = 4;
  { Count of color buttons per height of drop down panel. }
  ColorPerY = 5;

  { Width of color button. }
  ColorBoxWidth = 21;
  { Height of color button. }
  ColorBoxHeight = 21;

  { Width of "Other color" button. }
  OtherColorButtonWidth = 65;
  { Height of "Other color" button. }
  OtherColorButtonHeight = 21;
  { Height of "Transparent" button. }
  TransparentButtonHeight = 21;

  { Default caption of "Other color" button. }
  svgrOtherColor = 'Other...';
  { Default caption of "Transparent" button. }
  svgrTransparentColor = 'Transparent';

type
  TvgrColorButton = class;
{ Specifies type of place within drop down panel.
Syntax:
  TvgrButtonType = (vgrbtNone, vgrbtColorBox, vgrbtOtherColorBox,
                               vgrbtOtherColor, vgrbtTransparent);
Items:
  vgrbtNone - within empty space
  vgrbtColorBox - within one of color buttons
  vgrbtOtherColorBox - within other color box
  vgrbtOtherColor - within "Other color" button
  vgrbtTransparent - within "Transparent" button}
  TvgrButtonType = (vgrbtNone, vgrbtColorBox, vgrbtOtherColorBox, vgrbtOtherColor, vgrbtTransparent);
{
This event is called when user select a color.
Syntax:
  TvgrColorSelectedEvent = procedure (Sender: TObject; Color: TColor) of object
Parameters:
  Sender -  indicates which component received the event and therefore called the handler
  Color - color that the user selects
}
  TvgrColorSelectedEvent = procedure (Sender: TObject; Color: TColor) of object;

  /////////////////////////////////////////////////
  //
  // TvgrColorPaletteForm
  //
  /////////////////////////////////////////////////
{TvgrColorPaletteForm implements drop down panel, which are showing when user click on TvgrColorButton.
Also this form can be shown separately, with use of a PopupPaletteForm method. }
  TvgrColorPaletteForm = class(TvgrDropDownForm)
    ColorDialog: TColorDialog;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ColorDialogShow(Sender: TObject);
  private
    { Private declarations }
    FSelectedColor: TColor;
    FOtherColor: TColor;
    FOtherString: string;
    FTransparentString: string;
    FOnColorSelected: TvgrColorSelectedEvent;

    FLastButtonType: TvgrButtonType;
    FLastColorButtonPos: TPoint;

    FColorButtonsRect: TRect;
    FOtherColorButtonRect: TRect;
    FOtherColorBox: TRect;
    FTransparentButtonRect: TRect;

    function GetSelectedColor : TColor;
    function IsColorExists(var AColor: TColor): Boolean;
    function GetColorButtonRect(const AColorButtonPos: TPoint): TRect;
    function GetButtonRect(AButtonType: TvgrButtonType; const AColorButtonPos: TPoint): TRect;
    procedure SetSelectedColor(Value : TColor);
    procedure SetOtherColor(Value : TColor);
    procedure GetPointInfoAt(const APos: TPoint; var AButtonType: TvgrButtonType; var AColorButtonPos: TPoint);
    procedure DrawButton(AButtonType: TvgrButtonType; const AColorButtonPos : TPoint; Selected, Highlighted : boolean);
    function GetButton: TvgrColorButton;
  protected
    property Button: TvgrColorButton read GetButton;
  public
    { Specifies current selected color.
      If user click on "Transparent" button, SelectedColor equals clNone. }
    property SelectedColor : TColor read GetSelectedColor write SetSelectedColor;
    { Specifies color, selected with "other color" button. }
    property OtherColor : TColor read FOtherColor write SetOtherColor;
    { Specifies caption of "Other color" button. Default value - "Other...". }
    property OtherString : string read FOtherString write FOtherString;
    { Specifies caption of "Transparent" button. Default value - "Transparent". }
    property TransparentString : string read FTransparentString write FTransparentString;
    { Occurs when user select color, by pressing color button or select color in dialog window. }
    property OnColorSelected : TvgrColorSelectedEvent read FOnColorSelected write FOnColorSelected;
  end;

  /////////////////////////////////////////////////
  //
  // TvgrColorButton
  //
  /////////////////////////////////////////////////
  {TvgrColorButton represents a button that lets users select a color.
Use TvgrColorButton to provide the user with a button with drop down panel
from which to select a color.
Use the SelectedColor property to access the color that the user selects.}
  TvgrColorButton = class(TvgrBaseButton)
  private
    FSelectedColor: TColor;
    FOtherColor: TColor;
    FOnColorSelected: TvgrColorSelectedEvent;
    FOtherString: string;
    FTransparentString: string;

    procedure SetSelectedColor(Value: TColor);
    procedure SetOtherColor(Value: TColor);
    procedure DoOnColorSelected(Sender: TObject; Color: TColor);
    function IsOtherStringStored: Boolean;
    function IsTransparentStringStored: Boolean;

    function GetDropDownForm: TvgrColorPaletteForm;
  protected
    function GetDropDownFormClass: TvgrDropDownFormClass; override;
    procedure ShowDropDownForm; override;
    procedure DrawButtonInternal(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean; const AInternalRect: TRect); override;

    property DropDownForm: TvgrColorPaletteForm read GetDropDownForm;
  public
{Creates an instance of the TvgrColorButton class.
Parameters:
  AOwner - Component that is responsible for freeing the button.
It becomes the value of the Owner property.}
    constructor Create(AOwner : TComponent); override;
{Frees an instance of the TvgrColorButton class.}
    destructor Destroy; override;
{Simulates a mouse click, as if the user had clicked the button.}    
    procedure Click; override;
  published
    property Action;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
{$IFDEF VGR_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

{Specifies the value indicating whether the arrow is visible.}
    property DropDownArrow default True;
{Use SelectedColor to get or set the selected color as a TColor value.
If user click on "Transparent" button, SelectedColor equals clNone. }
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor;
{Use OtherColor to get or set the color showing on other color box.}
    property OtherColor: TColor read FOtherColor write SetOtherColor;
{Specifies caption of "Other color" button. Default value - "Other...".}
    property OtherString: string read FOtherString write FOtherString stored IsOtherStringStored;
{Specifies caption of "Transparent" button. Default value - "Transparent".}
    property TransparentString: string read FTransparentString write FTransparentString stored IsTransparentStringStored;
{Occurs when user select color in drop down panel, by pressing color button or select color in dialog window.}
    property OnColorSelected: TvgrColorSelectedEvent read FOnColorSelected write FOnColorSelected;
  end;

{ Use this metod to create and show TvgrColorPaletteForm at specified position.

   AOwner - owner for the created form
   X, Y - coordinates of the created form
          this values is relative to the screen in pixels.
   ASelectedColor - specifies initial value of TvgrColorPaletteForm.SelectedColor property.
   AOtherColor - specifies initial value of TvgrColorPaletteForm.OtherColor property.
   OnColorSelected - specifies event procedure, which are called when user select color.
   AOtherString - caption for "Other color" button.
   ATransparentString - caption for "Transparent" button.

   Function returns reference to the created form. }
function PopupPaletteForm(AOwner: TComponent;
                          X, Y : integer;
                          ASelectedColor, AOtherColor : TColor;
                          OnColorSelected : TvgrColorSelectedEvent;
                          const AOtherString, ATransparentString : string) : TvgrColorPaletteForm;

implementation

uses
  vgr_GUIFunctions, vgr_Functions;

const
  LeftOffset = 2;
  RightOffset = 2;
  TopOffset = 2;
  BottomOffset = 2;
  DeltaXOffset = 2;
  DeltaYOffset = 2;
  
var
  aColors : array [0..ColorPerY - 1, 0..ColorPerX - 1] of TColor =
            ((clWhite,clBlack,clSilver,clGray),
             (clRed,clMaroon,clYellow,clOlive),
             (clLime,clGreen,clAqua,clTeal),
             (clBlue,clNavy,clFuchsia,clPurple),
             (clBtnFace,clHighlight,clBtnHighlight,clInactiveCaption));
{$R *.DFM}

function PopupPaletteForm(AOwner: TComponent;
                          X, Y : integer;
                          ASelectedColor, AOtherColor : TColor;
                          OnColorSelected : TvgrColorSelectedEvent;
                          const AOtherString, ATransparentString : string) : TvgrColorPaletteForm;
var
  R: TRect;
begin
  Result := TvgrColorPaletteForm.Create(AOwner);
  Result.OtherColor := AOtherColor;
  Result.SelectedColor := ASelectedColor;
  Result.OtherString := AOtherString;
  Result.TransparentString := ATransparentString;
  Result.OnColorSelected := OnColorSelected;

  SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);
  if X + Result.Width > r.Right then
    X := X - Result.Width;
  if Y + Result.Height > r.Bottom then
    Y := Y - Result.Height;
  Result.Left := X;
  Result.Top := Y;
  Result.Show;
end;

//////////////////////////////
//
// TvgrColorButton
//
//////////////////////////////
constructor TvgrColorButton.Create(AOwner : TComponent);
begin
  inherited;
  DropDownArrow := True;
  Width := 45;
  Height := 22;
  TabStop := true;
  FOtherString := svgrOtherColor;
  FTransparentString := svgrTransparentColor;
end;

destructor TvgrColorButton.Destroy;
begin
  inherited;
end;

function TvgrColorButton.IsOtherStringStored: Boolean;
begin
  Result := FOtherString <> svgrOtherColor;
end;

function TvgrColorButton.IsTransparentStringStored: Boolean;
begin
  Result := FTransparentString <> svgrTransparentColor;
end;

procedure TvgrColorButton.SetSelectedColor(Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    Invalidate;
  end;
end;

procedure TvgrColorButton.SetOtherColor(Value: TColor);
begin
  if FOtherColor <> Value then
  begin
    FOtherColor := Value;
  end;
end;

function TvgrColorButton.GetDropDownForm: TvgrColorPaletteForm;
begin
  Result := TvgrColorPaletteForm(inherited DropDownForm);
end;

function TvgrColorButton.GetDropDownFormClass: TvgrDropDownFormClass;
begin
  Result := TvgrColorPaletteForm;
end;

procedure TvgrColorButton.ShowDropDownForm;
begin
  inherited;

  DropDownForm.OnColorSelected := DoOnColorSelected;
  DropDownForm.OtherColor := OtherColor;
  DropDownForm.SelectedColor := SelectedColor;
  DropDownForm.OtherString := OtherString;
  DropDownForm.TransparentString := TransparentString;
end;

procedure TvgrColorButton.DrawButtonInternal(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean; const AInternalRect: TRect);
var
  r: TRect;
  nbr: HBRUSH;
begin
  r := AInternalRect;
  if APushed then
  begin
    r.Top := r.Top + 1;
    r.Left := r.Left + 1;
  end;

  // draw color box
  if FSelectedColor<>clNone then
  begin
    R.Right := R.Right - 4;
    R.Left := R.Left + 2;
    DrawInnerBorder(ADC, r, false);

    nbr := CreateSolidBrush(GetRGBColor(SelectedColor));
    FillRect(ADC, R, nbr);
    DeleteObject(nbr);
  end;
end;

procedure TvgrColorButton.DoOnColorSelected(Sender: TObject; Color: TColor);
begin
  OtherColor := DropDownForm.OtherColor;
  SelectedColor := Color;
  if Assigned(OnColorSelected) then
    OnColorSelected(Self, SelectedColor);
end;

procedure TvgrColorButton.Click;
begin
  ShowDropDownForm;
  inherited;
end;

/////////////////////////////////////////////////
//
// TprColorPaletteForm
//
/////////////////////////////////////////////////
function TvgrColorPaletteForm.GetSelectedColor;
begin
  if FSelectedColor <> clNone then
    Result := GetRGBColor(FSelectedColor)
  else
    Result := FSelectedColor;
end;

function TvgrColorPaletteForm.IsColorExists(var AColor: TColor): Boolean;
var
  I, J: integer;
begin
  for I := 0 to ColorPerX - 1 do
    for J := 0 to ColorPerY - 1 do
      if GetRGBColor(aColors[J, I]) = AColor then
      begin
        AColor := AColors[J, I];
        Result := True;
        exit;
      end;
  Result := False;
end;

function TvgrColorPaletteForm.GetColorButtonRect(const AColorButtonPos: TPoint): TRect;
begin
  Result.Left := LeftOffset + AColorButtonPos.X * (ColorBoxWidth + DeltaXOffset);
  Result.Top := TopOffset + AColorButtonPos.Y * (ColorBoxHeight + DeltaYOffset);
  Result.Right := Result.Left + ColorBoxWidth;
  Result.Bottom := Result.Top + ColorBoxHeight;
end;

function TvgrColorPaletteForm.GetButtonRect(AButtonType: TvgrButtonType; const AColorButtonPos: TPoint): TRect;
begin
  case AButtonType of
    vgrbtColorBox: Result := GetColorButtonRect(AColorButtonPos);
    vgrbtOtherColorBox: Result := FOtherColorBox;
    vgrbtOtherColor: Result := FOtherColorButtonRect;
    vgrbtTransparent: Result := FTransparentButtonRect; 
  else
    Result := Rect(0, 0, 0, 0);
  end;
end;

procedure TvgrColorPaletteForm.SetSelectedColor(Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    if not IsColorExists(Value) then
      FOtherColor := Value;
    FSelectedColor := Value;
    Invalidate;
  end;
end;

procedure TvgrColorPaletteForm.SetOtherColor;
begin
  if FOtherColor <> Value then
  begin
    FOtherColor := Value;
    Invalidate;
  end;
end;

procedure TvgrColorPaletteForm.GetPointInfoAt(const APos: TPoint; var AButtonType: TvgrButtonType; var AColorButtonPos: TPoint);
begin
  if PtInRect(FColorButtonsRect, APos) then
  begin
    AButtonType := vgrbtColorBox;
    AColorButtonPos.X := (APos.X - LeftOffset) div (ColorBoxWidth + DeltaXOffset);
    AColorButtonPos.Y := (APos.Y - TopOffset) div (ColorBoxHeight + DeltaYOffset);
  end
  else
    if PtInRect(FOtherColorBox, APos) then
      AButtonType := vgrbtOtherColorBox
    else
      if PtInRect(FOtherColorButtonRect, APos) then
        AButtonType := vgrbtOtherColor
      else
        if PtInRect(FTransparentButtonRect, APos) then
          AButtonType := vgrbtTransparent
        else
          AButtonType := vgrbtNone;
end;

function TvgrColorPaletteForm.GetButton: TvgrColorButton;
begin
  Result := TvgrColorButton(inherited Button);
end;

procedure TvgrColorPaletteForm.DrawButton(AButtonType: TvgrButtonType; const AColorButtonPos : TPoint; Selected, Highlighted : boolean);
var
  r: TRect;

  procedure DrawColorBox(Color: TColor);
  begin
    Canvas.Brush.Color := clBtnFace;
    Canvas.FillRect(r);
    if Selected or Highlighted then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.FrameRect(r);
        InflateRect(r,-1,-1);
      end;
    if Highlighted then
      begin
        Canvas.Brush.Color := clBtnHighlight;
        Canvas.FillRect(r);
      end;
    InflateRect(r,-4,-4);
    Canvas.Brush.Color := clHighlight;
    Canvas.FrameRect(r);
    InflateRect(r,-1,-1);
    Canvas.Brush.Color := Color;
    Canvas.FillRect(r);
  end;

  procedure DrawPushButton(const s : string);
  begin
    if Selected or Highlighted then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.FrameRect(r);
        InflateRect(r,-1,-1);
      end;
    if Highlighted then
      Canvas.Brush.Color := clBtnHighlight
    else
      Canvas.Brush.Color := clBtnFace;
    Canvas.FillRect(r);
    DrawText(Canvas.Handle,PChar(s),length(s),r,DT_CENTER	or DT_VCENTER or DT_SINGLELINE);
  end;

begin
  case AButtonType of
    vgrbtColorBox:
      begin
        R := GetColorButtonRect(AColorButtonPos);
        DrawColorBox(aColors[AColorButtonPos.y, AColorButtonPos.x]);
      end;
    vgrbtOtherColorBox:
      begin
        R := FOtherColorBox;
        DrawColorBox(FOtherColor);
      end;
    vgrbtOtherColor:
      begin
        R := FOtherColorButtonRect;
        DrawPushButton(FOtherString);
      end;
    vgrbtTransparent:
      begin
        R := FTransparentButtonRect;
        DrawPushButton(FTransparentString);
      end;
  end;
end;

procedure TvgrColorPaletteForm.FormPaint(Sender: TObject);
var
  r: TRect;
  I, J: integer;
begin
  Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(ClientRect);
  
  for I := 0 to ColorPerX - 1 do
    for J := 0 to ColorPerY - 1 do
      DrawButton(vgrbtColorBox, Point(I, J),
                 aColors[J, I] = FSelectedColor,
                 (FLastButtonType = vgrbtColorBox) and
                 (FLastColorButtonPos.X = I) and (FLastColorButtonPos.Y = J));

  r := Rect(FColorButtonsRect.Left,
            FColorButtonsRect.Bottom + 5,
            FColorButtonsRect.Right,
            FColorButtonsRect.Bottom + 5);
  DrawEdge(Canvas.Handle, r, EDGE_ETCHED, BF_TOP);

  DrawButton(vgrbtOtherColorBox, Point(0, 0), FSelectedColor = FOtherColor, FLastButtonType = vgrbtOtherColorBox);

  DrawButton(vgrbtOtherColor, Point(0, 0), False, FLastButtonType = vgrbtOtherColor);

  DrawButton(vgrbtTransparent, Point(0, 0), FSelectedColor = clNone, FLastButtonType = vgrbtTransparent);
end;

procedure TvgrColorPaletteForm.FormCreate(Sender: TObject);
begin
  FOtherString := svgrOtherColor;
  FTransparentString := svgrTransparentColor;

  FColorButtonsRect := Rect(LeftOffset,
                            TopOffset,
                            LeftOffset + ColorPerX * ColorBoxWidth + (ColorPerX - 1) * DeltaXOffset,
                            TopOffset + ColorPerY * ColorBoxHeight+ (ColorPerY - 1) * DeltaYOffset);
  FOtherColorButtonRect := Rect(LeftOffset,
                                FColorButtonsRect.Bottom + 10,
                                LeftOffset + OtherColorButtonWidth,
                                FColorButtonsRect.Bottom + 10 + OtherColorButtonHeight);
  FOtherColorBox := Rect(FColorButtonsRect.Right - ColorBoxWidth,
                         FColorButtonsRect.Bottom + 10,
                         FColorButtonsRect.Right,
                         FColorButtonsRect.Bottom + 10 + ColorBoxHeight);
  FTransparentButtonRect := Rect(FColorButtonsRect.Left,
                                 FOtherColorButtonRect.Bottom + 4,
                                 FColorButtonsRect.Right,
                                 FOtherColorButtonRect.Bottom + 4 + TransparentButtonHeight);

  ClientWidth := FColorButtonsRect.Right + RightOffset;
  ClientHeight := FTransparentButtonRect.Bottom + BottomOffset
end;

procedure TvgrColorPaletteForm.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ANewColorButtonPos: TPoint;
  ANewButtonType: TvgrButtonType;
  ARect: TRect;
begin
  GetPointInfoAt(Point(X, Y), ANewButtonType, ANewColorButtonPos);
  if (FLastButtonType = ANewButtonType) and
     ((FLastButtonType <> vgrbtColorBox) or
      ((FLastColorButtonPos.x = ANewColorButtonPos.X) and
       (FLastColorButtonPos.y = ANewColorButtonPos.Y))) then exit;

  ARect := GetButtonRect(FLastButtonType, FLastColorButtonPos);

  FLastButtonType := ANewButtonType;
  FLastColorButtonPos := ANewColorButtonPos;

  InvalidateRect(Handle, @ARect, False);
  if FLastButtonType <> vgrbtNone then
  begin
    ARect := GetButtonRect(FLastButtonType, FLastColorButtonPos);
    InvalidateRect(Handle, @ARect, False);
  end;
end;

procedure TvgrColorPaletteForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ANewColorButtonPos : TPoint;
  ANewButtonType : TvgrButtonType;
  Color : TColor;
begin
  GetPointInfoAt(Point(X,Y), ANewButtonType, ANewColorButtonPos);
  if ANewButtonType = vgrbtNone then exit;

  Color := clWhite;
  case ANewButtonType of
    vgrbtColorBox: Color := aColors[ANewColorButtonPos.Y, ANewColorButtonPos.X];
    vgrbtOtherColorBox: Color := FOtherColor;
    vgrbtOtherColor:
      begin
        ColorDialog.Color := FOtherColor;
        if not ColorDialog.Execute then
          exit;
        Color := ColorDialog.Color;
        OtherColor := Color;
      end;
    vgrbtTransparent: Color := clNone;
  end;
  
  SelectedColor := Color;
  if Assigned(FOnColorSelected) then
    FOnColorSelected(Self, SelectedColor);
  Close;
end;

procedure TvgrColorPaletteForm.ColorDialogShow(Sender: TObject);
begin
  SetWindowPos(ColorDialog.Handle,
               HWND_TOPMOST,
               0, 0, 0, 0,
               SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

end.
