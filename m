From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: RE: [PATCH] mke2fs: fix flexbg check to allow small filesystems
Date: Thu, 31 Jul 2014 00:12:11 +0000
Message-ID: <28989C0C9F1C0A428470D967B5FCED372B71A0@BPXM22GP.gisp.nec.co.jp>
References: <1406709022-28957-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Dilger <andreas.dilger@intel.com>
To: Andreas Dilger <adilger@dilger.ca>, "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:36353 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbaGaAb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2014 20:31:27 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id s6V0VPix000440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2014 09:31:25 +0900 (JST)
In-Reply-To: <1406709022-28957-1-git-send-email-adilger@dilger.ca>
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

>From: linux-ext4-owner@vger.kernel.org [mailto:linux-ext4-owner@vger.kernel.org] On Behalf Of
>Andreas Dilger
>Sent: Wednesday, July 30, 2014 5:30 PM
>To: tytso@mit.edu
>Cc: linux-ext4@vger.kernel.org; Andreas Dilger; Andreas Dilger
>Subject: [PATCH] mke2fs: fix flexbg check to allow small filesystems
>
>Fix the flexbg check added in d988201ef9c so that it allows common
>small filesystem configurations to succeed instead of reporting
>a cryptic error message and failing due to a bad flex_bg layout:
>
>    mke2fs -O flex_bg -b 4096 -I 1024 -F /tmp/tt 79106
>    mke2fs 1.42.11 (09-Jul-2014)
>    /tmp/tt: Invalid argument passed to ext2 library while setting
>             up superblock
>
>This check in ext2fs_initialize() was added to prevent the metadata
>from being allocated beyond the end of the filesystem, but it is
>also causing a wide range of failures for small filesystems.
>
>Fix this by shrinking the flex_bg factor by half repeatedly until it
>would be expected to fit into the current filesystem size, rather
>than return an error as previously done.  Ideally it would only try
>a smaller flex_bg factor if the default value was being used, and had
>not been specified on the command line, but it isn't possible to see
>if this is the case in ext2fs_initialize() or not.
>
>Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>---
> lib/ext2fs/initialize.c |   13 +++++++------
> 1 files changed, 7 insertions(+), 6 deletions(-)
>
>diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
>index de358fd..d58a664 100644
>--- a/lib/ext2fs/initialize.c
>+++ b/lib/ext2fs/initialize.c
>@@ -91,7 +91,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
> 	unsigned int	rem;
> 	unsigned int	overhead = 0;
> 	unsigned int	ipg;
>-	unsigned int	flexbg_size;
>+	unsigned int	flexbg_factor;
> 	dgrp_t		i;
> 	blk64_t		free_blocks;
> 	blk64_t		flexbg_overhead;
>@@ -428,18 +428,19 @@ ipg_retry:
> 	 * This is a simple check, so that the backup superblock and
> 	 * other feature related blocks are not considered.
> 	 */
>-	flexbg_size = 1 << fs->super->s_log_groups_per_flex;
>+flex_retry:
>+	flexbg_factor = 1 << super->s_log_groups_per_flex;
> 	flexbg_overhead = super->s_first_data_block + 1 +
> 		fs->desc_blocks + super->s_reserved_gdt_blocks +
>-		(__u64)flexbg_size * (2 + fs->inode_blocks_per_group);
>+		(__u64)flexbg_factor * (2 + fs->inode_blocks_per_group);
>
> 	/*
> 	 * Disallow creating ext4 which breaks flex_bg metadata layout
> 	 * obviously.
> 	 */

This comment is unneeded any more,
But patch looks good to me, thanks.

Reviewed-by: Akira Fujita <a-fujita@rs.jp.nec.co.jp>


>-	if (flexbg_overhead > ext2fs_blocks_count(fs->super)) {
>-		retval = EXT2_ET_INVALID_ARGUMENT;
>-		goto cleanup;
>+	if (flexbg_overhead > ext2fs_blocks_count(super)) {
>+		super->s_log_groups_per_flex -= 1;
>+		goto flex_retry;
> 	}
>
> 	/*
>--
>1.7.3.4
>

