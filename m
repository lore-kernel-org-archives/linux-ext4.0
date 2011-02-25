From: Joel Becker <jlbec@evilplan.org>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 13:59:25 -0800
Message-ID: <20110225215924.GA28214@noexit>
References: <E1PsnrK-0005r5-JH@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:46197 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab1BYV7a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 16:59:30 -0500
Content-Disposition: inline
In-Reply-To: <E1PsnrK-0005r5-JH@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 24, 2011 at 09:56:46PM -0500, Theodore Ts'o wrote:
> The solution to this problem is to use an increased allocation size as
> far as the block allocaiton bitmaps are concerned.  However, the size
> of allocation bitmaps, and the granularity of blocks as far as the the
> extent tree blocks are concerned, are still based on the original
> maximum 4k block size.

	Why not call it a 'cluster' like the rest of us do?  The term
'blocksize' is overloaded enough already.

> Because we are not changing the definition of a block, the only
> changes that need to be made are at the intersection of allocating to
> an inode (or to file system metadata).  This is good, because it means
> the bulk of ext4 does not need to be changed
> 
> 
> = Kernel Changes required =
> 
> 1) Globally throughout ext4: uses of EXT4_BLOCKS_PER_GROUP() need to
> be audited to see if they should be EXT4_BLOCKS_PER_GROUP() or
> EXT4_ALLOC_BLOCKS_PER_GROUP().
> 
> 2) ext4_map_blocks() and its downstream functions need to be changed so
> that they understand the new allocation rules, and in particular
> understand that before allocating a new block, they need to see if a
> partially allocated block has already been allocated, and can be used
> to fulfill the current allocation.
> 
> 3) mballoc.c will need little or no changes, other than the
> EXT4_BLOCKS_PER_GROUP()/EXT4_ALLOC_BLOCKS_PER_GROUP() audit discussed
> in (1).

	Be careful in your zeroing.  A new allocation block might have
pages at its front that are not part of the write() or mmap().  You'll
either need to keep track that they are uninitialized, or you will have
to zero them in write_begin() (ocfs2 does the latter).  We've had quite
a few tricky bugs in this area, because the standard pagecache code
handles the pags covered by the write, but the filesystem has to handle
the new pages outside the write.

> = Downsides =
> 
> Internal fragmentation will be expensive for small files.  So this is
> only useful for file systems where most files are large, or where the
> file system performance is more important than the losses caused by
> internal fragmentation.  

	It's a huge win for anything needing large files, like database
files or VM images.  mkfs.ocfs2 has a vmimage mode just for this ;-)
Even with good allocation code and proper extents, a long-lived
filesystem with 4K clusters just gets fragmented.  This leads to later
files being very discontiguous, which are slow to I/O to.  I think this
is much more important than the simple speed-of-allocation win.

> Directories will also be allocated in chucks of the allocation block
> size.  If this is especially large (such as 1 MiB), and there are a
> large number of directories, this could be quite expensive.
> Applications which use multi-level directory schemes to keep
> directories small to optimize for ext2's very slow large directory
> performance could be especially vulnerable.

	Anecdotal evidence suggests that directories often benefit with
clusters of 8-16K size, but suffer greatly after 128K for precisely the
reasons you describe.  We usually don't recommend clusters greater than
32K for filesystems that aren't expressly for large things.

Joel

-- 

"I don't want to achieve immortality through my work; I want to
 achieve immortality through not dying."
        - Woody Allen

			http://www.jlbec.org/
			jlbec@evilplan.org
