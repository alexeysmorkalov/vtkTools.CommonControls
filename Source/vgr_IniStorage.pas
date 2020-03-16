unit vgr_IniStorage;

{$I vtk.inc}

interface

uses
  Windows, Classes, SysUtils, IniFiles, Registry;

type
  {low-level wrapper for the system registry and functions that operate on the registry}
  TRegistryAccess = class(TRegistry)
  end;

  /////////////////////////////////////////////////
  //
  // TvgrIniStorage
  //
  /////////////////////////////////////////////////
  { TvgrIniStorage is the base class for objects that represent ini storages.
    TvgrIniStorage contains abstract or, in C++ terminology, pure virtual methods
    and should not be directly instantiated. }
  TvgrIniStorage = class(TObject)
  private
    FPath: string;
  protected
    procedure InternalInit; virtual; abstract;
  public
    { Creates a TvgrIniStorage object for an application.
Parameters:
  APath identifies file name of ini file for TvgrIniFileStorage or
registry path relative to HKEY_CURRENT_USER for TvgrRegistryStorage. }
    constructor Create(const APath: string);

    { Call ReadString to read a string value from an INI file.
Parameters:
  ASection identifies the section in the file that contains the desired key.
  AIdent is the name of the key from which to retrieve the value.
  ADefault is the string value to return if the:
<br>Section does not exist.
<br>Key does not exist.
<br>Data value for the key is not assigned.
Return value:
  string value}
    function ReadString(const ASection, AIdent, ADefault: string): string; virtual; abstract;
    { Call ReadInteger to read an integer value from an ini file.
Parameters:
  ASection identifies the section in the file that contains the desired key.
  AIdent is the name of the key from which to retrieve the value.
  ADefault is the integer value to return if the:      
<br>             Section does not exist.
<br>             Key does not exist.
<br>             Data value for the key is not assigned.
Return value:
  integer value}
    function ReadInteger(const ASection, AIdent: string; ADefault: Integer): Integer; virtual; abstract;
    { Call ReadBool to read a Boolean value from an ini file.
Parameters:
  ASection identifies the section in the file that contains the desired key.
  AIdent is the name of the key from which to retrieve the Boolean value.
  ADefault is the Boolean value to return if the:
<br>Section does not exist.
<br>Key does not exist.
<br>Data value for the key is not assigned.
Return value:
  Boolean value}
    function ReadBool(const ASection, AIdent: string; ADefault: Boolean): Boolean; virtual; abstract;
    { Call ReadStrings to read TStrings.Items values from an ini file.
      Count of items reads from APrefix + '_Count' key.
      Each item reads from APrefix + IntToStr(ItemIndex) key.
Parameters:
  ASection - string
  APrefix - string
  AStrings - TStrings}
    procedure ReadStrings(const ASection, APrefix: string; AStrings: TStrings);

    { Call WriteString to write a string value to an ini file.
Parameters:
      ASection identifies the section in the file that contain the key to which to write.
      AIdent is the name of the key for which to set a value.
      AValue is the string value to write. }
    procedure WriteString(const ASection, AIdent, AValue: string); virtual; abstract;
    { Call WriteInteger to write a integer value to an ini file.
Parameters:
      ASection identifies the section in the file that contain the key to which to write.
      AIdent is the name of the key for which to set a value.
      AValue is the integer value to write. }
    procedure WriteInteger(const ASection, AIdent: string; AValue: Integer); virtual; abstract;
    { Call WriteBool to write a boolean value to an ini file.
Parameters:
      ASection identifies the section in the file that contain the key to which to write.
      AIdent is the name of the key for which to set a value.
      AValue is the boolean value to write. }
    procedure WriteBool(const ASection, AIdent: string; AValue: Boolean); virtual; abstract;
    { Call WriteStrings to write a TStrings.Items to an ini file.
Parameters:
      ASection identifies the section in the file that contain the key to which to write.
      AStrings is the reference to stored TStrings object.
      APrefix Count of items stored to APrefix + '_Count' key,
Each item stored to APrefix + IntToStr(ItemIndex) key. }
    procedure WriteStrings(const ASection, APrefix: string; AStrings: TStrings);

    { Call EraseSection to remove a section, all its keys,
      and their data values from an ini file.
Parameters:
  ASection identifies the ini file section to remove. If
a section cannot be removed, an exception is raised. }
    procedure EraseSection(const ASection: string); virtual; abstract;
    { Use SectionExists to determine whether a section exists within the ini file specified
      in FileName.
Parameters:
  ASection is the ini file section SectionExists determines the existence of.
Return value:
  Boolean. SectionExists returns a Boolean value that indicates whether the section in question exists. }
    function SectionExists(const ASection: string): Boolean; virtual; abstract;
    { Use ValueExists to determine whether a key exists in the ini file specified in FileName.
Parameters:
      ASection is the section in the ini file in which to search for the key.
      AIdent is the name of the key to search for.
Return value:
      ValueExists returns a boolean value that indicates whether the key exists
      in the specified section. }
    function ValueExists(const ASection, AIdent: string): Boolean; virtual; abstract;

    { Path identifies file name of ini file for TvgrIniFileStorage or
      registry path relative to HKEY_CURRENT_USER for TvgrRegistryStorage.
      This property initializated in constructor. }
    property Path: string read FPath;
  end;

  /////////////////////////////////////////////////
  //
  // TvgrIniFileStorage
  //
  /////////////////////////////////////////////////
  TvgrIniFileStorage = class(TvgrIniStorage)
  protected
    FIniFile: TIniFile;
    procedure InternalInit; override;
  public
    destructor Destroy; override;
    
    function ReadString(const ASection, AIdent, ADefault: string): string; override;
    function ReadInteger(const ASection, AIdent: string; ADefault: Integer): Integer; override;
    function ReadBool(const ASection, AIdent: string; ADefault: Boolean): Boolean; override;

    procedure WriteString(const ASection, AIdent, AValue: string); override;
    procedure WriteInteger(const ASection, AIdent: string; AValue: Integer); override;
    procedure WriteBool(const ASection, AIdent: string; AValue: Boolean); override;

    procedure EraseSection(const ASection: string); override;
    function SectionExists(const ASection: string): Boolean; override;
    function ValueExists(const ASection, AIdent: string): Boolean; override;

    { Reference to internal TIniFile object. }
    property IniFile: TIniFile read FIniFile;
  end;

  /////////////////////////////////////////////////
  //
  // TvgrRegistryStorage
  //
  /////////////////////////////////////////////////
  TvgrRegistryStorage = class(TvgrIniStorage)
  private
    FRegistry: TRegIniFile;
  protected
    procedure InternalInit; override;
  public
    destructor Destroy; override;
    
    function ReadString(const ASection, AIdent, ADefault: string): string; override;
    function ReadInteger(const ASection, AIdent: string; ADefault: Integer): Integer; override;
    function ReadBool(const ASection, AIdent: string; ADefault: Boolean): Boolean; override;

    procedure WriteString(const ASection, AIdent, AValue: string); override;
    procedure WriteInteger(const ASection, AIdent: string; AValue: Integer); override;
    procedure WriteBool(const ASection, AIdent: string; AValue: Boolean); override;

    procedure EraseSection(const ASection: string); override;
    function SectionExists(const ASection: string): Boolean; override;
    function ValueExists(const ASection, AIdent: string): Boolean; override;

    { Reference to internal TRegIniFile object. }
    property Registry: TRegIniFile read FRegistry;
  end;

implementation

uses
  vgr_Functions;
  
/////////////////////////////////////////////////
//
// TvgrIniStorage
//
/////////////////////////////////////////////////
constructor TvgrIniStorage.Create(const APath: string);
begin
  inherited Create;
  FPath := APath;
  InternalInit;
end;

procedure TvgrIniStorage.ReadStrings(const ASection, APrefix: string; AStrings: TStrings);
var
  I, N: Integer;
begin
  if ValueExists(ASection, APrefix + '_Count') then
  begin
    AStrings.Clear;
    N := ReadInteger(ASection, APrefix + '_Count', 0);
    for I := 0 to N - 1 do
      AStrings.Add(ReadString(ASection, APrefix + IntToStr(I), ''));
  end;
end;

procedure TvgrIniStorage.WriteStrings(const ASection, APrefix: string; AStrings: TStrings);
var
  I: Integer;
begin
  WriteInteger(ASection, APrefix + '_Count', AStrings.Count);
  for I := 0 to AStrings.Count - 1 do
    WriteString(ASection, APrefix + IntToStr(I), AStrings[I]);
end;

/////////////////////////////////////////////////
//
// TvgrIniFileStorage
//
/////////////////////////////////////////////////
destructor TvgrIniFileStorage.Destroy;
begin
  FreeAndNil(FIniFile);
  inherited;
end;

procedure TvgrIniFileStorage.InternalInit;
begin
  FIniFile := TIniFile.Create(Path);
end;

function TvgrIniFileStorage.ReadString(const ASection, AIdent, ADefault: string): string;
begin
  Result := IniFile.ReadString(ASection, AIdent, ADefault);
end;

function TvgrIniFileStorage.ReadInteger(const ASection, AIdent: string; ADefault: Integer): Integer;
begin
  Result := IniFile.ReadInteger(ASection, AIdent, ADefault);
end;

function TvgrIniFileStorage.ReadBool(const ASection, AIdent: string; ADefault: Boolean): Boolean;
begin
  Result := IniFile.ReadBool(ASection, AIdent, ADefault);
end;

procedure TvgrIniFileStorage.WriteString(const ASection, AIdent, AValue: string);
begin
  IniFile.WriteString(ASection, AIdent, AValue);
end;

procedure TvgrIniFileStorage.WriteInteger(const ASection, AIdent: string; AValue: Integer);
begin
  IniFile.WriteInteger(ASection, AIdent, AValue);
end;

procedure TvgrIniFileStorage.WriteBool(const ASection, AIdent: string; AValue: Boolean); 
begin
  IniFile.WriteBool(ASection, AIdent, AValue);
end;

procedure TvgrIniFileStorage.EraseSection(const ASection: string);
begin
  IniFile.EraseSection(ASection);
end;

function TvgrIniFileStorage.SectionExists(const ASection: string): Boolean;
begin
  Result := IniFile.SectionExists(ASection);
end;

function TvgrIniFileStorage.ValueExists(const ASection, AIdent: string): Boolean;
begin
  Result := IniFile.ValueExists(ASection, AIdent);
end;

/////////////////////////////////////////////////
//
// TvgrRegistryStorage
//
/////////////////////////////////////////////////
destructor TvgrRegistryStorage.Destroy;
begin
  if FRegistry <> nil then
    FreeAndNil(FRegistry);
  inherited;
end;

procedure TvgrRegistryStorage.InternalInit;
begin
  FRegistry := TRegIniFile.Create(Path);
end;

function TvgrRegistryStorage.ReadString(const ASection, AIdent, ADefault: string): string;
begin
  Result := Registry.ReadString(ASection, AIdent, ADefault);
end;

function TvgrRegistryStorage.ReadInteger(const ASection, AIdent: string; ADefault: Integer): Integer;
begin
  Result := Registry.ReadInteger(ASection, AIdent, ADefault);
end;

function TvgrRegistryStorage.ReadBool(const ASection, AIdent: string; ADefault: Boolean): Boolean;
begin
  Result := Registry.ReadBool(ASection, AIdent, ADefault);
end;

procedure TvgrRegistryStorage.WriteString(const ASection, AIdent, AValue: string);
begin
  Registry.WriteString(ASection, AIdent, AValue);
end;

procedure TvgrRegistryStorage.WriteInteger(const ASection, AIdent: string; AValue: Integer);
begin
  Registry.WriteInteger(ASection, AIdent, AValue);
end;

procedure TvgrRegistryStorage.WriteBool(const ASection, AIdent: string; AValue: Boolean);
begin
  Registry.WriteBool(ASection, AIdent, AValue);
end;

procedure TvgrRegistryStorage.EraseSection(const ASection: string);
begin
  Registry.EraseSection(ASection);
end;

function TvgrRegistryStorage.SectionExists(const ASection: string): Boolean;
begin
  Result := Registry.KeyExists(ASection);
end;

function TvgrRegistryStorage.ValueExists(const ASection, AIdent: string): Boolean;
var
  Key, OldKey: HKEY;
begin
  Key := TRegistryAccess(Registry).GetKey(ASection);
  Result := Key <> 0;
  if Result then
    try
      OldKey := Registry.CurrentKey;
      TRegistryAccess(Registry).SetCurrentKey(Key);
      try
        Result := Registry.ValueExists(AIdent);
      finally
        TRegistryAccess(Registry).SetCurrentKey(OldKey);
      end;
    finally
      RegCloseKey(Key);
    end
end;

end.
