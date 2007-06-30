From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: fallocate support for bitmap-based files
Date: Sat, 30 Jun 2007 13:29:21 -0400
Message-ID: <20070630172921.GB5159@schatzie.adilger.int>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org> <1183212800.9505.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Mike Waychison <mikew@google.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:46023 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbXGAQVz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2007 12:21:55 -0400
Content-Disposition: inline
In-Reply-To: <1183212800.9505.12.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 30, 2007  10:13 -0400, Mingming Cao wrote:
> Another approach we have been thinking  is using a backing
> inode(per-inode-with-preallocation) to store the preallocated blocks.
> When user asked for preallocation on the base inode, ext2/3 create a
> temporary backing inode, and it's (pre)allocate the corresponding
> blocks in the backing inode. 
> 
> When writes to the base inode, and realize we need to block allocation
> on, before doing the fs real block allocation, it will check if the file
> has a backing inode stores some preallocated blocks for the same logical
> blocks.  If so, it will transfer the preallocated blocks from backing
> inode to the base inode.
> 
> We need to link the two inodes in some way, maybe store the backing
> inode number via EA in the base inode, and flag the base inode that it
> has a backing inode to get preallocated blocks.
> 
> Since it doesn't change the block mapping on the original file until
> writeout, so it doesn't require a incompat feature to protect the
> preallocated contents to be read in "old" kernel. There some work need
> to be done in e2fsck to understand the backing inode.

I don't know if you realize, but this is half-way to supporting
snapshots within the filesystem.  If there are any serious efforts in
the direction of snapshots, you should start by looking at ext3cow,
which does that already.  I haven't looked at that code yet, but I
worked on a snapshotting ext2 many years ago and it was implemented
nearly as you describe (though backward, moving blocks from the "real"
file to the shadow inode).

The OTHER thing that is important for snapshots, is quite easy to
implement now (it even makes the filesystem more robust), but will be
considerably harder to do later, and something I wish someone could work
on is to add "whiteout" support for extents to allow extents in a file
to explicitly encode a hole in the file to "hide" the contents in a
backing/snapshot inode that was truncated away, as described in my email
"[RFC] extent whiteouts" (that nobody ever commented on).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
