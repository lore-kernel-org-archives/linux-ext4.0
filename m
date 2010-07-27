From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] Add batched discard support for ext4
Date: Tue, 27 Jul 2010 18:28:10 +0200
Message-ID: <20100727162810.GC6820@quack.suse.cz>
References: <1280234514-10287-1-git-send-email-lczerner@redhat.com>
 <1280234514-10287-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab0G0Q2h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 12:28:37 -0400
Content-Disposition: inline
In-Reply-To: <1280234514-10287-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 27-07-10 14:41:54, Lukas Czerner wrote:
> Walk through each allocation group and trim all free extents. It can be
> invoked through TRIM ioctl on the file system. The main idea is to
> provide a way to trim the whole file system if needed, since some SSD's
> may suffer from performance loss after the whole device was filled (it
> does not mean that fs is full!).
> 
> It search fro free extents in each allocation group. When the free
> extent is found, blocks are marked as used and then trimmed. Afterwards
> these blocks are marked as free in per-group bitmap.
> 
> Since fstrim is a long operation it is good to have an ability to interrupt
> it by a signal. This was added by Dmitry Monakhov. Thanks Dimitry.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  A couple of comments below...

> ---
>  fs/ext4/ext4.h    |    2 +
>  fs/ext4/mballoc.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/super.c   |    1 +
>  3 files changed, 106 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index b423a36..f00b7dd 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4640,3 +4640,106 @@ error_return:
>  		kmem_cache_free(ext4_ac_cachep, ac);
>  	return;
>  }
> +
> +/**
> + * Trim "count" blocks starting at "start" in "group"
> + * This must be called under group lock
> + */
> +static void ext4_trim_extent(struct super_block *sb, int start, int count,
> +		ext4_group_t group)
> +{
> +	ext4_fsblk_t discard_block;
> +	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
> +
> +	discard_block = (ext4_fsblk_t)group *
> +			EXT4_BLOCKS_PER_GROUP(sb)
> +			+ start
> +			+ le32_to_cpu(es->s_first_data_block);
   You can use ext4_group_first_block_no() I believe.

> +	trace_ext4_discard_blocks(sb,
> +			(unsigned long long)discard_block,
> +			count);
> +	sb_issue_discard(sb, discard_block, count);
> +	cond_resched();
> +}
> +
> +/**
> + * Trim all free extents in group at least minblocks long
> + */
> +ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
> +		ext4_grpblk_t minblocks)
> +{
> +	struct buffer_head *bitmap_bh = NULL;
> +	ext4_grpblk_t max = EXT4_BLOCKS_PER_GROUP(sb);
> +	ext4_grpblk_t start, next, count = 0;
> +	struct ext4_group_info *grp;
> +	int err = 0;
> +
> +	err = -EIO;
> +	bitmap_bh = ext4_read_block_bitmap(sb, group);
> +	if (!bitmap_bh)
> +		return 0;
> +
> +	grp = ext4_get_group_info(sb, group);
> +	start = grp->bb_first_free;
> +
> +	down_write(&grp->alloc_sem);
> +	while (start < max) {
> +
> +		start = mb_find_next_zero_bit(bitmap_bh->b_data, max, start);
> +		if (start >= max)
> +			break;
> +		next = mb_find_next_bit(bitmap_bh->b_data, max, start);
  Hmm, I don't think this is right. If you want to avoid doing the same
thing as you do for ext3, you have to use the buddy bitmap and not the
on-disk bitmap (we free blocks from a buddy bitmap only after a transaction
freeing them is committed). That way you avoid trimming blocks that were
freed in the transaction which is just committing (you mustn't do
that). So you have to load the buddy bitmap for the group into memory
(ext4_mb_load_buddy()), lock the group (ext4_group_lock()), and then you
can investigate the buddy bitmap (EXT4_MB_BITMAP()). You could actually use
the buddy information to make scanning bitmap faster (it carries
information about larger chunks of free blocks) but that's a voluntary
bonus I think ;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
