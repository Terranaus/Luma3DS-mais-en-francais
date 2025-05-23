@   This paricular file is licensed under the following terms:

@   This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable
@   for any damages arising from the use of this software.
@
@   Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it
@   and redistribute it freely, subject to the following restrictions:
@
@    The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
@    If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
@
@    Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
@    This notice may not be removed or altered from any source distribution.

.arm
.balign 4

.macro SVC_BEGIN name
    .section .text.\name, "ax", %progbits
    .global \name
    .type \name, %function
    .align 2
    .cfi_startproc
\name:
.endm

.macro SVC_END
    .cfi_endproc
.endm

SVC_BEGIN svcCustomBackdoor
    svc 0x80
    bx lr
SVC_END

SVC_BEGIN svcConvertVAToPA
    svc 0x90
    bx lr
SVC_END

SVC_BEGIN svcFlushDataCacheRange
    svc 0x91
    bx lr
SVC_END

SVC_BEGIN svcFlushEntireDataCache
    svc 0x92
    bx lr
SVC_END

SVC_BEGIN svcInvalidateInstructionCacheRange
    svc 0x93
    bx lr
SVC_END

SVC_BEGIN svcInvalidateEntireInstructionCache
    svc 0x94
    bx lr
SVC_END

SVC_BEGIN svcMapProcessMemoryEx
    push {r4, r5, r6}
    ldr r4, [sp, #12]
    ldr r5, [sp, #16]
    mov r6, r0 @ Move the dst handle to r6 to make room for magic value
    mov r0, #0xFFFFFFF2 @ Set r0 to magic value, which allows for backwards compatibility
    svc 0xA0
    pop {r4, r5, r6}
    bx lr
SVC_END

SVC_BEGIN svcUnmapProcessMemoryEx
    svc 0xA1
    bx lr
SVC_END

SVC_BEGIN svcControlMemoryEx
    push {r0, r4, r5}
    ldr  r0, [sp, #0xC]
    ldr  r4, [sp, #0xC+0x4]
    ldr  r5, [sp, #0xC+0x8]
    svc  0xA2
    pop  {r2, r4, r5}
    str  r1, [r2]
    bx   lr
SVC_END

SVC_BEGIN svcControlMemoryUnsafe
    str r4, [sp, #-4]!
    ldr r4, [sp, #4]
    svc 0xA3
    ldr r4, [sp], #4
    bx lr
SVC_END

SVC_BEGIN svcFreeMemory
    svc  0xA3
    bx   lr
SVC_END

SVC_BEGIN svcControlService
    svc 0xB0
    bx lr
SVC_END

SVC_BEGIN svcCopyHandle
    str r0, [sp, #-4]!
    svc 0xB1
    ldr r2, [sp], #4
    str r1, [r2]
    bx lr
SVC_END

SVC_BEGIN svcTranslateHandle
    str r0, [sp, #-4]!
    svc 0xB2
    ldr r2, [sp], #4
    str r1, [r2]
    bx lr
SVC_END

SVC_BEGIN svcControlProcess
    svc 0xB3
    bx lr
SVC_END
