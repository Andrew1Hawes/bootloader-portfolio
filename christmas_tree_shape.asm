[BITS 16]
[ORG 0x7C00]
top:
  ;; Put 0 into ds (data segment)
  ;; Can't do it directly
  mov ax,0x0000
  mov ds,ax
  ;initiate registers with number of rows in the pyramid and number of dots to print
  ;use 8 bit portions of registers as 16 bits is unnecessarily large in this case
  mov cl, 5
  mov dl, 1
  call pyramid
  ;print the square trunk of the tree
  mov si, TreeTrunk
  call writeString
  jmp $ ; Spin
pyramid:
  ;move the numbers of rows/spaces and dots into separate counters for the inner loops
  mov ch, cl
  mov dh, dl
  call printSpaces
  call printDots
  ;print newline
  mov si, NewLine
  call writeString
  ;subtract number of rows/spaces by 1 and add 2 to number of dots
  dec cl
  add dl, 2
  ;check if pyramid is complete
  cmp cl, 0
  jne pyramid
  ret
printSpaces:
  ;print a space then check to see if another space needs to be printed, otherwise return
  mov si, Space
  call writeString
  dec ch
  cmp ch, 0
  jne printSpaces
  ret
printDots:
  ;print a dot then check if another dot needs to be printed, otherwise return
  mov si, Dot
  call writeString
  dec dh
  cmp dh, 0
  jne printDots
  ret
writeString:
  mov ah,0x0E ; Display a character
  mov bh,0x00
  mov bl,0x07
nextchar:
  Lodsb ; Loads [SI] into AL and increases SI by one
  ;; Effectively "pumps" the string through AL
  cmp al,0 ; Checks if it's reached the end of the string
  jz done
  int 0x10 ; BIOS interrupt
  jmp nextchar
done:
  ret
  ;declare memory locations (variables) to store our text
  ;13,10 represent new line, 0 signals to stop printing
  Dot db '*',0
  NewLine db 13,10,0
  Space db ' ',0
  TreeTrunk db '   ***',13,10,'   ***',13,10,0
  times 510-($-$$) db 0
  dw 0xAA55
