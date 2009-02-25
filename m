From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
	flex_bg filesystems
Date: Tue, 24 Feb 2009 21:50:54 -0500
Message-ID: <20090225025054.GD7064@mit.edu>
References: <20090218154310.GH3600@mini-me.lan> <20090224085931.GA25657@skywalker> <20090224224108.GQ3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34848 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbZBYCvA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 21:51:00 -0500
Content-Disposition: inline
In-Reply-To: <20090224224108.GQ3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Two notes here -
> - get_random_bytes() is actually a fairly CPU-intensive operation, though
>   I'm not sure it is significant in this context
> - more importantly, scanning ALL groups in a very large filesystem to find
>   an optimal group.  Large filesystems can have upwards of 60-100k groups
>   to scan, and even with flexbg it seems that get_orlov_stats() is not
>   using the flex_group[] stats in the common case where flex_size is the
>   same as the flexbg size, but recalculating these for every allocation.

Note that this only happens when we are creating directories.  I'm
making the assumption here that creating directories is rare, and
certainly happens less often than allocating inodes or blocks.  I was
deliberately not using flex_group[] stats, since I was thinking that
eventually it would be worthwhile to nuke the need to take a spinlock
for every inode and block allocation, and it wasn't keeping track of
the number of directories, anyway.

We also don't actually scan ALL the groups.  For top-level directories
we do, yes.  But most directories aren't top-level; and for non
top-level directories, we find the first block group which meets the
minimum criteria:

	for (i = 0; i < ngroups; i++) {
		grp = (parent_group + i) % ngroups;
		get_orlov_stats(sb, grp, flex_size, &stats);
		if (stats.used_dirs >= max_dirs)
			continue;
		if (stats.free_inodes < min_inodes)
			continue;
		if (stats.free_blocks < min_blocks)
			continue;
		goto found_flex_bg;
	}

Looking at Eric's benchmark, it looks like each iteration is creating
196,608 directories for each iteration.  If takes 6 seconds, then each
mkdir is taking 30 microseconds, and if takes 15 seconds to do an
interation, then each mkdir is taking 76 microseconds.  So that
variance is large, but how bad does it really get?

Also, what workload is likely going to be creating tons and tons of
directories?  Even a psycho squid cache hierarchy is only 65536
directories.

> Based on the above, it would be preferable to settle for a "local"
> optimal group after scanning N successful candidates, then checking
> the "most recently selected" group saved in the superblock if it is
> still better than the local optimum.  Of course it should continue to
> scan all groups if there are no suitable groups yet found.
> 
> Since the starting group is random, this will avoid being stuck in
> a bad local minimum, while avoiding an exhaustive search when there
> are a lot of groups.

The above algorithm is only used for top-level directories.

> It would seem that using i_last_alloc_group FIRST (if set) would be better
> than always checking all groups in the flexbg.  Either i_last_alloc_group
> is in the same flex group as parent_group (so no harm done) or a previous
> allocation wasn't able to find any free inode in that flex group and it
> had to do a more expensive search elsewhere.

(This is the algorithm used for non-directories).  Yeah, I agree that
keeping track of the last flex group and using it first makes sense.

I do think it makes sense to start at the beginning of each flex
group; checking each block group is pretty fast, since we're not
scanning the bitmap; just checking a count value.  Even if there are
128 groups for flex groups, we're in big trouble if checking free
inodes count for 100+ groups is noticeable.

							- Ted
