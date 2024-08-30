vlib work
vlog Automatic_Garage_Door_Controller.v Automatic_Garage_Door_Controller_TB.v
vsim -voptargs=+accs work.Automatic_Garage_Door_Controller_TB
add wave *
run -all