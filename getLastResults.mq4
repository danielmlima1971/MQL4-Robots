//+------------------------------------------------------------------+
//|                                               getLastResults.mq4 |
//|                                                   DanielTrader4X |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "DanielTrader4X"
#property link      ""
#property version   "1.00"
#property strict


//=============================================================================
//       FUNCAO PARA BUSCAR OS RESULTADOS DA ULTIMA ORDEM FECHADA
//=============================================================================

//#include "getLastResults.mq4"
int lastOrderType;
double lastOrderProfit;
double lastOrderLots;

double getLastTradeResults(){
   int cnt = OrdersHistoryTotal();
      for(int i=0 ; i < cnt ; i++){
         OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
            if(Symbol() == OrderSymbol() && MagicNumber == OrderMagicNumber()){
               lastOrderType = OrderType();
               lastOrderProfit = OrderProfit();
               lastOrderLots = OrderLots();
          
         }}
  return(0);
}