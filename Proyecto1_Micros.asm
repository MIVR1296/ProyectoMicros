add $t2, $t2, 1 
add $t2,$t2,$t2
j salto1
add $t2,$t2,$t2
nop 
nop
nop

salto1: 
add $t2,$t2,$t2
add $t2,$t2,$t2
add $t1, $t1, 1
sub $t2, $t2, $t1
add $t2,$t2,$t2
add $t1, $t1, 1
sub $t2, $t2, $t1 
