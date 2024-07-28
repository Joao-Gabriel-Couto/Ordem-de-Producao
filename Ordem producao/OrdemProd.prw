#include 'totvs.ch'
#include 'topconn.ch'
#include 'tbiconn.ch'

/*/{Protheus.doc} OrdemProd
Classe generica para ordem de produção

@author    João Couto - Geeker Company
@since     14/03/2024
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
class OrdemProd
	data cFillOP 		 
    data cNumOP			 
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
	
	data nOPC_INC		 
	data nOPC_UPDT		 
	data nOPC_DEL		 	
	data nOperation		 

    data cError    		 	
    data aDados			 
	


    method new_OrdemProd() constructor 
	
	method getByChave_OrdemProd()	
	method setByAlias_OrdemProd()
    method setByBD_OrdemProd()
	method prepDados_OrdemProd()
	method execManRegis_OrdemProd()    
	method manRegis_OrdemProd()
		
endClass

/*/{Protheus.doc} new_OrdemProd
Metodo construtor
@author    João Couto
@since     14/03/2024
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method new_OrdemProd() class OrdemProd
	
	::nOPC_INC  := 3
	::nOPC_UPDT	:= 4
	::nOPC_DEL	:= 5
	
	::cError	:= ""
	::aDados    := {}

return

/*/{Protheus.doc} getByChave_OrdemProd
Metodo para buscar pela chave
@author    João Couto
@since     14/03/2024
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method getByChave_OrdemProd() class OrdemProd
	Local aArea    := GetArea()

	DBSelectArea("SC2")
    SC2->( DbSetOrder( 1 ) )
    if( SC2->( DbSeek( xFilial( "SC2" ) ) ) )

    else
        ::cError := "Registro nao encontrado"
    endIf
	RestArea(aArea)
return

/*/{Protheus.doc} setByAlias_OrdemProd
Metodo setar os atributos baseado em um alias
@author    João Couto
@since     14/03/2024
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method setByAlias_OrdemProd() class OrdemProd

	::cFillOP		:= ( cAliasQry )->C2_FILIAL
	::cNumOP 		:= ( cAliasQry )->C2_NUM
	::cItem			:= ( cAliasQry )->C2_ITEM
	::cSequencia 	:= ( cAliasQry )->C2_SEQUEN
	::cProduto 		:= ( cAliasQry )->C2_PRODUTO
	::cArmazem 		:= ( cAliasQry )->C2_LOCAL
	::cCtrCusto 	:= ( cAliasQry )->C2_CC
	::nQuantidade 	:= ( cAliasQry )->C2_QUANT
	::cUnidMedida 	:= ( cAliasQry )->C2_UM
	::dPrevIni	 	:= ( cAliasQry )->C2_DATPRI
	::dEntrega 		:= ( cAliasQry )->C2_DATPRF
	::cObservcao 	:= ( cAliasQry )->C2_OBS
	::dDataEmi 		:= ( cAliasQry )->C2_EMISSAO
	::cPrioridade 	:= ( cAliasQry )->C2_PRIOR
	::cSituacao 	:= ( cAliasQry )->C2_STATUS
	::cTipoOP 		:= ( cAliasQry )->C2_TPOP
	

return

/*/{Protheus.doc} setByBD_OrdemProd
Metodo setar os atributos baseado no registro posicionado
@author    João Couto
@since     14/03/2024
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method setByBD_OrdemProd()class OrdemProd

    ::cFillOP		:= SC2->C2_FILIAL
	::cNumOP 		:= SC2->C2_NUM
	::cItem			:= SC2->C2_ITEM
	::cSequencia 	:= SC2->C2_SEQUEN
	::cProduto 		:= SC2->C2_PRODUTO
	::cArmazem 		:= SC2->C2_LOCAL
	::cCtrCusto 	:= SC2->C2_CC
	::nQuantidade 	:= SC2->C2_QUANT
	::cUnidMedida 	:= SC2->C2_UM
	::dPrevIni 	    := SC2->C2_DATPRI
	::dEntrega 		:= SC2->C2_DATPRF
	::cObservcao 	:= SC2->C2_OBS
	::dDataEmi 		:= SC2->C2_EMISSAO
	::cPrioridade 	:= SC2->C2_PRIOR
	::cSituacao 	:= SC2->C2_STATUS
	::cTipoOP 		:= SC2->C2_TPOP

	

return

/*/{Protheus.doc} execManRegis_OrdemProd
Metodo que ira preparar o necessairo, para chamada da rotina automática
@author    João Couto 
@since     14/03/2024
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method execManRegis_OrdemProd() class OrdemProd

    if( Empty( ::cError ) )
        ::prepDados_OrdemProd()
    endIf

    if( Empty( ::cError ) )
        ::manRegis_OrdemProd()
    endIf

return

/*/{Protheus.doc} prepDados_OrdemProd
Metodo para preparar os atributos para o Array da rotina automatica
@author   João Couto
@since     14/01/2020
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method prepDados_OrdemProd() class OrdemProd
   

	if( !Empty( ::cFillOP ) )
		AAdd( ::aDados, {'C2_FILIAL'   , ::cFillOP        , nil } )
	endIf

	if( !Empty( ::cItem ) )
		AAdd( ::aDados, {'C2_ITEM'     , ::cItem   	      , nil } )
	endIf

	if( !Empty( ::cSequencia ) )
		AAdd( ::aDados, {'C2_SEQUEN'   , ::cSequencia      , nil } )
	endIf

	if( !Empty( ::cProduto ) )
		AAdd( ::aDados, {'C2_PRODUTO'   , ::cProduto       , nil } )
	endIf

	if( !Empty( ::cArmazem ) )
		AAdd( ::aDados, {'C2_LOCAL'     , ::cArmazem       , nil } )
	endIf  

	if( !Empty( ::cCtrCusto ) )
		AAdd( ::aDados, {'C2_CC'        , ::cCtrCusto      , nil } )
	endIf

	if( !Empty( ::nQuantidade ) )
		AAdd( ::aDados, {'C2_QUANT'     , ::nQuantidade    , nil } )
	endIf

	if( !Empty( ::cUnidMedida ) )
		AAdd( ::aDados, {'C2_UM'        , ::cUnidMedida    , nil } )
	endIf
	if( !Empty( ::dPrevIni ) )
		AAdd( ::aDados, {'C2_DATPRI'    , ::dPrevIni   	   , nil } )
	endIf
	
	if( !Empty( ::dEntrega ) )
		AAdd( ::aDados, {'C2_DATPRF'    , ::dEntrega       , nil } )
	endIf

	if( !Empty( ::cObservcao ) )
		AAdd( ::aDados, {'C2_OBS'       , ::cObservcao     , nil } )
	endIf

	if( !Empty( ::dDataEmi ) )
		AAdd( ::aDados, {'C2_EMISSAO'   , ::dDataEmi   	   , nil } )
	endIf

	if( !Empty( ::cPrioridade ) )
		AAdd( ::aDados, {'C2_PRIOR'     , ::cPrioridade    , nil } )
	endIf

	if( !Empty( ::cSituacao ) )
		AAdd( ::aDados, {'C2_STATUS'    , ::cSituacao      , nil } )
	endIf

	if( !Empty( ::cTipoOP ) )
		AAdd( ::aDados, {'C2_TPOP  '    , ::cTipoOP   	   , nil } )
	endIf
return

/*/{Protheus.doc} manRegis_OrdemProd()
Metodo para execução da rotina automática
de inclusão
@author    João Couto
@since     14/03/2024
@version   ${version}
@example
(examples)
@see (links_or_references)
/*/
method manRegis_OrdemProd() class OrdemProd
	
	private lMsErroAuto := .F.
    private lMsHelpAuto := .T.
	default ::nOperation  := ::nOPC_INC
    MsExecAuto({ |x, y| Mata650(x, y) }, ::aDados, ::nOperation )

        if(lMsErroAuto)
            ::cError := Alltrim( u_MsgErroAuto() )
        else
			Conout("Ordem de produção incluida com sucesso")
		endIf

return
