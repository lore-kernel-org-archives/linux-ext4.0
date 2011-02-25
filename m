From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 18:40:02 -0500
Message-ID: <20110225234002.GA2924@thunk.org>
References: <E1PsnrK-0005r5-JH@tytso-glaptop>
 <20110225215924.GA28214@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37708 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab1BYXkH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Feb 2011 18:40:07 -0500
Content-Disposition: inline
In-Reply-To: <20110225215924.GA28214@noexit>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 25, 2011 at 01:59:25PM -0800, Joel Becker wrote:
> 
> 	Why not call it a 'cluster' like the rest of us do?  The term
> 'blocksize' is overloaded enough already.

Yes, good point.  Allocation cluster makes a lot more sense as a name.

> > 3) mballoc.c will need little or no changes, other than the
> > EXT4_BLOCKS_PER_GROUP()/EXT4_ALLOC_BLOCKS_PER_GROUP() audit discussed
> > in (1).
> 
> 	Be careful in your zeroing.  A new allocation block might have
> pages at its front that are not part of the write() or mmap().  You'll
> either need to keep track that they are uninitialized, or you will have
> to zero them in write_begin() (ocfs2 does the latter).  We've had quite
> a few tricky bugs in this area, because the standard pagecache code
> handles the pags covered by the write, but the filesystem has to handle
> the new pages outside the write.

We're going to keep track of what blocks are uninitialized or not on a
4k basis.  So that part of the ext4 code doesn't change.

That being said, one of my primary design mantras for ext4 is, "we're
not going to optimize for sparse files".  They should work for
correctness sake, but if the file system isn't at its most performant
in the case of sparse files, I'm not going to shed any tears.

> 	It's a huge win for anything needing large files, like database
> files or VM images.  mkfs.ocfs2 has a vmimage mode just for this ;-)
> Even with good allocation code and proper extents, a long-lived
> filesystem with 4K clusters just gets fragmented.  This leads to later
> files being very discontiguous, which are slow to I/O to.  I think this
> is much more important than the simple speed-of-allocation win.

Yes, very true.

> > Directories will also be allocated in chucks of the allocation block
> > size.  If this is especially large (such as 1 MiB), and there are a
> > large number of directories, this could be quite expensive.
> > Applications which use multi-level directory schemes to keep
> > directories small to optimize for ext2's very slow large directory
> > performance could be especially vulnerable.
> 
> 	Anecdotal evidence suggests that directories often benefit with
> clusters of 8-16K size, but suffer greatly after 128K for precisely the
> reasons you describe.  We usually don't recommend clusters greater than
> 32K for filesystems that aren't expressly for large things.

Yes.  I'm going to assume that file systems optimized for large files
are (in general) not going to have lots of directories, and even if
they do, chewing a 1 megabyte for a directory isn't that a big of a
deal of you're talking about a 2-4TB disk.

We could add complexity to do suballocations for directories, but KISS
seems to be a much better idea for now.

						- Ted
