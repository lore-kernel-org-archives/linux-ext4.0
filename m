From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] ext4: serialize dio nolocked reads with defrag
 workers V2
Date: Mon, 10 Sep 2012 11:31:26 +0200
Message-ID: <20120910093126.GE22903@quack.suse.cz>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab2IJJb2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2012 05:31:28 -0400
Content-Disposition: inline
In-Reply-To: <1347211634-11509-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 09-09-12 21:27:10, Dmitry Monakhov wrote:
> Inode's block defrag and ext4_change_inode_journal_flag() may
> affect nonlocked DIO reads result, so proper synchronization
> required.
> 
> - Add missed inode_dio_wait() calls where appropriate
> - Check inode state under extra i_dio_count reference.
> 
> Changes from V1:
> - add missed memory bariers
> - move DIOREAD_LOCK state check out from generic should_dioread_nolock
>   otherwise it will affect existing DIO readers.
  Looks good. Just maybe I would rename ext4_inode_dio_wait() to
ext4_inode_block_unlocked_dio(). Anyway you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/ext4.h        |    3 +++
>  fs/ext4/indirect.c    |   23 +++++++++++++++++++++++
>  fs/ext4/inode.c       |    4 ++++
>  fs/ext4/move_extent.c |    5 +++++
>  4 files changed, 35 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index be976ca..0377d2b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1348,6 +1348,8 @@ enum {
>  	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
>  	EXT4_STATE_NEWENTRY,		/* File just added to dir */
>  	EXT4_STATE_DELALLOC_RESERVED,	/* blks already reserved for delalloc */
> +	EXT4_STATE_DIOREAD_LOCK,	/* Disable support for dio read
> +					   nolocking */
>  };
>  
>  #define EXT4_INODE_BIT_FNS(name, field, offset)				\
> @@ -2015,6 +2017,7 @@ extern void ext4_da_update_reserve_space(struct inode *inode,
>  /* indirect.c */
>  extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
>  				struct ext4_map_blocks *map, int flags);
> +extern void ext4_inode_dio_wait(struct inode *inode, int resume);
>  extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  				const struct iovec *iov, loff_t offset,
>  				unsigned long nr_segs);
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 61f13e5..3714413 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -760,6 +760,19 @@ out:
>  	return err;
>  }
>  
> +/* Wait for existing dio workers
> + * Disable DIO read nolock optimization, so new dioreaders will
> + * be forced to grab i_mutex
> +*/
> +void ext4_inode_dio_wait(struct inode *inode, int resume_readers)
> +{
> +	ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
> +	smp_mb();
> +	inode_dio_wait(inode);
> +	if (resume_readers)
> +		ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
> +}
> +
>  /*
>   * O_DIRECT for ext3 (or indirect map) based files
>   *
> @@ -810,10 +823,20 @@ retry:
>  		if (unlikely(!list_empty(&ei->i_completed_io_list)))
>  			ext4_flush_completed_IO(inode);
>  
> +		/* Nolock dioread optimization may be dynamically disabled.
> +		 * Check inode's state while holding extra i_dio_count ref. */
> +		atomic_inc(&inode->i_dio_count);
> +		smp_mb();
> +		if (!unlikely(ext4_test_inode_state(inode,
> +						    EXT4_STATE_DIOREAD_LOCK))) {
> +			inode_dio_done(inode);
> +			goto retry;
> +		}
>  		ret = __blockdev_direct_IO(rw, iocb, inode,
>  				 inode->i_sb->s_bdev, iov,
>  				 offset, nr_segs,
>  				 ext4_get_block, NULL, NULL, 0);
> +		inode_dio_done(inode);
>  	} else {
>  		ret = blockdev_direct_IO(rw, iocb, inode, iov,
>  				 offset, nr_segs, ext4_get_block);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 762b955..ffb4a27 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4720,6 +4720,9 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>  			return err;
>  	}
>  
> +	/* Wait for all existing dio workers */
> +	ext4_inode_dio_wait(inode, 0);
> +
>  	jbd2_journal_lock_updates(journal);
>  
>  	/*
> @@ -4739,6 +4742,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>  	ext4_set_aops(inode);
>  
>  	jbd2_journal_unlock_updates(journal);
> +	ext4_clear_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
>  
>  	/* Finally we can mark the inode as dirty. */
>  
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index c5826c6..aea0e7a 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -1214,6 +1214,9 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  	if (ret1 < 0)
>  		return ret1;
>  
> +	/* Wait for all existing dio workers */
> +	ext4_inode_dio_wait(orig_inode, 0);
> +	ext4_inode_dio_wait(donor_inode, 0);
>  	/* Protect extent tree against block allocations via delalloc */
>  	double_down_write_data_sem(orig_inode, donor_inode);
>  	/* Check the filesystem environment whether move_extent can be done */
> @@ -1412,6 +1415,8 @@ out:
>  		kfree(holecheck_path);
>  	}
>  	double_up_write_data_sem(orig_inode, donor_inode);
> +	ext4_clear_inode_state(orig_inode, EXT4_STATE_DIOREAD_LOCK);
> +	ext4_clear_inode_state(donor_inode, EXT4_STATE_DIOREAD_LOCK);
>  	ret2 = mext_inode_double_unlock(orig_inode, donor_inode);
>  
>  	if (ret1)
> -- 
> 1.7.7.6
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
