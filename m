From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/74] resize2fs: rewrite extent/dir/ea block checksums
 when migrating
Date: Thu, 12 Dec 2013 23:35:53 -0500
Message-ID: <20131213043553.GE23888@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012001.30655.83797.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39578 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3LMEfz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 23:35:55 -0500
Content-Disposition: inline
In-Reply-To: <20131211012001.30655.83797.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:20:01PM -0800, Darrick J. Wong wrote:
> With the advent of metadata_csum, we now tie extent and directory
> blocks to the associated inode number (and generation).  Therefore, we
> must be careful when remapping inodes.  At that point in the resize
> process, all the blocks that are going away have been duplicated
> elsewhere in the FS (albeit with checksums based on the old inode
> numbers).  If we're moving the inode, then do that and remember that
> new inode number.  Now we can update the block mappings for each inode
> with the final inode number, and schedule directory blocks for mass
> inode relocation.  We also have to recalculate the EA block checksum.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied to the next branch.

				- Ted
