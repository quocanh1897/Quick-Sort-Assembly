##########################
##########################
##no longer use this code#
##########################
##########################
.data
 space: .asciiz " "  
 line: .asciiz "\n"  
 colonsp: .asciiz ": "  
 #.align 2
 array: .word 0 : 1000 # array cac phan tu kieu word, chua array ketqua
 test1: .word 34 5 88 4 56 98 7 70 23 63 44 87 #12 so
 test2: .word 6 7 2 4 3 45 45 55 5 6 36 35 21 120 555 784 1 10 12 15 41 47 45 78 77 65 12 123 31 91 #30 so
 size: .word 12 # so phan tu can sort trong ar$ray.
 ask: .asciiz "Input number of values to be sorted (0 < N < 1000): "
 input: .asciiz "Input each value: "
 sorted_array_string: .asciiz "Sorted:"
 receive_values_loop_iter_string: .asciiz "Input value#"
.text
.globl main
main:

 params_info:
 li $v0, 4 # in string
 la $a0, ask# load ask vao $a0.
 syscall 
 
 params:
 li $v0, 5 # doc int
 syscall # do dai cua arr kq
 la $t0, size 
 sw $v0, 0($t0) 
 
 receive_values_loop_info:
 li $v0, 4 # nguoi dung nhap vao arr
 la $a0, input
 syscall 
 li $v0, 4 # print new line
 la $a0, line 
 syscall 
 
### input loop

 receive_values_loop_prep:
 la $t0, array # load ar$ray to $$t0.
 lw $t1, size # load size to $t1.
 li $t2, 0 # loop iter, starting from 0.
 
 receive_values_loop:
 bge $t2, $t1, receive_values_end # while ($t2 < $t1).
 li $v0, 4 # prompt at every ite$ration during input
 la $a0, receive_values_loop_iter_string 
 syscall 
 li $v0, 1 
 addi $a0, $t2, 1 # load (iter + 1) to argument register $$a0.
 syscall 
 li $v0, 4 
 la $a0, colonsp 
 syscall 
 li $v0, 5 
 syscall # USER INPUT
 sw $v0, 0($t0) # store the user input in the ar$ray.
 addi $t0, $t0, 4 # increment ar$ray pointer by 4.
 addi $t2, $t2, 1 # increment loop iter by 1.
 j receive_values_loop # jump back to the beginning of the loop.
 receive_values_end:
 jal print # print input values
 
 la $a0, array # a0 adrs of the array
 li $a1, 0 # left val
 lw $a2, size # right val
 addi $a2, $a2, -1
 jal def_quick_sort 
 jal print
 j exit

# tham so quickSort:
# a0 - address of array
# a1 - 0
# a2 - size-1 of array

def_quick_sort:
 bge $a1, $a2, qs_End # while(a1 < a2)
 
 addi $sp, $sp, -20
 sw $ra, 0($sp) # save return adrs
 sw $a0, 8($sp) 
 sw $a1, 12($sp) # save left 
 sw $a2, 16($sp) # save right 
 
 jal def_partition # v0 = def_partition(arr, left, right)
 lw $ra, 0($sp) #
 sw $v0, 4($sp) 
 # lw $a0, 8($sp) # 
 lw $a1, 12($sp) # 
 
 addi $a2, $v0, -1 # 
 jal def_quick_sort
 lw $ra, 0($sp) #
 # lw $a0, 12($sp) # 
 lw $t0, 4($sp) #
 addi $a1, $t0, 1 # 
 lw $a2, 16($sp) # 
 jal def_quick_sort
 addi $sp, $sp, 20
 lw $ra, 0($sp) 
qs_End: 
 jr $ra
 
# tham so cua partition:
# a0 - address of array
# a1 - 0
# a2 - size-1 of array


def_partition:
 add $t0, $a1, $zero
 add $t1, $a2, $zero 
 mul $t7, $t1, 4
 add $t7, $a0, $t7
 lw $t2, ($t7) # key
 addi $t1, $t1, -1
 li $t5, -1 # t5 = i
 
 loop:
 bgt $t0, $t1, loop_end # t0 = j// while(t0 < t1) 
 mul $t7, $t0, 4 
 add $t7, $a0, $t7
 lw $t3, ($t7)
 ble $t3, $t2, incl
 
 incl_return:
 addi $t0, $t0, 1
 j loop
 loop_end:
 j swap_p
 swap_p_return:
 add $v0, $t0, $zero
 jr $ra
 incl:
 addi $t5, $t5, 1
 mul $t6, $t5, 4
 add $t6, $a0, $t6
 lw $s0, ($t6)
 mul $t7, $t0, 4
 add $t7, $a0, $t7
 lw $s1, ($t7)
 sw $s0, ($t7)
 sw $s1, ($t6)
 j incl_return
 
 swap_p:
 addi $t5, $t5, 1
 mul $t6, $t5, 4
 add $t6, $a0, $t6
 lw $s0, ($t6)
 mul $t7, $a2, 4
 add $t7, $a0, $t7
 lw $s1, ($t7)
 sw $s0, ($t7)
 sw $s1, ($t6)
 j swap_p_return
# prog$rams ends
# 
exit:
 li $v0, 10 # 10 = exit syscall.
 syscall 
 
### Printing
print:
 print_loop_prep:
 la $t0, array
 lw $t1, size
 li $t2, 0
 print_loop:
 bge $t2, $t1, print_end
 li $v0, 1
 lw $a0, 0($t0)
 syscall
 li $v0, 4
 la $a0, space
 syscall
 addi $t0, $t0, 4
 addi $t2, $t2, 1
 j print_loop
 print_end:
 li $v0, 4
 la $a0, line
 syscall
 jr $ra
