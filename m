From: number9652 <number9652@yahoo.com>
Subject: Re: e2fsprogs bmap problem
Date: Mon, 18 May 2009 07:56:38 -0700 (PDT)
Message-ID: <199598.89239.qm@web43514.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n76.bullet.mail.sp1.yahoo.com ([98.136.44.48]:33518 "HELO
	n76.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751140AbZERO4h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 10:56:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--- Theodore Tso wrote:
> number9652 wrote:
> > 
> > I am running into a problem with the output of the
> function
> > ext2fs_bmap in the ext2fs library version 1.41.5: when
> I send it an
> > inode structure pointer as the third argument and the
> number of a
> > deleted inode as the second argument, it seems to end
> up trying to
> > read the deleted inode from disk (and results in the
> returned value
> > block number being 0), when I expected it to just get
> the values
> > from the inode structure I send to it.  This only
> happens if the
> > inode contains an extent structure within it; when it
> has the
> > indirect block structure it behaves as I expected.
> 
> I suppose we could add a new version of the extent
> structure which
> used a caller-supplied inode structure.  This would be
> mostly safe as
> long as you were only doing read-only operations on the
> buffer head,
> and only assuming that all of the extents fit in the inode
> structure.

I have looked at it a little more closely now, and to me it seems that we could add a new function like ext2fs_extent_open to accept an inode structure, as an alternative to changing the extent structure.

> The short version is it would be possible for us to patch
> the extents
> support code to use a passed-in inode, and then change
> ext2fs_bmap()
> to pass the inode structure to the extents functions, but
> the main
> reason why I would do it would be for the optimization, and
> not to
> support (at least officially) the use of an inode structure
> different
> from what is on disk, since that is highly likely to simply
> not work
> correctly.

I didn't consider it, but I agree that the efficiency improvement is a much better reason.  I realize there are a lot of pitfalls, some of which you enumerated, for using the inodes in this way.  For the particular use I was trying, I had opened the fs read only, and I realize I may get garbage at the end of it, but also that sometimes I will get the file.
> 
> Out of curiosity, where are you getting the data for the
> inode
> structure if it is not on disk?  Is this some kind of
> ext3grep-like
> approach where you are grabbing an old version of the inode
> from the
> journal, or some such?

Yes, that is exactly it (see extundelete.sf.net if you are interested).  Currently, it has a local copy of ext2fs_block_iterate2 (and most of the rest of block.c and some from extents.c) that was modified to accept an inode to be able to restore files from an ext4 file system; I was hoping it could use bmap to get rid of most of that, but found this during testing.



      

