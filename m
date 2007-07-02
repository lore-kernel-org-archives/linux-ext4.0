From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Mon, 2 Jul 2007 11:49:39 -0400
Message-ID: <20070702154939.GC4720@thunk.org>
References: <20070629170958.13b7700c@gara> <20070630055125.GC5535@schatzie.adilger.int> <20070630233908.115ec78e@gara> <20070701123054.GC28917@thunk.org> <20070701094833.47035331@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49744 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbXGBPtu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2007 11:49:50 -0400
Content-Disposition: inline
In-Reply-To: <20070701094833.47035331@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 01, 2007 at 09:48:33AM -0500, Jose R. Santos wrote:
> Is your concern due to being unable to find contiguous block in the
> case that a bad disk area is in one of the bitmap blocks?  One thing we
> can do is try to search for another set of contiguous blocks and if we
> fail to find one, we can flag the block group and move to an indirect
> block approach to allocating the bitmaps.  At this point, we do lose
> some of the performance benefits of BIG_BG, but we would still be able
> to use the block group.

Yes, my concern is what we might need to do if for some reason e2fsck
needs to reallocate the bitmap blocks.  I don't think an indirect
block scheme is the right approach, though; we're adding a lot of
complexity for a case that probably wouldn't be used but very, very
rarely.

My proposal (as we discsused) in the call, is to implement BIG_BG as
meaning the following:

	1) Implementations must understand and use the s_desc_size
	superblock field to determine whether block group descriptors
	are the old 32 bytes or the newer 64 bytes format.  
	
	2) Implementations must support the newer ext4_group_desc
	format in particular to support bg_free_blocks_count_hi and
	bg_free_inodes_count_hi

	3) Implementations will relax constraints on where the
	superblock, bitmaps, and inode tables for a particular block
	group will be stored.

So with that, we can experiment with what size block groups really
make sense, versus using the extended metablockgroup idea, or possibly
doing both.

						- Ted
