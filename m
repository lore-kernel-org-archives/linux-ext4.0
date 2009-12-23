From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/5] quota: decouple fs reserved space from quota reservation
Date: Wed, 23 Dec 2009 18:27:53 +0100
Message-ID: <1261589276-1380-3-git-send-email-jack@suse.cz>
References: <1261589276-1380-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58473 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbZLWR2G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 12:28:06 -0500
In-Reply-To: <1261589276-1380-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

Currently inode_reservation is managed by fs itself and this
reservation is transfered on dquot_transfer(). This means what
inode_reservation must always be in sync with
dquot->dq_dqb.dqb_rsvspace. Otherwise dquot_transfer() will result
in incorrect quota(WARN_ON in dquot_claim_reserved_space() will be
triggered)
This is not easy because of complex locking order issues
for example http://bugzilla.kernel.org/show_bug.cgi?id=14739

The patch introduce quota reservation field for each fs-inode
(fs specific inode is used in order to prevent bloating generic
vfs inode). This reservation is managed by quota code internally
similar to i_blocks/i_bytes and may not be always in sync with
internal fs reservation.

Also perform some code rearrangement:
- Unify dquot_reserve_space() and dquot_reserve_space()
- Unify dquot_release_reserved_space() and dquot_free_space()
- Also this patch add missing warning update to release_rsv()
  dquot_release_reserved_space() must call flush_warnings() as
  dquot_free_space() does.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         |  215 ++++++++++++++++++++++++++--------------------
 include/linux/quota.h    |    5 +-
 include/linux/quotaops.h |   11 ++-
 3 files changed, 133 insertions(+), 98 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 38f7bd5..6b12046 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1388,6 +1388,69 @@ void vfs_dq_drop(struct inode *inode)
 EXPORT_SYMBOL(vfs_dq_drop);
 
 /*
+ * inode_reserved_space is managed internally by quota, and protected by
+ * i_lock similar to i_blocks+i_bytes.
+ */
+static qsize_t *inode_reserved_space(struct inode * inode)
+{
+	/* Filesystem must explicitly define it's own method in order to use
+	 * quota reservation interface */
+	BUG_ON(!inode->i_sb->dq_op->get_reserved_space);
+	return inode->i_sb->dq_op->get_reserved_space(inode);
+}
+
+void inode_add_rsv_space(struct inode *inode, qsize_t number)
+{
+	spin_lock(&inode->i_lock);
+	*inode_reserved_space(inode) += number;
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL(inode_add_rsv_space);
+
+void inode_claim_rsv_space(struct inode *inode, qsize_t number)
+{
+	spin_lock(&inode->i_lock);
+	*inode_reserved_space(inode) -= number;
+	__inode_add_bytes(inode, number);
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL(inode_claim_rsv_space);
+
+void inode_sub_rsv_space(struct inode *inode, qsize_t number)
+{
+	spin_lock(&inode->i_lock);
+	*inode_reserved_space(inode) -= number;
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL(inode_sub_rsv_space);
+
+static qsize_t inode_get_rsv_space(struct inode *inode)
+{
+	qsize_t ret;
+	spin_lock(&inode->i_lock);
+	ret = *inode_reserved_space(inode);
+	spin_unlock(&inode->i_lock);
+	return ret;
+}
+
+static void inode_incr_space(struct inode *inode, qsize_t number,
+				int reserve)
+{
+	if (reserve)
+		inode_add_rsv_space(inode, number);
+	else
+		inode_add_bytes(inode, number);
+}
+
+static void inode_decr_space(struct inode *inode, qsize_t number, int reserve)
+{
+	if (reserve)
+		inode_sub_rsv_space(inode, number);
+	else
+		inode_sub_bytes(inode, number);
+}
+
+/*
  * Following four functions update i_blocks+i_bytes fields and
  * quota information (together with appropriate checks)
  * NOTE: We absolutely rely on the fact that caller dirties
@@ -1405,6 +1468,21 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
 	int cnt, ret = QUOTA_OK;
 	char warntype[MAXQUOTAS];
 
+	/*
+	 * First test before acquiring mutex - solves deadlocks when we
+	 * re-enter the quota code and are already holding the mutex
+	 */
+	if (IS_NOQUOTA(inode)) {
+		inode_incr_space(inode, number, reserve);
+		goto out;
+	}
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode)) {
+		inode_incr_space(inode, number, reserve);
+		goto out_unlock;
+	}
+
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warntype[cnt] = QUOTA_NL_NOWARN;
 
@@ -1415,7 +1493,8 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
 		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt)
 		    == NO_QUOTA) {
 			ret = NO_QUOTA;
-			goto out_unlock;
+			spin_unlock(&dq_data_lock);
+			goto out_flush_warn;
 		}
 	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -1426,64 +1505,32 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
 		else
 			dquot_incr_space(inode->i_dquot[cnt], number);
 	}
-	if (!reserve)
-		inode_add_bytes(inode, number);
-out_unlock:
+	inode_incr_space(inode, number, reserve);
 	spin_unlock(&dq_data_lock);
-	flush_warnings(inode->i_dquot, warntype);
-	return ret;
-}
-
-int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
-{
-	int cnt, ret = QUOTA_OK;
-
-	/*
-	 * First test before acquiring mutex - solves deadlocks when we
-	 * re-enter the quota code and are already holding the mutex
-	 */
-	if (IS_NOQUOTA(inode)) {
-		inode_add_bytes(inode, number);
-		goto out;
-	}
-
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	if (IS_NOQUOTA(inode)) {
-		inode_add_bytes(inode, number);
-		goto out_unlock;
-	}
-
-	ret = __dquot_alloc_space(inode, number, warn, 0);
-	if (ret == NO_QUOTA)
-		goto out_unlock;
 
+	if (reserve)
+		goto out_flush_warn;
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		if (inode->i_dquot[cnt])
 			mark_dquot_dirty(inode->i_dquot[cnt]);
+out_flush_warn:
+	flush_warnings(inode->i_dquot, warntype);
 out_unlock:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 out:
 	return ret;
 }
+
+int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
+{
+	return __dquot_alloc_space(inode, number, warn, 0);
+}
 EXPORT_SYMBOL(dquot_alloc_space);
 
 int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
 {
-	int ret = QUOTA_OK;
-
-	if (IS_NOQUOTA(inode))
-		goto out;
-
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	if (IS_NOQUOTA(inode))
-		goto out_unlock;
-
-	ret = __dquot_alloc_space(inode, number, warn, 1);
-out_unlock:
-	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-out:
-	return ret;
+	return __dquot_alloc_space(inode, number, warn, 1);
 }
 EXPORT_SYMBOL(dquot_reserve_space);
 
@@ -1540,14 +1587,14 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
 	int ret = QUOTA_OK;
 
 	if (IS_NOQUOTA(inode)) {
-		inode_add_bytes(inode, number);
+		inode_claim_rsv_space(inode, number);
 		goto out;
 	}
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	if (IS_NOQUOTA(inode))	{
 		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		inode_add_bytes(inode, number);
+		inode_claim_rsv_space(inode, number);
 		goto out;
 	}
 
@@ -1559,7 +1606,7 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
 							number);
 	}
 	/* Update inode bytes */
-	inode_add_bytes(inode, number);
+	inode_claim_rsv_space(inode, number);
 	spin_unlock(&dq_data_lock);
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
@@ -1572,38 +1619,9 @@ out:
 EXPORT_SYMBOL(dquot_claim_space);
 
 /*
- * Release reserved quota space
- */
-void dquot_release_reserved_space(struct inode *inode, qsize_t number)
-{
-	int cnt;
-
-	if (IS_NOQUOTA(inode))
-		goto out;
-
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	if (IS_NOQUOTA(inode))
-		goto out_unlock;
-
-	spin_lock(&dq_data_lock);
-	/* Release reserved dquots */
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (inode->i_dquot[cnt])
-			dquot_free_reserved_space(inode->i_dquot[cnt], number);
-	}
-	spin_unlock(&dq_data_lock);
-
-out_unlock:
-	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-out:
-	return;
-}
-EXPORT_SYMBOL(dquot_release_reserved_space);
-
-/*
  * This operation can block, but only after everything is updated
  */
-int dquot_free_space(struct inode *inode, qsize_t number)
+int __dquot_free_space(struct inode *inode, qsize_t number, int reserve)
 {
 	unsigned int cnt;
 	char warntype[MAXQUOTAS];
@@ -1612,7 +1630,7 @@ int dquot_free_space(struct inode *inode, qsize_t number)
          * re-enter the quota code and are already holding the mutex */
 	if (IS_NOQUOTA(inode)) {
 out_sub:
-		inode_sub_bytes(inode, number);
+		inode_decr_space(inode, number, reserve);
 		return QUOTA_OK;
 	}
 
@@ -1627,21 +1645,43 @@ out_sub:
 		if (!inode->i_dquot[cnt])
 			continue;
 		warntype[cnt] = info_bdq_free(inode->i_dquot[cnt], number);
-		dquot_decr_space(inode->i_dquot[cnt], number);
+		if (reserve)
+			dquot_free_reserved_space(inode->i_dquot[cnt], number);
+		else
+			dquot_decr_space(inode->i_dquot[cnt], number);
 	}
-	inode_sub_bytes(inode, number);
+	inode_decr_space(inode, number, reserve);
 	spin_unlock(&dq_data_lock);
+
+	if (reserve)
+		goto out_unlock;
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		if (inode->i_dquot[cnt])
 			mark_dquot_dirty(inode->i_dquot[cnt]);
+out_unlock:
 	flush_warnings(inode->i_dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+
+int dquot_free_space(struct inode *inode, qsize_t number)
+{
+	return  __dquot_free_space(inode, number, 0);
+}
 EXPORT_SYMBOL(dquot_free_space);
 
 /*
+ * Release reserved quota space
+ */
+void dquot_release_reserved_space(struct inode *inode, qsize_t number)
+{
+	__dquot_free_space(inode, number, 1);
+
+}
+EXPORT_SYMBOL(dquot_release_reserved_space);
+
+/*
  * This operation can block, but only after everything is updated
  */
 int dquot_free_inode(const struct inode *inode, qsize_t number)
@@ -1679,19 +1719,6 @@ int dquot_free_inode(const struct inode *inode, qsize_t number)
 EXPORT_SYMBOL(dquot_free_inode);
 
 /*
- * call back function, get reserved quota space from underlying fs
- */
-qsize_t dquot_get_reserved_space(struct inode *inode)
-{
-	qsize_t reserved_space = 0;
-
-	if (sb_any_quota_active(inode->i_sb) &&
-	    inode->i_sb->dq_op->get_reserved_space)
-		reserved_space = inode->i_sb->dq_op->get_reserved_space(inode);
-	return reserved_space;
-}
-
-/*
  * Transfer the number of inode and blocks from one diskquota to an other.
  *
  * This operation can block, but only after everything is updated
@@ -1734,7 +1761,7 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 	}
 	spin_lock(&dq_data_lock);
 	cur_space = inode_get_bytes(inode);
-	rsv_space = dquot_get_reserved_space(inode);
+	rsv_space = inode_get_rsv_space(inode);
 	space = cur_space + rsv_space;
 	/* Build the transfer_from list and check the limits */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 78c4889..8fd8efc 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -313,8 +313,9 @@ struct dquot_operations {
 	int (*claim_space) (struct inode *, qsize_t);
 	/* release rsved quota for delayed alloc */
 	void (*release_rsv) (struct inode *, qsize_t);
-	/* get reserved quota for delayed alloc */
-	qsize_t (*get_reserved_space) (struct inode *);
+	/* get reserved quota for delayed alloc, value returned is managed by
+	 * quota code only */
+	qsize_t *(*get_reserved_space) (struct inode *);
 };
 
 /* Operations handling requests from userspace */
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 26361c4..34b1f13 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -26,6 +26,10 @@ static inline void writeout_quota_sb(struct super_block *sb, int type)
 		sb->s_qcop->quota_sync(sb, type);
 }
 
+void inode_add_rsv_space(struct inode *inode, qsize_t number);
+void inode_claim_rsv_space(struct inode *inode, qsize_t number);
+void inode_sub_rsv_space(struct inode *inode, qsize_t number);
+
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
@@ -42,7 +46,6 @@ int dquot_alloc_inode(const struct inode *inode, qsize_t number);
 int dquot_reserve_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_claim_space(struct inode *inode, qsize_t number);
 void dquot_release_reserved_space(struct inode *inode, qsize_t number);
-qsize_t dquot_get_reserved_space(struct inode *inode);
 
 int dquot_free_space(struct inode *inode, qsize_t number);
 int dquot_free_inode(const struct inode *inode, qsize_t number);
@@ -199,6 +202,8 @@ static inline int vfs_dq_reserve_space(struct inode *inode, qsize_t nr)
 		if (inode->i_sb->dq_op->reserve_space(inode, nr, 0) == NO_QUOTA)
 			return 1;
 	}
+	else
+		inode_add_rsv_space(inode, nr);
 	return 0;
 }
 
@@ -221,7 +226,7 @@ static inline int vfs_dq_claim_space(struct inode *inode, qsize_t nr)
 		if (inode->i_sb->dq_op->claim_space(inode, nr) == NO_QUOTA)
 			return 1;
 	} else
-		inode_add_bytes(inode, nr);
+		inode_claim_rsv_space(inode, nr);
 
 	mark_inode_dirty(inode);
 	return 0;
@@ -235,6 +240,8 @@ void vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_active(inode->i_sb))
 		inode->i_sb->dq_op->release_rsv(inode, nr);
+	else
+		inode_sub_rsv_space(inode, nr);
 }
 
 static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
-- 
1.6.4.2

