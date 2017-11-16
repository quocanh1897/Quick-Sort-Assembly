.data
test1: .word 9 8 4 2 1 3 45 #7 so
test2: .word 34 5 88 4 56 98 7 70 23 63 44 87 #12 so
test3: .word 69 7 2 4 3 45 48 55 5 6 36 35 21 120 555 784 1 10 12 15 41 47 45 78 77 65 13 123 31 91 #30 so
test4: .word 47 5 49 55 8 6 2 20 1 2 12 45 65 32 201 1 0 6 9 40 #20 so
test5: .word 5 5 4 1 41 12 23 20 25 11 44 55 86 95 210 256 14 13 0 9 #20 so
size5: .word 20
size4: .word 20
size3: .word 30
size2: .word 12
size1: .word 7
space: .asciiz " "
newLine: .asciiz "\n"

.text
  main:
  
  	la $s0, test4 #load test case
  	lw $s7, size4 #load size cua test case
  	
  	jal printResult
  	
  	addi $a1, $0, 0  #address cua left
  	
  	mul $a2, $s7, 4  #address cua..
  	subi $a2, $a2, 4 #..right 
  	
  	jal quickSort
  	
	li $v0, 10 #break
	syscall
 #end main	
	
 swap: #void swap(int a1, int a2)
  	lw $t1, 0($a1)		#temp1 = a1	
  	lw $t2, 0($a2)		#temp2 = a2
  	
	sw $t2, 0($a1)		#a1 = t2
  	sw $t1, 0($a2)		#a2 = t1	 ' 
	  
  	jr $ra  	  
 #end swap
  
 printResult: #void printResult(int* s0(test case), int size = s7)
	add $t2, $0, $s0		#int *t2 = testcase
	addi $t0, $0, 0		#i = t0;
	
   loopPrint:
		beq $t0,  $s7,  exitPrint	#while (i != size)
		lw $a0,  0($t2)		#load test case
		
		li $v0, 1	#print int test case
		syscall
		
		la $a0,  space		
		li $v0, 4 #print string (spacebar)
		syscall
		
		addi $t2,  $t2, 4		#doi con tro t2 toi address so ke tiep
		addi $t0, $t0, 1		#i++
		j loopPrint
	
   exitPrint:
 		la $a0, newLine		#print newLine
  		li $v0, 4
  		syscall
  		
   	jr $ra
 #end printResult


 partition: #int(v1) *partition(int *s0(test case), int *left = a1, int *right = a2, pivot = a3)
 	subi $sp, $sp, 4		#save $ra..
  	sw $ra, 0($sp)			#..vao stack
 		
  	add $s1, $s0, $a1		#s1 = left
  	subi $s1, $s1, 4		#doi con tro left ve so truoc no
  	add $s2, $s0, $a2		#s2 = right
  	
   loopPartition:
   
      loopLeft:
    		addi $s1, $s1, 4		  #doi con tro left ve so ke tiep
    		lw $t1, 0($s1)			  #t1 = left
    		blt $t1, $a3, loopLeft #do loopLeft while (left < pivot)
    		
      loopRight:
    		beq $s2, $s0, exitRight	#if (right = testcase) then exitRight
    		subi $s2, $s2, 4			#doi con tro right ve so truoc no
    		lw $t1, 0($s2)				#t1 = right
    		bge $t1, $a3, loopRight #do loopRight while(right >= pivot)
    		
      exitRight:
         bge $s1, $s2, exitLoopPartition #if(left >= right) then exitLoopPartition
         
         subi $sp, $sp, 8	#save..
         sw $a1, 0($sp)		#..a1..
  			sw $a2, 4($sp)		#..a2 vao stack
  			
  			#swap(left, right)
         add $a1, $0, $s1	
        	add $a2, $0, $s2
        	jal swap
         	
        	lw $a1, 0($sp)		#load..
  			lw $a2, 4($sp)		#..a1, a2..
		  	addi $sp, $sp, 8	#..from stack
  	
         j loopPartition
         
   exitLoopPartition:
   	subi $sp, $sp, 8	#save..
      sw $a1, 0($sp)		#..a1..
 	 	sw $a2, 4($sp)		#..a2 vao stack
         	
      #swap(left, right)
	 	add $a1, $0, $s1		
 		add $a2, $s0, $a2
      jal swap
         	
      lw $a1, 0($sp)		#load..
  		lw $a2, 4($sp)		#..a1, a2..
		addi $sp, $sp, 8	#..from stack
     	jal printResult	
        	
     	add $v1, $0, $s1	#return v1 = s1 (=left)
     	lw $ra, 0($sp)
  		addi $sp, $sp, 4
	
	  	jr $ra	
#end partition


  quickSort: #void quickSort(int *s0(test case), int *left = a1, int *right = a2)
  	subi $sp, $sp, 4	
  	sw $ra, 0($sp)

   bge $a1, $a2, exitQuickSort #if (left >= right) then exitQuickSort
  	
  	add $a3, $s0, $a2	#pivot = testcase[right];
  	lw $a3, 0($a3)
  	
  	jal partition		
  	
  	add $t1 , $0, $v1		#partition address
  	sub $t1, $t1, $s0		#change to partitionPoint x4
  	
  	#save to stack
  	subi $sp, $sp, 12		
   sw $a1, 0($sp)
  	sw $a2, 4($sp)
  	sw $t1, 8($sp)
  	
  	subi $a2, $t1, 4		#right = partitionPoint - 1
  	jal quickSort			#quickSort(testcase, left, partitionPoint - 1)
  	
	#van giu nguyen stack dang chua a1, a2, t1
  	
  	addi $a1, $t1, 4		#partitionPoint + 1
  	jal quickSort			#quickSort(testcase, partitionPoint + 1, right);
  	
  	#load from stack
   lw $a1, 0($sp)		
  	lw $a2, 4($sp)
  	lw $t1, 8($sp)
  	addi $sp, $sp, 12 #pop stack x3
  	
   exitQuickSort:
  	lw $ra, 0($sp)
  	addi $sp, $sp, 4
  	jr $ra  
#end quickSort  