.386
.model flat, stdcall
.stack 4096

include C:\masm32\include\windows.inc
include kernel32.inc
include masm32.inc

includelib kernel32.lib
includelib masm32.lib

.data
    array db 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 ; sorted array
    array_length db 10                          ; length of the array
    targets db 7, 15, 2, 19, 10, 0              ; targets to search for (0 as terminator)
    not_found_msg db "Not Found", 0
    found_msg db "Found at index: ", 0
    newline db 10, 0                              ; Newline for output

.code
main proc
    mov ecx, array_length      ; length of the array
    lea esi, targets           ; point to the targets array
    xor ebx, ebx              ; target index

next_target:
    movzx eax, byte ptr [esi + ebx] ; load current target
    test eax, eax                   ; check if it's the terminator (0)
    jz exit                         ; if yes, exit

    call binary_search              ; perform the binary search

    inc ebx                         ; move to the next target
    jmp next_target                 ; repeat for next target

binary_search proc
    xor ebx, ebx                   ; left = 0
    dec ecx                        ; right = length - 1

search_loop:
    cmp ebx, ecx                   ; if left > right
    jg not_found                   ; target not found

    ; Calculate mid = (left + right) / 2
    mov edx, ebx                   ; edx = left
    add edx, ecx                   ; edx = left + right
    shr edx, 1                     ; edx = (left + right) / 2
    mov al, [array + edx]          ; al = array[mid]
    
    ; Compare target with array[mid]
    cmp al, [esi + ebx]
    je found                       ; if target == array[mid], found

    ; If target < array[mid], search in the left half
    jl search_left
    ; If target > array[mid], search in the right half
    jmp search_right

search_left:
    mov ecx, edx                   ; right = mid - 1
    dec ecx
    jmp search_loop

search_right:
    mov ebx, edx                   ; left = mid + 1
    inc ebx
    jmp search_loop

found:
    ; Print found message
    invoke StdOut, found_msg       ; Print "Found at index: "
    invoke StdOut, newline          ; Newline
    invoke StdOut, edx              ; Print found index (you might need to convert it to string)
    invoke StdOut, newline          ; Newline
    jmp exit

not_found:
    ; Print not found message
    invoke StdOut, not_found_msg    ; Print "Not Found"
    invoke StdOut, newline          ; Newline
    jmp exit

exit:
    invoke ExitProcess, 0
main endp
end main
