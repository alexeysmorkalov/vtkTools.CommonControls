{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2004 by vtkTools      }
{                                          }
{******************************************}

{Contains the TvgrMultiPageButton component that represents a button that lets users select a range of pages in preview.
Use the TvgrMultiPageButton component to provide the user with a button with drop-down panel
from which he can select a pages' range.
The pages' range is specified by two parameters:
<ul>
<li>Count of pages per width</li>
<li>Count of pages per height</li>
</ul>
See also:
  TvgrMultiPageButton}

unit vgr_MultiPageButton;

{$I vtk.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls, Buttons, math, vgr_Button;

const
{Default value for caption displaying at the bottom of drop-down panel, when user
can cancel selecting of pages' range.}
  DefaultCloseCaption = 'Close';
{Default value for caption displaying at the bottom of drop-down panel, when user
can select the pages' range.}
  DefaultPagesCaption = 'Pages %d x %d';

{Specifies the default value for minimum amount of pages per width of drop-down panel.
Syntax:
  DefaultMinPagesPerX = 3;}
  DefaultMinPagesPerX = 3;
{Specifies the default value for maximum amount of pages per width of drop-down panel.
Syntax:
  DefaultMaxPagesPerX = 10;}
  DefaultMaxPagesPerX = 10;
{Specifies the default value for minimum amount of pages per height of drop-down panel.
Syntax:
  DefaultMinPagesPerY = 2;}
  DefaultMinPagesPerY = 2;
{Specifies the default value for maximum amount of pages per height of drop-down panel.
Syntax:
  DefaultMaxPagesPerY = 4;}
  DefaultMaxPagesPerY = 4;

{Width of page button.
Syntax:
  ColorBoxWidth = 24;}
  ColorBoxWidth = 24;
{Height of page button.
Syntax:
  ColorBoxHeight = 24;}
  ColorBoxHeight = 24;

type
  TvgrMultiPageButton = class;
{TvgrPagesRangeSelectedEvent is the type for TvgrMultiPageButton.OnPagesRangeSelectedEvent event.
This event occurs when user selects a pages' range.
Parameters:
  Sender - The TvgrMultiPageButton object.
  APagesRange - Specifies a selected pages' range.}
  TvgrPagesRangeSelectedEvent = procedure (Sender: TObject; const APagesRange: TPoint) of object;

  /////////////////////////////////////////////////
  //
  // TvgrMultiPagePaletteForm
  //
  /////////////////////////////////////////////////
{TvgrMultiPagePaletteForm implements drop down panel, which are showing when user click on TvgrMultiPageButton.
Also this form can be shown separately, with use of a PopupPaletteForm method.}
  TvgrMultiPagePaletteForm = class(TvgrDropDownForm)
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCloseCaption: String;
    FPagesCaption: String;
    FSelectedPagesRange: TPoint;
    FOnPagesRangeSelected: TvgrPagesRangeSelectedEvent;
    FButtonsRect: TRect;
    FCaptionRect: TRect;
    FImmediateDropDown: Boolean;
    FMinPagesPerX: Integer;
    FMaxPagesPerX: Integer;
    FMinPagesPerY: Integer;
    FMaxPagesPerY: Integer;
    FPagesPerX: Integer;
    FPagesPerY: Integer;
    FDisablePaint: Boolean;

    procedure SetImmediateDropDown(Value: Boolean);
    function GetSelectedPagesRange: TPoint;
    function GetMultiPageButtonRect(const AMultiPageButtonPos: TPoint): TRect;
    procedure SetSelectedPagesRange(Value: TPoint);
    procedure GetPointInfoAt(const APos: TPoint; var APagesRange: TPoint);
    procedure DrawButton(ACanvas: TCanvas; const AMultiPageButtonPos: TPoint; Highlighted: Boolean);
    function GetButton: TvgrMultiPageButton;
  protected
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;

    procedure CloseUp(X, Y: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function GetFormSize: TSize;
    property Button: TvgrMultiPageButton read GetButton;
  public
{Creates an instance of the TvgrMultiPagePaletteForm class.
Parameters:
  AOwner - The component - owner.}
    constructor Create(AOwner: TComponent); override;
{Frees an intance of the TvgrMultiPagePaletteForm class.}
    destructor Destroy; override;

{Specifies the minimum amount of pages per width of drop-down panel.}
    property MinPagesPerX: Integer read FMinPagesPerX write FMinPagesPerX;
{Specifies the minimum amount of pages per height of drop-down panel.}
    property MinPagesPerY: Integer read FMinPagesPerY write FMinPagesPerY;
{Specifies the maximum amount of pages per width of drop-down panel.}
    property MaxPagesPerX: Integer read FMaxPagesPerX write FMaxPagesPerX;
{Specifies the maximum amount of pages per height of drop-down panel.}
    property MaxPagesPerY: Integer read FMaxPagesPerY write FMaxPagesPerY;

{Specifies the current amount of pages per width of drop-down panel.}
    property PagesPerX: Integer read FPagesPerX write FPagesPerX;
{Specifies the current amount of pages per height of drop-down panel.}
    property PagesPerY: Integer read FPagesPerY write FPagesPerY;

{Specifies the selected pages' range.}
    property SelectedPagesRange: TPoint read GetSelectedPagesRange write SetSelectedPagesRange;
{Specifies the value indicating whether the drop-down panel must be opened immediate after
the left mouse down.}
    property ImmediateDropDown: Boolean read FImmediateDropDown write SetImmediateDropDown;
{Specifies the caption displaying at the bottom of drop-down panel, when user
can cancel selecting of pages' range.}
    property CloseCaption: string read FCloseCaption write FCloseCaption;
{Specifies the caption displaying at the bottom of drop-down panel, when user
can select the pages' range.}
    property PagesCaption: string read FPagesCaption write FPagesCaption;
{Occurs when the user selects the pages' range.
See also:
  TvgrPageSelectedEvent}
    property OnPagesRangeSelected: TvgrPagesRangeSelectedEvent read FOnPagesRangeSelected write FOnPagesRangeSelected;
  end;

  /////////////////////////////////////////////////
  //
  // TvgrMultiPageButton
  //
  /////////////////////////////////////////////////
{TvgrMultiPageButton represents a button that lets users select the pages' range.
Use the TvgrMultiPageButton component to provide the user with a button with drop-down panel
from which he can select a pages' range.
The pages' range is specified by two parameters:
<ul>
<li>Count of pages per width</li>
<li>Count of pages per height</li>
</ul>
Use the SelectedPagesRange property to access the currently selected range of pages.}
  TvgrMultiPageButton = class(TvgrBaseButton)
  private
    FImmediateDropDown: Boolean;
    FSelectedPagesRange: TPoint;
    FOnPagesRangeSelected: TvgrPagesRangeSelectedEvent;
    FCloseCaption: String;
    FPagesCaption: String;
    FMinPagesPerX: Integer;
    FMaxPagesPerX: Integer;
    FMinPagesPerY: Integer;
    FMaxPagesPerY: Integer;

    procedure DoOnPagesRangeSelected(Sender: TObject; const APagesRange: TPoint);
    procedure SetSelectedPagesRange(Value: TPoint);
    procedure SetImmediateDropDown(Value: Boolean);

    function IsCloseCaptionStored: Boolean;
    function IsPagesCaptionStored: Boolean;

    function GetDropDownForm: TvgrMultiPagePaletteForm;
  protected
    procedure CNCommand(var Msg: TWMCommand); message CN_COMMAND;

    function GetDropDownFormClass: TvgrDropDownFormClass; override;
    function GetDrawFocusRect: Boolean; override;
    procedure ShowDropDownForm; override;
    procedure DrawButton(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean); override;
    procedure DrawButtonInternal(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean; const AInternalRect: TRect); override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property DropDownForm: TvgrMultiPagePaletteForm read GetDropDownForm;
  public
{Creates an instance of the TvgrMultiPageButton class.
Parameters:
  AOwner - Component that is responsible for freeing the button.
It becomes the value of the Owner property.}
    constructor Create(AOwner: TComponent); override;
{Frees an instance of the TvgrMultiPageButton class.}
    destructor Destroy; override;

{Simulates a mouse click, as if the user had clicked the button.}    
    procedure Click; override;
{Specifies the current pages' range.}
    property SelectedPagesRange: TPoint read FSelectedPagesRange write SetSelectedPagesRange;
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
    property Visible;
{$IFDEF VGR_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

{Set Flat to true to remove the raised border when the button is unselected and the lowered border when the button is clicked or selected.}
    property Flat default True;
{Specifies the value indicating whether the drop-down panel must be opened immediate after
the left mouse down.}
    property ImmediateDropDown: Boolean read FImmediateDropDown write SetImmediateDropDown default true;
{Specifies the minimum amount of pages per width of drop-down panel.}
    property MinPagesPerX: Integer read FMinPagesPerX write FMinPagesPerX default DefaultMinPagesPerX;
{Specifies the minimum amount of pages per height of drop-down panel.}
    property MinPagesPerY: Integer read FMinPagesPerY write FMinPagesPerY default DefaultMinPagesPerY;
{Specifies the maximum amount of pages per width of drop-down panel.}
    property MaxPagesPerX: Integer read FMaxPagesPerX write FMaxPagesPerX default DefaultMaxPagesPerX;
{Specifies the maximum amount of pages per height of drop-down panel.}
    property MaxPagesPerY: Integer read FMaxPagesPerY write FMaxPagesPerY default DefaultMaxPagesPerY;

{Specifies the caption displaying at the bottom of drop-down panel, when user
can cancel selecting of pages' range.}
    property CloseCaption: string read FCloseCaption write FCloseCaption stored IsCloseCaptionStored;
{Specifies the caption displaying at the bottom of drop-down panel, when user
can select the pages' range.}
    property PagesCaption: string read FPagesCaption write FPagesCaption stored IsPagesCaptionStored;

{Occurs when the user selects the pages' range.
See also:
  TvgrPagesRangeSelectedEvent}
    property OnPagesRangeSelected: TvgrPagesRangeSelectedEvent read FOnPagesRangeSelected write FOnPagesRangeSelected;
  end;

{Use this metod to create and show TvgrMultiPagePaletteForm at specified position.
Parameters:
  AOwner - Specifies an owner for the created form.
  X, Y - Coordinates of the created form this values is relative to the screen in pixels.
  OnPagesRangeSelected - Specifies an event procedure, which is called when user selects the pages' range.
Return value:
   Returns a reference to the created form.}
function PopupPaletteForm(AOwner: TComponent;
                          X, Y: integer;
                          OnPagesRangeSelected: TvgrPagesRangeSelectedEvent): TvgrMultiPagePaletteForm;

implementation

uses
  vgr_GUIFunctions, vgr_Functions;

{$R vgrMultiPageButton.res}
{$R *.DFM}

const
  LeftOffset = 3;
  RightOffset = 3;
  TopOffset = 3;
  BottomOffset = 3;
  DeltaXOffset = 2;
  DeltaYOffset = 2;

var
  FButtonImage: TBitmap;
  FPageImage: TBitmap;

function PopupPaletteForm(AOwner: TComponent;
                          X, Y: integer;
                          OnPagesRangeSelected: TvgrPagesRangeSelectedEvent): TvgrMultiPagePaletteForm;
var
  R: TRect;
begin
  Result := TvgrMultiPagePaletteForm.Create(AOwner);
  Result.OnPagesRangeSelected := OnPagesRangeSelected;
  SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);
  if X + Result.Width > r.Right then
    X := X - Result.Width;
  if Y + Result.Height > r.Bottom then
    Y := Y - Result.Height;
  Result.Left := X;
  Result.Top := Y;
  Result.Show;
end;

/////////////////////////////////////////////////
//
// TvgrMultiPageButton
//
/////////////////////////////////////////////////
constructor TvgrMultiPageButton.Create(AOwner: TComponent);
begin
  inherited;
  FImmediateDropDown := True;
  FCloseCaption := DefaultCloseCaption;
  FPagesCaption := DefaultPagesCaption;
  FMinPagesPerX := DefaultMinPagesPerX;
  FMinPagesPerY := DefaultMinPagesPerY;
  FMaxPagesPerX := DefaultMaxPagesPerX;
  FMaxPagesPerY := DefaultMaxPagesPerY;
  Flat := True;
  Width := 23;
  Height := 22;
end;

destructor TvgrMultiPageButton.Destroy;
begin
  inherited;
end;

function TvgrMultiPageButton.IsCloseCaptionStored: Boolean;
begin
  Result := FCloseCaption <> DefaultCloseCaption;
end;

function TvgrMultiPageButton.IsPagesCaptionStored: Boolean;
begin
  Result := FPagesCaption <> DefaultPagesCaption;
end;

function TvgrMultiPageButton.GetDropDownForm: TvgrMultiPagePaletteForm;
begin
  Result := TvgrMultiPagePaletteForm(inherited DropDownForm);
end;

function TvgrMultiPageButton.GetDropDownFormClass: TvgrDropDownFormClass;
begin
  Result := TvgrMultiPagePaletteForm;
end;

procedure TvgrMultiPageButton.ShowDropDownForm;
begin
  inherited;

  DropDownForm.SelectedPagesRange := Point(0, 0);
  DropDownForm.OnPagesRangeSelected := DoOnPagesRangeSelected;
  DropDownForm.PagesCaption := PagesCaption;
  DropDownForm.CloseCaption := CloseCaption;
  DropDownForm.MinPagesPerX := MinPagesPerX;
  DropDownForm.MinPagesPerY := MinPagesPerY;
  DropDownForm.MaxPagesPerX := MaxPagesPerX;
  DropDownForm.MaxPagesPerY := MaxPagesPerY;
end;

function TvgrMultiPageButton.GetDrawFocusRect: Boolean;
begin
  Result := false;
end;

procedure TvgrMultiPageButton.DrawButton(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean);
begin
  if (DropDownForm <> nil) and (DropDownForm.ImmediateDropDown) then
  begin
    inherited DrawButton(ADC, ADisabled, True, AFocused, AUnderMouse);
  end
  else
  begin
    inherited;
  end;
end;

procedure TvgrMultiPageButton.DrawButtonInternal(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean; const AInternalRect: TRect);
var
  R: TRect;
  ATempCanvas: TCanvas;
begin
  r := AInternalRect;

  // draw image
  ATempCanvas := TCanvas.Create;
  ATempCanvas.Handle := ADC;
  try
    with r do
      ATempCanvas.Draw(r.Left + (r.Right - r.Left - FButtonImage.Width) div 2,
                       r.Top + (r.Bottom - r.Top - FButtonImage.Height) div 2, FButtonImage);
  finally
    ATempCanvas.Free;
  end;
end;

procedure TvgrMultiPageButton.CNCommand(var Msg: TWMCommand);
begin
  if Msg.NotifyCode = BN_CLICKED then
  begin
    if ImmediateDropDown then
    begin
      Msg.Result := 1;
      exit;
    end;
  end;
  inherited;
end;

procedure TvgrMultiPageButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if DropDownForm <> nil then
  begin
    DropDownForm.ImmediateDropDown := False;
    Invalidate;
  end;
  inherited;
end;

procedure TvgrMultiPageButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ImmediateDropDown then
  begin
    if DropDownForm = nil then
    begin
      ShowDropDownForm;
      DropDownForm.ImmediateDropDown := True;
    end;
    Invalidate;
  end;
end;

procedure TvgrMultiPageButton.Click;
begin
  if (DropDownForm = nil) and not ImmediateDropDown then
    ShowDropDownForm;
  inherited;
end;

procedure TvgrMultiPageButton.SetSelectedPagesRange(Value: TPoint);
begin
  FSelectedPagesRange := Value;
  Invalidate;
end;

procedure TvgrMultiPageButton.SetImmediateDropDown(Value: Boolean);
begin
  FImmediateDropDown := Value;
end;

procedure TvgrMultiPageButton.DoOnPagesRangeSelected(Sender: TObject; const APagesRange: TPoint);
begin
  SelectedPagesRange := APagesRange;
  if Assigned(OnPagesRangeSelected) then
    OnPagesRangeSelected(Self, SelectedPagesRange);
end;

/////////////////////////////////
//
// TprMultiPagePaletteForm
//
/////////////////////////////////
constructor TvgrMultiPagePaletteForm.Create(AOwner: TComponent);
begin
  inherited;
  BorderStyle := bsNone;

  FMinPagesPerX := DefaultMinPagesPerX;
  FMinPagesPerY := DefaultMinPagesPerY;
  FMaxPagesPerX := DefaultMaxPagesPerX;
  FMaxPagesPerY := DefaultMaxPagesPerY;
  FPagesPerX := FMinPagesPerX;
  FPagesPerY := FMinPagesPerY;

  FCloseCaption := DefaultCloseCaption;
  FPagesCaption := DefaultPagesCaption;

  FSelectedPagesRange.X := 0;
  FSelectedPagesRange.Y := 0;
end;

destructor TvgrMultiPagePaletteForm.Destroy;
begin
  inherited;
end;

procedure TvgrMultiPagePaletteForm.CMMouseLeave(var Msg: TMessage);
begin
  if not ImmediateDropDown then
    SelectedPagesRange := Point(0, 0);
  inherited;
end;

procedure TvgrMultiPagePaletteForm.SetImmediateDropDown(Value: Boolean);
begin
  FImmediateDropDown := Value;
  if FImmediateDropDown then
    SetCaptureControl(Self);
end;

function TvgrMultiPagePaletteForm.GetSelectedPagesRange;
begin
  Result := FSelectedPagesRange;
end;

function TvgrMultiPagePaletteForm.GetMultiPageButtonRect(const AMultiPageButtonPos: TPoint): TRect;
begin
  Result.Left := LeftOffset + AMultiPageButtonPos.X * (ColorBoxWidth + DeltaXOffset);
  Result.Top := TopOffset + AMultiPageButtonPos.Y * (ColorBoxHeight + DeltaYOffset);
  Result.Right := Result.Left + ColorBoxWidth;
  Result.Bottom := Result.Top + ColorBoxHeight;
end;

procedure TvgrMultiPagePaletteForm.SetSelectedPagesRange(Value: TPoint);
begin
  FSelectedPagesRange := Value;
  Invalidate;
end;

procedure TvgrMultiPagePaletteForm.GetPointInfoAt(const APos: TPoint; var APagesRange: TPoint);
begin
  if APos.X < FButtonsRect.Left then
    APagesRange.X := 0
  else
    APagesRange.X := Max(0, (APos.X - LeftOffset) div (ColorBoxWidth + DeltaXOffset) + 1);
  if APos.Y < FButtonsRect.Top then
    APagesRange.Y := 0
  else
    APagesRange.Y := Max(0, (APos.Y - TopOffset) div (ColorBoxHeight + DeltaYOffset) + 1);

  if ImmediateDropDown then
  begin
    APagesRange.X := Min(APagesRange.X, MaxPagesPerX);
    APagesRange.Y := Min(APagesRange.Y, MaxPagesPerY);
  end
  else
  begin
    if PtInRect(FButtonsRect, APos) then
    begin
      APagesRange.X := Min(APagesRange.X, MaxPagesPerX);
      APagesRange.Y := Min(APagesRange.Y, MaxPagesPerY);
    end
    else
    begin
      APagesRange.X := 0;
      APagesRange.Y := 0;
    end;
  end;
end;

function TvgrMultiPagePaletteForm.GetButton: TvgrMultiPageButton;
begin
  Result := TvgrMultiPageButton(inherited Button);
end;

procedure TvgrMultiPagePaletteForm.DrawButton(ACanvas: TCanvas; const AMultiPageButtonPos: TPoint; Highlighted: Boolean);
var
  R, R2, R_BAK: TRect;
begin
  R := GetMultiPageButtonRect(AMultiPageButtonPos);
  R_BAK := R;
  R2 := R;

  // Icon
  R2.Left := R2.Left + (R2.Right - R2.Left - FPageImage.Width) div 2;
  R2.Top := R2.Top + (R2.Bottom - R2.Top - FPageImage.Height) div 2;
  R2.Right := R2.Left + FPageImage.Width;
  R2.Bottom := R2.Top + FPageImage.Height;
  Canvas.StretchDraw(R2, FPageImage);
  ExcludeClipRect(Canvas, R2);

  // Shadow for page icon
  Canvas.Brush.Color := clGray;
  R := R2;
  R2.Left := R2.Right;
  R2.Right := R2.Right + 1;
  R2.Top := R2.Top + 1;
  R2.Bottom := R2.Bottom + 1;
  Canvas.FillRect(R2);
  ExcludeClipRect(Canvas, R2);
  R2 := R;
  R2.Left := R2.Left + 1;
  R2.Right := R2.Right + 1;
  R2.Top := R2.Bottom;
  R2.Bottom := R2.Bottom + 1;
  Canvas.FillRect(R2);
  ExcludeClipRect(Canvas, R2);

  // inner area
  R := R_BAK;
  InflateRect(R, -1, -1);
  if Highlighted then
    Canvas.Brush.Color := clHighlight
  else
    Canvas.Brush.Color := clWindow;
  Canvas.FillRect(R);
  ExcludeClipRect(ACanvas, R);

  // border
  Canvas.Brush.Color := clBtnShadow;
  Canvas.FillRect(R_BAK);
  ExcludeClipRect(ACanvas, R_BAK);
end;

procedure TvgrMultiPagePaletteForm.FormPaint(Sender: TObject);
var
  R: TRect;
  I, J: integer;
  ACaption: string;
begin
  if FDisablePaint then
    exit;
    
  // Buttons
  for I := 0 to PagesPerX - 1 do
    for J := 0 to PagesPerY - 1 do
      DrawButton(Canvas, Point(I, J), (J < SelectedPagesRange.Y) and (I < SelectedPagesRange.X));

  // Bottom caption
  Canvas.Brush.Color := clWindow;
  Canvas.Font.Color := clWindowText;
  Canvas.FillRect(FCaptionRect);

  Canvas.Brush.Style := bsClear;
  if (SelectedPagesRange.Y = 0) or (SelectedPagesRange.X = 0) then
    ACaption := CloseCaption
  else
    ACaption := Format(PagesCaption, [SelectedPagesRange.Y, SelectedPagesRange.X]);
  with FCaptionRect, Canvas.TextExtent(ACaption) do
    Canvas.TextOut(Left + (Right - Left - cx) div 2,
                   Top + (Bottom - Top - cy) div 2,
                   ACaption);
  ExcludeClipRect(Canvas, FCaptionRect);
  Canvas.Brush.Style := bsSolid;

  //
  R := ClientRect;
  InflateRect(R, -1, -1);
  Canvas.Brush.Color := clWindow;
  Canvas.FillRect(R);
  ExcludeClipRect(Canvas, R);

  // Form's borders
  Canvas.Brush.Color := clBtnShadow;
  Canvas.FillRect(ClientRect);
end;

function TvgrMultiPagePaletteForm.GetFormSize: TSize;
begin
  // buttons' area
  FButtonsRect := Rect(LeftOffset,
                       TopOffset,
                       LeftOffset + PagesPerX * ColorBoxWidth + (PagesPerX - 1) * DeltaXOffset,
                       TopOffset + PagesPerY * ColorBoxHeight+ (PagesPerY - 1) * DeltaYOffset);
  // caption's area
  FCaptionRect.Left := FButtonsRect.Left;
  FCaptionRect.Top := FButtonsRect.Bottom;
  FCaptionRect.Right := FButtonsRect.Right;
  FCaptionRect.Bottom := FCaptionRect.Top + MulDiv(GetFontHeight(Canvas.Font), 3, 2);

  // form's size
  Result.cx := FButtonsRect.Right + RightOffset;
  Result.cy := FCaptionRect.Bottom + BottomOffset;
end;

procedure TvgrMultiPagePaletteForm.FormCreate(Sender: TObject);
begin
  with GetFormSize do
  begin
    ClientWidth := cx;
    ClientHeight := cy;
  end;
end;

procedure TvgrMultiPagePaletteForm.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ANewPagesRange: TPoint;
begin
  GetPointInfoAt(Point(X, Y), ANewPagesRange);
  if (ANewPagesRange.X <> SelectedPagesRange.X) or (ANewPagesRange.Y <> SelectedPagesRange.Y) then
  begin
    if (ANewPagesRange.X > PagesPerX) or (ANewPagesRange.Y > PagesPerY) then
    begin
      PagesPerY := Max(ANewPagesRange.Y, PagesPerY);
      PagesPerX := Max(ANewPagesRange.X, PagesPerX);
      with GetFormSize do
        SetBounds(Left, Top, cx, cy);
    end;
    FSelectedPagesRange := ANewPagesRange;
    Invalidate;
  end;
end;

procedure TvgrMultiPagePaletteForm.CloseUp(X, Y: Integer);
begin
  if (SelectedPagesRange.X > 0) or (SelectedPagesRange.Y > 0) then
  begin
    if Assigned(FOnPagesRangeSelected) then
      FOnPagesRangeSelected(Self, SelectedPagesRange);
  end;
  Close;
end;

procedure TvgrMultiPagePaletteForm.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CloseUp(X, Y);
end;

procedure TvgrMultiPagePaletteForm.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  if ImmediateDropDown then
  begin
    SetCaptureControl(nil);

    if Self.Button <> nil then
    begin
      P := ClientToScreen(Point(X, Y));
      P := Self.Button.ScreenToClient(P);
      if PtInRect(Rect(0, 0, Self.Button.Width, Self.Button.Height), P) then
      begin
        Self.Button.MouseUp(Button, Shift, P.X, P.Y);
        exit;
      end
      else
        Self.Button.MouseInControl := False;
    end;

    CloseUp(X, Y);
  end;
end;

initialization

  FButtonImage := TBitmap.Create;
  FButtonImage.LoadFromResourceName(hInstance, 'VGR_MULTIPAGEICON');
  FButtonImage.Transparent := True;
  FPageImage := TBitmap.Create;
  FPageImage.LoadFromResourceName(hInstance,'VGR_PAGEICON');

finalization

  FButtonImage.Free;
  FPageImage.Free;

end.
