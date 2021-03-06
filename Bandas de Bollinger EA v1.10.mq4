﻿//+------------------------------------------------------------------+
//|                                 Bandas de Bollinger EA v1.10.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Daniel de Medeiros Lima"
#property link      ""
#property version   "1.10"
#property strict
#include "OrdensAbertasV1.00.mq4"
#include "getLastResults.mq4"



extern int     MagicNumber       =  135711;
extern double  LoteInicial       =  1.00;
extern double  MaxSpread         =  10;
extern int     startHour         =  0;
extern int     finishHour        =  24;
extern double  StopLoss          =  200;
extern int     Bandsperiod       =  17;
extern double  BandsDeviation    =  2.2;
extern int     mmePeriod         =  60;
extern double  FatorMartingale   =  2;

bool compraAutorizada            =  true;
bool vendaAutorizada             =  true;
int ticket_c, ticket_v;
int   Buy, 
      Sell, 
      OnlyBuy, 
      OnlySell, 
      BuyAndSell, 
      TotalOrdensAbertas;

double stop_c, stop_v;
double Lote = LoteInicial;



void OnTick(){

         getLastTradeResults();
            
         double bandaSuperior = iBands(Symbol(),PERIOD_CURRENT,Bandsperiod,BandsDeviation,1,PRICE_CLOSE,MODE_UPPER,1);
         double bandaInferior = iBands(Symbol(),PERIOD_CURRENT,Bandsperiod,BandsDeviation,1,PRICE_CLOSE,MODE_LOWER,1);
         double bandaCentral  = iBands(Symbol(),PERIOD_CURRENT,Bandsperiod,BandsDeviation,1,PRICE_CLOSE,MODE_MAIN,1);
         double mmeFiltro     = iMA(Symbol(),PERIOD_CURRENT,mmePeriod,1,MODE_EMA,PRICE_CLOSE,1);
         
         OrdensAbertas();
         Buy = OnlyBuy;
         Sell = OnlySell;
         TotalOrdensAbertas = BuyAndSell;
         
         //VERIFICA O SPREAD
         double Spread = MarketInfo(Symbol(), MODE_SPREAD);
         
         
         Comment (/*"Banda Superior= ", bandaSuperior + 
                  "\nBanda Central= ",bandaCentral+
                  "\nBanda Inferior= ",bandaInferior + 
                  "\nCompra Autorizada = ",compraAutorizada+
                  "\nVenda Autorizada  = ",vendaAutorizada+*/
                  "\nLote = ",Lote+
                  "\nLoteInicial = ",LoteInicial+
                  "\nlastOrderProfit = ", lastOrderProfit
                  /*"\nStop_c = ",stop_c+
                  "\nStop_v = ",stop_v+
                  "\nQtde de Ordens Abertas: ", TotalOrdensAbertas +
                  "\nQtd de Compras: ", Buy +
                  "\nQtd de Vendas: ", Sell +
                  "\nSpread: ", Spread*/);
   
   //CONDICIONAL DE HORÁRIO E O SPREAD MÁXIMO               
   if(Hour()>= startHour && Hour() <= finishHour && Spread <= MaxSpread)
   {
         /*--------------------------------------------------------------
         COMPRA
         --------------------------------------------------------------*/
                  
         
         //ABRE ORDEM COMPRA
         if(Buy==0){
            if(Close[0] <= bandaInferior && Close[0] >= mmeFiltro){
               if(lastOrderProfit >= 0){
                  Lote = LoteInicial;
                  ticket_c = OrderSend(Symbol(),OP_BUY,Lote,Ask,3,Bid-StopLoss*Point(),0,"BandasDeBolingerEA",MagicNumber,0,clrBlue);
                  stop_c = Bid-StopLoss*Point();        
               }else{
                  Lote = Lote * FatorMartingale;
                  ticket_c = OrderSend(Symbol(),OP_BUY,Lote,Ask,3,Bid-StopLoss*Point(),0,"BandasDeBolingerEA",MagicNumber,0,clrBlue);
                  stop_c = Bid-StopLoss*Point();
               }
            }
         }
         //FECHA A ORDEM DE COMPRA
         if (Buy > 0 && Close[0] >= bandaSuperior){
               OrderClose(ticket_c,Lote,Bid,3,clrRed);
               //compraAutorizada = true;
         }                                                
         if(Buy > 0 && Close[0] <= stop_c){
            OrderClose(ticket_c,Lote,Bid,3,clrRed);
            //compraAutorizada = true;
            stop_c = 0;
         }   
         
         /*--------------------------------------------------------------
         VENDA
         --------------------------------------------------------------*/
                  
         //ABRE ORDEM VENDA
         if(Sell == 0){
            if(Close[0] >= bandaSuperior && Close[0] <= mmeFiltro){
               if(lastOrderProfit >= 0){
                  Lote = LoteInicial;
                  ticket_v = OrderSend(Symbol(),OP_SELL,Lote,Bid,3,Ask+StopLoss*Point(),0,"BandasDeBolingerEA",MagicNumber,0,clrRed);
                  stop_v = Ask+StopLoss*Point();
               }else{
                  Lote = Lote * FatorMartingale;
                  ticket_v = OrderSend(Symbol(),OP_SELL,Lote,Bid,3,Ask+StopLoss*Point(),0,"BandasDeBolingerEA",MagicNumber,0,clrRed);
                  stop_v = Ask+StopLoss*Point();        
               }
            }
         }
         //FECHA A ORDEM DE VENDA
         if (Sell > 0 && Close[0] <= bandaInferior){
            OrderClose(ticket_v,Lote,Ask,3,clrBlue);
            //vendaAutorizada = true;
         }                                                
         if(Sell > 0 && Close[0] >= stop_v){
            OrderClose(ticket_v,Lote,Ask,3,clrBlue);
            stop_v = 0;
            //vendaAutorizada = true;
         }   
         
   
   
   }//hour                
}//OnTick()         
         
