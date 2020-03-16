
{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2003 by vtkTools      }
{                                          }
{******************************************}

{Common functions, types, constants and variables definitions unit.
      
See also:
vgr_GUIFunctions}

unit vgr_Functions;

interface

{$I vtk.inc}

uses
  Windows, Classes, SysUtils, TypInfo, {$IFDEF VTK_D6_OR_D7} Variants, {$ENDIF}
  Clipbrd, Math, Graphics;

{$IFNDEF VTK_D7}
const
{number of hours in one day}
  HoursPerDay = 24;
{number of minutes in one hour}
  MinsPerHour = 60;
{number of seconds in one minute}
  SecsPerMin = 60;
{number of milliseconds in one second}
  MSecsPerSec = 1000;
{number of minutes in one day}
  MinsPerDay = HoursPerDay * MinsPerHour;
{number of seconds in one day}
  SecsPerDay = MinsPerDay * SecsPerMin;
{number of milliseconds in one day}  
  MSecsPerDay = SecsPerDay * MSecsPerSec;
{$ENDIF}

type
{$IFNDEF VTK_D6_OR_D7}
  IInterface = interface(IUnknown)
  end;
{$ENDIF}
{Array of TRect
Syntax:
  TRectArray = array [0..0] of TRect;}
  TRectArray = array [0..MaxInt div sizeof(TRect) div 2] of TRect;
{Pointer to a TRectArray array
Syntax:
  PRectArray = ^TRectArray;}
  PRectArray = ^TRectArray;
{Array of integer
Syntax:
  TIntArray = array [0..0] of Integer;}
  TIntArray = array [0..MaxInt div sizeof(Integer) div 2] of Integer;
{Pointer to a TIntArray array
Syntax:
  PIntArray = ^TIntArray;}
  PIntArray = ^TIntArray;
{Array of integer
Syntax:
  TDynIntegerArray = array of Integer;}
  TDynIntegerArray = array of Integer;
{Array of string
Syntax:
  TvgrStringArray = array of string;}
  TvgrStringArray = array of string;
{Represent position of border side
Syntax:
  TvgrBorderSide = (vgrbsLeft, vgrbsTop, vgrbsRight, vgrbsBottom);
Items:
  vgrbsLeft - Left
  vgrbsTop - Top
  vgrbsRight - Right
  vgrbsBottom - Bottom
}
  TvgrBorderSide = (vgrbsLeft, vgrbsTop, vgrbsRight, vgrbsBottom);
{ Represent units that measure size.
Syntax:
  TvgrUnits = (vgruMms, vgruCentimeters, vgruInches, vgruTenthsMMs, vgruPixels);
Items:
  vgruMms - millimeters
  vgruCentimeters - centimeters
  vgruInches - Inches
  vgruTenthsMMs - 1/10 of millimeter
  vgruPixels - device pixels }
  TvgrUnits = (vgruMms, vgruCentimeters, vgruInches, vgruTenthsMMs, vgruPixels);
{Record containing information on lines with text
Syntax:
  TvgrTextLineInfo = record
    Start: Integer;
    Length: Integer;
    FullLength: Integer;
    TextLength: Integer;
  end;
}
  TvgrTextLineInfo = record
    Start: Integer;
    Length: Integer;
    FullLength: Integer;
    TextLength: Integer;
    CrLf: Boolean;
  end;

  /////////////////////////////////////////////////
  //
  // Functions
  //
  /////////////////////////////////////////////////
{$IFNDEF VTK_D6_OR_D7}
  function IsZero(const A: Extended; Epsilon: Extended = 0): Boolean; overload;
  function IsZero(const A: Double; Epsilon: Double = 0): Boolean; overload;
  function IsZero(const A: Single; Epsilon: Single = 0): Boolean; overload;
  { DirectoryExists returns a boolean value that indicates whether the
    specified directory exists (and is actually a directory) 
Parameters:
  Directory - string with path to directory.
Return value:
  Boolean, true - if directory exists, false - if directory not exists}
  function DirectoryExists(const Directory: string): Boolean;

  { Interface support routines }
  function Supports(const Instance: IInterface; const IID: TGUID; out Intf): Boolean; overload;
  function SupportsObject(const Instance: TObject; const IID: TGUID; out Intf): Boolean; overload;
  function Supports(const Instance: IInterface; const IID: TGUID): Boolean; overload;
  function Supports(const Instance: TObject; const IID: TGUID): Boolean; overload;
  function Supports(const AClass: TClass; const IID: TGUID): Boolean; overload;

{$ENDIF}
{$IFNDEF VTK_D7}
  function TryEncodeDate(Year, Month, Day: Word; out Date: TDateTime): Boolean;
  function TryEncodeTime(Hour, Min, Sec, MSec: Word; out Time: TDateTime): Boolean;
  function TryStrToTime(const S: string; out Value: TDateTime): Boolean;
  function TryStrToDateTime(const S: string; out Value: TDateTime): Boolean;
  function StrToDateTimeDef(const S: string; ADefDateTime: TDateTime): TDateTime;
{$ENDIF}

  { Returns caption of worksheet column by it number.
For example ColNumber = 27, Result = 'AB'
Parameters:
  ColNumber - integer, number of column (from zero).
Return value:
  String with caption of worksheet column.}
  function GetWorksheetColCaption(ColNumber: integer): string;
  { Returns caption of worksheet row by it number.
For example RowNumber = 27, Result = '28'
Parameters:
  RowNumber - number of row (from zero)
Return value:
  String with caption of worksheet row.}
  function GetWorksheetRowCaption(RowNumber: integer): string;

  { Creates a TSize structure from a sizes.
Parameters:
  cx is the width
  cy is the height
Return value:
  Returns TSize structure which represents a width and height.
  }
  function Size(cx, cy: Integer): TSize;
  { This function determines whether ASmallRect placed within ALargeRect.  
Parameters:
  ASmallRect - TRect object
  ALargeRect - TRect object
Return value:
  Boolean, True - if ASmallRect placed within ALargeRect, False - if ASmallRect not placed within ALargeRect.
  }
  function RectInRect(const ASmallRect, ALargeRect: TRect): Boolean;
  { This function determines whether ASmallRect placed within ALargeRect.
Parameters:
  ASmallRect - TRect object
  ALargeRect - TRect object
Return value:
  Boolean, True - if ASmallRect placed within ALargeRect, False - if ASmallRect not placed within ALargeRect.
}
  function RectInSelRect(const ASmallRect, ALargeRect: TRect): Boolean;
  { Returns true if APoint placed within ARect, also this function returns
    true if APoint placed on bounds of ARect.
Parameters:
  APoint - TPoint object
  ARect - TRect object
Return value:
  Boolean.}
  function PointInSelRect(const APoint: TPoint; ARect: TRect): Boolean;
  { The RectOverRect function determines whether any part of the
    specified rectangle (r1) is within the boundaries of a over rectangle (r2). 
Parameters:
  r1 - TRect object
  r2 - TRect object
Return value:
  Boolean. True - if any part of the
    specified rectangle (r1) is within the boundaries of a over rectangle (r2). False - if not.}
  function RectOverRect(const r1: TRect; const r2: TRect): boolean;
  { This function normalizes a TRect structure so both the height and width are positive.
    The method does a comparison of the top and bottom values,
    swapping them if the bottom is greater than the top.
    The same action is performed on the left and right values.
Parameters:
  r - TRect object.
Return value:
  Normalized TRect object.
  }
  function NormalizeRect(const r: TRect): TRect; overload;
  { This function creates a normalizated TRect structure so both the height and width
    are positive.
    The method does a comparison of the y1 (top) and y2 (bottom) values,
    swapping them if the bottom is greater than the top.
    The same action is performed on the (x1)left and (x2)right values. 
Parameters:
  x1 - left value.
  y1 - top value.
  x2 - right value.
  y2 - bottom value.
Return value:
  Normalized TRect object.}
  function NormalizeRect(x1,y1,x2,y2: Integer): TRect; overload;

  { Returns horizontal center of the rect.
    Result := ARect.Left + (ARect.Right - ARect.Left) div 2
Parameters:
  ARect - TRect object
Return value:
  Value of horizontal center of the rect}
  function HorzCenterOfRect(const ARect: TRect): Integer;

  { Converts a string of hexadecimal digits to the corresponding binary value.
Parameters:
  S - string of hexadecimal digits
  AResult - integer in which is written resulting binary value.
Return value:
  Boolean, return True if convert OK, otherwise return False.}
  function HexToInt(const S: string; var AResult: Integer): Boolean; 
  { Converts a string of hexadecimal digits to the corresponding binary value.
Parameters:
  S - string of hexadecimal digits
  ADefault - if S contains invalid string, ADefault returns.
Return value:
  Integer with binary value.
  }
  function HexToIntDef(const S: string; ADefault: Integer = 0): Integer;

  { Returns names of enum items to TStrings object. }
  procedure GetEnumNamesToStrings(ATypeInfo: PTypeInfo; AStrings: TStrings; ADeleteFirstCharCount: Integer = 0);
  { Call GetUniqueComponentName to get the unique name of the component within its owner. 
Parameters:
  AComponent - TComponent instance
Return value:
  String with unique name of the component within its owner}
  function GetUniqueComponentName(AComponent: TComponent): string;
  { Returns True if ANewName is a valid name for component AComponent.
    ANewName not equals empty string and AComponent.Owner = nil or owner of AComponent
    not contains child component with name ANewName. 
Parameters:
  AComponent - TComponent, component instance
  ANewName - String, name for component AComponent
Return value:
  Boolean value
    }
  function CheckComponentName(AComponent: TComponent; const ANewName: string): Boolean;

  { Format AValue based on its type. If AValue is a numeric value then FormatFloat function used.
    If AValue is a TDateTime value then FormatDateTime function used.
    If AValue is a string value returns AValue converted to string (VarToStr function used). 
Parameters:
  AFormat - string with specified format.
  AValue - variant value to format.
Return value:
  Formated string.
  }
  function FormatVariant(const AFormat: string; const AValue: Variant): string;

  function PosToRowAndCol(AStrings: TStrings; APos: Integer; var ARow, ACol: Integer; AStringDelimiters: TSysCharSet): Boolean; overload;
  function PosToRowAndCol(AStrings: TStrings; APos: Integer; var ARow, ACol: Integer): Boolean; overload;
  procedure BeginEnumLines(const S: string; var ALineInfo: TvgrTextLineInfo);
  function EnumLines(const S: string; var ALineInfo: TvgrTextLineInfo): Boolean;
  procedure FindEndOfLineBreak(const S: string; ALen: Integer; var I: Integer);

  { Call IndexOf to obtain the position of the first occurrence of the string S.
    This function is not case sensitive. 
    IndexOf returns the 0-based index of the string.
Parameters:
  S - string for search
  AList - list of strings
Return value:
  Integer. If S matches the first string in the list, IndexOf returns 0, 
  if S is the second string, IndexOf returns 1, and so on.
  If the string is not in the string list, IndexOf returns -1. }
  function IndexInStrings(const S: string; AList: TStrings): Integer;
  { This procedure call destructor for all objects in then AList.
    List AList must contains objects, all of its values should be not equal nil. 
Parameters:
  AList - TList, list of objects.}
  procedure FreeListItems(AList: TList);
{$IFDEF VTK_D4}
  procedure FreeAndNil(var AObject);
{$ENDIF}
  { This procedure call destructor for all objects in then AList.
    List AList must contains objects, all of its values should be not equal nil.
    Also this procedure free AList object.
Parameters:
  AList - list of objects.}
  procedure FreeList(var AList: TList);

  { Copying contents of AStream object to clipboard.
    All contents of AStream are copied, irrespective of its property Position. 
Parameters:
  AClipboardFormat - Word number which represents clipboard format
  AStream - TMemoryStream object
}
  procedure StreamToClipboard(AClipboardFormat: Word; AStream: TMemoryStream);
  { Copying contents of clipboard to a AStream object.
    Previos contents of AStream are discarded.
Parameters:
  AClipboardFormat - Word number which represents clipboard format
  AStream - TMemoryStream object}
  procedure StreamFromClipboard(AClipboardFormat: Word; AStream: TMemoryStream);

  function GetBorderPartSize(ASize: Integer; ASide: TvgrBorderSide): Integer;

  { Use this method to convert a value in twips to a value in pixels, based on value of ScreenPixelsPerInchX variable.
Parameters:
  Twips - Number of twips
Return value:
  Number of pixels}
  function ConvertTwipsToPixelsX(Twips: integer): integer; overload;
  { Use this method to convert a value in twips to a value in pixels, based on value of ScreenPixelsPerInchY variable. 
Parameters:
  Twips - Number of twips
Return value:
  Number of pixels}
  function ConvertTwipsToPixelsY(Twips: integer): integer; overload;
  { Use this method to convert a value in twips to a value in pixels, based on value of PixelsPerX parameter.
Parameters:
  Twips - Number of twips
  PixelsPerX - indicates the number of device pixels that make up a logical inch in the horizontal direction.
Return value:
  Number of pixels}
  function ConvertTwipsToPixelsX(Twips: integer; PixelsPerX: Integer): integer; overload;
  {Use this method to convert a value in twips to a value in pixels, based on value of PixelsPerY parameter.
Parameters:
  Twips - Number of twips
  PixelsPerY -  parameter indicates the number of device pixels that make up a logical inch in the vertical direction.
Return value:
  Number of pixels
}
  function ConvertTwipsToPixelsY(Twips: integer; PixelsPerY: Integer): integer; overload;

  { Use this method to convert a value in pixels to a value in twips, based on value of ScreenPixelsPerInchX variable. 
Parameters:
  Integer, number of pixels
Return value:
  Integer, number of twips
}
  function ConvertPixelsToTwipsX(Pixels: integer): integer; overload;
  { Use this method to convert a value in pixels to a value in twips, based on value of ScreenPixelsPerInchY variable.
Parameters:
  Integer, number of pixels
Return value:
  Integer, number of twips
}
  function ConvertPixelsToTwipsY(Pixels: integer): integer; overload;
  { Use this method to convert a value in pixels to a value in twips, based on value of PixelsPerX parameter.
Parameters:
  Pixels - number of pixels
  PixelsPerX - parameter indicates the number of device pixels that make up a logical inch in the horizontal direction.
Return value:
  Integer, number of twips}
  function ConvertPixelsToTwipsX(Pixels: integer; PixelsPerX: Integer): integer; overload;
  { Use this method to convert a value in pixels to a value in twips, based on value of PixelsPerY parameter.
Parameters:
  Pixels - number of pixels
  PixelsPerY - indicates the number of device pixels that make up a logical inch in the vertical direction. 
Return value:
  Integer, number of twips.
  }
  function ConvertPixelsToTwipsY(Pixels: integer; PixelsPerY: Integer): integer; overload;

  { Use this method to convert a value in units which specified a AUnits parameter to a value in twips.
Parameters:
  AValue - Extended, value in units.
  AUnits - TvgrUnits, type of units. If AUnits equals to vgruPixels, 
ScreenPixelsPerInchY variable used in coversion.
Return value:
  Integer, number of twips}
  function ConvertUnitsToTwips(AValue: Extended; AUnits: TvgrUnits): Integer;
  { Use this method to covert a value in twips to a value in units which specified a AUnits parameter.
Parameters:
  ATwips - Integer, number of twips.
  AUnits - TvgrUnits, type of units. If AUnits equals to vgruPixels, 
ScreenPixelsPerInchY variable used in coversion. 
Return value:
  Extended, value in units}
  function ConvertTwipsToUnits(ATwips: Integer; AUnits: TvgrUnits): Extended;
  { Use this method to convert a value in twips to a value in units which specified a AUnits parameter.
    Resulting value are formatted to string.    
Parameters:
  ATwips - Integer, number of twips.
  AUnits - TvgrUnits, type of units. If AUnits equals to vgruPixels, 
ScreenPixelsPerInchY variable used in coversion.
Return value:
  String, value in units.
    }
  function ConvertTwipsToUnitsStr(ATwips: Integer; AUnits: TvgrUnits): string;

  { Returns True if a passed string is the list of pages, for example:
    '1,3,6,10-13'. 
Parameters:
  S - String for checking
Return value:
  Boolean
    }
  function CheckPageList(const S: string): Boolean;
  { This function are parsing string and form a list of numbers in this string.
Example:
    S = '1,3,6,10-13'
    APagesList contains these items: 1,3,6,10,11,12,13.  
Parameters:
  S - String for parsing
  APagesList - TList containing resulting numbers
Return value:
  Boolean. Returns True if successful.}
  function TextToPageList(const S: string; APagesList: TList): Boolean;

  { Function GetCurrencyFormat returns the format string used to convert a numeric value to a string for display a currency value.
    This string can be passed as format to a FormatFloat function.
Return value:
  String with format.}
  function GetCurrencyFormat: string;
  { Returns a path name with a trailing delimiter. If APathName not contains a backslahs at end,
the return value is APathName with the added backslahs symbol at end.
Parameters:
  APathName - string with path name
Return value:
  Path name with a trailing delimiter
}
  function AddFlash(const APathName: string): string;
  { Search file with specified name and return its full name.<br>
    The search goes in the following order:
      <li>1. In program directory</li>
      <li>2. In windows system directory</li>
      <li>3. In windows directory</li><br>
    If file not exists in previous paths return file in program directory. }
  function GetFindFileName(const AFileName: string): string;
  { Returns full file name relative to specified directory.
Example:
      AFileName = 'c:\temp\temp1\temp.tmp'
      ADirectory = 'c:\temp'
      Result = temp1\temp.tmp

      AFileName = 'c:\temp\temp1\temp.tmp'
      ADirectory = 'c:\temp\temp2'
      Result = '..\temp1\temp.tmp' 
Parameters:
  AFileName - string with full path to file
  ADirectory - string with full path to directory
Return value:
  String, full file name relative to specified directory}
  function GetRelativePathToFile(const AFileName: string; const ADirectory: string): string; 

  { Write a string to specified stream at current position, in this format:  
    first four bytes - length of string
    next chars - contents of the string without last zero character.
Parameters:
  AStream - TStream object
  S - string value for writing}
  procedure WriteString(AStream: TStream; const S: string);
  { Write a string to specified stream at current position,
    also this function add an end-of-line marker (line feed or carriage return/line feed) to the stream. 
Parameters:
  AStream - TStream object
  S - string value for writing
} 
  procedure WriteLnString(AStream: TStream; const S: string);
  { Writes the Boolean value passed in Value to the current position of the stream. 
Parameters:
  AStream - TStream object
  Value - boolean value for writing
}
  procedure WriteBoolean(AStream: TStream; Value: Boolean);
  { Reads a string value written by WriteString from the stream and returns its contents. 
Parameters:
  AStream - TStream object
Return value:
  String value written by WriteString.}
  function ReadString(AStream: TStream): string;
  { Reads a boolean from the stream and returns that boolean value. 
Parameters:
  AStream - TStream object
Return value:
  Boolean.}
  function ReadBoolean(AStream: TStream): Boolean;

  { Obtains the name of a character set.
    Call vgrCharsetToIdent to obtain the symbolic name for the character set of a font.
Parameters:
  ACharset - TFontCharset
Return value:
  String with symbolic name for the character set of a font.
}
  function vgrCharsetToIdent(ACharset: TFontCharset): string;
  { Translates the name of a character set constant to the corresponding character set. 
Parameters:
  AIdent - string with name of a character set
Return value:
  TFontCharset}
  function vgrIdentToCharset(const AIdent: string): TFontCharset;

  { Extract new line from string from position [P]. Lines are delimited by #13#10 chars. 
Parameters:
  S - string from which is extracted new line
  P - position of the initial symbol in string S
Return value:
  String with new line}
  function ExtractLine(const S: string; var P: Integer): string;

  { ExtractSubStr given a set of word delimiters, return the substring from S,
    that started from position Pos.
Parameters:
  S - string for processing
  Pos - integer witch indicates started position
  Delims - TSysCharSet, set of word delimiters.
Return value:
  String
    }
  function ExtractSubStr(const S: string; var Pos: Integer; const Delims: TSysCharSet): string;
{Rounds a number to a specified number of digits.
Parameters:
  AValue - Is the number you want to round.
  ANumDigits - Specifies the number of digits to which you want to round number.}
  function RoundEx(AValue: Extended; ANumDigits: Integer): Extended;

  procedure JustifyArray(a: PIntArray;
                         aLen, NeededSize, RealSize: Integer; AUseSpaces: Boolean; S: PChar);

  /////////////////////////////////////////////////
  //
  // DEBUG Functions
  //
  /////////////////////////////////////////////////
  procedure DbgFileWriteString(const AFileName: string; const S: string); overload;
  procedure DbgFileWriteString(const S: string); overload;

  procedure DbgFileRect(const ADescRect: string; const ARect: TRect);
  procedure DbgFileStr(const s: string);
  procedure DbgFileStrFmt(const AMask: string; AParams: array of const);

  procedure DbgRect(const ADescRect: string; const ARect: TRect);
  procedure DbgStr(const s: string);
  procedure DbgStrFmt(const AMask: string; AParams: array of const);

var
  { ScreenPixelsPerInchX global variable indicates the number of device pixels
    that make up a logical inch in the horizontal direction. }
  ScreenPixelsPerInchX: Integer;
  { ScreenPixelsPerInchY global variable indicates the number of device pixels
    that make up a logical inch in the vertical direction. }
  ScreenPixelsPerInchY: Integer;

  DbgFileFileName: string = 'c:\CommonControlsDbgFile.txt';
  
implementation

uses
  vgr_Consts;

const
{$IFNDEF VTK_D6_OR_D7}
  FuzzFactor = 1000;
  ExtendedResolution = 1E-19 * FuzzFactor;
  DoubleResolution   = 1E-15 * FuzzFactor;
  SingleResolution   = 1E-7 * FuzzFactor;
{$ENDIF}
  RoundArray: array [1..5] of integer =(10, 100, 1000, 10000, 100000);

/////////////////////////////////////////////////
//
// Functions
//
/////////////////////////////////////////////////
procedure JustifyArray(a: PIntArray; aLen, NeededSize, RealSize: Integer; AUseSpaces: Boolean; S: PChar);
var
  i,n,step,Delta,DeltaAbs, ASpacesCount : integer;
begin
  if aLen = 0 then exit;

  Delta := NeededSize - RealSize;

  if AUseSpaces and (Delta > 0) then
  begin

    ASpacesCount := 0;
    for I := 1 to Length(S) do
      if S[I] = ' ' then
        Inc(ASpacesCount);

    if ASpacesCount = 0 then
      exit;

    if Delta >= ASpacesCount then
    begin
      N := Delta div ASpacesCount;
      for I := 0 to aLen - 1 do
        if S[I] = ' ' then
        begin
          Inc(a^[i], N);
          Dec(Delta, N);
        end;
    end;

    if Delta <> 0 then
    begin
      I := 0;
      while (I < aLen) and (Delta > 0) do
      begin
        if S[I] = ' ' then
        begin
          Inc(a^[I], 1);
          Dec(Delta);
        end;
        Inc(I);
      end;
    end;
  end
  else
  begin
    DeltaAbs := Abs(Delta);

    if DeltaAbs >= aLen then
    begin
      n := Delta div aLen;
      for I := 0 to aLen - 1 do
      begin
        Inc(a^[i], n);
        Dec(Delta, n);
      end;
      DeltaAbs := Abs(Delta);
    end;

    if Delta <> 0 then
    begin
      if Delta > 0 then step := 1
                   else step := -1;
      N := aLen div DeltaAbs;
      I := 0;
      while (I < aLen) and (DeltaAbs > 0) do
      begin
        Inc(a^[I], step);
        Inc(I, N);
        Dec(DeltaAbs);
      end;

      if DeltaAbs > 0 then
        Inc(a^[aLen div 2], step);
    end;
  end;
end;

function RoundEx(AValue: Extended; ANumDigits: Integer): Extended;
var
  AKoef, ADelta: Extended;
begin
  if ANumDigits = 0 then
    Result := Round(AValue)
  else
  begin
    if Abs(ANumDigits) > 5 then
      AKoef := Power(10, Abs(ANumDigits))
    else
      AKoef := RoundArray[Abs(ANumDigits)];

    if AValue < 0 then
      ADelta := -0.5
    else
      ADelta := 0.5;

    if ANumDigits > 0 then
      Result := Int(AValue * AKoef + ADelta) / AKoef
    else
      Result := Int(AValue / AKoef + ADelta) * AKoef;
  end;
end;

function HexToIntDef(const S: string; ADefault: Integer = 0): Integer;
begin
  if not HexToInt(S, Result) then
    Result := ADefault;
end;

function HexToInt(const S: string; var AResult: Integer): Boolean;
var
  I, AShift: Integer;
begin
  Result := Length(S) <= 8;
  if Result then
  begin
    AShift := 0;
    AResult := 0;
    for I := Length(S) downto 1 do
    begin
      case S[I] of
        '0'..'9': AResult := AResult + ((Byte(S[i]) - Byte('0')) shl AShift);
        'a'..'f': AResult := Aresult + ((Byte(S[i]) - Byte('a') + 10) shl AShift);
        'A'..'F': AResult := Aresult + ((Byte(S[i]) - Byte('A') + 10) shl AShift);
        else
          begin
            Result := False;
            exit;
          end;
      end;
      AShift := AShift + 4;
    end;
  end;
end;

function ExtractLine(const S: string; var P: Integer): string;
var
  I, J, ALen: Integer;
begin
  ALen := Length(S);
  I := P;
  while (P <= ALen) and not (S[P] in [#10, #13]) do Inc(P);
  J := P;
  if P <= ALen then
  begin
    if (P < ALen) and (((S[P] = #10) and (S[P + 1] = #13)) or
                       ((S[P] = #13) and (S[P + 1] = #10))) then
      Inc(P);
    Inc(P);
  end;
  Result := Copy(S, I, J - I);
end;

function ExtractSubStr(const S: string; var Pos: Integer;
  const Delims: TSysCharSet): string;
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and not (S[I] in Delims) do Inc(I);
  Result := Copy(S, Pos, I - Pos);
  if (I <= Length(S)) and (S[I] in Delims) then Inc(I);
  Pos := I;
end;

function vgrCharsetToIdent(ACharset: TFontCharset): string;
var
  S: string;
begin
  CharsetToIdent(ACharset, S);
  if S = '' then
    Result := IntToStr(ACharset)
  else
    Result := S;
end;

function vgrIdentToCharset(const AIdent: string): TFontCharset;
var
  ACharset: Integer;
begin
  if not IdentToCharset(AIdent, ACharset) then
    Result := StrToIntDef(AIdent, DEFAULT_CHARSET)
  else
    Result := ACharset;
end;

procedure WriteString(AStream: TStream; const S: string);
var
  N: Integer;
begin
  N := Length(S);
  AStream.Write(N, 4);
  AStream.WriteBuffer(S[1], N);
end;

procedure WriteLnString(AStream: TStream; const S: string);
var
  ABuf: string;
begin
  ABuf := S + #13#10;
  AStream.Write(ABuf[1], Length(ABuf));
end;

procedure WriteBoolean(AStream: TStream; Value: Boolean);
begin
  AStream.Write(Value, 1);
end;

function ReadString(AStream: TStream): string;
var
  N: Integer;
begin
  AStream.Read(N, 4);
  SetLength(Result, N);
  AStream.Read(Result[1], N);
end;

function ReadBoolean(AStream: TStream): Boolean;
begin
  AStream.Read(Result, 1);
end;

function GetFindFileName(const AFileName: string): string;
var
  Buf: array [0..255] of char;
begin
  Result := AddFlash(ExtractFilePath(ParamStr(0))) + AFileName;
  if not FileExists(Result) then
  begin
    {find in System dir}
    GetSystemDirectory(Buf, 255);
    Result := AddFlash(StrPas(Buf)) + AFileName;
    if not FileExists(Result) then
      begin
        {find in Windows dir}
        GetWindowsDirectory(Buf, 255);
        Result := AddFlash(StrPas(Buf)) + AFileName;
        if not FileExists(Result) then
          Result := AddFlash(ExtractFilePath(ParamStr(0))) + AFileName;
      end;
  end;
end;

function GetRelativePathToFile(const AFileName: string; const ADirectory: string): string;
var
  ADir, AFilePath: string;
  I, J, AFileNameLen, ADirLen: Integer;
begin
  ADir := AddFlash(ADirectory);
  AFileNameLen := Length(AFileName);
  AFilePath := ExtractFilePath(AFileName);
  ADirLen := Length(ADir);
  I := 0;
  while (I < AFileNameLen) and (I < ADirLen) and
        (AnsiCompareText(Copy(AFileName, 1, I + 1), Copy(ADir, 1, I + 1)) = 0) do Inc(I);

  if I = 0 then
    Result := AFileName
  else
  begin
    Result := '';
    J := ADirLen;
    while J > I do
    begin
      if ADir[J] = '\' then
        Result := Result + '..\';
      Dec(J);
    end;
    Result := Result + Copy(AFileName, I + 1, AFileNameLen);
  end;
end;

function AddFlash(const APathName: string): string;
begin
  Result := APathName;
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
end;

function GetCurrencyFormat: string;
var
  CurrStr: string;
  I: Integer;
  C: Char;
begin
  if CurrencyDecimals > 0 then
  begin
    SetLength(Result, CurrencyDecimals);
    FillChar(Result[1], Length(Result), '0');
  end
  else
    Result := '';
  Result := ',0.' + Result;
  CurrStr := '';
  for I := 1 to Length(CurrencyString) do
  begin
    C := CurrencyString[I];
    if C in [',', '.'] then
      CurrStr := CurrStr + '''' + C + ''''
    else
      CurrStr := CurrStr + C;
  end;
  if Length(CurrStr) > 0 then
    case Sysutils.CurrencyFormat of
      0: Result := CurrStr + Result; { '$1' }
      1: Result := Result + CurrStr; { '1$' }
      2: Result := CurrStr + ' ' + Result; { '$ 1' }
      3: Result := Result + ' ' + CurrStr; { '1 $' }
    end;
  Result := Format('%s;-%s', [Result, Result]);
end;

{$IFNDEF VTK_D7}
function TryEncodeDate(Year, Month, Day: Word; out Date: TDateTime): Boolean;
var
  I: Integer;
  DayTable: PDayTable;
begin
  Result := False;
  DayTable := @MonthDays[IsLeapYear(Year)];
  if (Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
    (Day >= 1) and (Day <= DayTable^[Month]) then
  begin
    for I := 1 to Month - 1 do Inc(Day, DayTable^[I]);
    I := Year - 1;
    Date := I * 365 + I div 4 - I div 100 + I div 400 + Day - DateDelta;
    Result := True;
  end;
end;

type
  TDateOrder = (doMDY, doDMY, doYMD);
  
function GetDateOrder(const DateFormat: string): TDateOrder;
var
  I: Integer;
begin
  Result := doMDY;
  I := 1;
  while I <= Length(DateFormat) do
  begin
    case Chr(Ord(DateFormat[I]) and $DF) of
      'E': Result := doYMD;
      'Y': Result := doYMD;
      'M': Result := doMDY;
      'D': Result := doDMY;
    else
      Inc(I);
      Continue;
    end;
    Exit;
  end;
  Result := doMDY;
end;

function StrCharLength(const Str: PChar): Integer;
begin
  if SysLocale.FarEast then
    Result := Integer(CharNext(Str)) - Integer(Str)
  else
    Result := 1;
end;

function NextCharIndex(const S: string; Index: Integer): Integer;
begin
  Result := Index + 1;
  assert((Index > 0) and (Index <= Length(S)));
  if SysLocale.FarEast and (S[Index] in LeadBytes) then
    Result := Index + StrCharLength(PChar(S) + Index - 1);
end;

procedure ScanBlanks(const S: string; var Pos: Integer);
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and (S[I] = ' ') do Inc(I);
  Pos := I;
end;

function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
begin
  Result := False;
  ScanBlanks(S, Pos);
  if (Pos <= Length(S)) and (S[Pos] = Ch) then
  begin
    Inc(Pos);
    Result := True;
  end;
end;

function ScanNumber(const S: string; var Pos: Integer;
  var Number: Word; var CharCount: Byte): Boolean;
var
  I: Integer;
  N: Word;
begin
  Result := False;
  CharCount := 0;
  ScanBlanks(S, Pos);
  I := Pos;
  N := 0;
  while (I <= Length(S)) and (S[I] in ['0'..'9']) and (N < 1000) do
  begin
    N := N * 10 + (Ord(S[I]) - Ord('0'));
    Inc(I);
  end;
  if I > Pos then
  begin
    CharCount := I - Pos;
    Pos := I;
    Number := N;
    Result := True;
  end;
end;

procedure ScanToNumber(const S: string; var Pos: Integer);
begin
  while (Pos <= Length(S)) and not (S[Pos] in ['0'..'9']) do
  begin
    if S[Pos] in LeadBytes then
      Pos := NextCharIndex(S, Pos)
    else
      Inc(Pos);
  end;
end;

function GetEraYearOffset(const Name: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(EraNames) to High(EraNames) do
  begin
    if EraNames[I] = '' then Break;
    if AnsiStrPos(PChar(EraNames[I]), PChar(Name)) <> nil then
    begin
      Result := EraYearOffsets[I];
      Exit;
    end;
  end;
end;

function CurrentYear: Word;
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wYear;
end;

function ScanDate(const S: string; var Pos: Integer;
  var Date: TDateTime): Boolean; overload;
var
  DateOrder: TDateOrder;
  N1, N2, N3, Y, M, D: Word;
  L1, L2, L3, YearLen: Byte;
  CenturyBase: Integer;
  EraName : string;
  EraYearOffset: Integer;

  function EraToYear(Year: Integer): Integer;
  begin
    if SysLocale.PriLangID = LANG_KOREAN then
    begin
      if Year <= 99 then
        Inc(Year, (CurrentYear + Abs(EraYearOffset)) div 100 * 100);
      if EraYearOffset > 0 then
        EraYearOffset := -EraYearOffset;
    end
    else
      Dec(EraYearOffset);
    Result := Year + EraYearOffset;
  end;

begin
  Y := 0;
  M := 0;
  D := 0;
  YearLen := 0;
  Result := False;
  DateOrder := GetDateOrder(ShortDateFormat);
  EraYearOffset := 0;
  if (ShortDateFormat <> '') and (ShortDateFormat[1] = 'g') then  // skip over prefix text
  begin
    ScanToNumber(S, Pos);
    EraName := Trim(Copy(S, 1, Pos-1));
    EraYearOffset := GetEraYearOffset(EraName);
  end
  else
    if AnsiPos('e', ShortDateFormat) > 0 then
      EraYearOffset := EraYearOffsets[1];
  if not (ScanNumber(S, Pos, N1, L1) and ScanChar(S, Pos, DateSeparator) and
    ScanNumber(S, Pos, N2, L2)) then Exit;
  if ScanChar(S, Pos, DateSeparator) then
  begin
    if not ScanNumber(S, Pos, N3, L3) then Exit;
    case DateOrder of
      doMDY: begin Y := N3; YearLen := L3; M := N1; D := N2; end;
      doDMY: begin Y := N3; YearLen := L3; M := N2; D := N1; end;
      doYMD: begin Y := N1; YearLen := L1; M := N2; D := N3; end;
    end;
    if EraYearOffset > 0 then
      Y := EraToYear(Y)
    else
    if (YearLen <= 2) then
    begin
      CenturyBase := CurrentYear - TwoDigitYearCenturyWindow;
      Inc(Y, CenturyBase div 100 * 100);
      if (TwoDigitYearCenturyWindow > 0) and (Y < CenturyBase) then
        Inc(Y, 100);
    end;
  end else
  begin
    Y := CurrentYear;
    if DateOrder = doDMY then
    begin
      D := N1; M := N2;
    end else
    begin
      M := N1; D := N2;
    end;
  end;
  ScanChar(S, Pos, DateSeparator);
  ScanBlanks(S, Pos);
  if SysLocale.FarEast and (System.Pos('ddd', ShortDateFormat) <> 0) then
  begin     // ignore trailing text
    if ShortTimeFormat[1] in ['0'..'9'] then  // stop at time digit
      ScanToNumber(S, Pos)
    else  // stop at time prefix
      repeat
        while (Pos <= Length(S)) and (S[Pos] <> ' ') do Inc(Pos);
        ScanBlanks(S, Pos);
      until (Pos > Length(S)) or
        (AnsiCompareText(TimeAMString, Copy(S, Pos, Length(TimeAMString))) = 0) or
        (AnsiCompareText(TimePMString, Copy(S, Pos, Length(TimePMString))) = 0);
  end;
  Result := TryEncodeDate(Y, M, D, Date);
end;

function ScanString(const S: string; var Pos: Integer;
  const Symbol: string): Boolean;
begin
  Result := False;
  if Symbol <> '' then
  begin
    ScanBlanks(S, Pos);
    if AnsiCompareText(Symbol, Copy(S, Pos, Length(Symbol))) = 0 then
    begin
      Inc(Pos, Length(Symbol));
      Result := True;
    end;
  end;
end;

function TryEncodeTime(Hour, Min, Sec, MSec: Word; out Time: TDateTime): Boolean;
begin
  Result := False;
  if (Hour < HoursPerDay) and (Min < MinsPerHour) and (Sec < SecsPerMin) and (MSec < MSecsPerSec) then
  begin
    Time := (Hour * (MinsPerHour * SecsPerMin * MSecsPerSec) +
             Min * (SecsPerMin * MSecsPerSec) +
             Sec * MSecsPerSec +
             MSec) / MSecsPerDay;
    Result := True;
  end;
end;

function ScanTime(const S: string; var Pos: Integer;
  var Time: TDateTime): Boolean; overload;
var
  BaseHour: Integer;
  Hour, Min, Sec, MSec: Word;
  Junk: Byte;
begin
  Result := False;
  BaseHour := -1;
  if ScanString(S, Pos, TimeAMString) or ScanString(S, Pos, 'AM') then
    BaseHour := 0
  else if ScanString(S, Pos, TimePMString) or ScanString(S, Pos, 'PM') then
    BaseHour := 12;
  if BaseHour >= 0 then ScanBlanks(S, Pos);
  if not ScanNumber(S, Pos, Hour, Junk) then Exit;
  Min := 0;
  Sec := 0;
  MSec := 0;
  if ScanChar(S, Pos, TimeSeparator) then
  begin
    if not ScanNumber(S, Pos, Min, Junk) then Exit;
    if ScanChar(S, Pos, TimeSeparator) then
    begin
      if not ScanNumber(S, Pos, Sec, Junk) then Exit;
      if ScanChar(S, Pos, DecimalSeparator) then
        if not ScanNumber(S, Pos, MSec, Junk) then Exit;
    end;
  end;
  if BaseHour < 0 then
    if ScanString(S, Pos, TimeAMString) or ScanString(S, Pos, 'AM') then
      BaseHour := 0
    else
      if ScanString(S, Pos, TimePMString) or ScanString(S, Pos, 'PM') then
        BaseHour := 12;
  if BaseHour >= 0 then
  begin
    if (Hour = 0) or (Hour > 12) then Exit;
    if Hour = 12 then Hour := 0;
    Inc(Hour, BaseHour);
  end;
  ScanBlanks(S, Pos);
  Result := TryEncodeTime(Hour, Min, Sec, MSec, Time);
end;

function TryStrToTime(const S: string; out Value: TDateTime): Boolean;
var
  Pos: Integer;
begin
  Pos := 1;
  Result := ScanTime(S, Pos, Value) and (Pos > Length(S));
end;

function TryStrToDateTime(const S: string; out Value: TDateTime): Boolean;
var
  Pos: Integer;
  Date, Time: TDateTime;
begin
  Result := True;
  Pos := 1;
  Time := 0;
  if not ScanDate(S, Pos, Date) or
     not ((Pos > Length(S)) or ScanTime(S, Pos, Time)) then

    // Try time only
    Result := TryStrToTime(S, Value)
  else
    if Date >= 0 then
      Value := Date + Time
    else
      Value := Date - Time;
end;

function StrToDateTimeDef(const S: string; ADefDateTime: TDateTime): TDateTime;
begin
  if not TryStrToDateTime(S, Result) then
    Result := ADefDateTime;
end;
{$ENDIF}

{$IFNDEF VTK_D6_OR_D7}
function Supports(const Instance: IInterface; const IID: TGUID; out Intf): Boolean;
begin
  Result := (Instance <> nil) and (Instance.QueryInterface(IID, Intf) = 0);
end;

function SupportsObject(const Instance: TObject; const IID: TGUID; out Intf): Boolean;
var
  LUnknown: IInterface;
begin
  Result := (Instance <> nil) and
            ((Instance.GetInterface(IUnknown, LUnknown) and Supports(LUnknown, IID, Intf)) or
             Instance.GetInterface(IID, Intf));
end;

function Supports(const Instance: IInterface; const IID: TGUID): Boolean;
var
  Temp: IInterface;
begin
  Result := Supports(Instance, IID, Temp);
end;

function Supports(const Instance: TObject; const IID: TGUID): Boolean;
var
  Temp: IInterface;
begin
  Result := SupportsObject(Instance, IID, Temp);
end;

function Supports(const AClass: TClass; const IID: TGUID): Boolean;
begin
  Result := AClass.GetInterfaceEntry(IID) <> nil;
end;

function DirectoryExists(const Directory: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function IsZero(const A: Extended; Epsilon: Extended): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := ExtendedResolution;
  Result := Abs(A) <= Epsilon;
end;

function IsZero(const A: Double; Epsilon: Double): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := DoubleResolution;
  Result := Abs(A) <= Epsilon;
end;

function IsZero(const A: Single; Epsilon: Single): Boolean;
begin
  if Epsilon = 0 then
    Epsilon := SingleResolution;
  Result := Abs(A) <= Epsilon;
end;
{$ENDIF}

function GetWorksheetColCaption(ColNumber : integer) : string;
begin
  Result := '';
  repeat
    Result := char(ColNumber mod 26+byte('A'))+Result;
    ColNumber := ColNumber div 26;
    if ColNumber=1 then
      Result := 'A'+Result;
  until ColNumber<=1;
end;

function GetWorksheetRowCaption(RowNumber : integer) : string;
begin
  Result := IntToStr(RowNumber+1);
end;

function RectOverRect(const r1: TRect; const r2: TRect): boolean;
begin
  Result :=
    (((r1.Left >= r2.Left) and (r1.Left <= r2.Right)) or ((r1.Right >= r2.Left) and (r1.Right <= r2.Right)) or ((r1.Left <= r2.Left) and (r1.Right >= r2.Left)))
    and
    (((r1.Top >= r2.Top) and (r1.Top <= r2.Bottom)) or ((r1.Bottom >= r2.Top) and (r1.Bottom <= r2.Bottom)) or ((r1.Top <= r2.Top) and (r1.Bottom >= r2.Top)));
end;

function NormalizeRect(const r: TRect): TRect;
begin
  Result := NormalizeRect(r.Left,r.Top,r.Right,r.Bottom);
end;

function NormalizeRect(x1,y1,x2,y2: Integer): TRect;
begin
  if x1 > x2 then
  begin
    Result.Left := x2;
    Result.Right := x1;
  end
  else
  begin
    Result.Left := x1;
    Result.Right := x2;
  end;
  if y1 > y2 then
  begin
    Result.Top := y2;
    Result.Bottom := y1;
  end
  else
  begin
    Result.Top := y1;
    Result.Bottom := y2;
  end;
end;

function Size(cx, cy: Integer): TSize;
begin
  Result.cx := cx;
  Result.cy := cy;
end;

function RectInRect(const ASmallRect, ALargeRect: TRect): Boolean;
begin
  Result := PtInRect(ALargeRect, ASmallRect.TopLeft) and
            PtInRect(ALargeRect, ASmallRect.BottomRight);
end;

function RectInSelRect(const ASmallRect, ALargeRect: TRect): Boolean;
begin
  Result := (ALargeRect.Left <= ASmallRect.Left) and
            (ALargeRect.Right >= ASmallRect.Right) and
            (ALargeRect.Top <= ASmallRect.Top) and
            (ALargeRect.Bottom >= ASmallRect.Bottom);
end;

function PointInSelRect(const APoint: TPoint; ARect: TRect): Boolean;
begin
  with APoint, ARect do
    Result := (X >= Left) and (X <= Right) and (Y >= Top) and (Y <= Bottom);
end;

function HorzCenterOfRect(const ARect: TRect): Integer;
begin
  Result := ARect.Left + (ARect.Right - ARect.Left) div 2;
end;

procedure GetEnumNamesToStrings(ATypeInfo: PTypeInfo; AStrings: TStrings; ADeleteFirstCharCount: Integer = 0);
var
  I: Integer;
  s: string;
begin
  for I := GetTypeData(ATypeInfo).MinValue to GetTypeData(ATypeInfo).MaxValue do
  begin
    s := GetEnumName(ATypeInfo, I);
    Delete(s, 1, ADeleteFirstCharCount);
    AStrings.Add(s);
  end;
end;

function GetUniqueComponentName(AComponent: TComponent): string;
var
  I: Integer;
  AParent: TComponent;
  APrefix: string;
begin
  AParent := AComponent.GetParentComponent;
  Result := '';
  while AParent <> nil do
  begin
    Result := AParent.Name + Result;
    AParent := AParent.GetParentComponent;
  end;

  APrefix := AComponent.ClassName;
  Delete(APrefix, 1, 1);
  if AComponent.Owner = nil then
    Result := Result + APrefix
  else
  begin
    I := 1;
    while (I < MaxInt) and (AComponent.Owner.FindComponent(Result + APrefix + IntToStr(I)) <> nil) do Inc(I);
    Result := Result + APrefix + IntToStr(I);
  end;
end;

function CheckComponentName(AComponent: TComponent; const ANewName: string): Boolean;
begin
  Result := (ANewName <> '') and ((AComponent.Owner = nil) or (AComponent.Owner.FindComponent(ANewName) = nil) or (AComponent.Owner.FindComponent(ANewName) = AComponent));
end;

function FormatVariant(const AFormat: string; const AValue: Variant): string;
begin
  case VarType(AValue) of
    varSmallint, varInteger, varSingle,
    {$IFDEF VRK_D6_OR_D7}varShortInt,
    varWord, varLongWord, varInt64,{$ENDIF}
    varByte, varDouble, varCurrency:
      Result := FormatFloat(AFormat, AValue);
    varDate:
      Result := FormatDateTime(AFormat, AValue);
    varOleStr, {$IFDEF VRK_D6_OR_D7}varStrArg, {$ENDIF}varString:
      Result := VarToStr(AValue);
    else
      Result := '';
  end;
end;

function IndexInStrings(const S: string; AList: TStrings): Integer;
begin
  Result := 0;
  while (Result < AList.Count) and (AnsiCompareText(AList[Result], S) <> 0) do Inc(Result);
  if Result >= AList.Count then
    Result := -1;
end;

function PosToRowAndCol(AStrings: TStrings; APos: Integer; var ARow, ACol: Integer; AStringDelimiters: TSysCharSet): Boolean;
var
  S: string;
  C: char;
  I: Integer;
  AMaxPos: Integer;
begin
  ARow := 1;
  ACol := 1;
  S := AStrings.Text;
  AMaxPos := Min(APos, Length(S));
  I := 1;
  while I < AMaxPos do
  begin
    ACol := 1;
    while (I < AMaxPos) and not(S[I] in AStringDelimiters) do
    begin
      Inc(ACol);
      Inc(I);
    end;
    if (I < AMaxPos) and (S[I] in AStringDelimiters) then
    begin
      C := S[I];
      Inc(I);
      if (I < AMaxPos) and (S[I] in AStringDelimiters) and (S[I] <> c) then
        Inc(I);
    end;
//    while (I < AMaxPos) and (S[I] in AStringDelimiters) do Inc(I);
    if I > AMaxPos then
      break;
    Inc(ARow);
  end;
  Result := I >= APos;
end;

function PosToRowAndCol(AStrings: TStrings; APos: Integer; var ARow, ACol: Integer): Boolean;
begin
  Result := PosToRowAndCol(AStrings, APos, ARow, ACol, [#13, #10]);
end;

procedure BeginEnumLines(const S: string; var ALineInfo: TvgrTextLineInfo);
begin
  with ALineInfo do
  begin
    Start := 1;
    Length := 0;
    FullLength := 0;
    TextLength := System.Length(S);
    CrLf := False;
  end;
end;

procedure FindEndOfLineBreak(const S: string; ALen: Integer; var I: Integer);
begin
  if (I <= ALen) and ((S[I] = #13) or (S[I] = #10)) then
  begin
    Inc(I);
    if (I <= ALen) and ((S[I] = #13) or (S[I] = #10)) and (S[I] <> S[I - 1]) then
      Inc(I);
  end;
end;

function EnumLines(const S: string; var ALineInfo: TvgrTextLineInfo): Boolean;
var
  I: Integer;
begin
  with ALineInfo do
  begin
    Start := Start + FullLength;
    Result := Start <= TextLength;
    if Result then
    begin
      I := Start;
      while (I <= TextLength) and (S[I] <> #13) and (S[I] <> #10) do Inc(I);
      Length := I - Start;
      if I <= TextLength then
      begin
        FindEndOfLineBreak(S, TextLength, I);
        FullLength := I - Start;
        if I > TextLength then
        begin
          if CrLf then
          begin
//            CrLf := false;
            Result := True;
          end
          else
          begin
            CrLf := True;
            FullLength := Length;
          end;
        end;
      end
      else
        FullLength := Length;
    end;
//    Assert(not (Result and (FullLength = 0)));
  end;
end;

procedure FreeListItems(AList: TList);
var
  I: Integer;
begin
  for I := 0 to AList.Count - 1 do
    TObject(AList[I]).Free;
end;

{$IFDEF VTK_D4}
procedure FreeAndNil(var AObject);
var
  P: TObject;
begin
  P := TObject(AObject);
  TObject(AObject) := nil;  // clear the reference before destroying the object
  P.Free;
end;
{$ENDIF}

procedure FreeList(var AList: TList);
begin
  FreeListItems(AList);
  FreeAndNil(AList);
end;

procedure StreamToClipboard(AClipboardFormat: Word; AStream: TMemoryStream);
var
  hMem: THandle;
  pMem: Pointer;
begin
  ClipBoard.Open;
  try
    hMem := GlobalAlloc(GMEM_MOVEABLE + GMEM_SHARE + GMEM_ZEROINIT, AStream.Size);
    if hMem <> 0 then
    begin
      pMem := GlobalLock(hMem);
      if pMem <> nil then
      begin
        CopyMemory(pMem, AStream.Memory, AStream.Size);
        GlobalUnLock(hMem);
        ClipBoard.SetAsHandle(AClipboardFormat, hMem);
      end;
    end;
  finally
    ClipBoard.Close;
  end;
end;

procedure StreamFromClipboard(AClipboardFormat: Word; AStream: TMemoryStream);
var
  hMem: THandle;
  pMem: Pointer;
  ASize: Integer;
begin
  ClipBoard.Open;
  try
    hMem := Clipboard.GetAsHandle(AClipboardFormat);
    pMem := GlobalLock(hMem);
    if pMem <> nil then
    begin
      ASize := GlobalSize(hMem);
      AStream.Clear;
      AStream.SetSize(ASize);
      MoveMemory(AStream.Memory, pMem, ASize);
      GlobalUnlock(hMem);
    end;
  finally
    ClipBoard.Close;
  end;
end;

function GetBorderPartSize(ASize: Integer; ASide: TvgrBorderSide): Integer;
begin
  if ASize = 0 then
    Result := 0
  else
    case ASide of
      vgrbsLeft: Result := (ASize - 1) div 2{ASize div 2};
      vgrbsTop: Result := (ASize - 1) div 2{ASize div 2};
      vgrbsRight: Result := 1 + ASize div 2{(ASize + 1) div 2};
    else {vgrbsBottom}
      Result := 1 + ASize div 2{(ASize + 1) div 2};
    end;
end;


function ConvertTwipsToPixelsX(Twips : integer) : integer;
begin
  Result := Round(ScreenPixelsPerInchX/TwipsPerInch*Twips);
end;

function ConvertTwipsToPixelsY(Twips : integer) : integer;
begin
  Result := Round(ScreenPixelsPerInchY/TwipsPerInch*Twips);
end;

function ConvertTwipsToPixelsX(Twips: integer; PixelsPerX: Integer): integer;
begin
  Result := Round(PixelsPerX/TwipsPerInch*Twips);
end;

function ConvertTwipsToPixelsY(Twips: integer; PixelsPerY: Integer): integer;
begin
  Result := Round(PixelsPerY/TwipsPerInch*Twips);
end;

function ConvertPixelsToTwipsX(Pixels: integer) : integer;
begin
  Result := Round(TwipsPerInch/ScreenPixelsPerInchX*Pixels);
end;

function ConvertPixelsToTwipsY(Pixels: integer) : integer;
begin
  Result := Round(TwipsPerInch/ScreenPixelsPerInchY*Pixels);
end;

function ConvertPixelsToTwipsX(Pixels: integer; PixelsPerX: Integer): integer;
begin
  Result := Round(TwipsPerInch/PixelsPerX*Pixels);
end;

function ConvertPixelsToTwipsY(Pixels: integer; PixelsPerY: Integer): integer;
begin
  Result := Round(TwipsPerInch/PixelsPerY*Pixels);
end;

function ConvertUnitsToTwips(AValue: Extended; AUnits: TvgrUnits): Integer;
begin
  case AUnits of
    vgruMms: Result := Round(TwipsPerMMs * AValue);
    vgruCentimeters: Result := Round(TwipsPerMMs * 10 * AValue);
    vgruInches: Result := Round(TwipsPerInch * AValue);
    vgruTenthsMMs: Result := Round(TwipsPerMMs * AValue / 10);
  else
    Result := ConvertPixelsToTwipsX(Round(AValue));
  end;
end;

function ConvertTwipsToUnits(ATwips: Integer; AUnits: TvgrUnits): Extended;
begin
  case AUnits of
    vgruMms: Result := ATwips / TwipsPerMMs;
    vgruCentimeters: Result := ATwips / TwipsPerMMs / 10;
    vgruInches: Result := ATwips / TwipsPerInch;
    vgruTenthsMMs: Result := ATwips / TwipsPerMMs * 10;
  else
    Result := ConvertTwipsToPixelsX(ATwips);
  end;
end;

function ConvertTwipsToUnitsStr(ATwips: Integer; AUnits: TvgrUnits): string;
const
  AFormats: Array[TvgrUnits] of string = ('0.0', '0.00', '0.00', '0', '0');
begin
  Result := FormatFloat(AFormats[AUnits], ConvertTwipsToUnits(ATwips, AUnits))
end;

function sp(Item1, Item2: Pointer): Integer;
begin
  Result := Integer(Item1) - Integer(Item2);
end;

function CheckPageList(const S: string): Boolean;
var
  L: TList;
begin
  L := TList.Create;
  try
    Result := TextToPageList(S, L);
  finally
    L.Free;
  end;
end;

function TextToPageList(const S: string; APagesList: TList): Boolean;
var
  I, J, L, N1, N2: Integer;
begin
  APagesList.Clear;
  Result := Trim(s) = '';
  if not Result then
  begin
    Result := false;
    N2 := -1;
    N1 := -1;
    L := Length(S);
    I := 1;
    while I <= L do
      begin
        case S[i] of
          '-':
            begin
              if (N2 = -1) or (N1 <> -1) then exit;
              N1 := N2;
            end;
          ',':
            begin
              if (N1 <> -1) and (N2 <> -1) then
                for J := N1 to N2 do
                  APagesList.Add(pointer(J))
              else
                if n2 <> -1 then
                  APagesList.Add(pointer(N2))
                else
                  exit;
              N1 := -1;
              N2 := -1;
            end;
          '0'..'9':
            begin
              J := I;
              while (I <= L) and (S[i] in ['0'..'9']) do Inc(I);
              N2 := StrToInt(Copy(S, J, I - J));
              Dec(I);
            end;
          else
            exit;
        end;
        Inc(I);
      end;
      
    if (N1 <> -1) and (N2 <> -1) then
      for J := N1 to N2 do
        APagesList.Add(pointer(J))
    else
      if n2 <> -1 then
        APagesList.Add(pointer(N2))
      else
        exit;
    APagesList.Sort(sp);
    Result := True;
  end;
end;

procedure DbgFileWriteString(const AFileName: string; const S: string);
var
  AHandle: THandle;
  ABytes: Cardinal;
begin
  AHandle := CreateFile(PChar(AFileName),
                        GENERIC_WRITE,
                        FILE_SHARE_WRITE or FILE_SHARE_READ,
                        nil,
                        OPEN_ALWAYS,
                        0, 0);
  if AHandle <> INVALID_HANDLE_VALUE then
  begin
    SetFilePointer(AHandle, 0, nil, FILE_END); 
    WriteFile(AHandle, S[1], Length(S), ABytes, nil);
    CloseHandle(AHandle);
  end;
end;

procedure DbgFileWriteString(const S: string);
begin
  DbgFileWriteString(DbgFileFileName, S);
end;

procedure DbgFileRect(const ADescRect: string; const ARect: TRect);
begin
  with ARect do
    DbgFileWriteString(Format('%s= (%d, %d, %d, %d)', [ADescRect, Left, Top, Right, Bottom]));
end;

procedure DbgFileStr(const s: string);
begin
  DbgFileWriteString(S);
end;

procedure DbgFileStrFmt(const AMask: string; AParams: array of const);
begin
  DbgFileWriteString(Format(AMask, AParams));
end;

procedure DbgRect(const ADescRect: string; const ARect: TRect);
begin
  with ARect do
    OutputDebugString(PChar(Format('%s= (%d, %d, %d, %d)', [ADescRect, Left, Top, Right, Bottom])));
end;

procedure DbgStr(const s: string);
begin
  OutputDebugString(PChar(s));
end;

procedure DbgStrFmt(const AMask: string; AParams: array of const);
begin
  OutputDebugString(PChar(Format(AMask, AParams)));
end;

var
  ADC: HDC;

initialization

  ADC := GetDC(0);
  ScreenPixelsPerInchX := GetDeviceCaps(ADC, LOGPIXELSX);
  ScreenPixelsPerInchY := GetDeviceCaps(ADC, LOGPIXELSY);
  ReleaseDC(0, ADC);

end.
