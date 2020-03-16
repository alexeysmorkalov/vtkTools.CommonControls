{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2003 by vtkTools      }
{                                          }
{******************************************}

{Constants used in the GridReport library.}
unit vgr_Consts;

interface

const
{Millimeters per inch}
  MillimetersPerInch = 25.4;
{Twips Per Inch}
  TwipsPerInch = 1440;
{TwipsPerInch / MillimetersPerInch}
  TwipsPerMMs = TwipsPerInch / MillimetersPerInch;
{Default row height in points}
  cXLSDefaultRowHeightPoints = $00FF;
{Average char width of Arial, 10 font}
  cXLSAveCharWidthPixels = 8;
{Default column width in chars}
  cXLSDefaultColumnWidthInChars = 8;

{Default column width (TvgrCol.Width) in twips.}
  cDefaultColWidthTwips = (cXLSDefaultColumnWidthInChars * cXLSAveCharWidthPixels *  TwipsPerInch) div 96;
{Default row height (TvgrRow.Height) in twips.}
  cDefaultRowHeightTwips = (cXLSDefaultRowHeightPoints * TwipsPerInch) div (72 * 20);

{Twips per centimeter.}
  cTwipsPerCm = 567; // 1440 / 25.4 * 10

{Width in 1/10 mm of A4 paper}
  A4_PaperWidth = 2100;
{Height in 1/10 mm of A4 paper}
  A4_PaperHeight = 2970;
  
implementation

end.
