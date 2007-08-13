From: vignesh babu <vignesh.babu@wipro.com>
Subject: [kj] is_power_of_2 in ext
Date: Mon, 13 Aug 2007 18:27:02 +0530
Message-ID: <1187009822.7273.11.camel@merlin.linuxcoe.com>
Reply-To: vigneshbabu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Kernel Janitors List <kernel-janitors@lists.osdl.org>
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:58697 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030784AbXHMM5j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 08:57:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 639a32c..f932c60 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -30,6 +30,7 @@
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
+#include <linux/log2.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
@@ -804,7 +805,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
 		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
 		if ((sbi->s_inode_size < EXT2_GOOD_OLD_INODE_SIZE) ||
-		    (sbi->s_inode_size & (sbi->s_inode_size - 1)) ||
+		    !is_power_of_2(sbi->s_inode_size) ||
 		    (sbi->s_inode_size > blocksize)) {
 			printk ("EXT2-fs: unsupported inode size: %d\n",
 				sbi->s_inode_size);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4550b83..0bfb88e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1667,7 +1667,7 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT)) {
 		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
 		    sbi->s_desc_size > EXT4_MAX_DESC_SIZE ||
-		    sbi->s_desc_size & (sbi->s_desc_size - 1)) {
+		    !is_power_of_2(sbi->s_desc_size)) {
 			printk(KERN_ERR
 			       "EXT4-fs: unsupported descriptor size %lu\n",
 			       sbi->s_desc_size);

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"
