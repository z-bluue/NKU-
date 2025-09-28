    .section .data
fmt_in:     .string "%d"
fmt_out:    .string "%d\n"

    .section .text
    .globl main
    .type main, @function

    .extern scanf
    .extern printf
    .globl square_sum
    .type square_sum, @function

# ---------- square_sum ----------
square_sum:
    addi    sp, sp, -32
    sd      ra, 24(sp)
    sd      s0, 16(sp)
    mv      s0, sp

    li      t0, 0          # sum
    li      t1, 0          # i

sq_loop:
    li      t2, 5
    bge     t1, t2, sq_end

    slli    t3, t1, 2
    add     t4, a0, t3
    lw      t5, 0(t4)
    mul     t6, t5, t5
    add     t0, t0, t6

    addi    t1, t1, 1
    j       sq_loop

sq_end:
    mv      a0, t0
    ld      ra, 24(sp)
    ld      s0, 16(sp)
    addi    sp, sp, 32
    ret

# ---------- main ----------
main:
    addi    sp, sp, -64
    sd      ra, 56(sp)
    sd      s0, 48(sp)
    mv      s0, sp

    addi    s1, sp, 8      # s1 = &a[0] on stack

    li      t1, 0
read_loop:
    li      t2, 5
    bge     t1, t2, after_read

    # scanf("%d", &a[i])
    la      a0, fmt_in
    slli    t3, t1, 2
    add     a1, s1, t3
    call    scanf

    addi    t1, t1, 1
    j       read_loop

after_read:
    mv      a0, s1
    call    square_sum      # total in a0

    li      t0, 30          # 阈值
    ble     a0, t0, do_print0

    # print 1
    li      t1, 1
    mv      a1, t1
    la      a0, fmt_out
    call    printf
    j       end_main

do_print0:
    li      t1, 0
    mv      a1, t1
    la      a0, fmt_out
    call    printf

end_main:
    li      a0, 0           # return code
    ld      ra, 56(sp)
    ld      s0, 48(sp)
    addi    sp, sp, 64
    ret
