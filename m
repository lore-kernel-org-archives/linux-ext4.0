From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix spare warnings
Date: Fri, 21 Sep 2007 10:55:06 +0530
Message-ID: <11903523092904-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44119 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXIUFZO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 01:25:14 -0400
In-Reply-To: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c         |    6 ++++--
 include/linux/ext4_fs.h |   16 ++++++++--------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a4848e0..307e240 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3177,12 +3177,14 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 						      iloc, handle);
 			if (ret) {
 				EXT4_I(inode)->i_state |= EXT4_STATE_NO_EXPAND;
-				if (mnt_count != sbi->s_es->s_mnt_count) {
+				if (mnt_count !=
+					le16_to_cpu(sbi->s_es->s_mnt_count)) {
 					ext4_warning(inode->i_sb, __FUNCTION__,
 					"Unable to expand inode %lu. Delete"
 					" some EAs or run e2fsck.",
 					inode->i_ino);
-					mnt_count = sbi->s_es->s_mnt_count;
+					mnt_count =
+					le16_to_cpu(sbi->s_es->s_mnt_count);
 				}
 			}
 		}
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index c7b9bb2..ab7edaa 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -129,7 +129,7 @@ struct ext4_group_desc
 	__le16	bg_free_blocks_count;	/* Free blocks count */
 	__le16	bg_free_inodes_count;	/* Free inodes count */
 	__le16	bg_used_dirs_count;	/* Directories count */
-	__u16	bg_flags;
+	__le16	bg_flags;
 	__u32	bg_reserved[3];
 	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
 	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
@@ -596,13 +596,13 @@ struct ext4_super_block {
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
 
-- 
1.5.3.1.91.gd3392-dirty
