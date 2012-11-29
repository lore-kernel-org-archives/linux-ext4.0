From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] ext4: Convert unwritten extents during end_io
 processing
Date: Thu, 29 Nov 2012 11:47:39 -0800
Message-ID: <20121129194739.GA2694@blackbox.djwong.org>
References: <20121123075502.307482760@bombadil.infradead.org>
 <20121123075916.375908616@bombadil.infradead.org>
 <x49a9u3f276.fsf@segfault.boston.devel.redhat.com>
 <20121128002656.GC4321@blackbox.djwong.org>
 <20121128003027.GA14500@infradead.org>
 <20121128080254.GB11869@blackbox.djwong.org>
 <20121128143405.GB23743@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16885 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab2K2Tse (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2012 14:48:34 -0500
Content-Disposition: inline
In-Reply-To: <20121128143405.GB23743@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2012 at 09:34:05AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 28, 2012 at 12:02:54AM -0800, Darrick J. Wong wrote:
> > Here's a lightly tested (it passed enough of xfstests and an aio+dio+osync
> > tester on ext4 on x64...) patch that rips out the whole wq mess to convert
> > unwritten extents from endio processing.  This has the effect that unwritten
> > extents are now converted as part of writeback, not fsync/truncate/punch_hole.
> > I have a suspicion that the reason why ext4 had that behavior was to reduce
> > churn in the extent tree if one writes a bunch of adjacent sections of hole.
> > Oh well.  I haven't seen any huge regressions yet, but then I'm really just
> > posting this early to see if anyone spots obvious bugs.
> > 
> > Christoph, was this what you had in mind?
> 
> Can you actually call ext4_convert_unwritten_extents from irq context
> safely for the buffered I/O case?  At least for the XFS equivalent we
> need user context, which is why we have these workqueues in the first
> place.

You can't call the conversion from irq context.  It /looks/ like for the
buffered case the conversion seems to get done from the context of the calling
process, and it's only for dio that we need to do odd twists to make
dio_complete happen from a wq.

Sadly, I also discovered that I hadn't fixed all the cases where the conversion
could happen from irq context.  I think I found the last two, but now I'm
suspicious that I've messed up the locking... it seems like the
generic_write_sync -> ext4_fsync_file path is encountering extents that are
still unconverted, and stalling there.  Hm.  Maybe I should have some lunch
first.

> But what we're doing is to make sure unwritten extent conversion happens
> before marking the page writeback complete, so that
> filemap_write_and_wait and friends implicitly wait for this conversion
> when waiting for page I/O to complete, and thus removing the need for
> all the explicit flushing infrastructure.

That's where I (hope) I'm headed too. :)

--D
