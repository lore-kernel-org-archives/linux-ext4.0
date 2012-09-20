From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH] e2fsprogs: Fix reserved blocks calculation for mke2fs
 -m 50%
Date: Thu, 20 Sep 2012 10:05:06 +0900
Message-ID: <505A6BC2.4080803@rs.jp.nec.com>
References: <503F4B71.7090001@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:52202 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2ITBLe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2012 21:11:34 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id q8K1BXbu000683
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2012 10:11:33 +0900 (JST)
In-Reply-To: <503F4B71.7090001@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Could you check this patch?

(2012/08/30 20:16), Akira Fujita wrote:
> mke2fs -m option can set reserved blocks ratio up to 50%.
> But if the last BG is not big enough to support the necessary data
> structures, reserved blocks ratio can exceed 50%
> and we never succeed in e2fsck with that FS.
> This bug happens on ext2, ext3 and ext4.
> 
> To fix this, the patch recalculates reserved blocks count
> if FS blocks count is changed in mke2fs because of
> the last BG's size.
> 
> Steps to reproduce:
> 
> 1. Create a FS which has the overhead for the last BG
>     and specify 50 % for reserved blocks ratio
>   # mke2fs -m 50 -t ext4 DEV 1025M
> 
>   mke2fs 1.42.5 (29-Jul-2012)
>   warning: 256 blocks unused.
> 
>   Filesystem label=
>   OS type: Linux
>   Block size=4096 (log=2)
>   Fragment size=4096 (log=2)
>   Stride=0 blocks, Stripe width=0 blocks
>   656640 inodes, 2621440 blocks
>   1310848 blocks (50.00%) reserved for the super user
>   ~~~~~~~ <-- Reserved blocks exceed 50% of FS blocks count!
> 
> 2. e2fsck outputs filesystem corruption
>   # e2fsck DEV
> 
>   e2fsck 1.42.5 (29-Jul-2012)
>   Corruption found in superblock.  (r_blocks_count = 1310848).
> 
>   The superblock could not be read or does not describe a correct ext2
>   filesystem.  If the device is valid and it really contains an ext2
>   filesystem (and not swap or ufs or something else), then the superblock
>   is corrupt, and you might try running e2fsck with an alternate superblock:
>       e2fsck -b 32768 <device>
> 
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.ne.com>
> ---
>   lib/ext2fs/initialize.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index 5a6f8ea..3567722 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -101,6 +101,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
>   	unsigned	reserved_inos;
>   	char		*buf = 0;
>   	char		c;
> +	double		reserved_ratio;
>   
>   	if (!param || !ext2fs_blocks_count(param))
>   		return EXT2_ET_INVALID_ARGUMENT;
> @@ -391,6 +392,14 @@ ipg_retry:
>   	if (rem && (rem < overhead+50)) {
>   		ext2fs_blocks_count_set(super, ext2fs_blocks_count(super) -
>   					rem);
> +		/*
> +		 * If blocks count is changed, we need to recalculate
> +		 * reserved blocks count not to exceed 50%.
> +		 */
> +		reserved_ratio = 100.0 * ext2fs_r_blocks_count(param) /
> +			ext2fs_blocks_count(param);
> +		ext2fs_r_blocks_count_set(super, reserved_ratio *
> +			ext2fs_blocks_count(super) / 100.0);
>   
>   		goto retry;
>   	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Akira Fujita <a-fujita@rs.jp.nec.com>

The First Fundamental Software Development Group,
Platform Division, NEC Software Tohoku, Ltd.

