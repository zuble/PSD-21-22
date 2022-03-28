
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name psdlab3 -dir "C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/impl/planAhead_run_2" -part xc6slx45csg324-3
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/impl/s6base_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/impl} }
set_property target_constrs_file "C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/src/data/s6base.ucf" [current_fileset -constrset]
add_files [list {C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/src/data/s6base.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/impl/s6base_top.ncd"
if {[catch {read_twx -name results_1 -file "C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/impl/s6base_top.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"C:/usr/jca/FEUP/FEUP/Aulas/2020-2021/Projeto_Sistemas_Digitais_2021/Labs/Lab23/lab3/impl/s6base_top.twx\": $eInfo"
}
