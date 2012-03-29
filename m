From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: remove max_debt in find_group_orlov()
Date: Thu, 29 Mar 2012 17:27:52 +0200
Message-ID: <20120329152752.GB19400@quack.suse.cz>
References: <4F71679C.7080401@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab2C2P2F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Mar 2012 11:28:05 -0400
Content-Disposition: inline
In-Reply-To: <4F71679C.7080401@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 27-03-12 16:09:16, Akira Fujita wrote:
> max_debt, involved variables and calculations
> are no longer needed, clean them up.
  Thanks. Merged into my tree.

							Honza

> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---
>  fs/ext3/ialloc.c |   20 ++------------------
>  1 files changed, 2 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> index 1cde284..8bc04e6 100644
> --- a/fs/ext3/ialloc.c
> +++ b/fs/ext3/ialloc.c
> @@ -191,8 +191,7 @@ error_return:
>   * It's OK to put directory into a group unless
>   * it has too many directories already (max_dirs) or
>   * it has too few free inodes left (min_inodes) or
> - * it has too few free blocks left (min_blocks) or
> - * it's already running too large debt (max_debt).
> + * it has too few free blocks left (min_blocks).
>   * Parent's group is preferred, if it doesn't satisfy these
>   * conditions we search cyclically through the rest. If none
>   * of the groups look good we just look for a group with more
> @@ -202,21 +201,16 @@ error_return:
>   * when we allocate an inode, within 0--255.
>   */
>  
> -#define INODE_COST 64
> -#define BLOCK_COST 256
> -
>  static int find_group_orlov(struct super_block *sb, struct inode *parent)
>  {
>  	int parent_group = EXT3_I(parent)->i_block_group;
>  	struct ext3_sb_info *sbi = EXT3_SB(sb);
> -	struct ext3_super_block *es = sbi->s_es;
>  	int ngroups = sbi->s_groups_count;
>  	int inodes_per_group = EXT3_INODES_PER_GROUP(sb);
>  	unsigned int freei, avefreei;
>  	ext3_fsblk_t freeb, avefreeb;
> -	ext3_fsblk_t blocks_per_dir;
>  	unsigned int ndirs;
> -	int max_debt, max_dirs, min_inodes;
> +	int max_dirs, min_inodes;
>  	ext3_grpblk_t min_blocks;
>  	int group = -1, i;
>  	struct ext3_group_desc *desc;
> @@ -253,20 +247,10 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
>  		goto fallback;
>  	}
>  
> -	blocks_per_dir = (le32_to_cpu(es->s_blocks_count) - freeb) / ndirs;
> -
>  	max_dirs = ndirs / ngroups + inodes_per_group / 16;
>  	min_inodes = avefreei - inodes_per_group / 4;
>  	min_blocks = avefreeb - EXT3_BLOCKS_PER_GROUP(sb) / 4;
>  
> -	max_debt = EXT3_BLOCKS_PER_GROUP(sb) / max(blocks_per_dir, (ext3_fsblk_t)BLOCK_COST);
> -	if (max_debt * INODE_COST > inodes_per_group)
> -		max_debt = inodes_per_group / INODE_COST;
> -	if (max_debt > 255)
> -		max_debt = 255;
> -	if (max_debt == 0)
> -		max_debt = 1;
> -
>  	for (i = 0; i < ngroups; i++) {
>  		group = (parent_group + i) % ngroups;
>  		desc = ext3_get_group_desc (sb, group, NULL);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
