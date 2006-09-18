From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Plan for new interfaces in libext2fs to support extents, 64-bits
Date: Sun, 17 Sep 2006 23:47:39 -0400
Message-ID: <E1GPA6d-0003K9-FA@candygram.thunk.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32650 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751384AbWIRDrl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Sep 2006 23:47:41 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

So I've been noodling over Andreas' patches to support 32-bit extents,
as well as glancing at the 48-bit and 64-bit patches, and I've come to
an initial plan for how to fold this into e2fsprogs in the most
ABI-preserving, backwards compatible way possible.  This does mean that
the patches will have to get rototilled significantly before they get
merged in, as I want to make some major changes to the interfaces in
order to guarantee as much forwards compatibility as possible.

I also happen to be a very firm believer in Rusty's philosophy about
interface design, namely for big projects, that it's all about damage
control --- you want interfaces that are not just easy to use, but hard
to misuse, and that it's all about getting the interfaces right.

	http://ozlabs.org/~rusty/ols-2003-keynote/img29.html

It gets worse given that for the ext2fs shared library, we need to make
sure we get the interfaces right once we release a stable version, since
I need to preserve ABI compatibility.  


So the first thing I want to do is to define a new interface for dealing
with extents in libext2fs.  It will look like this:

/*
 * Generic (non-filesystem layout specific) extents structure
 */
struct ext2fs_extent {
	blk64_t	e_pblk;		/* first physical block */
	blk64_t	e_lblk;		/* first logical block extent covers */
	int	e_len;		/* number of blocks covered by extent */
};


Note the use of blk64_t; yes, this means that blk_t will stay as a
32-bit value, and blk64_t will be used for new interfaces and be a
64-bit value.  The basic idea is that as we add support for new extents
formats: 48-bit, 64-bit, bit-packing for compressing many extents inside
the inode, etc., I don't want this to be visible to most applications.
So we will define a new structure to pass extents informatoin between
the library and applications, which is independent of the on-disk
format.

This will get used to define an extent iterator function, that will look
something like this:

errcode_t ext2fs_extent_iterate(ext2_filsys fs,
				ext2_ino_t	ino,
				int	flags,
				char *block_buf,
				int (*func)(ext2_filsys fs,
					    struct ext2fs_extent *extent,
					    void	*priv_data),
				int (*meta_func)(ext2_filsys fs,
						 blk64_t blk,
						 int blk_type,
						 char *buf,
						 void	*priv_data),
				void *priv_data);

This interface will work for both extent and non-extent-based
inodes.... that is, if this interface is called on an inode which is
using direct and indirect blocks, the function will Do The Right Thing
and find contiguous blocks runs which it will use to fill extent
structures that will be passed to the callback function.  This is fine,
since extent-based interfaces will be easier and more efficient to use
anyway.

We will also define two interfaces to manipulate the extents tree (and
which again, will Do The Right Thing on traditional non-extents based
inods):

errcode_t ext2fs_extent_set(ext2_filsys fs,
			    ext2_ino_t	ino,
			    ext2_ino_t	*block_buf,
			    struct_ext2fs_extent *extent);

errcode_t ext2fs_extent_delete(ext2_filsys fs,
			       ext2_ino_t	ino,
			       ext2_ino_t	*block_buf,
			       struct_ext2fs_extent *extent);


Both of these interfaces may require splitting an existing extent.  For
example, if ext2fs_extent_set() is passed an extent which falls in the
middle of an extent in the inode, it could result in one extent turning
into three extents (namely the before extent, the new extent, and the
after extent).  Similarly ext2fs_extent_delete() may be asked to delete
a sub-extent in the middle of an existing extent in the extent tree.
This would be logically equivalent to the Windows NT "punch" operation,
which is a more general version of truncate(), except it can remove
blocks from the middle of a file.


The othher interface which I've started spec'ing out in my mind is a new
form interface and implementation for bitmaps().  The new-style bitmaps
will take a blk64_t type, but their biggest difference is that they will
allow multiple different types of interfaces, much like the io_manager
abstractions we have right now abstracts our I/O reoutines.  Some
implementations may use an extents tree to keep track of used and unused
bits.  Anothers might use a disk file as a LRU backing store (this will
be necessary to support really large storage devices on systems with
limited physical memory).  And of course, at least initially the first
implementation we will support will be the old-fasheioned, "store the
whole thing in memory" approach.

So the basic idea is to implement new library abstractions which will
work well for 32-bit extents, but which can be easily extensible to
newer patches, and which can solve other problems as well while we're at
it (such as the people trying to use a cheap processor with small
amounts of memory with terabytes of storagte and their having problems
with fsck running out of memory, for example).

Comments?

						- Ted
	










