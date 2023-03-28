module WB2APB_sva (
      WB2APB_interface vif
);
    property P_WB2APBV_EMERGENCY_UP;
        @(posedge vif.clk) disable iff (vif.reset_n == 0)
        (vif.emergency == 1) & (vif.elv_status == 2'b01) |->
        (vif.door_control == 5'b0) [*0:$] ##1
        (vif.door_control == $past(vif.current_floor) + 1'b1);
    endproperty
    AP_WB2APBV_EMERGENCY_UP: assert property(P_WB2APBV_EMERGENCY_UP)
        else $display("SVA_ERROR: AP_WB2APBV_EMERGENCY_STOP");

    property P_WB2APBV_EMERGENCY_DOWN;
        @(posedge vif.clk) disable iff (vif.reset_n == 0)
        (vif.emergency == 1) & (vif.elv_status == 2'b10) |->
        (vif.door_control == 5'b0) [*0:$] ##1
        (vif.door_control == vif.current_floor);
    endproperty
    AP_WB2APBV_EMERGENCY_DOWN: assert property(P_WB2APBV_EMERGENCY_DOWN)
        else $display("SVA_ERROR: AP_WB2APBV_EMERGENCY_STOP");


//To start ERROR response, HREADY is driven LOW. In the next cycle, it is driven HIGH.  HRESP keeps HIGH two-cycles

    property P_WB2APBV_GO_UP(logic up, cur_floor, door_control);
        @(posedge vif.clk) disable iff(vif.reset_n==0)
        (up == 1) [*0:$] |->
        (cur_floor & (vif.elv_status == 2'b01) & door_control);
    endproperty

    AP_WB2APBV_GO_UP_1: assert property(P_WB2APBV_GO_UP(vif.up[0], vif.current_floor[0], vif.door_control[0]));
    AP_WB2APBV_GO_UP_2: assert property(P_WB2APBV_GO_UP(vif.up[1], vif.current_floor[1], vif.door_control[1]));
    AP_WB2APBV_GO_UP_3: assert property(P_WB2APBV_GO_UP(vif.up[2], vif.current_floor[2], vif.door_control[2]));
    AP_WB2APBV_GO_UP_4: assert property(P_WB2APBV_GO_UP(vif.up[3], vif.current_floor[3], vif.door_control[3]));

    property P_WB2APBV_GO_DOWM(logic down, cur_floor, door_control);
        @(posedge vif.clk) disable iff(vif.reset_n==0)
        (down == 1) [*0:$] |->
        (cur_floor & (vif.elv_status == 2'b10) & door_control);
    endproperty
    
    
    AP_WB2APBV_GO_DOWN_5: assert property(P_WB2APBV_GO_DOWM(vif.down[3], vif.current_floor[4], vif.door_control[4]));
    AP_WB2APBV_GO_DOWN_4: assert property(P_WB2APBV_GO_DOWM(vif.down[2], vif.current_floor[3], vif.door_control[3]));
    AP_WB2APBV_GO_DOWN_3: assert property(P_WB2APBV_GO_DOWM(vif.down[1], vif.current_floor[2], vif.door_control[2]));
    AP_WB2APBV_GO_DOWN_2: assert property(P_WB2APBV_GO_DOWM(vif.down[0], vif.current_floor[1], vif.door_control[1]));


    // property AP_EMERGENCY_DONE;
    //     @(posedge vif.clk) disable iff(vif.reset_n==0)
    //     (vif.emergency == 1 & moving_done==1 ) [*0:$] |->
    //     ( (vif.elv_status == 2'b11) & vif.door_control==vif.current_floor );
    // endproperty

    // AP_EMERGENCY_DONE_0: assert property(AP_EMERGENCY_DONE);

    property AP_EMERGENCY_UP;
        @(posedge vif.clk) disable iff(vif.reset_n==0)
        (vif.emergency == 1 ) [*0:$] |->
        (vif.elv_status == 2'b01)|->
        (vif.current_floor  & (vif.elv_status == 2'b11) & vif.door_control==vif.current_floor);
    endproperty

    AP_EMERGENCY_UP_0: assert property(AP_EMERGENCY_UP)
    else $display("AP_EMERGENCY_UP fall");

    property AP_EMERGENCY_DOWN;
        @(posedge vif.clk) disable iff(vif.reset_n==0)
        (vif.emergency == 1  ) [*0:$] |->
        (vif.elv_status == 2'b10)|->
        ((vif.elv_status == 2'b11) & vif.door_control==vif.current_floor);
    endproperty

    AP_EMERGENCY_DOWN_0 : assert property(AP_EMERGENCY_DOWN);

    property AP_EMERGENCY_STOP;
        @(posedge vif.clk) disable iff(vif.reset_n==0)
        (vif.emergency == 1 & vif.elv_status== 2'b11 ) [*0:$] |->
        (vif.door_control == vif.current_floor );
    endproperty

    AP_EMERGENCY_STOP_0 : assert property(AP_EMERGENCY_STOP);


    property AP_KEEP_OPEN;
        @(posedge vif.clk) disable iff(vif.reset_n==0)
        $fell(vif.keep_open) [*0:10]  |->
        ($stable(vif.keep_open)&$rose(vif.emergency)&$rose(vif.close))|->
        (vif.door_control==5'b0);
    endproperty

    property AP_CLOSE;
        @(posedge vif.clk) disable iff(vif.reset_n==0)
        (vif.close == 1 & vif.door_control!=0 ) |=>
        (vif.door_control == 5'b0);
    endproperty

    AP_CLOSE_0: assert property(AP_CLOSE);

    property AP_TARGET_FLOOR;//3 cái đều là one-hot
        @(posedge vif.clk) disable iff(vif.reset_n==0)
        (vif.target_floor !=5'b0 ) [*0:$] |->
        (vif.current_floor == vif.target_floor   & vif.door_control == vif.target_floor);
    endproperty

    AP_TARGET_FLOOR_0: assert property(AP_TARGET_FLOOR);

    property AP_DOOR_OPEN(logic door_control);
    // cửa mở thì kiểm tra trong 3 chu ky sau đó nếu không có 
    // tác động gì thì sau 1 chu kỳ là đóng hay không ?
        @(posedge vif.clk) disable iff(vif.reset_n==0)
        (door_control ==1 ) [*0:3] |->
        ~($rose(vif.emergency)& $rose(vif.keep_open)&$rose(vif.close))&$stable(door_control) |=>
        (door_control==0);
    endproperty

    AP_DOOR_OPEN_0: assert property(AP_DOOR_OPEN(vif.door_control[0]));
    AP_DOOR_OPEN_1: assert property(AP_DOOR_OPEN(vif.door_control[1]));
    AP_DOOR_OPEN_2: assert property(AP_DOOR_OPEN(vif.door_control[2]));
    AP_DOOR_OPEN_3: assert property(AP_DOOR_OPEN(vif.door_control[3]));
    AP_DOOR_OPEN_4: assert property(AP_DOOR_OPEN(vif.door_control[4]));




endmodule