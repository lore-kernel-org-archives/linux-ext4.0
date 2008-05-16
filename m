From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 16 May 2008 23:03:15 +0100
Message-ID: <20080516220315.GB15334@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:44871 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707AbYEPWDW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 May 2008 18:03:22 -0400
Content-Disposition: inline
In-Reply-To: <482DF44B.50204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> > If we were seeing a significant number of "hey, my disk got wrecked"
> > reports which attributable to this then yes, perhaps we should change
> > the default.  But I've never seen _any_, although I've seen claims that
> > others have seen reports.
> 
> Hm, how would we know, really?  What does it look like?  It'd totally
> depend on what got lost...  When do you find out?  Again depends what
> you're doing, I think.  I'll admit that I don't have any good evidence
> of my own.  I'll go off and do some plug-pull-testing and a benchmark or
> two.

You have to pull the plug quite a lot, while there is data in write
cache, and when the data is something you will notice later.

Checking filesystem is hard.  Something systematic would be good - for
which you will want an electronically controlled power switch.

I have seen corruption which I believe is from lack of barriers, and
hasn't occurred since I implemented them (or disabled write cache).
But it's hard to be sure that was the real cause.

If you just want to test the block I/O layer and drive itself, don't
use the filesystem, but write a program which just access the block
device, continuously writing with/without barriers every so often, and
after power cycle read back to see what was and wasn't written.

I think there may be drives which won't show any effect - if they have
enough internal power (from platter inertia) to write everything in
the cache before losing it.

If you want to test, the worst case is to queue many small writes at
seek positions acrosss the disk, so that flushing the disk's write
cache takes the longest time.  A good pattern might be take numbers
0..2^N-1 (e.g. 0..255), for each number reverse the bit order (0, 128,
64, 192...) and do writes at those block positions, scaling up to the
range of the whole disk.  The idea is if the disk just caches the last
few queued, they will always be quite spread out.

However, a particular disk's cache algorithm may bound the write cache
size by predicted seek time needed to flush it, rather than bytes,
defeating that.

> But, drive caches are only getting bigger, I assume this can't help.  I
> have a hard time seeing how speed at the cost of correctness is the
> right call...

I agree.

The MacOS X folks decided that speed is most important for fsync().
fsync() does not guarantee commit to platter.  *But* they added an
fcntl() for applications to request a commit to platter, which SQLite
at least uses.  I don't know if MacOS X uses barriers for filesystem
operations.

> > Do we know which distros are enabling barriers by default?
> 
> SuSE does (via patch for ext3).

SuSE did the same for 2.4: they patched the kernel to add barriers to
2.4.  (I'm using an improved version of that patch in my embedded
devices).  It's nice they haven't weakened the behavior in 2.6.

> Red Hat & Fedora don't,

Neither did they patch for barriers in 2.4, but we can't hold that
against them :-)

> and install by default on lvm which won't pass barriers anyway.

Considering how many things depend on LVM not passing barriers, that
is scary.  People use software RAID assuming integrity.  They are
immune to many hardware faults.  But it turns out, on Linux, that a
single disk can have higher integrity against power failure than a
RAID.

> So maybe it's hypocritical to send this patch from redhat.com :)

So send the patch to fix LVM too :-)

> And as another "who uses barriers" datapoint, reiserfs & xfs both have
> them on by default.

Are they noticably slower than ext3?  If not, it suggests ext3 can be
fixed to keep its performance with barriers enabled.

Specifically: under some workloads, batching larger changes into the
journal between commit blocks might compensate.  Maybe the journal has
been tuned for barriers off because they are by default?

> I suppose alternately I could send another patch to remove "remember
> that ext3/4 by default offers higher data integrity guarantees than
> most." from Documentation/filesystems/ext4.txt  ;)

It would be fair.  I suspect a fair number of people are under the
impression ext3 uses barriers with no special options, prior to this
thread.  It was advertised as a feature in development during the 2.5
series.
