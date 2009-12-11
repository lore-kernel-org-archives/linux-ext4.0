From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] quota: decouple fs reserved space from quota reservation.
 [V4]
Date: Fri, 11 Dec 2009 05:41:44 +0300
Message-ID: <1260499305-6806-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:52776 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762122AbZLKClb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2009 21:41:31 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KUG00A0XVPBNE40@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Fri, 11 Dec 2009 05:46:26 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

Changes from V3:
- fix deadlock in dquota_alloc_space in journalled mode with nodelalloc

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c      |  218 ++++++++++++++++++++++++++++---------------------
 include/linux/quota.h |    5 +-
 2 files changed, 127 insertions(+), 96 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 39b49c4..7872f85 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1388,6 +1388,71 @@ void vfs_dq_drop(struct inode *inode)
 EXPORT_SYMBOL(vfs_dq_drop);
 
 /*
+ * inode_reserved_space is managed internally by quota, and protected by
+ * i_lock similar to i_blocks+i_bytes.
+ */
+static qsize_t* inode_reserved_space(struct inode * inode)
+{
+	/* Filesystem must explicitly define it's own method in order to use
+	 * quota reservation interface */
+	BUG_ON(!inode->i_sb->dq_op->get_reserved_space);
+	return inode->i_sb->dq_op->get_reserved_space(inode);
+}
+
+static void inode_add_rsv_space(struct inode *inode, qsize_t number)
+{
+	spin_lock(&inode->i_lock);
+	*inode_reserved_space(inode) += number;
+	spin_unlock(&inode->i_lock);
+}
+
+static void inode_claim_rsv_space(struct inode *inode, qsize_t number)
+{
+	spin_lock(&inode->i_lock);
+	*inode_reserved_space(inode) -= number;
+	inode->i_blocks += number >> 9;
+	number &= 511;
+	inode->i_bytes += number;
+	if (inode->i_bytes >= 512) {
+		inode->i_blocks++;
+		inode->i_bytes -= 512;
+	}
+	spin_unlock(&inode->i_lock);
+}
+
+static void inode_sub_rsv_space(struct inode *inode, qsize_t number)
+{
+	spin_lock(&inode->i_lock);
+	*inode_reserved_space(inode) -= number;
+	spin_unlock(&inode->i_lock);
+}
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
+static void __inode_add_bytes(struct inode *inode, qsize_t number, int reserve)
+{
+	if (reserve)
+		inode_add_rsv_space(inode, number);
+	else
+		inode_add_bytes(inode, number);
+}
+
+static void __inode_sub_bytes(struct inode *inode, qsize_t number, int reserve)
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
@@ -1405,6 +1470,21 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
 	int cnt, ret = QUOTA_OK;
 	char warntype[MAXQUOTAS];
 
+	/*
+	 * First test before acquiring mutex - solves deadlocks when we
+	 * re-enter the quota code and are already holding the mutex
+	 */
+	if (IS_NOQUOTA(inode)) {
+		__inode_add_bytes(inode, number, reserve);
+		goto out;
+	}
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode)) {
+		__inode_add_bytes(inode, number, reserve);
+		goto out_unlock;
+	}
+
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warntype[cnt] = QUOTA_NL_NOWARN;
 
@@ -1415,7 +1495,8 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
 		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt)
 		    == NO_QUOTA) {
 			ret = NO_QUOTA;
-			goto out_unlock;
+			spin_unlock(&dq_data_lock);
+			goto out_flush_warn;
 		}
 	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -1426,64 +1507,32 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
 		else
 			dquot_incr_space(inode->i_dquot[cnt], number);
 	}
-	if (!reserve)
-		inode_add_bytes(inode, number);
-out_unlock:
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
+	__inode_add_bytes(inode, number, reserve);
 
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
 
@@ -1540,14 +1589,14 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
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
 
@@ -1559,7 +1608,7 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
 							number);
 	}
 	/* Update inode bytes */
-	inode_add_bytes(inode, number);
+	inode_claim_rsv_space(inode, number);
 	spin_unlock(&dq_data_lock);
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
@@ -1572,38 +1621,9 @@ out:
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
@@ -1612,7 +1632,7 @@ int dquot_free_space(struct inode *inode, qsize_t number)
          * re-enter the quota code and are already holding the mutex */
 	if (IS_NOQUOTA(inode)) {
 out_sub:
-		inode_sub_bytes(inode, number);
+		__inode_sub_bytes(inode, number, reserve);
 		return QUOTA_OK;
 	}
 
@@ -1627,21 +1647,43 @@ out_sub:
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
 	spin_unlock(&dq_data_lock);
+	__inode_sub_bytes(inode, number, reserve);
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
+	return (void )__dquot_free_space(inode, number, 1);
+
+}
+EXPORT_SYMBOL(dquot_release_reserved_space);
+
+/*
  * This operation can block, but only after everything is updated
  */
 int dquot_free_inode(const struct inode *inode, qsize_t number)
@@ -1679,19 +1721,6 @@ int dquot_free_inode(const struct inode *inode, qsize_t number)
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
@@ -1734,7 +1763,7 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 	}
 	spin_lock(&dq_data_lock);
 	cur_space = inode_get_bytes(inode);
-	rsv_space = dquot_get_reserved_space(inode);
+	rsv_space = inode_get_rsv_space(inode);
 	space = cur_space + rsv_space;
 	/* Build the transfer_from list and check the limits */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -1854,6 +1883,7 @@ const struct dquot_operations dquot_operations = {
 	.write_info	= dquot_commit_info,
 	.alloc_dquot	= dquot_alloc,
 	.destroy_dquot	= dquot_destroy,
+
 };
 
 /*
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 78c4889..40845f1 100644
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
+	qsize_t* (*get_reserved_space) (struct inode *);
 };
 
 /* Operations handling requests from userspace */
-- 
1.6.0.4

