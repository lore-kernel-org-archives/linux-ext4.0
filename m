From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [PATCH 5/5][64-BIT] fix inode->i_blocks 32-bit wrap in e2fsck/pass1.c.
Date: Wed, 15 Apr 2009 15:59:50 -0400
Message-ID: <20090415195950.GG1668@shell>
References: <11660.1239227250@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZDOT7y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 15:59:54 -0400
Content-Disposition: inline
In-Reply-To: <11660.1239227250@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2009 at 05:47:30PM -0400, Nick Dokos wrote:
> Running e2fsck on a 32TiB fs with a 16TiB file in it produced this
> error:
> 
> sudo ./e2fsck -n -f /dev/mapper/bigvg-bigvol
> e2fsck 1.41.4 (27-Jan-2009)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 13, i_blocks is 3216, should be 34359741584.  Fix? no
> 
> This patch adds a 64-bit aware access function to lib/ext2fs/blknum.c
> and uses that, instead of accessing the i_blocks field directly.
> 
> With this patch, the above error goes away.
> 
> In addition, there was a stutter in the code, where inode->i_blocks was checked
> twice in an if statement: I got rid of one instance. This was harmless,
> but unnecessary.
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

> ---
>  e2fsck/pass1.c      |    6 +++---
>  lib/ext2fs/blknum.c |   11 +++++++++++
>  lib/ext2fs/ext2fs.h |    2 ++
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 8c4d170..d69dd5c 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -828,7 +828,7 @@ void e2fsck_pass1(e2fsck_t ctx)
>  				check_blocks(ctx, &pctx, block_buf);
>  				continue;
>  			}
> -			if ((inode->i_links_count || inode->i_blocks ||
> +			if ((inode->i_links_count ||
>  			     inode->i_blocks || inode->i_block[0]) &&
>  			    fix_problem(ctx, PR_1_JOURNAL_INODE_NOT_CLEAR,
>  					&pctx)) {
> @@ -1925,7 +1925,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  		pb.num_blocks *= (fs->blocksize / 512);
>  #if 0
>  	printf("inode %u, i_size = %lu, last_block = %lld, i_blocks=%lu, num_blocks = %lu\n",
> -	       ino, inode->i_size, pb.last_block, inode->i_blocks,
> +	       ino, inode->i_size, pb.last_block, ext2fs_inode_i_blocks(fs, inode),
>  	       pb.num_blocks);
>  #endif
>  	if (pb.is_dir) {
> @@ -1974,7 +1974,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  	if (LINUX_S_ISREG(inode->i_mode) &&
>  	    (inode->i_size_high || inode->i_size & 0x80000000UL))
>  		ctx->large_files++;
> -	if ((pb.num_blocks != inode->i_blocks) ||
> +	if ((pb.num_blocks != ext2fs_inode_i_blocks(fs, inode)) ||
>  	    ((fs->super->s_feature_ro_compat &
>  	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
>  	     (inode->i_flags & EXT4_HUGE_FILE_FL) &&
> diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
> index 5959ded..b9666fb 100644
> --- a/lib/ext2fs/blknum.c
> +++ b/lib/ext2fs/blknum.c
> @@ -55,6 +55,17 @@ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
>  }
>  
>  /*
> + * Return the inode i_blocks count
> + */
> +blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
> +					struct ext2_inode *inode)
> +{
> +	return (inode->i_blocks |
> +		(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
> +		 (__u64)inode->osd2.linux2.l_i_blocks_hi << 32 : 0));
> +}
> +
> +/*
>   * Return the fs block count
>   */
>  blk64_t ext2fs_blocks_count(struct ext2_super_block *super)
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index ea8209b..b97d39e 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -735,6 +735,8 @@ extern blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group);
>  extern blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group);
>  extern blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
>  					 struct ext2_inode *inode);
> +extern blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
> +					 struct ext2_inode *inode);
>  extern blk64_t ext2fs_blocks_count(struct ext2_super_block *super);
>  extern void ext2fs_blocks_count_set(struct ext2_super_block *super,
>  				    blk64_t blk);
> -- 
> 1.6.0.6
> 
