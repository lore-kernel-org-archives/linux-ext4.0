From: Theodore Tso <tytso@mit.edu>
Subject: Thoughts on improving ext4's inode allocator
Date: Fri, 7 Aug 2009 20:43:13 -0400
Message-ID: <20090808004313.GC13642@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59164 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbZHHAnO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2009 20:43:14 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While we're talking about ext4 allocator issues, the other problem
allocator-related issue that needs looking at is the inode allocator;
the spreading algorithm causes us to take a performance degredation
sooner than we would otherwise when the filesystem is only partially
filled (since access times at the beginning of the disk is faster than
at the end of the disk for people who are still using spinning rust
platters).  I talked to a company while I was at OSCON a few weeks
ago, and they noticed a regression using one of their benchmarks.  I'm
not sure how of a big deal that is, since eventually as the disk gets
filled, the access times will average out, but for people who only use
30-50% of their filesystem, we can do better by changing our spreading
algorithm.

Spreading is still important for making the filesystem less likely to
be subject to aging, but we may want to use a spreading algorithm that
tries using block groups closer to the beginning of the disk, and then
only starts using block groups in the second half of the disk only
when first half of the disk is filled.

The other thing that we should look at is the hueristics that we use
when creating a new subdirectory, to decide whether to put the
subdirectory in the current flex_bg, or in a new flex_bg.  Currently
what I coded up is an extension based on BSD's FFS's Orlov algorithm.
The basic idea is that if the number of directories in the flex_bg
exceeds average number of directories per flex_bg plus
inodes_per_group/16, or the number of free inodes in the flex_bg is
less than 75% of the average number of inodes per flex_bg, or the
number of free blocks is less than 75% of the average free blocks per
flex_bg, then we try the next flex_bg in the filesystem until we find
one that meets the Orlov criteria.  

However, the Orlov criteria hasn't been seriously investigated in over
two decades, and distribution of files and depth of directory
hierarchies probably have changed somewhat since then.  So the
decision when we decide to move to a new directory is something that
we should look at.

So in summary, here are some of aspects of the Orlov algorithm that
might stand some tweaking:

	 * How to pick the flex_bg for top-level directories
		(currently we use random starting point)
	 * Whether to use the current flex_bg for subdirectories
		(currently we use a fairly complicated set of directories)
	 * How to pick a new flex_bg for subdirectories
	 	(currently we use the next flex_bg as a starting point)

			      	      	   	      - Ted
