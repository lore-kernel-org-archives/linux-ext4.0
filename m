From: tytso@mit.edu
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Sun, 21 Mar 2010 21:27:58 -0400
Message-ID: <20100322012758.GE11560@thunk.org>
References: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51213 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab0CVCMR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Mar 2010 22:12:17 -0400
Content-Disposition: inline
In-Reply-To: <ac8f92701003210701j5926f2c4v843e36bc602a0444@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 21, 2010 at 10:01:06PM +0800, jing zhang wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Sun Mar 21 21:59:35     2010
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
> 
> ---
> 
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc3.c	2010-03-21 21:37:18.000000000 +0800
> @@ -2360,6 +2360,24 @@ err_freesgi:
>  	return -ENOMEM;
>  }
> 
> +static void ext4_mb_destroy_backend(struct super_block *sb)
> +{
> +	ext4_group_t ngroups = ext4_get_groups_count(sb);
> +	ext4_group_t i;
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	int j;
> +	int num_meta_group_infos = (ngroups + EXT4_DESC_PER_BLOCK(sb) -1)
> +					>> EXT4_DESC_PER_BLOCK_BITS(sb);
> +	for (i = 0; i < ngroups; i++)
> +		kfree(ext4_get_group_info(sb, i));
> +
> +	for (j = 0; j < num_meta_group_infos; j++)
> +		kfree(sbi->s_group_info[j]);
> +
> +	kfree(sbi->s_group_info);
> +	iput(sbi->s_buddy_cache);
> +}
> +

It would be better if this could be done by making ext4_mb_release()
more flexible, and then calling ext4_mb_release() if there is an error
setting up the data structures in ext4_mb_init().

						- Ted
