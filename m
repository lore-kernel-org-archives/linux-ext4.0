From: Theodore Ts'o <tytso@mit.edu>
Subject: [RFC/PATCH 1/3] ext4: rename s_resize_flags to s_ext4_flags
Date: Thu,  2 Feb 2017 17:59:22 -0500
Message-ID: <20170202225924.19301-2-tytso@mit.edu>
References: <20170202225924.19301-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54682 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751821AbdBBW7r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 2 Feb 2017 17:59:47 -0500
In-Reply-To: <20170202225924.19301-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are currently using one bit in s_resize_flags; in order to allow
more of the bits in that unsigned long for other purposes.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h   | 10 +++++++---
 fs/ext4/resize.c |  5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1cd077e02517..d5b7b2ccb302 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1399,8 +1399,7 @@ struct ext4_sb_info {
 	struct journal_s *s_journal;
 	struct list_head s_orphan;
 	struct mutex s_orphan_lock;
-	unsigned long s_resize_flags;		/* Flags indicating if there
-						   is a resizer */
+	unsigned long s_ext4_flags;		/* Ext4 superblock flabs */
 	unsigned long s_commit_interval;
 	u32 s_max_batch_time;
 	u32 s_min_batch_time;
@@ -1834,6 +1833,12 @@ static inline bool ext4_has_incompat_features(struct super_block *sb)
 }
 
 /*
+ * Superblock flags
+ */
+#define EXT4_FLAGS_RESIZING	0
+
+
+/*
  * Default values for user and/or group using reserved blocks
  */
 #define	EXT4_DEF_RESUID		0
@@ -3217,7 +3222,6 @@ static inline void ext4_inode_resume_unlocked_dio(struct inode *inode)
 					    EXT4_WQ_HASH_SZ])
 extern wait_queue_head_t ext4__ioend_wq[EXT4_WQ_HASH_SZ];
 
-#define EXT4_RESIZING	0
 extern int ext4_resize_begin(struct super_block *sb);
 extern void ext4_resize_end(struct super_block *sb);
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index cf681004b196..c3ed9021b781 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -45,7 +45,8 @@ int ext4_resize_begin(struct super_block *sb)
 		return -EPERM;
 	}
 
-	if (test_and_set_bit_lock(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags))
+	if (test_and_set_bit_lock(EXT4_FLAGS_RESIZING,
+				  &EXT4_SB(sb)->s_ext4_flags))
 		ret = -EBUSY;
 
 	return ret;
@@ -53,7 +54,7 @@ int ext4_resize_begin(struct super_block *sb)
 
 void ext4_resize_end(struct super_block *sb)
 {
-	clear_bit_unlock(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags);
+	clear_bit_unlock(EXT4_FLAGS_RESIZING, &EXT4_SB(sb)->s_ext4_flags);
 	smp_mb__after_atomic();
 }
 
-- 
2.11.0.rc0.7.gbe5a750
