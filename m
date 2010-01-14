From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: prevent reread after write IO error v2
Date: Thu, 14 Jan 2010 15:18:04 +0100
Message-ID: <20100114141803.GB3146@quack.suse.cz>
References: <4B4EB5B9.4020809@hitachi.com>
 <4B4EDE5C.8040600@hitachi.com>
 <4B4EEE86.7080807@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Nick Piggin <npiggin@suse.de>,
	dle-develop@lists.sourceforge.net,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab0ANOSI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jan 2010 09:18:08 -0500
Content-Disposition: inline
In-Reply-To: <4B4EEE86.7080807@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 14-01-10 19:14:30, Hidehiro Kawai wrote:
> This patch fixes the similar bug fixed by commit 95450f5a.
> 
> If a directory is modified, its data block is journaled as metadata
> and finally written back to the right place.  Now, we assume a
> transient write erorr happens on that writeback.  Uptodate flag of
> the buffer is cleared by write error, so next access on the buffer
> causes a reread from disk.  This means it breaks the filesystems
> consistency.
> 
> To prevent old directory data from being reread, this patch set
> uptodate flag again in the case of after write error before issuing
> the read operation.  The write error on the directory's data block
> is detected at the time of journal checkpointing or discarded if a
> rewrite by another modification succeeds, so no problem.
> 
> Similarly, this kind of consistency breakage can be caused by
> a transient write error on a bitmap block.
  Good catch, that's indeed a problem.

> I tested this patch by using fault injection approach.
> 
> By the way, I think the right fix is to keep uptodate flag on write
> error, but it gives a big impact.  We have to confirm whether
> over 200 buffer_uptodate's are used for real uptodate check or write
> error check.  For now, I adopt the quick-fix solution.
  Yes that needs to be solved. I also looked into it and it's too much work
to do it in a one big sweep. But I think we could do the conversion
filesystem by filesystem - see below.
  Admittedly, I don't like your solution very much. It looks strange to
check write_io_error when *reading* the buffer and I'm afraid we could
introduce bugs e.g. by clearing write_io_error bit so that ext3_bread would
then fail to detect the error condition or by some other code deciding to
read the buffer from disk via other function than just ext3_bread. So I
think it would be much better to set back uptodate flag shortly after the
failed write or not clear it at all.
  Now here's how I think we could achieve that without having to change all
other filesystems: We could create a new superblock flag which would mean
that "this filesystem handles write_io_error and doesn't want to clear
uptodate flag". Filesystems with this capability would set this flag when
calling get_sb_bdev. And if write IO fails we check this flag
(via bh->b_bdev->bd_super->s_flags) and clear / not clear uptodate flag
accordingly. What do you think?
  I know it's more work than your quick fix but it should fix all these
problems for ext3 once for all and it would be much cleaner...

									Honza
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> ---
>  fs/ext3/balloc.c |   12 ++++++++++++
>  fs/ext3/inode.c  |   13 +++++++++++++
>  fs/ext3/namei.c  |   15 ++++++++++++++-
>  3 files changed, 39 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 27967f9..5dc5ccf 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -156,6 +156,18 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
>  	if (likely(bh_uptodate_or_lock(bh)))
>  		return bh;
>  
> +	/*
> +	 * uptodate flag may have been cleared by a previous (transient)
> +	 * write IO error.  In this case, we don't want to reread its
> +	 * old on-disk data.  Actually the buffer has the latest data,
> +	 * so set uptodate flag again.
> +	 */
> +	if (buffer_write_io_error(bh)) {
> +		set_buffer_uptodate(bh);
> +		unlock_buffer(bh);
> +		return bh;
> +	}
> +
>  	if (bh_submit_read(bh) < 0) {
>  		brelse(bh);
>  		ext3_error(sb, __func__,
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 455e6e6..67d7849 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1077,10 +1077,23 @@ struct buffer_head *ext3_bread(handle_t *handle, struct inode *inode,
>  		return bh;
>  	if (buffer_uptodate(bh))
>  		return bh;
> +
> +	/*
> +	 * uptodate flag may have been cleared by a previous (transient)
> +	 * write IO error.  In this case, we don't want to reread its
> +	 * old on-disk data.  Actually the buffer has the latest data,
> +	 * so set uptodate flag again.
> +	 */
> +	if (buffer_write_io_error(bh)) {
> +		set_buffer_uptodate(bh);
> +		return bh;
> +	}
> +
>  	ll_rw_block(READ_META, 1, &bh);
>  	wait_on_buffer(bh);
>  	if (buffer_uptodate(bh))
>  		return bh;
> +
>  	put_bh(bh);
>  	*err = -EIO;
>  	return NULL;
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 7b0e44f..7ed8e45 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -909,7 +909,20 @@ restart:
>  				num++;
>  				bh = ext3_getblk(NULL, dir, b++, 0, &err);
>  				bh_use[ra_max] = bh;
> -				if (bh)
> +				if (!bh || buffer_uptodate(bh))
> +					continue;
> +
> +				/*
> +				 * uptodate flag may have been cleared by a
> +				 * previous (transient) write IO error.  In
> +				 * this case, we don't want to reread its
> +				 * old on-disk data.  Actually the buffer
> +				 * has the latest data, so set uptodate flag
> +				 * again.
> +				 */
> +				if (buffer_write_io_error(bh))
> +					set_buffer_uptodate(bh);
> +				else
>  					ll_rw_block(READ_META, 1, &bh);
>  			}
>  		}
> -- 
> 1.6.0.3
> 
> 
> 
> -- 
> Hidehiro Kawai
> Hitachi, Systems Development Laboratory
> Linux Technology Center
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
