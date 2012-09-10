From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/7] ext4: fsync should wait for DIO writers
Date: Mon, 10 Sep 2012 11:51:35 +0200
Message-ID: <20120910095135.GF22903@quack.suse.cz>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab2IJJvh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2012 05:51:37 -0400
Content-Disposition: inline
In-Reply-To: <1347211634-11509-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 09-09-12 21:27:11, Dmitry Monakhov wrote:
> fsync and punch_hole are the places where we have to wait for all
> existing writers (writeback, aio, dio), but currently we simply
> flush pended end_io request which is not sufficient.
  Why not? I guess you mean the fact that there can be DIO in flight for
which end_io() was not called so it is not queued in the queue? But that is
OK - we have not yet called aio_complete() for that IO so for userspace the
write has not happened yet. Thus there's no need to flush it to disk -
fsync() does not say anything about writes in progress while fsync is
called.

> Even more i_mutex is not holded while punch_hole which obviously
> result in dangerous data corruption due to write-after-free.
  Yes, that's a bug. I also noticed that but didn't get to fixing it (I'm
actually working on a more long term fix using range locking but that's
more of a research project so having somehow fixed at least the most
blatant locking problems is good).

								Honza

> 
> This patch performs following changes:
> 
> - Guard punch_hole with i_mutex
> - fsync and punch_hole now wait for all writers in flight
>   NOTE: XXX write-after-free race is still possible because
>   truncate_pagecache_range() is not completely reliable and where
>   is no easy way to stop writeback while punch_hole is in progress.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |   10 ++++++++--
>  fs/ext4/fsync.c   |    1 +
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e993879..8252651 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4845,6 +4845,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  			return err;
>  	}
>  
> +	mutex_lock(&inode->i_mutex);
>  	/* Now release the pages */
>  	if (last_page_offset > first_page_offset) {
>  		truncate_pagecache_range(inode, first_page_offset,
> @@ -4852,12 +4853,15 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	}
>  
>  	/* finish any pending end_io work */
> +	inode_dio_wait(inode);
>  	ext4_flush_completed_IO(inode);
>  
>  	credits = ext4_writepage_trans_blocks(inode);
>  	handle = ext4_journal_start(inode, credits);
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
> +		goto out_mutex;
> +	}
>  
>  	err = ext4_orphan_add(handle, inode);
>  	if (err)
> @@ -4951,6 +4955,8 @@ out:
>  	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>  	ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);
> +out_mutex:
> +	mutex_unlock(&inode->i_mutex);
>  	return err;
>  }
>  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 24f3719..290c5cf 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -204,6 +204,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	if (inode->i_sb->s_flags & MS_RDONLY)
>  		goto out;
>  
> +	inode_dio_wait(inode);
>  	ret = ext4_flush_completed_IO(inode);
>  	if (ret < 0)
>  		goto out;
> -- 
> 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
