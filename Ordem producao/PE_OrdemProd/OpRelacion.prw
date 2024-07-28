#include 'totvs.ch'
#include 'topconn.ch'
#include 'tbiconn.ch'
User Function jTestPE2()
    RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
          
	    u_ValidaOp()

	RESET ENVIRONMENT

return

User Function ValidaOp()

    local lOK    
    local oOpRel := Nil
          oOpRel := OpAdc():new_OpRel()
          oOpRel:exec_OpRel()
    lOK := oOpRel:abreOP()
return lOK

class OpAdc
    data aProds
    data aDados

    data cItem
    data cSequencia
    data cProduto
    data cArmazem
    data cCtrCusto
    data nQuantidade
    data cUnidMedida
    data dPrevIni
    data dEntrega
    data cObservcao
    data dDataEmi
    data cPrioridade
    data cSituacao
    data cTipoOP
	
    data lRet
    data oDadosOP
    data oabreOP
    data oBrowse


    method new_OpRel() constructor
    method Search_ProdRel()
    method Tela_OpRel()
    method Linha()
    method marcacao()
    method inverter()
    method getMark()
    method exec_OpRel()
    method abreOP()
    
endclass

method new_OpRel() class OpAdc
    ::aProds        := {}
    ::aDados        := {}
    ::cProduto      := ""
    ::cItem         := ""
    ::cSequencia    := ""
    ::cArmazem      := ""
    ::cCtrCusto     := ""
    ::nQuantidade   := 0  
    ::cUnidMedida   := ""
    ::dPrevIni      := nil
    ::dEntrega      := nil
    ::cObservcao    := ""  
    ::dDataEmi      := nil
    ::cPrioridade   := ""  
    ::cSituacao     := ""
    ::cTipoOP       := ""

    ::oDadosOP    := dadosOP():New_dadosOP()  
    ::oabreOP     := OrdemProd():new_OrdemProd()      
    ::oBrowse     := Nil
return

method exec_OpRel() class OpAdc

   if ( Empty(::aDados))
          ::Search_ProdRel()
    endif

    if (!Empty(::aDados))
          ::Tela_OpRel()
    endif
return

method Search_ProdRel() class OpAdc
 
    local lRet := .T.
    ::oDadosOP:get_dadosOP()

    DBSelectArea("SB1")    
    SB1->( DbSetOrder( 1 ) )    

      if( SB1->( DbSeek( xFilial( "SB1" )+::oDadosOP:cProduto) ) )


    if !Empty(SB1->B1_X_PROD1) 
       AAdd( ::aDados,{ .F.,  SB1->B1_X_PROD1 , SB1->B1_X_DESC1 })
       
    endIf

     if !Empty(SB1->B1_X_PROD2) 
       AAdd( ::aDados,{ .F.,  SB1->B1_X_PROD2 , SB1->B1_X_DESC2 })
    endIf

    if !Empty(SB1->B1_X_PROD3) 
       AAdd( ::aDados,{ .F.,  SB1->B1_X_PROD3 , SB1->B1_X_DESC3 })
    endIf
    /*/if !Empty(SB1->B1_X_PROD4) 
       AAdd( ::aDados,{ SB1->B1_X_PROD4 })
    endIf
    if !Empty(SB1->B1_X_PROD5) 
       AAdd( ::aDados,{ SB1->B1_X_PROD5 })
    endIf/*/
    if (!Empty(::aDados))
        lRet := .F.
    
    endif

    endIf 

 return lRet

method Tela_OpRel() class OpAdc
    local oDlg as object
    
    // Criação da dialog
    oDlg = TDialog():New( 180, 180, 550, 700, "Exemplo TCBrowse com coluna de marcação",,, .F.,,,,,, .T.)

    // Cria Browse

    DEFINE MSDIALOG oDlg TITLE "Produto comumente relacionados" FROM 0,0 TO 320,700 PIXEL

    @ 010, 007   LISTBOX ::oBrowse Fields HEADER "","Produto","Descrição" SIZE 300, 100 OF oDlg PIXEL ColSizes 50,50 //cabeçalho 

    // Monta a linha a ser exibina no Browse
    ::Linha(::aDados)
                            
    // Evento de duplo click na celula
    ::oBrowse:bLDblClick	:= {|| ::marcacao(::oBrowse), (::getMark()) }
    ::oBrowse:bHeaderClick	:= {|| ::inverter(::oBrowse) }
    //ACTIVATE MSDIALOG oDlg CENTERED
    
    @ 130, 010 BUTTON oButCan PROMPT "Confirmar"	SIZE 057, 014 OF oDlg ACTION ( ::abreOP(), oDlg:End() ) PIXEL
    @ 130, 085 BUTTON oButCan PROMPT "Cancelar"	    SIZE 057, 014 OF oDlg ACTION ( oDlg:End() )             PIXEL	

    oDlg:Activate( ,,,.T.)

return 

method abreOP() class OpAdc
    local lRet
    local nI

    ::oDadosOP:cProduto := ::aProds

    for nI := 1 to Len(::aProds)

        ::oabreOP:cProduto      := ::oDadosOP:cProduto[nI]
        ::oabreOP:cItem         := ::oDadosOP:cItem
        ::oabreOP:cSequencia    := ::oDadosOP:cSequencia
        ::oabreOP:cArmazem      := ::oDadosOP:cArmazem
        ::oabreOP:nQuantidade   := ::oDadosOP:nQuantidade
        ::oabreOP:cUnidMedida   := ::oDadosOP:cUnidMedida
        ::oabreOP:dPrevIni      := date(::oDadosOP:dPrevIni)
        ::oabreOP:dEntrega      := date(::oDadosOP:dEntrega)
        ::oabreOP:dDataEmi      := date(::oDadosOP:dDataEmi)
        
    Next nI

    ::oabreOP:execManRegis_OrdemProd()

    lRet := .T.
    
    

return lRet

method Linha() class OpAdc
    
	local oOk := LoadBitmap( GetResources(), "LBOK")
	local oNo := LoadBitmap( GetResources(), "LBNO")
	
	::oBrowse:SetArray(::aDados)                     

	::oBrowse:bLine := {|| {;                        
		        Iif(::aDados[::oBrowse:nAt,01],oOk,oNo),;
                Alltrim(::aDados[::oBrowse:nAt,02]),;
                Alltrim(::aDados[::oBrowse:nAt,03])	}} 
return 
method getMark() class OpAdc
    local nI    := 1
    
    ::aProds := {}

    for nI := 1 to Len( ::aDados )

        if(::aDados[ nI, 01 ] )		    
            AAdd( ::aProds, ::aDados[nI, 02] )
            
        endIf
    next
	
return

method marcacao(oBrowse) class OpAdc

#define COL_MARCACAO 1
//Só faz a marcação se estiver posicionado na coluna de marcação
//Se quiser que clicar ou pressionar o enter funcione como marcação em qualquer coluna, basta remover esse IF

    ::aDados[::oBrowse:nAt][01] := !::aDados[::oBrowse:nAt][01]
  
    ::oBrowse:DrawSelect()	
    ::oBrowse:Refresh()
   

return ::aDados 
method inverter(oBrowse) class OpAdc
local nI as numeric

//Só faz a marcação se estiver posicionado na coluna de marcação
//Se quiser que clicar ou pressionar o enter funcione como marcação em qualquer coluna, basta remover esse IF
if ::oBrowse:ColPos() == COL_MARCACAO
    for nI := 1 to Len(oBrowse:aArray)
        ::oBrowse:aArray[nI, COL_MARCACAO] := !oBrowse:aArray[nI, COL_MARCACAO]
    next

    ::oBrowse:DrawSelect()
	::oBrowse:Refresh()
endif

return
/*/
::oDadosOP:cProduto := "PIP000001"


::oDadosOP:cItem := "01"

::oDadosOP:cSequencia := "001"

::oDadosOP:cArmazem := "01"

::oDadosOP:nQuantidade := 100

::oDadosOP:cUnidMedida := "UN"

::oDadosOP:dPrevIni := DATE(17/07/2024)

::oDadosOP:dEntrega := DATE(17/07/2024)

::oDadosOP:dmi := DATE(17/07/2024)

