From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] x86_64/lib: improve the performance of memmove
Date: Thu, 16 Sep 2010 14:31:43 +0800
Message-ID: <4C91B9CF.2020401@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When the dest and the src do overlap and the memory area is large, memmove of
x86_64 is very inefficient, and it led to bad performance, such as btrfs's file
deletion performance. This patch improved the performance of memmove on x86_64
by using __memcpy_bwd() instead of byte copy when doing large memory area copy
(len > 64).

I have tested this patchset by doing 500 bytes memory copy for 50000 times
with various alignments and buffer sizes on my x86_64 box:
Len	Src Unalign	Dest Unalign	Without Patch	Patch applied
---	-----------	------------	-------------	------------- 
256	0		0		0s 815158us	0s 249647us
256	0		4		0s 816059us	0s 324210us
256	0		7		0s 815192us	0s 324254us
256	3		0		0s 815179us	0s 325991us
256	3		1		0s 815161us	0s 378462us
256	3		4		0s 815154us	0s 779306us
256	3		7		0s 815151us	0s 782924us
256	7		0		0s 815839us	0s 325524us
256	7		4		0s 815149us	0s 375658us
256	7		7		0s 815160us	0s 374488us
1024	0		0		3s 125891us	0s 437662us
1024	0		1		3s 125940us	0s 777524us
1024	0		4		3s 159788us	0s 778850us
1024	0		7		3s 155177us	0s 733927us
1024	4		0		3s 118323us	0s 830167us
1024	4		4		3s 129124us	0s 962505us
1024	4		7		3s 123456us	2s 600326us

After appling this patchset, the performance of the file creation and deletion
on some filesystem become better. I have tested it with the following benchmark
tool on my x86_64 box.
  http://marc.info/?l=linux-btrfs&m=128212635122920&q=p3

Test steps:
# ./creat_unlink 50000

The result(Total time):
Ext4:
		2.6.36-rc4	2.6.36-rc4 + patch
file creation	0.737007	0.701888		4.8%UP
file deletion	0.422226	0.413457		2.1%UP

Btrfs:
		2.6.36-rc4	2.6.36-rc4 + patch
file creation	0.977638	0.935208		4.3%UP
file deletion	1.327140	1.221073		8%UP

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 arch/x86/include/asm/string_64.h |    1 +
 arch/x86/lib/Makefile            |    2 +-
 arch/x86/lib/memcpy_bwd_64.S     |  137 ++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/memmove_64.c        |   10 ++-
 4 files changed, 145 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/lib/memcpy_bwd_64.S

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 19e2c46..4e64a87 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -55,6 +55,7 @@ extern void *__memcpy(void *to, const void *from, size_t len);
 void *memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMMOVE
+extern void *__memcpy_bwd(void *dest, const void *src, size_t count);
 void *memmove(void *dest, const void *src, size_t count);
 
 int memcmp(const void *cs, const void *ct, size_t count);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index e10cf07..ab241df 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -19,7 +19,7 @@ obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
-lib-y += memcpy_$(BITS).o
+lib-y += memcpy_$(BITS).o memcpy_bwd_$(BITS).o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o
diff --git a/arch/x86/lib/memcpy_bwd_64.S b/arch/x86/lib/memcpy_bwd_64.S
new file mode 100644
index 0000000..ca894e3
--- /dev/null
+++ b/arch/x86/lib/memcpy_bwd_64.S
@@ -0,0 +1,137 @@
+/* Copyright 2010 Miao Xie */
+
+#include <linux/linkage.h>
+
+#include <asm/cpufeature.h>
+#include <asm/dwarf2.h>
+
+/*
+ * __memcpy_bwd - Copy a memory block from the end to the beginning
+ *
+ * Input:
+ *  rdi destination
+ *  rsi source
+ *  rdx count
+ *
+ * Output:
+ *  rax original destination
+ */
+
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemcpy_bwd_c:
+	movq %rdi, %rax
+
+	addq %rdx, %rdi
+	addq %rdx, %rsi
+	leaq -8(%rdi), %rdi
+	leaq -8(%rsi), %rsi
+
+	std
+
+	movq %rdx, %rcx
+	shrq $3, %rcx
+	andq $7, %rdx
+	rep movsq
+
+	leaq 8(%rdi), %rdi
+	leaq 8(%rsi), %rsi
+	decq %rsi
+	decq %rdi
+	movq %rdx, %rcx
+	rep movsb
+
+	cld
+	ret
+.Lmemcpy_bwd_e:
+	.previous
+
+ENTRY(__memcpy_bwd)
+	CFI_STARTPROC
+
+	movq %rdi, %rax
+
+	addq %rdx, %rdi
+	addq %rdx, %rsi
+
+	movq %rdx, %rcx
+	shrq $6, %rcx
+	jz .Lhandle_tail
+
+	.p2align 4
+.Lloop_64:
+	decq %rcx
+
+	leaq -64(%rdi), %rdi
+	leaq -64(%rsi), %rsi
+
+	movq 7*8(%rsi),	%r11
+	movq 6*8(%rsi),	%r8
+	movq %r11,	7*8(%rdi)
+	movq %r8,	6*8(%rdi)
+
+	movq 5*8(%rsi),	%r9
+	movq 4*8(%rsi),	%r10
+	movq %r9,	5*8(%rdi)
+	movq %r10,	4*8(%rdi)
+
+	movq 3*8(%rsi),	%r11
+	movq 2*8(%rsi),	%r8
+	movq %r11,	3*8(%rdi)
+	movq %r8,	2*8(%rdi)
+
+	movq 1*8(%rsi),	%r9
+	movq 0*8(%rsi),	%r10
+	movq %r9,	1*8(%rdi)
+	movq %r10,	0*8(%rdi)
+
+	jnz	.Lloop_64
+
+.Lhandle_tail:
+	movq %rdx, %rcx
+	andq $63, %rcx
+	shrq $3, %rcx
+	jz .Lhandle_7
+
+	.p2align 4
+.Lloop_8:
+	decq %rcx
+
+	leaq -8(%rsi), %rsi
+	leaq -8(%rdi), %rdi
+
+	movq (%rsi),	%r8
+	movq %r8,	(%rdi)
+
+	jnz .Lloop_8
+
+.Lhandle_7:
+	movq %rdx, %rcx
+	andq $7, %rcx
+	jz .Lend
+
+	.p2align 4
+.Lloop_1:
+	decq %rcx
+
+	decq %rsi
+	decq %rdi
+
+	movb (%rsi),	%r8b
+	movb %r8b,	(%rdi)
+
+	jnz .Lloop_1
+
+.Lend:
+	ret
+	CFI_ENDPROC
+ENDPROC(__memcpy_bwd)
+
+	.section .altinstructions, "a"
+	.align 8
+	.quad __memcpy_bwd
+	.quad .Lmemcpy_bwd_c
+	.word X86_FEATURE_REP_GOOD
+
+	.byte .Lmemcpy_bwd_e - .Lmemcpy_bwd_c
+	.byte .Lmemcpy_bwd_e - .Lmemcpy_bwd_c
+	.previous
diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 0a33909..bd4cbcc 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -8,14 +8,16 @@
 #undef memmove
 void *memmove(void *dest, const void *src, size_t count)
 {
-	if (dest < src) {
+	if (dest < src || dest - src >= count)
 		return memcpy(dest, src, count);
-	} else {
+	else if (count <= 64) {
 		char *p = dest + count;
 		const char *s = src + count;
 		while (count--)
 			*--p = *--s;
-	}
-	return dest;
+
+		return dest;
+	} else
+		return __memcpy_bwd(dest, src, count);
 }
 EXPORT_SYMBOL(memmove);
-- 
1.7.0.1
