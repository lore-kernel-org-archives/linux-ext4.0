From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: correctly subtract xattr blocks on bigalloc
 filesystems
Date: Wed, 24 May 2017 21:54:01 -0400
Message-ID: <20170525015401.3d3ntl7vg7wua5my@thunk.org>
References: <20170521062303.32296-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35562 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754744AbdEYByD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 May 2017 21:54:03 -0400
Content-Disposition: inline
In-Reply-To: <20170521062303.32296-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 20, 2017 at 11:23:03PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> ext2fs_inode_data_blocks2() calculates an inode's data block count by
> subtracting the external xattr block, if any, from the total blocks.
> But on bigalloc filesystems, the xattr "block" is actually a whole
> cluster, so ext2fs_inode_data_blocks2() would return a too-large value.
> 
> It seems this could have caused several different problems, but the one
> I encountered was that xfstest generic/399 failed in the "bigalloc"
> config because e2fsck incorrectly considered a symlink on the filesystem
> to be corrupted at the end of the test.  This happened because e2fsck
> incorrectly calculated a nonzero data block count for a "fast" symlink
> with an external xattr block and therefore treated it as a "slow"
> symlink, which failed validation.
> 
> Fix this by updating ext2fs_inode_data_blocks2() to subtract the cluster
> size rather than the block size.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
