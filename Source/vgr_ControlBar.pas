{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2003 by vtkTools      }
{                                          }
{******************************************}

{Contains @link(TvgrControlBar) and @link(TvgrControlBarManager) - components for managing the layout of toolbar components.
TvgrControlBar manages the layout of toolbar components. TvgrControlBarManager provides a mechanism to store information about toolbars layout to a TvgrIniStorage or ini file.
See also:
vgr_FontComboBox,vgr_ColorButton,vgr_Label
}
unit vgr_ControlBar;

{$I vtk.inc}

interface

uses
  commctrl, messages, SysUtils, Windows, Classes, forms,
  Controls, Graphics, comctrls, math,

  vgr_IniStorage;

type

  TvgrCBBand = class;
  TvgrControlBar = class;

  /////////////////////////////////////////////////
  //
  // TvgrCBRow
  //
  /////////////////////////////////////////////////
  { Internal class, used to store information about row in control bar.
    Each row consists from several bands.
    Each band linked to child control of TvgrControlBar. }
  TvgrCBRow = class(TObject)
  private
    FControlBar: TvgrControlBar;
    FBands: TList;
    FLoadedMin: Integer;
    function GetBand(I: integer) : TvgrCBBand;
    function GetMin: Integer;
    function GetMax: Integer;
    function GetSize: Integer;
    function GetVisible: Boolean;
    function GetBandsCount: Integer;
    function GetVisibleBandsCount: Integer;

    procedure AddBand(Band: TvgrCBBand);
    procedure DeleteBand(Band: TvgrCBBand);
    procedure AlignBands;

    property ControlBar: TvgrControlBar read FControlBar;
    property Visible: Boolean read GetVisible;
    property Min: Integer read GetMin;
    property Max: Integer read GetMax;
    property Size: Integer read GetSize;
    property Bands[I: integer]: TvgrCBBand read GetBand;
    property BandsCount: Integer read GetBandsCount;
    property VisibleBandsCount: Integer read GetVisibleBandsCount;
  public
{Creates a instance of TvgrCBRow class.}
    constructor Create(AControlBar: TvgrControlbar);
{Destroys an instance of TvgrCBRow.
Do not call Destroy directly in an application. 
Instead, call Free.}
    destructor Destroy; override;
  end;
  
  /////////////////////////////////////////////////
  //
  // TvgrCBBand
  //
  /////////////////////////////////////////////////
  { Internal class, used to store information about child control in TvgrControlBar.
    Each TvgrCBBand object linked to child control of TvgrControlBar. }
  TvgrCBBand = class(TObject)
  private
    FControl: TControl;
    FMin: Integer;
    FHeight: Integer;
    FWidth: Integer;
    FRow: TvgrCBRow;
    FVisible: Boolean;

    FLoadedControlName: string;
    FLoadedVisible: Boolean;

    procedure SetRow(Value: TvgrCBRow);
    procedure SetVisible(Value: Boolean);
    procedure SetMin(Value: Integer);
    procedure SetWidth(Value: Integer);
    procedure SetHeight(Value: Integer);
    function GetRect: TRect;
    function GetSize: Integer;
    procedure DoAlignRowBands;

    property Row: TvgrCBRow read FRow write SetRow;
    property Control: TControl read FControl write FControl;
    property Min: Integer read FMin write SetMin;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property Visible: Boolean read FVisible write SetVisible;
    property Rect: TRect read GetRect;
    property Size: Integer read GetSize;
  public
{Creates a instance of class.}  
    constructor Create(ARow: TvgrCBRow; AControl: TControl; AWidth: Integer; AHeight: Integer; AMin: Integer); overload;
{Creates a instance of class.}    
    constructor Create; overload;
  end;

{ Position of the TvgrControlBar object within parent control. 
Syntax:
  TvgrControlBarSide = (prcbsLeft, prcbsTop, prcbsRight, prcbsBottom);
Items:
  prcbsLeft - Left
  prcbsTop - Top
  prcbsRight - Right
  prcbsBottom - Bottom
}
  TvgrControlBarSide = (prcbsLeft, prcbsTop, prcbsRight, prcbsBottom);
  /////////////////////////////////////////////////
  //
  // TvgrControlBar
  //
  /////////////////////////////////////////////////
  { TvgrControlBar manages the layout of toolbar components.
    Use TvgrControlBar as a docking site for toolbar components.
    Control bars contain child controls (usually TToolBar objects) that can be
    moved and resized independently. }
  TvgrControlBar = class(TCustomControl)
  private
    FUpdateCount: Integer;
    FRows: TList;
    FDownBand: TvgrCBBand;
    FSide: TvgrControlBarSide;
    FDownMousePos: TPoint;
    FFirstCallAfterLoad: Boolean;
    procedure SetSide(Value : TvgrControlBarSide);
    function GetRow(i : integer) : TvgrCBRow;
    function GetRowsCount : integer;
    function GetSize : integer;
    procedure SetSize(Value : integer);
    procedure CMDesignHitTest(var Msg : TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMControlListChange(var Msg : TCMControlListChange); message CM_CONTROLLISTCHANGE;
    function GetEnableUpdate: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure ClearRows;
    function IsControlVisible(Control: TControl) : boolean;
    function FindControlBand(Control: TControl) : TvgrCBBand;
    function IsVertical: boolean;
    function GetControlRowCoord(Control: TControl) : integer;
    function GetControlBandCoord(Control: TControl) : integer;
    function FindRow(RowCoord: Integer): TvgrCBRow;
    function GetLastRowMax: Integer;
    procedure DeleteRow(Row: TvgrCBRow);
    procedure DeleteControl(Control: TControl);
    procedure GetBandSizes(ARow: TvgrCBRow; AControl: TControl; var AWidth, AHeight: Integer);
    procedure InternalAlignControls;
  
    function IsAllControlsCreated: Boolean;
    procedure AlignControls(Control: TControl; var ARect: TRect); override;
    procedure UpdateSize;
    procedure GetPointInfoAt(X,Y : integer; var band : TvgrCBBand);
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X,Y: integer); override;
    procedure MouseMove(Shift : TShiftState; X,Y: Integer); override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X,Y: Integer); override;
    procedure PositionDockRect(DragDockObject: TDragDockObject); override;
  
    procedure SetControlVisible(Control: TControl; Visible : boolean);

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure SetupControlProperties(AControl: TControl);

    procedure NotifyDesigner;

    procedure InternalBuildAfterLoad;
    procedure InternalCalculateBandsAfterLoad;

    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadLayout(Stream: TStream);
    procedure WriteLayout(Stream: TStream);
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure Loaded; override;

    property EnableUpdate: Boolean read GetEnableUpdate;
    property Rows[I: Integer] : TvgrCBRow read GetRow;
    property RowsCount: Integer read GetRowsCount;
  public
{
Calling Create constructs and initializes an instance of TvgrControlBar.}  
    constructor Create(AOwner: TComponent); override;
{Destroys an instance of TvgrControlBar.
Do not call Destroy directly in an application. 
Instead, call Free.}    
    destructor Destroy; override;

    { If Position equals prcbsLeft or prcbsRight - Size property returns and sets Width
      of TvgrControlBar object.
      If Position property equals prcbsTop or prcbsBottom - Size property returns and sets
      Height of TvgrControlBar object. }
    property Size: integer read GetSize write SetSize;
  published
    { Specifies place of the TvgrControlBar object within parent control. }
    property Side: TvgrControlBarSide read FSide write SetSide default prcbsTop;
    property Anchors;
    property Color;
    property Enabled;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  { TvgrOnGetToolbarsList is the type for event handlers that supply list of toolbars to a TvgrControlBarManager.
Syntax:
TvgrOnGetToolbarsList = procedure(Sender : TObject; L : TList) of object;
Parameters:
    Sender is the TvgrControlBarManager object
    L is a list that you can fill with toolbars, which should managed by TvgrControlBarManager object. }
  TvgrOnGetToolbarsList = procedure(Sender : TObject; L : TList) of object;
  /////////////////////////////////////////////////
  //
  // TvgrControlBarManager
  //
  /////////////////////////////////////////////////
  { TvgrControlBarManager provides a mechanism to store information about toolbars layout to a TvgrIniStorage or ini file.
    Use LeftCB, TopCB, RightCB and BottomCB properties to specify TvgrControlBar objects
    which aligned to appropriate sides of the form. }
  TvgrControlBarManager = class(TComponent)
  private
    FLeftCB : TvgrControlBar;
    FTopCB : TvgrControlBar;
    FRightCB : TvgrControlBar;
    FBottomCB : TvgrControlBar;
    FOnGetToolbarsList : TvgrOnGetToolbarsList;
    FToolbarsList : TList;
    FOldOnFormShow : TNotifyEvent;
    FRestoredToolbars : TList;
    procedure GetToolbarsList;
    function GetToolbar(i : integer) : TToolbar;
    function GetToolbarsCount : integer;
    procedure OnFormShow(Sender : TObject);
  protected
    property Toolbars[i : integer] : TToolBar read GetToolbar;
    property ToolbarsCount : integer read GetToolbarsCount;

    procedure WriteToolbar(Toolbar: TToolbar; AStorage: TvgrIniStorage; const SectionName : string);
    procedure WriteControlBar(AControlBar: TvgrControlBar; AStorage: TvgrIniStorage; const SectionName: string);

    procedure ReadToolbar(Toolbar : TToolbar; AStorage: TvgrIniStorage; const SectionName: string);
    procedure ReadControlBar(AControlBar: TvgrControlBar; AStorage: TvgrIniStorage; const SectionName: string);

    procedure Notification(AComponent : TComponent; AOperation : TOperation); override;
    procedure Loaded; override;
  public
{Calling Create constructs and initializes an instance of TvgrControlBarManager.}
    constructor Create(AOwner : TComponent); override;
{Destroys an instance of TvgrControlBarManager.
Do not call Destroy directly in an application. 
Instead, call Free. Free verifies that the object is not nil before it calls Destroy.}    
    destructor Destroy; override; 

{Call this method to store information about toolbars layout to an ini file.
You can call this method in any time, for example in TForm.OnClose event, or
TForm.OnDestroy event.
Parameters:
  AIniFileName is a full name of ini file
  SectionNamePrefix prefix which are added to a name of sections in ini file,
created while writing.
}
    procedure WriteToIni(const AIniFileName: string; const SectionNamePrefix : string);
{ Call this method to read information about toolbars layout from an ini file.
  You can call this method only then all toolbars and control bars on the form
  are created and has valid Handles, therefore you can`t use this method in
  TForm.OnCreate method, use TForm.OnShow or TForm.OnActivate events instead.
Parameters:
  AIniFileName is a full name of ini file
  SectionNamePrefix prefix which are added to a name of sections in ini file.  
Example:
      procedure TForm1.FormShow(Sender: TObject);
      begin
        if not FSettingsRestored then
        begin
          ControlBarManager.ReadFromIni('c:\windows\gr.ini', 'ControlBarManager');
          FSettingsRestored := True;
        end;
      end; }
    procedure ReadFromIni(const AIniFileName: string; const SectionNamePrefix : string);
{ Call this method to store information about toolbars layout to an TvgrIniStorage object.
  You can call this method in any time, for example in TForm.OnClose event, or
  TForm.OnDestroy event. 
Parameters:
  AStorage - TvgrIniStorage object
  SectionNamePrefix - prefix which are added to a name of sections in ini file,
created while writing.}
    procedure WriteToStorage(AStorage: TvgrIniStorage; const SectionNamePrefix: string);
{ Call this method to read information about toolbars layout from an TvgrIniStorage object.      
  You can call this method only then all toolbars and control bars on the form
  are created and has valid Handles, therefore you can`t use this method in
  TForm.OnCreate method, use TForm.OnShow or TForm.OnActivate events instead.
Parameters:
  AStorage - TvgrIniStorage object
  SectionNamePrefix - prefix which are added to a name of sections in ini file.
Example:
  procedure TForm1.FormShow(Sender: TObject);
  var
    AStorage: TvgrIniFileStorage;
  begin
    if not FSettingsRestored then
    begin
      AStorage := TvgrIniFileStorage.Create('c:\windows\prog.ini');
      vgrControlBarManager1.ReadFromStorage(AStorage, 'Form1');
      AStorage.Free;
    end;
  end;}
    procedure ReadFromStorage(AStorage: TvgrIniStorage; const SectionNamePrefix: string);

{ Call this method to hide or show toolbar, 
  which are managed by TvgrControlBarManagerObject. 
Parameters:
  ToolBar - TToolBar object
  Visible - true shows toolbar, false hides.
}
    procedure ShowHideToolBar(ToolBar: TToolBar; Visible: Boolean);
  published
    { Specify TvgrControlBar object which aligned to the left side of the form. }
    property LeftCB: TvgrControlBar read FLeftCB write FLeftCB;
    { Specify TvgrControlBar object which aligned to the top side of the form. }
    property TopCB: TvgrControlBar read FTopCB write FTopCB;
    { Specify TvgrControlBar object which aligned to the right side of the form. }
    property RightCB: TvgrControlBar read FRightCB write FRightCB;
    { Specify TvgrControlBar object which aligned to the bottom side of the form. }
    property BottomCB: TvgrControlBar read FBottomCB write FBottomCB;
    { Use this event to provide list of toolbars, which are manged by TvgrControlBarManager object.
      If this event handler not defined TvgrControlBarManager operates all toolbars on the form. }
    property OnGetToolbarsList: TvgrOnGetToolbarsList read FOnGetToolbarsList write FOnGetToolbarsList;
  end;
  
implementation

uses
  vgr_Functions;
  
const
  CaptionOffs = 7;
  BorderOffs = 2;
  aAlignArray: Array [TvgrControlBarSide] of TAlign = (alLeft, alTop, alRight, alBottom);

type
  /////////////////////////////////////////////////
  //
  // TToolBarAccess
  //
  /////////////////////////////////////////////////
  TToolBarAccess = class(TToolBar)
  end;

  /////////////////////////////////////////////////
  //
  // TToolButtonAccess
  //
  /////////////////////////////////////////////////
  TToolButtonAccess = class(TToolButton)
  end;

  /////////////////////////////////////////////////
  //
  // TWinControlAccess
  //
  /////////////////////////////////////////////////
  TWinControlAccess = class(TWinControl)
  end;

/////////////////////////////////////////////////
//
// TvgrCBBand
//
/////////////////////////////////////////////////
constructor TvgrCBBand.Create;
begin
  inherited Create;
end;

constructor TvgrCBBand.Create(ARow: TvgrCBRow; AControl: TControl; AWidth: Integer; AHeight: Integer; AMin: Integer);
begin
  Create;
  
  FVisible := True;
  FWidth := AWidth;
  FHeight := AHeight;
  FMin := AMin;
  FControl := AControl;
  Row := ARow;
end;

procedure TvgrCBBand.SetRow(Value : TvgrCBRow);
begin
  if FRow <> Value then
  begin
    if FRow <> nil then
      FRow.DeleteBand(Self);
    FRow := Value;
    if FRow <> nil then
      FRow.AddBand(Self);
  end;
end;

procedure TvgrCBBand.DoAlignRowBands;
begin
  if FRow<>nil then
    FRow.AlignBands;
end;

procedure TvgrCBBand.SetVisible(Value : boolean);
begin
  FVisible := Value;
  DoAlignRowBands;
end;

procedure TvgrCBBand.SetMin(Value : integer);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    DoAlignRowBands;
  end;
end;

procedure TvgrCBBand.SetWidth(Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    DoAlignRowBands;
  end;
end;

procedure TvgrCBBand.SetHeight(Value: Integer);
begin
  if FHeight <> Value then
  begin
    FHeight := Value;
    DoAlignRowBands;
  end;
end;

function TvgrCBBand.GetRect : TRect;
begin
  if Row.ControlBar.IsVertical then
    Result := Classes.Rect(Row.Min, Min, Row.Max, Min + Height)
  else
    Result := Classes.Rect(Min, Row.Min, Min + Width, Row.Max);
end;

function TvgrCBBand.GetSize: Integer;
begin
  if Row.ControlBar.IsVertical then
    Result := Height
  else
    Result := Width;
end;

/////////////////////////////////////////////////
//
// TvgrCBRow
//
/////////////////////////////////////////////////
constructor TvgrCBRow.Create(AControlBar: TvgrControlBar);
begin
  inherited Create;
  FControlBar := AControlBar;
  FBands := TList.Create;
end;

destructor TvgrCBRow.Destroy;
begin
  FreeListItems(FBands);
  FBands.Free;
  inherited;
end;

function TvgrCBRow.GetBand(I: integer) : TvgrCBBand;
begin
  Result := TvgrCBBand(FBands[I]);
end;

function TvgrCBRow.GetBandsCount : integer;
begin
  Result := FBands.Count;
end;

function TvgrCBRow.GetVisibleBandsCount : integer;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to BandsCount - 1 do
    if Bands[I].Visible then
      Inc(Result);
end;

function TvgrCBRow.GetVisible : boolean;
var
  I: integer;
begin
  for I := 0 to BandsCount - 1 do
    if Bands[I].Visible then
    begin
      Result := True;
      exit;
    end;
  Result := False;
end;

function TvgrCBRow.GetMin : integer;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to ControlBar.RowsCount - 1 do
    if ControlBar.Rows[I] = Self then
      exit
    else
      Result := Result + ControlBar.Rows[I].Size;
end;

function TvgrCBRow.GetSize : integer;
var
  I: integer;
begin
  Result := 0;
  if ControlBar.IsVertical then
  begin
    for I := 0 to BandsCount - 1 do
      if Bands[I].Visible then
        if Bands[I].Width > Result then
          Result := Bands[I].Width;
  end
  else
  begin
    for I := 0 to BandsCount - 1 do
      if Bands[I].Visible then
        if Bands[I].Height > Result then
          Result := Bands[I].Height;
  end;
end;

function TvgrCBRow.GetMax : integer;
begin
  Result := GetMin + GetSize;
end;

procedure TvgrCBRow.AddBand(Band : TvgrCBBand);
begin
  FBands.Add(Band);
  AlignBands;
end;

procedure TvgrCBRow.DeleteBand(Band : TvgrCBBand);
begin
  FBands.Remove(Band);
  if BandsCount = 0 then
    ControlBar.DeleteRow(Self)
  else
    AlignBands;
end;

function BandsSorTvgroc(it1,it2 : pointer) : integer;
begin
  Result := TvgrCBBand(it1).Min - TvgrCBBand(it2).Min;
end;

procedure TvgrCBRow.AlignBands;
var
  I: integer;
  PriorBand : TvgrCBBand;
begin
  FBands.Sort(BandsSorTvgroc);
  PriorBand := nil;
  for I := 0 to BandsCount - 1 do
    if Bands[I].Visible then
    begin
      if PriorBand <> nil then
        Bands[I].FMin := PriorBand.Min + PriorBand.Size
      else
        Bands[I].FMin := math.Max(0, Bands[I].FMin);
      PriorBand := Bands[I];
    end;
end;

/////////////////////////////////////////////////
//
// TvgrControlBar
//
/////////////////////////////////////////////////
constructor TvgrControlBar.Create(AOwner : TComponent);
begin
  inherited;
{$IFDEF VGR_DEMO}
  ShowDemoWarning;
{$ENDIF}
  ControlStyle := [csDesignInteractive, csAcceptsControls, csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  FRows := TList.Create;
  DockSite := true;
  Side := prcbsTop;
  Size := 100;
  FFirstCallAfterLoad := True;
end;

destructor TvgrControlBar.Destroy;
begin
  ClearRows;
  FRows.Free;
  inherited;
end;

procedure TvgrControlBar.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('Layout', ReadLayout, WriteLayout, RowsCount > 0);
end;

procedure TvgrControlBar.ReadLayout(Stream: TStream);
var
  I, J, N, K: Integer;
  ARow: TvgrCBRow;
  ABand: TvgrCBBand;
begin
  FreeListItems(FRows);
  FRows.Clear;
  Stream.Read(N, 4);
  for I := 0 to N - 1 do
  begin
    ARow := TvgrCBRow.Create(Self);
    Stream.Read(ARow.FLoadedMin, 4);
    Stream.Read(K, 4);
    for J := 0 to K - 1 do
    begin
      ABand := TvgrCBBand.Create;
      ABand.FRow := ARow;
      ABand.FLoadedControlName := ReadString(Stream);
      ABand.FLoadedVisible := ReadBoolean(Stream);
      ARow.FBands.Add(ABand);
    end;
    FRows.Add(ARow);
  end;
end;

procedure TvgrControlBar.WriteLayout(Stream: TStream);
var
  I, J, N: Integer;
begin
  I := RowsCount;
  Stream.Write(I, 4);
  for I := 0 to RowsCount - 1 do
  begin
    N := Rows[I].Bands[0].Min;
    Stream.Write(N, 4);
    N := Rows[I].BandsCount;
    Stream.Write(N, 4);
    for J := 0 to N - 1 do
    begin
      WriteString(Stream, Rows[I].Bands[J].Control.Name);
      WriteBoolean(Stream, Rows[I].Bands[J].Visible);
    end;
  end;
end;

procedure TvgrControlBar.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited;
  if (AComponent is TControl) and (AOperation = opRemove) then
    DeleteControl(TControl(AComponent));
end;

procedure TvgrControlBar.Loaded;
begin
  inherited;

  InternalBuildAfterLoad;
  if csDesigning in ComponentState then
  begin
    InternalCalculateBandsAfterLoad;
    InternalAlignControls;
  end
end;

procedure TvgrControlBar.InternalBuildAfterLoad;
var
  I, J: Integer;
  AControl: TControl;
  ABand: TvgrCBBand;
begin
  for I := 0 to RowsCount - 1 do
  begin
    for J := 0 to Rows[I].BandsCount - 1 do
    begin
      ABand := Rows[I].Bands[J];
      AControl := TControl(Owner.FindComponent(ABand.FLoadedControlName));
      if (AControl <> nil) and (AControl is TControl) then
      begin
        ABand.FControl := AControl;
        ABand.FVisible := ABand.FLoadedVisible;
      end;
    end;
  end;
end;

procedure TvgrControlBar.InternalCalculateBandsAfterLoad;
var
  I, J, AMin, AWidth, AHeight: Integer;
  ABand: TvgrCBBand;
begin
  for I := 0 to RowsCount - 1 do
  begin
    AMin := Rows[I].FLoadedMin;
    for J := 0 to Rows[I].BandsCount - 1 do
    begin
      ABand := Rows[I].Bands[J];
      GetBandSizes(Rows[I], ABand.Control, AWidth, AHeight);
      ABand.FWidth := AWidth;
      ABand.FHeight := AHeight;
      ABand.FMin := AMin;
      if IsVertical then
        AMin := ABand.FMin + AHeight
      else
        AMin := ABand.FMin + AWidth;
    end;
    Rows[I].AlignBands;
  end;
end;

function TvgrControlBar.GetControlRowCoord(Control : TControl) : integer;
begin
  if IsVertical then
    Result := Control.Left
  else
    Result := Control.Top;
end;

function TvgrControlBar.GetControlBandCoord(Control : TControl) : integer;
begin
  if IsVertical then
    Result := Control.Top
  else
    Result := Control.Left;
end;

function TvgrControlBar.FindRow(RowCoord : integer) : TvgrCBRow;
var
  i : integer;
begin
for i:=0 to RowsCount-1 do
  if Rows[i].Visible and (RowCoord>=Rows[i].Min) and (RowCoord<=Rows[i].Max) then
    begin
      Result := Rows[i];
      exit;
    end;
Result := nil;
end;

function TvgrControlBar.FindControlBand(Control  :TControl) : TvgrCBBand;
var
  I, J: integer;
begin
  for I := 0 to RowsCount - 1 do
    for J := 0 to Rows[I].BandsCount - 1 do
      if Rows[I].Bands[J].Control = Control then
      begin
        Result := Rows[I].Bands[J];
        exit;
      end;
  Result := nil;
end;

function TvgrControlBar.GetLastRowMax : integer;
begin
if RowsCount<=0 then
  Result := 0
else
  Result := Rows[RowsCount-1].Max;
end;

procedure TvgrControlBar.DeleteRow(Row : TvgrCBRow);
begin
FRows.Remove(Row);
Row.Free;
end;

procedure TvgrControlBar.DeleteControl(Control: TControl);
var
  Band: TvgrCBBand;
begin
  Band := FindControlBand(Control);
  if band <> nil then
  begin
    band.Row := nil;
    band.Free;
  end;
end;

function TvgrControlBar.IsControlVisible(Control : TControl) : boolean;
begin
Result := (csDesigning in ComponentState) or Control.Visible;
end;

procedure TvgrControlBar.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TvgrControlBar.EndUpdate;
begin
  Dec(FUpdateCount);
end;

procedure TvgrControlBar.SetupControlProperties(AControl: TControl);
begin
  if AControl is TToolBar then
    with TToolBar(AControl) do
    begin
      DragKind := dkDock;
      DragMode := dmAutomatic;
      EdgeBorders := [];
      Flat := True;
      AutoSize := True;
      Align := alNone;
    end;
end;

function TvgrControlBar.GetEnableUpdate: Boolean;
begin
  Result := FUpdateCount = 0;
end;

function WrapButtons(AToolBar: TToolBarAccess; AVertical: Boolean; var NewWidth, NewHeight: Integer): Boolean;
var
  Index, NcX, NcY: Integer;
  WrapStates: TBits;

  procedure CalcSize(var CX, CY: Integer);
  var
    IsWrapped: Boolean;
    I, Tmp, X, Y, HeightChange: Integer;
    Control: TControl;
  begin
    CX := 0;
    CY := 0;
    X := AToolBar.Indent;
    Y := 0;
    for I := 0 to AToolBar.ButtonCount - 1 do
    begin
      Control := TControl(AToolBar.Buttons[I]);
      if (csDesigning in AToolBar.ComponentState) or Control.Visible then
      begin
        if (Control is TToolButton) and (I < AToolBar.ButtonCount - 1) then
          if WrapStates <> nil then
            IsWrapped := WrapStates[I] else
            IsWrapped := TToolButton(Control).Wrap
        else
          IsWrapped := False;
        if Control is TToolButton and
          (TToolButton(Control).Style in [tbsSeparator, tbsDivider]) then
        begin
          { Store the change in height, from the current row to the next row
            after wrapping, in HeightChange. THe IE4 version of comctl32
            considers this height to be the width the last separator on the
            current row - prior versions of comctl32 consider this height to be
            2/3 the width the last separator. }
          HeightChange := Control.Width;
          if (GetComCtlVersion < ComCtlVersionIE4) or not AToolBar.Flat and
            (GetComCtlVersion >= ComCtlVersionIE401) then
            HeightChange := HeightChange * 2 div 3;
          if IsWrapped and (I < AToolBar.ButtonCount - 1) then
          begin
            Tmp := Y + AToolBar.ButtonHeight + HeightChange;
            if Tmp > CY then
              CY := Tmp;
          end
          else
          begin
            Tmp := X + Control.Width;
            if Tmp > CX then
              CX := Tmp;
          end;
          if IsWrapped then
            Inc(Y, HeightChange);
        end
        else
        begin
          Tmp := X + Control.Width;
          if Tmp > CX then
            CX := Tmp;
          Tmp := Y + AToolBar.ButtonHeight;
          if Tmp > CY then
            CY := Tmp;
        end;
        if IsWrapped then
        begin
          X := AToolBar.Indent;
          Inc(Y, AToolBar.ButtonHeight);
        end
        else
          Inc(X, Control.Width);
      end;
    end;
    { Adjust for 2 pixel top margin when not flat style buttons }
    if (CY > 0) and not AToolBar.Flat then Inc(CY, 2);
  end;

  function WrapHorz(CX: Integer): Integer;
  var
    I, J, X: Integer;
    Control: TControl;
    Found: Boolean;
  begin
    Result := 1;
    X := AToolBar.Indent;
    I := 0;
    while I < AToolBar.ButtonCount do
    begin
      Control := TControl(AToolBar.Buttons[I]);
      if Control is TToolButton then
        WrapStates[I] := False;
      if (csDesigning in AToolBar.ComponentState) or Control.Visible then
      begin
        if (X + Control.Width > CX) and (not (Control is TToolButton) or
          not (TToolButton(Control).Style in [tbsDivider, tbsSeparator])) then
        begin
          Found := False;
          for J := I downto 0 do
            if TControl(AToolBar.Buttons[J]) is TToolButton then
              with TToolButton(AToolBar.Buttons[J]) do
                if ((csDesigning in ComponentState) or Visible) and
                  (Style in [tbsSeparator, tbsDivider]) then
                begin
                  if not WrapStates[J] then
                  begin
                    Found := True;
                    I := J;
                    X := AToolBar.Indent;
                    WrapStates[J] := True;
                    Inc(Result);
                  end;
                  Break;
                end;
          if not Found then
          begin
            for J := I - 1 downto 0 do
              if TControl(AToolBar.Buttons[J]) is TToolButton then
                with TToolButton(AToolBar.Buttons[J]) do
                  if (csDesigning in ComponentState) or Visible then
                  begin
                    if not WrapStates[J] then
                    begin
                      Found := True;
                      I := J;
                      X := AToolBar.Indent;
                      WrapStates[J] := True;
                      Inc(Result);
                    end;
                    Break;
                  end;
            if not Found then
              Inc(X, Control.Width);
          end;
        end
        else
          Inc(X, Control.Width);
      end;
      Inc(I);
    end;
  end;

  function InternalButtonCount: Integer;
  begin
    Result := AToolBar.Perform(TB_BUTTONCOUNT, 0, 0);
  end;
  
begin
  Result := True;
  if AToolBar.HandleAllocated then
  begin
    Index := InternalButtonCount - 1;
    if (Index >= 0) or not (csDesigning in AToolBar.ComponentState) then
    begin
      WrapStates := TBits.Create;
      try
        NcX := AToolBar.Width - AToolBar.ClientWidth;
        NcY := AToolBar.Height - AToolBar.ClientHeight;

        WrapHorz(NewWidth);
        CalcSize(NewWidth, NewHeight);

        if AVertical then
        begin
          for Index := 0 to WrapStates.Size - 1 do
            if TControl(AToolBar.Buttons[Index]) is TToolButton then
              TToolButton(AToolBar.Buttons[Index]).Wrap := WrapStates[Index];
        end;

        NewWidth := NewWidth + NcX;
        NewHeight := NewHeight + NcY;
      finally
        WrapStates.Free;
      end;
    end;
  end;
end;

procedure TvgrControlBar.GetBandSizes(ARow: TvgrCBRow; AControl: TControl; var AWidth, AHeight: Integer);
var
  I, ASize, ATempWidth, ATempHeight: Integer;
begin
  if AControl is TToolBar then
  begin
    if (csDesigning in ComponentState) and (TToolBar(AControl).ButtonCount = 0) then
    begin
      if IsVertical then
      begin
        AWidth := 30;
        AHeight := 100;
      end
      else
      begin
        AWidth := 100;
        AHeight := 30;
      end;
    end
    else
    begin
      ASize := 0;
      if (ARow <> nil) and IsVertical then
      begin
        for I := 0 to ARow.BandsCount - 1 do
        begin
          if (ARow.Bands[I].Control <> AControl) and (ARow.Bands[I].Control is TToolBar) then
          begin
            ATempWidth := 0;
            ATempHeight := MaxInt;
            WrapButtons(TToolBarAccess(ARow.Bands[I].Control), True, ATempWidth, ATempHeight);
            ATempWidth := ATempWidth - BorderOffs - BorderOffs;
            if ATempWidth > ASize then
              ASize := ATempWidth;
          end;
        end;
      end;

      if IsVertical then
      begin
        AWidth := ASize;
        AHeight := MaxInt;
      end
      else
      begin
        AWidth := MaxInt;
        AHeight := ASize;
      end;
      WrapButtons(TToolBarAccess(AControl), IsVertical, AWidth, AHeight);
    end;
  end
  else
    with AControl do
    begin
      AWidth := Width;
      AHeight := Height;
    end;

  if IsVertical then
  begin
    AWidth := AWidth + BorderOffs + BorderOffs;
    AHeight := AHeight + CaptionOffs + BorderOffs + BorderOffs;
  end
  else
  begin
    AWidth := AWidth + CaptionOffs + BorderOffs + BorderOffs;
    AHeight := AHeight + BorderOffs + BorderOffs;
  end;
end;

procedure TvgrControlBar.InternalAlignControls;
var
  I, J : integer;
  AControl: TControl;
begin
  BeginUpdate;
  try
    for I := 0 to RowsCount - 1 do
      if Rows[I].Visible then
        for J := 0 to Rows[I].BandsCount - 1 do
          if Rows[I].Bands[J].Visible then
          begin
            AControl := Rows[I].Bands[J].Control;
            if IsVertical then
            begin
              AControl.SetBounds(Rows[I].Min + BorderOffs,
                                 Rows[I].Bands[J].Min + BorderOffs + CaptionOffs,
                                 Rows[I].Size - BorderOffs - BorderOffs,
                                 Rows[I].Bands[J].Size - CaptionOffs - BorderOffs - BorderOffs);
              with Rows[I].Bands[J] do
              begin
                Width := Control.Width + BorderOffs + BorderOffs;
                Height := Control.Height + CaptionOffs + BorderOffs + BorderOffs;
              end;
            end
            else
            begin
              AControl.SetBounds(Rows[I].Bands[j].Min + CaptionOffs + BorderOffs,
                                 Rows[I].Min + BorderOffs,
                                 Rows[I].Bands[J].Size - CaptionOffs - BorderOffs - BorderOffs,
                                 Rows[I].Size - BorderOffs - BorderOffs);
              with Rows[I].Bands[J] do
              begin
                Width := Control.Width + CaptionOffs + BorderOffs + BorderOffs;
                Height := Control.Height + BorderOffs + BorderOffs;
              end;
            end;
          end;
    if not (csDesigning in ComponentState) then
      UpdateSize;
    Repaint;
  finally
    EndUpdate;
  end;
end;

function TvgrControlBar.IsAllControlsCreated: Boolean;
var
  I, J: Integer;
begin
  for I := 0 to RowsCount - 1 do
    for J := 0 to Rows[I].BandsCount - 1 do
      if (Rows[I].Bands[J].Control = nil) or
         ((Rows[I].Bands[J].Control is TWinControl) and
          not (TWinControlAccess(Rows[I].Bands[J].Control).HandleAllocated)) then
      begin
        Result := False;
        exit;
      end;
  Result := True;
end;

procedure TvgrControlBar.AlignControls(Control: TControl; var ARect: TRect);
var
  I, AWidth, AHeight: integer;
  ABand: TvgrCBBand;
  ARow: TvgrCBRow;
  AControl: TControl;
  ANeedRepeat: Boolean;
begin
  if EnableUpdate and not (csLoading in ComponentState) and IsAllControlsCreated then
  begin
    BeginUpdate;
    try
      if FFirstCallAfterLoad and not (csDesigning in ComponentState) then
      begin
        InternalCalculateBandsAfterLoad;
        FFirstCallAfterLoad := False;
      end
      else
      begin
        ANeedRepeat := False;
        repeat
        for I := 0 to ControlCount - 1 do
        begin
          AControl := Controls[I];
          ABand := FindControlBand(AControl);
          if ABand = nil then
          begin
            // new control added
            // 1. find row for control
            ARow := FindRow(GetControlRowCoord(aControl) + BorderOffs);
            if ARow = nil then
            begin
              // row not found create new
              ARow := TvgrCBRow.Create(Self);
              FRows.Add(ARow);
            end;

            // 2. create band
            GetBandSizes(ARow, AControl, AWidth, AHeight);
            TvgrCBBand.Create(ARow,
                              AControl,
                              AWidth,
                              AHeight,
                              GetControlBandCoord(AControl) - BorderOffs - CaptionOffs);
          end
          else
            if IsControlVisible(Controls[I]) and not ABand.Visible then
            begin
              // show control
              FindControlBand(AControl).Visible := True;
            end
            else
              if not IsControlVisible(Controls[I]) and ABand.Visible then
              begin
                // hide control
                FindControlBand(AControl).Visible := False;
              end
              else
                if IsControlVisible(Controls[I]) then
                begin
                  // control position is changed
                  ABand := FindControlBand(AControl);
                  ARow := FindRow(GetControlRowCoord(AControl));
                  if ARow = nil then
                  begin
                    // row not found create new
                    ARow := TvgrCBRow.Create(Self);
                    FRows.Add(ARow);
                    ANeedRepeat := not ANeedRepeat;
                  end;
                  ABand.Row := ARow;
                  GetBandSizes(ARow, AControl, AWidth, AHeight);
                  ABand.Width := AWidth;
                  ABand.Height := AHeight;
                end;
        end;
        until not ANeedRepeat;
      end;

      InternalAlignControls;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TvgrControlbar.UpdateSize;
begin
Size := GetLastRowMax;
end;

function TvgrControlBar.IsVertical : boolean;
begin
Result := FSide in [prcbsLeft,prcbsRight];
end;

function TvgrControlBar.GetRow(i : integer) : TvgrCBRow;
begin
Result := TvgrCBRow(FRows[i]);
end;

function TvgrControlBar.GetRowsCount : integer;
begin
Result := FRows.Count;
end;

procedure TvgrControlBar.ClearRows;
var
  i : integer;
begin
for i:=0 to FRows.Count-1 do
  Rows[i].Free;
FRows.Clear;
end;

procedure TvgrControlBar.CreateParams(var Params: TCreateParams);
begin
inherited;
with Params.WindowClass do
  style := style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TvgrControlBar.Paint;
var
  r : TRect;
  i,j : integer;
begin
with Canvas do
  begin
    if csDesigning in ComponentState then
      begin
        Pen.Color := clBlack;
        Brush.Color := clBtnFace;
        Rectangle(0,0,ClientWidth,ClientHeight);
      end
    else
      begin
        Brush.Color := clBtnFace;
        FillRect(Rect(0,0,ClientWidth,ClientHeight));
      end;
    // Draw bands
    for i:=0 to RowsCount-1 do
      for j:=0 to Rows[i].BandsCount-1 do
        if Rows[i].Bands[j].Visible then
          begin
            r := Rows[i].Bands[j].Rect;
            DrawEdge(Handle,r,BDR_RAISEDINNER,BF_RECT);

            if IsVertical then
              begin
                r := Rect(r.Left+2,r.Top+2,r.Right-2,r.Top+4);
                DrawEdge(Handle,r,BDR_RAISEDINNER,BF_RECT);
                OffsetRect(r,0,3);
                DrawEdge(Handle,r,BDR_RAISEDINNER,BF_RECT);
              end
            else
              begin
                r := Rect(r.Left+2,r.Top+2,r.Left+4,r.Bottom-2);
                DrawEdge(Handle,r,BDR_RAISEDINNER,BF_RECT);
                OffsetRect(r,3,0);
                DrawEdge(Handle,r,BDR_RAISEDINNER,BF_RECT);
              end;
          end;
  end;
end;

procedure TvgrControlBar.SetSide(Value : TvgrControlBarSide);
begin
if FSide=Value then exit;
FSide := Value;
Align := aAlignArray[FSide];
end;

function TvgrControlBar.GetSize : integer;
begin
if IsVertical then
  Result := Width
else
  Result := Height;
end;

procedure TvgrControlBar.SetSize(Value : integer);
begin
if GetSize=Value then exit;
if IsVertical then
  Width := Value
else
  Height := Value;
end;

procedure TvgrControlBar.GetPointInfoAt(X,Y : integer; var band : TvgrCBBand);
var
  i,j : integer;
begin
band := nil;
for i:=0 to RowsCount-1 do
  for j:=0 to Rows[i].BandsCount-1 do
    if Rows[i].Bands[j].Visible and PtInRect(Rows[i].Bands[j].Rect,Point(X,Y)) then
      begin
        band := Rows[i].Bands[j];
        exit;
      end;
end;

procedure TvgrControlBar.NotifyDesigner;
begin
  if (Owner is TForm) and (TForm(Owner).Designer <> nil) then
    TForm(Owner).Designer.Modified;
end;

procedure TvgrControlBar.MouseDown(Button : TMouseButton; Shift : TShiftState; X,Y: integer);
begin
  GetPointInfoAt(X,Y,FDownBand);
  FDownMousePos := Point(X, Y);
end;

procedure TvgrControlBar.MouseMove(Shift : TShiftState; X,Y : Integer);
var
  AOldRow, Row: TvgrCBRow;
  I, RowCoord, BandCoord, AWidth, AHeight: Integer;
begin
  if (FDownBand = nil) or
     (not (FDownBand.Control is TToolBar)) or
     (TToolBar(FDownBand.Control).DragKind <> dkDock) or
     ((FDownMousePos.X = X) and (FDownMousePos.Y = Y)) then exit;

  FDownMousePos := Point(X, Y);
  if IsVertical then
  begin
    RowCoord := X;
    BandCoord := Y;
  end
  else
  begin
    RowCoord := Y;
    BandCoord := X;
  end;

  if ((RowCoord < 0) or (RowCoord > GetLastRowMax)) and (FDownBand.Row.VisibleBandsCount = 1) then
  begin
    if not (csDesigning in ComponentState) then
    begin
      // start drag operation
      FDownBand.Control.BeginDrag(true);
      DeleteControl(FDownBand.Control);
      FDownBand := nil;
    end;
  end
  else
  begin
    // find new band position
    if FDownBand.Row.BandsCount > 1 then
      AOldRow := FDownBand.Row
    else
      AOldRow := nil;
    Row := FindRow(RowCoord);
    if Row = nil then
    begin
      Row := TvgrCBRow.Create(Self);
      if RowCoord < 0 then
        FRows.Insert(0, Row)
      else
        FRows.Add(Row);
    end;
    FDownBand.Row := Row;
    FDownBand.Min := BandCoord;
    GetBandSizes(Row, FDownBand.Control, AWidth, AHeight);
    FDownBand.Width := AWidth;
    FDownBand.Height := AHeight;

    // realign old FDownBand row
    if AOldRow <> nil then
      for I := 0 to AOldRow.BandsCount - 1 do
      begin
        if AOldRow.Bands[I].Control <> nil then
        begin
          GetBandSizes(AOldRow, AOldRow.Bands[I].Control, AWidth, AHeight);
          AOldRow.Bands[I].Width := AWidth;
          AOldRow.Bands[I].Height := AHeight;
        end;
      end;

    InternalAlignControls;

    NotifyDesigner;
  end;
end;

procedure TvgrControlBar.MouseUp(Button : TMouseButton; Shift : TShiftState; X,Y: Integer);
begin
  FDownBand := nil;
end;

procedure TvgrControlBar.PositionDockRect(DragDockObject: TDragDockObject);
var
  r: TRect;
  AWidth, AHeight: Integer;
begin
  inherited;

  if DragDockObject.Control <> nil then
  begin
    GetBandSizes(nil, DragDockObject.Control, AWidth, AHeight);
    r.Left := Mouse.CurSorPos.x; //DragDockObject.DockRect.Left;
    r.Top := Mouse.CurSorPos.y; //DragDockObject.DockRect.Top;
    r.Right := r.Left + AWidth;
    r.Bottom := r.Top + AHeight;
    DragDockObject.DockRect := r;
  end;
end;

procedure TvgrControlBar.CMDesignHitTest(var Msg : TCMDesignHitTest);
var
  band: TvgrCBBand;
begin
  GetPointInfoAt(Msg.XPos,Msg.YPos,band);
  Msg.Result := Ord((FDownBand <> nil) or (band <> nil));
end;

procedure TvgrControlBar.CMControlListChange(var Msg : TCMControlListChange);
begin
  inherited;
  if Msg.Control <> nil then
  begin
    if Msg.Inserting then
    begin
      // Setup default control properties for better
      if ((csDesigning in ComponentState) or (csDesigning in Msg.Control.ComponentState)) and
         not (csLoading in ComponentState) and not (csLoading in Msg.Control.ComponentState) then
        SetupControlProperties(Msg.Control);
    end
    else
//      if EnableUpdate then
        DeleteControl(Msg.Control);
  end;
end;

procedure TvgrControlBar.SetControlVisible(Control : TControl; Visible : boolean);
var
  Band: TvgrCBBand;
begin
  Band := FindControlBand(Control);
  if Band <> nil then
  begin
    BeginUpdate;
    try
      band.Visible := Visible;
      band.Control.Visible := Visible;
      InternalAlignControls;
    finally
      EndUpdate;
    end;
  end;
end;

/////////////////////////////////////////////////
//
// TvgrControlBarManager
//
/////////////////////////////////////////////////
constructor TvgrControlBarManager.Create(AOwner : TComponent); 
begin
  inherited;
{$IFDEF VGR_DEMO}
  ShowDemoWarning;
{$ENDIF}
  FToolbarsList := TList.Create;
  FRestoredToolbars := TList.Create;
end;

destructor TvgrControlBarManager.Destroy;
begin
  if Owner is TForm then
    TForm(Owner).OnShow := FOldOnFormShow;
  FToolbarsList.Free;
  FRestoredToolbars.Free;
  inherited;
end;

procedure TvgrControlBarManager.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited;
  if AOperation = opRemove then
  begin
    if AComponent = FLeftCB then
      FLeftCB := nil;
    if AComponent = FTopCB then
      FTopCB := nil;
    if AComponent = FRightCB then
      FRightCB := nil;
    if AComponent = FBottomCB then
      FBottomCB := nil;
  end;
end;

procedure TvgrControlBarManager.Loaded;
var
  fLoading: Boolean;
begin
  fLoading := csLoading in ComponentState;
  inherited;
  if not (csDesigning in ComponentState) and fLoading then
  begin
    if Owner is TForm then
    begin
      FOldOnFormShow := TForm(Owner).OnShow;
      TForm(Owner).OnShow := OnFormShow;
    end;
  end;
end;

procedure TvgrControlBarManager.OnFormShow(Sender : TObject);
var
  I: integer;
begin
  for I := 0 to FRestoredToolbars.Count - 1 do
    with TToolbar(FRestoredToolbars[I]) do
    begin
      EnableWindow(Parent.Handle, True);
      SetWindowPos(Parent.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOZORDER);
      SetWindowLong(Parent.Handle, GWL_HWNDPARENT, Longint(TForm(Owner).Handle));
    end;
  FRestoredToolbars.Clear;
  if Assigned(FOldOnFormShow) then
    FOldOnFormShow(Owner);
end;

procedure TvgrControlBarManager.GetToolbarsList;
var
  I: integer;
begin
  FToolbarsList.Clear;
  if Assigned(FOnGetToolbarsList) then
    FOnGetToolbarsList(Self, FToolbarsList)
  else
    for I := 0 to Owner.ComponentCount - 1 do
      if Owner.Components[I] is TToolBar then
        FToolbarsList.Add(Owner.Components[I]);
end;

function TvgrControlBarManager.GetToolbar(I: integer) : TToolbar;
begin
  Result := TToolBar(FToolbarsList[i]);
end;

function TvgrControlBarManager.GetToolbarsCount : integer;
begin
  Result := FToolbarsList.Count;
end;

procedure TvgrControlBarManager.WriteToolbar(Toolbar: TToolbar; AStorage: TvgrIniStorage; const SectionName: string);
var
  ADockSide: Integer;
begin
  AStorage.EraseSection(SectionName);
  AStorage.WriteBool(SectionName, 'Visible', ToolBar.Visible);
  if not Toolbar.Floating and (ToolBar.Parent is TvgrControlBar) then
  begin
    if Toolbar.Parent = LeftCB then
      ADockSide := 0
    else
      if Toolbar.Parent = RightCB then
        ADockSide := 1
      else
        if Toolbar.Parent = TopCB then
          ADockSide := 2
        else
          if Toolbar.Parent = BottomCB then
            ADockSide := 3
          else
            ADockSide := -1;

    if ADockSide <> -1 then
    begin
      AStorage.WriteBool(SectionName, 'Floating', False);
      AStorage.WriteInteger(SectionName, 'DockSide', ADockSide);
      exit;
    end;
  end;

  AStorage.WriteBool(SectionName, 'Floating', True);
  with ToolBar.Parent.BoundsRect do
  begin
    AStorage.WriteInteger(SectionName, 'Left', Left);
    AStorage.WriteInteger(SectionName, 'Top', Top);
    AStorage.WriteInteger(SectionName, 'Right', Right);
    AStorage.WriteInteger(SectionName, 'Bottom', Bottom);
  end;
end;

procedure TvgrControlBarManager.WriteControlBar(AControlBar: TvgrControlBar; AStorage: TvgrIniStorage; const SectionName: string);
var
  I, J: Integer;
  S, S2: string;
  ARow: TvgrCBRow;
begin
  AStorage.EraseSection(SectionName);
  AStorage.WriteInteger(SectionName, 'RowsCount', AControlBar.RowsCount);
  for I := 0 to AControlBar.RowsCount - 1 do
  begin
    S := 'Row' + IntToStr(I);
    ARow := AControlBar.Rows[I];
    AStorage.WriteInteger(SectionName, S + '_Min', ARow.Bands[0].Min);
    AStorage.WriteInteger(SectionName, S + '_Count', ARow.BandsCount);
    for J := 0 to ARow.BandsCount - 1 do
    begin
      S2 := S + '_Band' + IntToStr(J);
      AStorage.WriteString(SectionName, S2 + '_Control', ARow.Bands[J].Control.Name);
      AStorage.WriteBool(SectionName, S2 + '_Visible', ARow.Bands[J].Visible);
    end;
  end;
end;

procedure TvgrControlBarManager.WriteToStorage(AStorage: TvgrIniStorage; const SectionNamePrefix: string);
var
  I: integer;
begin
  if LeftCB <> nil then
    WriteControlBar(LeftCB, AStorage, SectionNamePrefix + 'LeftControlBar');
  if RightCB <> nil then
    WriteControlBar(RightCB, AStorage, SectionNamePrefix + 'RightControlBar');
  if TopCB <> nil then
    WriteControlBar(TopCB, AStorage, SectionNamePrefix + 'TopControlBar');
  if BottomCB <> nil then
    WriteControlBar(BottomCB, AStorage, SectionNamePrefix + 'BottomControlBar');

  GetToolbarsList;
  for I := 0 to ToolbarsCount - 1 do
    WriteToolbar(Toolbars[I], AStorage, SectionNamePrefix + Toolbars[I].Name);
end;

procedure TvgrControlBarManager.ReadFromStorage(AStorage: TvgrIniStorage; const SectionNamePrefix: string);
var
  I: integer;

  procedure EndReadControlBar(AControlBar: TvgrControlBar);
  begin
    if AControlBar <> nil then
    begin
      AControlBar.InternalCalculateBandsAfterLoad;
      AControlBar.InternalAlignControls;
      AControlBar.EndUpdate;
    end;
  end;
  
begin
  if LeftCB <> nil then
    LeftCB.BeginUpdate;
  if TopCB <> nil then
    TopCB.BeginUpdate;
  if RightCB <> nil then
    RightCB.BeginUpdate;
  if BottomCB <> nil then
    BottomCB.BeginUpdate;

  try
    GetToolbarsList;
    for I := 0 to ToolbarsCount - 1 do
      ReadToolBar(ToolBars[I], AStorage, SectionNamePrefix + ToolBars[I].Name);

    if LeftCB <> nil then
      ReadControlBar(LeftCB, AStorage, SectionNamePrefix + 'LeftControlBar');
    if RightCB <> nil then
      ReadControlBar(RightCB, AStorage, SectionNamePrefix + 'RightControlBar');
    if TopCB <> nil then
      ReadControlBar(TopCB, AStorage, SectionNamePrefix + 'TopControlBar');
    if BottomCB <> nil then
      ReadControlBar(BottomCB, AStorage, SectionNamePrefix + 'BottomControlBar');
  finally
    EndReadControlBar(LeftCB);
    EndReadControlBar(TopCB);
    EndReadControlBar(RightCB);
    EndReadControlBar(BottomCB);
  end;
end;

procedure TvgrControlBarManager.ReadToolbar(Toolbar: TToolbar; AStorage: TvgrIniStorage; const SectionName: string);
var
  ADockSide: integer;
  AFloating: Boolean;
  ADockControlBar: TvgrControlBar;
begin
  if not AStorage.SectionExists(SectionName) then exit;

  ADockSide := AStorage.ReadInteger(SectionName, 'DockSide', -1);
  AFloating := AStorage.ReadBool(SectionName, 'Floating', True);
  case ADockSide of
    0: ADockControlBar := LeftCB;
    1: ADockControlBar := RightCB;
    2: ADockControlBar := TopCB;
    3: ADockControlBar := BottomCB;
    else ADockControlBar := nil;
  end;

  if (ADockControlBar <> nil) and not AFloating then
  begin
    if ToolBar.Parent <> ADockControlBar then
    begin
      if ToolBar.Parent is TvgrControlBar then
        TvgrControlBar(Toolbar.Parent).DeleteControl(Toolbar);
      Toolbar.Parent := ADockControlBar;
    end;
  end
  else
  begin
    if ToolBar.Parent is TvgrControlBar then
      TvgrControlBar(ToolBar.Parent).DeleteControl(ToolBar);

    ToolBar.ManualFloat(Rect(AStorage.ReadInteger(SectionName, 'Left', 0),
                             AStorage.ReadInteger(SectionName, 'Top', 0),
                             AStorage.ReadInteger(SectionName, 'Right', ToolBar.Width),
                             AStorage.ReadInteger(SectionName, 'Bottom', ToolBar.Height)));
    FRestoredToolbars.Add(ToolBar);
  end;
  ToolBar.Visible := AStorage.ReadBool(SectionName, 'Visible', true);
end;

procedure TvgrControlBarManager.ReadControlBar(AControlBar: TvgrControlBar; AStorage: TvgrIniStorage; const SectionName: string);
var
  I, J, N, K: Integer;
  ARow: TvgrCBRow;
  ABand: TvgrCBBand;
  S, S2, AControlName: string;
  AControl: TComponent;
begin
  if not AStorage.SectionExists(SectionName) then exit;

  FreeListItems(AControlBar.FRows);
  AControlBar.FRows.Clear;
  N := AStorage.ReadInteger(SectionName, 'RowsCount', 0);
  for I := 0 to N - 1 do
  begin
    S := 'Row' + IntToStr(I);
    ARow := TvgrCBRow.Create(AControlBar);
    ARow.FLoadedMin := AStorage.ReadInteger(SectionName, S + '_Min', 0);
    K := AStorage.ReadInteger(SectionName, S + '_Count', 0);
    for J := 0 to K - 1 do
    begin
      S2 := S + '_Band' + IntToStr(J);
      AControlName := AStorage.ReadString(SectionName, S2 + '_Control', '');
      AControl := Owner.FindComponent(AControlName);
      if AControl is TControl then
      begin
        ABand := TvgrCBBand.Create;
        ABand.FRow := ARow;
        ABand.FControl := TControl(AControl);
        ABand.FVisible := AStorage.ReadBool(SectionName, S2 + '_Visible', True);
        ARow.FBands.Add(ABand);
      end;
    end;
    if ARow.BandsCount > 0 then
      AControlBar.FRows.Add(ARow)
    else
      ARow.Free;
  end;
end;

procedure TvgrControlBarManager.WriteToIni(const AIniFileName: string; const SectionNamePrefix : string);
var
  AIniFile: TvgrIniFileStorage;
begin
  AIniFile := TvgrIniFileStorage.Create(AIniFileName);
  try
    WriteToStorage(AIniFile, SectionNamePrefix);
  finally
    AIniFile.Free;
  end;
end;

procedure TvgrControlBarManager.ReadFromIni(const AIniFileName: string; const SectionNamePrefix : string);
var
  AIniFile: TvgrIniFileStorage;
begin
  AIniFile := TvgrIniFileStorage.Create(AIniFileName);
  try
    ReadFromStorage(AIniFile, SectionNamePrefix);
  finally
    AIniFile.Free;
  end;
end;

procedure TvgrControlBarManager.ShowHideToolBar(ToolBar: TToolBar; Visible: Boolean);
begin
  GetToolBarsList;
  if FToolBarsList.IndexOf(ToolBar) = -1 then exit;
  if ToolBar.Floating then
    ToolBar.Visible := Visible
  else
    if ToolBar.Parent is TvgrControlBar then
      TvgrControlBar(ToolBar.Parent).SetControlVisible(ToolBar, Visible);
end;

end.

