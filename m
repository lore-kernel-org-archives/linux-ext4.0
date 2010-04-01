From: Jan Kara <jack@suse.cz>
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Thu, 1 Apr 2010 21:48:23 +0200
Message-ID: <20100401194822.GA8401@atrey.karlin.mff.cuni.cz>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, esandeen@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38764 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755154Ab0DATsY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Apr 2010 15:48:24 -0400
Content-Disposition: inline
In-Reply-To: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> In running iozone for writes to small files, we noticed a pretty big
> discrepency between the performance of the deadline and cfq I/O
> schedulers.  Investigation showed that I/O was being issued from 2
> different contexts: the iozone process itself, and the jbd2/sdh-8 thread
> (as expected).  Because of the way cfq performs slice idling, the delays
> introduced between the metadata and data I/Os were significant.  For
> example, cfq would see about 7MB/s versus deadline's 35 for the same
> workload.  I also tested fs_mark with writing and fsyncing 1000 64k
> files, and a similar 5x performance difference was observed.  Eric
> Sandeen suggested that I flag the journal writes as metadata, and once I
> did that, the performance difference went away completely (cfq has
> special logic to prioritize metadata I/O).
> 
> So, I'm submitting this patch for comments and testing.  I have a
> similar patch for jbd that I will submit if folks agree that this is a
> good idea.
  This looks like a good idea to me. I'd just be careful about data=journal
mode where even data is written via journal and thus you'd incorrectly
prioritize all the IO. I suppose that could have negative impact on performace
of other filesystems on the same disk. So for data=journal mode, I'd leave
write_op to be just WRITE / WRITE_SYNC_PLUG.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
