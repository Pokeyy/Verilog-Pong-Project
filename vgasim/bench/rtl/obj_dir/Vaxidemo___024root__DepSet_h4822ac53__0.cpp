// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vaxidemo.h for the primary calling header

#include "Vaxidemo__pch.h"
#include "Vaxidemo__Syms.h"
#include "Vaxidemo___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vaxidemo___024root___dump_triggers__ico(Vaxidemo___024root* vlSelf);
#endif  // VL_DEBUG

void Vaxidemo___024root___eval_triggers__ico(Vaxidemo___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vaxidemo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vaxidemo___024root___eval_triggers__ico\n"); );
    // Body
    vlSelf->__VicoTriggered.set(0U, (IData)(vlSelf->__VicoFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vaxidemo___024root___dump_triggers__ico(vlSelf);
    }
#endif
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vaxidemo___024root___dump_triggers__act(Vaxidemo___024root* vlSelf);
#endif  // VL_DEBUG

void Vaxidemo___024root___eval_triggers__act(Vaxidemo___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vaxidemo__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vaxidemo___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->i_clk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__i_clk__0))));
    vlSelf->__VactTriggered.set(1U, (((~ (IData)(vlSelf->axidemo__DOT____Vcellinp__memcontrol__S_AXI_ARESETN)) 
                                      & (IData)(vlSelf->__Vtrigprevexpr___TOP__axidemo__DOT____Vcellinp__memcontrol__S_AXI_ARESETN__0)) 
                                     | ((IData)(vlSelf->i_pixclk) 
                                        & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__i_pixclk__0)))));
    vlSelf->__VactTriggered.set(2U, (((~ (IData)(vlSelf->axidemo__DOT____Vcellinp__memcontrol__S_AXI_ARESETN)) 
                                      & (IData)(vlSelf->__Vtrigprevexpr___TOP__axidemo__DOT____Vcellinp__memcontrol__S_AXI_ARESETN__0)) 
                                     | ((IData)(vlSelf->i_clk) 
                                        & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__i_clk__0)))));
    vlSelf->__VactTriggered.set(3U, (((~ (IData)(vlSelf->axidemo__DOT__video__DOT__pix_reset_n)) 
                                      & (IData)(vlSelf->__Vtrigprevexpr___TOP__axidemo__DOT__video__DOT__pix_reset_n__0)) 
                                     | ((IData)(vlSelf->i_pixclk) 
                                        & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__i_pixclk__0)))));
    vlSelf->__VactTriggered.set(4U, ((IData)(vlSelf->i_pixclk) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__i_pixclk__0))));
    vlSelf->__Vtrigprevexpr___TOP__i_clk__0 = vlSelf->i_clk;
    vlSelf->__Vtrigprevexpr___TOP__axidemo__DOT____Vcellinp__memcontrol__S_AXI_ARESETN__0 
        = vlSelf->axidemo__DOT____Vcellinp__memcontrol__S_AXI_ARESETN;
    vlSelf->__Vtrigprevexpr___TOP__i_pixclk__0 = vlSelf->i_pixclk;
    vlSelf->__Vtrigprevexpr___TOP__axidemo__DOT__video__DOT__pix_reset_n__0 
        = vlSelf->axidemo__DOT__video__DOT__pix_reset_n;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vaxidemo___024root___dump_triggers__act(vlSelf);
    }
#endif
}
