From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] e2fsprogs: move code computing old_desc_blocks to
 a function
Date: Mon, 23 Jan 2012 11:56:33 -0500
Message-ID: <20120123165633.GC4439@thunk.org>
References: <1325674932-26069-1-git-send-email-xiaoqiangnk@gmail.com>
 <1325674932-26069-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34118 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2AWSKB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 13:10:01 -0500
Content-Disposition: inline
In-Reply-To: <1325674932-26069-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 04, 2012 at 07:02:11PM +0800, Yongqiang Yang wrote:
> diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
> index 33da7d6..f1d5156 100644
> --- a/lib/ext2fs/blknum.c
> +++ b/lib/ext2fs/blknum.c
> @@ -98,6 +98,20 @@ blk64_t ext2fs_blocks_count(struct ext2_super_block *super)
>  }
>  
>  /*
> + * Return the old desc blocks count
> + */
> +blk64_t ext2fs_old_desc_blocks_count(ext2_filsys fs)
> +{
> +	blk64_t old_desc_blocks;
> +
> +	old_desc_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
> +	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG &&
> +	    old_desc_blocks > fs->super->s_first_meta_bg)
> +		old_desc_blocks = fs->super->s_first_meta_bg;
> +	return old_desc_blocks;

I'd prefer if you don't refactor code and change what it does at the
same time.  That makes it harder later to figure out whether a bug is
introduced by the refactorization, or by the change in the
calculation.  It's especially bad when there is no mention of the
change of the calculation in the commit description.

As I mentioned in my comments for your 3/3 patch, s_first_meta_bg
should *always* be less than old_desc_blocks, since it describes the
meta-blockgroup number where we start using the meta-blockgroup
layout.  Since there the size of the meta-blockgroup is defined to be
the number of block groups descriptors that fit in a block, by
definition the meta_bg must be less than or equal to old_desc_blocks.
If it isn't the superblock must be corrupt.

I think it's much better to fix this by adding a check to open and
initialization functions.

						- Ted
