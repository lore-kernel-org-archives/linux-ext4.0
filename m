From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Fix a BUG in mb_mark_used during trim.
Date: Thu, 3 Mar 2011 11:01:49 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103031053380.8737@dhcp-27-109.brq.redhat.com>
References: <1299144832-5123-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	lczerner@redhat.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1CCKB5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Mar 2011 05:01:57 -0500
In-Reply-To: <1299144832-5123-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 3 Mar 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> In a bs=4096 volume, if we call FITRIM with the following parameter as
> fstrim_range(start = 102400, len = 134144000, minlen = 10240),
> we will trigger a BUG_ON.
> BUG_ON(start + len > (e4b->bd_sb->s_blocksize << 3));
> 
> Mar  4 00:55:52 boyu-tm kernel: ------------[ cut here ]------------
> Mar  4 00:55:52 boyu-tm kernel: kernel BUG at fs/ext4/mballoc.c:1506!
> Mar  4 01:21:09 boyu-tm kernel: Code: d4 00 00 00 00 49 89 fe 8b 56 0c 44 8b 7e 04 89 55 c4 48 8b 4f 28 89 d6 44 01 fe 48 63 d6 48 8b 41 18 48 c1 e0 03 48 39 c2 76 04 <0f> 0b eb fe 48 8b 55 b0 8b 47 34 3b 42 08 74 04 0f 0b eb fe 48
> Mar  4 01:21:09 boyu-tm kernel: RIP  [<ffffffffa053eb42>] mb_mark_used+0x47/0x26c [ext4]
> Mar  4 01:21:09 boyu-tm kernel:  RSP <ffff880121e45c38>
> Mar  4 01:21:09 boyu-tm kernel: ---[ end trace 9f461696f6a9dcf2 ]---
> 
> The reason is that in ext4_trim_fs, the last_block is checked wrongly.
> if (len >= EXT4_BLOCKS_PER_GROUP(sb))
> 	len -= (EXT4_BLOCKS_PER_GROUP(sb) - first_block);
> else
> 	last_block = first_block + len;
> 
> So if len < EXT4_BLOCKS_PER_GROUP while first_block + len > EXT4_BLOCKS_PER_GROUP,
> last_block will be set to a overflow value which exceeds EXT4_BLOCKS_PER_GROUP.
> 
> This patch fixes it and adjusts len accordingly.

Oh, thanks for spotting this. One comment though.

> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/mballoc.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 29d7d17..ed63c3e 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4889,10 +4889,11 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  			break;
>  		}
>  
> -		if (len >= EXT4_BLOCKS_PER_GROUP(sb))
> -			len -= (EXT4_BLOCKS_PER_GROUP(sb) - first_block);
> +		if (first_block + len >= EXT4_BLOCKS_PER_GROUP(sb))
> +			last_block = EXT4_BLOCKS_PER_GROUP(sb);
>  		else
>  			last_block = first_block + len;

Since last_block would not change until the last group, can we simplify
the condition ?

		if (first_block + len < EXT4_BLOCKS_PER_GROUP(sb))
			last_block = first_block + len;

> +		len -= last_block - first_block;
>  
>  		if (e4b.bd_info->bb_free >= minlen) {
>  			cnt = ext4_trim_all_free(sb, &e4b, first_block,
> 

Thanks!
-Lukas
