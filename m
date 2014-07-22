From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/24] e2fsck: fix inode coherency issue when iterating
 an inode's blocks
Date: Tue, 22 Jul 2014 14:58:10 -0400
Message-ID: <20140722185810.GL25291@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225311.31374.34009.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50561 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaGVUea (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:34:30 -0400
Content-Disposition: inline
In-Reply-To: <20140718225311.31374.34009.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:53:11PM -0700, Darrick J. Wong wrote:
> When we're about to iterate the blocks of a block-map file, we need to
> write the inode out to disk if it's dirty because block_iterate3()
> will re-read the inode from disk.  (In practice this won't happen
> because nothing dirties block-mapped inodes before the iterate call,
> but we can program defensively).
> 
> More importantly, we need to re-read the inode after the iterate()
> operation because it's possible that mappings were changed (or erased)
> during the iteration.  If we then dirty or clear the inode, we'll
> mistakenly write the old inode values back out to disk!
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
