From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] ext4: Inode flags diet
Date: Thu,  6 Oct 2016 13:04:34 +0200
Message-ID: <1475751874-32114-4-git-send-email-jack@suse.cz>
References: <1475751874-32114-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53653 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752880AbcJFLEi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Oct 2016 07:04:38 -0400
In-Reply-To: <1475751874-32114-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove 6 inode flags that were apparently never used and only take up
space in inode flags field which is already full.

There are also other inode flags of doubtful use (not used by current
Linux kernel - IMAGIC, NOTAIL, EA_INODE) but let's leave them there for
now since I'm not quite sure about their status.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h | 34 +++++-----------------------------
 1 file changed, 5 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2874957e3ee2..c986ab0c9a1f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -363,19 +363,11 @@ struct flex_groups {
 /*
  * Inode flags
  */
-#define	EXT4_SECRM_FL			0x00000001 /* Secure deletion */
-#define	EXT4_UNRM_FL			0x00000002 /* Undelete */
-#define	EXT4_COMPR_FL			0x00000004 /* Compress file */
 #define EXT4_SYNC_FL			0x00000008 /* Synchronous updates */
 #define EXT4_IMMUTABLE_FL		0x00000010 /* Immutable file */
 #define EXT4_APPEND_FL			0x00000020 /* writes to file may only append */
 #define EXT4_NODUMP_FL			0x00000040 /* do not dump file */
 #define EXT4_NOATIME_FL			0x00000080 /* do not update atime */
-/* Reserved for compression usage... */
-#define EXT4_DIRTY_FL			0x00000100
-#define EXT4_COMPRBLK_FL		0x00000200 /* One or more compressed clusters */
-#define EXT4_NOCOMPR_FL			0x00000400 /* Don't compress */
-	/* nb: was previously EXT2_ECOMPR_FL */
 #define EXT4_ENCRYPT_FL			0x00000800 /* encrypted file */
 /* End compression flags --- maybe not all used */
 #define EXT4_INDEX_FL			0x00001000 /* hash-indexed directory */
@@ -392,8 +384,8 @@ struct flex_groups {
 #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
+#define EXT4_FL_USER_VISIBLE		0x304BD8F8 /* User visible flags */
+#define EXT4_FL_USER_MODIFIABLE		0x204BC0F8 /* User modifiable flags */
 
 /* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
 #define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
@@ -404,11 +396,9 @@ struct flex_groups {
 					 EXT4_PROJINHERIT_FL)
 
 /* Flags that should be inherited by new inodes from their parent. */
-#define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
-			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
-			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
-			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
-			   EXT4_PROJINHERIT_FL)
+#define EXT4_FL_INHERITED (EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
+			   EXT4_JOURNAL_DATA_FL | EXT4_NOTAIL_FL | \
+			   EXT4_DIRSYNC_FL | EXT4_PROJINHERIT_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
 #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
@@ -431,20 +421,12 @@ static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
  * Inode flags used for atomic set/get
  */
 enum {
-	EXT4_INODE_SECRM	= 0,	/* Secure deletion */
-	EXT4_INODE_UNRM		= 1,	/* Undelete */
-	EXT4_INODE_COMPR	= 2,	/* Compress file */
 	EXT4_INODE_SYNC		= 3,	/* Synchronous updates */
 	EXT4_INODE_IMMUTABLE	= 4,	/* Immutable file */
 	EXT4_INODE_APPEND	= 5,	/* writes to file may only append */
 	EXT4_INODE_NODUMP	= 6,	/* do not dump file */
 	EXT4_INODE_NOATIME	= 7,	/* do not update atime */
-/* Reserved for compression usage... */
-	EXT4_INODE_DIRTY	= 8,
-	EXT4_INODE_COMPRBLK	= 9,	/* One or more compressed clusters */
-	EXT4_INODE_NOCOMPR	= 10,	/* Don't compress */
 	EXT4_INODE_ENCRYPT	= 11,	/* Encrypted file */
-/* End compression flags --- maybe not all used */
 	EXT4_INODE_INDEX	= 12,	/* hash-indexed directory */
 	EXT4_INODE_IMAGIC	= 13,	/* AFS directory */
 	EXT4_INODE_JOURNAL_DATA	= 14,	/* file data should be journaled */
@@ -478,17 +460,11 @@ enum {
 
 static inline void ext4_check_flag_values(void)
 {
-	CHECK_FLAG_VALUE(SECRM);
-	CHECK_FLAG_VALUE(UNRM);
-	CHECK_FLAG_VALUE(COMPR);
 	CHECK_FLAG_VALUE(SYNC);
 	CHECK_FLAG_VALUE(IMMUTABLE);
 	CHECK_FLAG_VALUE(APPEND);
 	CHECK_FLAG_VALUE(NODUMP);
 	CHECK_FLAG_VALUE(NOATIME);
-	CHECK_FLAG_VALUE(DIRTY);
-	CHECK_FLAG_VALUE(COMPRBLK);
-	CHECK_FLAG_VALUE(NOCOMPR);
 	CHECK_FLAG_VALUE(ENCRYPT);
 	CHECK_FLAG_VALUE(INDEX);
 	CHECK_FLAG_VALUE(IMAGIC);
-- 
2.6.6

