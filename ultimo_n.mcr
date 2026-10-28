#!MC 1410

#$!PAUSE "|NUMZONES|"

$!VarSet |REFZONE| = 1

#------------------------------------------------------------------------------------------------------------------------------
$!PROMPTFORTEXTSTRING |VISUALIZACION|
  INSTRUCTIONS = 'Calculo de variables de ayuda para visualizacion: para hacerlo conteste 1, sino conteste 2'

$!IF |VISUALIZACION| == 1

  $!ALTERDATA [2]
    EQUATION = '{r_xy [m]} = SQRT({x} ** 2 + {y} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{r_yz [m]} = SQRT({y} ** 2 + {z} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{r_zx [m]} = SQRT({z} ** 2 + {x} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{plano_xy [º]} = atan2({y},{x}) * 180 / PI'
  $!ALTERDATA [2]
    EQUATION = '{plano_yz [º]} = atan2({z},{y}) * 180 / PI'
  $!ALTERDATA [2]
    EQUATION = '{plano_zx [º]} = atan2({x},{z}) * 180 / PI'

  $!ELSE

$!ENDIF

$!ALTERDATA [2]
  EQUATION = '{yz_cambiado} = IF({plano_yz [º]} > (-15), {plano_yz [º]} + 15, 180 + (180 + {plano_yz [º]}) + 15)'

$!LOOP |NUMZONES|
  $!VarSet |Z| = (|LOOP|)

  $!ALTERDATA [|Z|]
    EQUATION = '{yz_cambiado} = {yz_cambiado}[2]'

  $!ALTERDATA [|Z|]
    EQUATION = '{p_alabe} = 0'

$!ENDLOOP


#------------------------------------------------------------------------------------------------------------------
$!PROMPTFORTEXTSTRING |Z_1T|
  INSTRUCTIONS = 'Introduce el numero de intervalos de Tecplot para un periodo de vibracion (N-1):'
$!VarSet |Z_1T_BUCLE| = (|Z_1T|)


#$!VarSet |N_DECIMAL| = ((|NUMZONES| - 1) / (|Z_1T| + 1))
#$!PROMPTFORTEXTSTRING |N|
#  INSTRUCTIONS = '|N_decimal|, introduce el valor truncando al entero:'
$!VarSet |Z_ULTIMO_T| = (|NUMZONES| - |Z_1T| + 1)

$!PROMPTFORTEXTSTRING |MASA_MODAL|
  INSTRUCTIONS = 'Introduce el valor de la masa modal:'

$!PROMPTFORTEXTSTRING |FRECUENCIA|
  INSTRUCTIONS = 'Introduce el valor de la frecuencia de vibracion en Hz:'

$!PROMPTFORTEXTSTRING |DESP_MOD_MAX|
  INSTRUCTIONS = 'Introduce el desplazamiento modal maximo:'

#$!VarSet |ZONAS| = (|N| * |Z_1T|)

$!PROMPTFORTEXTSTRING |ARMONICOS|
  INSTRUCTIONS = 'Introduce el numero de armonicos a calcular:'
$!PROMPTFORTEXTSTRING |TIPO_ARMONICOS|
  INSTRUCTIONS = 'Para forma trigonometrica escriba 1, para la compleja 2, para ambas 3'


$!LOOP |NUMZONES|
  $!VarSet |Z| = (|LOOP|)
  
  $!ALTERDATA [|Z|]
    EQUATION = '{dx [m]} = {x} - {x}[|REFZONE|]'
  $!ALTERDATA [|Z|]
    EQUATION = '{dy [m]} = {y} - {y}[|REFZONE|]'
  $!ALTERDATA [|Z|]
    EQUATION = '{dz [m]} = {z} - {z}[|REFZONE|]'
  $!ALTERDATA [|Z|]
    EQUATION = '{d_mod [m]} = SQRT({dx [m]} ** 2 + {dy [m]} ** 2 + {dz [m]} ** 2)'
  $!ALTERDATA [|Z|]
    EQUATION = '{x_ref} = {x}[1]'
  $!ALTERDATA [|Z|]
    EQUATION = '{y_ref} = {y}[1]'
  $!ALTERDATA [|Z|]
    EQUATION = '{z_ref} = {z}[1]'


#  $!ALTERDATA [|Z|]
#    EQUATION = '{p_prueba} = 100000'

$!ENDLOOP


$!LOOP 12
  $!VarSet |A| = (|LOOP|)

  $!LOOP |NUMZONES|
    $!VarSet |Z| = (|LOOP|)

    $!ALTERDATA [|Z|]
      EQUATION = '{p_alabe} = IF ({yz_cambiado} >= 30 * (|A| - 1) && {yz_cambiado} < 30 * |A|, 50000 + 500 * |A| * SIN(2 * PI * |Z| / (|Z_1T|+ 1)), {p_alabe})'

  $!ENDLOOP

$!ENDLOOP



#-------------------------------------------------------------------------------------
$!EXTENDEDCOMMAND
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'GRIDKUNITNORMAL\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'F\' UseMorePointsForFEGradientCalculations=\'F\''


$!ALTERDATA [2]
  EQUATION = '{dx_a_0} = 0'
$!ALTERDATA [2]
  EQUATION = '{dy_a_0} = 0'
$!ALTERDATA [2]
  EQUATION = '{dz_a_0} = 0'
$!ALTERDATA [2]
  EQUATION = '{d_mod_a_0} = 0'
$!ALTERDATA [2]
  EQUATION = '{pressure_a_0 [Pa]} = 0'
$!ALTERDATA [2]
  EQUATION = '{pressure_x_a_0 [Pa]} = 0'
$!ALTERDATA [2]
  EQUATION = '{pressure_y_a_0 [Pa]} = 0'
$!ALTERDATA [2]
  EQUATION = '{pressure_z_a_0 [Pa]} = 0'
#$!ALTERDATA [2]
#  EQUATION = '{p_prueba_a_0 [Pa]} = 0'


$!LOOP |Z_1T|
  $!VarSet |Z| = (|LOOP|)

  $!VarSet |Z_T_GLOBAL| = (|Z_ULTIMO_T| + |Z| - 1)

  $!ALTERDATA [2]
    EQUATION = '{dx_a_0} = {dx_a_0} + {dx [m]}[|Z_T_GLOBAL|]'
  $!ALTERDATA [2]
    EQUATION = '{dy_a_0} = {dy_a_0} + {dy [m]}[|Z_T_GLOBAL|]'
  $!ALTERDATA [2]
    EQUATION = '{dz_a_0} = {dz_a_0} + {dz [m]}[|Z_T_GLOBAL|]'
  $!ALTERDATA [2]
    EQUATION = '{d_mod_a_0} = {d_mod_a_0} + {d_mod [m]}[|Z_T_GLOBAL|]'
  $!ALTERDATA [2]
    EQUATION = '{pressure_a_0 [Pa]} = {pressure_a_0 [Pa]} + {Pressure}[|Z_T_GLOBAL|]'
  $!ALTERDATA [2]
    EQUATION = '{pressure_x_a_0 [Pa]} = {pressure_x_a_0 [Pa]} + {Pressure}[|Z_T_GLOBAL|] * {X Grid K Unit Normal}[|Z_T_GLOBAL|]'
  $!ALTERDATA [2]
    EQUATION = '{pressure_y_a_0 [Pa]} = {pressure_y_a_0 [Pa]} + {Pressure}[|Z_T_GLOBAL|] * {Y Grid K Unit Normal}[|Z_T_GLOBAL|]'
  $!ALTERDATA [2]
    EQUATION = '{pressure_z_a_0 [Pa]} = {pressure_z_a_0 [Pa]} + {Pressure}[|Z_T_GLOBAL|] * {Z Grid K Unit Normal}[|Z_T_GLOBAL|]'
#  $!ALTERDATA [2]
#    EQUATION = '{p_prueba_a_0 [Pa]} = {p_prueba_a_0 [Pa]} + {p_prueba}[|Z_T_GLOBAL|]'

$!ENDLOOP


$!ALTERDATA [2]
  EQUATION = '{dx_a_0} = 1 * {dx_a_0} / |Z_1T|'
$!ALTERDATA [2]
  EQUATION = '{dy_a_0} = 1 * {dy_a_0} / |Z_1T|'
$!ALTERDATA [2]
  EQUATION = '{dz_a_0} = 1 * {dz_a_0} / |Z_1T|'
$!ALTERDATA [2]
  EQUATION = '{d_mod_a_0} = 1 * {d_mod_a_0} / |Z_1T|'
$!ALTERDATA [2]
  EQUATION = '{pressure_a_0 [Pa]} = 1 * {pressure_a_0 [Pa]} / |Z_1T|'
$!ALTERDATA [2]
  EQUATION = '{pressure_x_a_0 [Pa]} = 1 * {pressure_x_a_0 [Pa]} / |Z_1T|'
$!ALTERDATA [2]
  EQUATION = '{pressure_y_a_0 [Pa]} = 1 * {pressure_y_a_0 [Pa]} / |Z_1T|'
$!ALTERDATA [2]
  EQUATION = '{pressure_z_a_0 [Pa]} = 1 * {pressure_z_a_0 [Pa]} / |Z_1T|'
#$!ALTERDATA [2]
#  EQUATION = '{p_prueba_a_0 [Pa]} = 1 * {p_prueba_a_0 [Pa]} / |Z_1T|'

$!LOOP |NUMZONES|
  $!VarSet |Z| = (|LOOP|)

  $!ALTERDATA[|Z|]
    EQUATION = '{dx_a_0} = {dx_a_0}[2]'
  $!ALTERDATA[|Z|]
    EQUATION = '{dy_a_0} = {dy_a_0}[2]'
  $!ALTERDATA[|Z|]
    EQUATION = '{dz_a_0} = {dz_a_0}[2]'
  $!ALTERDATA[|Z|]
    EQUATION = '{d_mod_a_0} = {d_mod_a_0}[2]'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_a_0 [Pa]} = {pressure_a_0 [Pa]}[2]'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_x_a_0 [Pa]} = {pressure_x_a_0 [Pa]}[2]'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_y_a_0 [Pa]} = {pressure_y_a_0 [Pa]}[2]'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_z_a_0 [Pa]} = {pressure_z_a_0 [Pa]}[2]'
 # $!ALTERDATA[|Z|]
 #   EQUATION = '{p_prueba_a_0 [Pa]} = {p_prueba_a_0 [Pa]}[2]'

  $!ALTERDATA[|Z|]
    EQUATION = '{dx_aprox [m]} = 0'
  $!ALTERDATA[|Z|]
    EQUATION = '{dy_aprox [m]} = 0'
  $!ALTERDATA[|Z|]	
    EQUATION = '{dz_aprox [m]} = 0'
  $!ALTERDATA[|Z|]
    EQUATION = '{d_mod_aprox [m]} = 0'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_aprox [Pa]} = 0'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_x_aprox [Pa]} = 0'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_y_aprox [Pa]} = 0'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_z_aprox [Pa]} = 0'

  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_x [Pa]} = {Pressure}[|Z|] * {X Grid K Unit Normal}[|Z|]'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_y [Pa]} = {Pressure}[|Z|] * {Y Grid K Unit Normal}[|Z|]'
  $!ALTERDATA[|Z|]
    EQUATION = '{pressure_z [Pa]} = {Pressure}[|Z|] * {Z Grid K Unit Normal}[|Z|]'


$!ENDLOOP

#-------------------------------------------------------------------------------------
#$!PAUSE "|ARMONICOS|"


$!LOOP |ARMONICOS|
  $!VarSet |I| = (|LOOP|)

  $!VarSet |Z_T| = 0

  $!ALTERDATA [2]
    EQUATION = '{sum_dx_a_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_dx_b_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_dy_a_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_dy_b_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_dz_a_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_dz_b_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_pressure_a_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_pressure_b_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_pressure_x_a_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_pressure_x_b_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_pressure_y_a_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_pressure_y_b_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_pressure_z_a_|I|} = 0'
  $!ALTERDATA [2]
    EQUATION = '{sum_pressure_z_b_|I|} = 0'

#  $!ALTERDATA [2]
#    EQUATION = '{sum_p_prueba_x_a_|I|} = 0'
#  $!ALTERDATA [2]
#    EQUATION = '{sum_p_prueba_x_b_|I|} = 0'
#  $!ALTERDATA [2]
#    EQUATION = '{sum_p_prueba_y_a_|I|} = 0'
#  $!ALTERDATA [2]
#    EQUATION = '{sum_p_prueba_y_b_|I|} = 0'
#  $!ALTERDATA [2]
#    EQUATION = '{sum_p_prueba_z_a_|I|} = 0'
#  $!ALTERDATA [2]
#    EQUATION = '{sum_p_prueba_z_b_|I|} = 0'

  $!ALTERDATA [2]
     EQUATION = '{sum_p_alabe_a_|I|} = 0'
  $!ALTERDATA [2]
     EQUATION = '{sum_p_alabe_b_|I|} = 0'



  $!LOOP |Z_1T|
    $!VarSet |Z| = (|LOOP|)

    $!VarSet |Z_T_GLOBAL| = (|Z_ULTIMO_T| + |Z| - 1)
#    $!PAUSE "|Z_T|"

#    $!IF |Z| > 220
#
#      $!PAUSE "Z = |Z|"
#      $!PAUSE "|Z_T|"
#
#    $!ENDIF


    $!ALTERDATA [2]
      EQUATION = '{sum_dx_a_|I|} = {sum_dx_a_|I|} + {dx [m]}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_dx_b_|I|} = {sum_dx_b_|I|} + {dx [m]}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_dy_a_|I|} = {sum_dy_a_|I|} + {dy [m]}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_dy_b_|I|} = {sum_dy_b_|I|} + {dy [m]}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_dz_a_|I|} = {sum_dz_a_|I|} + {dz [m]}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_dz_b_|I|} = {sum_dz_b_|I|} + {dz [m]}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_pressure_a_|I|} = {sum_pressure_a_|I|} + {Pressure}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_pressure_b_|I|} = {sum_pressure_b_|I|} + {Pressure}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_pressure_x_a_|I|} = {sum_pressure_x_a_|I|} + {Pressure}[|Z_T_GLOBAL|] * {X Grid K Unit Normal}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_pressure_x_b_|I|} = {sum_pressure_x_b_|I|} + {Pressure}[|Z_T_GLOBAL|] * {X Grid K Unit Normal}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_pressure_y_a_|I|} = {sum_pressure_y_a_|I|} + {Pressure}[|Z_T_GLOBAL|] * {Y Grid K Unit Normal}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_pressure_y_b_|I|} = {sum_pressure_y_b_|I|} + {Pressure}[|Z_T_GLOBAL|] * {Y Grid K Unit Normal}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_pressure_z_a_|I|} = {sum_pressure_z_a_|I|} + {Pressure}[|Z_T_GLOBAL|] * {Z Grid K Unit Normal}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_pressure_z_b_|I|} = {sum_pressure_z_b_|I|} + {Pressure}[|Z_T_GLOBAL|] * {Z Grid K Unit Normal}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'


 #   $!ALTERDATA [2]
 #     EQUATION = '{sum_p_prueba_x_a_|I|} = {sum_p_prueba_x_a_|I|} + {p_prueba}[|Z_T_GLOBAL|] * {X Grid K Unit Normal}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
 #   $!ALTERDATA [2]
 #     EQUATION = '{sum_p_prueba_x_b_|I|} = {sum_p_prueba_x_b_|I|} + {p_prueba}[|Z_T_GLOBAL|] * {X Grid K Unit Normal}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'
 #   $!ALTERDATA [2]
 #     EQUATION = '{sum_p_prueba_y_a_|I|} = {sum_p_prueba_y_a_|I|} + {p_prueba}[|Z_T_GLOBAL|] * {Y Grid K Unit Normal}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
 #   $!ALTERDATA [2]
 #     EQUATION = '{sum_p_prueba_y_b_|I|} = {sum_p_prueba_y_b_|I|} + {p_prueba}[|Z_T_GLOBAL|] * {Y Grid K Unit Normal}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'
 #   $!ALTERDATA [2]
 #     EQUATION = '{sum_p_prueba_z_a_|I|} = {sum_p_prueba_z_a_|I|} + {p_prueba}[|Z_T_GLOBAL|] * {Z Grid K Unit Normal}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
 #   $!ALTERDATA [2]
 #     EQUATION = '{sum_p_prueba_z_b_|I|} = {sum_p_prueba_z_b_|I|} + {p_prueba}[|Z_T_GLOBAL|] * {Z Grid K Unit Normal}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'


    $!ALTERDATA [2]
      EQUATION = '{sum_p_alabe_a_|I|} = {sum_p_alabe_a_|I|} + {p_alabe}[|Z_T_GLOBAL|] * COS(2 * PI * |I| * |Z_T| / |Z_1T|)'
    $!ALTERDATA [2]
      EQUATION = '{sum_p_alabe_b_|I|} = {sum_p_alabe_b_|I|} + {p_alabe}[|Z_T_GLOBAL|] * SIN(2 * PI * |I| * |Z_T| / |Z_1T|)'


    $!VarSet |Z_T| = (|Z_T| + 1)


  $!ENDLOOP


  $!ALTERDATA [2]
    EQUATION = '{dx_a_|I| [m]} = 2 * {sum_dx_a_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_dx_a|
  NAME = "sum_dx_a_|I|"
  $!DELETEVARS [|sum_dx_a|]

  $!ALTERDATA [2]
    EQUATION = '{dx_b_|I| [m]} = 2 * {sum_dx_b_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_dx_b|
  NAME = "sum_dx_b_|I|"
  $!DELETEVARS [|sum_dx_b|]

  $!ALTERDATA [2]
    EQUATION = '{dy_a_|I| [m]} = 2 * {sum_dy_a_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_dy_a|
  NAME = "sum_dy_a_|I|"
  $!DELETEVARS [|sum_dy_a|]

  $!ALTERDATA [2]
    EQUATION = '{dy_b_|I| [m]} = 2 * {sum_dy_b_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_dy_b|
  NAME = "sum_dy_b_|I|"
  $!DELETEVARS [|sum_dy_b|]

  $!ALTERDATA [2]
    EQUATION = '{dz_a_|I| [m]} = 2 * {sum_dz_a_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_dz_a|
  NAME = "sum_dz_a_|I|"
  $!DELETEVARS [|sum_dz_a|]

  $!ALTERDATA [2]
    EQUATION = '{dz_b_|I| [m]} = 2 * {sum_dz_b_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_dz_b|
  NAME = "sum_dz_b_|I|"
  $!DELETEVARS [|sum_dz_b|]

  $!ALTERDATA [2]
    EQUATION = '{pressure_a_|I| [Pa]} = 2 * {sum_pressure_a_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_pressure_a|
  NAME = "sum_pressure_a_|I|"
  $!DELETEVARS [|sum_pressure_a|]

  $!ALTERDATA [2]
    EQUATION = '{pressure_b_|I| [Pa]} = 2 * {sum_pressure_b_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_pressure_b|
  NAME = "sum_pressure_b_|I|"
  $!DELETEVARS [|sum_pressure_b|]

  $!ALTERDATA [2]
    EQUATION = '{pressure_x_a_|I| [Pa]} = 2 * {sum_pressure_x_a_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_pressure_x_a|
  NAME = "sum_pressure_x_a_|I|"
  $!DELETEVARS [|sum_pressure_x_a|]

  $!ALTERDATA [2]
    EQUATION = '{pressure_x_b_|I| [Pa]} = 2 * {sum_pressure_x_b_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_pressure_x_b|
  NAME = "sum_pressure_x_b_|I|"
  $!DELETEVARS [|sum_pressure_x_b|]

  $!ALTERDATA [2]
    EQUATION = '{pressure_y_a_|I| [Pa]} = 2 * {sum_pressure_y_a_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_pressure_y_a|
  NAME = "sum_pressure_y_a_|I|"
  $!DELETEVARS [|sum_pressure_y_a|]

  $!ALTERDATA [2]
    EQUATION = '{pressure_y_b_|I| [Pa]} = 2 * {sum_pressure_y_b_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_pressure_y_b|
  NAME = "sum_pressure_y_b_|I|"
  $!DELETEVARS [|sum_pressure_y_b|]

  $!ALTERDATA [2]
    EQUATION = '{pressure_z_a_|I| [Pa]} = 2 * {sum_pressure_z_a_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_pressure_z_a|
  NAME = "sum_pressure_z_a_|I|"
  $!DELETEVARS [|sum_pressure_z_a|]

  $!ALTERDATA [2]
    EQUATION = '{pressure_z_b_|I| [Pa]} = 2 * {sum_pressure_z_b_|I|} / (|Z_1T|)'
  $!GETVARNUMBYNAME |sum_pressure_z_b|
  NAME = "sum_pressure_z_b_|I|"
  $!DELETEVARS [|sum_pressure_z_b|]




#  $!ALTERDATA [2]
#    EQUATION = '{p_prueba_x_a_|I| [Pa]} = 2 * {sum_p_prueba_x_a_|I|} / (|Z_1T|)'
#  $!ALTERDATA [2]
#    EQUATION = '{p_prueba_x_b_|I| [Pa]} = 2 * {sum_p_prueba_x_b_|I|} / (|Z_1T|)'
#  $!ALTERDATA [2]
#    EQUATION = '{modulo_p_prueba_x_|I|} = SQRT({p_prueba_x_a_|I| [Pa]} ** 2 + {p_prueba_x_b_|I| [Pa]} ** 2)'
#  $!ALTERDATA [2]
#    EQUATION = '{p_prueba_y_a_|I| [Pa]} = 2 * {sum_p_prueba_y_a_|I|} / (|Z_1T|)'
#  $!ALTERDATA [2]
#    EQUATION = '{p_prueba_y_b_|I| [Pa]} = 2 * {sum_p_prueba_y_b_|I|} / (|Z_1T|)'
#  $!ALTERDATA [2]
#    EQUATION = '{modulo_p_prueba_y_|I|} = SQRT({p_prueba_y_a_|I| [Pa]} ** 2 + {p_prueba_y_b_|I| [Pa]} ** 2)'
#  $!ALTERDATA [2]
#    EQUATION = '{p_prueba_z_a_|I| [Pa]} = 2 * {sum_p_prueba_z_a_|I|} / (|Z_1T|)'
#  $!ALTERDATA [2]
#    EQUATION = '{p_prueba_z_b_|I| [Pa]} = 2 * {sum_p_prueba_z_b_|I|} / (|Z_1T|)'
#  $!ALTERDATA [2]
#    EQUATION = '{modulo_p_prueba_z_|I|} = SQRT({p_prueba_z_a_|I| [Pa]} ** 2 + {p_prueba_z_b_|I| [Pa]} ** 2)'


  $!ALTERDATA [2]
    EQUATION = '{p_alabe_a_|I| [Pa]} = 2 * {sum_p_alabe_a_|I|} / (|Z_1T|)'
  $!ALTERDATA [2]
    EQUATION = '{p_alabe_b_|I| [Pa]} = 2 * {sum_p_alabe_b_|I|} / (|Z_1T|)'


$!ENDLOOP


$!LOOP |ARMONICOS|
  $!VarSet |I| = (|LOOP|)

  $!ALTERDATA [2]
    EQUATION = '{dx_Re_|I| [m]} = {dx_a_|I| [m]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{dx_Im_|I| [m]} = - {dx_b_|I| [m]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{modulo_dx_|I| [m]} = SQRT({dx_a_|I| [m]} ** 2 + {dx_b_|I| [m]} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{dy_Re_|I| [m]} = {dy_a_|I| [m]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{dy_Im_|I| [m]} = - {dy_b_|I| [m]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{modulo_dy_|I| [m]} = SQRT({dy_a_|I| [m]} ** 2 + {dy_b_|I| [m]} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{dz_Re_|I| [m]} = {dz_a_|I| [m]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{dz_Im_|I| [m]} = - {dz_b_|I| [m]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{modulo_dz_|I| [m]} = SQRT({dz_a_|I| [m]} ** 2 + {dz_b_|I| [m]} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{modulo_d_total_|I| [m]} = SQRT({modulo_dx_|I| [m]} ** 2 + {modulo_dy_|I| [m]} ** 2 + {modulo_dz_|I| [m]} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{pressure_Re_|I| [Pa]} = {pressure_a_|I| [Pa]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{pressure_Im_|I| [Pa]} = - {pressure_b_|I| [Pa]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{modulo_pressure_|I| [Pa]} = SQRT({pressure_a_|I| [Pa]} ** 2 + {pressure_b_|I| [Pa]} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{fase_d_pressure_|I| [rad]} = atan2({pressure_Im_|I| [Pa]},{pressure_Re_|I| [Pa]})'

  $!ALTERDATA [2]
    EQUATION = '{pressure_x_Re_|I| [Pa]} = {pressure_x_a_|I| [Pa]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{pressure_x_Im_|I| [Pa]} = - {pressure_x_b_|I| [Pa]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{modulo_pressure_x_|I| [Pa]} = SQRT({pressure_x_a_|I| [Pa]} ** 2 + {pressure_x_b_|I| [Pa]} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{pressure_y_Re_|I| [Pa]} = {pressure_y_a_|I| [Pa]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{pressure_y_Im_|I| [Pa]} = - {pressure_y_b_|I| [Pa]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{modulo_pressure_y_|I| [Pa]} = SQRT({pressure_y_a_|I| [Pa]} ** 2 + {pressure_y_b_|I| [Pa]} ** 2)'
  $!ALTERDATA [2]
    EQUATION = '{pressure_z_Re_|I| [Pa]} = {pressure_z_a_|I| [Pa]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{pressure_z_Im_|I| [Pa]} = - {pressure_z_b_|I| [Pa]} / 2'
  $!ALTERDATA [2]
    EQUATION = '{modulo_pressure_z_|I| [Pa]} = SQRT({pressure_z_a_|I| [Pa]} ** 2 + {pressure_z_b_|I| [Pa]} ** 2)'


  $!ALTERDATA [2]
    EQUATION = '{modulo_p_alabe_|I| [Pa]} = SQRT({p_alabe_a_|I| [Pa]} ** 2 + {p_alabe_b_|I| [Pa]} ** 2)'


$!ENDLOOP


#-------------------------------------------------------------------------------------

$!LOOP |ARMONICOS|
  $!VarSet |I| = (|LOOP|)

  $!VarSet |Z_T| = 0

  $!LOOP |Z_1T|
    $!VarSet |Z| = (|LOOP|)

    $!VarSet |Z_T_GLOBAL| = (|Z_ULTIMO_T| + |Z| - 1)

    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_dx_a_|I|} = {dx_a_|I| [m]}[2] * COS(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_dx_b_|I|} = {dx_b_|I| [m]}[2] * SIN(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{dx_aprox [m]} = {dx_aprox [m]} + {cont_dx_a_|I|} + {cont_dx_b_|I|}'

    $!GETVARNUMBYNAME |cont_dx_a|
    NAME = "cont_dx_a_|I|"
    $!DELETEVARS [|cont_dx_a|]

    $!GETVARNUMBYNAME |cont_dx_b|
    NAME = "cont_dx_b_|I|"
    $!DELETEVARS [|cont_dx_b|]


    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_dy_a_|I|} = {dy_a_|I| [m]}[2] * COS(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_dy_b_|I|} = {dy_b_|I| [m]}[2] * SIN(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{dy_aprox [m]} = {dy_aprox [m]} + {cont_dy_a_|I|} + {cont_dy_b_|I|}'

    $!GETVARNUMBYNAME |cont_dy_a|
    NAME = "cont_dy_a_|I|"
    $!DELETEVARS [|cont_dy_a|]

    $!GETVARNUMBYNAME |cont_dy_b|
    NAME = "cont_dy_b_|I|"
    $!DELETEVARS [|cont_dy_b|]    


    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_dz_a_|I|} = {dz_a_|I| [m]}[2] * COS(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_dz_b_|I|} = {dz_b_|I| [m]}[2] * SIN(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{dz_aprox [m]} = {dz_aprox [m]} + {cont_dz_a_|I|} + {cont_dz_b_|I|}'
    
    $!GETVARNUMBYNAME |cont_dz_a|
    NAME = "cont_dz_a_|I|"
    $!DELETEVARS [|cont_dz_a|]

    $!GETVARNUMBYNAME |cont_dz_b|
    NAME = "cont_dz_b_|I|"
    $!DELETEVARS [|cont_dz_b|]    


    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_pressure_a_|I|} = {pressure_a_|I| [Pa]}[2] * COS(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_pressure_b_|I|} = {pressure_b_|I| [Pa]}[2] * SIN(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{pressure_aprox [Pa]} = {pressure_aprox [Pa]} + {cont_pressure_a_|I|} + {cont_pressure_b_|I|}'

    $!GETVARNUMBYNAME |cont_pressure_a|
    NAME = "cont_pressure_a_|I|"
    $!DELETEVARS [|cont_pressure_a|]

    $!GETVARNUMBYNAME |cont_pressure_b|
    NAME = "cont_pressure_b_|I|"
    $!DELETEVARS [|cont_pressure_b|]


    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_pressure_x_a_|I|} = {pressure_x_a_|I| [Pa]}[2] * COS(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_pressure_x_b_|I|} = {pressure_x_b_|I| [Pa]}[2] * SIN(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{pressure_x_aprox [Pa]} = {pressure_x_aprox [Pa]} + {cont_pressure_x_a_|I|} + {cont_pressure_x_b_|I|}'

    $!GETVARNUMBYNAME |cont_pressure_x_a|
    NAME = "cont_pressure_x_a_|I|"
    $!DELETEVARS [|cont_pressure_x_a|]

    $!GETVARNUMBYNAME |cont_pressure_x_b|
    NAME = "cont_pressure_x_b_|I|"
    $!DELETEVARS [|cont_pressure_x_b|]


    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_pressure_y_a_|I|} = {pressure_y_a_|I| [Pa]}[2] * COS(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_pressure_y_b_|I|} = {pressure_y_b_|I| [Pa]}[2] * SIN(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{pressure_y_aprox [Pa]} = {pressure_y_aprox [Pa]} + {cont_pressure_y_a_|I|} + {cont_pressure_y_b_|I|}'

    $!GETVARNUMBYNAME |cont_pressure_y_a|
    NAME = "cont_pressure_y_a_|I|"
    $!DELETEVARS [|cont_pressure_y_a|]

    $!GETVARNUMBYNAME |cont_pressure_y_b|
    NAME = "cont_pressure_y_b_|I|"
    $!DELETEVARS [|cont_pressure_y_b|]


    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_pressure_z_a_|I|} = {pressure_z_a_|I| [Pa]}[2] * COS(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{cont_pressure_z_b_|I|} = {pressure_z_b_|I| [Pa]}[2] * SIN(2 * PI * |I| * |Z_T| / (|Z_1T|))'
    $!ALTERDATA [|Z_T_GLOBAL|]
      EQUATION = '{pressure_z_aprox [Pa]} = {pressure_z_aprox [Pa]} + {cont_pressure_z_a_|I|} + {cont_pressure_z_b_|I|}'

    $!GETVARNUMBYNAME |cont_pressure_z_a|
    NAME = "cont_pressure_z_a_|I|"
    $!DELETEVARS [|cont_pressure_z_a|]

    $!GETVARNUMBYNAME |cont_pressure_z_b|
    NAME = "cont_pressure_z_b_|I|"
    $!DELETEVARS [|cont_pressure_z_b|]


    $!VarSet |Z_T| = (|Z_T| + 1)


  $!ENDLOOP
  

$!ENDLOOP


$!LOOP |Z_1T|
  $!VarSet |Z| = (|LOOP|)

  $!VarSet |Z_T_GLOBAL| = (|Z_ULTIMO_T| + |Z| - 1)

  $!ALTERDATA [|Z_T_GLOBAL|]
    EQUATION = '{dx_aprox [m]} = {dx_aprox [m]} + {dx_a_0}'
  $!ALTERDATA [|Z_T_GLOBAL|]
    EQUATION = '{dy_aprox [m]} = {dy_aprox [m]} + {dy_a_0}'
  $!ALTERDATA [|Z_T_GLOBAL|]
    EQUATION = '{dz_aprox [m]} = {dz_aprox [m]} + {dz_a_0}'
  $!ALTERDATA [|Z_T_GLOBAL|]
    EQUATION = '{pressure_aprox [Pa]} = {pressure_aprox [Pa]} + {pressure_a_0 [Pa]}'
  $!ALTERDATA [|Z_T_GLOBAL|]
    EQUATION = '{pressure_x_aprox [Pa]} = {pressure_x_aprox [Pa]} + {pressure_x_a_0 [Pa]}'
  $!ALTERDATA [|Z_T_GLOBAL|]
    EQUATION = '{pressure_y_aprox [Pa]} = {pressure_y_aprox [Pa]} + {pressure_y_a_0 [Pa]}'
  $!ALTERDATA [|Z_T_GLOBAL|]
    EQUATION = '{pressure_z_aprox [Pa]} = {pressure_z_aprox [Pa]} + {pressure_z_a_0 [Pa]}'

$!ENDLOOP


#------------------------------------------------------------------------------------------------------------

$!ALTERDATA [2]
  EQUATION = '{dif_w_x_1 [N/m]} = 0'
$!ALTERDATA [2]
  EQUATION = '{dif_w_x_2 [N/m]} = 0'
$!ALTERDATA [2]
  EQUATION = '{dif_w_x [N/m]} = 0'
$!ALTERDATA [2]
  EQUATION = '{dif_w_y_1 [N/m]} = 0'
$!ALTERDATA [2]
  EQUATION = '{dif_w_y_2 [N/m]} = 0'
$!ALTERDATA [2]
  EQUATION = '{dif_w_y [N/m]} = 0'
$!ALTERDATA [2]
  EQUATION = '{dif_w_z_1 [N/m]} = 0'
$!ALTERDATA [2]
  EQUATION = '{dif_w_z_2 [N/m]} = 0'
$!ALTERDATA [2]
  EQUATION = '{dif_w_z [N/m]} = 0'


$!LOOP |ARMONICOS|
  $!VarSet |I| = (|LOOP|)
  
  $!ALTERDATA [2]
    EQUATION = '{dif_w_x_1 [N/m]} = {dif_w_x_1 [N/m]} + |I| * ({dx_b_|I| [m]} * {pressure_x_a_|I| [Pa]})'
  $!ALTERDATA [2]
    EQUATION = '{dif_w_x_2 [N/m]} = {dif_w_x_2 [N/m]} + |I| * (- {dx_a_|I| [m]} * {pressure_x_b_|I| [Pa]})'
  $!ALTERDATA [2]
    EQUATION = '{dif_w_x [N/m]} = {dif_w_x [N/m]} + |I| * ({dx_b_|I| [m]} * {pressure_x_a_|I| [Pa]} - {dx_a_|I| [m]} * {pressure_x_b_|I| [Pa]})'
  $!ALTERDATA [2]
    EQUATION = '{dif_w_y_1 [N/m]} = {dif_w_y_1 [N/m]} + |I| * ({dy_b_|I| [m]} * {pressure_y_a_|I| [Pa]})'
  $!ALTERDATA [2]
    EQUATION = '{dif_w_y_2 [N/m]} = {dif_w_y_2 [N/m]} + |I| * (- {dy_a_|I| [m]} * {pressure_y_b_|I| [Pa]})'
  $!ALTERDATA [2]
    EQUATION = '{dif_w_y [N/m]} = {dif_w_y [N/m]} + |I| * ({dy_b_|I| [m]} * {pressure_y_a_|I| [Pa]} - {dy_a_|I| [m]} * {pressure_y_b_|I| [Pa]})'
  $!ALTERDATA [2]
    EQUATION = '{dif_w_z_1 [N/m]} = {dif_w_z_1 [N/m]} + |I| * ({dz_b_|I| [m]} * {pressure_z_a_|I| [Pa]})'
  $!ALTERDATA [2]
    EQUATION = '{dif_w_z_2 [N/m]} = {dif_w_z_2 [N/m]} + |I| * (- {dz_a_|I| [m]} * {pressure_z_b_|I| [Pa]})'
  $!ALTERDATA [2]
    EQUATION = '{dif_w_z [N/m]} = {dif_w_z [N/m]} + |I| * ({dz_b_|I| [m]} * {pressure_z_a_|I| [Pa]} - {dz_a_|I| [m]} * {pressure_z_b_|I| [Pa]})'

$!ENDLOOP


$!ALTERDATA [2]
  EQUATION = '{dif_w_x_1 [N/m]} = PI * {dif_w_x_1 [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w_x_2 [N/m]} = PI * {dif_w_x_2 [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w_x [N/m]} = PI * {dif_w_x [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w_y_1 [N/m]} = PI * {dif_w_y_1 [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w_y_2 [N/m]} = PI * {dif_w_y_2 [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w_y [N/m]} = PI * {dif_w_y [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w_z_1 [N/m]} = PI * {dif_w_z_1 [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w_z_2 [N/m]} = PI * {dif_w_z_2 [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w_z [N/m]} = PI * {dif_w_z [N/m]}'


$!ALTERDATA [2]
  EQUATION = '{dif_w_1} = {dif_w_x_1 [N/m]} + {dif_w_y_1 [N/m]} + {dif_w_z_1 [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w_2} = {dif_w_x_2 [N/m]} + {dif_w_y_2 [N/m]} + {dif_w_z_2 [N/m]}'
$!ALTERDATA [2]
  EQUATION = '{dif_w} = {dif_w_x [N/m]} + {dif_w_y [N/m]} + {dif_w_z [N/m]}'
#$!ALTERDATA [1]
#  EQUATION = '{dif_w_2} = {dif_w_x [N/m]}[2] + {dif_w_y [N/m]}[2] + {dif_w_z [N/m]}[2]'

#$!ALTERDATA [2]
#  EQUATION = '{dif_trabajo} = {pressure_b_1 [Pa]} * {modulo_d_total_1 [m]} * PI'
#------------------------------------------------------------------------------------------------------------------------------------------------

#$!GETVARNUMBYNAME |dx_0|
#  NAME = "dx_a_0"
#$!DELETEVARS [|dx_0|]

#$!GETVARNUMBYNAME |dy_0|
#  NAME = "dy_a_0"
#$!DELETEVARS [|dy_0|]

#$!GETVARNUMBYNAME |dz_0|
#  NAME = "dz_a_0"
#$!DELETEVARS [|dz_0|]

#$!GETVARNUMBYNAME |d_mod_0|
#  NAME = "d_mod_a_0"
#$!DELETEVARS [|d_mod_0|]

#$!GETVARNUMBYNAME |pressure_0|
#  NAME = "pressure_a_0"
#$!DELETEVARS [|pressure_0|]


$!LOOP |ARMONICOS|
  $!VarSet |I| = (|LOOP|)


  $!IF |I| > 1

    $!GETVARNUMBYNAME |dx_a|
    NAME = "dx_a_|I| [m]"
    $!DELETEVARS [|dx_a|]

    $!GETVARNUMBYNAME |dx_b|
    NAME = "dx_b_|I| [m]"
    $!DELETEVARS [|dx_b|]

    $!GETVARNUMBYNAME |dy_a|
    NAME = "dy_a_|I| [m]"
    $!DELETEVARS [|dy_a|]

    $!GETVARNUMBYNAME |dy_b|
    NAME = "dy_b_|I| [m]"
    $!DELETEVARS [|dy_b|]

    $!GETVARNUMBYNAME |dz_a|
    NAME = "dz_a_|I| [m]"
    $!DELETEVARS [|dz_a|]

    $!GETVARNUMBYNAME |dz_b|
    NAME = "dz_b_|I| [m]"
    $!DELETEVARS [|dz_b|]

    $!GETVARNUMBYNAME |dx_Re|
    NAME = "dx_Re_|I| [m]"
    $!DELETEVARS [|dx_Re|]

    $!GETVARNUMBYNAME |dx_Im|
    NAME = "dx_Im_|I| [m]"
    $!DELETEVARS [|dx_Im|]

    $!GETVARNUMBYNAME |dy_Re|
    NAME = "dy_Re_|I| [m]"
    $!DELETEVARS [|dy_Re|]

    $!GETVARNUMBYNAME |dy_Im|
    NAME = "dy_Im_|I| [m]"
    $!DELETEVARS [|dy_Im|]

    $!GETVARNUMBYNAME |dz_Re|
    NAME = "dz_Re_|I| [m]"
    $!DELETEVARS [|dz_Re|]

    $!GETVARNUMBYNAME |dz_Im|
    NAME = "dz_Im_|I| [m]"
    $!DELETEVARS [|dz_Im|]

    $!GETVARNUMBYNAME |pressure_a|
    NAME = "pressure_a_|I| [Pa]"
    $!DELETEVARS [|pressure_a|]

    $!GETVARNUMBYNAME |pressure_b|
    NAME = "pressure_b_|I| [Pa]"
    $!DELETEVARS [|pressure_b|]

    $!GETVARNUMBYNAME |pressure_Re|
    NAME = "pressure_Re_|I| [Pa]"
    $!DELETEVARS [|pressure_Re|]

    $!GETVARNUMBYNAME |pressure_Im|
    NAME = "pressure_Im_|I| [Pa]"
    $!DELETEVARS [|pressure_Im|]

    $!GETVARNUMBYNAME |pressure_x_a|
    NAME = "pressure_x_a_|I| [Pa]"
    $!DELETEVARS [|pressure_x_a|]

    $!GETVARNUMBYNAME |pressure_x_b|
    NAME = "pressure_x_b_|I| [Pa]"
    $!DELETEVARS [|pressure_x_b|]

    $!GETVARNUMBYNAME |pressure_x_Re|
    NAME = "pressure_x_Re_|I| [Pa]"
    $!DELETEVARS [|pressure_x_Re|]

    $!GETVARNUMBYNAME |pressure_x_Im|
    NAME = "pressure_x_Im_|I| [Pa]"
    $!DELETEVARS [|pressure_x_Im|]

    $!GETVARNUMBYNAME |pressure_y_a|
    NAME = "pressure_y_a_|I| [Pa]"
    $!DELETEVARS [|pressure_y_a|]

    $!GETVARNUMBYNAME |pressure_y_b|
    NAME = "pressure_y_b_|I| [Pa]"
    $!DELETEVARS [|pressure_y_b|]

    $!GETVARNUMBYNAME |pressure_y_Re|
    NAME = "pressure_y_Re_|I| [Pa]"
    $!DELETEVARS [|pressure_y_Re|]

    $!GETVARNUMBYNAME |pressure_y_Im|
    NAME = "pressure_y_Im_|I| [Pa]"
    $!DELETEVARS [|pressure_y_Im|]

    $!GETVARNUMBYNAME |pressure_z_a|
    NAME = "pressure_z_a_|I| [Pa]"
    $!DELETEVARS [|pressure_z_a|]

    $!GETVARNUMBYNAME |pressure_z_b|
    NAME = "pressure_z_b_|I| [Pa]"
    $!DELETEVARS [|pressure_z_b|]

    $!GETVARNUMBYNAME |pressure_z_Re|
    NAME = "pressure_z_Re_|I| [Pa]"
    $!DELETEVARS [|pressure_z_Re|]

    $!GETVARNUMBYNAME |pressure_z_Im|
    NAME = "pressure_z_Im_|I| [Pa]"
    $!DELETEVARS [|pressure_z_Im|]

#    $!GETVARNUMBYNAME |modulo_dx|
#    NAME = "modulo_dx_|I| [m]"
#    $!DELETEVARS [|modulo_dx|]

    $!GETVARNUMBYNAME |modulo_dy|
    NAME = "modulo_dy_|I| [m]"
    $!DELETEVARS [|modulo_dy|]

    $!GETVARNUMBYNAME |modulo_dz|
    NAME = "modulo_dz_|I| [m]"
    $!DELETEVARS [|modulo_dz|]

    $!GETVARNUMBYNAME |modulo_d_total|
    NAME = "modulo_d_total_|I| [m]"
    $!DELETEVARS [|modulo_d_total|]

#    $!GETVARNUMBYNAME |modulo_pressure|
#    NAME = "modulo_pressure_|I| [Pa]"
#    $!DELETEVARS [|modulo_pressure|]

    $!GETVARNUMBYNAME |fase_pressure|
    NAME = "fase_d_pressure_|I| [rad]"
    $!DELETEVARS [|fase_pressure|]

    $!GETVARNUMBYNAME |modulo_pressure_x|
    NAME = "modulo_pressure_x_|I| [Pa]"
    $!DELETEVARS [|modulo_pressure_x|]

    $!GETVARNUMBYNAME |modulo_pressure_y|
    NAME = "modulo_pressure_y_|I| [Pa]"
    $!DELETEVARS [|modulo_pressure_y|]

    $!GETVARNUMBYNAME |modulo_pressure_z|
    NAME = "modulo_pressure_z_|I| [Pa]"
    $!DELETEVARS [|modulo_pressure_z|]


  $!ENDIF


  $!IF |TIPO_ARMONICOS| == 1

    $!GETVARNUMBYNAME |pressure_Re|
    NAME = "pressure_Re_|I| [Pa]"
    $!DELETEVARS [|pressure_Re|]

    $!GETVARNUMBYNAME |pressure_Im|
    NAME = "pressure_Im_|I| [Pa]"
    $!DELETEVARS [|pressure_Im|]

    $!GETVARNUMBYNAME |pressure_x_Re|
    NAME = "pressure_x_Re_|I| [Pa]"
    $!DELETEVARS [|pressure_x_Re|]

    $!GETVARNUMBYNAME |pressure_x_Im|
    NAME = "pressure_x_Im_|I| [Pa]"
    $!DELETEVARS [|pressure_x_Im|]

    $!GETVARNUMBYNAME |pressure_y_Re|
    NAME = "pressure_y_Re_|I| [Pa]"
    $!DELETEVARS [|pressure_y_Re|]

    $!GETVARNUMBYNAME |pressure_y_Im|
    NAME = "pressure_y_Im_|I| [Pa]"
    $!DELETEVARS [|pressure_y_Im|]

    $!GETVARNUMBYNAME |pressure_z_Re|
    NAME = "pressure_z_Re_|I| [Pa]"
    $!DELETEVARS [|pressure_z_Re|]

    $!GETVARNUMBYNAME |pressure_z_Im|
    NAME = "pressure_z_Im_|I| [Pa]"
    $!DELETEVARS [|pressure_z_Im|]

    $!IF |I| == 1

      $!GETVARNUMBYNAME |dx_Re|
      NAME = "dx_Re_|I| [m]"
      $!DELETEVARS [|dx_Re|]

      $!GETVARNUMBYNAME |dx_Im|
      NAME = "dx_Im_|I| [m]"
      $!DELETEVARS [|dx_Im|]

      $!GETVARNUMBYNAME |dy_Re|
      NAME = "dy_Re_|I| [m]"
      $!DELETEVARS [|dy_Re|]

      $!GETVARNUMBYNAME |dy_Im|
      NAME = "dy_Im_|I| [m]"
      $!DELETEVARS [|dy_Im|]

      $!GETVARNUMBYNAME |dz_Re|
      NAME = "dz_Re_|I| [m]"
      $!DELETEVARS [|dz_Re|]

      $!GETVARNUMBYNAME |dz_Im|
      NAME = "dz_Im_|I| [m]"
      $!DELETEVARS [|dz_Im|]


    $!ENDIF

  $!ELSEIF |TIPO_ARMONICOS| == 2

    $!GETVARNUMBYNAME |pressure_a|
    NAME = "pressure_a_|I| [Pa]"
    $!DELETEVARS [|pressure_a|]

    $!GETVARNUMBYNAME |pressure_b|
    NAME = "pressure_b_|I| [Pa]"
    $!DELETEVARS [|pressure_b|]

    $!GETVARNUMBYNAME |pressure_x_a|
    NAME = "pressure_x_a_|I| [Pa]"
    $!DELETEVARS [|pressure_x_a|]

    $!GETVARNUMBYNAME |pressure_x_b|
    NAME = "pressure_x_b_|I| [Pa]"
    $!DELETEVARS [|pressure_x_b|]

    $!GETVARNUMBYNAME |pressure_y_a|
    NAME = "pressure_y_a_|I| [Pa]"
    $!DELETEVARS [|pressure_y_a|]

    $!GETVARNUMBYNAME |pressure_y_b|
    NAME = "pressure_y_b_|I| [Pa]"
    $!DELETEVARS [|pressure_y_b|]

    $!GETVARNUMBYNAME |pressure_z_a|
    NAME = "pressure_z_a_|I| [Pa]"
    $!DELETEVARS [|pressure_z_a|]

    $!GETVARNUMBYNAME |pressure_z_b|
    NAME = "pressure_z_b_|I| [Pa]"
    $!DELETEVARS [|pressure_z_b|]

    $!IF |I| == 1

      $!GETVARNUMBYNAME |dx_a|
      NAME = "dx_a_|I| [m]"
      $!DELETEVARS [|dx_a|]

      $!GETVARNUMBYNAME |dx_b|
      NAME = "dx_b_|I| [m]"
      $!DELETEVARS [|dx_b|]

      $!GETVARNUMBYNAME |dy_a|
      NAME = "dy_a_|I| [m]"
      $!DELETEVARS [|dy_a|]

      $!GETVARNUMBYNAME |dy_b|
      NAME = "dy_b_|I| [m]"
      $!DELETEVARS [|dy_b|]

      $!GETVARNUMBYNAME |dz_a|
      NAME = "dz_a_|I| [m]"
      $!DELETEVARS [|dz_a|]

      $!GETVARNUMBYNAME |dz_b|
      NAME = "dz_b_|I| [m]"
      $!DELETEVARS [|dz_b|]


    $!ENDIF


  $!ENDIF


$!ENDLOOP


#$!GETVARNUMBYNAME |dif_w_x_1|
#NAME = "dif_w_x_1 [N/m]"
#$!DELETEVARS [|dif_w_x_1|]

#$!GETVARNUMBYNAME |dif_w_x_2|
#NAME = "dif_w_x_2 [N/m]"
#$!DELETEVARS [|dif_w_x_2|]

#$!GETVARNUMBYNAME |dif_w_x|
#NAME = "dif_w_x [N/m]"
#$!DELETEVARS [|dif_w_x|]

#$!GETVARNUMBYNAME |dif_w_y_1|
#NAME = "dif_w_y_1 [N/m]"
#$!DELETEVARS [|dif_w_y_1|]

#$!GETVARNUMBYNAME |dif_w_y_2|
#NAME = "dif_w_y_2 [N/m]"
#$!DELETEVARS [|dif_w_y_2|]

#$!GETVARNUMBYNAME |dif_w_y|
#NAME = "dif_w_y [N/m]"
#$!DELETEVARS [|dif_w_y|]

#$!GETVARNUMBYNAME |dif_w_z_1|
#NAME = "dif_w_z_1 [N/m]"
#$!DELETEVARS [|dif_w_z_1|]

#$!GETVARNUMBYNAME |dif_w_z_2|
#NAME = "dif_w_z_2 [N/m]"
#$!DELETEVARS [|dif_w_z_2|]

#$!GETVARNUMBYNAME |dif_w_z|
#NAME = "dif_w_z [N/m]"
#$!DELETEVARS [|dif_w_z|]
