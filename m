From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] jbd2: Add commit time into the commit block
Date: Sat, 15 Mar 2008 23:10:39 -0400
Message-ID: <20080316031039.GJ27847@mit.edu>
References: <1205629144-25994-1-git-send-email-tytso@mit.edu> <20080316012602.GZ3542@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:56845 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751718AbYCPDKq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 23:10:46 -0400
Content-Disposition: inline
In-Reply-To: <20080316012602.GZ3542@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 16, 2008 at 09:26:02AM +0800, Andreas Dilger wrote:
> On Mar 15, 2008  20:59 -0400, Theodore Ts'o wrote:
> > Carlo Wood has demonstrated that it's possible to recover deleted
> > files from the journal.  Something that will make this easier is if we
> > can put the time of the commit into commit block.
> 
> Note that we'd still be a lot further ahead undelete- and performance-wise
> if we avoided overwriting the indirect blocks in the first place...  As
> it is, this is only really useful if you pull the plug after the delete.
> No harm in doing it, but won't help you recover as much as you could.

Yeah, I looked at that at one point, but I never had time to try to
code it up.  The concept would is that we only need to zero out the
block pointers if we end up dirtying enough bitmap blocks that we've
run out of space in the journal and so we need to close the
transaction.  Of course, the problem is that we need to either (a)
figure out in advance exactly how many bitmap blocks we need to dirty
(which means we have to read all the indirect blocks twice to figure
it out for ext3; this is easier for ext4) so we know whether it will
fit in one transaction, or (b) if we try to do it in a single pass, we
need to allow enough safety margin so that when we *do* decide we
can't make it fit, we still do have enough space in the journal to
zero out the blocks in the indirect blocks and in the inode.

I guess the third alternative, (c), is that we don't update *any* of
the superblock or block group descriptors until the very end of the
transaction, and don't update any of the blocks.  So we just update
the bitmap blocks first, and then in a second pass update all of the
blockgroup descriptors and superblock.  This would require assuring
that the update of all of the block group descriptors, superblock, and
removing the inode from the orphan linked list, can all fit in a
single transaction. If not, this scheme wouldn't work at all.

(a) is probably the simplest, but it's fundamentally a two pass
algorithm.

						- Ted
