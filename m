From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 5/7] xfs: honor the O_SYNC flag for aysnchronous direct I/O requests
Date: Thu, 19 Apr 2012 11:04:22 -0400
Message-ID: <x49obqng3ux.fsf@segfault.boston.devel.redhat.com>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
	<1333058705-31512-6-git-send-email-jmoyer@redhat.com>
	<20120329225743.GC18323@dastard>
	<x49y5qii1mx.fsf@segfault.boston.devel.redhat.com>
	<x49d37tj2ji.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, jack@suse.cz, hch@infradead.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab2DSPE5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 11:04:57 -0400
In-Reply-To: <x49d37tj2ji.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Fri, 30 Mar 2012 15:45:37 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeff Moyer <jmoyer@redhat.com> writes:

> Jeff Moyer <jmoyer@redhat.com> writes:
>
>> Hi, Dave,
>>
>> Thanks for the review!
>>
>>> or better still, factor xfs_file_fsync() so that it calls a helper
>>> that doesn't wait for data IO completion, and call that helper here
>>> too. The semantics of fsync/fdatasync are too complex to have to
>>> implement and maintain in multiple locations....
>>
>> I definitely agree with consolidating things.  However, there are four
>> blocking calls in xfs_file_fsync (filemap_write_and_wait_range,
>> xfs_blkdev_issue_flush, _xfs_log_force_lsn, and another call to
>> xfs_blkdev_issue_flush).  How would you propose to make that
>> non-blocking given that those steps have to happen in sequence?
>
> OK, so re-reading your mail, I think you meant to just factor out
> everything except the filemap_write_and_wait_range.  Here are a couple
> of patches which do that.  Also, since we're not worried about blocking
> in the endio processing, just making things synchronous makes the code a
> lot simpler.  Let me know what you think of the attached two patches
> (which I've already run through xfstests).

Dave, ping?  Did you have a chance to take a look at these patches?

Cheers,
Jeff
