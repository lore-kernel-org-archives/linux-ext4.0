From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 16:10:27 -0400
Message-ID: <20090824201027.GC17684@mit.edu>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35616 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZHXUKa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 16:10:30 -0400
Content-Disposition: inline
In-Reply-To: <20090824183119.GI5931@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 24, 2009 at 12:31:19PM -0600, Andreas Dilger wrote:
> > No one has gotten around to looking at this closely; I think adding a
> > strategically placed blkdev_issue_flush() will allow us to safely
> > enable this feature, but it needs careful study.
> 
> I don't think that was the issue, but rather that we wanted to have
> per-block checksums in order to handle the case were some block in
> transaction A is causing a transaction checksum failure, yet transaction
> B has already committed and begun checkpointing.

There are multiple problems that are going on here.

Adding per-block checksums is useful in providing better resiliance in
the case of write errors in the journal, and providing better error
handling when we detect a checksum error in the commit block.

However, even if we add even if we add per-block checksums, there is
still the problem that there is logic in the jbd layer where we avoid
reusing certain blocks until we are sure the transaction has
committed.  With asynchronous commits, there is no way of knowing when
it is safe to reuse those blocks.  

To illustrate, consider a data block for an inode which has just been
deleted.  We have code which prevents that block from being reused
until the transaction has committed; but when we use asynchronous
commits, we don't know when that will be.  Currently the async commit
code assumes that once we send the commit block to be written, the
commit has happened; this opens up a race where between when the
commit record (and all of the associated journal blocks) is actually
written to disk, and when a data block gets reused.

Most of the time, this will cause silent corruption of a data file
that was about to be deleted right before the power failure --- but if
the block in question was part of a directory that was in the process
of being deleted, it could result in a filesystem corruption
detectable by e2fsck.

Looking at the code, the best we can do in the short-term is to write
the commit record where we do, but do so with a barrier requested, and
then wait for the commit block where we do.  This will provide some
performance improvement, since we won't wait for all of the journal
blocks to be sent to disk before writing the commit record.  However,
we still have to wait for the commit record (and all of the blocks
before it) to be committed to stable store before we can mark the
transaction as being truly committed.  So it's not a true "async
commit", but it is a benefit of adding journal checksums.

It might be possible in the long term to batch together multiple
transaction in the "committing" state, instead of only allowing one
transaction to be in the committing state, and to prevent blocks from
being reused or allowing pinned buffer_heads from writing the contents
of the blocks to their final location on disk until we are 100% sure
the commit block and all of the associated journal blocks really have
made it to disk.  However, it's probably not worth doing this, since
the only time this would make a big difference is when we have several
transactions closing within the space of a short time; and in that
case the fsync() requires a barrier operation anyway.

							- Ted
