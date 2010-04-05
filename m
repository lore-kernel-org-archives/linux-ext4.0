From: tytso@mit.edu
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Mon, 5 Apr 2010 13:46:03 -0400
Message-ID: <20100405174603.GA24493@thunk.org>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
 <20100401194822.GA8401@atrey.karlin.mff.cuni.cz>
 <x49tyrpkjmq.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	esandeen@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44757 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0DERqI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Apr 2010 13:46:08 -0400
Content-Disposition: inline
In-Reply-To: <x49tyrpkjmq.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 05, 2010 at 11:24:13AM -0400, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >   Hi,
> >
> >> In running iozone for writes to small files, we noticed a pretty big
> >> discrepency between the performance of the deadline and cfq I/O
> >> schedulers.  Investigation showed that I/O was being issued from 2
> >> different contexts: the iozone process itself, and the jbd2/sdh-8 thread
> >> (as expected).  Because of the way cfq performs slice idling, the delays
> >> introduced between the metadata and data I/Os were significant.  For
> >> example, cfq would see about 7MB/s versus deadline's 35 for the same
> >> workload.  I also tested fs_mark with writing and fsyncing 1000 64k
> >> files, and a similar 5x performance difference was observed.  Eric
> >> Sandeen suggested that I flag the journal writes as metadata, and once I
> >> did that, the performance difference went away completely (cfq has
> >> special logic to prioritize metadata I/O).
> >> 
> >> So, I'm submitting this patch for comments and testing.  I have a
> >> similar patch for jbd that I will submit if folks agree that this is a
> >> good idea.
> >   This looks like a good idea to me. I'd just be careful about data=journal
> > mode where even data is written via journal and thus you'd incorrectly
> > prioritize all the IO. I suppose that could have negative impact on performace
> > of other filesystems on the same disk. So for data=journal mode, I'd leave
> > write_op to be just WRITE / WRITE_SYNC_PLUG.
> 
> Hi, Jan, thanks for the review!  I'm trying to figure out the best way
> to relay the journal mode from ext3 or ext4 to jbd or jbd2.  Would a new
> journal flag, set in journal_init_inode, be appropriate?  This wouldn't
> cover the case of data journalling set per inode, though.  It also puts
> some ext3-specific code into the purportedly fs-agnostic jbd code
> (specifically, testing the superblock for the data journal mount flag).
> Do you have any suggestions?

I don't think it's necessary to worry about journal=data mode.  First
of all, it's not true that all of the I/O would be prioritized as
metadata.  In data=journal mode, data blocks are written twice; once
to the journal, and once to the final location on disk.  And the
journal writes do need to be prioritized because the commit can't go
out until all of the preceeding journal blocks have been written.  So
treating all of the journal writes as metadata for the the purposes of
cfq's prioritization makes sense to me....

					- Ted
