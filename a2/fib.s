.global fib
fib:
	li a1, 1  # a1 stores 1 initially and is used for stroing the next value in the fibonacci series
	li a2, 0  # a2 stores 0 initially and is used for stroing the current value in the fibonacci series
	li a3, 1  # a3 stores 1 all the time
			  # a3 is used to decrement a0 by 1 after each cycle of the loop given below
	
	loop:
		add a4,a1,a2      # Adding the the values in a1 and a2 and storing in a4 
		mv a2,a1          # Moving the current value in the series to a2 from a1
		mv a1,a4          # Moving the next value in the series to a1 from a4 
		sub a0,a0,a3      # a0 is decremented by 1 at the end of each iteration using a3
		bne a0,x0,loop    # If a0 does not contain 0 then branch back to the beginning of the loop
		
	mv a0,a2    # Move the answer to a0 which is contained in a2
    jr ra       # Return address was stored by original call
	
	
