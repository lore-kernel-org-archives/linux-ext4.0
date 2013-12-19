From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Thu, 19 Dec 2013 11:48:31 +1100
Message-ID: <20131219004831.GU31386@dastard>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
 <20131217223050.GB20579@dastard>
 <20131218023143.GA24491@parisc-linux.org>
 <20131218123319.GH31386@dastard>
 <20131218152234.GB9207@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23717 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab3LSAsg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Dec 2013 19:48:36 -0500
Content-Disposition: inline
In-Reply-To: <20131218152234.GB9207@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 18, 2013 at 08:22:34AM -0700, Matthew Wilcox wrote:
> On Wed, Dec 18, 2013 at 11:33:19PM +1100, Dave Chinner wrote:
> > That's something that happens with a mmap page fault. I'm talking
> > about read(2) calls which end up in xip_file_read() ->
> > do_xip_mapping_read().
> 
> *light goes on*!  Thank you!  I'll spin up a patch to fix that.
> 
> One approach would be grabbing the i_mmap_mutex while we copy the data
> to userspace.  That's not great from a scalability point of view, and I
> think there's a great need to ensure we can't deadlock against a fault
> (eg the classic read() into an mmap() of the same file), but I think
> it's doable.

i_mmap_mutex only covers the mmap page faults, not the changes to
the filesystem that the truncate does.

We already have a model for handling non page cache based IO paths:
Direct IO has to handle this read/truncate race condition without
page lock serialisation, and it works just fine. Go and look at
inode_dio_wait() rather than reinventing the wheel.

> > There needs to be serialisation against truncate provided in some
> > way, and that's what the page cache page locks provide non-XIP
> > buffered read paths. We don't have them in the XIP infrastructure,
> > and so there's a problem here.
> > 
> > Holding the i_mutex is not sufficient, as the locks that need to be
> > held to provide this serialisation are owned by the filesystems, not
> > the generic code. Hence XIP needs to use the normal .aio_read path
> > and have the filesystems call do_xip_mapping_read() when the
> > appropriate locks have been gained.
> > 
> > And, in fact, the XIP write(2) path needs to go through filesystems
> > to be locked correctly just like the read path. Buffered writes need
> > to be serialised against reads and other filesystem operations, and
> > holding the i_mutex is not sufficient for that purpose - again, the
> > locks tha tneed to be held are defined by the filesystem, not the
> > XIP infrastructure....
> 
> I see, I see ... I'm going to have to think about this some more.

I've already explained how to do this - remember my comments about
using the direct IO setup model to weave in and out of the
filesystems appropriately?

> > The only saving grace is that XIP is so old it doesn't use the
> > multi-block mapping code that all filesystems now provide to
> > mpage_readpages(), and so once the blocks have been removed from the
> > inode the mapping.

"ext4 will not find an extent and return a hole, hence returning zeros
rather than stale data. But this won't work on XFS, because extents
beyond EOF are allowed, are common, and need to be handled specially
by the write IO path."

> I think maybe you lost some words from that final sentence?  I have patches
> that attempt to make the XIP code work in larger quantities than single
> pages, so that's in progress.

And at that point you need external serialisation against truncate,
because mapping a large extent with no other serialisation means it
will be considered valid even when it isn't. The fine-grained page
lock/mapping check is what prevents this truncate race in the
buffered read path, and there's nothing like that in the XIP code so
multi-block mappings are going to expose the read/truncate race far
worse.

> > Like I said, the XIP code is needs a heap of infrastructure work
> > before we can hook a modern filesystem up to it in a sane way.
> 
> Oh, I quite agree.  I was just so focused on the problems with mmap vs
> truncate I didn't stop to consider the problems with read vs truncate.
> I assumed the original designers had covered that (and in fairness,
> maybe they did, but it got broken at some point in the last eight years).

I don't think it ever worked correctly - XIP has the same IO path
requirements for truncate serialisation as direct IO has but the
XIP code appears to have never considered this truncate problem.

This is one of the reasons I'm recommending that XIP follow the
direct IO model for the read/write IO path: we already have working,
tested infrastructure that solves this problem, and XIP can simply
hook into that and these problems just go away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
