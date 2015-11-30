From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] e2fsck: fix e2fsck -fD directory truncation
Date: Mon, 30 Nov 2015 15:29:52 -0500
Message-ID: <20151130202952.GH4316@thunk.org>
References: <1447920799-12834-1-git-send-email-andreas.dilger@intel.com>
 <1447920799-12834-2-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58312 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbbK3U3x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 15:29:53 -0500
Content-Disposition: inline
In-Reply-To: <1447920799-12834-2-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 19, 2015 at 01:13:19AM -0700, Andreas Dilger wrote:
> When an extent-mapped directory is compacted by "e2fsck -fD" and
> frees enough leaf blocks that it loses an extent tree index block,
> the old e2fsck_rehash_dir->ext2fs_block_iterate3->write_dir_block()
> code would not free the extent block, which would result in the
> extent tree becoming corrupted when it is written out.
> 
>     Pass 1: Checking inodes, blocks, and sizes
>     Inode 17825800, end of extent exceeds allowed value
>             (logical block 710, physical block 570459684, len 1019)
> 
> This results in loss of a whole index block of directory leaf blocks
> and maybe thousands or millions of files in lost+found.
> 
> Fix e2fsck_rehash_dir() to call ext2fs_punch() to free the blocks
> at the end of the directory instead of trying to handle this itself
> while writing out the directory.  That properly handles all of the
> cases of updating the extent tree as well as accounting for blocks
> that are released (both leaf blocks and index blocks).
> 
> Add a test case for compacting the directory to be smaller than the
> index block that originally caused the corruption.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

Thanks, applied.

						- Ted
