From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext4: serialize dio nonlocked reads with defrag
 workers
Date: Wed, 5 Sep 2012 17:47:19 +0200
Message-ID: <20120905154719.GE18051@quack.suse.cz>
References: <1346780214-29845-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab2IEPrV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Sep 2012 11:47:21 -0400
Content-Disposition: inline
In-Reply-To: <1346780214-29845-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 04-09-12 21:36:51, Dmitry Monakhov wrote:
> Inode's block defrag and ext4_change_inode_journal_flag() may
> affect nonlocked DIO reads result, so proper synchronization
> required.
> 
> - add missed inode_dio_wait() calls where appropriate
> - recheck ext4_should_dioread_nolock under extra i_dio_count reference.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
...
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 830e1b2..ba40309 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -812,10 +812,22 @@ retry:
>  			ext4_flush_completed_IO(inode);
>  			mutex_unlock(&inode->i_mutex);
>  		}
> +		/*
> +		 * Inode's locking behaviour may change due to number
> +		 * of reasons, in order to be shure that nolock dioreads
					      ^^^ sure
> +		 * is still allowed we have to recheck inode's flags
> +		 * while i_dio_count > 0
> +		 */
> +		atomic_inc(&inode->i_dio_count);
> +		if (!unlikely(ext4_should_dioread_nolock(inode))) {
> +			inode_dio_done(inode);
> +			goto retry;
> +		}
  Umm, to make this reliable, you need a smp_mb() between atomic_inc() and
ext4_should_dioread_nolock(). Otherwise the i_state test could be reordered
before the atomic_inc()... Similarly you need the barriers around all other
pairs working with i_dio_count and i_state.

Frankly, I'm not very happy with this solution. It's getting ugly rather
quickly. IMHO dioread_nolock should be just ripped out and replaced with
proper range locking (if we want the scalability). But this is mostly Ted's
decision...

								Honza

>  		ret = __blockdev_direct_IO(rw, iocb, inode,
>  				 inode->i_sb->s_bdev, iov,
>  				 offset, nr_segs,
>  				 ext4_get_block, NULL, NULL, 0);
> +		inode_dio_done(inode);
>  	} else {
>  		ret = blockdev_direct_IO(rw, iocb, inode, iov,
>  				 offset, nr_segs, ext4_get_block);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d12d30e..58ef61a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4741,6 +4741,10 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>  			return err;
>  	}
>  
> +	/* Wait for all existing dio workers */
> +	ext4_set_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
> +	inode_dio_wait(inode);
> +
>  	jbd2_journal_lock_updates(journal);
>  
>  	/*
> @@ -4760,6 +4764,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
>  	ext4_set_aops(inode);
>  
>  	jbd2_journal_unlock_updates(journal);
> +	ext4_clear_inode_state(inode, EXT4_STATE_DIOREAD_LOCK);
>  
>  	/* Finally we can mark the inode as dirty. */
>  
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index c5826c6..a6a4278 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -1213,6 +1213,14 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  	ret1 = mext_inode_double_lock(orig_inode, donor_inode);
>  	if (ret1 < 0)
>  		return ret1;
> +	/* Protect inodes against DIO workers
> +	 * - Disable dio nonlock reads, so all new dio workers will block
> +	 *   on i_mutex.
> +	 * - wait for existing DIO in flight */
> +	ext4_set_inode_state(orig_inode, EXT4_STATE_DIOREAD_LOCK);
> +	ext4_set_inode_state(donor_inode, EXT4_STATE_DIOREAD_LOCK);
> +	inode_dio_wait(orig_inode);
> +	inode_dio_wait(donor_inode);
>  
>  	/* Protect extent tree against block allocations via delalloc */
>  	double_down_write_data_sem(orig_inode, donor_inode);
> @@ -1412,6 +1420,8 @@ out:
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
