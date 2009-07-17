From: Theodore Tso <tytso@mit.edu>
Subject: Re: file allocation problem
Date: Thu, 16 Jul 2009 21:12:19 -0400
Message-ID: <20090717011219.GE8508@mit.edu>
References: <200907161331.17623.coolo@suse.de> <20090716155832.GA6605@mit.edu> <200907161943.21575.coolo@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Stephan Kulow <coolo@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39809 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933390AbZGQBM1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2009 21:12:27 -0400
Content-Disposition: inline
In-Reply-To: <200907161943.21575.coolo@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 16, 2009 at 07:43:21PM +0200, Stephan Kulow wrote:
> > If it is the case that this was originally an ext3 filesystem,
> > e4defrag does have some definite limitations that will prevent it from
> > doing a great job in such a case.  I'm guessing that's what's going on
> > here.
> My problem is not so much with what e4defrag does, but the fact that
> a new file I create with cp(1) contains 34 extents.

Well, because your filesystem is still fragmented; you asked e4defrag
to defragment a single file.  In fact, it wasn't able to do much --
the file previously had 25 extents, and the new file had 25 extents.
E4defrag is quite new, and still needs a lot of polishing; I'm not
sure it should have tried to swap files when the newly allocated file
has the same number of extents.  This might be a case of changing a
">=" to ">" in code.

The reason why "cp" still created a file with 34 extents is because
the free space was still fragmented.  As I said, e4defrag is quite
primitive; it doesn't know how to defrag free space; it simply tries
to reduce the number of extents for each file, on a file-by-file
basis.

The other problem is that an ext3 filesystem that has been converted
to ext4 does not have the flex_bg feature.  This is a feature that,
when set at when the file system is formatted, creates a higher order
flex_bg which combines several block groups into a bigger allocation
group, a flex_bg.  This helps avoid fragmentation, especially for
directories like /usr/bin which typically have more than 128 megs (a
single block group) worth of files in it.

Using an ext3 filesystem format, the filesystem driver will first try
to find space in the home block group of the directory, and if there
is no space there, it will look in other block groups.  With a freshly
formatted ext4 filesystem, the allocation group is the flex_bg, which
is much larger, and which gives us a better opportunity for allocating
contiguous blocks.

I suspect we could do better with our allocator in this case; maybe
should use a flex_bg to give the block group allocator a bigger set of
block groups to search.  The inode tables will still not be optimally
laid out for flex_bg, but we might still be better off.  Or, if the
block group is terribly fragmented, maybe we should have the allocator
find some other bg, even if it isn't the ideal block group close to
the directory.  According to the dumpe2fs output, the filesystem is
only 66% or so full, so there's probably some possibly completely
unused block groups we should be using instead.  One of the things
that we have _not_ had time to do is optimize the block allocator for
heavily fragimented filesystems, especially for fragmented filesystems
that had been converted from ext3 filesystems.

In any case, I don't anything went _wrong_ per se, just that both
e4defrag and our block allocator are insufficiently smart to help
improve things for you given your current filesystem.  A backup,
reformat, and restore will result in a filesystem that works far
better.

Out of curiosity, what sort of workload had the file system received?
It looks like the filesystem hadn't been created that long ago, so
it's bit surprising it was so fragmented.  Were you perhaps updating
your system (by doing a yum update or apt-get update) very frequently,
perhaps?

						- Ted
