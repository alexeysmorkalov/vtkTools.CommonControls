{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2003 by vtkTools      }
{                                          }
{******************************************}

{ Contains @link(TvgrBevelLabel) - this component combines possibilities of TBevel and TLabel.


See also:
vgr_FontComboBox,vgr_ControlBar,vgr_ColorButton}

unit vgr_Label;

interface

{$I vtk.inc}

uses
  Classes, Controls, StdCtrls, Windows, Graphics, Math;

type

  { Specify position of the beveled line
     vgrlbsCenterLine - line vertically centered in the control
     vgrlbsTopLine - line are top aligned in the control
     vgrlbsBottomLine - line are bottom aligned in the control }
  TvgrLabelBevelStyle = (vgrlbsCenterLine, vgrlbsTopLine, vgrlbsBottomLine);

  /////////////////////////////////////////////////
  //
  // TvgrBevelLabel
  //
  /////////////////////////////////////////////////
  { TvgrBevelLabel combines possibilities of TBevel and TLabel.

    Use TextWidthPercent property to specify ratio between areas of the text and beveled line.
    Use BevelStyle property to specify position of the beveled line. }
  TvgrBevelLabel = class(TCustomLabel)
  private
    FTextWidthPercent: Integer;
    FBevelStyle: TvgrLabelBevelStyle;
    procedure SetTextWidthPercent(Value: Integer);
    procedure SetBevelStyle(Value: TvgrLabelBevelStyle);
    function GetTextWidth: Integer;
  protected
    procedure AdjustBounds; override;
    procedure Paint; override;
    property TextWidth: Integer read GetTextWidth;
  public
{Creates a TvgrBevelLabel control.
AOwner is the component that is responsible for freeing the label. 
It becomes the value of the Owner property.}
    constructor Create(AOwner: TComponent); override;
  published
    { Use TextWidthPercent property to specify ratio between areas of the text and beveled line. }
    property TextWidthPercent: Integer read FTextWidthPercent write SetTextWidthPercent default 100;
    { Use BevelStyle property to specify position of the beveled line. }
    property BevelStyle: TvgrLabelBevelStyle read FBevelStyle write SetBevelStyle default vgrlbsCenterLine;

    property Align;
    property Alignment;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color nodefault;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowAccelChar;
    property ShowHint;
    property Transparent;
    property Layout;
    property Visible;
    property WordWrap;
    property OnClick;
{$IFDEF VTK_D6_OR_D7}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
{$IFDEF VTK_D6_OR_D7}
    property OnMouseEnter;
    property OnMouseLeave;
{$ENDIF}
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  vgr_Functions;

const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);

/////////////////////////////////////////////////
//
// TvgrBevelLabel
//
/////////////////////////////////////////////////
constructor TvgrBevelLabel.Create(AOwner: TComponent);
begin
  inherited;
{$IFDEF VGR_DEMO}
  ShowDemoWarning;
{$ENDIF}
  AutoSize := False;
  FTextWidthPercent := 100;
end;

procedure TvgrBevelLabel.SetTextWidthPercent(Value: Integer);
begin
  if FTextWidthPercent <> Value then
  begin
    FTextWidthPercent := Value;
    Invalidate;
  end;
end;

procedure TvgrBevelLabel.SetBevelStyle(Value: TvgrLabelBevelStyle);
begin
  if FBevelStyle <> Value then
  begin
    FBevelStyle := Value;
    Invalidate;
  end;
end;

function TvgrBevelLabel.GetTextWidth: Integer;
var
  ARect: TRect;
begin
  Result := MulDiv(ClientRect.Right - ClientRect.Left, FTextWidthPercent, 100);

  ARect := ClientRect;
  DoDrawText(ARect, DT_CALCRECT or DT_EXPANDTABS or WordWraps[WordWrap] or Alignments[Alignment] or DT_CALCRECT);

  Result := Min(Result, ARect.Right - ARect.Left);
end;

procedure TvgrBevelLabel.AdjustBounds;
begin
end;

procedure TvgrBevelLabel.Paint;
const
  cBevelOffset = 2;
var
  Rect, CalcRect: TRect;
  DrawStyle: Longint;
  Color1, Color2: TColor;
  ATextWidth: Integer;

  procedure DrawLine(AColor: TColor; X1, Y1, X2, Y2: Integer);
  begin
    with Canvas do
    begin
      Brush.Color := AColor;
      FillRect(Classes.Rect(X1, Y1, X2, Y2));
    end;
  end;

  procedure DrawBevel(AFrom, ATo: Integer);
  var
    Y: Integer;
  begin
   with ClientRect do
     case BevelStyle of
       vgrlbsCenterLine:
         Y := Top + (Bottom - Top - 2) div 2;
       vgrlbsTopLine:
         Y := Top + cBevelOffset;
     else
       Y := Bottom - 2 - cBevelOffset;
    end;
    DrawLine(Color1, AFrom, Y, ATo, Y + 1);
    DrawLine(Color2, AFrom, Y + 1, ATo, Y + 2);
  end;

begin
  with Canvas do
  begin
    if not Transparent then
    begin
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      FillRect(ClientRect);
    end;
    Brush.Style := bsClear;

    ATextWidth := Self.TextWidth;
    Rect := ClientRect;
    with Rect do
      case Alignment of
        taRightJustify: Left := Right - ATextWidth;
        taCenter:
          begin
            Left := Left + (Right - Left - ATextWidth) div 2;
            Right := Left + ATextWidth;
          end;
      else
        Right := Left + ATextWidth;
      end;

    { DoDrawText takes care of BiDi alignments }
    DrawStyle := DT_EXPANDTABS or WordWraps[WordWrap] or Alignments[Alignment];

    { Calculate vertical layout }
    if Layout <> tlTop then
    begin
      CalcRect := Rect;
      DoDrawText(CalcRect, DrawStyle or DT_CALCRECT);
      if Layout = tlBottom then OffsetRect(Rect, 0, Height - CalcRect.Bottom)
      else OffsetRect(Rect, 0, (Height - CalcRect.Bottom) div 2);
    end;
    DoDrawText(Rect, DrawStyle);

    { Draw bevel }
    Color1 := clBtnShadow;
    Color2 := clBtnHighlight;
    Brush.Style := bsSolid;

    case Alignment of
      taRightJustify: DrawBevel(ClientRect.Left, Rect.Left - 2);
      taCenter:
        begin
          DrawBevel(ClientRect.Left, Rect.Left - 2);
          DrawBevel(Rect.Right + 2, ClientRect.Right);
        end;
    else
      DrawBevel(Rect.Right + 2, ClientRect.Right);
    end;
  end;
end;

end.
