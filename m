From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: add lockdep annotations for i_data_sem
Date: Fri,  1 Apr 2016 01:32:56 -0400
Message-ID: <1459488776-22373-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

With the internal Quota feature, mke2fs creates empty quota inodes and
quota usage tracking is enabled as soon as the file system is mounted.
Since quotacheck is no longer preallocating all of the blocks in the
quota inode that are likely needed to be written to, we are now seeing
a lockdep false positive caused by needing to allocate a quota block
from inside ext4_map_blocks(), while holding i_data_sem for a data
inode.  This results in this complaint:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&ei->i_data_sem);
                                lock(&s->s_dquot.dqio_mutex);
                                lock(&ei->i_data_sem);
   lock(&s->s_dquot.dqio_mutex);

Google-Bug-Id: 27907753

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/ext4.h        | 23 +++++++++++++++++++++++
 fs/ext4/move_extent.c |  4 ++--
 fs/ext4/super.c       |  2 ++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7e4e3e9..6a857af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -912,6 +912,29 @@ do {									       \
 #include "extents_status.h"
 
 /*
+ * Lock subclasses for i_data_sem in the ext4_inode_info structure.
+ *
+ * These are needed to avoid lockdep false positives when we need to
+ * allocate blocks to the quota inode during ext4_map_blocks(), while
+ * holding i_data_sem for a normal (non-quota) inode.  Since we don't
+ * do quota tracking for the quota inode, this avoids deadlock (as
+ * well as infinite recursion, since it isn't turtles all the way
+ * down...)
+ *
+ *  I_DATA_SEM_NORMAL - Used for most inodes
+ *  I_DATA_SEM_OTHER  - Used by move_inode.c for the second normal inode
+ *			  where the second inode has larger inode number
+ *			  than the first
+ *  I_DATA_SEM_QUOTA  - Used for quota inodes only
+ */
+enum {
+	I_DATA_SEM_NORMAL = 0,
+	I_DATA_SEM_OTHER,
+	I_DATA_SEM_QUOTA,
+};
+
+
+/*
  * fourth extended file system inode data in memory
  */
 struct ext4_inode_info {
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 4098acc..45017af 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -60,10 +60,10 @@ ext4_double_down_write_data_sem(struct inode *first, struct inode *second)
 {
 	if (first < second) {
 		down_write(&EXT4_I(first)->i_data_sem);
-		down_write_nested(&EXT4_I(second)->i_data_sem, SINGLE_DEPTH_NESTING);
+		down_write_nested(&EXT4_I(second)->i_data_sem, I_DATA_SEM_OTHER);
 	} else {
 		down_write(&EXT4_I(second)->i_data_sem);
-		down_write_nested(&EXT4_I(first)->i_data_sem, SINGLE_DEPTH_NESTING);
+		down_write_nested(&EXT4_I(first)->i_data_sem, I_DATA_SEM_OTHER);
 
 	}
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5392975..63fe83d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5095,6 +5095,8 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 
 	/* Don't account quota for quota files to avoid recursion */
 	qf_inode->i_flags |= S_NOQUOTA;
+	lockdep_set_subclass(&EXT4_I(qf_inode)->i_data_sem, I_DATA_SEM_QUOTA);
+
 	err = dquot_enable(qf_inode, type, format_id, flags);
 	iput(qf_inode);
 
-- 
2.5.0
