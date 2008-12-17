From: Theodore Tso <tytso@mit.edu>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	00000000 [ext4_new_meta_blocks+0x7c/0xb7]
Date: Wed, 17 Dec 2008 06:47:11 -0500
Message-ID: <20081217114711.GL10590@mit.edu>
References: <20081209104121.GA7572@skywalker> <20081212145609.GA26085@mit.edu> <20081217075635.GA7685@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40809 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751946AbYLQLrQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 06:47:16 -0500
Content-Disposition: inline
In-Reply-To: <20081217075635.GA7685@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 17, 2008 at 01:26:35PM +0530, Aneesh Kumar K.V wrote:
> > One of the good things about getting rid of too many layers of
> > abstractions is that it makes bugs like this easier to spot.  We've
> > been sending allocating directory and symlinks using EXT4_MB_HINT_DATA
> > if extents haven't been enabled, and no one noticed before we
> > simplified out things....
> 
> We had always sent the directory allocation request with
> EXT4_MB_HINT_DATA not set.

With extents, yes.  With normal indirect block-based files, no.  I
agree that for consistency's sake, it should be the same, but at the
moment, it isn't.

> > Actually, I wonder if maybe we should set EXT4_MB_HINT_DATA for
> > directories as well.  Making directories contiguous does speed up
> > certain workloads, and it does speed up fsck.  It may be though that
> > the mballoc algorithms should be tuned specifically for directories,
> > and what we should do is to define a new flag, EXT4_MB_HINT_DIRECTORY,
> > and pass it in for that case. 
> > 
>
> True. But with the changes to do do_blk_alloc I guess we need to make
> sure we request directories with EXT4_MB_HINT_DATA not set.

I've played with this a bit, and changing extents.c to pass in
EXT4_MB_HINT_DATA for directories does work, although it's a toss-up
regarding exactly how effective it really is.  It does seem to reduce
fragmentation of directories, but I'm concerned that it might impact
the long-term performance of the filesystem as it ages.

My current thinking is that we should consider changing the block
allocation algorithms as follows:

1) Change the inode allocator to strongly avoid (unless no other
inodes are available) block groups where the block group number is a
even multiple of the flex blockgroup size.  The reasoning behind this
is these bg's have a fewer number of blocks given that the inode table
blocks are all allocated there, so they are much more likely to
overflow into other bg's when used.  So we should try to avoid these
bg's by the inode allocator unless there is no other choice.

2) Directory blocks for inodes in the flex bg metagroup should be
allocated in this first bg of the flexbg metagroup.  This keeps the
filesystem metadata together, and keeps directory blocks (which tend
to be much longer-lived that data blocks, especially for source/build
directories) in different block allocation regions, which is a good
thing.  It may be that all metadata blocks (i.e., also long symlinks
and extent-tree blocks) should also be located here, although that's
probably less important, simply because there are so few of such
blocks in most ext4 filesystems.  

							- Ted
