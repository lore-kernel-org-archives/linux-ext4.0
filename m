From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4 compat flag assignments
Date: Sun, 1 Oct 2006 22:34:58 -0600
Message-ID: <20061002043458.GF22010@schatzie.adilger.int>
References: <20060922091520.GC6335@schatzie.adilger.int> <p73u02rivk8.fsf@verdi.suse.de> <20060928224133.GM22010@schatzie.adilger.int> <200609290106.27852.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:21169 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S932413AbWJBEfB
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Oct 2006 00:35:01 -0400
To: Andi Kleen <ak@suse.de>
Content-Disposition: inline
In-Reply-To: <200609290106.27852.ak@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 29, 2006  01:06 +0200, Andi Kleen wrote:
> Andreas Dilger wrote:
> > No work has been done on this yet.  Getting checksums to be efficient
> > depends on having a generic callback mechanism from the journal code
> > to avoid repeated checksums on a block while it is being modified.
> 
> You can just do incremental checksumming which is very cheap. 
> 
> Or did you mean the flushing to disk of the checksum?  If it's always in
> the same object that would be free, but that is not possible for bitmaps
> at least.  But I guess the checksum write in the block descriptor 
> could be done very lazily at least, perhaps keeping track on disk if invalid
> checksums are expected or not.

I'm not sure I understand what you mean.  My goal is that the ext4 code
modifies the block as many times as it wants during a transaction (this
may happen from multiple threads for a single block), then just before
the transaction is committed to disk the journal calls a callback for that
block (inode, group descriptor, bitmap, superblock, extent, index, etc) and 
computes the checksum only once for that block.  Then the block is flushed
to filesystem.

I'm not sure I like the idea of writing "this block doesn't have a valid
checksum" to disk, since there is some risk of that block being corrupted
during a crash and then we don't know if the block is valid or not.

> > Finally, the extents format has the capability (though no code is
> > implemented for this yet) to store a checksum in each index and extent
> > block... storing an ext3_extent_tail (checksum, inode+generation
> > backpointer) as the last entry in the block.
> 
> Old style indirect blocks will need them too. My thinking was
> to use another block for those (so a indirect block would be two nearby
> blocks) 

We couldn't do this for the existing indirect blocks easily, but what I'd
thought is that it is possible to either have e2fsck convert block-mapped
files to extent mapped (with extent tail of checksum + inode backpointer)
or have a new block-mapped extent (for fragmented files), which would also
have a header with magic (so that random garbage in a large filesystem
doesn't look like a valid [dt]indirect block) and also have the extent
tail to contain the checksum + inode backpointer.

> Inodes need them, but with the inode extension that will be hopefully
> not a problem to keep a few bytes for this.

Yes, it might even be valuable to put this into the "small" inode so
that it can be used for existing ext3 filesystems.

> And directories, which should be relatively easy to extend with
> the current format.

Haven't thought about that specifically for directories, but I do have
some ideas about enhancing the directory format to allow storing more
data into the dir_entries (e.g. 64-bit inode) and possibly using the
same code to store a tree of EAs in the same format as directories, so
the htree code can be used to do lookups if there are lots of EAs.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

