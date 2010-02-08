From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 04/11] quota: generalize quota transfer interface
Date: Mon, 08 Feb 2010 16:28:06 +0300
Message-ID: <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:33220 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab0BHO22 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 09:28:28 -0500
Received: from localhost.localdomain ([unknown] [195.214.232.10])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KXI0097MZ0I9F10@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 16:34:01 +0300 (MSK)
In-reply-to: <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current quota transfer interface support only uid/gid.
This patch extend interface in order to support various quotas types
The goal is accomplished without changes in most frequently used
vfs_dq_transfer() func.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c         |   32 ++++++++++++++++++++------------
 include/linux/quota.h    |    2 +-
 include/linux/quotaops.h |    2 +-
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index dea86ab..a34e57c 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1659,15 +1659,13 @@ EXPORT_SYMBOL(dquot_free_inode);
  * This operation can block, but only after everything is updated
  * A transaction must be started when entering this function.
  */
-int dquot_transfer(struct inode *inode, struct iattr *iattr)
+int dquot_transfer(struct inode *inode, qid_t *chid, unsigned long mask)
 {
 	qsize_t space, cur_space;
 	qsize_t rsv_space = 0;
 	struct dquot *transfer_from[MAXQUOTAS];
 	struct dquot *transfer_to[MAXQUOTAS];
 	int cnt, ret = QUOTA_OK;
-	int chuid = iattr->ia_valid & ATTR_UID && inode->i_uid != iattr->ia_uid,
-	    chgid = iattr->ia_valid & ATTR_GID && inode->i_gid != iattr->ia_gid;
 	char warntype_to[MAXQUOTAS];
 	char warntype_from_inodes[MAXQUOTAS], warntype_from_space[MAXQUOTAS];
 
@@ -1681,13 +1679,10 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 		transfer_to[cnt] = NULL;
 		warntype_to[cnt] = QUOTA_NL_NOWARN;
 	}
-	if (chuid)
-		transfer_to[USRQUOTA] = dqget(inode->i_sb, iattr->ia_uid,
-					      USRQUOTA);
-	if (chgid)
-		transfer_to[GRPQUOTA] = dqget(inode->i_sb, iattr->ia_gid,
-					      GRPQUOTA);
-
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		if (mask & (1 << cnt))
+			transfer_to[cnt] = dqget(inode->i_sb, chid[cnt], cnt);
+	}
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
 	if (IS_NOQUOTA(inode)) {	/* File without quota accounting? */
@@ -1764,12 +1759,25 @@ over_quota:
 }
 EXPORT_SYMBOL(dquot_transfer);
 
-/* Wrapper for transferring ownership of an inode */
+/* Wrapper for transferring ownership of an inode for uid/gid only
+ * Called from FSXXX_setattr()
+ */
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
 {
+	qid_t chid[MAXQUOTAS];
+	unsigned long mask = 0;
+
+	if (iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid) {
+		mask |= 1 << USRQUOTA;
+		chid[USRQUOTA] = iattr->ia_uid;
+	}
+	if (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid) {
+		mask |= 1 << GRPQUOTA;
+		chid[GRPQUOTA] = iattr->ia_gid;
+	}
 	if (sb_any_quota_active(inode->i_sb) && !IS_NOQUOTA(inode)) {
 		vfs_dq_init(inode);
-		if (inode->i_sb->dq_op->transfer(inode, iattr) == NO_QUOTA)
+		if (inode->i_sb->dq_op->transfer(inode, chid, mask) == NO_QUOTA)
 			return 1;
 	}
 	return 0;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 1f1a3a1..74738e9 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -301,7 +301,7 @@ struct dquot_operations {
 	int (*alloc_inode) (const struct inode *, qsize_t);
 	int (*free_space) (struct inode *, qsize_t);
 	int (*free_inode) (const struct inode *, qsize_t);
-	int (*transfer) (struct inode *, struct iattr *);
+	int (*transfer) (struct inode *, qid_t *, unsigned long);
 	int (*write_dquot) (struct dquot *);		/* Ordinary dquot write */
 	struct dquot *(*alloc_dquot)(struct super_block *, int);	/* Allocate memory for new dquot */
 	void (*destroy_dquot)(struct dquot *);		/* Free memory for dquot */
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 70de499..b803fd7 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -47,7 +47,7 @@ qsize_t dquot_get_reserved_space(struct inode *inode);
 int dquot_free_space(struct inode *inode, qsize_t number);
 int dquot_free_inode(const struct inode *inode, qsize_t number);
 
-int dquot_transfer(struct inode *inode, struct iattr *iattr);
+int dquot_transfer(struct inode *inode, qid_t *chid, unsigned long mask);
 int dquot_commit(struct dquot *dquot);
 int dquot_acquire(struct dquot *dquot);
 int dquot_release(struct dquot *dquot);
-- 
1.6.3.3

