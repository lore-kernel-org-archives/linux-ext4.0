From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ext4: Support large files
Date: Fri, 12 Oct 2007 10:06:55 +0530
Message-ID: <1192163815-8721-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1192163815-8721-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:38800 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbXJLEhe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Oct 2007 00:37:34 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9C4bRRh007672
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 14:37:27 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9C4f3a1186190
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 14:41:04 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9C4YaCS002701
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 14:34:37 +1000
In-Reply-To: <1192163815-8721-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch converts ext4_inode i_blocks to represent total
blocks occupied by the inode in file system block size.
Earlier the variable used to represent this in 512 byte
block size. This actually limited the total size of the file.

The feature is enabled transparently when we write an inode
whose i_blocks cannot be represnted as 512 byte units in a
48 bit variable. We add a RO_COMPAT feature to the super
block to indicate that some of the inode have i_blocks
represented as file system block size units. Super block
with this feature set cannot be mounted read write on a kernel
with CONFIG_LSF disabled.

Super block flag EXT4_FEATURE_RO_COMPAT_HUGE_FILE
inode flag  EXT4_HUGE_FILE_FL

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c         |   41 +++++++++++++++++++++++++++++++++++------
 fs/ext4/super.c         |    9 ++++++---
 include/linux/ext4_fs.h |    3 ++-
 3 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 41af2d3..7fa1868 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2710,14 +2710,20 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 					struct ext4_inode_info *ei)
 {
 	blkcnt_t i_blocks ;
-	struct super_block *sb = ei->vfs_inode.i_sb;
+	struct inode *inode = &(ei->vfs_inode);
+	struct super_block *sb = inode->i_sb;
 
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
 		/* we are using combined 48 bit field */
 		i_blocks = ((u64)le16_to_cpu(raw_inode->i_blocks_high)) << 32 |
 						le32_to_cpu(raw_inode->i_blocks_lo);
-		return i_blocks;
+		if (ei->i_flags & EXT4_HUGE_FILE_FL) {
+			/* i_blocks represent file system block size */
+			return i_blocks  << (inode->i_blkbits - 9);
+		} else {
+			return i_blocks;
+		}
 	} else {
 		return le32_to_cpu(raw_inode->i_blocks_lo);
 	}
@@ -2882,6 +2888,7 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		 */
 		raw_inode->i_blocks_lo   = cpu_to_le32((u32)i_blocks);
 		raw_inode->i_blocks_high = 0;
+		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
 	} else if (i_blocks <= 0xffffffffffffULL) {
 		/*
 		 * i_blocks can be represented in a 48 bit variable
@@ -2905,10 +2912,32 @@ static int ext4_inode_blocks_set(handle_t *handle,
 		/* i_block is stored in the split  48 bit fields */
 		raw_inode->i_blocks_lo   = cpu_to_le32((u32)i_blocks);
 		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
-	}else {
-		ext4_error(sb, __FUNCTION__,
-				"Wrong inode i_blocks count  %llu\n",
-				(unsigned long long)inode->i_blocks);
+		ei->i_flags &= ~EXT4_HUGE_FILE_FL;
+	} else {
+		/*
+		 * i_blocks should be represented in a 48 bit variable
+		 * as multiple of  file system block size
+		 */
+		if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
+
+			err = ext4_journal_get_write_access(handle,
+					EXT4_SB(sb)->s_sbh);
+			if (err)
+				goto err_out;
+			ext4_update_dynamic_rev(sb);
+			EXT4_SET_RO_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
+			sb->s_dirt = 1;
+			handle->h_sync = 1;
+			err = ext4_journal_dirty_metadata(handle,
+					EXT4_SB(sb)->s_sbh);
+		}
+		ei->i_flags |= EXT4_HUGE_FILE_FL;
+		/* i_block is stored in file system block size */
+		i_blocks = i_blocks >> (inode->i_blkbits - 9);
+		raw_inode->i_blocks_lo   = cpu_to_le32((u32)i_blocks);
+		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
 	}
 err_out:
 	return err;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a7f3edf..ea3b2c3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1531,11 +1531,14 @@ static loff_t ext4_max_size(int bits)
 		upper_limit >>= (bits - 9);
 
 	} else {
-		/* We use 48 bit ext4_inode i_blocks */
+		/*
+		 * We use 48 bit ext4_inode i_blocks
+		 * With EXT4_HUGE_FILE_FL set the i_blocks
+		 * represent total number of blocks in
+		 * file system block size
+		 */
 		upper_limit = (1LL << 48) - 1;
 
-		/* total blocks in file system block size */
-		upper_limit >>= (bits - 9);
 	}
 
 	/* indirect blocks */
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 7e1a8f5..d747b05 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -205,8 +205,9 @@ struct ext4_group_desc
 #define EXT4_NOTAIL_FL			0x00008000 /* file tail should not be merged */
 #define EXT4_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
 #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
-#define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
+#define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
+#define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
-- 
1.5.3.4.206.g58ba4-dirty
