#include 'TOTVS.CH'
#include 'Protheus.ch'
#include 'Topconn.ch'
#include "tbiconn.ch"

User Function jTestPE()
    RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
          
	    u_MA650TOK()

	RESET ENVIRONMENT

return

User Function MA650TOK()
    
    local lRet := .F.
    local oDadosOP      := Nil
    local oProdRelc     := Nil
    local oRotinauto    := Nil

    oDadosOP := dadosOP():New_dadosOP() 
    oDadosOP:get_dadosOP()

    oProdRelc   :=  OpAdc():new_OpRel()
    oRotinauto  :=  OpAdc():new_OpRel()

    if    lRet := oProdRelc:Search_ProdRel()
     
	/*/else 
		lRet := oRotinauto:abreOP()/*/
    	 
	endif
    if lRet == .F.

        MsgYesNo("Para esse Produto há outros produtos comumete relacionados a produção"+CRLF+CRLF+"Deseja conferir esses produtos?")
       
        u_ValidaOp()

        //lRet := oRotinauto:abreOP()  
    endif

    
        
return lRet

Class dadosOP

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

    method New_dadosOP()
    method dadosOP()
    method get_dadosOP()
    method get_relacao()
endclass
method New_dadosOP() class dadosOP
::cProduto := ""

return
method get_dadosOP() class dadosOP

	::cItem			:= M->C2_ITEM
	::cSequencia 	:= M->C2_SEQUEN
	::cProduto 		:= M->C2_PRODUTO
	::cArmazem 		:= M->C2_LOCAL
	::cCtrCusto 	:= M->C2_CC
	::nQuantidade 	:= M->C2_QUANT
	::cUnidMedida 	:= M->C2_UM
	::dPrevIni 	    := M->C2_DATPRI
	::dEntrega 		:= M->C2_DATPRF
	::cObservcao 	:= M->C2_OBS
	::dDataEmi 		:= M->C2_EMISSAO
	::cPrioridade 	:= M->C2_PRIOR
	::cSituacao 	:= M->C2_STATUS
	::cTipoOP 		:= M->C2_TPOP

return

 /*/::cItem			:= M->C2_ITEM
	::cSequencia 	:= M->C2_SEQUEN
	::cProduto 		:= M->C2_PRODUTO
	::cArmazem 		:= M->C2_LOCAL
	::cCtrCusto 	:= M->C2_CC
	::nQuantidade 	:= M->C2_QUANT
	::cUnidMedida 	:= M->C2_UM
	::dPrevIni 	    := M->C2_DATPRI
	::dEntrega 		:= M->C2_DATPRF
	::cObservcao 	:= M->C2_OBS
	::dDataEmi 		:= M->C2_EMISSAO
	::cPrioridade 	:= M->C2_PRIOR
	::cSituacao 	:= M->C2_STATUS
	::cTipoOP 		:= M->C2_TPOP

 
    ::cItem			:= "01"
	::cSequencia 	:= "001"
	::cProduto 		:= "PIP000001"
	::cArmazem 		:= "01"
	::cCtrCusto 	:= M->C2_CC
	::nQuantidade 	:= 01
	::cUnidMedida 	:= "UN"
	::dPrevIni 	    := date(19/07/2024)
	::dEntrega 		:= date(19/07/2024)
	::cObservcao 	:= "TEST TEST"//M->C2_OBS
	::dDataEmi 		:= date(19/07/2024)
	::cPrioridade 	:= M->C2_PRIOR
	::cSituacao 	:= M->C2_STATUS
	::cTipoOP 		:= M->C2_TPOP
 /*/
