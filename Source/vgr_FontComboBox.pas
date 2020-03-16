{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2003 by vtkTools      }
{                                          }
{******************************************}

{Contains the TvgrFontComboBox component that is used for represents a combo box that lets users select a font.
Use this component to provide the user with a drop-down combo box from which to select a font name.
See also:
vgr_ControlBar,vgr_ColorButton,vgr_Label}
unit vgr_FontComboBox;

{$I vtk.inc}

interface

uses
  SysUtils, Messages, Windows, Classes, StdCtrls, graphics, Controls;

type

{ TvgrFontComboBoxOptions specify options for a TvgrFontComboBox component.
Syntax:
  TvgrFontComboBoxOptions = (prfcboFixedOnly);
Items:
  prfcboFixedOnly - show in drop down list only fixed fonts (all characters in the font have the same width). }
  TvgrFontComboBoxOptions = (prfcboFixedOnly);
{ TvgrFontComboBoxOptionsSet specify options for a TvgrFontComboBox component. 
Syntax:
  TvgrFontComboBoxOptionsSet = set of TvgrFontComboBoxOptions;
}
  TvgrFontComboBoxOptionsSet = set of TvgrFontComboBoxOptions;

  /////////////////////////////////////////////////
  //
  // TvgrFontComboBox
  //
  /////////////////////////////////////////////////
  { TvgrFontComboBox represents a combo box that lets users select a font.
    Use TvgrFontComboBox to provide the user with a drop-down combo box from which to select a font name.
    Use the Options property to specify which fonts the font box should list.
    Use the ListFontSize property to specify size of font in font box.

    Use the SelectedFontName property to access the font that the user selects. }
  TvgrFontComboBox = class(TCustomComboBox)
  private
    FTempFont: TFont;
    FListFontSize: integer;
    FItemHeight: integer;
    FMaxWidth: integer;
    FDroppingDown: boolean;
    FFocusChanged: boolean;
    FIsFocused: boolean;
    FOptions: TvgrFontComboBoxOptionsSet;
    procedure SetListFontSize(Value : integer);
    function GetOptions: TvgrFontComboBoxOptionsSet;
    procedure SetOptions(Value : TvgrFontComboBoxOptionsSet);
    procedure UpdateItems;
    function GetSelectedFontName: string;
    function GetIsFontSelected: Boolean;
  protected
    procedure AdjustDropDown; {$IFDEF VTK_D6_OR_D7} override; {$ENDIF}
    procedure WMDrawItem(var Msg: TWMDrawItem); message WM_DRAWITEM;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure CNCommand(var Msg: TWMCommand); message CN_COMMAND;
    procedure CBGetItemHeight(var Msg: TMessage); message CB_GETITEMHEIGHT;
    procedure CreateWnd; override;
    procedure WndProc(var Msg: TMessage); override;
  public
	{Creates a instance of class.}
    constructor Create(AOwner : TComponent); override;
    { Use the SelectedFontName property to access the font that the user selects. }
    property SelectedFontName: string read GetSelectedFontName;
    { IsFontSelected returns true if user select font in the list. (ItemIndex <> -1) }
    property IsFontSelected: Boolean read GetIsFontSelected;
  published
    { Use the ListFontSize property to specify size of font in font box. }
    property ListFontSize: integer read FListFontSize write SetListFontSize;
    { Use the Options property to specify which fonts the font box should list. }
    property Options: TvgrFontComboBoxOptionsSet read GetOptions write SetOptions default [];
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
{$IFDEF VTK_D5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  vgr_Functions, vgr_GUIFunctions;

{$R vgrFontComboBox.res}

var
  TrueTypeBitmap : TBitmap;

/////////////////////////////////////////////////
//
// TvgrFontComboBox
//
/////////////////////////////////////////////////
constructor TvgrFontComboBox.Create;
begin
  inherited;
{$IFDEF VGR_DEMO}
  ShowDemoWarning;
{$ENDIF}
  Style := csOwnerDrawFixed;
  FListFontSize := 12;
  FItemHeight := ItemHeight;
end;

function TvgrFontComboBox.GetSelectedFontName: string;
begin
  if (ItemIndex >= 0) and (ItemIndex < Items.Count) then
    Result := Items[ItemIndex]
  else
    Result := '';
end;

function TvgrFontComboBox.GetIsFontSelected: Boolean;
begin
  Result := (ItemIndex >= 0) and (ItemIndex < Items.Count);
end;

function EnumFontsProc(var LogFont : TLogFont;
                       var TextMetric : TTextMetric;
                       FontType : Integer;
                       Data : Pointer): Integer; stdcall;
var
  AHeight, AWidth: Integer;
begin
  with TvgrFontComboBox(Data) do
  begin
    if not (prfcboFixedOnly in Options) or ((LogFont.lfPitchAndFamily and FIXED_PITCH)<>0) then
    begin
      Items.AddObject(StrPas(LogFont.lfFaceName), TObject(FontType));

      FTempFont.Name := LogFont.lfFaceName;
      AHeight := GetFontHeight(FTempFont);
      AWidth := GetStringWidth(LogFont.lfFaceName, FTempFont);

      if AHeight > FItemHeight then
        FItemHeight := AHeight;
      if AWidth > FMaxWidth then
        FMaxWidth := AWidth;
    end;
  end;
  Result := 1;
end;

procedure TvgrFontComboBox.UpdateItems;
var
  ADC: HDC;
begin
  FTempFont := TFont.Create;
  FTempFont.Size := ListFontSize;

  Items.BeginUpdate;
  Items.Clear;
  FItemHeight := 0;
  FMaxWidth := 0;

  ADC := GetDC(0);
  EnumFonts(ADC, nil, @EnumFontsProc, pointer(Self));
  ReleaseDC(0, ADC);

  FItemHeight := FItemHeight + 2;
  FMaxWidth := FMaxWidth + 4;

  SendMessage(Handle, CB_SETITEMHEIGHT, 0, FItemHeight);  // update item height
  SendMessage(Handle, CB_SETDROPPEDWIDTH, FMaxWidth, 0);
  Items.EndUpdate;

  FreeAndNil(FTempFont);
end;

procedure TvgrFontComboBox.CreateWnd;
begin
  inherited;
  UpdateItems;
end;

procedure TvgrFontComboBox.WndProc;
begin
  if Msg.Msg=WM_SIZE then
  begin
    if FDroppingDown then
    begin
      DefaultHandler(Msg);
      Exit;
    end;
  end;
  inherited;
end;

procedure TvgrFontComboBox.SetListFontSize;
begin
  if Value<>FListFontSize then
  begin
    FListFontSize := Value;
    RecreateWnd;
  end;
end;

function TvgrFontComboBox.GetOptions: TvgrFontComboBoxOptionsSet;
begin
  Result := FOptions;
end;

procedure TvgrFontComboBox.SetOptions(Value : TvgrFontComboBoxOptionsSet);
begin
  if Value<>FOptions then
  begin
    FOptions := Value;
    if not (csLoading in ComponentState) then
      UpdateItems;
  end;
end;

procedure TvgrFontComboBox.AdjustDropDown;
var
  ItemCount: Integer;
begin
  ItemCount := Items.Count;
  if ItemCount > DropDownCount then ItemCount := DropDownCount;
  if ItemCount < 1 then ItemCount := 1;
  FDroppingDown := True;
  try
    SetWindowPos(Handle, 0, 0, 0, Width, FItemHeight * ItemCount +
      Height + 2, SWP_NOMOVE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_NOREDRAW +
      SWP_HIDEWINDOW);
  finally
    FDroppingDown := False;
  end;
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE +
    SWP_NOZORDER + SWP_NOACTIVATE + SWP_NOREDRAW + SWP_SHOWWINDOW);
end;

procedure TvgrFontComboBox.CBGetItemHeight(var Msg: TMessage);
begin
  inherited;
end;

procedure TvgrFontComboBox.CNCommand(var Msg: TWMCommand);
begin
  case Msg.NotifyCode of
    CBN_DROPDOWN:
      begin
        FFocusChanged := False;
        DropDown;
        AdjustDropDown;
        if FFocusChanged then
        begin
          PostMessage(Handle, WM_CANCELMODE, 0, 0);
          if not FIsFocused then PostMessage(Handle, CB_SHOWDROPDOWN, 0, 0);
        end;
      end;
    CBN_SETFOCUS:
      begin
        FIsFocused := True;
        FFocusChanged := True;
        SetIme;
      end;
    CBN_KILLFOCUS:
      begin
        FIsFocused := False;
        FFocusChanged := True;
        ResetIme;
      end;
    else
      inherited;
  end;
end;

procedure TvgrFontComboBox.WMPaint(var Msg: TWMPaint); 
begin
  if Enabled then
    Font.Color := clWindowText
  else
    Font.Color := clGrayText;
  inherited;
end;

procedure TvgrFontComboBox.WMDrawItem;
var
  s: string;
  sz: TSize;
  Canvas: TCanvas;
begin
  Msg.Result := 1;

  Canvas := TCanvas.Create;
  try
    with Msg.DrawItemStruct^ do
    begin
      Canvas.Handle := hDC;

      if (itemState and ODS_COMBOBOXEDIT) <> 0 then
        begin
          if ItemIndex = -1 then
            s := ''
          else
            s := Items[ItemIndex];
          Canvas.Font.Size := Font.Size;
          Canvas.Font.Name := Font.Name;
          if (itemState and ODS_DISABLED) <> 0 then
            Canvas.Font.Color := clGrayText
          else
            Canvas.Font.Color := clWindowText;
        end
      else
        begin
          s := Items[ItemID];
          Canvas.Font.Size := ListFontSize;
          Canvas.Font.Name := s;
          if (itemState and ODS_SELECTED)<>0 then
            begin
              Canvas.Font.Color := clHighlightText;
              Canvas.Brush.Color := clHighlight;
            end
          else
            begin
              Canvas.Font.Color := clWindowText;
              Canvas.Brush.Color := clWindow;
            end;
        end;

      Canvas.Brush.Style := bsSolid;
      Canvas.FillRect(rcItem);

      Canvas.Brush.Style := bsClear;
      sz := Canvas.TextExtent(s);

      Canvas.TextOut(rcItem.Left + TrueTypeBitmap.Width + 2 + 2,
                     rcItem.Top + (rcItem.Bottom - rcItem.Top - sz.cy) div 2,
                     s);
  
      if (ItemID<>$FFFFFFFF) and ((Integer(Items.Objects[ItemID]) and TRUETYPE_FONTTYPE) <> 0) then
        Canvas.Draw(rcItem.Left,
                    rcItem.Top + (rcItem.Bottom - rcItem.Top - TrueTypeBitmap.Height) div 2,
                    TrueTypeBitmap);
    end;
  finally
    Canvas.Free;
  end;
end;

initialization

  TrueTypeBitmap := TBitmap.Create;
  try
    TrueTypeBitmap.LoadFromResourceName(hInstance,'VGR_BMP_TRUETYPE');
  except
  end;
  TrueTypeBitmap.Transparent := True;

finalization

  TrueTypeBitmap.Free;

end.

