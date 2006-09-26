From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 04/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 17:16:43 -0400
Message-ID: <20060926211643.GE4219@thunk.org>
References: <20060926143343.GA20020@openx1.frec.bull.fr> <20060926144716.GD25755@openx1.frec.bull.fr> <20060926173253.GC4219@thunk.org> <20060926195449.GN22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:21983 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S932416AbWIZVQz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 17:16:55 -0400
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20060926195449.GN22010@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 26, 2006 at 01:54:49PM -0600, Andreas Dilger wrote:
> The only function which matches this description is block_iterate_extents()
> but it is not desired that this be a public interface.  It is just the
> "bridge" function between the block iterator and the extent iterator.

Yes, and I thought about simply pouring your extent.c file into
block.c so I could make it a static function.  That would have solved
the function, although made block.c a bit bulky.  But then when I
started thinking about the interface, I realized I wasn't completely
happy with it anyway, so I started rethinking what we wanted to
export.

> > errcode_t ext2fs_extent_iterate(ext2_filsys fs,
> > 				ext2_ino_t	ino,
> > 				int	flags,
> > 				char *block_buf,
> > 				int (*func)(ext2_filsys fs,
> > 					    struct ext2fs_extent *extent,
> > 					    void	*priv_data),
> > 				int (*meta_func)(ext2_filsys fs,
> > 						 blk64_t blk,
> > 						 int blk_type,
> > 						 char *buf,
> > 						 void	*priv_data),
> > 				void *priv_data);
> 
> Hmm, except that this interface isn't sufficient (at first glance) to
> allow full correctness checking of the extent metadata blocks.  It
> would allow checking of a given indirect/index block but not parent/child
> relationships between the index block and the extents/index it points to...

I believe that if we do breadth-first descent through the tree, and
call meta_func three times for each interior node of the tree.  So
when we hit an interior node, we call the meta_func() callback
function, and then we interate through all of the contents of the
node, calling either the func or meta_func callback as appropriate,
and then we call meta_func callback on the parent node again.  If the
child nodes are interior nodes, we then descend down the tree by
taking each interior node in turn, treating each one as a parent,
i.e., calling the meta_func() callback first, then func() or
meta_func() for all of its children, and then meta_func() callback
again.   

The blk_type would allow the callback function to determine whether it
is being called as PARENT_BEGIN_NODE, CHILD_ITERATE_NODE, or
PARENT_END_NODE.

> > This interface will work for both extent and non-extent-based
> > inodes.... that is, if this interface is called on an inode which is
> > using direct and indirect blocks, the function will Do The Right Thing
> > and find contiguous blocks runs which it will use to fill extent
> > structures that will be passed to the callback function.  This is fine,
> > since extent-based interfaces will be easier and more efficient to use
> > anyway.
> 
> Do you think this will be CPU-intensive on non-extent filesystems?

No, I don't think so.

For the application that needs to iterate over all of the blocks in
the file, whether we do it block by block, or do it inside the
block_interate_extent() function and then returning each extent one at
a time, it's the same amount of work.  In fact, by coalescing adjacent
blocks into an extent, the result is probably more cache friendly and
might actually save execution time.   

This is especially true for userspace callers, since they pretty much
all interate over the file sequentially.  The only reason why we might
not want to do this in the kernel is because it may not make sense for
random access files ---- although as we've discussed before, for
certain files, like database files, which are opened, and then
accessed repeatedly via a random access pattern, it may make sense to
figure out all of the extents in advance, store the extent tree in
memory, to accelerate random access lookups.

> > The other interface which I've started spec'ing out in my mind is a new
> > form interface and implementation for bitmaps().  The new-style bitmaps
> > will take a blk64_t type, but their biggest difference is that they will
> > allow multiple different types of interfaces, much like the io_manager
> > abstractions we have right now abstracts our I/O reoutines.  Some
> > implementations may use an extents tree to keep track of used and unused
> > bits.....
>
> It sounds desirable, but is this going to be a requirement for 1.40?  It
> seems like a lot of non-critical work at a point where you have little free
> time and there are other things awaiting the release of 1.40.

No --- but that raises the question of what we need to get into 1.40,
and what time line.  From my way of thinking of things, the big thing
we need to get into 1.40 is extent support, but I'd like to make the
interfaces be correct for 64-bits, even if we don't all get them
there.

Also, if we can get the interfaces _right_, it doesn't necessarily
have to me who does all of the coding.  Others can hopefully do some
of the coding to for example adapt the e2fsck patches to use the new
interfaces --- and if we've gotten the interfaces right, that really
shouldn't be that difficult.

As far as the non-critical work of supporting extra bitmap types, we
don't have to do it all; we just have to do enough of the framework to
support them, and then implement the basic
store-the-whole-bitmap-in-memory one to get started.  We can always do
the rest later.

Regards,

					- Ted
