From: Andi Kleen <ak@suse.de>
Subject: Re: ext4 compat flag assignments
Date: Fri, 29 Sep 2006 01:06:27 +0200
Message-ID: <200609290106.27852.ak@suse.de>
References: <20060922091520.GC6335@schatzie.adilger.int> <p73u02rivk8.fsf@verdi.suse.de> <20060928224133.GM22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:13472 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S964904AbWI1XId (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Sep 2006 19:08:33 -0400
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20060928224133.GM22010@schatzie.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


> Actually, there are several plans afoot in that direction already.
> Some of them need at least some help in the "finish up and get it
> into the kernel" department, some of them are just ideas previously
> discussed..

The important part right now is to just keep enough space in all 
structures that are being changed anyways.

> 
> One of the reason for Alexandre pushing the 64-bit inode/block counters
> into the "large" descriptor is because the 64-bit filesystem is already
> incompatible with a 32-bit filesystem so there is no extra harm, and this
> leaves space in the "original" group descriptor for checksums of the block
> and inode bitmaps.  The bitmap checksums are a critical single-point-of-
> failure, and having checksums allows the kernel to avoid cascading
> filesystem corruption even if it can't (yet) do anything about it.
> Having the checksums in the "original" group descriptor allows this
> feature to be used on both 32-bit and 64-bit filesystems.

Ok.

> No work has been done on this yet.  Getting checksums to be efficient
> depends on having a generic callback mechanism from the journal code
> to avoid repeated checksums on a block while it is being modified.

You can just do incremental checksumming which is very cheap. 

Or did you mean the flushing to disk of the checksum? If it's always in the same
object that would be free, but that is not possible for bitmaps at least.
But I guess the checksum write in the block descriptor 
could be done very lazily at least, perhaps keeping track on disk if invalid
checksums are expected or not.

> Finally, the extents format has the capability (though no code is implemented
> for this yet) to store a checksum in each index and extent block.  This
> would be done by reducing the count of allowed entries in the block and
> storing an ext3_extent_tail (checksum, inode+generation backpointer) as
> the last entry in the block.  No work has been done on this, but I've
> described the ext3_extent_tail a few times previously on this list.

Old style indirect blocks will need them too. My thinking was
to use another block for those (so a indirect block would be two nearby
blocks) 

Inodes need them, but with the inode extension that will be hopefully
not a problem to keep a few bytes for this.

And directories, which should be relatively easy to extend with
the current format.

-Andi
