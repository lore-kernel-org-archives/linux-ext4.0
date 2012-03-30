From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct I/O requests
Date: Fri, 30 Mar 2012 10:50:30 -0400
Message-ID: <x49y5qii1mx.fsf@segfault.boston.devel.redhat.com>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
	<1333058705-31512-6-git-send-email-jmoyer@redhat.com>
	<20120329225743.GC18323@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, jack@suse.cz, hch@infradead.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120329225743.GC18323@dastard> (Dave Chinner's message of "Fri,
	30 Mar 2012 09:57:43 +1100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, Dave,

Thanks for the review!

> or better still, factor xfs_file_fsync() so that it calls a helper
> that doesn't wait for data IO completion, and call that helper here
> too. The semantics of fsync/fdatasync are too complex to have to
> implement and maintain in multiple locations....

I definitely agree with consolidating things.  However, there are four
blocking calls in xfs_file_fsync (filemap_write_and_wait_range,
xfs_blkdev_issue_flush, _xfs_log_force_lsn, and another call to
xfs_blkdev_issue_flush).  How would you propose to make that
non-blocking given that those steps have to happen in sequence?

Cheers,
Jeff
