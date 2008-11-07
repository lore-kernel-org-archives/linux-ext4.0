From: akpm@linux-foundation.org
Subject: + quota-add-reservation-support-for-delayed-block-allocation.patch added to -mm tree
Date: Thu, 06 Nov 2008 16:00:27 -0800
Message-ID: <200811070000.mA700SA9002052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: cmm@us.ibm.com, jack@ucw.cz, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     quota: add reservation support for delayed block allocation
has been added to the -mm tree.  Its filename is
     quota-add-reservation-support-for-delayed-block-allocation.patch

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
Subject: quota: add reservation support for delayed block allocation
From: Mingming Cao <cmm@us.ibm.com>

Delayed allocation defers the block allocation at the dirty pages
flush-out time, doing quota charge/check at that time is too late.  But we
can't charge the quota blocks until blocks are really allocated, otherwise
users could get overcharged after reboot from system crash.

This patch adds quota reservation for delayed allocation.  Quota blocks
are reserved in memory, inode and quota won't gets dirtied until later
block allocation time.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c               |  105 ++++++++++++++++++++++++++-----------
 include/linux/quota.h    |    2 
 include/linux/quotaops.h |   23 ++++++++
 3 files changed, 101 insertions(+), 29 deletions(-)

diff -puN fs/dquot.c~quota-add-reservation-support-for-delayed-block-allocation fs/dquot.c
--- a/fs/dquot.c~quota-add-reservation-support-for-delayed-block-allocation
+++ a/fs/dquot.c
@@ -841,6 +841,11 @@ static inline void dquot_incr_space(stru
 	dquot->dq_dqb.dqb_curspace += number;
 }
 
+static inline void dquot_resv_space(struct dquot *dquot, qsize_t number)
+{
+	dquot->dq_dqb.dqb_rsvspace += number;
+}
+
 static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 {
 	if (dquot->dq_dqb.dqb_curinodes > number)
@@ -1069,13 +1074,18 @@ static int check_idq(struct dquot *dquot
 /* needs dq_data_lock */
 static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *warntype)
 {
+	qsize_t tspace;
+
 	*warntype = QUOTA_NL_NOWARN;
 	if (!sb_has_quota_limits_enabled(dquot->dq_sb, dquot->dq_type) ||
 	    test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
+	tspace = dquot->dq_dqb.dqb_curspace + dquot->dq_dqb.dqb_rsvspace
+		+ space;
+
 	if (dquot->dq_dqb.dqb_bhardlimit &&
-	    dquot->dq_dqb.dqb_curspace + space > dquot->dq_dqb.dqb_bhardlimit &&
+	    tspace > dquot->dq_dqb.dqb_bhardlimit &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
 			*warntype = QUOTA_NL_BHARDWARN;
@@ -1083,7 +1093,7 @@ static int check_bdq(struct dquot *dquot
 	}
 
 	if (dquot->dq_dqb.dqb_bsoftlimit &&
-	    dquot->dq_dqb.dqb_curspace + space > dquot->dq_dqb.dqb_bsoftlimit &&
+	    tspace > dquot->dq_dqb.dqb_bsoftlimit &&
 	    dquot->dq_dqb.dqb_btime && get_seconds() >= dquot->dq_dqb.dqb_btime &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
@@ -1092,7 +1102,7 @@ static int check_bdq(struct dquot *dquot
 	}
 
 	if (dquot->dq_dqb.dqb_bsoftlimit &&
-	    dquot->dq_dqb.dqb_curspace + space > dquot->dq_dqb.dqb_bsoftlimit &&
+	    tspace > dquot->dq_dqb.dqb_bsoftlimit &&
 	    dquot->dq_dqb.dqb_btime == 0) {
 		if (!prealloc) {
 			*warntype = QUOTA_NL_BSOFTWARN;
@@ -1227,49 +1237,85 @@ void vfs_dq_drop(struct inode *inode)
 /*
  * This operation can block, but only after everything is updated
  */
-int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
+int __dquot_alloc_space(struct inode *inode, qsize_t number,
+			int warn, int reserve)
 {
-	int cnt, ret = NO_QUOTA;
+	int cnt, ret = QUOTA_OK;
 	char warntype[MAXQUOTAS];
 
-	/* First test before acquiring mutex - solves deadlocks when we
-         * re-enter the quota code and are already holding the mutex */
-	if (IS_NOQUOTA(inode)) {
-out_add:
-		inode_add_bytes(inode, number);
-		return QUOTA_OK;
-	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warntype[cnt] = QUOTA_NL_NOWARN;
 
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	if (IS_NOQUOTA(inode)) {	/* Now we can do reliable test... */
-		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		goto out_add;
-	}
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (inode->i_dquot[cnt] == NODQUOT)
 			continue;
-		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt) == NO_QUOTA)
-			goto warn_put_all;
+		if (check_bdq(inode->i_dquot[cnt], number, warn, warntype+cnt)
+		    == NO_QUOTA) {
+			ret = NO_QUOTA;
+			goto out_unlock;
+		}
 	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (inode->i_dquot[cnt] == NODQUOT)
 			continue;
-		dquot_incr_space(inode->i_dquot[cnt], number);
+		if (reserve)
+			dquot_resv_space(inode->i_dquot[cnt], number);
+		else
+			dquot_incr_space(inode->i_dquot[cnt], number);
 	}
-	inode_add_bytes(inode, number);
-	ret = QUOTA_OK;
-warn_put_all:
+out_unlock:
+	flush_warnings(inode->i_dquot, warntype);
 	spin_unlock(&dq_data_lock);
+	return ret;
+}
+
+int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
+{
+	int cnt, ret = QUOTA_OK;
+
+	/*
+	 * First test before acquiring mutex - solves deadlocks when we
+	 * re-enter the quota code and are already holding the mutex
+	 */
+	if (IS_NOQUOTA(inode))
+		goto out;
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode))
+		goto out_unlock;
+
+	ret = __dquot_alloc_space(inode, number, warn, 0);
+	if (ret == NO_QUOTA)
+		goto out_unlock;
+
+	/* Dirtify all the dquots - this can block when journalling */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+		if (inode->i_dquot[cnt])
+			mark_dquot_dirty(inode->i_dquot[cnt]);
+out_unlock:
+	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+out:
 	if (ret == QUOTA_OK)
-		/* Dirtify all the dquots - this can block when journalling */
-		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-			if (inode->i_dquot[cnt])
-				mark_dquot_dirty(inode->i_dquot[cnt]);
-	flush_warnings(inode->i_dquot, warntype);
+		inode_add_bytes(inode, number);
+	return ret;
+}
+
+int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
+{
+	int ret = QUOTA_OK;
+
+	if (IS_NOQUOTA(inode))
+		goto out;
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode))
+		goto out_unlock;
+
+	ret = __dquot_alloc_space(inode, number, warn, 1);
+out_unlock:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+out:
 	return ret;
 }
 
@@ -1958,7 +2004,7 @@ static void do_get_dqblk(struct dquot *d
 	spin_lock(&dq_data_lock);
 	di->dqb_bhardlimit = stoqb(dm->dqb_bhardlimit);
 	di->dqb_bsoftlimit = stoqb(dm->dqb_bsoftlimit);
-	di->dqb_curspace = dm->dqb_curspace;
+	di->dqb_curspace = dm->dqb_curspace + dm->dqb_rsvspace;
 	di->dqb_ihardlimit = dm->dqb_ihardlimit;
 	di->dqb_isoftlimit = dm->dqb_isoftlimit;
 	di->dqb_curinodes = dm->dqb_curinodes;
@@ -2297,6 +2343,7 @@ EXPORT_SYMBOL(dquot_alloc_space);
 EXPORT_SYMBOL(dquot_alloc_inode);
 EXPORT_SYMBOL(dquot_free_space);
 EXPORT_SYMBOL(dquot_free_inode);
+EXPORT_SYMBOL(dquot_reserve_space);
 EXPORT_SYMBOL(dquot_transfer);
 EXPORT_SYMBOL(vfs_dq_transfer);
 EXPORT_SYMBOL(vfs_dq_quota_on_remount);
diff -puN include/linux/quota.h~quota-add-reservation-support-for-delayed-block-allocation include/linux/quota.h
--- a/include/linux/quota.h~quota-add-reservation-support-for-delayed-block-allocation
+++ a/include/linux/quota.h
@@ -186,6 +186,7 @@ struct mem_dqblk {
 	qsize_t dqb_bhardlimit;	/* absolute limit on disk blks alloc */
 	qsize_t dqb_bsoftlimit;	/* preferred limit on disk blks */
 	qsize_t dqb_curspace;	/* current used space */
+	qsize_t dqb_rsvspace;   /* current reserved space for delalloc*/
 	qsize_t dqb_ihardlimit;	/* absolute limit on allocated inodes */
 	qsize_t dqb_isoftlimit;	/* preferred inode limit */
 	qsize_t dqb_curinodes;	/* current # allocated inodes */
@@ -291,6 +292,7 @@ struct dquot_operations {
 	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
 	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
 	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
+	int (*reserve_space) (struct inode *, qsize_t, int); /* reserve quota for delayed block allocation */
 };
 
 /* Operations handling requests from userspace */
diff -puN include/linux/quotaops.h~quota-add-reservation-support-for-delayed-block-allocation include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-add-reservation-support-for-delayed-block-allocation
+++ a/include/linux/quotaops.h
@@ -176,6 +176,16 @@ static inline int vfs_dq_alloc_space(str
 	return ret;
 }
 
+static inline int vfs_dq_reserve_space(struct inode *inode, qsize_t nr)
+{
+	if (sb_any_quota_active(inode->i_sb)) {
+		/* Used space is updated in alloc_space() */
+		if (inode->i_sb->dq_op->reserve_space(inode, nr, 0) == NO_QUOTA)
+			return 1;
+	}
+	return 0;
+}
+
 static inline int vfs_dq_alloc_inode(struct inode *inode)
 {
 	if (sb_any_quota_active(inode->i_sb)) {
@@ -332,6 +342,11 @@ static inline int vfs_dq_alloc_space(str
 	return 0;
 }
 
+static inline int vfs_dq_reserve_space(struct inode *inode, qsize_t nr)
+{
+	return 0;
+}
+
 static inline void vfs_dq_free_space_nodirty(struct inode *inode, qsize_t nr)
 {
 	inode_sub_bytes(inode, nr);
@@ -363,12 +378,19 @@ static inline int vfs_dq_alloc_block_nod
 			nr << inode->i_sb->s_blocksize_bits);
 }
 
+
 static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t nr)
 {
 	return vfs_dq_alloc_space(inode,
 			nr << inode->i_sb->s_blocksize_bits);
 }
 
+static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
+{
+	return vfs_dq_reserve_space(inode,
+			nr << inode->i_blkbits);
+}
+
 static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
 {
 	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
@@ -397,6 +419,7 @@ static inline void vfs_dq_free_block(str
 #define DQUOT_ALLOC_BLOCK_NODIRTY(inode, nr) \
 				vfs_dq_alloc_block_nodirty(inode, nr)
 #define DQUOT_ALLOC_BLOCK(inode, nr) vfs_dq_alloc_block(inode, nr)
+#define DQUOT_RESERVE_BLOCK(inode, nr) vfs_dq_reserve_block(inode, nr)
 #define DQUOT_ALLOC_INODE(inode) vfs_dq_alloc_inode(inode)
 #define DQUOT_FREE_SPACE_NODIRTY(inode, nr) \
 				vfs_dq_free_space_nodirty(inode, nr)
_

Patches currently in -mm which might be from cmm@us.ibm.com are

quota-add-reservation-support-for-delayed-block-allocation.patch
quota-add-quota-claim-and-release-reserved-quota-blocks-operations.patch
ext4-quota-handling-for-delayed-allocation.patch

