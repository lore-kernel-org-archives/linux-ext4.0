From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 3/3] Ext2: remove the static function release_blocks
 to optimize the kernel
Date: Thu, 7 Feb 2013 16:45:38 +0100
Message-ID: <20130207154538.GD25392@quack.suse.cz>
References: <1360249074-2642-1-git-send-email-wangshilong1991@gmail.com>
 <1360249074-2642-2-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: Wang shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab3BGPpu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2013 10:45:50 -0500
Content-Disposition: inline
In-Reply-To: <1360249074-2642-2-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-02-13 22:57:54, Wang shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Because the static function 'release_blocks' is only called
> when releasing blocks,it will be more simple and efficient to
> call the function 'percpu_counter_add' directly.
  Thanks. I've added the patch to my tree.

							Honza
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext2/balloc.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 9d372bf..d5a6afd 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -159,15 +159,6 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
>  	return bh;
>  }
>  
> -static void release_blocks(struct super_block *sb, int count)
> -{
> -	if (count) {
> -		struct ext2_sb_info *sbi = EXT2_SB(sb);
> -
> -		percpu_counter_add(&sbi->s_freeblocks_counter, count);
> -	}
> -}
> -
>  static void group_adjust_blocks(struct super_block *sb, int group_no,
>  	struct ext2_group_desc *desc, struct buffer_head *bh, int count)
>  {
> @@ -569,7 +560,7 @@ do_more:
>  error_return:
>  	brelse(bitmap_bh);
>  	if (freed) {
> -		release_blocks(sb, freed);
> +		percpu_counter_add(&sbi->s_freeblocks_counter, freed);
>  		dquot_free_block_nodirty(inode, freed);
>  		mark_inode_dirty(inode);
>  	}
> -- 
> 1.7.11.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
