From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/7] ext4: fsync should wait for DIO writers
Date: Mon, 10 Sep 2012 14:56:04 +0400
Message-ID: <87bohegn97.fsf@openvz.org>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org> <1347211634-11509-5-git-send-email-dmonakhov@openvz.org> <20120910095135.GF22903@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52833 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757076Ab2IJK4I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2012 06:56:08 -0400
Received: by lagy9 with SMTP id y9so993942lag.19
        for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2012 03:56:06 -0700 (PDT)
In-Reply-To: <20120910095135.GF22903@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 10 Sep 2012 11:51:35 +0200, Jan Kara <jack@suse.cz> wrote:
> On Sun 09-09-12 21:27:11, Dmitry Monakhov wrote:
> > fsync and punch_hole are the places where we have to wait for all
> > existing writers (writeback, aio, dio), but currently we simply
> > flush pended end_io request which is not sufficient.
>   Why not? I guess you mean the fact that there can be DIO in flight for
> which end_io() was not called so it is not queued in the queue? But that is
> OK - we have not yet called aio_complete() for that IO so for userspace the
> write has not happened yet. Thus there's no need to flush it to disk -
> fsync() does not say anything about writes in progress while fsync is
> called.
>From posix point of view(which is good one) may be wait for aio-dio's is
overwhelming guarantee.
> > Even more i_mutex is not holded while punch_hole which obviously
> > result in dangerous data corruption due to write-after-free.
>   Yes, that's a bug. I also noticed that but didn't get to fixing it (I'm
> actually working on a more long term fix using range locking but that's
> more of a research project so having somehow fixed at least the most
> blatant locking problems is good).
Yes you right. In order to do things right we should block:
1) direct io
2) pagecache /mmap users (writeback, readpage)

A assumes I've fixed (1) but (2) is still exist

My current assumption is to do actions similar to writeback

   down_write(EXT4_I(inode)->i_data_sem)
   while (index <= end && pagevec_lookup(&pvec, mapping, index,...) {
        lock_page(pvec[i]);
        zero_user_page(pvec[i], 0, PAGE_SIZE);
        ret = try_to_release_page(pvec[i]);
   }
   /* At this moment we know that we locked all pages in range,
    * NOTE!!!! currently ext_remove_space may drop i_data_sem internally
    * so it should be modified to exit once i_mutex was dropped
   */
   ret = ext4_ext_remove_space(inode, from, to, NO_RELOCK)
   while (pvec_num)
         unlock_page(pvec[i])
   }
   up_write(EXT4_I(inode)->i_data_sem)

Number of locked pages should not be too large
Or even more instead of massive page locking, we can lock page
one by one, and simulate fake writeback, so all new writers will
wait on that bit, but readers will see zeroes.
   down_write(EXT4_I(inode)->i_data_sem)
   while (index <= end && pagevec_lookup(&pvec, mapping, index,...) {
        lock_page(pvec[i]);
        zero_user_page(pvec[i], 0, PAGE_SIZE);
        ret = try_to_release_page(pvec[i]);
        set_page_writeback(pvec[i]);
        unlock_page(pvec[i])
   }
   
   ret = ext4_ext_remove_space(inode, from, to, NO_RELOCK)
   while (pvec_num) {
         end_page_writeback(pvec[i])
   }
   up_write(EXT4_I(inode)->i_data_sem)

> 
> 								Honza
> 
> > 
> > This patch performs following changes:
> > 
> > - Guard punch_hole with i_mutex
> > - fsync and punch_hole now wait for all writers in flight
> >   NOTE: XXX write-after-free race is still possible because
> >   truncate_pagecache_range() is not completely reliable and where
> >   is no easy way to stop writeback while punch_hole is in progress.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/extents.c |   10 ++++++++--
> >  fs/ext4/fsync.c   |    1 +
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index e993879..8252651 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4845,6 +4845,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
> >  			return err;
> >  	}
> >  
> > +	mutex_lock(&inode->i_mutex);
> >  	/* Now release the pages */
> >  	if (last_page_offset > first_page_offset) {
> >  		truncate_pagecache_range(inode, first_page_offset,
> > @@ -4852,12 +4853,15 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
> >  	}
> >  
> >  	/* finish any pending end_io work */
> > +	inode_dio_wait(inode);
> >  	ext4_flush_completed_IO(inode);
> >  
> >  	credits = ext4_writepage_trans_blocks(inode);
> >  	handle = ext4_journal_start(inode, credits);
> > -	if (IS_ERR(handle))
> > -		return PTR_ERR(handle);
> > +	if (IS_ERR(handle)) {
> > +		err = PTR_ERR(handle);
> > +		goto out_mutex;
> > +	}
> >  
> >  	err = ext4_orphan_add(handle, inode);
> >  	if (err)
> > @@ -4951,6 +4955,8 @@ out:
> >  	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
> >  	ext4_mark_inode_dirty(handle, inode);
> >  	ext4_journal_stop(handle);
> > +out_mutex:
> > +	mutex_unlock(&inode->i_mutex);
> >  	return err;
> >  }
> >  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> > diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> > index 24f3719..290c5cf 100644
> > --- a/fs/ext4/fsync.c
> > +++ b/fs/ext4/fsync.c
> > @@ -204,6 +204,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> >  	if (inode->i_sb->s_flags & MS_RDONLY)
> >  		goto out;
> >  
> > +	inode_dio_wait(inode);
> >  	ret = ext4_flush_completed_IO(inode);
> >  	if (ret < 0)
> >  		goto out;
> > -- 
> > 1.7.7.6
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
