From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/6] e2fsck: Fix incorrect bbitmap checksum failure caused by
 integer overflow
Date: Wed, 28 Aug 2013 17:44:04 -0700
Message-ID: <20130829004404.3190.22438.stgit@blackbox.djwong.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26974 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3H2AoK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 20:44:10 -0400
In-Reply-To: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a filesystem with more than 2^32 blocks, the block group checksum test will
fail because "i" (the group number) is a 32-bit quantity that is used to
calculate the group's block bitmap block number.  Unfortunately, "i" is not
automatically promoted to 64-bit for this calculation and overflows.  When this
happens, e2fsck will incorrectly report bitmap checksum errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 51e4683..0fe7045 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -168,7 +168,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 
 		blk_itr = EXT2FS_B2C(ctx->fs,
 				     ctx->fs->super->s_first_data_block) +
-			  (i * (nbytes << 3));
+			  ((blk64_t)i * (nbytes << 3));
 		retval = ext2fs_get_block_bitmap_range2(ctx->fs->block_map,
 							blk_itr, nbytes << 3,
 							buf);

