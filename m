From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Date: Thu, 16 Sep 2010 10:40:08 +0200
Message-ID: <20100916104008.3e1e34b2@basil.nowhere.org>
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
	<4C91C44F.40700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:35410 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab0IPIkO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Sep 2010 04:40:14 -0400
In-Reply-To: <4C91C44F.40700@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 16 Sep 2010 15:16:31 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> On Thu, 16 Sep 2010 08:48:25 +0200 (cest), Andi Kleen wrote:
> >> When the dest and the src do overlap and the memory area is large,
> >> memmove of
> >> x86_64 is very inefficient, and it led to bad performance, such as
> >> btrfs's file
> >> deletion performance. This patch improved the performance of
> >> memmove on x86_64
> >> by using __memcpy_bwd() instead of byte copy when doing large
> >> memory area copy
> >> (len>  64).
> >
> >
> > I still don't understand why you don't simply use a backwards
> > string copy (with std) ? That should be much simpler and
> > hopefully be as optimized for kernel copies on recent CPUs.
> 
> But according to the comment of memcpy, some CPUs don't support "REP"
> instruction, 

I think you misread the comment. REP prefixes are in all x86 CPUs.
On some very old systems it wasn't optimized very well,
but it probably doesn't make too much sense to optimize for those.
On newer CPUs in fact REP should be usually faster than 
an unrolled loop.

I'm not sure how optimized the backwards copy is, but most likely
it is optimized too.

Here's an untested patch that implements backwards copy with string
instructions. Could you run it through your test harness?

-Andi


Implement the 64bit memmmove backwards case using string instructions

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index bcbcd1e..6e8258d 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -141,3 +141,28 @@ ENDPROC(__memcpy)
 	.byte .Lmemcpy_e - .Lmemcpy_c
 	.byte .Lmemcpy_e - .Lmemcpy_c
 	.previous
+
+/* 
+ * Copy memory backwards (for memmove)
+ * rdi target
+ * rsi source
+ * rdx count
+ */
+
+ENTRY(memcpy_backwards):
+	CFI_STARTPROC
+	std
+	movq %rdi, %rax
+	movl %edx, %ecx
+	add  %rdx, %rdi
+	add  %rdx, %rsi
+	shrl $3, %ecx
+	andl $7, %edx
+	rep movsq
+	movl %edx, %ecx
+	rep movsb
+	cld
+	ret
+	CFI_ENDPROC
+ENDPROC(memcpy_backwards)
+	
diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 0a33909..6c00304 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -5,16 +5,16 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
+extern void asmlinkage memcpy_backwards(void *dst, const void *src,
+				        size_t count);
+
 #undef memmove
 void *memmove(void *dest, const void *src, size_t count)
 {
 	if (dest < src) {
 		return memcpy(dest, src, count);
 	} else {
-		char *p = dest + count;
-		const char *s = src + count;
-		while (count--)
-			*--p = *--s;
+		return memcpy_backwards(dest, src, count);
 	}
 	return dest;
 }



-- 
ak@linux.intel.com -- Speaking for myself only.
