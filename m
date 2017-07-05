From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: add ext2fs_is_fast_symlink() function
Date: Wed, 5 Jul 2017 00:08:57 -0400
Message-ID: <20170705040857.zjhtkwf74hqqan55@thunk.org>
References: <20170630013159.28178-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47730 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750767AbdGEEI7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 5 Jul 2017 00:08:59 -0400
Content-Disposition: inline
In-Reply-To: <20170630013159.28178-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 29, 2017 at 06:31:59PM -0700, Tahsin Erdogan wrote:
> Current way of determining whether a symlink is in fast symlink
> format is to call ext2fs_inode_data_blocks2(). If number of data
> blocks is zero and EXT4_INLINE_DATA_FL flag is not set, then symlink
> data must be in inode->i_block.
> 
> This heuristic is becoming increasingly hard to maintain because
> inode->i_blocks count can also be incremented for blocks used by
> extended attributes. Before ea_inode feature, extra block could come
> from xattr block, now more blocks can be added because of xattr
> inodes.
> 
> To address the issue, add a ext2fs_is_fast_symlink() function that
> gives a direct answer based on inode->i_size field. This is
> equivalent to kernel's ext4_inode_is_fast_symlink() function.
> 
> This patch also fixes a few issues related to fast symlink handling:
> 
>   - Both rdump_symlink() and follow_link() interpreted symlinks with
>     0 data blocks to always mean fast symlinks. This is incorrect
>     because symlinks that are stored as inline data also have
>     0 data blocks. Thus, they try to read everything from
>     inode->i_block and miss the symlink suffix in inode extra area.
> 
>   - e2fsck_pass1_check_symlink() had code to handle inode with
>     EXT4_INLINE_DATA_FL flag twice. The first if block always returns
>     from the function so the second one is unreachable code.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied to the "next" branch.

						- Ted
