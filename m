From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH V2 1/3] quota: Add reservation support for delayed block
	allocation
Date: Fri, 31 Oct 2008 14:27:22 -0700
Message-ID: <1225488442.7600.12.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:42470 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYJaV12 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 17:27:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quota: Add quota reservation support

Delayed allocation defers the block allocation at the dirty pages
flush-out time, doing quota charge/check at that time is too late.
But we can't charge the quota blocks until blocks are really allocated,
otherwise users could get overcharged after reboot from system crash.

This patch adds quota reservation for delayed llocation. Quota blocks
are reserved in memory, inode and quota won't gets dirtied until later
block allocation time.

Based on Jan Kara's 64 bit quota changes, tested on 2.6.28-rc2.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>


---
 fs/dquot.c               |  113 ++++++++++++++++++++++++++++++++++-------------
 include/linux/quota.h    |    2 
 include/linux/quotaops.h |   30 ++++++++++++
 3 files changed, 115 insertions(+), 30 deletions(-)

Index: linux-2.6.28-rc2/fs/dquot.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/dquot.c	2008-10-29 13:26:57.000000000 -0700
+++ linux-2.6.28-rc2/fs/dquot.c	2008-10-30 14:41:50.000000000 -0700
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
@@ -1227,48 +1237,90 @@ void vfs_dq_drop(struct inode *inode)
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
-	spin_unlock(&dq_data_lock);
-	if (ret == QUOTA_OK)
-		/* Dirtify all the dquots - this can block when journalling */
-		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-			if (inode->i_dquot[cnt])
-				mark_dquot_dirty(inode->i_dquot[cnt]);
+out_unlock:
 	flush_warnings(inode->i_dquot, warntype);
+	spin_unlock(&dq_data_lock);
+	return ret;
+}
+
+int dquot_alloc_space(struct inode *inode, qsize_t number, int warn)
+{
+	int cnt, ret = QUOTA_OK;
+
+	/*
+	 * First test before acquiring mutex - solves deadlocks when we
+         * re-enter the quota code and are already holding the mutex
+         */
+	if (IS_NOQUOTA(inode)) {
+		inode_add_bytes(inode, number);
+		return ret;
+	}
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode))	{
+		/* Now we can do reliable test... */
+		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+		inode_add_bytes(inode, number);
+		return ret;
+	}
+
+	ret = __dquot_alloc_space(inode, number, warn, 0);
+	if (ret == NO_QUOTA) {
+		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+		return ret;
+	}
+
+	/* Dirtify all the dquots - this can block when journalling */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+		if (inode->i_dquot[cnt])
+			mark_dquot_dirty(inode->i_dquot[cnt]);
+	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	inode_add_bytes(inode, number);
+	return ret;
+}
+
+int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
+{
+	int ret = QUOTA_OK;
+
+	if (IS_NOQUOTA(inode))
+		return ret;
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode))	{
+		/* Now we can do reliable test... */
+		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+		return ret;
+	}
+
+	ret = __dquot_alloc_space(inode, number, warn, 1);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
@@ -1958,7 +2010,7 @@ static void do_get_dqblk(struct dquot *d
 	spin_lock(&dq_data_lock);
 	di->dqb_bhardlimit = stoqb(dm->dqb_bhardlimit);
 	di->dqb_bsoftlimit = stoqb(dm->dqb_bsoftlimit);
-	di->dqb_curspace = dm->dqb_curspace;
+	di->dqb_curspace = dm->dqb_curspace + dm->dqb_rsvspace;
 	di->dqb_ihardlimit = dm->dqb_ihardlimit;
 	di->dqb_isoftlimit = dm->dqb_isoftlimit;
 	di->dqb_curinodes = dm->dqb_curinodes;
@@ -2297,6 +2349,7 @@ EXPORT_SYMBOL(dquot_alloc_space);
 EXPORT_SYMBOL(dquot_alloc_inode);
 EXPORT_SYMBOL(dquot_free_space);
 EXPORT_SYMBOL(dquot_free_inode);
+EXPORT_SYMBOL(dquot_reserve_space);
 EXPORT_SYMBOL(dquot_transfer);
 EXPORT_SYMBOL(vfs_dq_transfer);
 EXPORT_SYMBOL(vfs_dq_quota_on_remount);
Index: linux-2.6.28-rc2/include/linux/quota.h
===================================================================
--- linux-2.6.28-rc2.orig/include/linux/quota.h	2008-10-29 13:56:50.000000000 -0700
+++ linux-2.6.28-rc2/include/linux/quota.h	2008-10-30 14:41:35.000000000 -0700
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
Index: linux-2.6.28-rc2/include/linux/quotaops.h
===================================================================
--- linux-2.6.28-rc2.orig/include/linux/quotaops.h	2008-10-29 13:26:57.000000000 -0700
+++ linux-2.6.28-rc2/include/linux/quotaops.h	2008-10-30 14:41:35.000000000 -0700
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
@@ -327,6 +337,11 @@ static inline int vfs_dq_alloc_space(str
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
@@ -358,12 +373,19 @@ static inline int vfs_dq_alloc_block_nod
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
+			nr << inode->i_sb->s_blocksize_bits);
+}
+
 static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
 {
 	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
@@ -392,6 +414,7 @@ static inline void vfs_dq_free_block(str
 #define DQUOT_ALLOC_BLOCK_NODIRTY(inode, nr) \
 				vfs_dq_alloc_block_nodirty(inode, nr)
 #define DQUOT_ALLOC_BLOCK(inode, nr) vfs_dq_alloc_block(inode, nr)
+#define DQUOT_RESERVE_BLOCK(inode, nr) vfs_dq_reserve_block(inode, nr)
 #define DQUOT_ALLOC_INODE(inode) vfs_dq_alloc_inode(inode)
 #define DQUOT_FREE_SPACE_NODIRTY(inode, nr) \
 				vfs_dq_free_space_nodirty(inode, nr)


