From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: dump ext4 performance degrades linearly as disk fills
Date: Mon, 16 Jun 2014 08:42:29 -0400
Message-ID: <20140616124229.GA8465@thunk.org>
References: <539E8401.5000607@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Joseph D. Wagner" <joe@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40783 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaFPMmh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jun 2014 08:42:37 -0400
Content-Disposition: inline
In-Reply-To: <539E8401.5000607@josephdwagner.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 15, 2014 at 10:43:29PM -0700, Joseph D. Wagner wrote:
> Background:
> - I use lvm snapshots on ext4 for backup.  I use dump to backup the
> snapshots.  The backup goes to an external hard drive over usb 3.0. The
> external hard drive has 1 partition formatted with ext4.
>
> My Thoughts So Far:
> - I suspect that either 1) dump is doing something which lowers performance
> as the backup progresses, or 2) the ext4 algorithm for finding and
> allocating free blocks is vulnerable to performance degradation as the
> volume fills.
> 
> - I haven't tested this thoroughly.  However, performance appears to improve
> when I clear out the external drive and do a fresh, full dump (-0), and
> performance appears to remain degraded on incremental backups on a nearly
> full volume.  This leads me to suspect #2.

The issue is that when the external disk is freshly mounted, we don't
have any of the block allocation bitmaps cached.  We also cache at run
information about the largest contiguous free block in a block group.
On a freshly unmounted file system we don't have any of this information.

So it's a known issue that on a freshly mounted file system,
allocation performance is bad for a little while until we have more
information cached.  It's not something we've really worked on trying
to improve, but there are a number of things we can do.  In
particular, with ext4 file system (as opposed to an ext3 file system
which was upgraded to ext4), the block allocation bitmaps are much
more contiguous.  So one of the things we could do is to readahead a
chunk of allocation bitmaps, so we avoid a whole series of 4k random
reads.   

> - What steps can I take to isolate the cause of the problem?  If there's any
> information I can provide, please let me know.

If you run dumpe2fs on the file system and send us the output, we can
probably confirm this pretty quickly.  The e2freefrag program can also
show us whether how fragmented the free space is, but I'm pretty sure
that's not the problem.

Something that might help is simply running "dumpe2fs /dev/sdXX >
/dev/null" or "e2freefrag /dev/hdXX > /dev/null" after you mount the
file system and before you kick off the backup.  This will load all of
the block allocation bitmaps into the buffer cache, and the libext2fs
functions used by dumpe2fs and e2freefrag will do so much more
efficiently than the kernel code will as it demand-loads the bitmap
blocks.

Hope this helps!

					- Ted
