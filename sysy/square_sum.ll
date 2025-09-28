@.str_in  = private constant [3 x i8] c"%d\00"
@.str_out = private constant [4 x i8] c"%d\0A\00"     ; "%d\n"
@N        = constant i32 5
@THRESH   = constant i32 30

declare i32 @scanf(i8*, ...)
declare i32 @printf(i8*, ...)

; int square_sum(int* arr)
define i32 @square_sum(i32* %arr) {
entry:
  %s = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %s
  store i32 0, i32* %i
  br label %cond

cond:                                             ; while (i < N)
  %i_val = load i32, i32* %i
  %cmp_loop = icmp slt i32 %i_val, 5
  br i1 %cmp_loop, label %loop, label %end

loop:
  %i_val2 = load i32, i32* %i
  %idxptr = getelementptr inbounds i32, i32* %arr, i32 %i_val2
  %val    = load i32, i32* %idxptr
  %mul    = mul nsw i32 %val, %val
  %s_old  = load i32, i32* %s
  %s_new  = add nsw i32 %s_old, %mul
  store i32 %s_new, i32* %s
  %i_old  = load i32, i32* %i
  %i_inc  = add nsw i32 %i_old, 1
  store i32 %i_inc, i32* %i
  br label %cond

end:
  %res = load i32, i32* %s
  ret i32 %res
}

; int main()
define i32 @main() {
entry:
  %a = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  store i32 0, i32* %i
  br label %read_cond

; for (i=0; i<5; i++) scanf("%d", &a[i]);
read_cond:
  %i_val = load i32, i32* %i
  %cmp_read = icmp slt i32 %i_val, 5
  br i1 %cmp_read, label %read_loop, label %calc

read_loop:
  %i_val2  = load i32, i32* %i
  %elemPtr = getelementptr inbounds [5 x i32], [5 x i32]* %a, i32 0, i32 %i_val2
  %fmtPtr  = getelementptr [3 x i8], [3 x i8]* @.str_in, i32 0, i32 0
  call i32 (i8*, ...) @scanf(i8* %fmtPtr, i32* %elemPtr)
  %i_old   = load i32, i32* %i
  %i_inc   = add nsw i32 %i_old, 1
  store i32 %i_inc, i32* %i
  br label %read_cond

; 调用 square_sum
calc:
  %arrPtr    = getelementptr inbounds [5 x i32], [5 x i32]* %a, i32 0, i32 0
  %total     = call i32 @square_sum(i32* %arrPtr)
  %cmp_total = icmp sgt i32 %total, 30
  %res       = select i1 %cmp_total, i32 1, i32 0

  ; 直接输出结果
  %fmt_out_ptr = getelementptr [4 x i8], [4 x i8]* @.str_out, i32 0, i32 0
  call i32 (i8*, ...) @printf(i8* %fmt_out_ptr, i32 %res)

  ret i32 %res
}
