program assertions (logic m_axis_mm2s_tvalid, m_axis_mm2s_tready);
        sequence tvalid
        m_axis_mm2s_tvalid;
        endsequence : tvalid
        
        sequence tready
        ##[1:2] m_axis_mm2s_tready;
        endsequence : tready
        
        property handshake;
        @(posedge axi_aclk) tvalid |-> tready;
        endproperty : handshake
        
        assert property (handshake);
endprogram : assertions