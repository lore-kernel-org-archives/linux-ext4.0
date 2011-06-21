From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] fs: kill i_alloc_sem
Date: Tue, 21 Jun 2011 15:40:56 +1000
Message-ID: <20110621054056.GP32466@dastard>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110620202031.175620498@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:44649 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1FUFlC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2011 01:41:02 -0400
Content-Disposition: inline
In-Reply-To: <20110620202031.175620498@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 20, 2011 at 04:15:37PM -0400, Christoph Hellwig wrote:
> i_alloc_sem is a rather special rw_semaphore.  It's the last one that may
> be released by a non-owner, and it's write side is always mirrored by
> real exclusion.  It's intended use it to wait for all pending direct I/O
> requests to finish before starting a truncate.
> 
> Replace it with a hand-grown construct:
> 
>  - exclusion for truncates is already guaranteed by i_mutex, so it can
>    simply fall way
>  - the reader side is replaced by an i_dio_count member in struct inode
>    that counts the number of pending direct I/O requests.  Truncate can't
>    proceed as long as it's non-zero
>  - when i_dio_count reaches non-zero we wake up a pending truncate using
>    wake_up_bit on a new bit in i_flags
>  - new references to i_dio_count can't appear while we are waiting for
>    it to read zero because the direct I/O count always needs i_mutex
>    (or an equivalent like XFS's i_iolock) for starting a new operation.
> 
> This scheme is much simpler, and saves the space of a spinlock_t and a
> struct list_head in struct inode (typically 160 bytes on a non-debug 64-bit
> system).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/direct-io.c
> ===================================================================
> --- linux-2.6.orig/fs/direct-io.c	2011-06-20 14:55:31.000000000 +0200
> +++ linux-2.6/fs/direct-io.c	2011-06-20 14:55:34.602490284 +0200
> @@ -136,6 +136,27 @@ struct dio {
>  };
>  
>  /*
> + * Wait for outstanding DIO requests to finish.  Must be locked against
> + * increments of i_dio_count by i_mutex.
> + */
> +void inode_dio_wait(struct inode *inode)
> +{
> +	might_sleep();
> +	while (atomic_read(&inode->i_dio_count)) {
> +		wait_on_bit(&inode->i_state, __I_DIO_WAKEUP, inode_wait,
> +			    TASK_UNINTERRUPTIBLE);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(inode_dio_wait);
> +
> +void inode_dio_wake(struct inode *inode)
> +{
> +	if (atomic_dec_and_test(&inode->i_dio_count))
> +		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
> +}
> +EXPORT_SYMBOL_GPL(inode_dio_wake);

Modification of inode->i_state is not safe outside the
inode->i_lock.

This probably needs to be implemented similar to the
__I_NEW/__wait_on_freeing_inode() and
__I_SYNC/inode_wait_for_writeback() pattern...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
