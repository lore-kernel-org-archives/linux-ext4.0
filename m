From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fck: don't complain about i_size for known blocks past
 EOF
Date: Tue, 19 Jan 2010 15:21:50 -0600
Message-ID: <4B56226E.2090204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab0ASVVx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jan 2010 16:21:53 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0JLLrCx006062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2010 16:21:53 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o0JLLnIQ026911
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jan 2010 16:21:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the userspace side of Jiaying's EOFBLOCKS patch, I think.
With Aneesh's patches for .33, Jiaying's patch, and this one,
xfstests 013/fsstress (even with direct IO enabled) has held up
through many runs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 09ff1d0..0a2c6cb 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1947,7 +1947,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		    /* allow allocated blocks to end of PAGE_SIZE */
 		    (size < (__u64)pb.last_block * fs->blocksize) &&
 		    (pb.last_block / blkpg * blkpg != pb.last_block ||
-		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize))
+		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize) &&
+		    !(inode->i_flags & EXT4_EOFBLOCKS_FL))
 			bad_size = 3;
 		else if (!(extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) &&
 			 size > ext2_max_sizes[fs->super->s_log_block_size])
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 114b001..6e31c0d 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -276,10 +276,11 @@ struct ext2_dx_countlimit {
 #define EXT2_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
+#define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
-#define EXT2_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
-#define EXT2_FL_USER_MODIFIABLE		0x000080FF /* User modifiable flags */
+#define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
+#define EXT2_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
 
 /*
  * ioctl commands

