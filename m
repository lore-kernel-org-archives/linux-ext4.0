From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Automatically enable journal_async_commit on
	ext4 file systems
Date: Sat, 5 Sep 2009 21:32:45 -0400
Message-ID: <20090906013245.GD2287@mit.edu>
References: <1252189963-23868-1-git-send-email-tytso@mit.edu> <1252189963-23868-2-git-send-email-tytso@mit.edu> <20090905225747.GP4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60631 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbZIFBcq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Sep 2009 21:32:46 -0400
Content-Disposition: inline
In-Reply-To: <20090905225747.GP4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 06, 2009 at 12:57:47AM +0200, Andreas Dilger wrote:
> On Sep 05, 2009  18:32 -0400, Theodore Ts'o wrote:
> > Now that we have cleaned up journal_async_commit, it's safe to enable
> > it all the time.  But we only want to do so if ext4-specific INCOMPAT
> > features are enabled, since otherwise we will prevent the filesystem
> > from being mounted using ext3.
> 
> So, the big question is what to do if not-the-last transaction in the
> journal has a bad block in it?  This is fairly unlikely, and IMHO the
> harm of aborting journal replay too early is likely far outweighed by
> the benefit of not "recovering" garbage directly over the filesystem
> metadata.
> 
> I had thought that you had rejected the e2fsck side of this patch for
> that reason, but maybe my memory is faulty...  We still have some
> test images for bad journal checksums that you can have if you want.

No, it's in e2fsck.  Right now, if we have a checksum failure, we
abort the journal replay dead in its tracks.  Whether or not that's
the right thing is actually highly questionable.  Yes, there's the
chance that we can recover garbage directly over the file system
metadata.  But the flip side is that if we abort the journal replay
too early, we can end up leaving the filesystem horribly corrupted.
In addition, if the it's a block which has been journalled multiple
time (which will is highly likely for block allocation blocks or inode
allocation blocks), an error in the middle of the journal is not a
disaster.

The one thing I have to check is to make sure that e2fsck forces a
filesystem check if it aborts a journal replay due to a checksum
error.  I'm pretty sure I did add that, but I need to make sure it's
there.

The other thing we might want to do is to add some code in ext4 is to
call jbd2_cleanup_journal_tail() a bit more aggressively.  If all of
the blocks in the transaction has been pushed out, then updating the
journal superblock frequently will reduce the number of transactions
that need to be replayed.  Right now, we often replay more transaction
that we strictly need to, out of a desire to reduce the need to update
the journal superblock.  But we are replaying transactions 23..30, but
we really only need to replay transactions 28 29 and 30 in order to
bring the filesystem into consistency, and we have a checksum failure
while reading some of the data blocks found in transaction 25, we'll
end up never replaying transactions 28--30, and we may end up losing
data, especially if we already started writing some (but not all) of
the blocks involved with transactions 28 and 29 to their final
location on disk.

					- Ted
