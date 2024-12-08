//+------------------------------------------------------------------+
//|                                                        00o00.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Script creates a button on the chart and closes all positions when Alt+K is pressed."
#include <Trade/Trade.mqh>
//--- Input parameters of the script
input string           InpName_clsall = "closeall"; // Button name for close all positions
input string           InpName_delall = "deleteall"; // Button name for delete all pending orders
input string           InpName_setsl = "setstop"; // Button name for setting sl 
input string           InpName_settp = "setprofit"; // Button name for setting tp


input ENUM_BASE_CORNER InpCorner0 = CORNER_RIGHT_LOWER; // Chart corner for anchoring
input ENUM_BASE_CORNER InpCorner1 = CORNER_LEFT_LOWER; // Chart corner for anchoring
input string           InpFont = "ESSTIXThirteen"; // Font
input int              InpFontSize = 14; // Font size
input color            InpColor = clrBlack; // Text color
input color            InpBackColor = clrRed; // Background color
input color            InpBorderColor = clrNONE; // Border color
input bool             InpState = false; // Pressed/Released
input bool             InpBack = false; // Background object
input bool             InpSelection = false; // Highlight to move
input bool             InpHidden = true; // Hidden in the object list
input long             InpZOrder = 0; // Priority for mouse click

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    
    // Create the button for close all positions
    if (!ButtonCreate(0, InpName_clsall, 0, 100, 40, 100, 40, InpCorner0, "closeall", InpFont, InpFontSize,
                      InpColor, InpBackColor, InpBorderColor, InpState, InpBack, InpSelection, InpHidden, InpZOrder))
    {
        Print("Failed to create the button 1!");
        return INIT_FAILED;
    }
    else
    {
        Print("Button 1 created successfully!");
    }
    
    // Create the button for delete all pending orders 
    if (!ButtonCreate(0, InpName_delall, 0, 0, 25, 70, 25, InpCorner1, "del", InpFont, InpFontSize,
                      InpColor, InpBackColor, InpBorderColor, InpState, InpBack, InpSelection, InpHidden, InpZOrder))
    {
        Print("Failed to create the button 2!");
        return INIT_FAILED;
    }
    else
    {
        Print("Button 2 created successfully!");
    }

    // Create the button for setting sl 
    if (!ButtonCreate(0, InpName_setsl, 0, 140, 25, 70, 25, InpCorner1, "sl", InpFont, InpFontSize,
                      InpColor, InpBackColor, InpBorderColor, InpState, InpBack, InpSelection, InpHidden, InpZOrder))
    {
        Print("Failed to create the button 3!");
        return INIT_FAILED;
    }
    else
    {
        Print("Button 3 created successfully!");
    }
  
    // Create the button for setting tp 
    if (!ButtonCreate(0, InpName_settp, 0, 280, 25, 70, 25, InpCorner1, "tp", InpFont, InpFontSize,
                      InpColor, InpBackColor, InpBorderColor, InpState, InpBack, InpSelection, InpHidden, InpZOrder))
    {
        Print("Failed to create the button 4!");
        return INIT_FAILED;
    }
    else
    {
        Print("Button 4 created successfully!");
    }
    
    // Create Edit Box for sl
    if (!CreateEditBox(70,25,"boxsl"))
    {
        Print("Failed to create Edit Box.");
        return INIT_FAILED;
    }
    else
    {
        Print("boxsl created successfully!");
    }
    
    // Create Edit Box for tp
    if (!CreateEditBox(210,25,"boxtp"))
    {
        Print("Failed to create Edit Box.");
        return INIT_FAILED;
    }
    else
    {
        Print("boxtp created successfully!");
    }
    
    // Redraw the chart
    ChartRedraw();

    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{  
    if (ObjectFind(0, InpName_clsall) >= 0)
    {
        ObjectDelete(0, InpName_clsall);  // Delete the 'closeall' button
        Print("Button 'closeall' deleted!");
    }

    if (ObjectFind(0, InpName_setsl) >= 0)
    {
        ObjectDelete(0, InpName_setsl);   // Delete the 'setsl' button
        Print("Button 'setsl' deleted!");
    }
    
    if (ObjectFind(0, InpName_delall) >= 0)
    {
        ObjectDelete(0, InpName_delall);  // Delete the 'closeall' button
        Print("Button 'deleteall' deleted!");
    }

    if (ObjectFind(0, InpName_settp) >= 0)
    {
        ObjectDelete(0, InpName_settp);   // Delete the 'setsl' button
        Print("Button 'settp' deleted!");
    }
    
    if (ObjectFind(0, "boxsl") >= 0)
    {
        ObjectDelete(0, "boxsl");  // Delete the 'closeall' button
        Print("Button 'sl_box' deleted!");
    }

    if (ObjectFind(0, "boxtp") >= 0)
    {
        ObjectDelete(0, "boxtp");   // Delete the 'setsl' button
        Print("Button 'tp_box' deleted!");
    }
    
    //EventKillTimer();
}


//+------------------------------------------------------------------+
//| Handle chart event (button click and key down)                    |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,                // Event identifier
                  const long &lparam,          // First parameter depending on the event type
                  const double &dparam,        // Second parameter depending on the event type
                  const string &sparam)        // Third parameter depending on the event type
{
    // Handle mouse click events on a graphical object
    if(id == CHARTEVENT_OBJECT_CLICK)
    {
        Print("Clicking a mouse button on an object named '" + sparam + "'");
        // Check if the clicked object is one of the buttons and handle accordingly
        if(sparam == InpName_clsall)
        {
            Print("Button 'closeall' was pressed");
            closeAllPositions(); 
        }
        
        else if(sparam == InpName_delall)
        {
            Print("Button 'deleteall' was pressed");
            
        }
        
        else if(sparam == InpName_setsl)
        {
            Print("Button 'setsl' was pressed");

            // Get the text from the object "boxsl"
            string SL_Text = ObjectGetString(0, "boxsl", OBJPROP_TEXT);
    
            // Convert the string to double using StringToDouble
            double price_SL = StringToDouble(SL_Text);
            setStopLossForAllPositions(price_SL);
            // Check if the conversion was successful (i.e., the text was a valid number)
            if (price_SL != 0.0 || SL_Text == "0")  // Allow "0" as a valid value
            {
               Print("Button clicked! boxsl Edit Box text: ", price_SL-0.4);
            }
            else
            {
               Print("Invalid input for SL. Could not convert text to double.");
            }
        }
        
        else if(sparam == InpName_settp)
        {
            Print("Button 'settp' was pressed");

            // Get the text from the object "boxsl"
            string TP_Text = ObjectGetString(0, "boxtp", OBJPROP_TEXT);
    
            // Convert the string to double using StringToDouble
            double price_TP = StringToDouble(TP_Text);
            setTakeProfitForAllPositions(price_TP);
            // Check if the conversion was successful (i.e., the text was a valid number)
            if (price_TP != 0.0 || TP_Text == "0")  // Allow "0" as a valid value
            {
               Print("Button clicked! boxtp Edit Box text: ", price_TP-0.4);
            }
            else
            {
               Print("Invalid input for TP. Could not convert text to double.");
            }
        }


        
        
        
    }
    
}


//+------------------------------------------------------------------+
//| Button creation function                                         |
//+------------------------------------------------------------------+
bool ButtonCreate(const long chart_ID = 0, const string name = "Button", const int sub_window = 0, 
                  const int x = 0, const int y = 0, const int width = 50, const int height = 18, 
                  const ENUM_BASE_CORNER corner = CORNER_RIGHT_LOWER, const string text = "Button", 
                  const string font = "Arial", const int font_size = 10, const color clr = clrBlack, 
                  const color back_clr = C'236,233,216', const color border_clr = clrNONE, 
                  const bool state = false, const bool back = false, const bool selection = false, 
                  const bool hidden = true, const long z_order = 0)
{
    ResetLastError();

    if (!ObjectCreate(chart_ID, name, OBJ_BUTTON, sub_window, 0, 0))
    {
        Print(__FUNCTION__, ": failed to create the button! Error code = ", GetLastError());
        return false;
    }

    // Set button properties
    ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
    ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
    ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
    ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
    ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
    ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
    ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
    ObjectSetInteger(chart_ID, name, OBJPROP_STATE, state);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);

    return true;
}


//+------------------------------------------------------------------+
//| Create an Edit Box at the left lower corner of the chart         |
//+------------------------------------------------------------------+
bool CreateEditBox(int x, int y, string edit_name = "box")
{
    // Coordinates for left lower corner
    //int x = 75; // X position (20 pixels from the left)
    //int y = 30; // Y position (50 pixels from the bottom)

    // Create Edit object
    if (!ObjectCreate(0, edit_name, OBJ_EDIT, 0, 0, 0))
    {
        Print("Error creating Edit Box: ", GetLastError());
        return false;
    }

    // Set properties for Edit Box
    ObjectSetInteger(0, edit_name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, edit_name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, edit_name, OBJPROP_XSIZE, 70);    // Width of the Edit Box
    ObjectSetInteger(0, edit_name, OBJPROP_YSIZE, 30);     // Height of the Edit Box
    ObjectSetInteger(0, edit_name, OBJPROP_CORNER, CORNER_LEFT_LOWER);
    ObjectSetString(0, edit_name, OBJPROP_TEXT, 0); // Initial text
    ObjectSetString(0, edit_name, OBJPROP_FONT, "Arial");    // Font
    ObjectSetInteger(0, edit_name, OBJPROP_FONTSIZE, 12);    // Font size
    ObjectSetInteger(0, edit_name, OBJPROP_COLOR, clrBlack); // Text color
    ObjectSetInteger(0, edit_name, OBJPROP_BGCOLOR, clrWhite); // Background color

    return true;
}


void closeAllPositions()
{
    ulong st = GetMicrosecondCount();

    CTrade sTrade;
    sTrade.SetAsyncMode(true);      // true:Async, false:Sync

    for(int cnt = PositionsTotal()-1; cnt >= 0 && !IsStopped(); cnt-- )
    {
        if(PositionGetTicket(cnt))
        {
            sTrade.PositionClose(PositionGetInteger(POSITION_TICKET),100);
            uint code = sTrade.ResultRetcode();
            Print(IntegerToString(code));
        }
    }
        
    
}


int setStopLossForAllPositions(double stopLossPrice)
{
    CTrade sTrade;
    sTrade.SetAsyncMode(true); // true: Async, false: Sync

    // Iterate through all open positions
    for(int cnt = PositionsTotal() - 1; cnt >= 0 && !IsStopped(); cnt--)
    {
        if(PositionGetTicket(cnt))
        {
            ulong ticket = PositionGetInteger(POSITION_TICKET);  // Get the ticket number of the position
            double openPrice = PositionGetDouble(POSITION_PRICE_OPEN); // Get the open price of the position
            int positionType = PositionGetInteger(POSITION_TYPE); // Get position type (BUY/SELL)
            double currentTP = PositionGetDouble(POSITION_TP); // Get the current take profit

            // Calculate stop loss based on the position type (BUY or SELL)
            // For BUY positions, stop loss should be below the entry price
            // For SELL positions, stop loss should be above the entry price
            double stopLoss = stopLossPrice;

            if(positionType == POSITION_TYPE_BUY)
            {
                // For BUY: The stop loss should be below the open price, so make sure stopLoss is less than openPrice
                if(stopLoss >= openPrice) {
                    continue; // Skip this position if the stop loss is not valid
                }
            }
            else if(positionType == POSITION_TYPE_SELL)
            {
                // For SELL: The stop loss should be above the open price, so make sure stopLoss is greater than openPrice
                if(stopLoss <= openPrice) {
                    continue; // Skip this position if the stop loss is not valid
                }
            }

            // Modify the position to set the stop loss and preserve the current take profit
            sTrade.PositionModify(ticket, stopLoss, currentTP); // Preserve the current TP value
        }
    }

    return 1; // Return after completing the loop
}
int setTakeProfitForAllPositions(double takeProfitPrice)
{
    CTrade sTrade;
    sTrade.SetAsyncMode(true);

    // Iterate through all open positions
    for(int cnt = PositionsTotal() - 1; cnt >= 0 && !IsStopped(); cnt--)
    {
        if(PositionGetTicket(cnt))
        {
            ulong ticket = PositionGetInteger(POSITION_TICKET);  
            double openPrice = PositionGetDouble(POSITION_PRICE_OPEN); 
            int positionType = PositionGetInteger(POSITION_TYPE); 
            double stopLoss = PositionGetDouble(POSITION_SL); 
            double takeProfit = takeProfitPrice; 

            // Modify the position to set the take profit and preserve the current stop loss
            sTrade.PositionModify(ticket, stopLoss, takeProfit); 
        }
    }

    return 1; // Return after completing the loop
}
