From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] ext4: serialize dio nolocked reads with defrag
 workers V2
Date: Mon, 10 Sep 2012 12:00:52 +0200
Message-ID: <20120910100052.GH22903@quack.suse.cz>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-4-git-send-email-dmonakhov@openvz.org>
 <20120910093126.GE22903@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab2IJKAy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2012 06:00:54 -0400
Content-Disposition: inline
In-Reply-To: <20120910093126.GE22903@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 10-09-12 11:31:26, Jan Kara wrote:
> On Sun 09-09-12 21:27:10, Dmitry Monakhov wrote:
> > Inode's block defrag and ext4_change_inode_journal_flag() may
> > affect nonlocked DIO reads result, so proper synchronization
> > required.
> > 
> > - Add missed inode_dio_wait() calls where appropriate
> > - Check inode state under extra i_dio_count reference.
> > 
> > Changes from V1:
> > - add missed memory bariers
> > - move DIOREAD_LOCK state check out from generic should_dioread_nolock
> >   otherwise it will affect existing DIO readers.
>   Looks good. Just maybe I would rename ext4_inode_dio_wait() to
> ext4_inode_block_unlocked_dio(). Anyway you can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
  Oh, I found one more thing:

> > +/* Wait for existing dio workers
> > + * Disable DIO read nolock optimization, so new dioreaders will
> > + * be forced to grab i_mutex
> > +*/
> > +void ext4_inode_dio_wait(struct inode *inode, int resume_readers)
> > +{
> > +	ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
> > +	smp_mb();
> > +	inode_dio_wait(inode);
> > +	if (resume_readers)
> > +		ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
> > +}
> > +
 I've just now noticed the resume_readers argument.
a) You probably meant to call ext4_clear_inode_state() when that argument
is set?
b) You need a smp_mb() before clearing DIOREAD_LOCK?
c) Please remove the resume_readers argument and make a separate function
from that. That new function could be called:
ext4_inode_unblock_unlocked_dio().

								Honza

> >  /*
> >   * O_DIRECT for ext3 (or indirect map) based files
> >   *
> > @@ -810,10 +823,20 @@ retry:
> >  		if (unlikely(!list_empty(&ei->i_completed_io_list)))
> >  			ext4_flush_completed_IO(inode);
> >  
> > +		/* Nolock dioread optimization may be dynamically disabled.
> > +		 * Check inode's state while holding extra i_dio_count ref. */
> > +		atomic_inc(&inode->i_dio_count);
> > +		smp_mb();
> > +		if (!unlikely(ext4_test_inode_state(inode,
> > +						    EXT4_STATE_DIOREAD_LOCK))) {
> > +			inode_dio_done(inode);
> > +			goto retry;
> > +		}
> >  		ret = __blockdev_direct_IO(rw, iocb, inode,
> >  				 inode->i_sb->s_bdev, iov,
> >  				 offset, nr_segs,
> >  				 ext4_get_block, NULL, NULL, 0);
> > +		inode_dio_done(inode);
> >  	} else {
> >  		ret = blockdev_direct_IO(rw, iocb, inode, iov,
> >  				 offset, nr_segs, ext4_get_block);
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 762b955..ffb4a27 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4720,6 +4720,9 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
> >  			return err;
> >  	}
> >  
> > +	/* Wait for all existing dio workers */
> > +	ext4_inode_dio_wait(inode, 0);
> > +
> >  	jbd2_journal_lock_updates(journal);
> >  
> >  	/*
> > @@ -4739,6 +4742,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
> >  	ext4_set_aops(inode);
> >  
> >  	jbd2_journal_unlock_updates(journal);
> > +	ext4_clear_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
> >  
> >  	/* Finally we can mark the inode as dirty. */
> >  
> > diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> > index c5826c6..aea0e7a 100644
> > --- a/fs/ext4/move_extent.c
> > +++ b/fs/ext4/move_extent.c
> > @@ -1214,6 +1214,9 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
> >  	if (ret1 < 0)
> >  		return ret1;
> >  
> > +	/* Wait for all existing dio workers */
> > +	ext4_inode_dio_wait(orig_inode, 0);
> > +	ext4_inode_dio_wait(donor_inode, 0);
> >  	/* Protect extent tree against block allocations via delalloc */
> >  	double_down_write_data_sem(orig_inode, donor_inode);
> >  	/* Check the filesystem environment whether move_extent can be done */
> > @@ -1412,6 +1415,8 @@ out:
> >  		kfree(holecheck_path);
> >  	}
> >  	double_up_write_data_sem(orig_inode, donor_inode);
> > +	ext4_clear_inode_state(orig_inode, EXT4_STATE_DIOREAD_LOCK);
> > +	ext4_clear_inode_state(donor_inode, EXT4_STATE_DIOREAD_LOCK);
> >  	ret2 = mext_inode_double_unlock(orig_inode, donor_inode);
> >  
> >  	if (ret1)
> > -- 
> > 1.7.7.6
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
