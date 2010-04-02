From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Fri, 2 Apr 2010 09:00:02 +0200
Message-ID: <20100402070001.GY23510@kernel.dk>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	esandeen@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51380 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759213Ab0DBHAD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Apr 2010 03:00:03 -0400
Content-Disposition: inline
In-Reply-To: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 01 2010, Jeff Moyer wrote:
> Hi,
> 
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

Looks good to me.

-- 
Jens Axboe

