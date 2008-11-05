From: akpm@linux-foundation.org
Subject: + quota-add-quota-claim-and-release-reserved-quota-blocks-operations.patch added to -mm tree
Date: Tue, 04 Nov 2008 17:33:41 -0800
Message-ID: <200811050133.mA51XfEj018682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: cmm@us.ibm.com, jack@ucw.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     quota: add quota claim and release reserved quota blocks operations
has been added to the -mm tree.  Its filename is
     quota-add-quota-claim-and-release-reserved-quota-blocks-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: add quota claim and release reserved quota blocks operations
From: Mingming Cao <cmm@us.ibm.com>

The reserved quota will be claimed at block allocation time.  Any
over-booked quota is returned back with the release callback function.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c               |   85 +++++++++++++++++++++++++++++++++++++
 include/linux/quota.h    |    2 
 include/linux/quotaops.h |   53 +++++++++++++++++++++++
 3 files changed, 140 insertions(+)

diff -puN fs/dquot.c~quota-add-quota-claim-and-release-reserved-quota-blocks-operations fs/dquot.c
--- a/fs/dquot.c~quota-add-quota-claim-and-release-reserved-quota-blocks-operations
+++ a/fs/dquot.c
@@ -846,6 +846,24 @@ static inline void dquot_resv_space(stru
 	dquot->dq_dqb.dqb_rsvspace += number;
 }
 
+/*
+ * Claim reserved quota space
+ */
+static int dquot_claim_reserved_space(struct dquot *dquot,
+						qsize_t number)
+{
+	if (dquot->dq_dqb.dqb_rsvspace < number) {
+		printk("WARNING: reserved quota %llu is not enough for"
+			"request %llu bytes\n",
+			dquot->dq_dqb.dqb_rsvspace, number);
+		return 1;
+	}
+
+	dquot->dq_dqb.dqb_curspace += number;
+	dquot->dq_dqb.dqb_rsvspace -= number;
+	return 0;
+}
+
 static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 {
 	if (dquot->dq_dqb.dqb_curinodes > number)
@@ -1325,6 +1343,71 @@ int dquot_reserve_space(struct inode *in
 	return ret;
 }
 
+int dquot_claim_space(struct inode *inode, qsize_t number)
+{
+	int cnt;
+	int ret = QUOTA_OK;
+
+	if (IS_NOQUOTA(inode)) {
+		inode_add_bytes(inode, number);
+		return ret;
+	}
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode))	{
+		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+		inode_add_bytes(inode, number);
+		return ret;
+	}
+
+	/* Claim reserved quotas to allocated quotas */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		if (inode->i_dquot[cnt] != NODQUOT)
+			ret = dquot_claim_reserved_space(inode->i_dquot[cnt],
+							number);
+	}
+	if (ret == NO_QUOTA) {
+		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+		return ret;
+	}
+	/* Dirtify all the dquots - this can block when journalling */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+		if (inode->i_dquot[cnt])
+			mark_dquot_dirty(inode->i_dquot[cnt]);
+	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+
+	/* Update inode bytes */
+	inode_add_bytes(inode, number);
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
+		return;
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode))	{
+		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+		return;
+	}
+
+	/* Release reserved dquots */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		if (inode->i_dquot[cnt] != NODQUOT) {
+			dquot = inode->i_dquot[cnt];
+			dquot->dq_dqb.dqb_rsvspace -= number;
+		}
+	}
+	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+}
+
 /*
  * This operation can block, but only after everything is updated
  */
@@ -2350,6 +2433,8 @@ EXPORT_SYMBOL(dquot_alloc_inode);
 EXPORT_SYMBOL(dquot_free_space);
 EXPORT_SYMBOL(dquot_free_inode);
 EXPORT_SYMBOL(dquot_reserve_space);
+EXPORT_SYMBOL(dquot_claim_space);
+EXPORT_SYMBOL(dquot_release_reserved_space);
 EXPORT_SYMBOL(dquot_transfer);
 EXPORT_SYMBOL(vfs_dq_transfer);
 EXPORT_SYMBOL(vfs_dq_quota_on_remount);
diff -puN include/linux/quota.h~quota-add-quota-claim-and-release-reserved-quota-blocks-operations include/linux/quota.h
--- a/include/linux/quota.h~quota-add-quota-claim-and-release-reserved-quota-blocks-operations
+++ a/include/linux/quota.h
@@ -293,6 +293,8 @@ struct dquot_operations {
 	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
 	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
 	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve quota for delayed block allocation */
+	int (*claim_space) (struct inode *, qsize_t); /* claim reserved quota for delayed block allocation */
+	void (*release_rsv) (struct inode *, qsize_t); /* release reserved quota for delayed block allocation */
 };
 
 /* Operations handling requests from userspace */
diff -puN include/linux/quotaops.h~quota-add-quota-claim-and-release-reserved-quota-blocks-operations include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-add-quota-claim-and-release-reserved-quota-blocks-operations
+++ a/include/linux/quotaops.h
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
+	if (sb_any_quota_active(inode->i_sb)){
+		if (inode->i_sb->dq_op->claim_space(inode, nr) == NO_QUOTA)
+			return 1;
+	}
+	else
+		inode_add_bytes(inode, nr);
+
+	mark_inode_dirty(inode);
+	return 0;
+}
+
+/*
+ * Release reserved (in-memory) quotas
+ */
+static inline void vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
+{
+	if (sb_any_quota_active(inode->i_sb))
+		inode->i_sb->dq_op->release_rsv(inode, nr);
+}
+
 static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	if (sb_any_quota_active(inode->i_sb))
@@ -347,6 +377,16 @@ static inline int vfs_dq_reserve_space(s
 	return 0;
 }
 
+static inline int vfs_dq_claim_space(struct inode *inode, qsize_t nr)
+{
+	return vfs_dq_alloc_space(inode, nr);
+}
+
+static inline int vfs_dq_release_reservation_space(struct inode *inode, qsize_t nr)
+{
+	return 0;
+}
+
 static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	inode_sub_bytes(inode, nr);
@@ -391,6 +431,17 @@ static inline int vfs_dq_reserve_block(s
 			nr << inode->i_sb->s_blocksize_bits);
 }
 
+static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
+{
+	return vfs_dq_claim_space(inode,
+			nr << inode->i_sb->s_blocksize_bits);
+}
+
+static inline void vfs_dq_release_reservation(struct inode *inode, qsize_t nr)
+{
+	vfs_dq_release_reservation_space(inode, nr << inode->i_sb->s_blocksize_bits);
+}
+
 static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
 {
 	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
@@ -420,6 +471,8 @@ static inline void vfs_dq_free_block(str
 				vfs_dq_alloc_block_nodirty(inode, nr)
 #define DQUOT_ALLOC_BLOCK(inode, nr) vfs_dq_alloc_block(inode, nr)
 #define DQUOT_RESERVE_BLOCK(inode, nr) vfs_dq_reserve_block(inode, nr)
+#define DQUOT_CLAIM_BLOCK(inode, nr) vfs_dq_claim_block(inode, nr)
+#define DQUOT_RELEASE_RSV_BLOCK(inode, nr) vfs_dq_release_reservation(inode, nr)
 #define DQUOT_ALLOC_INODE(inode) vfs_dq_alloc_inode(inode)
 #define DQUOT_FREE_SPACE_NODIRTY(inode, nr) \
 				vfs_dq_free_space_nodirty(inode, nr)
_

Patches currently in -mm which might be from cmm@us.ibm.com are

quota-add-reservation-support-for-delayed-block-allocation.patch
quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes.patch
quota-add-quota-claim-and-release-reserved-quota-blocks-operations.patch
quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes.patch
ext4-quota-handling-for-delayed-allocation.patch
ext4-quota-handling-for-delayed-allocation-checkpatch-fixes.patch

