From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] Ext2: remove the static function release_blocks to
 optimize the kernel
Date: Wed, 6 Feb 2013 13:48:17 +0100
Message-ID: <20130206124817.GD6330@quack.suse.cz>
References: <1360131268-1615-1-git-send-email-wangshilong1991@gmail.com>
 <1360131268-1615-3-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: Wang shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab3BFMs3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2013 07:48:29 -0500
Content-Disposition: inline
In-Reply-To: <1360131268-1615-3-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 06-02-13 14:14:28, Wang shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Because the static function 'release_blocks' is only called
> when releasing blocks,it will be more simple and efficient to
> call the function 'percpu_counter_add' directly.
  Thanks. The patch looks good. Just it depends on the previous patch so
please resend it once with the previous one fixed. Thanks.

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
