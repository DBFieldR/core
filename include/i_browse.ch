/*
 * $Id: i_browse.ch,v 1.8 2005-10-22 06:04:31 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Browse definitions
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

#define BROWSE_JTFY_LEFT                0
#define BROWSE_JTFY_RIGHT       	1
#define BROWSE_JTFY_CENTER      	2
#define BROWSE_JTFY_JUSTIFYMASK 	3

#translate MemVar . <AreaName> . <FieldName> =>  MemVar<AreaName><FieldName>
///////////////////////////////////////////////////////////////////////////////
// STANDARD BROWSE
///////////////////////////////////////////////////////////////////////////////

#command @ <row>,<col> BROWSE <name> 		;
		[ OF <parent> ] 		;
                [ OBJ <oObj> ]                  ;
		[ WIDTH <w> ] 			;
		[ HEIGHT <h> ] 			;
		[ HEADERS <headers> ] 		;
		[ WIDTHS <widths> ] 		;
                [ WORKAREA <workarea> ]         ;
		[ FIELDS <Fields> ] 		;
                [ INPUTMASK <Picture> ]         ;
		[ VALUE <value> ] 		;
		[ FONT <fontname> ] 		;
		[ SIZE <fontsize> ] 		;
                [ <bold : BOLD> ]               ;
                [ <italic : ITALIC> ]           ;
                [ <underline : UNDERLINE> ]     ;
                [ <strikeout : STRIKEOUT> ]     ;
		[ TOOLTIP <tooltip> ]  		;
                [ BACKCOLOR <backcolor> ]       ;
                [ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
		[ DYNAMICFORECOLOR <dynamicforecolor> ] ;
                [ FONTCOLOR <fontcolor> ]       ;
		[ ON GOTFOCUS <gotfocus> ] 	;
		[ ON CHANGE <change> ]  	;
		[ ON LOSTFOCUS <lostfocus> ] 	;
		[ ON DBLCLICK <dblclick> ]  	;
		[ <edit : EDIT> ] 		;
		[ <inplace : INPLACE> ]		;
		[ <append : APPEND> ] 		;
		[ ON HEADCLICK <aHeadClick> ] 	;
                [ WHEN <aWhenFields> ]          ;
                [ VALID <aValidFields> ]        ;
		[ VALIDMESSAGES <aValidMessages> ] ;
		[ READONLY <aReadOnly> ] 	;
		[ <lock: LOCK> ] 		;
		[ <Delete: DELETE> ]		;
                [ <style: NOLINES> ]            ;
                [ IMAGE <aImage> ]              ;
                [ JUSTIFY <aJust> ]             ;
		[ <novscroll: NOVSCROLL> ] 	;
		[ HELPID <helpid> ] 		;
		[ <break: BREAK> ] 		;
                [ <rtl: RTL> ]                  ;
                [ ON APPEND <onappend> ]        ;
                [ ON EDITCELL <editcell> ]      ;
                [ COLUMNCONTROLS <editcontrols> ] ;
                [ REPLACEFIELD <replacefields> ] ;
	=>;
[ <oObj> := ] TBrowse():Define( ;
                <(name)> ,      ;
                <(parent)> ,    ;
		<col> ,		;
		<row> ,		;
		<w> , 		;
		<h> , 		;
		<headers> , 	;
		<widths> , 	;
		<Fields> , 	;
		<value> ,	;
		<fontname> , 	;
		<fontsize> , 	;
		<tooltip> , 	;
		<{change}> ,	;
		<{dblclick}> ,  ;
		<aHeadClick> ,  ;
		<{gotfocus}> ,	;
		<{lostfocus}>, 	;
                <(workarea)> ,  ;
		<.Delete.>,  	;
		<.style.> ,	;
		<aImage> ,	;
		<aJust> , ;
		<helpid>  , ;
		<.bold.> , ;
		<.italic.> , ;
		<.underline.> , ;
		<.strikeout.> , ;
		<.break.>  , ;
		<backcolor> , ;
		<fontcolor> , ;
		<.lock.>  , ;
		<.inplace.> , ;
		<.novscroll.> , ;
		<.append.> , ;
		<aReadOnly> , ;
		<{aValidFields}> , ;
		<aValidMessages> , ;
                <.edit.> , ;
                <dynamicbackcolor> , ;
                <aWhenFields> , ;
                <dynamicforecolor>, ;
                <Picture>, ;
                <.rtl.>, ;
                <{onappend}>, ;
                <{editcell}>, ;
                <editcontrols>, ;
                <replacefields> )

///////////////////////////////////////////////////////////////////////////////
// SPLITBOX BROWSE
///////////////////////////////////////////////////////////////////////////////
#command BROWSE <name> 		;
		[ OF <parent> ] 		;
                [ OBJ <oObj> ]                  ;
		[ WIDTH <w> ] 			;
		[ HEIGHT <h> ] 			;
		[ HEADERS <headers> ] 		;
		[ WIDTHS <widths> ] 		;
		[ WORKAREA <WorkArea> ]		;
		[ FIELDS <Fields> ] 		;
                [ INPUTMASK <Picture> ]         ;
		[ VALUE <value> ] 		;
		[ FONT <fontname> ] 		;
		[ SIZE <fontsize> ] 		;
                [ <bold : BOLD> ]               ;
                [ <italic : ITALIC> ]           ;
                [ <underline : UNDERLINE> ]     ;
                [ <strikeout : STRIKEOUT> ]     ;
		[ TOOLTIP <tooltip> ]  		;
                [ BACKCOLOR <backcolor> ]       ;
                [ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
		[ DYNAMICFORECOLOR <dynamicforecolor> ] ;
                [ FONTCOLOR <fontcolor> ]       ;
		[ ON GOTFOCUS <gotfocus> ] 	;
		[ ON CHANGE <change> ]  	;
		[ ON LOSTFOCUS <lostfocus> ] 	;
		[ ON DBLCLICK <dblclick> ]  	;
		[ <edit : EDIT> ] 		;
		[ <inplace : INPLACE> ]		;
		[ <append : APPEND> ] 		;
		[ ON HEADCLICK <aHeadClick> ] 	;
                [ WHEN <aWhenFields> ]          ;
		[ VALID <aValidFields> ]	;
		[ VALIDMESSAGES <aValidMessages> ] ;
		[ READONLY <aReadOnly> ] 	;
		[ <lock: LOCK> ] 		;
		[ <Delete: DELETE> ]		;
                [ <style: NOLINES> ]            ;
                [ IMAGE <aImage> ]              ;
                [ JUSTIFY <aJust> ]             ;
		[ <novscroll: NOVSCROLL> ] 	;
		[ HELPID <helpid> ] 		;
		[ <break: BREAK> ] 		;
                [ <rtl: RTL> ]                  ;
                [ ON APPEND <onappend> ]        ;
                [ ON EDITCELL <editcell> ]      ;
                [ COLUMNCONTROLS <editcontrols> ] ;
                [ REPLACEFIELD <replacefields> ] ;
	=>;
[ <oObj> := ] TBrowse():Define( ;
                <(name)> ,      ;
                <(parent)> ,    ;
		 ,		;
		 ,		;
		<w> , 		;
		<h> , 		;
		<headers> , 	;
		<widths> , 	;
		<Fields> , 	;
		<value> ,	;
		<fontname> , 	;
		<fontsize> , 	;
		<tooltip> , 	;
		<{change}> ,	;
		<{dblclick}> ,  ;
		<{aHeadClick}> ,;
		<{gotfocus}> ,	;
		<{lostfocus}>, 	;
                <(WorkArea)> ,  ;
		<.Delete.>,  	;
		<.style.> ,	;
		<aImage> ,	;
		<aJust> , ;
		<helpid>  , ;
		<.bold.> , ;
		<.italic.> , ;
		<.underline.> , ;
		<.strikeout.> , ;
		<.break.>  , ;
		<backcolor> , ;
		<fontcolor> , ;
		<.lock.> , ;
		<.inplace.> , ;
		<.novscroll.> , ;
		<.append.> , ;
		<aReadOnly> , ;
		 <{aValidFields}> , ;
		<aValidMessages> , ;
                <.edit.>  , ;
                <dynamicbackcolor> , ;
                <aWhenFields> , ;
                <dynamicforecolor>, ;
                <Picture>, ;
                <.rtl.>, ;
                <{onappend}>, ;
                <{editcell}>, ;
                <editcontrols>, ;
                <replacefields> )

#command SET BROWSESYNC ON  => SetBrowseSync( .T. )
#command SET BROWSESYNC OFF => SetBrowseSync( .F. )