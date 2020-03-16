{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2003 by vtkTools      }
{                                          }
{******************************************}
{Registers the components and determine where to install them on the Component palette}
unit vgr_ControlsReg;

{$I vtk.inc}

interface

uses
  Classes,

  vgr_ColorButton, vgr_FontComboBox,
  vgr_ControlBar, vgr_Label, vgr_MultiPageButton;

procedure Register;

implementation

{$R *.res}

procedure Register;
begin
  RegisterComponents('vtkTools CommonControls', [TvgrColorButton,
                                      TvgrFontComboBox,
                                      TvgrControlBar,
                                      TvgrControlBarManager,
                                      TvgrBevelLabel,
                                      TvgrMultiPageButton]);
end;

end.
