From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 05/11] quota: introduce  get_id callback
Date: Mon, 08 Feb 2010 16:28:07 +0300
Message-ID: <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33218 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0BHO22 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:28 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:01 +0300 (MSK)
In-reply-to: <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During some quota oparations we have to determine quota_id for given inode
according to quota_type. But only USRQUOTA/GRPQUOTA id are intermediately
accessible from generic vfs-inode. This patch introduce new per_sb quota
operation for this purpose.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/super.c          |    1 +
 fs/ext4/super.c          |    1 +
 fs/ocfs2/quota_global.c  |    1 +
 fs/quota/dquot.c         |   39 +++++++++++++++++++++++++++++----------
 fs/reiserfs/super.c      |    1 +
 include/linux/quota.h    |    1 +
 include/linux/quotaops.h |    1 +
 7 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index afa2b56..4ce86a6 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -758,6 +758,7 @@ static const struct dquot_operations ext3_quota_operations = {
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
 	.transfer	= dquot_transfer,
+	.get_id		= dquot_get_id,
 	.write_dquot	= ext3_write_dquot,
 	.acquire_dquot	= ext3_acquire_dquot,
 	.release_dquot	= ext3_release_dquot,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4fd8cfb..68a5915 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1029,6 +1029,7 @@ static const struct dquot_operations ext4_quota_operations = {
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
 	.transfer	= dquot_transfer,
+	.get_id		= dquot_get_id,
 	.write_dquot	= ext4_write_dquot,
 	.acquire_dquot	= ext4_acquire_dquot,
 	.release_dquot	= ext4_release_dquot,
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index b437dc0..1ede78f 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -858,6 +858,7 @@ const struct dquot_operations ocfs2_quota_operations = {
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
 	.transfer	= dquot_transfer,
+	.get_id		= dquot_get_id,
 	.write_dquot	= ocfs2_write_dquot,
 	.acquire_dquot	= ocfs2_acquire_dquot,
 	.release_dquot	= ocfs2_release_dquot,
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a34e57c..033c271 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1242,6 +1242,26 @@ static int info_bdq_free(struct dquot *dquot, qsize_t space)
 		return QUOTA_NL_BHARDBELOW;
 	return QUOTA_NL_NOWARN;
 }
+
+qid_t dquot_get_id(struct inode *inode, int type, qid_t *new)
+{
+	switch (type) {
+	case USRQUOTA:
+		if (new)
+			return new[USRQUOTA];
+		else
+			return inode->i_uid;
+	case GRPQUOTA:
+		if (new)
+			return new[GRPQUOTA];
+		else
+			return inode->i_gid;
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL(dquot_get_id);
+
 /*
  *	Initialize quota pointers in inode
  *	We do things in a bit complicated way but by that we avoid calling
@@ -1263,14 +1283,9 @@ int dquot_initialize(struct inode *inode, int type)
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
-		switch (cnt) {
-		case USRQUOTA:
-			id = inode->i_uid;
-			break;
-		case GRPQUOTA:
-			id = inode->i_gid;
-			break;
-		}
+		if (!sb_has_quota_active(sb, cnt))
+			continue;
+		id = inode->i_sb->dq_op->get_id(inode, cnt, NULL);
 		got[cnt] = dqget(sb, id, cnt);
 	}
 
@@ -1668,6 +1683,7 @@ int dquot_transfer(struct inode *inode, qid_t *chid, unsigned long mask)
 	int cnt, ret = QUOTA_OK;
 	char warntype_to[MAXQUOTAS];
 	char warntype_from_inodes[MAXQUOTAS], warntype_from_space[MAXQUOTAS];
+	qid_t id;
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
@@ -1680,8 +1696,10 @@ int dquot_transfer(struct inode *inode, qid_t *chid, unsigned long mask)
 		warntype_to[cnt] = QUOTA_NL_NOWARN;
 	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (mask & (1 << cnt))
-			transfer_to[cnt] = dqget(inode->i_sb, chid[cnt], cnt);
+		if (mask & (1 << cnt)) {
+			id = inode->i_sb->dq_op->get_id(inode, cnt, chid);
+			transfer_to[cnt] = dqget(inode->i_sb, id, cnt);
+		}
 	}
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
@@ -1810,6 +1828,7 @@ const struct dquot_operations dquot_operations = {
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
 	.transfer	= dquot_transfer,
+	.get_id		= dquot_get_id,
 	.write_dquot	= dquot_commit,
 	.acquire_dquot	= dquot_acquire,
 	.release_dquot	= dquot_release,
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index b4a7dd0..897f2bc 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -623,6 +623,7 @@ static const struct dquot_operations reiserfs_quota_operations = {
 	.free_space = dquot_free_space,
 	.free_inode = dquot_free_inode,
 	.transfer = dquot_transfer,
+	.get_id		= dquot_get_id,
 	.write_dquot = reiserfs_write_dquot,
 	.acquire_dquot = reiserfs_acquire_dquot,
 	.release_dquot = reiserfs_release_dquot,
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 74738e9..abf6a5a 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -303,6 +303,7 @@ struct dquot_operations {
 	int (*free_inode) (const struct inode *, qsize_t);
 	int (*transfer) (struct inode *, qid_t *, unsigned long);
 	int (*write_dquot) (struct dquot *);		/* Ordinary dquot write */
+	qid_t (*get_id)(struct inode *, int, qid_t *new); /* Quota id for given type */
 	struct dquot *(*alloc_dquot)(struct super_block *, int);	/* Allocate memory for new dquot */
 	void (*destroy_dquot)(struct dquot *);		/* Free memory for dquot */
 	int (*acquire_dquot) (struct dquot *);		/* Quota is going to be created on disk */
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index b803fd7..878f2a0 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -26,6 +26,7 @@ static inline void writeout_quota_sb(struct super_block *sb, int type)
 		sb->s_qcop->quota_sync(sb, type);
 }
 
+qid_t dquot_get_id(struct inode *inode, int type, qid_t *new);
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
-- 
1.6.3.3

