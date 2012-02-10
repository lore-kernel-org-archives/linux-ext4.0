From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH] libext2fs: quiet spurious group checksum errors
Date: Fri, 10 Feb 2012 11:42:47 +0900
Message-ID: <4F348427.5050109@rs.jp.nec.com>
References: <1328048130-40981-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41666 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab2BJCnL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Feb 2012 21:43:11 -0500
In-Reply-To: <1328048130-40981-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Thank you for the patch.
I confirmed that the bug which I reported originally was fixed with it.

Tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Regards,
Akira Fujita

(2012/02/01 7:15), Andreas Dilger wrote:
> If we have to read the backup group descriptor checksums, the UNINIT
> flags are cleared to ensure that all of the inodes in the filesystem
> are scanned.  However, the code that reset the UNINIT flags did not
> reset the group checksum, and this produced many spurious error
> messages in e2fsck.
> 
> Group descriptor 0 checksum is invalid.  FIXED.
> Group descriptor 1 checksum is invalid.  FIXED.
> :
> :
> 
> Recompute checksums after modifying group descriptors to avoid these
> error messages.  Remove expected error messages in f_illitable_flexbg.
> 
> Signed-off-by: Andreas Dilger<adilger@whamcloud.com>
> ---
> lib/ext2fs/openfs.c               |    3 +++
> tests/f_illitable_flexbg/expect.1 |    8 ++------
> 2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 40a52c5..b1b68ad 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -378,6 +378,9 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
> 			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
> 			ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
> 			ext2fs_bg_itable_unused_set(fs, group, 0);
> +			/* The checksum will be reset later, but fix it here
> +			 * anyway to avoid printing a lot of spurious errors. */
> +			ext2fs_group_desc_csum_set(fs, group);
> 		}
> 		ext2fs_mark_super_dirty(fs);
> 	}
> diff --git a/tests/f_illitable_flexbg/expect.1 b/tests/f_illitable_flexbg/expect.1
> index 2d8bd0c..af30bd4 100644
> --- a/tests/f_illitable_flexbg/expect.1
> +++ b/tests/f_illitable_flexbg/expect.1
> @@ -1,17 +1,13 @@
> ../e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
> -One or more block group descriptor checksums are invalid.  Fix? yes
> -
> -Group descriptor 0 checksum is invalid.  FIXED.
> Inode table for group 1 is not in group.  (block 0)
> WARNING: SEVERE DATA LOSS POSSIBLE.
> Relocate? yes
> 
> -Group descriptor 1 checksum is invalid.  FIXED.
> -Group descriptor 2 checksum is invalid.  FIXED.
> -Group descriptor 3 checksum is invalid.  FIXED.
> Pass 1: Checking inodes, blocks, and sizes
> Relocating group 1's inode table to 142...
> Restarting e2fsck from the beginning...
> +One or more block group descriptor checksums are invalid.  Fix? yes
> +
> Group descriptor 1 checksum is invalid.  FIXED.
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure

-- 
Akira Fujita <a-fujita@rs.jp.nec.com>

The First Fundamental Software Development Group,
Platform Division, NEC Software Tohoku, Ltd.

