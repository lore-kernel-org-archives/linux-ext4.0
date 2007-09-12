From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Sparse endian issues with patches.
Date: Wed, 12 Sep 2007 22:18:39 +0530
Message-ID: <46E81867.1000606@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: valerie.clement@bull.net, Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:48079 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764505AbXILQu3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2007 12:50:29 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8CGoRwD022461
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 02:50:27 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8CGnBUA4304962
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 02:49:11 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8CGms9O021834
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 02:48:55 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Attaching below patch that fix the sparse warning for ext4.

NOTE: yet to test the changes.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 390b36d..a3ffa15 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2567,7 +2567,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
-	allocated = newex.ee_len;
+	allocated = le16_to_cpu(newex.ee_len);
 outnew:
 	__set_bit(BH_New, &bh_result->b_state);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 89837eb..2136f43 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3298,12 +3298,12 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 						      iloc, handle);
 			if (ret) {
 				EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
-				if (mnt_count != sbi->s_es->s_mnt_count) {
+				if (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count)) {
 					ext4_warning(inode->i_sb, __FUNCTION__,
 					"Unable to expand inode %lu. Delete"
 					" some EAs or run e2fsck.",
 					inode->i_ino);
-					mnt_count = sbi->s_es->s_mnt_count;
+					mnt_count = le16_to_cpu(sbi->s_es->s_mnt_count);
 				}
 			}
 		}
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7b1c640..4ece35c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2747,7 +2747,7 @@ static int ext4_mb_read_prealloc_table(char *page, char **start,
 }
 
 static int ext4_mb_write_prealloc_table(struct file *file,
-			const char *buf, unsigned long cnt, void *data)
+			const char __user *buf, unsigned long cnt, void *data)
 {
 	struct ext4_sb_info *sbi = data;
 	unsigned long value;
@@ -2809,7 +2809,7 @@ static int ext4_mb_read_##name(char *page, char **start,	\
 
 #define MB_PROC_VALUE_WRITE(name)				\
 static int ext4_mb_write_##name(struct file *file,		\
-		const char *buf, unsigned long cnt, void *data)	\
+		const char __user *buf, unsigned long cnt, void *data)	\
 {								\
 	struct ext4_sb_info *sbi = data;			\
 	char str[32];						\
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 81e0e8d..17afd97 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -156,7 +156,7 @@ struct ext4_group_desc
 	__le16	bg_free_blocks_count;	/* Free blocks count */
 	__le16	bg_free_inodes_count;	/* Free inodes count */
 	__le16	bg_used_dirs_count;	/* Directories count */
-	__u16	bg_flags;
+	__le16	bg_flags;
 	__u32	bg_reserved[2];
 	__le16  bg_itable_unused;       /* Unused inodes count */
 	__le16  bg_checksum;            /* crc16(sb_uuid+group+desc) */
@@ -332,7 +332,7 @@ struct ext4_inode {
 	__le32	i_flags;	/* File flags */
 	union {
 		struct {
-			__u32  l_i_version;
+			__le32  l_i_version;
 		} linux1;
 		struct {
 			__u32  h_i_translator;
@@ -636,13 +636,13 @@ struct ext4_super_block {
 /*150*/	__le32	s_blocks_count_hi;	/* Blocks count */
 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
-	__u16	s_min_extra_isize;	/* All inodes have at least # bytes */
-	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
-	__u32	s_flags;		/* Miscellaneous flags */
-	__u16   s_raid_stride;		/* RAID stride */
-	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
-	__u64   s_mmp_block;            /* Block for multi-mount protection */
-	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
+	__le16	s_min_extra_isize;	/* All inodes have at least # bytes */
+	__le16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
+	__le32	s_flags;		/* Miscellaneous flags */
+	__le16  s_raid_stride;		/* RAID stride */
+	__le16  s_mmp_interval;         /* # seconds to wait in MMP checking */
+	__le64  s_mmp_block;            /* Block for multi-mount protection */
+	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u32   s_reserved[163];        /* Padding to the end of the block */
 };
 
