From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/11] ocfs2: Push out dropping of dentry lock to ocfs2_wq
Date: Fri, 16 Jan 2009 19:08:11 +0100
Message-ID: <1232129299-22018-4-git-send-email-jack@suse.cz>
References: <yes>
 <1232129299-22018-1-git-send-email-jack@suse.cz>
 <1232129299-22018-2-git-send-email-jack@suse.cz>
 <1232129299-22018-3-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47972 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761525AbZAPSIW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jan 2009 13:08:22 -0500
In-Reply-To: <1232129299-22018-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dropping of last reference to dentry lock is a complicated operation involving
dropping of reference to inode. This can get complicated and quota code in
particular needs to obtain some quota locks which leads to potential deadlock.
Thus we defer dropping of inode reference to ocfs2_wq.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/ocfs2/dcache.c |   42 +++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/dcache.h |    9 ++++++++-
 fs/ocfs2/ocfs2.h  |    6 ++++++
 fs/ocfs2/super.c  |    3 +++
 4 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index b1cc7c3..e9d7c20 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -38,6 +38,7 @@
 #include "dlmglue.h"
 #include "file.h"
 #include "inode.h"
+#include "super.h"
 
 
 static int ocfs2_dentry_revalidate(struct dentry *dentry,
@@ -294,6 +295,34 @@ out_attach:
 	return ret;
 }
 
+static DEFINE_SPINLOCK(dentry_list_lock);
+
+/* We limit the number of dentry locks to drop in one go. We have
+ * this limit so that we don't starve other users of ocfs2_wq. */
+#define DL_INODE_DROP_COUNT 64
+
+/* Drop inode references from dentry locks */
+void ocfs2_drop_dl_inodes(struct work_struct *work)
+{
+	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
+					       dentry_lock_work);
+	struct ocfs2_dentry_lock *dl;
+	int drop_count = DL_INODE_DROP_COUNT;
+
+	spin_lock(&dentry_list_lock);
+	while (osb->dentry_lock_list && drop_count--) {
+		dl = osb->dentry_lock_list;
+		osb->dentry_lock_list = dl->dl_next;
+		spin_unlock(&dentry_list_lock);
+		iput(dl->dl_inode);
+		kfree(dl);
+		spin_lock(&dentry_list_lock);
+	}
+	if (osb->dentry_lock_list)
+		queue_work(ocfs2_wq, &osb->dentry_lock_work);
+	spin_unlock(&dentry_list_lock);
+}
+
 /*
  * ocfs2_dentry_iput() and friends.
  *
@@ -318,16 +347,23 @@ out_attach:
 static void ocfs2_drop_dentry_lock(struct ocfs2_super *osb,
 				   struct ocfs2_dentry_lock *dl)
 {
-	iput(dl->dl_inode);
 	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
 	ocfs2_lock_res_free(&dl->dl_lockres);
-	kfree(dl);
+
+	/* We leave dropping of inode reference to ocfs2_wq as that can
+	 * possibly lead to inode deletion which gets tricky */
+	spin_lock(&dentry_list_lock);
+	if (!osb->dentry_lock_list)
+		queue_work(ocfs2_wq, &osb->dentry_lock_work);
+	dl->dl_next = osb->dentry_lock_list;
+	osb->dentry_lock_list = dl;
+	spin_unlock(&dentry_list_lock);
 }
 
 void ocfs2_dentry_lock_put(struct ocfs2_super *osb,
 			   struct ocfs2_dentry_lock *dl)
 {
-	int unlock = 0;
+	int unlock;
 
 	BUG_ON(dl->dl_count == 0);
 
diff --git a/fs/ocfs2/dcache.h b/fs/ocfs2/dcache.h
index c091c34..d06e16c 100644
--- a/fs/ocfs2/dcache.h
+++ b/fs/ocfs2/dcache.h
@@ -29,8 +29,13 @@
 extern struct dentry_operations ocfs2_dentry_ops;
 
 struct ocfs2_dentry_lock {
+	/* Use count of dentry lock */
 	unsigned int		dl_count;
-	u64			dl_parent_blkno;
+	union {
+		/* Linked list of dentry locks to release */
+		struct ocfs2_dentry_lock *dl_next;
+		u64			dl_parent_blkno;
+	};
 
 	/*
 	 * The ocfs2_dentry_lock keeps an inode reference until
@@ -47,6 +52,8 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry, struct inode *inode,
 void ocfs2_dentry_lock_put(struct ocfs2_super *osb,
 			   struct ocfs2_dentry_lock *dl);
 
+void ocfs2_drop_dl_inodes(struct work_struct *work);
+
 struct dentry *ocfs2_find_local_alias(struct inode *inode, u64 parent_blkno,
 				      int skip_unhashed);
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index ad5c24a..0773841 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -210,6 +210,7 @@ struct ocfs2_journal;
 struct ocfs2_slot_info;
 struct ocfs2_recovery_map;
 struct ocfs2_quota_recovery;
+struct ocfs2_dentry_lock;
 struct ocfs2_super
 {
 	struct task_struct *commit_task;
@@ -325,6 +326,11 @@ struct ocfs2_super
 	struct list_head blocked_lock_list;
 	unsigned long blocked_lock_count;
 
+	/* List of dentry locks to release. Anyone can add locks to
+	 * the list, ocfs2_wq processes the list  */
+	struct ocfs2_dentry_lock *dentry_lock_list;
+	struct work_struct dentry_lock_work;
+
 	wait_queue_head_t		osb_mount_event;
 
 	/* Truncate log info */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 43ed113..b1cb38f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1887,6 +1887,9 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	INIT_WORK(&journal->j_recovery_work, ocfs2_complete_recovery);
 	journal->j_state = OCFS2_JOURNAL_FREE;
 
+	INIT_WORK(&osb->dentry_lock_work, ocfs2_drop_dl_inodes);
+	osb->dentry_lock_list = NULL;
+
 	/* get some pseudo constants for clustersize bits */
 	osb->s_clustersize_bits =
 		le32_to_cpu(di->id2.i_super.s_clustersize_bits);
-- 
1.6.0.2

