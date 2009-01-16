From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/11] quota: Add quota reservation claim and released operations
Date: Fri, 16 Jan 2009 19:08:14 +0100
Message-ID: <1232129299-22018-7-git-send-email-jack@suse.cz>
References: <yes>
 <1232129299-22018-1-git-send-email-jack@suse.cz>
 <1232129299-22018-2-git-send-email-jack@suse.cz>
 <1232129299-22018-3-git-send-email-jack@suse.cz>
 <1232129299-22018-4-git-send-email-jack@suse.cz>
 <1232129299-22018-5-git-send-email-jack@suse.cz>
 <1232129299-22018-6-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1232129299-22018-6-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Mingming Cao <cmm@us.ibm.com>

Reserved quota will be claimed at the block allocation time. Over-booked
quota could be returned back with the release callback function.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c               |  110 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/quota.h    |    6 +++
 include/linux/quotaops.h |   53 ++++++++++++++++++++++
 3 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 9b1c4d3..2916f91 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -904,6 +904,23 @@ static inline void dquot_resv_space(struct dquot *dquot, qsize_t number)
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
 	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
@@ -1452,6 +1469,72 @@ warn_put_all:
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
+EXPORT_SYMBOL(dquot_claim_space);
+
+/*
+ * Release reserved quota space
+ */
+void dquot_release_reserved_space(struct inode *inode, qsize_t number)
+{
+	int cnt;
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
+		if (inode->i_dquot[cnt] != NODQUOT)
+			dquot_free_reserved_space(inode->i_dquot[cnt], number);
+	}
+	spin_unlock(&dq_data_lock);
+
+out_unlock:
+	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+out:
+	return;
+}
+EXPORT_SYMBOL(dquot_release_reserved_space);
+
 /*
  * This operation can block, but only after everything is updated
  */
@@ -1529,6 +1612,19 @@ int dquot_free_inode(const struct inode *inode, qsize_t number)
 }
 
 /*
+ * call back function, get reserved quota space from underlying fs
+ */
+qsize_t dquot_get_reserved_space(struct inode *inode)
+{
+	qsize_t reserved_space = 0;
+
+	if (sb_any_quota_active(inode->i_sb) &&
+	    inode->i_sb->dq_op->get_reserved_space)
+		reserved_space = inode->i_sb->dq_op->get_reserved_space(inode);
+	return reserved_space;
+}
+
+/*
  * Transfer the number of inode and blocks from one diskquota to an other.
  *
  * This operation can block, but only after everything is updated
@@ -1536,7 +1632,8 @@ int dquot_free_inode(const struct inode *inode, qsize_t number)
  */
 int dquot_transfer(struct inode *inode, struct iattr *iattr)
 {
-	qsize_t space;
+	qsize_t space, cur_space;
+	qsize_t rsv_space = 0;
 	struct dquot *transfer_from[MAXQUOTAS];
 	struct dquot *transfer_to[MAXQUOTAS];
 	int cnt, ret = QUOTA_OK;
@@ -1575,7 +1672,9 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 		goto put_all;
 	}
 	spin_lock(&dq_data_lock);
-	space = inode_get_bytes(inode);
+	cur_space = inode_get_bytes(inode);
+	rsv_space = dquot_get_reserved_space(inode);
+	space = cur_space + rsv_space;
 	/* Build the transfer_from list and check the limits */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (transfer_to[cnt] == NODQUOT)
@@ -1604,11 +1703,14 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 			warntype_from_space[cnt] =
 				info_bdq_free(transfer_from[cnt], space);
 			dquot_decr_inodes(transfer_from[cnt], 1);
-			dquot_decr_space(transfer_from[cnt], space);
+			dquot_decr_space(transfer_from[cnt], cur_space);
+			dquot_free_reserved_space(transfer_from[cnt],
+						  rsv_space);
 		}
 
 		dquot_incr_inodes(transfer_to[cnt], 1);
-		dquot_incr_space(transfer_to[cnt], space);
+		dquot_incr_space(transfer_to[cnt], cur_space);
+		dquot_resv_space(transfer_to[cnt], rsv_space);
 
 		inode->i_dquot[cnt] = transfer_to[cnt];
 	}
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 54b837f..a510d91 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -311,6 +311,12 @@ struct dquot_operations {
 	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
 	/* reserve quota for delayed block allocation */
 	int (*reserve_space) (struct inode *, qsize_t, int);
+	/* claim reserved quota for delayed alloc */
+	int (*claim_space) (struct inode *, qsize_t);
+	/* release rsved quota for delayed alloc */
+	void (*release_rsv) (struct inode *, qsize_t);
+	/* get reserved quota for delayed alloc */
+	qsize_t (*get_reserved_space) (struct inode *);
 };
 
 /* Operations handling requests from userspace */
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 3e3a0d2..7369d04 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -35,6 +35,11 @@ void dquot_destroy(struct dquot *dquot);
 int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_alloc_inode(const struct inode *inode, qsize_t number);
 
+int dquot_reserve_space(struct inode *inode, qsize_t number, int prealloc);
+int dquot_claim_space(struct inode *inode, qsize_t number);
+void dquot_release_reserved_space(struct inode *inode, qsize_t number);
+qsize_t dquot_get_reserved_space(struct inode *inode);
+
 int dquot_free_space(struct inode *inode, qsize_t number);
 int dquot_free_inode(const struct inode *inode, qsize_t number);
 
@@ -203,6 +208,31 @@ static inline int vfs_dq_alloc_inode(struct inode *inode)
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
@@ -354,6 +384,17 @@ static inline int vfs_dq_reserve_space(struct inode *inode, qsize_t nr)
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
@@ -397,6 +438,18 @@ static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
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
-- 
1.6.0.2

