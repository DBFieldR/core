/*
 * $Id: h_browse.prg,v 1.53 2006-08-09 02:02:15 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG browse functions
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

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

STATIC _OOHG_BrowseSyncStatus := .F.

CLASS TBrowse FROM TXBrowse
   DATA Type            INIT "BROWSE" READONLY
   DATA aRecMap         INIT {}
   DATA RecCount        INIT 0
   DATA lEof            INIT .F.

   METHOD Define
   METHOD Refresh
   METHOD Value               SETGET
   METHOD RefreshData

   METHOD Events_Enter
   METHOD Events_Notify

   METHOD EditCell
   METHOD EditItem_B

   METHOD BrowseOnChange
   METHOD FastUpdate
   METHOD ScrollUpdate
   METHOD SetValue
   METHOD Delete
   METHOD UpDate

   METHOD Home
   METHOD End
   METHOD PageUp
   METHOD PageDown
   METHOD Up
   METHOD Down
   MESSAGE GoTop    METHOD Home
   MESSAGE GoBottom METHOD End
   METHOD SetScrollPos
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aHeaders, aWidths, ;
               aFields, value, fontname, fontsize, tooltip, change, ;
               dblclick, aHeadClick, gotfocus, lostfocus, WorkArea, ;
               AllowDelete, nogrid, aImage, aJust, HelpId, bold, italic, ;
               underline, strikeout, break, backcolor, fontcolor, lock, ;
               inplace, novscroll, AllowAppend, readonly, valid, ;
               validmessages, edit, dynamicbackcolor, aWhenFields, ;
               dynamicforecolor, aPicture, lRtl, onappend, editcell, ;
               editcontrols, replacefields ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local nWidth2, nCol2, oScroll

   IF ! ValType( WorkArea ) $ "CM" .OR. Empty( WorkArea )
      WorkArea := ALIAS()
   ENDIF
   if valtype( aFields ) != "A"
      aFields := ( WorkArea )->( DBSTRUCT() )
      AEVAL( aFields, { |x,i| aFields[ i ] := WorkArea + "->" + x[ 1 ] } )
   endif

   if valtype( aHeaders ) != "A"
      aHeaders := Array( len( aFields ) )
   else
      aSize( aHeaders, len( aFields ) )
   endif
   aEval( aHeaders, { |x,i| aHeaders[ i ] := iif( ! ValType( x ) $ "CM", if( valtype( aFields[ i ] ) $ "CM", aFields[ i ], "" ), x ) } )

   // If splitboxed force no vertical scrollbar

   if valtype(x) != "N" .or. valtype(y) != "N"
      novscroll := .T.
   endif

   IF valtype( w ) != "N"
      w := 240
   ENDIF
   IF novscroll
      nWidth2 := w
   Else
      nWidth2 := w - GETVSCROLLBARWIDTH()
   ENDIF

   ::TGrid:Define( ControlName, ParentForm, x, y, nWidth2, h, aHeaders, aWidths, {}, nil, ;
                   fontname, fontsize, tooltip, , , aHeadClick, , , ;
                   nogrid, aImage, aJust, break, HelpId, bold, italic, underline, strikeout, nil, ;
                   nil, nil, edit, backcolor, fontcolor, dynamicbackcolor, dynamicforecolor, aPicture, ;
                   lRtl, InPlace, editcontrols, readonly, valid, validmessages, editcell, ;
                   aWhenFields )

   ::nWidth := w

   IF ValType( Value ) == "N"
      ::nValue := Value
   ENDIF
   ::Lock := Lock
   ::WorkArea := WorkArea
   ::AllowDelete := AllowDelete
   ::aFields := aFields
   ::aRecMap := {}
   ::AllowAppend := AllowAppend
   ::aReplaceField := replacefields

   if ! novscroll

      ::ScrollButton := TScrollButton():Define( , Self, nCol2, ::nHeight - GETHSCROLLBARHEIGHT(), GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() )

      oScroll := TScrollBar()
      oScroll:nWidth := GETVSCROLLBARWIDTH()
      oScroll:SetRange( 1, 100 )

      IF ::lRtl .AND. ! ::Parent:lRtl
         ::nCol := ::nCol + GETVSCROLLBARWIDTH()
         nCol2 := -GETVSCROLLBARWIDTH()
      Else
         nCol2 := nWidth2
      ENDIF
      oScroll:nCol := nCol2

      If IsWindowStyle( ::hWnd, WS_HSCROLL )
         oScroll:nRow := 0
         oScroll:nHeight := ::nHeight - GETHSCROLLBARHEIGHT()
      Else
         oScroll:nRow := 0
         oScroll:nHeight := ::nHeight
         ::ScrollButton:Visible := .F.
      EndIf

      oScroll:Define( , Self )
      ::VScroll := oScroll
      ::VScroll:OnLineUp   := { || ::SetFocus():Up() }
      ::VScroll:OnLineDown := { || ::SetFocus():Down() }
      ::VScroll:OnPageUp   := { || ::SetFocus():PageUp() }
      ::VScroll:OnPageDown := { || ::SetFocus():PageDown() }
      ::VScroll:OnThumb    := { |VScroll,Pos| ::SetFocus():SetScrollPos( Pos, VScroll ) }
// cambiar TOOLTIP si cambia el del BROWSE
// Cambiar HelpID si cambia el del BROWSE

      // It forces to hide "additional" controls when it's inside a
      // non-visible TAB page.
      ::Visible := ::Visible
   EndIf

   // Add to browselist array to update on window activation
   aAdd( ::Parent:BrowseList, Self )

   ::SizePos()

   // Must be set after control is initialized
   ::OnLostFocus := lostfocus
   ::OnGotFocus :=  gotfocus
   ::OnChange   :=  change
   ::OnDblClick := dblclick
   ::OnAppend := onappend

Return Self

*-----------------------------------------------------------------------------*
METHOD UpDate() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local PageLength , aTemp, _BrowseRecMap := {} , x
Local nCurrentLength
Local lColor, aFields, cWorkArea, hWnd, nWidth

   cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return nil
   EndIf

   lColor := ! ( Empty( ::DynamicForeColor ) .AND. Empty( ::DynamicBackColor ) )
   nWidth := LEN( ::aFields )
   aFields := ARRAY( nWidth )
   AEVAL( ::aFields, { |c,i| aFields[ i ] := ::ColumnBlock( i ), c } )
   hWnd := ::hWnd

   ::lEof := .F.

   PageLength := ListViewGetCountPerPage( hWnd )

   If lColor
      ::GridForeColor := ARRAY( PageLength )
      ::GridBackColor := ARRAY( PageLength )
   Else
      ::GridForeColor := nil
      ::GridBackColor := nil
   EndIf

   x := 0
   nCurrentLength := ::ItemCount()

   Do While x < PageLength .AND. ! ( cWorkArea )->( Eof() )

      x++

      aTemp := ARRAY( nWidth )

      AEVAL( aFields, { |b,i| aTemp[ i ] := EVAL( b ) } )

      If lColor
         ( cWorkArea )->( ::SetItemColor( x,,, aTemp ) )
      EndIf

      IF nCurrentLength < x
         AddListViewItems( hWnd, aTemp )
         nCurrentLength++
      Else
         ListViewSetItem( hWnd, aTemp, x )
      ENDIF

      aadd( _BrowseRecMap , ( cWorkArea )->( RecNo() ) )

      ( cWorkArea )->( DbSkip() )
   EndDo

   Do While nCurrentLength > Len( _BrowseRecMap )
      ListViewDeleteString( hWnd, nCurrentLength )
      nCurrentLength--
   EndDo

   IF ( cWorkArea )->( Eof() )
      ::lEof := .T.
   EndIf

   ::aRecMap := _BrowseRecMap

Return nil

*-----------------------------------------------------------------------------*
METHOD PageDown() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _RecNo , _DeltaScroll, s

   _DeltaScroll := ListView_GetSubItemRect( ::hWnd, 0 , 0 )

   s := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If  s >= Len( ::aRecMap )

      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
		EndIf

      if ::lEof
         If ::AllowAppend
            ::EditItem( .t. )
         Endif
         Return nil
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ( ::WorkArea )->( DbGoBottom() )
         ( ::WorkArea )->( DbSkip( - LISTVIEWGETCOUNTPERPAGE ( ::hWnd ) + 1 ) )
      Else
         ( ::WorkArea )->( DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] ) )
      EndIf
      ::Update()
      If Len( ::aRecMap ) == 0
         ( ::WorkArea )->( DbGoTo( 0 ) )
      Else
         ( ::WorkArea )->( DbGoTo( ::aRecMap[ Len( ::aRecMap ) ] ) )
      EndIf
      ::scrollUpdate()
      ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
      ListView_SetCursel ( ::hWnd, Len( ::aRecMap ) )
      ( ::WorkArea )->( DbGoTo( _RecNo ) )

	Else

      ::FastUpdate( LISTVIEWGETCOUNTPERPAGE( ::hWnd ) - s, Len( ::aRecMap ) )

	EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD PageUp() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _RecNo , _DeltaScroll

   _DeltaScroll := ListView_GetSubItemRect( ::hWnd, 0 , 0 )

   If LISTVIEW_GETFIRSTITEM( ::hWnd ) == 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
		EndIf
      _RecNo := ( ::WorkArea )->( RecNo() )
      If Len( ::aRecMap ) == 0
         ( ::WorkArea )->( DbGoTop() )
      Else
         ( ::WorkArea )->( DbGoTo( ::aRecMap[ 1 ] ) )
      EndIf
      ( ::WorkArea )->( DbSkip( - LISTVIEWGETCOUNTPERPAGE ( ::hWnd ) + 1 ) )
      ::scrollUpdate()
      ::Update()
      ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
      ( ::WorkArea )->( DbGoTo( _RecNo ) )
      ListView_SetCursel ( ::hWnd, 1 )

	Else

      ::FastUpdate( 1 - LISTVIEW_GETFIRSTITEM ( ::hWnd ), 1 )

	EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD Home() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _RecNo , _DeltaScroll

   _DeltaScroll := ListView_GetSubItemRect ( ::hWnd, 0 , 0 )

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return nil
	EndIf
   _RecNo := ( ::WorkArea )->( RecNo() )
   ( ::WorkArea )->( DbGoTop() )
   ::scrollUpdate()
   ::Update()
   ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
   ( ::WorkArea )->( DbGoTo( _RecNo ) )

   ListView_SetCursel ( ::hWnd, 1 )

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD End( lAppend ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _RecNo , _DeltaScroll , _BottomRec
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.

   _DeltaScroll := ListView_GetSubItemRect ( ::hWnd, 0 , 0 )

   If Select( ::WorkArea ) == 0
      ::RecCount := 0
      Return nil
	EndIf
   _RecNo := ( ::WorkArea )->( RecNo() )
   ( ::WorkArea )->( DbGoBottom() )
   _BottomRec := ( ::WorkArea )->( RecNo() )
   ::scrollUpdate()

   // If it's for APPEND, leaves a blank line ;)
   ( ::WorkArea )->( DbSkip( - ::CountPerPage + IF( lAppend, 2, 1 ) ) )
   ::Update()
   ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
   ( ::WorkArea )->( DbGoTo( _RecNo ) )

   ListView_SetCursel( ::hWnd, ascan ( ::aRecMap, _BottomRec ) )

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD Up() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local s  , _RecNo , _DeltaScroll := { Nil , Nil , Nil , Nil }

   _DeltaScroll := ListView_GetSubItemRect ( ::hWnd, 0 , 0 )

   s := LISTVIEW_GETFIRSTITEM ( ::hWnd )

   If s <= 1
      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
      EndIf
      _RecNo := ( ::WorkArea )->( RecNo() )
      If Len( ::aRecMap ) == 0
         ( ::WorkArea )->( DbGoTop() )
      Else
         ( ::WorkArea )->( DbGoTo( ::aRecMap[ 1 ] ) )
      EndIf
      ( ::WorkArea )->( DbSkip( -1 ) )
      ::scrollUpdate()
      ::Update()
      ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
      ( ::WorkArea )->( DbGoTo( _RecNo ) )
      If Len( ::aRecMap ) != 0
         ListView_SetCursel( ::hWnd, 1 )
      EndIf

	Else

      ::FastUpdate( -1, s - 1 )

	EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD Down() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local s , _RecNo , _DeltaScroll

   s := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If s >= Len( ::aRecMap )

      _DeltaScroll := ListView_GetSubItemRect( ::hWnd, 0 , 0 )

      If Select( ::WorkArea ) == 0
         ::RecCount := 0
         Return nil
      EndIf

      if ::lEof
         If ::AllowAppend
            ::EditItem( .t. )
         Endif
         Return nil
      EndIf

      _RecNo := ( ::WorkArea )->( RecNo() )

      If Len( ::aRecMap ) == 0
         ( ::WorkArea )->( DbGoTop() )
      Else
         ( ::WorkArea )->( DbGoTo( ::aRecMap[ 1 ] ) )
      EndIf
      ( ::WorkArea )->( DbSkip() )
      ::Update()
      If Len( ::aRecMap ) != 0
         ( ::WorkArea )->( DbGoTo( ATail( ::aRecMap ) ) )
         ListView_Scroll( ::hWnd, _DeltaScroll[2] * (-1) , 0 )
      EndIf
      ::scrollUpdate()
      ( ::WorkArea )->( DbGoTo( _RecNo ) )

      ListView_SetCursel( ::hWnd, Len( ::aRecMap ) )

	Else

      ::FastUpdate( 1, s + 1 )

	EndIf

   ::BrowseOnChange()

Return nil

*-----------------------------------------------------------------------------*
METHOD SetValue( Value, mp ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local _RecNo , NewPos := 50, _DeltaScroll , m , hWnd, cWorkArea

   cWorkArea := ::WorkArea

   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return nil
	EndIf

	If Value <= 0
      Return nil
	EndIf

   hWnd := ::hWnd

   If _OOHG_ThisEventType == 'BROWSE_ONCHANGE'
      If hWnd == _OOHG_ThisControl:hWnd
         MsgOOHGError( "BROWSE: Value property can't be changed inside ONCHANGE event. Program Terminated" )
		EndIf
	EndIf

   If Value > ( cWorkArea )->( RecCount() )
      ::nValue := 0
      ListViewReset( hWnd )
      ::BrowseOnChange()
      Return nil
	EndIf

   If valtype ( mp ) != "N"
      m := int( ListViewGetCountPerPage( hWnd ) / 2 )
	else
		m := mp
	endif

   _DeltaScroll := ListView_GetSubItemRect( hWnd, 0 , 0 )

   _RecNo := ( cWorkArea )->( RecNo() )

   ( cWorkArea )->( DbGoTo( Value ) )

   If ( cWorkArea )->( Eof() )
      ( cWorkArea )->( DbGoTo( _RecNo ) )
      Return nil
	EndIf

// Sin usar DBFILTER()
   ( cWorkArea )->( DBSkip() )
   ( cWorkArea )->( DBSkip( -1 ) )
   IF ( cWorkArea )->( RecNo() ) != Value
      ( cWorkArea )->( DbGoTo( _RecNo ) )
      Return nil
   ENDIF

   if pcount() < 2
      ::scrollUpdate()
   EndIf
   ( cWorkArea )->( DbSkip( -m + 1 ) )

   ::nValue := Value
   ::Update()
   ( cWorkArea )->( DbGoTo( _RecNo ) )

   ListView_Scroll( hWnd, _DeltaScroll[ 2 ] * ( -1 ) , 0 )
   ListView_SetCursel ( hWnd, ascan( ::aRecMap, Value ) )

   _OOHG_ThisEventType := 'BROWSE_ONCHANGE'
   ::BrowseOnChange()
   _OOHG_ThisEventType := ''

Return nil

*-----------------------------------------------------------------------------*
METHOD Delete() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local Value, nRecNo

   Value := ::Value

	If Value == 0
		Return Nil
	EndIf

   nRecNo := ( ::WorkArea )->( RecNo() )

   ( ::WorkArea )->( DbGoTo( Value ) )

   If ::Lock .AND. ! ( ::WorkArea )->( Rlock() )

      MsgStop('Record is being editied by another user. Retry later','Delete Record')

   Else

      ( ::WorkArea )->( DbDelete() )
      ( ::WorkArea )->( DbSkip() )
      if ( ::WorkArea )->( Eof() )
         ( ::WorkArea )->( DbGoBottom() )
      EndIf

      If Set( _SET_DELETED )
         ::SetValue( ( ::WorkArea )->( RecNo() ) , LISTVIEW_GETFIRSTITEM( ::hWnd ) )
		EndIf

	EndIf

   ( ::WorkArea )->( DbGoTo( nRecNo ) )

Return Nil

*-----------------------------------------------------------------------------*
METHOD EditItem_B( append ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local nOldRecNo, nItem, cWorkArea, lRet

   ASSIGN append VALUE append TYPE "L" DEFAULT .F.

   cWorkArea := ::WorkArea
   If Select( cWorkArea ) == 0
      ::RecCount := 0
      Return .F.
   EndIf

   nItem := LISTVIEW_GETFIRSTITEM( ::hWnd )

   If nItem == 0 .AND. ! append
      Return .F.
   EndIf

   nOldRecNo := ( cWorkArea )->( RecNo() )

   If ! append
      ( cWorkArea )->( DbGoTo( ::aRecMap[ nItem ] ) )
   EndIf

   lRet := ::Super:EditItem_B( append )

   If lRet .AND. append
      nOldRecNo := ( cWorkArea )->( RecNo() )
      ::Value := nOldRecNo
   EndIf

   ( cWorkArea )->( DbGoTo( nOldRecNo ) )

Return lRet

*-----------------------------------------------------------------------------*
METHOD EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local lRet, BackRec
   ASSIGN lAppend VALUE lAppend TYPE "L" DEFAULT .F.
   ASSIGN nRow    VALUE nRow    TYPE "N" DEFAULT ::CurrentRow
   If nRow < 1 .OR. nRow > ::ItemCount()
      // Cell out of range
      lRet := .F.
   ElseIf Select( ::WorkArea ) == 0
      // It the specified area does not exists, set recordcount to 0 and return
      ::RecCount := 0
      lRet := .F.
   Else
      BackRec := ( ::WorkArea )->( RecNo() )
      IF lAppend
         ( ::WorkArea )->( DbGoTo( 0 ) )
      Else
         ( ::WorkArea )->( DbGoTo( ::aRecMap[ nRow ] ) )
      EndIf
      lRet := ::Super:EditCell( nRow, nCol, EditControl, uOldValue, uValue, cMemVar, lAppend )
      If lRet .AND. lAppend
         AADD( ::aRecMap, ( ::WorkArea )->( RecNo() ) )
      EndIf
      ( ::WorkArea )->( DbGoTo( BackRec ) )
   Endif
Return lRet

#pragma BEGINDUMP
#define s_Super s_TGrid

#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"
extern int TGrid_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam );
#pragma ENDDUMP

*-----------------------------------------------------------------------------*
METHOD BrowseOnChange() CLASS TBrowse
*-----------------------------------------------------------------------------*
LOCAL cWorkArea

   If _OOHG_BrowseSyncStatus

      cWorkArea := ::WorkArea

      If Select( cWorkArea ) != 0 .AND. ( cWorkArea )->( RecNo() ) != ::Value

         ( cWorkArea )->( DbGoTo( ::Value ) )

		EndIf

	EndIf

   ::DoEvent( ::OnChange )

Return nil

*-----------------------------------------------------------------------------*
METHOD FastUpdate( d, nRow ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local ActualRecord , RecordCount

	// If vertical scrollbar is used it must be updated
   If ::VScroll != nil

      RecordCount := ::RecCount

		If RecordCount == 0
         Return nil
		EndIf

		If RecordCount < 100
         ActualRecord := ::VScroll:Value + d
         * ::VScroll:RangeMax := RecordCount
         ::VScroll:Value := ActualRecord
		EndIf

	EndIf

   If Len( ::aRecMap ) < nRow .OR. nRow == 0
      ::nValue := 0
   Else
      ::nValue := ::aRecMap[ nRow ]
   EndIf

   ListView_SetCursel( ::hWnd, nRow )

Return nil

*-----------------------------------------------------------------------------*
METHOD ScrollUpdate() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local ActualRecord , RecordCount
Local oVScroll, cWorkArea

   oVScroll := ::VScroll

	// If vertical scrollbar is used it must be updated
   If oVScroll != nil

      cWorkArea := ::WorkArea
      IF Select( cWorkArea ) == 0
         ::RecCount := 0
         Return NIL
      ENDIF
      RecordCount := ( cWorkArea )->( OrdKeyCount() )
      If RecordCount > 0
         ActualRecord := ( cWorkArea )->( OrdKeyNo() )
		Else
         ActualRecord := ( cWorkArea )->( RecNo() )
         RecordCount := ( cWorkArea )->( RecCount() )
		EndIf

      ::nValue := ( cWorkArea )->( RecNo() )
      ::RecCount := RecordCount

		If RecordCount < 100
         oVScroll:RangeMax := RecordCount
         oVScroll:Value := ActualRecord
		Else
         oVScroll:RangeMax := 100
         oVScroll:Value := Int ( ActualRecord * 100 / RecordCount )
		EndIf

	EndIf

Return NIL

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local s , _RecNo , _DeltaScroll, v
Local cWorkArea, hWnd

   cWorkArea := ::WorkArea
   hWnd := ::hWnd

   If Select( cWorkArea ) == 0
      ListViewReset( hWnd )
      Return nil
	EndIf

   v := ::Value

   _DeltaScroll := ListView_GetSubItemRect ( hWnd, 0 , 0 )

   s := LISTVIEW_GETFIRSTITEM ( hWnd )

   _RecNo := ( cWorkArea )->( RecNo() )

   if v <= 0
		v := _RecNo
	EndIf

   ( cWorkArea )->( DbGoTo( v ) )

***************************

	if s == 1 .or. s == 0
      ( cWorkArea )->( DBSkip() )
      ( cWorkArea )->( DBSkip( -1 ) )
      IF ( cWorkArea )->( RecNo() ) != v
         ( cWorkArea )->( DbSkip() )
      ENDIF
	EndIf

***************************

	if s == 0
      if ( cWorkArea )->( INDEXORD() ) != 0
         if ( cWorkArea )->( ORDKEYVAL() ) == Nil
            ( cWorkArea )->( DbGoTop() )
			endif
		EndIf

      if Set( _SET_DELETED )
         if ( cWorkArea )->( Deleted() )
            ( cWorkArea )->( DbGoTop() )
			endif
		EndIf
	endif

   If ( cWorkArea )->( Eof() )

      ListViewReset ( hWnd )

      ( cWorkArea )->( DbGoTo( _RecNo ) )

      Return nil

	EndIf

   ::scrollUpdate()

	if s != 0
      ( cWorkArea )->( DbSkip( -s+1 ) )
	EndIf

   ::Update()

   ListView_Scroll( hWnd, _DeltaScroll[2] * (-1) , 0 )
   ListView_SetCursel ( hWnd, ascan ( ::aRecMap, v ) )

   ( cWorkArea )->( DbGoTo( _RecNo ) )

Return nil

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local nItem
   IF VALTYPE( uValue ) == "N"
      ::SetValue( uValue )
   ENDIF
   If SELECT( ::WorkArea ) == 0
      ::RecCount := 0
      uValue := 0
   Else
      nItem := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If nItem > 0 .AND. nItem <= Len( ::aRecMap )
         uValue := ::aRecMap[ nItem ]
      Else
         uValue := ::nValue
      Endif
	EndIf
RETURN uValue

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TBrowse
*-----------------------------------------------------------------------------*
Local nValue := ::nValue
   IF ValType( nValue ) != "N" .OR. nValue == 0
      ::Refresh()
      ::nValue := ::Value
   Else
      ::Refresh()
   ENDIF
RETURN nil

*-----------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TBrowse
*-----------------------------------------------------------------------------*
   If Select( ::WorkArea ) != 0
      ::Super:Events_Enter()
   Endif
Return nil

#pragma BEGINDUMP
// -----------------------------------------------------------------------------
// METHOD Events_Notify( wParam, lParam ) CLASS TBrowse
HB_FUNC_STATIC( TBROWSE_EVENTS_NOTIFY )
// -----------------------------------------------------------------------------
{
   LONG wParam = hb_parnl( 1 );
   LONG lParam = hb_parnl( 2 );
   PHB_ITEM pSelf;

   switch( ( ( NMHDR FAR * ) lParam )->code )
   {
      case NM_CLICK:
      case LVN_BEGINDRAG:
      case LVN_KEYDOWN:
         HB_FUNCNAME( TBROWSE_EVENTS_NOTIFY2 )();
         break;

      case NM_CUSTOMDRAW:
      {
         pSelf = hb_stackSelfItem();
         _OOHG_Send( pSelf, s_AdjustRightScroll );
         hb_vmSend( 0 );
         hb_retni( TGrid_Notify_CustomDraw( pSelf, lParam ) );
         break;
      }

      default:
         _OOHG_Send( hb_stackSelfItem(), s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events_Notify );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 2 );
         break;
   }
}
#pragma ENDDUMP

FUNCTION TBrowse_Events_Notify2( wParam, lParam )
Local Self := QSelf()
Local nNotify := GetNotifyCode( lParam )
Local nvKey, r, DeltaSelect

   If nNotify == NM_CLICK  .or. nNotify == LVN_BEGINDRAG

      r := LISTVIEW_GETFIRSTITEM( ::hWnd )
      If r > 0
         DeltaSelect := r - ascan ( ::aRecMap, ::nValue )
         ::FastUpdate( DeltaSelect, r )
         ::BrowseOnChange()
      EndIf

      Return nil

   elseIf nNotify == LVN_KEYDOWN

      nvKey := GetGridvKey( lParam )

      Do Case

      Case Select( ::WorkArea ) == 0

         // No database open

      Case nvKey == 65 // A

         if GetAltState() == -127 ;
            .or.;
            GetAltState() == -128   // ALT

            if ::AllowAppend
               ::EditItem( .t. )
            EndIf

         EndIf

      Case nvKey == 46 // DEL

         If ::AllowDelete
            If MsgYesNo( _OOHG_Messages( 4, 1 ), _OOHG_Messages( 4, 2 ) )
               ::Delete()
            EndIf
         EndIf

      Case nvKey == 36 // HOME

         ::Home()
         Return 1

      Case nvKey == 35 // END

         ::End()
         Return 1

      Case nvKey == 33 // PGUP

         ::PageUp()
         Return 1

      Case nvKey == 34 // PGDN

         ::PageDown()
         Return 1

      Case nvKey == 38 // UP

         ::Up()
         Return 1

      Case nvKey == 40 // DOWN

         ::Down()
         Return 1

      EndCase

      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*-----------------------------------------------------------------------------*
METHOD SetScrollPos( nPos ) CLASS TBrowse
*-----------------------------------------------------------------------------*
Local BackRec
   If Select( ::WorkArea ) != 0
      BackRec := ( ::WorkArea )->( RecNo() )
      ::Super:SetScrollPos( nPos, ::VScroll )
      ::Value := ( ::WorkArea )->( RecNo() )
      ( ::WorkArea )->( DbGoTo( BackRec ) )
      ::BrowseOnChange()
   EndIf
Return nil

EXTERN INSERTUP, INSERTDOWN, INSERTPRIOR, INSERTNEXT

#pragma BEGINDUMP
HB_FUNC (INSERTUP)
{
			keybd_event(
			VK_UP	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);
}

HB_FUNC (INSERTDOWN)
{
			keybd_event(
			VK_DOWN	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);
}

HB_FUNC (INSERTPRIOR)
{
			keybd_event(
			VK_PRIOR	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);
}

HB_FUNC (INSERTNEXT)
{
			keybd_event(
			VK_NEXT	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);
}

#pragma ENDDUMP

Function SetBrowseSync( lValue )
   IF valtype( lValue ) == "L"
      _OOHG_BrowseSyncStatus := lValue
   ENDIF
Return _OOHG_BrowseSyncStatus
