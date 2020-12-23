//+------------------------------------------------------------------+
//|                                           OrdensAbertasV1.00.mq4 |
//|                                                   DanielTrader4X |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "DanielTrader4X"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

int OrdensAbertas() {
   int c_pending = 0, c_buy = 0, c_sell = 0;
   int BuyAndSell, Pending, OnlyPending;   
     
   for (int i = OrdersTotal() - 1; i >= 0; i--)
      if (OrderSelect(i, SELECT_BY_POS))
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) // EAMN is a global variable that contains the magic number
            switch (OrderType()) {
               case OP_BUYLIMIT:
               case OP_BUYSTOP:
                  c_pending++;
               case OP_BUY:
                  c_buy++; break;
               case OP_SELLLIMIT:
               case OP_SELLSTOP:
                  c_pending++;
               case OP_SELL:
                  c_sell++; break;
               default:
                  break;
            }
   
   BuyAndSell  = c_buy + c_sell; // total open trades
   Pending     = c_pending;      // total pending trades
   OnlyBuy     = c_buy;          // total buy trades
   OnlySell    = c_sell;         // total sell trades

   return BuyAndSell;
   return OnlyPending;
   return OnlyBuy;
   return OnlySell;
}