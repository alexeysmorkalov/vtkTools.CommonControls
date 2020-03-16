//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("vgr_CommonControlsBCB5.res");
USEPACKAGE("vcl50.bpi");
USEFORMNS("vgr_ColorButton.pas", Vgr_colorbutton, vgrColorPaletteForm);
USEUNIT("vgr_Consts.pas");
USEUNIT("vgr_ControlBar.pas");
USEUNIT("vgr_FontComboBox.pas");
USEUNIT("vgr_Functions.pas");
USEUNIT("vgr_GUIFunctions.pas");
USEUNIT("vgr_IniStorage.pas");
USEUNIT("vgr_Label.pas");
USEFORMNS("vgr_MultiPageButton.pas", Vgr_multipagebutton, vgrMultiPagePaletteForm);
USEUNIT("vgr_Button.pas");
USEUNIT("vgr_Barcode.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
