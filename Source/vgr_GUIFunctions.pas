unit vgr_GUIFunctions;

{$I vtk.inc}

interface

uses
  SysUtils, Windows, Graphics, Classes, Forms, Controls,
  comctrls, vgr_Functions;

const
{Specifies the set of charactes which will be used as "wrap" characters.}
  WordWrapChars: set of char = [' '];
  
type
  TvgrTextHorzAlign = (vgrthaLeft, vgrthaCenter, vgrthaRight);
{Describes the image align within a rectangle.
Items:
  vgridmCenter - The image should be centered in the rectangle.
  vgridmStretch - The image should be changed so that it exactly fits the rectangle.
  vgridmStretchProp - The image should be changed, without distortion, so that it fits the rectangle.}
  TvgrImageDrawMode = (vgridmCenter, vgridmStretch, vgridmStretchProp);

  RGNDATAHEADER = packed record
    dwSize: Integer;
    iType: Integer;
    nCount: Integer;
    nRgnSize: Integer;
    rcBound: TRect;
  end;
  pRGNDATAHEADER = ^RGNDATAHEADER;
  
  /////////////////////////////////////////////////
  //
  // TvgrFastRegion
  //
  /////////////////////////////////////////////////
(*$NODEFINE TvgrFastRegion*)
(*$HPPEMIT 'class DELPHICLASS TvgrFastRegion;'*)
(*$HPPEMIT 'class PASCALIMPLEMENTATION TvgrFastRegion : public System::TObject'*)
(*$HPPEMIT '{'*)
(*$HPPEMIT '	typedef System::TObject inherited;'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'private:'*)
(*$HPPEMIT '	RGNDATAHEADER *FRegionData;'*)
(*$HPPEMIT '	TRect *FRects;'*)
(*$HPPEMIT '	int FCapacity;'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'protected:'*)
(*$HPPEMIT '	void __fastcall Grow(void);'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'public:'*)
(*$HPPEMIT '	__fastcall TvgrFastRegion(void);'*)
(*$HPPEMIT '	__fastcall virtual ~TvgrFastRegion(void);'*)
(*$HPPEMIT '	void __fastcall Clear(void);'*)
(*$HPPEMIT '	void __fastcall AddRect(const TRect &ARect);'*)
(*$HPPEMIT '	HRGN __fastcall BuildRegion(void);'*)
(*$HPPEMIT '};'*)

  { This class describes region consisting from a collection of rectangles.
    The given class allows much faster to create region consisting from a
    collection of regions than standard API function CombineRgn. }
  TvgrFastRegion = class(TObject)
  private
    FRegionData: pRGNDATAHEADER;
    FRects: PRectArray;
    FCapacity: Integer;
  protected
    procedure Grow;
  public
{Creates a TvgrFastRegion instance.}
    constructor Create;
{Destroys an instance of TvgrFastRegion.}
    destructor Destroy; override;

    { Deletes all rects from the region. }
    procedure Clear;
    { Add rect to region.
Parameters:
  ARect - TRect object}
    procedure AddRect(const ARect: TRect);
    { Build API region.
Return value:
  The return value is the handle to the region.}
    function BuildRegion: HRGN;
  end;

  /////////////////////////////////////////////////
  //
  // TvgrWrapLine
  //
  /////////////////////////////////////////////////
{Represents the info about separate line in text.
This structure is used by WrapMemo function to return information
about strings in text.
Length member specifies the length of string without CRLF chars and trailing spaces,
CreatedFromCrLf has true value if string created on wrapping.
Syntax:
  TvgrWrapLine = packed record
    Start: Integer;
    Length: Integer;
    CreatedFromCrLf: Boolean;
  end;}
  TvgrWrapLine = packed record
    Start: Integer;
    Length: Integer;
    CreatedFromCrLf: Boolean;
  end;
  TvgrWrapLineDynArray = array of TvgrWrapLine;

  /////////////////////////////////////////////////
  //
  // Functions
  //
  /////////////////////////////////////////////////
  { The vgrCalcStringHeight function computes the height of the specified string of text.
    Text may contain many lines, lines must be separated by #13#10 chars.
Parameters:
  ACanvas - TCanvas object
  S - string
Return value:
  Integer}
  function vgrCalcStringHeight(ACanvas: TCanvas; const S: string): Integer;
  { The vgrCalcStringSize function computes the sizes (width and height) of the specified string of text.
    Text may contain many lines, lines must be separated by #13#10 chars.
    Also function returns count of lines in text.
Parameters:
  ACanvas - TCanvas object
  S - string
  ALineCount - Integer (output count of lines in text)
Return value:
  TSize}
  function vgrCalcStringSize(ACanvas: TCanvas; const S: string; var ALineCount: Integer): TSize; overload;
  { The vgrCalcStringSize function computes the sizes (width and height) of the specified string of text.
    Text may contain many lines, lines must be separated by #13#10 chars.
Parameters:
  ACanvas - TCanvas object
  S - string
Return value:
  TSize}    
  function vgrCalcStringSize(ACanvas: TCanvas; const S: string): TSize; overload;
  { The vgrDrawString procedure draws formatted text in the specified rectangle.
    It horizontally align the text according to the AHorzAlign parameter.
Parameters:
  ACanvas - TCanvas object
  S - string
  ARect - TRect object
  AVertOffset - Integer
  AHorzAlign - TvgrTextHorzAlign, indicates how to align text horizontally}
  procedure vgrDrawString(ACanvas: TCanvas;
                          const S: string;
                          const ARect: TRect;
                          AVertOffset: Integer;
                          AHorzAlign: TvgrTextHorzAlign);
  { The CreateFont function creates a logical font with the characteristics specified by Font object.
    The returned logical font not depend from Font object and can subsequently be selected as the font for any device.
Parameters:
  Font - TFont object
Return value:
  HFont, font object handle}
  function CreateAPIFont(Font: TFont) : HFont;
  { Returns height of specified font in logical units relative to display device context.
Parameters:
  Font - TFont object
Return value:
  integer}
  function GetFontHeight(Font: TFont): integer;
  { Returns width of string in logical units when used the specified Font on display device context. 
Parameters:
  s - string
  Font - TFont object
Return value:
  Integer, width of string in logical units}
  function GetStringWidth(const s: string; Font: TFont) : integer;

  { The SetCanvasTransparentMode function sets the background mix mode of the specified device context.
    The background mix mode is used with text, hatched brushes, and pen styles that are not solid lines.
Parameters:
  Canvas - TCanvas object
  ATransparent - Boolean. If ATransparent = False - Background is filled with the current background color
before the text, hatched brush, or pen is drawn otherwise Background remains untouched.
Return value:
  Boolean}
  function SetCanvasTransparentMode(Canvas: TCanvas; ATransparent: Boolean): Boolean;
  { The CombineRectAndRegion procedure combines region and rectangle and stores the result in a region (ARegion parameter).
    If ARegion parameter is zero, then function creates a new rectangular region
    according Rect parameter.
    The region and rect are combined according to the specified mode.
      <br>RGN_AND Creates the intersection of the ARegion and Rect
      <br>RGN_COPY Creates a copy of the region identified by Rect.
      <br>RGN_DIFF Combines the parts of ARegion that are not part of Rect.
      <br>RGN_OR Creates the union of ARegion and Rect.
      <br>RGN_XOR Creates the union of ARegion and Rect except for any overlapping areas.
Parameters:
  ARegion - HRGN, handle to a region
  Rect - TRect object
  ACombineMode - Integer, default value = RGN_OR}
  procedure CombineRectAndRegion(var ARegion: HRGN; const Rect: TRect; ACombineMode: Integer = RGN_OR);
  { The CombineRegionAndRegion procedure combines ADestRegion and AAddedRegion and stores the result in a region (ADestRegion parameter).
    If ADestRegion parameter is zero, AAddedRegion returned.
    Note!!! If ADestRegion not is zero then AAddedRegion destroyed after combine.
    The regions are combined according to the specified mode:
      <br>RGN_AND Creates the intersection of the ARegion and Rect
      <br>RGN_COPY Creates a copy of the region identified by Rect.
      <br>RGN_DIFF Combines the parts of ARegion that are not part of Rect.
      <br>RGN_OR Creates the union of ARegion and Rect.
      <br>RGN_XOR Creates the union of ARegion and Rect except for any overlapping areas. 
Parameters:
  ADestRegion - HRGN, handle to a region
  AAddedRegion - HRGN, handle to a region
  ACombineMode - Integer, default = RGN_OR}
  procedure CombineRegionAndRegion(var ADestRegion: HRGN; AAddedRegion: HRGN; ACombineMode: Integer = RGN_OR);
  { The CombineRegionAndRegionNoDelete procedure combines ADestRegion and AAddedRegion and stores the result in a region (ADestRegion parameter).
    If ADestRegion parameter is zero, AAddedRegion returned.
    The regions are combined according to the specified mode:
      <br>RGN_AND Creates the intersection of the ARegion and Rect
      <br>RGN_COPY Creates a copy of the region identified by Rect.
      <br>RGN_DIFF Combines the parts of ARegion that are not part of Rect.
      <br>RGN_OR Creates the union of ARegion and Rect.
      <br>RGN_XOR Creates the union of ARegion and Rect except for any overlapping areas. 
Parameters:
  ADestRegion - HRGN, handle to a region
  AAddedRegion - HRGN, handle to a region
  ACombineMode - Integer, default value = RGN_OR}
  procedure CombineRegionAndRegionNoDelete(var ADestRegion: HRGN; AAddedRegion: HRGN; ACombineMode: Integer = RGN_OR);
  { The ExcludeClipRect procedure creates a new clipping region that consists of the
    existing clipping region minus the specified rectangle.
    The lower and right edges of the specified rectangle are not excluded from the clipping region.
Parameters:
  Canvas - TCanvas object
  Rect - TRect object}
  procedure ExcludeClipRect(Canvas: TCanvas; const Rect: TRect);
  { The ExcludeClipRegion procedure creates a new clipping region that consists of the
    existing clipping region minus the specified region.
    The lower and right edges of the specified rectangle are not excluded from the clipping region.
    If canvas don`t has clipping region, new rectangular region created with coords (0, 0, 32000, 32000).
Parameters:
  Canvas - TCanvas object
  ARegion - HRGN, handle to a region}
  procedure ExcludeClipRegion(Canvas: TCanvas; ARegion: HRGN);
  { The GetClipRegion function retrieves a handle identifying the current application-defined
    clipping region for the specified canvas.
Parameters:
  Canvas - TCanvas object
Return value:
  HRGN, handle to a region}
  function GetClipRegion(Canvas: TCanvas): HRGN;
  { The SelectClipRgn function selects a region as the current clipping region for the specified canvas. 
Parameters:
  Canvas - TCanvas object
  AClipRegion - HRGN, handle to a region}
  procedure SetClipRegion(Canvas: TCanvas; AClipRegion: HRGN);
  { The SelectClipRgn function selects a specified rectangle as the current clipping rectangle for the specified canvas. 
Parameters:
  Canvas - TCanvas object
  AClipRect - TRect object}
  procedure SetClipRect(Canvas: TCanvas; const AClipRect: TRect);
  { The CombineClipRegionAndRect procedure combines the specified rectangle with the current clipping region using the specified mode.

      <br>RGN_AND The new clipping region combines the overlapping areas of the current
              clipping region and the ractangle identified by ARect.
      <br>RGN_COPY The new clipping region is a rectangular region appropriate ARect parameter.
      <br>RGN_DIFF The new clipping region combines the areas of the current
               clipping region with those areas excluded from the ractangle identified by ARect.
      <br>RGN_OR The new clipping region combines the current clipping region
             and the ractangle identified by ARect.
      <br>RGN_XOR The new clipping region combines the current clipping region and the ractangle identified by ARect
              but excludes any overlapping areas. 
Parameters:
  Canvas: TCanvas object
  ARect - TRect object
  ACombineMode - Integer,default value = RGN_OR}
  procedure CombineClipRegionAndRect(Canvas: TCanvas; const ARect: TRect; ACombineMode: Integer = RGN_OR);
  { The ExtSelectClipRgn function combines the specified region with the current clipping region using the specified mode.

      <br>RGN_AND The new clipping region combines the overlapping areas of the
              current clipping region and the region identified by AClipRegion.
      <br>RGN_COPY The new clipping region is a copy of the region identified by AClipRegion.
               This is identical to SelectClipRgn. If the region identified by AClipRegion is NULL,
               the new clipping region is the default clipping region
               (the default clipping region is a null region).
      <br>RGN_DIFF The new clipping region combines the areas of the current
               clipping region with those areas excluded from the region identified by AClipRegion.
      <br>RGN_OR The new clipping region combines the current clipping region and
             the region identified by AClipRegion.
      <br>RGN_XOR The new clipping region combines the current clipping region
              and the region identified by AClipRegion but excludes any overlapping areas.
Parameters:
  Canvas: TCanvas object
  AClipRegion - HRGN, handle to a region
  ACombineMode - Integer, default value = RGN_OR}
  procedure CombineClipRegionAndRegion(Canvas: TCanvas; AClipRegion: HRGN; ACombineMode: Integer = RGN_OR);
  { The FillRgn function fills a region by using the current brush.
Parameters:
  Canvas - TCanvas object
  ARegion - HRGN, handle to a region}
  procedure FillRegion(Canvas: TCanvas; ARegion: HRGN);
  { Function convert a color value in delphi format to a color value in Windows API format.
    (It call GetSysColor function if color is system color like clWindow, clBtnFace etc). 
Parameters:
  AColor - TColor
Return value:
  TColor}
  function GetRGBColor(AColor: TColor): TColor;
  { Function returns a highlighted color for specified color by mixing a specified color
    and clHighlighted color.
Parameters:
  AColor - TColor type
Return value:
  TColor, highlighted color}
  function GetHighlightColor(AColor: TColor): TColor;
  { Function are mixing two colors according ATransparentValue parameter.
Parameters:
  ATransparentValue - Byte
  AColor1 - TColor
  AColor2 - TColor
Return value:
  TColor<br>
  if ATransparentValue = 0 AColor2 returned,<br>
  if ATransparentValue = 100 AColor1 returned. }
  function MixingColors(ATransparentValue: Byte; AColor1, AColor2: TColor): TColor;

  { Splits each string in a memo into multiple lines as its length approaches a specified size.
    AMaxWidth is the maximum line width in pixels.
Parameters:
  ACanvas - TCanvas object
  AMemo - TStrings
  AMaxWidth - Integer, maximum line width in pixels}
//  procedure WrapMemo(ACanvas: TCanvas; AMemo: TStrings; AMaxWidth : Integer); overload;

{Wrap the passed string on lines with using CRLF characters only.
Parameters:
  S - string to wrap.
  ALines - array of TvgrWrapLine structures each structure describe the separate line.}
  procedure WrapMemo(const S: string;
                     var ALines: TvgrWrapLineDynArray;
                     ASkipEmptyLines: Boolean); overload;
  procedure WrapMemo(ACanvas: TCanvas;
                     const S: string;
                     AMaxWidth: Integer;
                     var ALines: TvgrWrapLineDynArray;
                     ASkipEmptyLines: Boolean); overload;
  procedure WrapMemo(ADC: HDC;
                     const S: string;
                     AMaxWidth: Integer;
                     var ALines: TvgrWrapLineDynArray;
                     ASkipEmptyLines: Boolean); overload;
  procedure WrapMemo(ADC: HDC;
                     const S: string;
                     AMaxWidth: Integer;
                     var ALines: TvgrWrapLineDynArray;
                     AWordWrap: Boolean;
                     ADeleteEmptyLines: Boolean;
                     ADeleteEmptyLinesAtEnd: Boolean); overload;
{Wrap the passed string on lines, the AMaxWidth parameters specifies the maximum length of line in chars.}
  procedure WrapMemoChars(const S: string;
                          AMaxWidth: Integer;
                          var ALines: TvgrWrapLineDynArray;
                          ASkipEmptyLines: Boolean); overload;
  procedure WrapMemoChars(const S: string;
                          AMaxWidth: Integer;
                          var ALines: TvgrWrapLineDynArray;
                          AWordWrap: Boolean;
                          ADeleteEmptyLines: Boolean;
                          ADeleteEmptyLinesAtEnd: Boolean); overload;

  function WrapMemo(ACanvas: TCanvas; const S: string; AMaxWidth: Integer): string; overload;

  { The LoadCursor procedure loads the specified cursor resource from the executable (.EXE)
    file associated with an application instance and add them to a TScreen.Cursors collection.
Parameters:
  ACursorName -  string that contains the name of the cursor resource to be loaded
  ACursorID - after call contains identificator of a cursor in TScreen.Cursors collection
  ALoadedCusrorID - if cursor resource with given name exists this value returned
  ADefaultCursor - if cursor resource with given name not exists this value returned}
  procedure LoadCursor(const ACursorName: string; var ACursorID: TCursor; ALoadedCusrorID, ADefaultCursor: TCursor);

  { Draws a one pixel borders around a specified rectangle and fill inner area by specified color.
Parameters:
  ACanvas - TCanvas object
  ABorderRect - TRect object
  AFlags parameter are specifies borders for drawing:
<br>BF_LEFT - left border
<br>BF_TOP - top border
<br>BF_RIGHT - right border
<br>BF_BOTTOM - bottom border
  AColor - color of borders
  AFillColor - color for fill inner area, default - clNone (no fill). }
  procedure DrawBorders(ACanvas: TCanvas; const ABorderRect: TRect; AFlags: Cardinal; AColor: TColor; AFillColor: TColor = clNone); overload;
  { Draws a one pixel borders around a specified rectangle and fill inner area by specified color.
Parameters:
  ACanvas - TCanvas object
  ABorderRect - TRect object
  ALeft - Boolean, draw(True) left border or not(False)
  ATop - Boolean, draw top border or not
  ARight - Boolean, draw right border or not
  ABottom - Boolean, draw bottom border or not
  AColor - color of borders
  AFillColor - color for fill inner area, default - clNone (no fill). }
  procedure DrawBorders(ACanvas: TCanvas; const ABorderRect: TRect; ALeft, ATop, ARight, ABottom: Boolean; AColor: TColor; AFillColor: TColor = clNone); overload;

  { Draw a border of specified type around control and returns rectangle which excludes a drawn border,
    also procedure calculate width and height of this rectangle.
Parameters:
  AControl - TControl
  ACanvas - TCanvas
  ABorderStyle - TBorderStyle
  AInternalRect - TRect
  AWidth - Integer, output by reference
  AHeight - Integer, output by reference}
  procedure DrawBorder(AControl: TControl; ACanvas: TCanvas; ABorderStyle: TBorderStyle; var AInternalRect: TRect; var AWidth, AHeight: Integer);

  { Draw frame around the specified rectangle by specified color.
Parameters:
  ACanvas - TCanvas, canvas on which draw frame around rectangle
  ARect - TRect, rectangle
  AColor - TColor, color for draw}
  procedure DrawFrame(ACanvas: TCanvas; const ARect: TRect; AColor: TColor);

  { Convert a value in degrees to a value in radians.
Parameters:
  Angle - Double, angle in degrees
Return value:
  Double, angle in radians.}
  function ToRadians(Angle: Double): Double;
  { Returns coordinates of center of specified rectangle. 
Parameters:
  ARect - TRect object
Return value:
  TPoint}
  function RectCenter(const ARect: TRect): TPoint;
  { Returns height of specified rectangle.
Parameters:
  ARect - TRect object
Return value:
  Integer, height of ARect rectangle}
  function RectHeight(const ARect: TRect): Integer;
  { Returns width of specified rectangle.
Parameters:
  ARect - TRect object
Return value:
  Integer, width of ARect rectangle}
  function RectWidth(const ARect: TRect): Integer;
  { Rotate a point by specified angle (in degrees). 
Parameters:
  APoint - TPoint
  AAngle - Double, angle in degrees
Return value:
  TPoint}
  function RotatePoint(const APoint: TPoint; AAngle: Double): TPoint;
  { Create a new logical font according a Font parameter rotated by angle specified
    by RotateAngle parameter (angle in degrees).
Parameters:
  Font - TFont object
  RotateAngle - Integer, angle in degrees
Return value:
  HFONT, handle to a font}
  function GetRotatedFontHandle(Font: TFont; RotateAngle: Integer): HFONT;
  function GetRotatedTextSize(Canvas: TCanvas; const Text: string; Font: TFont; RotateAngle: Integer): TSize;
  procedure GetRotatedTextRectSize(Canvas: TCanvas; const Text: string; Font: TFont; RotateAngle: Integer; var RectSize: TSize; var TextSize: TSize); overload;
  procedure GetRotatedTextRectSize(TextSize: TSize; RotateAngle: Integer; var RectSize: TSize); overload;

  { Change StateIndex property of TTreeNode object specified by ANode parameter.
    if StateIndex equals AChecked them AStateIndex = ANotChecked, otherwise
    StateIndex equals AChecked.
    This function also update StateIndex property of parent nodes and child nodes.
Parameters:
  ANode - TTreeNode object
  ANotChecked - Integer
  AChecked - Integer
  AGrayed - Integer}
  procedure ChangeStateOfTreeNode(ANode: TTreeNode; ANotChecked, AChecked, AGrayed: Integer);

{Draws the image on a canvas.
Parameters:
  ACanvas - The TCanvas object.
  AImage - Image to drawing.
  ARect - The bounds rectangle, within of which the image should be aligned.
  AScaleX, AScaleY - Specify the scaling of image.
  ADrawMode - Specifies the image alignment.}
  procedure DrawImage(ACanvas: TCanvas;
                      AImage: TGraphic;
                      const ARect: TRect;
                      AScaleX, AScaleY: Extended;
                      ADrawMode: TvgrImageDrawMode);

{Searches an optimum place for popup form.
Parameters:
  AButtonRect - Rectangle of button that causes the showing of popup form.
  AWidth - Width of popup form.
  AHeight - Height of popup form.
Return value:
  Point at which the form must be displayed.}
  function FindPopupPoint(const AButtonRect: TRect; AWidth, AHeight: Integer): TPoint;

implementation

uses
  Math, vgr_Consts;

const
  ACrLfChars: set of char = [#13, #10];

function FindPopupPoint(const AButtonRect: TRect; AWidth, AHeight: Integer): TPoint;
var
  R: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);
  if AButtonRect.Left + AWidth > r.Right then
    Result.X := r.Right - AWidth
  else
    Result.X := AButtonRect.Left;
  if AButtonRect.Bottom + AHeight > r.Bottom then
    Result.Y := AButtonRect.Top - AHeight
  else
    Result.Y := AButtonRect.Bottom;
end;
  
/////////////////////////////////////////////////
//
// TvgrFastRegion
//
/////////////////////////////////////////////////
constructor TvgrFastRegion.Create;
begin
  inherited Create;
  FRegionData := AllocMem(SizeOf(RGNDATAHEADER));
  FRegionData.dwSize := SizeOf(RGNDATAHEADER);
  FRegionData.iType := RDH_RECTANGLES;
end;

destructor TvgrFastRegion.Destroy;
begin
  FreeMem(FRegionData);
  inherited;
end;

procedure TvgrFastRegion.Clear;
begin
  ReallocMem(FRegionData, SizeOf(RGNDATAHEADER));
  FRects := PRectArray(PChar(FRegionData) + SizeOf(RGNDATAHEADER));
  with FRegionData^ do
  begin
    nCount := 0;
    rcBound.Left := 0;
    rcBound.Top := 0;
    rcBound.Right := 0;
    rcBound.Bottom := 0;
  end;
  FCapacity := 0;
end;

procedure TvgrFastRegion.Grow;
begin
  FCapacity := FCapacity + FRegionData.nCount div 5 + 1;
  ReallocMem(FRegionData, FCapacity * SizeOf(TRect) + SizeOf(RGNDATAHEADER));
  FRects := PRectArray(PChar(FRegionData) + SizeOf(RGNDATAHEADER));
end;

// Count div 5 + 1
procedure TvgrFastRegion.AddRect(const ARect: TRect);
begin
  if FRegionData.nCount = FCapacity then
    Grow;
  with FRects^[FRegionData.nCount] do
  begin
    Left := ARect.Left;
    Top := ARect.Top;
    Right := ARect.Right;
    Bottom := ARect.Bottom;
  end;
  with FRegionData^.rcBound do
  begin
    if ARect.Left < Left then
      Left := ARect.Left;
    if ARect.Top < Top then
      Top := ARect.Top;
    if ARect.Right > Right then
      Right := ARect.Right;
    if ARect.Bottom < Bottom then
      Bottom := ARect.Bottom;
  end;
  Inc(FRegionData.nCount);
end;

function TvgrFastRegion.BuildRegion: HRGN;
begin
  if FRegionData.nCount = 0 then
    Result := 0
  else
    Result := ExtCreateRegion(nil, FCapacity * SizeOf(TRect) + SizeOf(RGNDATAHEADER), PRgnData(FRegionData)^);
end;

/////////////////////////////////////////////////
//
// Functions
//
/////////////////////////////////////////////////
function vgrCalcStringHeight(ACanvas: TCanvas; const S: string): Integer;
var
  ALineCount: Integer;
  ATextMetrics: tagTEXTMETRIC;
  ALineInfo: TvgrTextLineInfo;
begin
  ALineCount := 0;
  BeginEnumLines(S, ALineInfo);
  while EnumLines(S, ALineInfo) do
    Inc(ALineCount);

  GetTextMetrics(ACanvas.Handle, ATextMetrics);
  Result := ATextMetrics.tmHeight * (ALineCount{ + 1});
end;

function vgrCalcStringSize(ACanvas: TCanvas; const S: string; var ALineCount: Integer): TSize;
var
  ATextMetrics: tagTEXTMETRIC;
  ALineInfo: TvgrTextLineInfo;
  ATextSize: TSize;
  ALine: string;
begin
  BeginEnumLines(S, ALineInfo);

  ALineCount := 0;
  Result.cx := 0;
  while EnumLines(S, ALineInfo) do
  begin
    ALine := Copy(S, ALineInfo.Start, ALineInfo.Length);
    GetTextExtentPoint32(ACanvas.Handle, PChar(S), ALineInfo.Length, ATextSize);
    if ATextSize.cx > Result.cx then
      Result.cx := ATextSize.cx;

    Inc(ALineCount);
  end;

  GetTextMetrics(ACanvas.Handle, ATextMetrics);
  Result.cy := ATextMetrics.tmHeight * (ALineCount{ + 1});
end;

function vgrCalcStringSize(ACanvas: TCanvas; const S: string): TSize;
var
  ALineCount: Integer;
begin
  Result := vgrCalcStringSize(ACanvas, S, ALineCount);
end;

procedure vgrDrawString(ACanvas: TCanvas;
                        const S: string;
                        const ARect: TRect;
                        AVertOffset: Integer;
                        AHorzAlign: TvgrTextHorzAlign);
var
  X, Y, AWidth: Integer;
  ALineInfo: TvgrTextLineInfo;
  ALine: string;
  ATextMetrics: tagTEXTMETRIC;
  ALineSize: TSize;
begin
  GetTextMetrics(ACanvas.Handle, ATextMetrics);
  BeginEnumLines(S, ALineInfo);
  Y := ARect.Top + AVertOffset;
  AWidth := ARect.Right - ARect.Left;
  while EnumLines(S, ALineInfo) do
  begin
    ALine := Copy(S, ALineInfo.Start, ALineInfo.Length);

    GetTextExtentPoint32(ACanvas.Handle, PChar(ALine), ALineInfo.Length, ALineSize);
    case AHorzAlign of
      vgrthaCenter: X := ARect.Left + (AWidth - ALineSize.cx) div 2;
      vgrthaRight: X := ARect.Right - ALineSize.cx;
      else X := ARect.Left;
    end;
    ExtTextOut(ACanvas.Handle, X, Y, ETO_CLIPPED, @ARect, PChar(ALine), ALineInfo.Length, nil);

    Y := Y + ATextMetrics.tmHeight;
  end;
end;

function CreateAPIFont(Font : TFont) : HFont;
var
  F: TLogFont;
begin
  GetObject(Font.Handle,SizeOf(TLogFont),@F);
  Result := CreateFontIndirect(F);
end;

function GetFontHeight(Font: TFont): Integer;
var
  ATextMetrics: tagTEXTMETRIC;
  DC: HDC;
  OldFont: HFONT;
begin
  DC := GetDC(0);
  OldFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, ATextMetrics);
  SelectObject(DC, OldFont);
  ReleaseDC(0, DC);
  Result := ATextMetrics.tmHeight;
end;

function GetStringWidth(const s : string; Font : TFont) : integer;
var
  sz: TSize;
  DC: HDC;
  OldFont,NewFont: HFONT;
begin
  DC := GetDC(0);
  NewFont := CreateAPIFont(Font);
  OldFont := SelectObject(DC,NewFont);
  GetTextExtentPoint(DC,PChar(s),Length(s),sz);
  Result := sz.cx;
  SelectObject(DC,OldFont);
  DeleteObject(NewFont);
  ReleaseDC(0,DC);
end;

function SetCanvasTransparentMode(Canvas: TCanvas; ATransparent: Boolean): Boolean;
const
  aBkMode: array [Boolean] of Integer = (OPAQUE	, TRANSPARENT);
begin
  Result := SetBkMode(Canvas.Handle, aBkMode[ATransparent]) = TRANSPARENT;
end;

procedure ExcludeClipRect(Canvas: TCanvas; const Rect: TRect);
begin
  Windows.ExcludeClipRect(Canvas.Handle, Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
end;

procedure CombineRegionAndRegionNoDelete(var ADestRegion: HRGN; AAddedRegion: HRGN; ACombineMode: Integer = RGN_OR);
begin
  if ADestRegion = 0 then
  begin
    ADestRegion := CreateRectRgn(0, 0, 0, 0);
    CombineRgn(ADestRegion, ADestRegion, AAddedRegion, RGN_COPY);
  end
  else
    CombineRgn(ADestRegion, ADestRegion, AAddedRegion, ACombineMode);
end;

procedure CombineRegionAndRegion(var ADestRegion: HRGN; AAddedRegion: HRGN; ACombineMode: Integer = RGN_OR);
begin
  if ADestRegion = 0 then
    ADestRegion := AAddedRegion
  else
  begin
    CombineRgn(ADestRegion, ADestRegion, AAddedRegion, ACombineMode);
    DeleteObject(AAddedRegion);
  end
end;

procedure CombineRectAndRegion(var ARegion: HRGN; const Rect: TRect; ACombineMode: Integer = RGN_OR);
var
  ATempRegion: HRGN;
begin
  if ARegion = 0 then
    ARegion := CreateRectRgnIndirect(Rect)
  else
  begin
    ATempRegion := CreateRectRgnIndirect(Rect);
    CombineRgn(ARegion, ARegion, ATempRegion, ACombineMode);
    DeleteObject(ATempRegion);
  end;
end;

procedure ExcludeClipRegion(Canvas: TCanvas; ARegion: HRGN);
var
  ATempRegion: HRGN;
begin
  ATempRegion := CreateRectRgn(0, 0, 0, 0);
  if GetClipRgn(Canvas.Handle, ATempRegion) = 0 then
  begin
    DeleteObject(ATempRegion);
    ATempRegion := CreateRectRgn(0, 0, 32000, 32000); // !!! other values cause bug on Win9X
    SelectClipRgn(Canvas.Handle, ATempRegion);
  end;
  ExtSelectClipRgn(Canvas.Handle, ARegion, RGN_DIFF);
  DeleteObject(ATempRegion);
end;

function GetClipRegion(Canvas: TCanvas): HRGN;
begin
  Result := CreateRectRgn(0, 0, 0, 0);
  if GetClipRgn(Canvas.Handle, Result) = 0 then
  begin
    DeleteObject(Result);
    Result := 0;
  end;
end;

procedure SetClipRegion(Canvas: TCanvas; AClipRegion: HRGN);
begin
  SelectClipRgn(Canvas.Handle, AClipRegion);
end;

procedure CombineClipRegionAndRect(Canvas: TCanvas; const ARect: TRect; ACombineMode: Integer = RGN_OR);
var
  ARegion: HRGN;
begin
  ARegion := GetClipRegion(Canvas);
  if ARegion = 0 then
    SetClipRect(Canvas, ARect)
  else
  begin
    CombineRectAndRegion(ARegion, ARect, ACombineMode);
    SelectClipRgn(Canvas.Handle, ARegion);
    DeleteObject(ARegion);
  end;
end;

procedure CombineClipRegionAndRegion(Canvas: TCanvas; AClipRegion: HRGN; ACombineMode: Integer = RGN_OR);
begin
  ExtSelectClipRgn(Canvas.Handle, AClipRegion, ACombineMode);
end;

procedure SetClipRect(Canvas: TCanvas; const AClipRect: TRect);
var
  ARegion: HRGN;
begin
  ARegion := CreateRectRgnIndirect(AClipRect);
  SelectClipRgn(Canvas.Handle, ARegion);
  DeleteObject(ARegion); 
end;

procedure FillRegion(Canvas: TCanvas; ARegion: HRGN);
begin
  FillRgn(Canvas.Handle, ARegion, Canvas.Brush.Handle);
end;

function GetRGBColor(AColor: TColor): TColor;
begin
  if (AColor and $FF0000000) <> 0 then
    Result := GetSysColor(AColor and not $FF000000)
  else
    Result := AColor;
end;

function MixingColors(ATransparentValue: Byte; AColor1, AColor2: TColor): TColor;
var
  r1, g1, b1: byte;
  r2, g2, b2: byte;
  r3, g3, b3: byte;
  v: single;
  ARGBColor1, ARGBColor2: TColor;
begin
  v := ATransparentValue / 100;
  ARGBColor1 := GetRGBColor(AColor1);
  ARGBColor2 := GetRGBColor(AColor2);

  r1 := lo(ARGBColor1);
  g1 := lo(ARGBColor1 shr 8);
  b1 := lo(ARGBColor1 shr 16);

  r2 := lo(ARGBColor2);
  g2 := lo(ARGBColor2 shr 8);
  b2 := lo(ARGBColor2 shr 16);

  r3 := round(r1 * v + r2 * (1 - v));
  g3 := round(g1 * v + g2 * (1 - v));
  b3 := round(b1 * v + b2 * (1 - v));

  result := RGB(r3, g3, b3);
end;

function GetHighlightColor(AColor: TColor): TColor;
begin
  Result := MixingColors(70, AColor, clHighlight);
end;

procedure LoadCursor(const ACursorName: string; var ACursorID: TCursor; ALoadedCusrorID, ADefaultCursor: TCursor);
var
  ACursor: HCURSOR;
begin
  ACursor := LoadImage(hInstance, PChar(ACursorName), IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE or LR_DEFAULTCOLOR);
  if ACursor = 0 then
    ACursorID := ADefaultCursor
  else
  begin
    Screen.Cursors[ALoadedCusrorID] := ACursor;
    ACursorID := ALoadedCusrorID;
  end;
end;

procedure WrapMemoChars(const S: string;
                        AMaxWidth: Integer;
                        var ALines: TvgrWrapLineDynArray;
                        ASkipEmptyLines: Boolean);
var
  I, J, N, M, ALen: Integer;
  ACrLf: Boolean;

begin
  ALen := Length(S);
  SetLength(ALines, 0);

  //
  I := 1;
  while I <= ALen do
  begin
    J := I;
    while (I <= ALen) and
          (not (S[I] in ACrLfChars)) and
          (I - J < AMaxWidth) do
      Inc(I);

    ACrLf := (I <= ALen) and (S[I] in ACrLfChars);
    if (I <= ALen) and not (S[I] in ACrLfChars) then
    begin
      if I = J then
      begin
        // width of symbol large then AMaxWidth
        Inc(I);
      end
      else
      begin
        if S[I] = ' ' then
          while (I <= ALen) and (S[I] = ' ') do Inc(I)
        else
        begin
          N := I;
          while (I > J) and not (S[I] in WordWrapChars) do
            Dec(I);
          if I <= J then
            I := N
          else
          begin
            Inc(I);
            while (I <= ALen) and (S[I] = ' ') do Inc(I);
          end;
        end;
      end;
    end;
    N := I;
    FindEndOfLineBreak(S, ALen, I);
    M := N;
    while (M > J) and (S[M - 1] = ' ') do Dec(M);

    if not ASkipEmptyLines or (M - J > 0) then
    begin
      SetLength(ALines, Length(ALines) + 1);
      with ALines[High(ALines)] do
      begin
        Start := J;
        Length := M - J;
        CreatedFromCrLf := ACrLf;
      end;
    end;
  end;
end;

procedure WrapMemoChars(const S: string;
                        AMaxWidth: Integer;
                        var ALines: TvgrWrapLineDynArray;
                        AWordWrap: Boolean;
                        ADeleteEmptyLines: Boolean;
                        ADeleteEmptyLinesAtEnd: Boolean);
var
  I: Integer;
begin
  if AWordWrap and (AMaxWidth > 0) then
    WrapMemoChars(S, AMaxWidth, ALines, ADeleteEmptyLines)
  else
    WrapMemo(S, ALines, ADeleteEmptyLines);

  if not ADeleteEmptyLines and ADeleteEmptyLinesAtEnd then
  begin
    I := High(ALines);
    while (I > 0) and (ALines[I].Length = 0) do Dec(I);
    SetLength(ALines, I + 1);
  end;
end;

procedure WrapMemo(ADC: HDC;
                   const S: string;
                   AMaxWidth: Integer;
                   var ALines: TvgrWrapLineDynArray;
                   AWordWrap: Boolean;
                   ADeleteEmptyLines: Boolean;
                   ADeleteEmptyLinesAtEnd: Boolean);
var
  I: Integer;
begin
  if AWordWrap then
    WrapMemo(ADC, S, AMaxWidth, ALines, ADeleteEmptyLines)
  else
    WrapMemo(S, ALines, ADeleteEmptyLines);

  if not ADeleteEmptyLines and ADeleteEmptyLinesAtEnd then
  begin
    I := High(ALines);
    while (I > 0) and (ALines[I].Length = 0) do Dec(I);
    SetLength(ALines, I + 1);
  end;
end;

procedure WrapMemo(ACanvas: TCanvas; const S: string; AMaxWidth: Integer; var ALines: TvgrWrapLineDynArray; ASkipEmptyLines: Boolean);
begin
  WrapMemo(ACanvas.Handle, S, AMaxWidth, ALines, ASkipEmptyLines);
end;

procedure WrapMemo(const S: string; var ALines: TvgrWrapLineDynArray; ASkipEmptyLines: Boolean);
var
  I, J, N, M, ALen: Integer;
  ACrLf: Boolean;
begin
  SetLength(ALines, 0);

  ALen := Length(S);
  I := 1;
  while I <= ALen do
  begin
    J := I;
    while (I <= ALen) and (not (S[I] in ACrLfChars)) do
      Inc(I);

    ACrLf := (I < ALen) and (S[I] in ACrLfChars);

    N := I;
    FindEndOfLineBreak(S, ALen, I);
    M := N;
    while (M > J) and (S[M - 1] = ' ') do Dec(M);

    if not ASkipEmptyLines or (M - J > 0) then
    begin
      SetLength(ALines, Length(ALines) + 1);
      with ALines[High(ALines)] do
      begin
        Start := J;
        Length := M - J;
        CreatedFromCrLf := ACrLf;
      end;
    end;
  end;
end;

procedure WrapMemo(ADC: HDC; const S: string; AMaxWidth: Integer; var ALines: TvgrWrapLineDynArray; ASkipEmptyLines: Boolean);
const
  ABlockSize = 8192;
var
  ABuf: PIntArray;
  ASize: TSize;
  AFit, I, J, N, M, ALen, AWidth: Integer;
  ACrLf: Boolean;

  function IsWordWrapChar(C: char): Boolean;
  begin
    Result := C = ' ';
  end;
  
begin
  SetLength(ALines, 0);
  
  ALen := Length(S);
  GetMem(ABuf, ALen * 4);
  try
    I := 1;
    while I < ALen do
    begin
      GetTextExtentExPoint(ADC,
                           @S[I],
                           Min(ABlockSize, ALen - I + 1),
                           MaxInt,
                           @AFit,
                           PInteger(PChar(ABuf) + (I - 1) * 4),
                           ASize);

      for J := Min(ALen - 1, I + ABlockSize - 2) downto I do
        ABuf^[J] := ABuf^[J] - ABuf^[J - 1];

      I := I + ABlockSize;
    end;

    //
    I := 1;
    while I <= ALen do
    begin
      J := I;
      AWidth := 0;
      while (I <= ALen) and
            (not (S[I] in ACrLfChars)) and
            (AWidth + ABuf^[I - 1] < AMaxWidth) do
      begin
        AWidth := AWidth + ABuf^[I - 1];
        Inc(I);
      end;

      ACrLf := (I <= ALen) and (S[I] in ACrLfChars);
      if (I <= ALen) and not (S[I] in ACrLfChars) then
      begin
        if I = J then
        begin
          // width of symbol large then AMaxWidth
          Inc(I);
        end
        else
        begin
          if S[I] = ' ' then
            while (I <= ALen) and (S[I] = ' ') do Inc(I)
          else
          begin
            N := I;
            while (I > J) and not IsWordWrapChar(S[I]) do
              Dec(I);
            if I <= J then
              I := N
            else
            begin
              Inc(I);
              while (I <= ALen) and (S[I] = ' ') do Inc(I);
            end;
          end;
        end;
      end;
      N := I;
      FindEndOfLineBreak(S, ALen, I);
      M := N;
      while (M > J) and (S[M - 1] = ' ') do Dec(M);

      if not ASkipEmptyLines or (M - J > 0) then
      begin
        SetLength(ALines, Length(ALines) + 1);
        with ALines[High(ALines)] do
        begin
          Start := J;
          Length := M - J;
          CreatedFromCrLf := ACrLf;
        end;
      end;
    end;

  finally
    FreeMem(ABuf);
  end;
end;

function WrapMemo(ACanvas: TCanvas; const S: string; AMaxWidth: Integer): string;
const
  ABlockSize = 8192;
var
  ABuf: PIntArray;
  ASize: TSize;
  AFit, I, J, K, N, M, ALen, AWidth: Integer;

  function IsWordWrapChar(C: char): Boolean;
  begin
    Result := C = ' ';
  end;
  
begin
  ALen := Length(S);
  GetMem(ABuf, ALen * 4);
  try
    I := 1;
    while I < ALen do
    begin
      GetTextExtentExPoint(ACanvas.Handle,
                           @S[I],
                           Min(ABlockSize, ALen - I + 1),
                           MaxInt,
                           @AFit,
                           PInteger(PChar(ABuf) + (I - 1) * 4),
                           ASize);

      for J := Min(ALen - 1, I + ABlockSize - 2) downto I do
      begin
        if S[J + 1] in ACrLfChars then
          ABuf^[J] := 0
        else
          ABuf^[J] := ABuf^[J] - ABuf^[J - 1];
      end;

      I := I + ABlockSize;
    end;

    //
    SetLength(Result, ALen * 4);
    I := 1;
    K := 1;
    while I <= ALen do
    begin
      J := I;
      AWidth := 0;
      while (I <= ALen) and (AWidth + ABuf^[I - 1] < AMaxWidth) do
      begin
        Result[K] := S[I];
        if (S[I] = #13) or (S[I] = #10) then
          AWidth := 0
        else
          AWidth := AWidth + ABuf^[I - 1];
        Inc(I);
        Inc(K);
      end;

      if I <= ALen then
      begin
        if I = J then
        begin
          // width of symbol large then AMaxWidth
          Result[K] := S[I];
          Inc(K);
          Inc(I);
        end
        else
        begin
          if S[I] = ' ' then
            while (I <= ALen) and (S[I] = ' ') do Inc(I)
          else
          begin
            N := I;
            M := K;
            while (I > J) and not IsWordWrapChar(S[I]) do
            begin
              Dec(I);
              Dec(K);
            end;
            if I <= J then
            begin
              I := N;
              K := M;
            end
            else
            begin
              Inc(I);
              Inc(K);
            end;
          end;
        end;

        Result[K] := #13;
        Inc(K);
        Result[K] := #10;
        Inc(K);
      end;
    end;
    SetLength(Result, K - 1);

  finally
    FreeMem(ABuf);
  end;
end;
{
procedure WrapMemo(ACanvas: TCanvas; AMemo: TStrings; AMaxWidth : Integer);
var
  l: TStringList;
  s: string;
  sz: TSize;
  i, ls, p1, p2, p3 : integer;
begin
l := TStringList.Create;
try
  for i:=0 to AMemo.Count-1 do
  begin
    s := AMemo[i];
    ls := Length(s);
    p1 := 1;
    p2 := 1;
    while p2<=ls do
    begin
      GetTextExtentExPoint(ACanvas.Handle, PChar(@s[p2]), ls - p2 + 1, AMaxWidth, @p1, nil, sz);
      if p2+p1<=ls then
      begin
        //
        if s[p1+p2]=' ' then
        begin
          while (p1+p2<=ls) and (s[p1+p2]=' ') do Inc(p1);
        end
        else
        begin
          p3 := p1+p2-1;
          while (p3>=p2) and not(s[p3] in [' ','.',',','-',';']) do Dec(p3);
          if p3>=p2 then
            p1 := p3-p2+1;
        end;
      end;
      if p1=0 then
        p1 :=1;
      // add string part from p2 to p1
      l.Add(Trim(Copy(s, p2, p1)));
      p2 := p2+p1;
    end;
  end;
  AMemo.Assign(l);
finally
  l.Free;
end;
end;
}
procedure DrawBorders(ACanvas: TCanvas; const ABorderRect: TRect; AFlags: Cardinal; AColor: TColor; AFillColor: TColor = clNone);
begin
  DrawBorders(ACanvas, ABorderRect,
              (BF_LEFT and AFlags) <>0,
              (BF_TOP and AFlags) <>0,
              (BF_RIGHT and AFlags) <>0,
              (BF_BOTTOM and AFlags) <>0,
              AColor,
              AFillColor);
end;

procedure DrawBorders(ACanvas: TCanvas; const ABorderRect: TRect; ALeft, ATop, ARight, ABottom: Boolean; AColor: TColor; AFillColor: TColor = clNone);
var
  ARect: TRect;
begin
  ARect := ABorderRect;
  ACanvas.Brush.Color := AColor;
  if ALeft then
  begin
    ACanvas.FillRect(Rect(ARect.Left, ARect.Top, ARect.Left + 1, ARect.Bottom));
    ARect.Left := ARect.Left + 1;
  end;
  if ATop then
  begin
    ACanvas.FillRect(Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Top + 1));
    ARect.Top := ARect.Top + 1;
  end;
  if ARight then
  begin
    ACanvas.FillRect(Rect(ARect.Right - 1, ARect.Top, ARect.Right, ARect.Bottom));
    ARect.Right := ARect.Right - 1;
  end;
  if ABottom then
  begin
    ACanvas.FillRect(Rect(ARect.Left, ARect.Bottom - 1, ARect.Right, ARect.Bottom));
    ARect.Bottom := ARect.Bottom - 1;
  end;
  if AFillColor <> clNone then
  begin
    ACanvas.Brush.Color := AFillColor;
    ACanvas.FillRect(ARect);
  end;
end;

function RectCenter(const ARect: TRect): TPoint;
begin
  with ARect do
  begin
    Result.X := Left + (Right - Left) div 2;
    Result.Y := Top + (Bottom - Top) div 2;
  end;
end;

function RectHeight(const ARect: TRect): Integer;
begin
  Result := ARect.Bottom - ARect.Top;
end;

function RectWidth(const ARect: TRect): Integer;
begin
  Result := ARect.Right - ARect.Left;
end;

function ToRadians(Angle: Double): Double;
begin
  Result := Pi / 180 * Angle;
end;

function GetRotatedFontHandle(Font: TFont; RotateAngle: Integer): HFONT;
var
  LF: TLogFont;
begin
  GetObject(Font.Handle, SizeOf(TLogFont), @LF);
  LF.lfEscapement  := RotateAngle * 10;
  LF.lfOrientation := RotateAngle * 10;
  Result := CreateFontIndirect(LF);
end;

function GetRotatedTextSize(Canvas: TCanvas; const Text: string; Font: TFont; RotateAngle: Integer): TSize;
var
  OldFont,NewFont: HFONT;
  ARect: TRect;
begin
  NewFont := GetRotatedFontHandle(Font,RotateAngle);
  OldFont := SelectObject(Canvas.Handle,NewFont);
  ARect := Rect(0,0, MaxInt, MaxInt);
  DrawText(Canvas.Handle, PChar(Text), Length(Text), ARect, DT_CALCRECT or DT_LEFT or DT_NOPREFIX);
  Result.cx := ARect.Right - ARect.Left;
  Result.cy := ARect.Bottom - ARect.Top;
  SelectObject(Canvas.Handle,OldFont);
  DeleteObject(NewFont);
end;

procedure GetRotatedTextRectSize(TextSize: TSize; RotateAngle: Integer; var RectSize: TSize);
var
  SinAngle,CosAngle,RadianAngle: Double;
begin
  RadianAngle := ToRadians(RotateAngle);
  SinAngle := sin(RadianAngle);
  CosAngle := cos(RadianAngle);
  RectSize.cx := Abs(Round(TextSize.cx * CosAngle)) + Abs(Round(TextSize.cy * SinAngle));
  RectSize.cy := Abs(Round(TextSize.cx * SinAngle)) + Abs(Round(TextSize.cy * CosAngle));
end;

procedure GetRotatedTextRectSize(Canvas: TCanvas; const Text: string; Font: TFont; RotateAngle: Integer; var RectSize: TSize; var TextSize: TSize);
begin
  TextSize := GetRotatedTextSize(Canvas, Text, Font, RotateAngle);
  GetRotatedTextRectSize(TextSize, RotateAngle, RectSize);
end;

function RotatePoint(const APoint: TPoint; AAngle: Double): TPoint;
var
  SinAngle,CosAngle,RadianAngle: Double;
begin
  RadianAngle := ToRadians(AAngle);
  SinAngle := sin(RadianAngle);
  CosAngle := cos(RadianAngle);
  Result.X := Round(APoint.X * CosAngle - APoint.Y * SinAngle);
  Result.Y := Round(APoint.X * SinAngle + APoint.Y * CosAngle);
end;

procedure ChangeStateOfTreeNode(ANode: TTreeNode; ANotChecked, AChecked, AGrayed: Integer);
var
  AParent: TTreeNode;

  procedure SetAllChildrenStateIndex(ANode: TTreeNode; AStateIndex: Integer);
  var
    AChild: TTreeNode;
  begin
    ANode.StateIndex := AStateIndex;
    AChild := ANode.getFirstChild;
    while AChild <> nil do
    begin
      SetAllChildrenStateIndex(AChild, AStateIndex);
      AChild := ANode.GetNextChild(AChild);
    end;
  end;

  procedure CheckParent(ANode: TTreeNode);
  var
    AChild: TTreeNode;
    AStateIndex: Integer;
  begin
    AChild := ANode.getFirstChild;
    if AChild <> nil then
    begin
      AStateIndex := AChild.StateIndex;
      if AStateIndex <> AGrayed then
      begin
        while (AChild <> nil) and (AStateIndex = AChild.StateIndex) do
          AChild := ANode.GetNextChild(AChild);
        if AChild <> nil then
          AStateIndex := AGrayed;
      end;
      ANode.StateIndex := AStateIndex;
    end;
  end;

begin
  if ANode.StateIndex = AChecked then
    ANode.StateIndex := ANotChecked
  else
    ANode.StateIndex := AChecked;

  SetAllChildrenStateIndex(ANode, ANode.StateIndex);
  AParent := ANode.Parent;
  while AParent <> nil do
  begin
    CheckParent(AParent);
    AParent := AParent.Parent;
  end;
end;

procedure DrawBorder(AControl: TControl; ACanvas: TCanvas; ABorderStyle: TBorderStyle; var AInternalRect: TRect; var AWidth, AHeight: Integer);
begin
  AInternalRect := Rect(0, 0, AControl.ClientWidth, AControl.ClientHeight);
  case ABorderStyle of
    bsSingle: DrawEdge(ACanvas.Handle, AInternalRect, EDGE_SUNKEN, BF_ADJUST or BF_RECT);
  end;
  AWidth := AInternalRect.Right - AInternalRect.Left;
  AHeight := AInternalRect.Bottom - AInternalRect.Top;
end;

procedure DrawFrame(ACanvas: TCanvas; const ARect: TRect; AColor: TColor);
begin
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Brush.Color := AColor;
  with ARect do
  begin
    ACanvas.FillRect(Rect(Left, Top, Right, Top + 1));
    ACanvas.FillRect(Rect(Right - 1, Top, Right, Bottom));
    ACanvas.FillRect(Rect(Left, Bottom - 1, Right, Bottom));
    ACanvas.FillRect(Rect(Left, Top, Left + 1, Bottom));
  end;
end;

procedure DrawImage(ACanvas: TCanvas;
                    AImage: TGraphic;
                    const ARect: TRect;
                    AScaleX, AScaleY: Extended;
                    ADrawMode: TvgrImageDrawMode);
var
  AOldClipRgn, AClipRgn: HRGN;
  AOrgEx: TPoint;
  AImageWidth, AImageHeight: Integer;
  R: TRect;
  kmul, kdiv: Integer;
begin
  AImageWidth := Round(AImage.Width * AScaleX);
  AImageHeight := Round(AImage.Height * AScaleY);
  if (AImageWidth = 0) or (AImageHeight = 0) then exit;

  case ADrawMode of
    vgridmCenter:
      begin
        // center
        AOldClipRgn := GetClipRegion(ACanvas);
        GetViewportOrgEx(ACanvas.Handle, AOrgEx);
        AClipRgn := CreateRectRgn(ARect.Left + AOrgEx.X,
                                  ARect.Top + AOrgEx.Y,
                                  ARect.Right + AOrgEx.X,
                                  ARect.Bottom + AOrgEx.Y);
        SetClipRegion(ACanvas, AClipRgn);

        with ARect do
        begin
          R.Left := Left + (Right - Left - AImageWidth) div 2;
          R.Top := Top + (Bottom - Top - AImageHeight) div 2;
          R.Right := r.Left + AImageWidth;
          R.Bottom := r.Top + AImageHeight;
        end;

        ACanvas.StretchDraw(R, AImage);

        SetClipRegion(ACanvas, AOldClipRgn);
        DeleteObject(AClipRgn);
        if AOldClipRgn <> 0 then
          DeleteObject(AOldClipRgn)
      end;
    vgridmStretch:
      begin
        // stretch in rect
        ACanvas.StretchDraw(ARect, AImage);
      end;
    vgridmStretchProp:
      begin
        if (ARect.Right - ARect.Left) / AImageWidth < (ARect.Bottom - ARect.Top) / AImageHeight then
        begin
          kmul := ARect.Right - ARect.Left;
          kdiv := AImageWidth;
        end
        else
        begin
          kmul := ARect.Bottom - ARect.Top;
          kdiv := AImageHeight;
        end;
        
        AImageWidth := muldiv(AImageWidth, kmul, kdiv);
        AImageHeight := muldiv(AImageHeight, kmul, kdiv);
        with ARect do
        begin
          R.Left := Left + (Right - Left - AImageWidth) div 2;
          R.Top := Top + (Bottom - Top - AImageHeight) div 2;
          R.Right := r.Left + AImageWidth;
          R.Bottom := r.Top + AImageHeight;
        end;

        ACanvas.StretchDraw(R, AImage);
      end;
  end;
end;

end.

