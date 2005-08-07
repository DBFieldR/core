/*
 * $Id: c_slider.c,v 1.1 2005-08-07 00:04:19 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C slider functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <shlobj.h>

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

HB_FUNC ( INITSLIDER )
{
	HWND hwnd;
	HWND hbutton;

	int Style = WS_CHILD ;

	INITCOMMONCONTROLSEX  i;
	i.dwSize = sizeof(INITCOMMONCONTROLSEX);
	i.dwICC = ICC_DATE_CLASSES;
	InitCommonControlsEx(&i);

	hwnd = (HWND) hb_parnl (1);

	if ( !hb_parl (10) )
	{
		Style = Style | TBS_AUTOTICKS ;
	}

	if ( hb_parl (10) )
	{
		Style = Style | TBS_NOTICKS ;
	}

	if ( hb_parl (9) )
	{
		Style = Style | TBS_VERT ;
	}

	if ( hb_parl (11) )
	{
		Style = Style | TBS_BOTH ;
	}

	if ( hb_parl (12) )
	{
		Style = Style | TBS_TOP ;
	}

	if ( hb_parl (13) )
	{
		Style = Style | TBS_LEFT ;
	}

	if ( !hb_parl (14) )
	{
		Style = Style | WS_VISIBLE ;
	}

	if ( !hb_parl (15) )
	{
		Style = Style | WS_TABSTOP ;
	}

	hbutton = CreateWindow(TRACKBAR_CLASS ,0,
	Style ,
	hb_parni(3), hb_parni(4) ,hb_parni(5) ,hb_parni(6) ,
	hwnd,(HMENU)hb_parni(2) , GetModuleHandle(NULL) , NULL ) ;

	SendMessage( hbutton, TBM_SETRANGE, TRUE, MAKELONG(hb_parni(7),hb_parni(8)));

	hb_retnl ( (LONG) hbutton );
}

HB_FUNC ( SETSLIDERRANGE )
{
	SendMessage( (HWND) hb_parnl (1), TBM_SETRANGE, TRUE, MAKELONG(hb_parni(2),hb_parni(3)));
}
