#include 'TOTVS.CH'
#include 'Protheus.ch'
#include 'Topconn.ch'
#include "tbiconn.ch"


user function jtestOP()

	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
	
	    u_ujtestOP()

	RESET ENVIRONMENT

return
user function ujtestOP()
    local oOpRel := Nil
          oOpRel := OpAdc():new_OpRel()
          oOpRel:exec_OpRel()
return

class OpAdc
    data lOK
    data aDados
    data cCodProd
    data oBrowse

    method new_OpRel() constructor
    method Search_ProdRel()
    method Tela_OpRel()
    method Linha()
    method vldMark()
    method marcaBrw()
    method marcaAmostra()
    method marcaOLabId()
    method updSoma()
    method exec_OpRel()
endclass

method new_OpRel() class OpAdc

    ::aDados      := {}
    ::cCodProd    := ""

    ::oBrowse     := Nil
return

method exec_OpRel() class OpAdc
    if (Empty(::aDados))
        ::Search_ProdRel()
    endif
    if (!Empty(::aDados))
        ::Tela_OpRel()
    endif
return
method Search_ProdRel() class OpAdc

    
    ::cCodProd := "PIP000001"

    DBSelectArea("SB1")
    SB1->( DbSetOrder( 1 ) )
    if( SB1->( DbSeek( xFilial( "SB1" )+::cCodProd) ) )

    if !Empty(SB1->B1_X_PROD1) 
       AAdd( ::aDados,{.F., SB1->B1_X_PROD1 , SB1->B1_X_DESC1 })
    endIf

     if !Empty(SB1->B1_X_PROD2) 
       AAdd( ::aDados,{.F., SB1->B1_X_PROD2 , SB1->B1_X_DESC2 })
    endIf

    if !Empty(SB1->B1_X_PROD3) 
       AAdd( ::aDados,{.F., SB1->B1_X_PROD3 , SB1->B1_X_DESC3 })
    endIf
    /*/if !Empty(SB1->B1_X_PROD4) 
       AAdd( ::aDados,{ SB1->B1_X_PROD4 })
    endIf
    if !Empty(SB1->B1_X_PROD5) 
       AAdd( ::aDados,{ SB1->B1_X_PROD5 })
    endIf/*/
    endIf

    

return

method Tela_OpRel() class OpAdc

local oDlg as object

// Criação da dialog
oDlg = TDialog():New( 180, 180, 550, 700, "Exemplo TCBrowse com coluna de marcação",,, .F.,,,,,, .T.)


// Cria Browse

DEFINE MSDIALOG oDlg TITLE "Produto comumente relacionados" FROM 0,0 TO 320,700 PIXEL

@ 038, 007   LISTBOX ::oBrowse Fields HEADER "","Produto","Descrição" SIZE 300, 100 OF oDlg PIXEL ColSizes 50,50 //cabeçalho
    

// Monta a linha a ser exibina no Browse
::Linha(::aDados)
                           
// Evento de duplo click na celula
::oBrowse:bLDblClick	:= {|| iif(::vldMark(),;
											(::marcaBrw(), ::updSoma());
											,)}	
// Ativa e exibe a janela
ACTIVATE MSDIALOG oDlg CENTERED
//oDlg:Activate( ,,,.T.)

return
method Linha() class OpAdc
    
	local oOk := LoadBitmap( GetResources(), "LBOK")
	local oNo := LoadBitmap( GetResources(), "LBNO")
	
	::oBrowse:SetArray(::aDados)                     

	::oBrowse:bLine := {|| {;                        
		    iif(::aDados[::oBrowse:nAt]:lOK,oOk,oNo),;
                Alltrim(::aDados[::oBrowse:nAt]:cProduto),;
                Alltrim(::aDados[::oBrowse:nAt]:cDescricao)	}} 
return 
method vldMark() class OpAdc
	local lRet := .T.
	local cRet := ""
		
	if(!::aDados[::oBrowse:nAt]:lOK)		
		if(lRet)
			cRet := ::vldUmItem(::oBrowse:nAt)

			if(!Empty(cRet))
				Aviso("Merieux - Operação inválida", cRet, {"OK"}, 3, FunDesc())
				lRet := .F.
			endif
		endIf
	endIf
return lRet

return

/*/{Protheus.doc} marcaBrw
Marca os browse

@author Geeker Company - Fabio Hayama
@since 22/03/2017 
@version 1.0
/*/
method marcaBrw() class OpAdc
	 
	::aDados[::oBrowse:nAt]:lOK := !::aDados[::oBrowse:nAt]:lOK
	
	::marcaOLabId(::aDados[::oBrowse:nAt]	, ::aDados[::oBrowse:nAt]:lOK)
	::marcaAmostra(::aDados[::oBrowse:nAt]	, ::aDados[::oBrowse:nAt]:lOK)					
return
/*/{Protheus.doc} marcaBrw
Marca os browse

@author Geeker Company - Fabio Hayama
@since 22/03/2017 
@version 1.0
/*/
method marcaOLabId(oDadMark, lMark) class OpAdc
	local nI := 1

	for nI := 1 to Len(::aDados)
		if(!Empty(::aDados[nI]:cOLabId) .AND. Alltrim(::aDados[nI]:cOLabId) == Alltrim(oDadMark:cOLabId))
			::aDados[nI]:lOK := lMark
		endIf	 
	next
	
	::oBrowse:DrawSelect()
	::oBrowse:Refresh()
return
/*/{Protheus.doc} marcaAmostra
Marca o browse com as mesmas amostras

@author Geeker Company - Fabio Hayama
@since 22/03/2017 
@version 1.0
/*/
method marcaAmostra(oDadMark, lMark) class OpAdc
	local nI := 1

	for nI := 1 to Len(::aDados)
		if(!Empty(::aDados[nI]:cNumAmostra) .AND. Alltrim(::aDados[nI]:cNumAmostra) == Alltrim(oDadMark:cNumAmostra))
			::aDados[nI]:lOK := lMark
		endIf	 
	next
	
	::oBrowse:DrawSelect()
	::oBrowse:Refresh()
return

method updSoma() class OpAdc	
return
