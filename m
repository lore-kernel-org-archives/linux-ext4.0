From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Check for return value from sb_set_blocksize
Date: Wed,  9 Jan 2008 22:37:49 +0530
Message-ID: <1199898469-10369-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:43395 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751641AbYAIRIC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 12:08:02 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m09H7rcp011271
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 22:37:53 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m09H7ru6917592
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 22:37:53 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m09H7stQ006594
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 17:07:55 GMT
In-Reply-To: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

sb_set_blocksize validates whether the specfied block size can be used by
the file system. Make sure we fail mounting the file system if the
blocksize specfied cannot be used.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 10330eb..ab62d7f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1793,7 +1793,6 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	unsigned long def_mount_opts;
 	struct inode *root;
 	int blocksize;
-	int hblock;
 	int db_count;
 	int i;
 	int needs_recovery;
@@ -1958,20 +1957,17 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	hblock = bdev_hardsect_size(sb->s_bdev);
 	if (sb->s_blocksize != blocksize) {
-		/*
-		 * Make sure the blocksize for the filesystem is larger
-		 * than the hardware sectorsize for the machine.
-		 */
-		if (blocksize < hblock) {
-			printk(KERN_ERR "EXT4-fs: blocksize %d too small for "
-			       "device blocksize %d.\n", blocksize, hblock);
+
+		brelse (bh);
+
+		/* Validate the filesystem blocksize */
+		if (!sb_set_blocksize(sb, blocksize)) {
+			printk(KERN_ERR "EXT4-fs: bad block size %d.\n",
+					blocksize);
 			goto failed_mount;
 		}
 
-		brelse (bh);
-		sb_set_blocksize(sb, blocksize);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
 		bh = sb_bread(sb, logical_sb_block);
-- 
1.5.4.rc2.60.gb2e62-dirty
