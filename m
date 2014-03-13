From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/49] e2fsck: don't rehash inline directories
Date: Wed, 12 Mar 2014 22:38:48 -0700
Message-ID: <20140313053848.GD9070@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065449.30585.54020.stgit@birch.djwong.org>
 <20140313035248.GC13367@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36120 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaCMFiw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2014 01:38:52 -0400
Content-Disposition: inline
In-Reply-To: <20140313035248.GC13367@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2014 at 11:52:48PM -0400, Theodore Ts'o wrote:
> On Mon, Mar 10, 2014 at 11:54:49PM -0700, Darrick J. Wong wrote:
> > If a directory's contents are stored entirely inside the inode,
> > there's no index to rebuild and no dirblock checksum to recompute.
> > As far as I know these are the only two reasons to call dir rehash.
> 
> Well, actually, there is a third reason to rehash directories, and
> that is to reorganize a directory to optimize out deleted entries that
> are scattered in the middle of the directory.

Ooh, I forgot about that. :/

> That being said, it's more critical for inline directories, since we
> very much want to keep them from spilling over to an external block,
> this process of compressing out deleted space is something that should
> be done in real time as we operate on the directory, by the kernel,
> and not just at fsck time.
> 
> The only reason why we don't do this today is because if the directory
> is open for scanning using opendir/readdir, if we reorganize a
> directory block, it could end up corrupting the readdir --- and for
> non-inline directories, it's much less important.
> 
> What I think would might make sense is to have the kernel track
> whether the directory has been opened for reading, and if it hasn't,
> then it would be safe to try compressing all of the directory entries
> in the block so that the free space is in a single unused directory
> entry at the end of the block.  We could try doing this "dynamic
> compression" of directory free space both at unlink(2) time, and also
> when we try inserting a directory entry into the block and there is
> apparently no space in the directory block.
> 
> So I'm fine with skipping the rehashing of inline directories now, but
> this is a future, relatively small, kernel project we might want to
> think about for ext4.

Probably we ought to fix up rehash.c to be able to compress directory entries
too.  The only reason I kicked them here was that somehow an inline data dir
would end up on the rehash list, causing the block iteration to fail and e2fsck
stops cold.

--D
> 
> Cheers,
> 
> 							- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
