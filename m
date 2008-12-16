From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Patch/BUG] (ext4) s_mb_maxs[] of ext4_sb_info is too small size
Date: Tue, 16 Dec 2008 10:58:24 -0600
Message-ID: <4947DE30.2090903@redhat.com>
References: <20081216170409.34EA.E1E9C6FF@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, Li Zefan <lizf@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
	Linux Kernel ML <linux-kernel@vger.kernel.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56973 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbYLPQ6x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Dec 2008 11:58:53 -0500
In-Reply-To: <20081216170409.34EA.E1E9C6FF@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Yasunori Goto wrote:
> Hello.
> 
> I chased the cause of following ext4 oops report which is tested on
> ia64 box.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12018
> 
> The cause is the size of s_mb_maxs array that is
> defined as "unsigned short" in ext4_sb_info structure.
> Unsigned short is too small.
> 
> In this bug report, Li-san formatted with 64Kbyte block size like
> the following. Ia64 has 64Kbyte page size, then this
> block size is acceptable.
> 
> # mkfs.ext4 -b 65536 /dev/md0
> 
> In this case, the maximum value of s_mb_maxs[] becomes 
> (blocksize << 2) = 256K by the following code.
> 
> 2482 int ext4_mb_init(struct super_block *sb, int needs_recovery)
>                : 
>                :
> 2508         max = sb->s_blocksize << 2;    <---- max becomes 0x40000.
> 2509         do {
> 2510                 sbi->s_mb_offsets[i] = offset;
> 2511                 sbi->s_mb_maxs[i] = max;            <--- over flow!!!
> 2512                 offset += 1 << (sb->s_blocksize_bits - i);
> 2513                 max = max >> 1;
> 2514                 i++;
> 2515         } while (i <= sb->s_blocksize_bits + 1);
> 
> Then, some s_mb_maxs[] becomes 0 due to overflow.
> It is cause of this oops. The following patch is to fix it.

Looks good to mee; and these lines before it:

        sbi->s_mb_maxs[0] = sb->s_blocksize << 3;
        sbi->s_mb_offsets[0] = 0;

mean that we would have a problem "even" on 8k blocks, yes?

-Eric

> Thanks.
> 
> ----
> 
> The size of s_mb_maxs that is defined in ext4_sb_info is too small.
> When block size is 64K, which is possible on ia64,
> the maximum value of s_mb_maxs becomes 256K(0x40000).
> However, s_mb_maxs is defined as unsigned short. This is cause of panic.
> 
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> 
> ---
>  fs/ext4/ext4_sb.h |    3 ++-
>  fs/ext4/mballoc.c |    2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> Index: test2/fs/ext4/ext4_sb.h
> ===================================================================
> --- test2.orig/fs/ext4/ext4_sb.h	2008-12-16 11:20:18.000000000 +0900
> +++ test2/fs/ext4/ext4_sb.h	2008-12-16 14:17:32.000000000 +0900
> @@ -101,7 +101,8 @@ struct ext4_sb_info {
>  	spinlock_t s_reserve_lock;
>  	spinlock_t s_md_lock;
>  	tid_t s_last_transaction;
> -	unsigned short *s_mb_offsets, *s_mb_maxs;
> +	unsigned short *s_mb_offsets;
> +	unsigned int *s_mb_maxs;
>  
>  	/* tunables */
>  	unsigned long s_stripe;
> Index: test2/fs/ext4/mballoc.c
> ===================================================================
> --- test2.orig/fs/ext4/mballoc.c	2008-12-16 11:20:18.000000000 +0900
> +++ test2/fs/ext4/mballoc.c	2008-12-16 14:23:21.000000000 +0900
> @@ -2493,6 +2493,8 @@ int ext4_mb_init(struct super_block *sb,
>  	if (sbi->s_mb_offsets == NULL) {
>  		return -ENOMEM;
>  	}
> +
> +	i = (sb->s_blocksize_bits + 2) * sizeof(unsigned int);

>  	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
>  	if (sbi->s_mb_maxs == NULL) {
>  		kfree(sbi->s_mb_maxs);
> 

