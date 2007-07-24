From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch 4/13] Allow regular files to be preallocated on-disk.
Date: Tue, 24 Jul 2007 16:34:48 +0530
Message-ID: <1185275088.3789.69.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40556 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765748AbXGXLED (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 07:04:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Allow regular files to be preallocated on-disk up to the next multiple
of the system PAGE_SIZE without complaining about extra blocks.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Girish Shilamkar <girish@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: e2fsprogs-1.40.1/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40.1/e2fsck/pass1.c
@@ -1591,9 +1591,14 @@ static void check_blocks(e2fsck_t ctx, s
 				bad_size = 2;
 		}
 	} else {
+		e2_blkcnt_t blkpg = getpagesize() / fs->blocksize;
+
 		size = EXT2_I_SIZE(inode);
 		if ((pb.last_block >= 0) &&
-		    (size < (__u64) pb.last_block * fs->blocksize))
+		    /* allow allocated blocks to end of PAGE_SIZE */
+		    (size < (__u64)pb.last_block * fs->blocksize) &&
+		    (pb.last_block / blkpg * blkpg != pb.last_block ||
+		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize))
 			bad_size = 3;
 		else if (size > ext2_max_sizes[fs->super->s_log_block_size])
 			bad_size = 4;
