From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if
 !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 16:38:08 -0500
Message-ID: <20120308213808.GK29510@shiny>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57F523.3020703@redhat.com>
 <4F581BF6.8000305@zabbo.net>
 <20120308155419.GB6777@thunk.org>
 <20120308180951.GB29510@shiny>
 <4F59148A.4070001@panasas.com>
 <20120308212412.GC11861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boaz Harrosh <bharrosh@panasas.com>, Zach Brown <zab@zabbo.net>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:40409 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CHViS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2012 16:38:18 -0500
Content-Disposition: inline
In-Reply-To: <20120308212412.GC11861@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 08, 2012 at 04:24:12PM -0500, Ted Ts'o wrote:
> On Thu, Mar 08, 2012 at 12:20:26PM -0800, Boaz Harrosh wrote:
> > 
> > I have a theory of how we can fix that 2-sec wait, by avoiding writeback of
> > the last n pages of an inode who's mtime is less then 2-sec. This would
> > solve any sequential writer wait penalty, which is Ted's case
> 
> That won't work in general, *unless* 2 seconds is enough time that the
> appending writer is done writing to that particular 4k page and moved
> on to the next 4k block, so nothing touches that page and potentially
> blocks for however long it takes for the queues to drain.
> 
> Let's take another example, suppose you have a file-backed mmap
> region, and you modify the page, and now let's suppose the process is
> under enough memory pressure that the page cleaner decides to initiate
> writeback of the page.  Now suppose you get unlucky (this is the 1% or
> 0.1% case; remember, 99th or 99.9 percentile latencies matter), and
> you try to modify the page in question again.  ***THUNK*** your
> process takes a page fault, and is frozen solid in amber for
> potentially seconds until the I/O queues drain.
> 
> Hmm.... let's turn this around.  If the issue is checksum calculation,
> how about trying to solve this problem in some cases by deferring the
> checksum calculation until right before the block I/O layer is going
> to schedule the write (i.e., have the I/O submitter provide a callback
> function which calculates the checksum, which gets called by the BIO
> layer at the very last moment)?

Btrfs currently does this, and the DIF code is by definition right
before the write.  The pages really only get set writeback when they are
being sent in flight, so the waiting being done by the stable pages
patch is file_write or page_mkwrite being polite and waiting for the IO
to finish before changing the page.

-chris
