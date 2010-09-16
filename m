From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Date: Thu, 16 Sep 2010 17:29:32 +0800
Message-ID: <4C91E37C.2060309@cn.fujitsu.com>
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>	<4C91C44F.40700@cn.fujitsu.com> <20100916104008.3e1e34b2@basil.nowhere.org>
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
Received: from cn.fujitsu.com ([222.73.24.84]:61352 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab0IPJ30 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Sep 2010 05:29:26 -0400
In-Reply-To: <20100916104008.3e1e34b2@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 16 Sep 2010 10:40:08 +0200, Andi Kleen wrote:
> On Thu, 16 Sep 2010 15:16:31 +0800
> Miao Xie<miaox@cn.fujitsu.com>  wrote:
>
>> On Thu, 16 Sep 2010 08:48:25 +0200 (cest), Andi Kleen wrote:
>>>> When the dest and the src do overlap and the memory area is large,
>>>> memmove of
>>>> x86_64 is very inefficient, and it led to bad performance, such as
>>>> btrfs's file
>>>> deletion performance. This patch improved the performance of
>>>> memmove on x86_64
>>>> by using __memcpy_bwd() instead of byte copy when doing large
>>>> memory area copy
>>>> (len>   64).
>>>
>>>
>>> I still don't understand why you don't simply use a backwards
>>> string copy (with std) ? That should be much simpler and
>>> hopefully be as optimized for kernel copies on recent CPUs.
>>
>> But according to the comment of memcpy, some CPUs don't support "REP"
>> instruction,
>
> I think you misread the comment. REP prefixes are in all x86 CPUs.
> On some very old systems it wasn't optimized very well,
> but it probably doesn't make too much sense to optimize for those.
> On newer CPUs in fact REP should be usually faster than
> an unrolled loop.
>
> I'm not sure how optimized the backwards copy is, but most likely
> it is optimized too.
>
> Here's an untested patch that implements backwards copy with string
> instructions. Could you run it through your test harness?

Ok, I'll do it.

> +
> +/*
> + * Copy memory backwards (for memmove)
> + * rdi target
> + * rsi source
> + * rdx count
> + */
> +
> +ENTRY(memcpy_backwards):

s/://

> +	CFI_STARTPROC
> +	std
> +	movq %rdi, %rax
> +	movl %edx, %ecx
> +	add  %rdx, %rdi
> +	add  %rdx, %rsi

-	add  %rdx, %rdi
-	add  %rdx, %rsi
+	addq  %rdx, %rdi
+	addq  %rdx, %rsi

Besides that, the address that %rdi/%rsi pointed to is over the end of
mempry area that going to be copied, so we must tune the address to be
correct.
+	leaq -8(%rdi), %rdi
+	leaq -8(%rsi), %rsi

> +	shrl $3, %ecx
> +	andl $7, %edx
> +	rep movsq

The same as above.
+	leaq 8(%rdi), %rdi
+	leaq 8(%rsi), %rsi
+	decq %rsi
+	decq %rdi

> +	movl %edx, %ecx
> +	rep movsb
> +	cld
> +	ret
> +	CFI_ENDPROC
> +ENDPROC(memcpy_backwards)
> +	
> diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
> index 0a33909..6c00304 100644
> --- a/arch/x86/lib/memmove_64.c
> +++ b/arch/x86/lib/memmove_64.c
> @@ -5,16 +5,16 @@
>   #include<linux/string.h>
>   #include<linux/module.h>
>
> +extern void asmlinkage memcpy_backwards(void *dst, const void *src,
> +				        size_t count);

The type of the return value must be "void *".

Thanks
Miao

> +
>   #undef memmove
>   void *memmove(void *dest, const void *src, size_t count)
>   {
>   	if (dest<  src) {
>   		return memcpy(dest, src, count);
>   	} else {
> -		char *p = dest + count;
> -		const char *s = src + count;
> -		while (count--)
> -			*--p = *--s;
> +		return memcpy_backwards(dest, src, count);
>   	}
>   	return dest;
>   }
>
