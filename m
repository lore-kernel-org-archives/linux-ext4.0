From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: semi-stable page writes
Date: Wed, 31 Oct 2012 02:05:19 -0700
Message-ID: <20121031090519.GE19591@blackbox.djwong.org>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121029220122.GT29378@dastard>
 <20121030204037.GE19559@blackbox.djwong.org>
 <20121030234331.GH29378@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27067 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935251Ab2JaJFe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Oct 2012 05:05:34 -0400
Content-Disposition: inline
In-Reply-To: <20121030234331.GH29378@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 31, 2012 at 10:43:31AM +1100, Dave Chinner wrote:
> On Tue, Oct 30, 2012 at 01:40:37PM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 30, 2012 at 09:01:22AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 26, 2012 at 03:19:09AM -0700, Darrick J. Wong wrote:
> > > > Hi everyone,
> > > > 
> > > > Are people still annoyed about writes taking unexpectedly long amounts of tme
> > > > due to the stable page write patchset?  I'm guessing yes...
> > > 
> > > I haven't heard anyone except th elunatic fringe complain
> > > recently...
> > > 
> > > > I'm close to posting a patchset that (a) gates the wait_on_page_writeback calls
> > > > on a flag that you can set in the bdi to indicate that you need stable writes
> > > > (which blk_integrity_register will set);
> > > 
> > > I'd prefer stable pages by default (e.g. btrfs needs it for sane
> > > data crc calculations), with an option to turn it off.
> > > 
> > > > (b) (ab)uses a page flag bit (PG_slab)
> > > > to indicate that a page is actually being sent out to disk hardware; and (c)
> > > 
> > > I don't think you can do that. You can send slab allocated memory to
> > > disk (e.g. kmalloc()d memory) and XFS definitely does that for
> > > sub-page sized metadata. I'm pretty sure that means the PG_slab
> > > flag is not available for (ab)use in the IO path....
> > 
> > I gave up on PG_slab and declared my own PG_ bit.  Unfortunately, atm I can't
> > remember which bit of code marks the page ptes so that they have to go back
> > through page_mkwrite, where we can trap the write.  Hopefully for a shorter
> > duration.
> 
> clear_page_dirty_for_io(), IIRC.

Yep, thanks.  My memory is a bit rusty due to recent downtime. :/

Now to figure out if I can safely call that from deep inside the SCSI dispatch
functions as part of deferred-checksumming.  I have a bad feeling that we have
to lock the page, which implies sleeping, and (unless they fixed this) the SCSI
dispatch functions hold the scsi host lock while running, which means we can't
sleep.

> > Also, I was wondering -- is it possible to pursue a dual strategy?  If we can
> > obtain a memory page without sleeping or causing any writeback, then use the
> > page as a bounce buffer.  Otherwise, just wait like we do now.
> 
> Using bounce buffers for all IO is not a feasible solution. Way too
> much overhead copying data, not to mention we are already suffering
> from the problem of flusher threads going CPU bound trying to issue
> enough IO to keep high bandwidth storage fully utilised...

Ok.

--D
