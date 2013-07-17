From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: Prevent massive fs corruption if verifying the
 block bitmap fails
Date: Wed, 17 Jul 2013 12:43:56 -0700
Message-ID: <20130717194356.GB5790@blackbox.djwong.org>
References: <20130717020209.GB5785@blackbox.djwong.org>
 <20130717030832.GB12908@thunk.org>
 <20130717070900.GA5790@blackbox.djwong.org>
 <20130717131951.GC12908@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17668 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab3GQToB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jul 2013 15:44:01 -0400
Content-Disposition: inline
In-Reply-To: <20130717131951.GC12908@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 17, 2013 at 09:19:51AM -0400, Theodore Ts'o wrote:
> On Wed, Jul 17, 2013 at 12:09:00AM -0700, Darrick J. Wong wrote:
> > 
> > I have a question though -- ext4_init_inode_bitmap (and the block bitmap
> > equivalent) contain code to detect a corrupt block group descriptor and "seal"
> > it off by setting the inode/block's free counts to zero and writing 1s to the
> > bitmap.  Does it make more sense to keep doing that, or to hook that up to this
> > EXT4_MB_GRP_CORRUPT mechanism?
> 
> The only thing a I worry a bit about this what
> ext4_init_inode_bitmap() is doing is if the block group descriptor
> checksum is wrong, who's to say that the location of the inode bitmap
> is correct?  Maybe it has been set to overlap with some valid data
> block belonging to a directory, and by memset'ing the bh to zero and
> then marking it up to date, when you try to read the directory, it
> will get all zero's instead of the valid directory information.
> (Fortunately the code in question isn't marking the bh dirty; if it
> did, then it would guarantee the overwritting the directory or data
> block in question, where as if it is just in the buffer cache marked
> uptodate, the user might get lucky and the bh might get pushed out of
> memory.)
> 
> What I would think is a better approach is to change the patch so that
> we have bits indicating an invalid block bitmap and an invalid
> inode/table bitmap, which disables block and inode allocations to that
> block group, respectively.
> 
> We could just also set the inode/block's free counts to zero, but then
> we would need to audit all of the codepaths where we decrement the
> free count to make sure it never goes negative.  (We shold be doing
> that already, though.)

Hmm, ok, I guess we could have separate flags to forbid allocating inodes and
blocks from a block group, and if we find the group descriptor to be faulty we
can forbid both.  I'll go poke on that this after lunch.

I also wrote a script that fills a fs, maliciously marks all the fs metadata
blocks as free, and writes more files to the fs, with the result that you
corrupt the metadata.  I wonder if it's feasible to modify mballoc to check
that it's not handing out well known metadata locations to files?

(metadata_csum will catch this fairly quickly, but you still end up with a
trashed fs.)

--D
> 
> 					- Ted
