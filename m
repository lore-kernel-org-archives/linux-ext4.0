From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/24] libext2fs: fix bounds check of the bitmap test
 range in get_free_blocks2
Date: Fri, 25 Jul 2014 07:13:42 -0400
Message-ID: <20140725111342.GE1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225359.31374.84989.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56124 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaGYLNs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 07:13:48 -0400
Content-Disposition: inline
In-Reply-To: <20140718225359.31374.84989.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:53:59PM -0700, Darrick J. Wong wrote:
> In the loop in ext2fs_get_free_blocks2, we ask the bitmap if there's a
> range of free blocks starting at "b" and ending at "b + num - 1".
> That quantity is the number of the last block in the range.  Since
> ext2fs_blocks_count() returns the number of blocks and not the number
> of the last block in the filesystem, the check is incorrect.
> 
> Put in a shortcut to exit the loop if finish > start, because in that
> case it's obvious that we don't need to reset to the beginning of the
> FS to continue the search for blocks.  This is needed to terminate the
> loop because the broken test meant that b could get large enough to
> equal finish, which would end the while loop.
> 
> The attached testcase shows that with the off by one error, it is
> possible to throw e2fsck into an infinite loop while it tries to
> find space for the inode table even though there's no space for one.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
