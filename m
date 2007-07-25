From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Wed, 25 Jul 2007 10:32:09 -0400
Message-ID: <20070725143209.GA23613@thunk.org>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57204 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbXGYOcO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jul 2007 10:32:14 -0400
Content-Disposition: inline
In-Reply-To: <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 25, 2007 at 11:06:28AM +0530, Aneesh Kumar K.V wrote:
> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> Add new option -I <inode_size> to tune2fs.
> This is used to change the inode size. The size
> need to be multiple of 2 and we don't allow to
> decrease the inode size.
> 
> As a part of increasing the inode size we throw
> away the free inodes in the last block group. If
> we can't we fail. In such case one can resize the
> file system and then try to increase the inode size.

Let me guess, you're testing with a filesystem with two block groups,
right?  And to date you've tested *only* by doubling the size of the
inode.

What your patch does is is keep the number of inode blocks per block
group constant, so that the total number of inodes decreases by
whatever factor the inode size is increasing.  It's a cheap, dirty way
of doing the resizing, since it avoids needing to either (a) update
directory entries when inode numbers get renumbered, and (b) need to
update inodes when blocks need to get relocated in order to make room
for growing the inode table.

The problem with your patch is:

	* By shrinking the number of inodes, it can constrain the
          ability of the filesystem to create new files in the future.

	* It ruins the inode and block placement algorithms where we
          try to keep inodes in the same block group as their parent
          directory, and we try to allocate blocks in the same block
          group as their containing inode.

	* Because when the current patch makes no attempt to relocate
          inodes, and when it doubles the inode size, it chops the
          number of inodes in half, there must be no inodes in the
          last half of the inode table.  That is if there are N block
          groups, the inode tables in blockgroups N/2 to N-1 must be
          empty.  But because of the block group spreading algorithm,
          where new directories get pushed out to new block groups, in
          any real real-life filesystem, the use of block groups is
          evenly spread out, which means in practice you won't see
          case where the last half of the inodes will not be in use.
          Hence, your patch won't actually work in practice.

So unfortunately, the right answer *will* require expanding the inode
tables, and potentially moving blocks out of the way in order to make
room for it.  A lot of that machinery is in resize2fs, actually, and
I'm wondering if the right answer is to move resize2fs's functionality
into tune2fs.  We will also need this to be able to add the resize
inode after the fact.

That's not going to be a trivial set of changes; if you're looking for
something to test the undo manager, my suggestion would be to wire it
up into mke2fs and/or e2fsck first.  Mke2fs might be nice since it
will give us a recovery path in case someone screws up the arguments
to mkfs.  

> tune2fs use undo I/O manager when migrating to large
> inode. This helps in reverting the changes if end results
> are not correct.The environment variable TUNE2FS_SCRATCH_DIR
> is used to indicate the  directory within which the tdb
> file need to be created. The file will be named tune2fs-XXXXXX

My suggestion would be to use something like /var/lib/e2fsprogs as the
defalut directory.  And we should also do some tests to make sure
something sane happens if we run out of room for the undo file.
Presumably the only thing we can do is to abort the run and then back
out the chnages using what was written out to the undo file.

    		      	       	       	   - Ted
