{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2004 by vtkTools      }
{                                          }
{******************************************}

{Contains the some base classes which are used in other modules.}
unit vgr_Button;

interface

{$I vtk.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls,Buttons;

type
  TvgrDropDownForm = class;
  TvgrDropDownFormClass = class of TvgrDropDownForm;

  /////////////////////////////////////////////////
  //
  // TvgrBaseButton
  //
  /////////////////////////////////////////////////
{Base class for buttons.
See also:
  TvgrColorButton, TvgrMultiPageButton}
  TvgrBaseButton = class(TButtonControl)
  private
    FFlat: Boolean;
    FDropDownArrow: Boolean;
    FMouseInControl: Boolean;
    FDropDownForm: TvgrDropDownForm;

    procedure SetDropDownArrow(Value: Boolean);
    procedure SetFlat(Value: Boolean);
  protected
    function GetDropDownFormClass: TvgrDropDownFormClass; virtual;
    function GetDrawFocusRect: Boolean; virtual;
    procedure ShowDropDownForm; virtual;
    procedure DrawFocusedBorder(ADC: HDC; var ARect: TRect; AFillInnerRect: Boolean);
    procedure DrawRaiseBorder(ADC: HDC; var ARect: TRect; AFillInnerRect: Boolean);
    procedure DrawInnerBorder(ADC: HDC; var ARect: TRect; AFillInnerRect: Boolean);
    procedure DrawNoBorder(ADC: HDC; var ARect: TRect; AFillInnerRect: Boolean);
    procedure DrawButton(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean); virtual;
    procedure DrawButtonInternal(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean; const AInternalRect: TRect); virtual;

    procedure CNDrawItem(var Msg: TWMDrawItem); message CN_DRAWITEM;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    //procedure CNCommand(var Msg: TWMCommand); message CN_COMMAND;

    procedure CreateParams(var Params: TCreateParams); override;

    property DropDownForm: TvgrDropDownForm read FDropDownForm write FDropDownForm;
    property MouseInControl: Boolean read FMouseInControl write FMouseInControl; 
  public
{Creates an instance of the TvgrBaseButton class.
Parameters:
  AOwner - The component - owner.}
    constructor Create(AOwner: TComponent); override;
  published
{Set Flat to true to remove the raised border when the button is unselected and the lowered border when the button is clicked or selected.}
    property Flat: Boolean read FFlat write SetFlat default False;
{Specifies the value indicating whether the arrow is visible.}
    property DropDownArrow: Boolean read FDropDownArrow write SetDropDownArrow default False;
  end;

  /////////////////////////////////////////////////
  //
  // TvgrDropDownForm
  //
  /////////////////////////////////////////////////
{Base class for drop-down panels.
See also:
  TvgrColorPaletteForm, TvgrMultiPagePaletteForm}
  TvgrDropDownForm = class(TForm)
  private
    FButton: TvgrBaseButton;
  protected
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Deactivate; override;

    property Button: TvgrBaseButton read FButton write FButton;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeDestruction; override;
  end;

implementation

uses
  vgr_Functions, vgr_GUIFunctions;

/////////////////////////////////////////////////
//
// TvgrBaseButton
//
/////////////////////////////////////////////////
constructor TvgrBaseButton.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TvgrBaseButton.SetFlat(Value: Boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    Invalidate;
  end;
end;

procedure TvgrBaseButton.SetDropDownArrow(Value: Boolean);
begin
  if FDropDownArrow <> Value then
  begin
    FDropDownArrow := Value;
    Invalidate;
  end;
end;

procedure TvgrBaseButton.CreateParams(var Params: TCreateParams);
begin
  inherited;
  CreateSubClass(Params, 'BUTTON');
  Params.Style := Params.Style or BS_PUSHBUTTON or BS_OWNERDRAW;
end;

{
procedure TvgrBaseButton.CNCommand(var Msg: TWMCommand);
begin
  if Msg.NotifyCode = BN_CLICKED then
  begin
    Click;
    Msg.Result := 1;
  end;
end;
}

procedure TvgrBaseButton.CMMouseEnter(var Msg: TMessage);
begin
  if not (csDesigning in ComponentState) then
  begin
    FMouseInControl := True;
    Invalidate;
  end;
  inherited;
end;

procedure TvgrBaseButton.CMMouseLeave(var Msg: TMessage);
begin
  if not (csDesigning in ComponentState) then
  begin
    FMouseInControl := False;
    Invalidate;
  end;
  inherited;
end;

procedure TvgrBaseButton.CNDrawItem(var Msg: TWMDrawItem);
begin
  with Msg.DrawItemStruct^ do
    DrawButton(hDC,
               (itemState and ODS_DISABLED) <> 0,
               (itemState and ODS_SELECTED) <> 0,
               (itemState and ODS_FOCUS) <> 0,
               FMouseInControl or (csDesigning in ComponentState));
  Msg.Result := 1;
end;

procedure TvgrBaseButton.DrawRaiseBorder(ADC: HDC; var ARect: TRect; AFillInnerRect: Boolean);
var
  ABrush: HBRUSH;
begin
  ABrush := CreateSolidBrush(GetRGBColor(clBtnHighlight));
  with ARect do
  begin
    FillRect(ADC, Rect(Left, Top, Left + 1, Bottom - 1), ABrush);
    FillRect(ADC, Rect(Left, Top, Right - 1, Top + 1), ABrush);
  end;
  DeleteObject(ABrush);

  ABrush := CreateSolidBrush(GetRGBColor(clBtnShadow));
  with ARect do
  begin
    FillRect(ADC, Rect(Left, Bottom - 1, Right, Bottom), ABrush);
    FillRect(ADC, Rect(Right - 1, Top, Right, Bottom), ABrush);
  end;
  DeleteObject(ABrush);

  InflateRect(ARect, -1, -1);
  if AFillInnerRect then
  begin
    ABrush := CreateSolidBrush(GetRGBColor(clBtnFace));
    FillRect(ADC, ARect, ABrush);
    DeleteObject(ABrush);
  end;
end;

procedure TvgrBaseButton.DrawInnerBorder(ADC: HDC; var ARect: TRect; AFillInnerRect: Boolean);
var
  ABrush: HBRUSH;
begin
  ABrush := CreateSolidBrush(GetRGBColor(clBtnShadow));
  with ARect do
  begin
    FillRect(ADC, Rect(Left, Top, Left + 1, Bottom - 1), ABrush);
    FillRect(ADC, Rect(Left, Top, Right - 1, Top + 1), ABrush);
  end;
  DeleteObject(ABrush);

  ABrush := CreateSolidBrush(GetRGBColor(clBtnHighlight));
  with ARect do
  begin
    FillRect(ADC, Rect(Left, Bottom - 1, Right, Bottom), ABrush);
    FillRect(ADC, Rect(Right - 1, Top, Right, Bottom), ABrush);
  end;
  DeleteObject(ABrush);

  InflateRect(ARect, -1, -1);
  if AFillInnerRect then
  begin
    ABrush := CreateSolidBrush(GetRGBColor(clBtnFace));
    FillRect(ADC, ARect, ABrush);
    DeleteObject(ABrush);
  end;
end;

procedure TvgrBaseButton.DrawFocusedBorder(ADC: HDC; var ARect: TRect; AFillInnerRect: Boolean);
var
  ABrush: HBRUSH;
begin
  ABrush := CreateSolidBrush(GetRGBColor(clBtnShadow));
  with ARect do
  begin
    FillRect(ADC, Rect(Left, Top, Left + 1, Bottom - 1), ABrush);
    FillRect(ADC, Rect(Left, Top, Right - 1, Top + 1), ABrush);
    FillRect(ADC, Rect(Left, Bottom - 1, Right, Bottom), ABrush);
    FillRect(ADC, Rect(Right - 1, Top, Right, Bottom), ABrush);
  end;
  DeleteObject(ABrush);

  InflateRect(ARect, -1, -1);
  if AFillInnerRect then
  begin
    ABrush := CreateSolidBrush(GetRGBColor(clBtnHighlight));
    FillRect(ADC, ARect, ABrush);
    DeleteObject(ABrush);
  end;
end;

procedure TvgrBaseButton.DrawNoBorder(ADC: HDC; var ARect: TRect; AFillInnerRect: Boolean);
var
  ABrush: HBRUSH;
begin
  if AFillInnerRect then
  begin
    ABrush := CreateSolidBrush(GetRGBColor(clBtnFace));
    FillRect(ADC, ARect, ABrush);
    DeleteObject(ABrush);
  end;

  InflateRect(ARect, -1, -1);
end;

function TvgrBaseButton.GetDropDownFormClass: TvgrDropDownFormClass;
begin
  Result := nil;
end;

function TvgrBaseButton.GetDrawFocusRect: Boolean;
begin
  Result := True;
end;

procedure TvgrBaseButton.ShowDropDownForm;
var
  R: TRect;
  P: TPoint;
begin
  FDropDownForm := GetDropDownFormClass.Create(Self);
  FDropDownForm.Button := Self;
  SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);
  P := ClientToScreen(Point(0, 0));
  P.Y := P.Y + Height;
  if P.X + FDropDownForm.Width > R.Right then
    P.X := P.X - FDropDownForm.Width;
  if P.Y + FDropDownForm.Height > r.Bottom then
    P.Y := p.Y - FDropDownForm.Height - Height;
  FDropDownForm.Left := P.X;
  FDropDownForm.Top := P.Y;
  FDropDownForm.Show;
end;

procedure TvgrBaseButton.DrawButton(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean);
const
  APushedArray: Array [Boolean] of Integer = (0, DFCS_PUSHED);
  ADisabledArray: Array [Boolean] of Integer = (0, DFCS_INACTIVE);
var
  R: TRect;
  y: Integer;
  nbr: HBRUSH;
begin
  r := ClientRect;
  if FFlat then
  begin
    if ADisabled then
      DrawNoBorder(ADC, r, True)
    else
    begin
      if APushed then
        DrawInnerBorder(ADC, r, True)
      else
      begin
        if AUnderMouse then
          DrawRaiseBorder(ADC, r, True)
        else
          DrawNoBorder(ADC, r, True);
      end
    end;
    InflateRect(r, -1, -1);
  end
  else
  begin
    DrawFrameControl(ADC, r, DFC_BUTTON, DFCS_ADJUSTRECT or DFCS_BUTTONPUSH or APushedArray[APushed] or ADisabledArray[ADisabled]);
    InflateRect(r, -1, -1);
  end;

  if GetDrawFocusRect then
  begin
    if not ADisabled and AFocused then
      DrawFocusRect(ADC, r);
    InflateRect(r, -2, -2);
  end;

  if DropDownArrow then
  begin
    // draw arrow
    nbr := CreateSolidBrush(GetRGBColor(clBlack));
    with R do
    begin
      y := Top + (Bottom - Top) div 2 - 1;
      FillRect(ADC, Rect(Right - 7, y, Right - 2, y + 1), nbr);
      FillRect(ADC, Rect(Right - 6, y + 1, Right - 3, y + 2), nbr);
      FillRect(ADC, Rect(Right - 5, y + 2, Right - 4, y + 3), nbr);
    end;
    DeleteObject(nbr);

    r.Right := r.Right - 10;
    nbr := CreateSolidBrush(GetRGBColor(clBtnShadow));
    with r do
      FillRect(ADC, Rect(Right, Top + 1, Right + 1, Bottom - 2), nbr);
    DeleteObject(nbr);

    nbr := CreateSolidBrush(GetRGBColor(clBtnHighlight));
    with r do
      FillRect(ADC, Rect(Right + 1, Top + 1, Right + 2, Bottom - 2), nbr);
    DeleteObject(nbr);
  end;

  DrawButtonInternal(ADC, ADisabled, APushed, AFocused, AUnderMouse, r);
end;

procedure TvgrBaseButton.DrawButtonInternal(ADC: HDC; ADisabled, APushed, AFocused, AUnderMouse: Boolean; const AInternalRect: TRect);
begin
end;

/////////////////////////////////////////////////
//
// TvgrDropDownForm
//
/////////////////////////////////////////////////
constructor TvgrDropDownForm.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TvgrDropDownForm.CreateParams;
begin
  inherited;
  Params.Style := Params.Style and not WS_CAPTION;
end;

procedure TvgrDropDownForm.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  Msg.Result := 1;
end;

procedure TvgrDropDownForm.DoClose(var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TvgrDropDownForm.Deactivate;
begin
  inherited;
  Close;
end;

procedure TvgrDropDownForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_ESCAPE) and (Shift = []) then
    Close;
end;

procedure TvgrDropDownForm.BeforeDestruction;
begin
  if FButton <> nil then
    FButton.DropDownForm := nil;
end;

end.
