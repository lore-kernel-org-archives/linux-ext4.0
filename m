From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
Date: Thu, 16 Sep 2010 19:47:19 +0800
Message-ID: <4C9203C7.4050705@cn.fujitsu.com>
References: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>	<4C91C44F.40700@cn.fujitsu.com>	<20100916104008.3e1e34b2@basil.nowhere.org>	<4C91E37C.2060309@cn.fujitsu.com> <20100916121141.6eb95a22@basil.nowhere.org> <4C91F5DF.9060001@cn.fujitsu.com>
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
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C91F5DF.9060001@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 16 Sep 2010 18:47:59 +0800
, Miao Xie wrote:
> On Thu, 16 Sep 2010 12:11:41 +0200, Andi Kleen wrote:
>> On Thu, 16 Sep 2010 17:29:32 +0800
>> Miao Xie<miaox@cn.fujitsu.com> wrote:
>>
>>
>> Ok was a very broken patch. Sorry should have really done some more
>> work on it. Anyways hopefully the corrected version is good for
>> testing.
>>
>> -Andi

The test result is following:
Len	Src Unalign	Dest Unalign	Patch applied	Without Patch	
---	-----------	------------	-------------	-------------
8	0		0		0s 421117us	0s 70203us
8	0		3		0s 252622us	0s 42114us
8	0		7		0s 252663us	0s 42111us
8	3		0		0s 252666us	0s 42114us
8	3		3		0s 252667us	0s 42113us
8	3		7		0s 252667us	0s 42112us
32	0		0		0s 252672us	0s 114301us
32	0		3		0s 252676us	0s 114306us
32	0		7		0s 252663us	0s 114300us
32	3		0		0s 252661us	0s 114305us
32	3		3		0s 252663us	0s 114300us
32	3		7		0s 252668us	0s 114304us
64	0		0		0s 252672us	0s 236119us
64	0		3		0s 264671us	0s 236120us
64	0		7		0s 264702us	0s 236127us
64	3		0		0s 270701us	0s 236128us
64	3		3		0s 287236us	0s 236809us
64	3		7		0s 287257us	0s 236123us

According to the above result, old version is better than the new one when the
memory area is small.

Len	Src Unalign	Dest Unalign	Patch applied	Without Patch	
---	-----------	------------	-------------	-------------
256	0		0		0s 281886us	0s 813660us
256	0		3		0s 332169us	0s 813645us
256	0		7		0s 342961us	0s 813639us
256	3		0		0s 305305us	0s 813634us
256	3		3		0s 386939us	0s 813638us
256	3		7		0s 370511us	0s 814335us
512	0		0		0s 310716us	1s 584677us
512	0		3		0s 456420us	1s 583353us
512	0		7		0s 468236us	1s 583248us
512	3		0		0s 493987us	1s 583659us
512	3		3		0s 588041us	1s 584294us
512	3		7		0s 605489us	1s 583650us
1024	0		0		0s 406971us	3s 123644us
1024	0		3		0s 748419us	3s 126514us
1024	0		7		0s 756153us	3s 127178us
1024	3		0		0s 854681us	3s 130013us
1024	3		3		1s 46828us	3s 140190us
1024	3		7		1s 35886us	3s 135508us

the new version is better when the memory area is large.

Thanks!
Miao

>>
>
> title: x86_64/lib: improve the performance of memmove
>
> Implement the 64bit memmmove backwards case using string instructions
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> arch/x86/lib/memcpy_64.S | 29 +++++++++++++++++++++++++++++
> arch/x86/lib/memmove_64.c | 8 ++++----
> 2 files changed, 33 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
> index bcbcd1e..9de5e9a 100644
> --- a/arch/x86/lib/memcpy_64.S
> +++ b/arch/x86/lib/memcpy_64.S
> @@ -141,3 +141,32 @@ ENDPROC(__memcpy)
> .byte .Lmemcpy_e - .Lmemcpy_c
> .byte .Lmemcpy_e - .Lmemcpy_c
> .previous
> +
> +/*
> + * Copy memory backwards (for memmove)
> + * rdi target
> + * rsi source
> + * rdx count
> + */
> +
> +ENTRY(memcpy_backwards)
> + CFI_STARTPROC
> + std
> + movq %rdi, %rax
> + movl %edx, %ecx
> + addq %rdx, %rdi
> + addq %rdx, %rsi
> + leaq -8(%rdi), %rdi
> + leaq -8(%rsi), %rsi
> + shrl $3, %ecx
> + andl $7, %edx
> + rep movsq
> + addq $7, %rdi
> + addq $7, %rsi
> + movl %edx, %ecx
> + rep movsb
> + cld
> + ret
> + CFI_ENDPROC
> +ENDPROC(memcpy_backwards)
> +
> diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
> index 0a33909..6774fd8 100644
> --- a/arch/x86/lib/memmove_64.c
> +++ b/arch/x86/lib/memmove_64.c
> @@ -5,16 +5,16 @@
> #include <linux/string.h>
> #include <linux/module.h>
>
> +extern void * asmlinkage memcpy_backwards(void *dst, const void *src,
> + size_t count);
> +
> #undef memmove
> void *memmove(void *dest, const void *src, size_t count)
> {
> if (dest < src) {
> return memcpy(dest, src, count);
> } else {
> - char *p = dest + count;
> - const char *s = src + count;
> - while (count--)
> - *--p = *--s;
> + return memcpy_backwards(dest, src, count);
> }
> return dest;
> }

