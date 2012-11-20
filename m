From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 4/9] xfs: honor the O_SYNC flag for aysnchronous direct I/O requests
Date: Tue, 20 Nov 2012 14:42:48 -0500
Message-ID: <x49wqxghxhj.fsf@segfault.boston.devel.redhat.com>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120075114.25270.40680.stgit@blackbox.djwong.org>
	<20121120112038.GC2591@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
	tytso@mit.edu, bpm@sgi.com, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, djwong+kernel@djwong.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab2KTTnG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2012 14:43:06 -0500
In-Reply-To: <20121120112038.GC2591@dastard> (Dave Chinner's message of "Tue,
	20 Nov 2012 22:20:38 +1100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner <david@fromorbit.com> writes:

> And requeuing work from one workqueue to the next is something that
> we can avoid.  We know at IO submission time (i.e.
> xfs_vm_direct_io)) whether an fsync completion is going to be needed
> during Io completion.  The ioend->io_needs_fsync flag can be set
> then, and the first pass through xfs_finish_ioend() can queue it to
> the correct workqueue.  i.e. it only needs to be queued if it's not
> already an unwritten or append ioend and it needs an fsync.
>
> As it is, all the data completion workqueues run the same completion
> function so all you need to do is handle the fsync case at the end
> of the existing processing - it's not an else case. i.e the end of
> xfs_end_io() becomes:
>
> 	if (ioend->io_needs_fsync) {
> 		error = xfs_ioend_fsync(ioend);
> 		if (error)
> 			ioend->io_error = -error;
> 		goto done;
> 	}
> done:
> 	xfs_destroy_ioend(ioend);

Works for me, that makes things simpler.

> As it is, this code is going to change before these changes go in -
> there's a nasty regression in the DIO code that I found this
> afternoon that requires reworking this IO completion logic to
> avoid. The patch will appear on the list soon....

I'm not on the xfs list, so if you haven't already sent it, mind Cc-ing
me?

>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -209,6 +209,7 @@ typedef struct xfs_mount {
>>  	struct workqueue_struct	*m_data_workqueue;
>>  	struct workqueue_struct	*m_unwritten_workqueue;
>>  	struct workqueue_struct	*m_cil_workqueue;
>> +	struct workqueue_struct *m_aio_blkdev_flush_wq;
>
> 	struct workqueue_struct *m_aio_fsync_wq;

For the record, m_aio_blkdev_flush_wq is the name you chose previously.
;-)

Thanks for the review!

Cheers,
Jeff
