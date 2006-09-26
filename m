From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [patch 04/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 13:54:49 -0600
Message-ID: <20060926195449.GN22010@schatzie.adilger.int>
References: <20060926143343.GA20020@openx1.frec.bull.fr> <20060926144716.GD25755@openx1.frec.bull.fr> <20060926173253.GC4219@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:20168 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S932254AbWIZTyw
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 15:54:52 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20060926173253.GC4219@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 26, 2006  13:32 -0400, Theodore Tso wrote:
> hopefully I or someone else will be able to rework this patch (which
> is way too big, and violates the namespace guidelines --- all
> publically visible new symbols in the ext2fs library must be prefixed
> by ext2fs_ in order to minimize namespace pollution issues)

The only function which matches this description is block_iterate_extents()
but it is not desired that this be a public interface.  It is just the
"bridge" function between the block iterator and the extent iterator.

>  */
> struct ext2fs_extent {
> 	blk64_t	e_pblk;		/* first physical block */
> 	blk64_t	e_lblk;		/* first logical block extent covers */
> 	int	e_len;		/* number of blocks covered by extent */
> };
> 
> 
> Note the use of blk64_t; yes, this means that blk_t will stay as a
> 32-bit value, and blk64_t will be used for new interfaces and be a
> 64-bit value.  The basic idea is that as we add support for new extents
> formats: 48-bit, 64-bit, bit-packing for compressing many extents inside
> the inode, etc., I don't want this to be visible to most applications.
> So we will define a new structure to pass extents informatoin between
> the library and applications, which is independent of the on-disk
> format.
> 
> This will get used to define an extent iterator function, that will look
> something like this:
> 
> errcode_t ext2fs_extent_iterate(ext2_filsys fs,
> 				ext2_ino_t	ino,
> 				int	flags,
> 				char *block_buf,
> 				int (*func)(ext2_filsys fs,
> 					    struct ext2fs_extent *extent,
> 					    void	*priv_data),
> 				int (*meta_func)(ext2_filsys fs,
> 						 blk64_t blk,
> 						 int blk_type,
> 						 char *buf,
> 						 void	*priv_data),
> 				void *priv_data);

Hmm, except that this interface isn't sufficient (at first glance) to
allow full correctness checking of the extent metadata blocks.  It
would allow checking of a given indirect/index block but not parent/child
relationships between the index block and the extents/index it points to...

> This interface will work for both extent and non-extent-based
> inodes.... that is, if this interface is called on an inode which is
> using direct and indirect blocks, the function will Do The Right Thing
> and find contiguous blocks runs which it will use to fill extent
> structures that will be passed to the callback function.  This is fine,
> since extent-based interfaces will be easier and more efficient to use
> anyway.

Do you think this will be CPU-intensive on non-extent filesystems?

> We will also define two interfaces to manipulate the extents tree (and
> which again, will Do The Right Thing on traditional non-extents based
> inods):
> 
> errcode_t ext2fs_extent_set(ext2_filsys fs,
> 			    ext2_ino_t	ino,
> 			    ext2_ino_t	*block_buf,
> 			    struct_ext2fs_extent *extent);
> 
> errcode_t ext2fs_extent_delete(ext2_filsys fs,
> 			       ext2_ino_t	ino,
> 			       ext2_ino_t	*block_buf,
> 			       struct_ext2fs_extent *extent);

Should the above "ext2_ino_t *block_buf" be "ext2_blk_t *block_buf"?

> The other interface which I've started spec'ing out in my mind is a new
> form interface and implementation for bitmaps().  The new-style bitmaps
> will take a blk64_t type, but their biggest difference is that they will
> allow multiple different types of interfaces, much like the io_manager
> abstractions we have right now abstracts our I/O reoutines.  Some
> implementations may use an extents tree to keep track of used and unused
> bits.  Anothers might use a disk file as a LRU backing store (this will
> be necessary to support really large storage devices on systems with
> limited physical memory).  And of course, at least initially the first
> implementation we will support will be the old-fasheioned, "store the
> whole thing in memory" approach.

It sounds desirable, but is this going to be a requirement for 1.40?  It
seems like a lot of non-critical work at a point where you have little free
time and there are other things awaiting the release of 1.40.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

