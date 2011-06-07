From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH RFC 05/30] ext4: snapshot hooks - delete blocks
Date: Tue, 7 Jun 2011 13:24:39 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106071306510.4754@dhcp-27-109.brq.redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <1304959308-11122-6-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: amir73il@users.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1FGLYx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 07:24:53 -0400
In-Reply-To: <1304959308-11122-6-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 9 May 2011, amir73il@users.sourceforge.net wrote:

> From: Amir Goldstein <amir73il@users.sf.net>
> 
> Before deleting file blocks in ext4_free_blocks(),
> we call the snapshot API ext4_snapshot_get_delete_access(),
> to optionally move the block to the snapshot file instead of
> freeing them.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/ext4.h    |   10 +++++++---
>  fs/ext4/mballoc.c |   30 +++++++++++++++++++++++++++---
>  2 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index ca25e67..4e9e46a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1729,9 +1729,13 @@ extern int ext4_mb_reserve_blocks(struct super_block *, int);
>  extern void ext4_discard_preallocations(struct inode *);
>  extern int __init ext4_init_mballoc(void);
>  extern void ext4_exit_mballoc(void);
> -extern void ext4_free_blocks(handle_t *handle, struct inode *inode,
> -			     struct buffer_head *bh, ext4_fsblk_t block,
> -			     unsigned long count, int flags);
> +extern void __ext4_free_blocks(const char *where, unsigned int line,
> +			       handle_t *handle,  struct inode *inode,
> +			       struct buffer_head *bh, ext4_fsblk_t block,
> +			       unsigned long count, int flags);
> +#define ext4_free_blocks(handle, inode, bh, block, count, flags) \
> +	__ext4_free_blocks(__func__, __LINE__ , (handle), (inode), (bh), \
> +			   (block), (count), (flags))
>  extern int ext4_mb_add_groupinfo(struct super_block *sb,
>  		ext4_group_t i, struct ext4_group_desc *desc);
>  extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e8bfd8d..3b1c6d1 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4445,9 +4445,9 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
>   * @count:		number of blocks to count
>   * @metadata: 		Are these metadata blocks
>   */
> -void ext4_free_blocks(handle_t *handle, struct inode *inode,
> -		      struct buffer_head *bh, ext4_fsblk_t block,
> -		      unsigned long count, int flags)
> +void __ext4_free_blocks(const char *where, unsigned int line, handle_t *handle,
> +			struct inode *inode, struct buffer_head *bh,
> +			ext4_fsblk_t block, unsigned long count, int flags)
>  {
>  	struct buffer_head *bitmap_bh = NULL;
>  	struct super_block *sb = inode->i_sb;
> @@ -4461,6 +4461,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
>  	struct ext4_buddy e4b;
>  	int err = 0;
>  	int ret;
> +	int maxblocks;
>  
>  	if (bh) {
>  		if (block)
> @@ -4543,6 +4544,29 @@ do_more:
>  		goto error_return;
>  	}
>  
> +	maxblocks = count;
> +	ret = ext4_snapshot_get_delete_access(handle, inode,
> +					      block, &maxblocks);

It would be nice to have this defined in the same commit, so I know what
is it doing.

> +	if (ret < 0) {
> +		ext4_journal_abort_handle(where, line, __func__,
> +					  NULL, handle, ret);
> +		err = ret;
> +		goto error_return;
> +	}
> +	if (ret > 0) {
> +		/* 'ret' blocks were moved to snapshot - skip them */
> +		block += maxblocks;
> +		count -= maxblocks;
> +		count += overflow;
> +		cond_resched();
> +		if (count > 0)
> +			goto do_more;
> +		/* no more blocks to free/move to snapshot */
> +		ext4_mark_super_dirty(sb);
> +		goto error_return;
> +	}
> +	overflow += count - maxblocks;
> +	count = maxblocks;
>  	BUFFER_TRACE(bitmap_bh, "getting write access");
>  	err = ext4_handle_get_bitmap_access(handle, sb, block_group, bitmap_bh);
>  	if (err)
> 
