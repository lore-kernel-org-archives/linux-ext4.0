From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Date: Thu, 16 Sep 2010 18:47:59 +0800
Message-ID: <4C91F5DF.9060001@cn.fujitsu.com>
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>	<4C91C44F.40700@cn.fujitsu.com>	<20100916104008.3e1e34b2@basil.nowhere.org>	<4C91E37C.2060309@cn.fujitsu.com> <20100916121141.6eb95a22@basil.nowhere.org>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60847 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0IPKrx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Sep 2010 06:47:53 -0400
In-Reply-To: <20100916121141.6eb95a22@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 16 Sep 2010 12:11:41 +0200, Andi Kleen wrote:
> On Thu, 16 Sep 2010 17:29:32 +0800
> Miao Xie<miaox@cn.fujitsu.com>  wrote:
>
>
> Ok was a very broken patch. Sorry should have really done some more
> work on it. Anyways hopefully the corrected version is good for
> testing.
>
> -Andi
>

title: x86_64/lib: improve the performance of memmove

Implement the 64bit memmmove backwards case using string instructions

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
  arch/x86/lib/memcpy_64.S  |   29 +++++++++++++++++++++++++++++
  arch/x86/lib/memmove_64.c |    8 ++++----
  2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index bcbcd1e..9de5e9a 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -141,3 +141,32 @@ ENDPROC(__memcpy)
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
+ENTRY(memcpy_backwards)
+	CFI_STARTPROC
+	std
+	movq %rdi, %rax
+	movl %edx, %ecx
+	addq %rdx, %rdi
+	addq %rdx, %rsi
+	leaq -8(%rdi), %rdi
+	leaq -8(%rsi), %rsi
+	shrl $3, %ecx
+	andl $7, %edx
+	rep movsq
+	addq $7, %rdi
+	addq $7, %rsi
+	movl %edx, %ecx
+	rep movsb
+	cld
+	ret
+	CFI_ENDPROC
+ENDPROC(memcpy_backwards)
+	
diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 0a33909..6774fd8 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -5,16 +5,16 @@
  #include <linux/string.h>
  #include <linux/module.h>
  
+extern void * asmlinkage memcpy_backwards(void *dst, const void *src,
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
1.7.0.1

