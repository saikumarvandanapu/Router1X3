###############################################################################
# Lab 1 - Reading RTL
# Script: run.tcl
###############################################################################
#setting library

source -echo ./setup.tcl

#Creating Design Library
create_lib -technology $TECH_FILE -ref_libs $REFERENCE_LIBRARY router1x3.dlib

#Reading RTL
analyze -format verilog [glob rtl/*.v]
elaborate router_top
set_top_module router_top

#reading TLU+ files
read_parasitic_tech -layermap ../ref/tech/saed32nm_tf_itf_tluplus.map -tlup ../ref/tech/saed32nm_1p9m_Cmax.lv.nxtgrd -name maxTLU
read_parasitic_tech -layermap ../ref/tech/saed32nm_tf_itf_tluplus.map -tlup ../ref/tech/saed32nm_1p9m_Cmin.lv.nxtgrd -name minTLU

#upf
load_upf ./design_data/router_core.upf
commit_upf

#MCMM
source -echo ./design_data/mcmm_router.tcl

#Reading SDC
read_sdc ./constraints/router.sdc

#missing scandef
set_app_options -list {place.coarse.continue_on_missing_scandef {true}}

#COMPILE FLOW STAGES
compile_fusion
#or
compile_fusion -from initial_map -to initial_map
compile_fusion -from logic_opto -to logic_opto

#floor planning
initialize_floorplan -boundary {{-111.523 -16.268} {-30.013 136.513}} -core_offset {2}
set_app_options -name place.coarse.fix_hard_macros -value false
set_app_options -name plan.place.auto_create_blockages -value auto
create_placement -floorplan


compile_fusion -from initial_place -to initial_place
compile_fusion -from initial_drc -to initial_drc
compile_fusion -from initial_opto -to initial_opto
compile_fusion -from final_place -to final_place
compile_fusion -from final_opto -to final_opto

#power planning
source -echo ./scripts/pns.tcl


#placement
place_pins -self
check_design -checks pre_placement_stage
place_opt


#cts
set_clock_tree_options -target_skew 0.05 -corners [get_corners ss*]

set CTS_CELLS [get_lib_cells "*/NBUFF*LVT */NBUFF*RVT */INVX*_LVT */INVX*_RVT */CGL* */LSUP* */*DFF*"]
set_dont_touch $CTS_CELLS false
set_lib_cell_purpose -exclude cts [get_lib_cells] 
set_lib_cell_purpose -include cts $CTS_CELLS

source -echo ./scripts/ndr.tcl

clock_opt

#routing

###antenna file###
source -echo ./ref/tech/saed32nm_ant_1p9m.tcl

set_app_options -name route.track.timing_driven     -value true
set_app_options -name route.track.crosstalk_driven  -value true
set_app_options -name route.detail.timing_driven    -value true
set_app_options -name route.detail.force_max_number_iterations -value false

route_auto
route_opt
route_eco
