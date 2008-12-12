From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH V4 2/3] quota: Add quota claim and release reserved quota
	blocks operations
Date: Fri, 12 Dec 2008 12:47:40 -0800
Message-ID: <1229114860.7646.26.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:33229 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYLLUrp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 15:47:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

quota: Add quota reservation claim and released operations

Reserved quota will be claimed at the block allocation time. Over-booked
quota could be returned back with the release callback function.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/dquot.c               |  101 +++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/quota.h    |    4 +
 include/linux/quotaops.h |   53 ++++++++++++++++++++++++
 3 files changed, 153 insertions(+), 5 deletions(-)

Index: linux-2.6.28-rc2/include/linux/quota.h
===================================================================
--- linux-2.6.28-rc2.orig/include/linux/quota.h	2008-12-12 12:18:29.000000000 -0800
+++ linux-2.6.28-rc2/include/linux/quota.h	2008-12-12 12:21:32.000000000 -0800
@@ -292,7 +292,9 @@ struct dquot_operations {
 	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
 	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
 	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
-	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve quota for delayed block allocation */
+	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve quota for delayed alloc */
+	int (*claim_space) (struct inode *, qsize_t); /* claim reserved quota for delayed alloc */
+	void (*release_rsv) (struct inode *, qsize_t); /* release rsved quota for delayed alloc */
 };
 
 /* Operations handling requests from userspace */
Index: linux-2.6.28-rc2/include/linux/quotaops.h
===================================================================
--- linux-2.6.28-rc2.orig/include/linux/quotaops.h	2008-12-12 12:20:45.000000000 -0800
+++ linux-2.6.28-rc2/include/linux/quotaops.h	2008-12-12 12:21:49.000000000 -0800
@@ -28,6 +28,11 @@ int dquot_drop(struct inode *inode);
 int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_alloc_inode(const struct inode *inode, qsize_t number);
 
+int dquot_reserve_space(struct inode *inode, qsize_t number, int prealloc);
+int dquot_claim_space(struct inode *inode, qsize_t number);
+void dquot_release_reserved_space(struct inode *inode, qsize_t number);
+
+
 int dquot_free_space(struct inode *inode, qsize_t number);
 int dquot_free_inode(const struct inode *inode, qsize_t number);
 
@@ -196,6 +201,31 @@ static inline int vfs_dq_alloc_inode(str
 	return 0;
 }
 
+/*
+ * Convert in-memory reserved quotas to real consumed quotas
+ */
+static inline int vfs_dq_claim_space(struct inode *inode, qsize_t nr)
+{
+	if (sb_any_quota_active(inode->i_sb)) {
+		if (inode->i_sb->dq_op->claim_space(inode, nr) == NO_QUOTA)
+			return 1;
+	} else
+		inode_add_bytes(inode, nr);
+
+	mark_inode_dirty(inode);
+	return 0;
+}
+
+/*
+ * Release reserved (in-memory) quotas
+ */
+static inline
+void vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
+{
+	if (sb_any_quota_active(inode->i_sb))
+		inode->i_sb->dq_op->release_rsv(inode, nr);
+}
+
 static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_active(inode->i_sb))
@@ -342,6 +372,17 @@ static inline int vfs_dq_reserve_space(s
 	return 0;
 }
 
+static inline int vfs_dq_claim_space(struct inode *inode, qsize_t nr)
+{
+	return vfs_dq_alloc_space(inode, nr);
+}
+
+static inline
+int vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
+{
+	return 0;
+}
+
 static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	inode_sub_bytes(inode, nr);
@@ -386,6 +427,18 @@ static inline int vfs_dq_reserve_block(s
 			nr << inode->i_blkbits);
 }
 
+static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
+{
+	return vfs_dq_claim_space(inode,
+			nr << inode->i_blkbits);
+}
+
+static inline
+void vfs_dq_release_reservation_block(struct inode *inode, qsize_t nr)
+{
+	vfs_dq_release_reservation_space(inode, nr << inode->i_blkbits);
+}
+
 static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
 {
 	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
Index: linux-2.6.28-rc2/fs/dquot.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/dquot.c	2008-12-12 12:20:45.000000000 -0800
+++ linux-2.6.28-rc2/fs/dquot.c	2008-12-12 12:21:49.000000000 -0800
@@ -846,6 +846,23 @@ static inline void dquot_resv_space(stru
 	dquot->dq_dqb.dqb_rsvspace += number;
 }
 
+/*
+ * Claim reserved quota space
+ */
+static void dquot_claim_reserved_space(struct dquot *dquot,
+						qsize_t number)
+{
+	WARN_ON(dquot->dq_dqb.dqb_rsvspace < number);
+	dquot->dq_dqb.dqb_curspace += number;
+	dquot->dq_dqb.dqb_rsvspace -= number;
+}
+
+static inline
+void dquot_free_reserved_space(struct dquot *dquot, qsize_t number)
+{
+	dquot->dq_dqb.dqb_rsvspace -= number;
+}
+
 static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 {
 	if (dquot->dq_dqb.dqb_curinodes > number)
@@ -1319,6 +1336,73 @@ out:
 	return ret;
 }
 
+int dquot_claim_space(struct inode *inode, qsize_t number)
+{
+	int cnt;
+	int ret = QUOTA_OK;
+
+	if (IS_NOQUOTA(inode)) {
+		inode_add_bytes(inode, number);
+		goto out;
+	}
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode))	{
+		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+		inode_add_bytes(inode, number);
+		goto out;
+	}
+
+	spin_lock(&dq_data_lock);
+	/* Claim reserved quotas to allocated quotas */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		if (inode->i_dquot[cnt] != NODQUOT)
+			dquot_claim_reserved_space(inode->i_dquot[cnt],
+							number);
+	}
+	/* Update inode bytes */
+	inode_add_bytes(inode, number);
+	spin_unlock(&dq_data_lock);
+	/* Dirtify all the dquots - this can block when journalling */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+		if (inode->i_dquot[cnt])
+			mark_dquot_dirty(inode->i_dquot[cnt]);
+	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+out:
+	return ret;
+}
+
+/*
+ * Release reserved quota space
+ */
+void dquot_release_reserved_space(struct inode *inode, qsize_t number)
+{
+	int cnt;
+	struct dquot *dquot;
+
+	if (IS_NOQUOTA(inode))
+		goto out;
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode))
+		goto out_unlock;
+
+	spin_lock(&dq_data_lock);
+	/* Release reserved dquots */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		if (inode->i_dquot[cnt] != NODQUOT) {
+			dquot = inode->i_dquot[cnt];
+			dquot_free_reserved_space(dquot, number);
+		}
+	}
+	spin_unlock(&dq_data_lock);
+
+out_unlock:
+	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+out:
+	return;
+}
+
 /*
  * This operation can block, but only after everything is updated
  */
@@ -1448,7 +1532,8 @@ int dquot_free_inode(const struct inode 
  */
 int dquot_transfer(struct inode *inode, struct iattr *iattr)
 {
-	qsize_t space;
+	qsize_t space, cur_space;
+	qsize_t rsv_space = 0;
 	struct dquot *transfer_from[MAXQUOTAS];
 	struct dquot *transfer_to[MAXQUOTAS];
 	int cnt, ret = NO_QUOTA, chuid = (iattr->ia_valid & ATTR_UID) && inode->i_uid != iattr->ia_uid,
@@ -1489,12 +1574,16 @@ int dquot_transfer(struct inode *inode, 
 		}
 	}
 	spin_lock(&dq_data_lock);
-	space = inode_get_bytes(inode);
+	space = cur_space = inode_get_bytes(inode);
 	/* Build the transfer_from list and check the limits */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (transfer_to[cnt] == NODQUOT)
 			continue;
 		transfer_from[cnt] = inode->i_dquot[cnt];
+		if (!rsv_space) {
+			rsv_space = transfer_from[cnt]->dq_dqb.dqb_rsvspace;
+			space += rsv_space;
+		}
 		if (check_idq(transfer_to[cnt], 1, warntype_to + cnt) ==
 		    NO_QUOTA || check_bdq(transfer_to[cnt], space, 0,
 		    warntype_to + cnt) == NO_QUOTA)
@@ -1518,11 +1607,13 @@ int dquot_transfer(struct inode *inode, 
 			warntype_from_space[cnt] =
 				info_bdq_free(transfer_from[cnt], space);
 			dquot_decr_inodes(transfer_from[cnt], 1);
-			dquot_decr_space(transfer_from[cnt], space);
+			dquot_decr_space(transfer_from[cnt], cur_space);
+			dquot_free_reserved_space(transfer_from[cnt], rsv_space);
 		}
 
 		dquot_incr_inodes(transfer_to[cnt], 1);
-		dquot_incr_space(transfer_to[cnt], space);
+		dquot_incr_space(transfer_to[cnt], cur_space);
+		dquot_resv_space(transfer_to[cnt], rsv_space);
 
 		inode->i_dquot[cnt] = transfer_to[cnt];
 	}
@@ -2344,6 +2435,8 @@ EXPORT_SYMBOL(dquot_alloc_inode);
 EXPORT_SYMBOL(dquot_free_space);
 EXPORT_SYMBOL(dquot_free_inode);
 EXPORT_SYMBOL(dquot_reserve_space);
+EXPORT_SYMBOL(dquot_claim_space);
+EXPORT_SYMBOL(dquot_release_reserved_space);
 EXPORT_SYMBOL(dquot_transfer);
 EXPORT_SYMBOL(vfs_dq_transfer);
 EXPORT_SYMBOL(vfs_dq_quota_on_remount);


