connect_pg_net -automatic

create_pg_mesh_pattern mesh_pattern -layers { {{vertical_layer: M6} {width: 0.84} {pitch: 8.4} {spacing: interleaving}}  {{horizontal_layer: M7} {width: 0.84} {pitch: 8.4} {spacing: interleaving}} }
set_pg_strategy mesh_strategy -core -pattern {{pattern: mesh_pattern}{nets: {VDD VSS}}} -blockage {macros: all}

create_pg_std_cell_conn_pattern std_cell_pattern

set_pg_strategy std_cell_strategy -core -pattern {{pattern: std_cell_pattern}{nets: {VDD VSS}}}


compile_pg -ignore_via_drc
