From: Theodore Tso <tytso@mit.edu>
Subject: Re: how to scale root-reserved space going forward...
Date: Sun, 1 Mar 2009 21:47:54 -0500
Message-ID: <20090302024754.GF6973@mit.edu>
References: <49AB0ABE.1030009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34304 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248AbZCBCr7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Mar 2009 21:47:59 -0500
Content-Disposition: inline
In-Reply-To: <49AB0ABE.1030009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 01, 2009 at 04:22:54PM -0600, Eric Sandeen wrote:
> 5% of a 16T filesystem is getting a little crazy from the point of view
> of "root-reserved" - 800G!
> 
> But I think the original reason for this reserved space was actually as
> an allocator cushion; letting root gain access to it was just a
> safety-valve for that.

Yep, that's correct.  Historically, this came from BSD Fast
Filesystem, which used to use a default reserve of 10%.  To quote from
the FreeBSD sources, in ufs/ffs.h:

/*
 * MINFREE gives the minimum acceptable percentage of filesystem
 * blocks which may be free. If the freelist drops below this level
 * only the superuser may continue to allocate blocks. This may
 * be set to 0 if no reserve of free blocks is deemed necessary,
 * however throughput drops by fifty percent if the filesystem
 * is run at between 95% and 100% full; thus the minimum default
 * value of fs_minfree is 5%. However, to get good clustering
 * performance, 10% is a better choice. hence we use 10% as our
 * default value. With 10% free space, fragmentation is not a
 * problem, so we choose to optimize for time.
 */
#define MINFREE         8

The interesting thing is that FreeBSD has decided push things down to
8%.  A quick survey shows that NetBSD is using a MINFREE of 5%, like
Linux.  (Fortunately, http://fxr.watson.org/ makes it easy to make
these comparisons.)  

And like Linux, it looks like the *BSD's have the same tendency not to
update the comments when they update the code.  :-)

> Now that we have a completely different allocator in ext4, and
> potentially much larger filesystems, I think we need to revisit how much
> is held back, and for what reason.
> 
> Any thoughts on a reasonable way to scale this reservation (or, just for
> discussion - if it's even needed at all today for ext4?)

This is a reasonable question.  What would be great is if we could get
a benchmarking team to fill an ext4 filesystem with files.  The simple
thing would be if we did something fixed --- say, 50 files per
directory, each file 100k, and say 10 subdirectories in each
directory, to some fixed depth, and with a filesystem size of at least
8 gigabytes (which would give us at least 16 flex groups with the
default flex size of 16) --- and then filled each filesystem to from
0% to 90% in increments of 10%, and from 90% to 99% in increments of
1%, and then ran some throughput benchmark like bonnie on the mostly
filled filesystem.

A better filler would probably use a random file sizes with a average
size of say 64k, but with outliers from 4k to 128 megs, and a similar
random distribution of number of files per directory, and number of
subdirectories and depth of subdirectories.

I suppose it would be good to do one set of charts with a filesystem
size of 8 gigs, and another at 80 gigs and 800 gigs, and see if the
shape of the filesystem curve changes at scale.  Once we have that, we
would be in a position to make a reasonable set of defaults.

Or we could just guess and come up with some percentage figure that
sounds good.  :-)

						- Ted
