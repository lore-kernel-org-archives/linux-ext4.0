From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: add missing swab for superblock, add checks
Date: Wed, 13 Dec 2017 22:41:21 -0500
Message-ID: <20171214034121.bmusgiypnn6iu77d@thunk.org>
References: <1513208834-37777-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42918 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751917AbdLNDlX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Dec 2017 22:41:23 -0500
Content-Disposition: inline
In-Reply-To: <1513208834-37777-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 13, 2017 at 04:47:14PM -0700, Andreas Dilger wrote:
> Several recently-added fields in struct ext2_super_block were
> not being swabbed in ext2fs_swap_super(), in particular:
> 
>    s_raid_stride, s_raid_stripe_width, s_{first,last}_error_*
>    s_lpf_ino, s_prj_quota_inum
> 
> Add swabbing for these missing fields.  Reorder the swabbing
> on other fields so that they are in struct order, and add
> comments for fields that do not need swabbing, so it is easier
> to see that all fields are being handled.
> 
> Since this seems to be a fairly common occurrence, add compile
> time checks to ext2fs_swap_super(), ext2fs_swap_inode_large(),
> and ext2fs_swap_group_desc2() via a new EXT2FS_BUILD_BUG_ON()
> macro to cause a compile warning if fields are used from these
> structs without a corresponding change to the swab functions.
> 
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
> Reported-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

						- Ted
