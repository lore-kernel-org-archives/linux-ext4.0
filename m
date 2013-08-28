From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4: Mark block group as corrupt on block bitmap
 error
Date: Wed, 28 Aug 2013 18:26:59 -0400
Message-ID: <20130828222659.GI27079@thunk.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130719235552.24017.26642.stgit@blackbox.djwong.org>
 <20130723033833.GF5785@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50903 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab3H1W1G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Aug 2013 18:27:06 -0400
Content-Disposition: inline
In-Reply-To: <20130723033833.GF5785@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 22, 2013 at 08:38:33PM -0700, Darrick J. Wong wrote:
> On Fri, Jul 19, 2013 at 04:55:52PM -0700, Darrick J. Wong wrote:
> > When we notice a block-bitmap corruption (because of device failure or
> > something else), we should mark this group as corrupt and prevent further block
> > allocations/deallocations from it. Currently, we end up generating one error
> > message for every block in the bitmap. This potentially could make the system
> > unstable as noticed in some bugs. With this patch, the error will be printed
> > only the first time and mark the entire block group as corrupted. This prevents
> > future access allocations/deallocations from it.

Thanks, applied....

> Hmm.  I think we need to have ext4_count_free_clusters() act as though corrupt
> block groups have "zero" free blocks so that mballoc will pass the -ENOSPC
> errors back to the upper layers.  Afaict, if one doesn't do this, ext4
> encounters the situation where marking the blocks in use fails, yet the fs
> thinks there are free blocks still and ... leaves the pages dirty forever,
> instead of simply failing.

Yes, that's something we should probably add to make things to be more
robust in the case where we have huge numbers of corrupted (or
hardware failures) in the block bitmaps.   

> Just trying this really quickly, if I blast /all/ the block groups, I see
> unstoppable errors in dmesg.

What sort of errors did you end up seeing?

> The other thing I noticed is that if one turns delalloc mode on, performs a
> live corruption of the bg descriptors, and then dd's a big file to the fs,
> there's no error reported back to userspace either in write(), sync(), or even
> umount().  Meanwhile, dmesg is getting hit with tons of corrupted-bitmap
> errors.

I'm not sure there's much we can do about this.  On the other hand,
how realistic of a threat is this.  If it's happening randomly, how
likely is this to happen?  And if it's a deliberate corruption, the
attacker can probably do a lot worse.

In practice, these weren't think we were really worried about when we
primarily worried about hardware failures, since hardware failures are
random, and so if the errors are affecting a large number of block
bitmaps, the storage device is probably completely toasted and there's
nothing we can do about it anyway.

When metadata checksums are enabled, this gets trickier, since it's
possible for a large number of metadata checksums to be corrupted in
the bg descriptors, especially if the bg descriptors get written to
while the file system is mounted.  This will smash a huge number of
checksums, and then badness will happen.  But realistically, bad
things would happen if that happened while the file system is mounted
even without checksums being enabled.  It maybe that the best thing we
can do is to some kind of rate limiting with log messages, or some
kind of hueristic where if a sufficient number of different checksums
are found to be broken, we take much more drastic, such as
unconditionally shutting down the file system.

The main issue here is that errors=continue is used if we want to do
some amount of recovery after certain types of file system corruption,
but what we really need is a mode where we can continue after certain
types of fs errors (especially if userspace is doing things its own
data block checksums and has its own recovery mechanisms at the
cluster file system level).  But if things gets really, really, bad,
we shouldn't trying to bull ahead in the face of errors when it's
clear it's going to be counterproductive.

> More for me to ponder....

Indeed...

					- Ted
