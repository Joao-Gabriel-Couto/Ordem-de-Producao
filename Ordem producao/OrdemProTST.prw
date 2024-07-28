#include 'totvs.ch'
#include 'topconn.ch'
#include 'tbiconn.ch'

User Function jOrdemProd()
    RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
          
	    u_uOrdemProd()

	RESET ENVIRONMENT

return

User Function uOrdemProd()

    local oExOrdemPrd 
    oExOrdemPrd := OrdemProdInc():newDados_OrdemProd()
    oExOrdemPrd:execGet_OPdados()
return

class OrdemProdInc

    data oOrdemProd
   
    
    method newDados_OrdemProd() constructor
    method get_OPdados()
    method execGet_OPdados()
endClass

method newDados_OrdemProd() class OrdemProdInc

    ::oOrdemProd := OrdemProd():new_OrdemProd()

return

method execGet_OPdados() class OrdemProdInc
 if ::get_OPdados()
 endif

return
method get_OPdados() class OrdemProdInc

    ::oOrdemProd:cFillOP        := ""
    ::oOrdemProd:cNumOP         := "000006"
    ::oOrdemProd:cItem          := "01"
    ::oOrdemProd:cSequencia     := "001"
    ::oOrdemProd:cProduto       := "PA00001"
    ::oOrdemProd:cArmazem       := "01"
    ::oOrdemProd:cCtrCusto      := ""
    ::oOrdemProd:nQuantidade    := 33
    ::oOrdemProd:cUnidMedida    := ""
    ::oOrdemProd:dPrevIni       :=Date(17/07/2024)
    ::oOrdemProd:dEntrega       :=Date(19/07/2024)
    ::oOrdemProd:cObservcao     :="Preciso dessa caneta para ontem"
    ::oOrdemProd:dDataEmi       :=Date(17/07/2024)
    ::oOrdemProd:cPrioridade    :="Sim"
    ::oOrdemProd:cSituacao      :=""
    ::oOrdemProd:cTipoOP        :="P"

    ::oOrdemProd:execManRegis_OrdemProd()
return
