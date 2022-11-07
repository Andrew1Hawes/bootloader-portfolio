[BITS 16]
[ORG 0x7C00]
top:
  ;; Put 0 into ds (data segment)
  ;; Can't do it directly
  mov ax,0x0000
  mov ds,ax
  ;; si is the location relative to the data segment of the
  ;; string/char to display
  mov si, SID
  call writeString
  mov si, Course
  call writeString
  mov si, OperatingSystem
  call writeString
  jmp $ ; Spin
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
  SID db '1234567',13,10,0 ; 13,10 represent new line, 0 signals to stop printing
  Course db 'Computer Science',13,10,0
  OperatingSystem db 'Linux',13,10,0
  times 510-($-$$) db 0
  dw 0xAA55
