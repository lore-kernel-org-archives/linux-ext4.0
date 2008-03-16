From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] jbd2: Add commit time into the commit block
Date: Sun, 16 Mar 2008 14:52:31 -0400
Message-ID: <20080316185231.GL27847@mit.edu>
References: <1205629144-25994-1-git-send-email-tytso@mit.edu> <20080316012602.GZ3542@webber.adilger.int> <20080316031039.GJ27847@mit.edu> <20080316151617.GA3542@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35790 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752209AbYCPSwo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Mar 2008 14:52:44 -0400
Content-Disposition: inline
In-Reply-To: <20080316151617.GA3542@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 16, 2008 at 11:16:17PM +0800, Andreas Dilger wrote:
> > I guess the third alternative, (c), is that we don't update *any* of
> > the superblock or block group descriptors until the very end of the
> > transaction, and don't update any of the blocks.  So we just update
> > the bitmap blocks first, and then in a second pass update all of the
> > blockgroup descriptors and superblock.  This would require assuring
> > that the update of all of the block group descriptors, superblock, and
> > removing the inode from the orphan linked list, can all fit in a
> > single transaction. If not, this scheme wouldn't work at all.
> 
> I'm not sure I understand this.  Wouldn't this possibly lead to those
> blocks being re-allocated after a crash?

No, because the inode is on the orphan/truncate list, which would get
processed as part of mounting the filesystem.  So we might end up
replaying some of the updates to the bitmaps, and clearing blocks that
are already cleared; but that's OK, because clearing the bitmap
allocations is an idempotent operation.  Incrementing the free blocks
count in the superblock and bitmap allocation blocks is *not*
idempotent, which means they they (along with removing the inode from
the orphaned inode list) all have to be done within a single atomic
transaction.

						- Ted
