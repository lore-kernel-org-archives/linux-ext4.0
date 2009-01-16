From: Jan Kara <jack@suse.cz>
Subject: [PATCH 01/11] quota: Improve locking
Date: Fri, 16 Jan 2009 19:08:09 +0100
Message-ID: <1232129299-22018-2-git-send-email-jack@suse.cz>
References: <yes>
 <1232129299-22018-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1232129299-22018-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We implement dqget() and dqput() that need neither dqonoff_mutex nor dqptr_sem.
Then move dqget() and dqput() calls so that they are not called from under
dqptr_sem. This is important because filesystem callbacks aren't called from
under dqptr_sem which used to cause *lots* of problems with lock ranking
(and with OCFS2 they became close to unsolvable).

The patch also removes two functions which were introduced solely because OCFS2
needed them to cope with the old locking scheme. As time showed, they were not
enough for OCFS2 anyway and it would be unnecessary work to adapt them to the
new locking scheme in which they aren't needed.  As a result OCFS2 needs the
following patch to compile properly with quotas.  Sorry to any bisecters which
hit this in advance.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c               |  218 ++++++++++++++++++++++++++--------------------
 include/linux/quotaops.h |    2 -
 2 files changed, 122 insertions(+), 98 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 48c0571..bca3cac 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -87,14 +87,17 @@
 #define __DQUOT_PARANOIA
 
 /*
- * There are two quota SMP locks. dq_list_lock protects all lists with quotas
- * and quota formats and also dqstats structure containing statistics about the
- * lists. dq_data_lock protects data from dq_dqb and also mem_dqinfo structures
- * and also guards consistency of dquot->dq_dqb with inode->i_blocks, i_bytes.
+ * There are three quota SMP locks. dq_list_lock protects all lists with quotas
+ * and quota formats, dqstats structure containing statistics about the lists
+ * dq_data_lock protects data from dq_dqb and also mem_dqinfo structures and
+ * also guards consistency of dquot->dq_dqb with inode->i_blocks, i_bytes.
  * i_blocks and i_bytes updates itself are guarded by i_lock acquired directly
- * in inode_add_bytes() and inode_sub_bytes().
+ * in inode_add_bytes() and inode_sub_bytes(). dq_state_lock protects
+ * modifications of quota state (on quotaon and quotaoff) and readers who care
+ * about latest values take it as well.
  *
- * The spinlock ordering is hence: dq_data_lock > dq_list_lock > i_lock
+ * The spinlock ordering is hence: dq_data_lock > dq_list_lock > i_lock,
+ *   dq_list_lock > dq_state_lock
  *
  * Note that some things (eg. sb pointer, type, id) doesn't change during
  * the life of the dquot structure and so needn't to be protected by a lock
@@ -103,12 +106,7 @@
  * operation is just reading pointers from inode (or not using them at all) the
  * read lock is enough. If pointers are altered function must hold write lock
  * (these locking rules also apply for S_NOQUOTA flag in the inode - note that
- * for altering the flag i_mutex is also needed).  If operation is holding
- * reference to dquot in other way (e.g. quotactl ops) it must be guarded by
- * dqonoff_mutex.
- * This locking assures that:
- *   a) update/access to dquot pointers in inode is serialized
- *   b) everyone is guarded against invalidate_dquots()
+ * for altering the flag i_mutex is also needed).
  *
  * Each dquot has its dq_lock mutex. Locked dquots might not be referenced
  * from inodes (dquot_alloc_space() and such don't check the dq_lock).
@@ -122,10 +120,17 @@
  * Lock ordering (including related VFS locks) is the following:
  *   i_mutex > dqonoff_sem > journal_lock > dqptr_sem > dquot->dq_lock >
  *   dqio_mutex
+ * The lock ordering of dqptr_sem imposed by quota code is only dqonoff_sem >
+ * dqptr_sem. But filesystem has to count with the fact that functions such as
+ * dquot_alloc_space() acquire dqptr_sem and they usually have to be called
+ * from inside a transaction to keep filesystem consistency after a crash. Also
+ * filesystems usually want to do some IO on dquot from ->mark_dirty which is
+ * called with dqptr_sem held.
  * i_mutex on quota files is special (it's below dqio_mutex)
  */
 
 static DEFINE_SPINLOCK(dq_list_lock);
+static DEFINE_SPINLOCK(dq_state_lock);
 DEFINE_SPINLOCK(dq_data_lock);
 
 static char *quotatypes[] = INITQFNAMES;
@@ -428,7 +433,7 @@ static inline void do_destroy_dquot(struct dquot *dquot)
  * quota is disabled and pointers from inodes removed so there cannot be new
  * quota users. There can still be some users of quotas due to inodes being
  * just deleted or pruned by prune_icache() (those are not attached to any
- * list). We have to wait for such users.
+ * list) or parallel quotactl call. We have to wait for such users.
  */
 static void invalidate_dquots(struct super_block *sb, int type)
 {
@@ -600,7 +605,6 @@ static struct shrinker dqcache_shrinker = {
 /*
  * Put reference to dquot
  * NOTE: If you change this function please check whether dqput_blocks() works right...
- * MUST be called with either dqptr_sem or dqonoff_mutex held
  */
 void dqput(struct dquot *dquot)
 {
@@ -697,36 +701,30 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
 }
 
 /*
- * Check whether dquot is in memory.
- * MUST be called with either dqptr_sem or dqonoff_mutex held
- */
-int dquot_is_cached(struct super_block *sb, unsigned int id, int type)
-{
-	unsigned int hashent = hashfn(sb, id, type);
-	int ret = 0;
-
-        if (!sb_has_quota_active(sb, type))
-		return 0;
-	spin_lock(&dq_list_lock);
-	if (find_dquot(hashent, sb, id, type) != NODQUOT)
-		ret = 1;
-	spin_unlock(&dq_list_lock);
-	return ret;
-}
-
-/*
  * Get reference to dquot
- * MUST be called with either dqptr_sem or dqonoff_mutex held
+ *
+ * Locking is slightly tricky here. We are guarded from parallel quotaoff()
+ * destroying our dquot by:
+ *   a) checking for quota flags under dq_list_lock and
+ *   b) getting a reference to dquot before we release dq_list_lock
  */
 struct dquot *dqget(struct super_block *sb, unsigned int id, int type)
 {
 	unsigned int hashent = hashfn(sb, id, type);
-	struct dquot *dquot, *empty = NODQUOT;
+	struct dquot *dquot = NODQUOT, *empty = NODQUOT;
 
         if (!sb_has_quota_active(sb, type))
 		return NODQUOT;
 we_slept:
 	spin_lock(&dq_list_lock);
+	spin_lock(&dq_state_lock);
+	if (!sb_has_quota_active(sb, type)) {
+		spin_unlock(&dq_state_lock);
+		spin_unlock(&dq_list_lock);
+		goto out;
+	}
+	spin_unlock(&dq_state_lock);
+
 	if ((dquot = find_dquot(hashent, sb, id, type)) == NODQUOT) {
 		if (empty == NODQUOT) {
 			spin_unlock(&dq_list_lock);
@@ -735,6 +733,7 @@ we_slept:
 			goto we_slept;
 		}
 		dquot = empty;
+		empty = NODQUOT;
 		dquot->dq_id = id;
 		/* all dquots go on the inuse_list */
 		put_inuse(dquot);
@@ -749,8 +748,6 @@ we_slept:
 		dqstats.cache_hits++;
 		dqstats.lookups++;
 		spin_unlock(&dq_list_lock);
-		if (empty)
-			do_destroy_dquot(empty);
 	}
 	/* Wait for dq_lock - after this we know that either dquot_release() is already
 	 * finished or it will be canceled due to dq_count > 1 test */
@@ -758,11 +755,15 @@ we_slept:
 	/* Read the dquot and instantiate it (everything done only if needed) */
 	if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags) && sb->dq_op->acquire_dquot(dquot) < 0) {
 		dqput(dquot);
-		return NODQUOT;
+		dquot = NODQUOT;
+		goto out;
 	}
 #ifdef __DQUOT_PARANOIA
 	BUG_ON(!dquot->dq_sb);	/* Has somebody invalidated entry under us? */
 #endif
+out:
+	if (empty)
+		do_destroy_dquot(empty);
 
 	return dquot;
 }
@@ -1198,63 +1199,76 @@ static int info_bdq_free(struct dquot *dquot, qsize_t space)
 }
 /*
  *	Initialize quota pointers in inode
- *	Transaction must be started at entry
+ *	We do things in a bit complicated way but by that we avoid calling
+ *	dqget() and thus filesystem callbacks under dqptr_sem.
  */
 int dquot_initialize(struct inode *inode, int type)
 {
 	unsigned int id = 0;
 	int cnt, ret = 0;
+	struct dquot *got[MAXQUOTAS] = { NODQUOT, NODQUOT };
+	struct super_block *sb = inode->i_sb;
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
 	if (IS_NOQUOTA(inode))
 		return 0;
-	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+
+	/* First get references to structures we might need. */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		if (type != -1 && cnt != type)
+			continue;
+		switch (cnt) {
+		case USRQUOTA:
+			id = inode->i_uid;
+			break;
+		case GRPQUOTA:
+			id = inode->i_gid;
+			break;
+		}
+		got[cnt] = dqget(sb, id, cnt);
+	}
+
+	down_write(&sb_dqopt(sb)->dqptr_sem);
 	/* Having dqptr_sem we know NOQUOTA flags can't be altered... */
 	if (IS_NOQUOTA(inode))
 		goto out_err;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
+		/* Avoid races with quotaoff() */
+		if (!sb_has_quota_active(sb, cnt))
+			continue;
 		if (inode->i_dquot[cnt] == NODQUOT) {
-			switch (cnt) {
-				case USRQUOTA:
-					id = inode->i_uid;
-					break;
-				case GRPQUOTA:
-					id = inode->i_gid;
-					break;
-			}
-			inode->i_dquot[cnt] = dqget(inode->i_sb, id, cnt);
+			inode->i_dquot[cnt] = got[cnt];
+			got[cnt] = NODQUOT;
 		}
 	}
 out_err:
-	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	up_write(&sb_dqopt(sb)->dqptr_sem);
+	/* Drop unused references */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+		dqput(got[cnt]);
 	return ret;
 }
 
 /*
  * 	Release all quotas referenced by inode
- *	Transaction must be started at an entry
  */
-int dquot_drop_locked(struct inode *inode)
+int dquot_drop(struct inode *inode)
 {
 	int cnt;
+	struct dquot *put[MAXQUOTAS];
 
+	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (inode->i_dquot[cnt] != NODQUOT) {
-			dqput(inode->i_dquot[cnt]);
-			inode->i_dquot[cnt] = NODQUOT;
-		}
+		put[cnt] = inode->i_dquot[cnt];
+		inode->i_dquot[cnt] = NODQUOT;
 	}
-	return 0;
-}
-
-int dquot_drop(struct inode *inode)
-{
-	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	dquot_drop_locked(inode);
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+		dqput(put[cnt]);
 	return 0;
 }
 
@@ -1470,8 +1484,9 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 	qsize_t space;
 	struct dquot *transfer_from[MAXQUOTAS];
 	struct dquot *transfer_to[MAXQUOTAS];
-	int cnt, ret = NO_QUOTA, chuid = (iattr->ia_valid & ATTR_UID) && inode->i_uid != iattr->ia_uid,
-	    chgid = (iattr->ia_valid & ATTR_GID) && inode->i_gid != iattr->ia_gid;
+	int cnt, ret = QUOTA_OK;
+	int chuid = iattr->ia_valid & ATTR_UID && inode->i_uid != iattr->ia_uid,
+	    chgid = iattr->ia_valid & ATTR_GID && inode->i_gid != iattr->ia_gid;
 	char warntype_to[MAXQUOTAS];
 	char warntype_from_inodes[MAXQUOTAS], warntype_from_space[MAXQUOTAS];
 
@@ -1479,21 +1494,11 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
          * re-enter the quota code and are already holding the mutex */
 	if (IS_NOQUOTA(inode))
 		return QUOTA_OK;
-	/* Clear the arrays */
+	/* Initialize the arrays */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		transfer_to[cnt] = transfer_from[cnt] = NODQUOT;
+		transfer_from[cnt] = NODQUOT;
+		transfer_to[cnt] = NODQUOT;
 		warntype_to[cnt] = QUOTA_NL_NOWARN;
-	}
-	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	/* Now recheck reliably when holding dqptr_sem */
-	if (IS_NOQUOTA(inode)) {	/* File without quota accounting? */
-		up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		return QUOTA_OK;
-	}
-	/* First build the transfer_to list - here we can block on
-	 * reading/instantiating of dquots.  We know that the transaction for
-	 * us was already started so we don't violate lock ranking here */
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		switch (cnt) {
 			case USRQUOTA:
 				if (!chuid)
@@ -1507,6 +1512,13 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 				break;
 		}
 	}
+
+	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	/* Now recheck reliably when holding dqptr_sem */
+	if (IS_NOQUOTA(inode)) {	/* File without quota accounting? */
+		up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+		goto put_all;
+	}
 	spin_lock(&dq_data_lock);
 	space = inode_get_bytes(inode);
 	/* Build the transfer_from list and check the limits */
@@ -1517,7 +1529,7 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 		if (check_idq(transfer_to[cnt], 1, warntype_to + cnt) ==
 		    NO_QUOTA || check_bdq(transfer_to[cnt], space, 0,
 		    warntype_to + cnt) == NO_QUOTA)
-			goto warn_put_all;
+			goto over_quota;
 	}
 
 	/*
@@ -1545,28 +1557,37 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 
 		inode->i_dquot[cnt] = transfer_to[cnt];
 	}
-	ret = QUOTA_OK;
-warn_put_all:
 	spin_unlock(&dq_data_lock);
+	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+
 	/* Dirtify all the dquots - this can block when journalling */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (transfer_from[cnt])
 			mark_dquot_dirty(transfer_from[cnt]);
-		if (transfer_to[cnt])
+		if (transfer_to[cnt]) {
 			mark_dquot_dirty(transfer_to[cnt]);
+			/* The reference we got is transferred to the inode */
+			transfer_to[cnt] = NODQUOT;
+		}
 	}
+warn_put_all:
 	flush_warnings(transfer_to, warntype_to);
 	flush_warnings(transfer_from, warntype_from_inodes);
 	flush_warnings(transfer_from, warntype_from_space);
-	
+put_all:
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (ret == QUOTA_OK && transfer_from[cnt] != NODQUOT)
-			dqput(transfer_from[cnt]);
-		if (ret == NO_QUOTA && transfer_to[cnt] != NODQUOT)
-			dqput(transfer_to[cnt]);
+		dqput(transfer_from[cnt]);
+		dqput(transfer_to[cnt]);
 	}
-	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
+over_quota:
+	spin_unlock(&dq_data_lock);
+	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	/* Clear dquot pointers we don't want to dqput() */
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
+		transfer_from[cnt] = NODQUOT;
+	ret = NO_QUOTA;
+	goto warn_put_all;
 }
 
 /* Wrapper for transferring ownership of an inode */
@@ -1651,19 +1672,24 @@ int vfs_quota_disable(struct super_block *sb, int type, unsigned int flags)
 			continue;
 
 		if (flags & DQUOT_SUSPENDED) {
+			spin_lock(&dq_state_lock);
 			dqopt->flags |=
 				dquot_state_flag(DQUOT_SUSPENDED, cnt);
+			spin_unlock(&dq_state_lock);
 		} else {
+			spin_lock(&dq_state_lock);
 			dqopt->flags &= ~dquot_state_flag(flags, cnt);
 			/* Turning off suspended quotas? */
 			if (!sb_has_quota_loaded(sb, cnt) &&
 			    sb_has_quota_suspended(sb, cnt)) {
 				dqopt->flags &=	~dquot_state_flag(
 							DQUOT_SUSPENDED, cnt);
+				spin_unlock(&dq_state_lock);
 				iput(dqopt->files[cnt]);
 				dqopt->files[cnt] = NULL;
 				continue;
 			}
+			spin_unlock(&dq_state_lock);
 		}
 
 		/* We still have to keep quota loaded? */
@@ -1830,7 +1856,9 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 	}
 	mutex_unlock(&dqopt->dqio_mutex);
 	mutex_unlock(&inode->i_mutex);
+	spin_lock(&dq_state_lock);
 	dqopt->flags |= dquot_state_flag(flags, type);
+	spin_unlock(&dq_state_lock);
 
 	add_dquot_ref(sb, type);
 	mutex_unlock(&dqopt->dqonoff_mutex);
@@ -1872,9 +1900,11 @@ static int vfs_quota_on_remount(struct super_block *sb, int type)
 	}
 	inode = dqopt->files[type];
 	dqopt->files[type] = NULL;
+	spin_lock(&dq_state_lock);
 	flags = dqopt->flags & dquot_state_flag(DQUOT_USAGE_ENABLED |
 						DQUOT_LIMITS_ENABLED, type);
 	dqopt->flags &= ~dquot_state_flag(DQUOT_STATE_FLAGS, type);
+	spin_unlock(&dq_state_lock);
 	mutex_unlock(&dqopt->dqonoff_mutex);
 
 	flags = dquot_generic_flag(flags, type);
@@ -1952,7 +1982,9 @@ int vfs_quota_enable(struct inode *inode, int type, int format_id,
 			ret = -EBUSY;
 			goto out_lock;
 		}
+		spin_lock(&dq_state_lock);
 		sb_dqopt(sb)->flags |= dquot_state_flag(flags, type);
+		spin_unlock(&dq_state_lock);
 out_lock:
 		mutex_unlock(&dqopt->dqonoff_mutex);
 		return ret;
@@ -2039,14 +2071,12 @@ int vfs_get_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *d
 {
 	struct dquot *dquot;
 
-	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
-	if (!(dquot = dqget(sb, id, type))) {
-		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
+	dquot = dqget(sb, id, type);
+	if (dquot == NODQUOT)
 		return -ESRCH;
-	}
 	do_get_dqblk(dquot, di);
 	dqput(dquot);
-	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
+
 	return 0;
 }
 
@@ -2130,7 +2160,6 @@ int vfs_set_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *d
 	struct dquot *dquot;
 	int rc;
 
-	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
 	dquot = dqget(sb, id, type);
 	if (!dquot) {
 		rc = -ESRCH;
@@ -2139,7 +2168,6 @@ int vfs_set_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *d
 	rc = do_set_dqblk(dquot, di);
 	dqput(dquot);
 out:
-	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return rc;
 }
 
@@ -2370,11 +2398,9 @@ EXPORT_SYMBOL(dquot_release);
 EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 EXPORT_SYMBOL(dquot_initialize);
 EXPORT_SYMBOL(dquot_drop);
-EXPORT_SYMBOL(dquot_drop_locked);
 EXPORT_SYMBOL(vfs_dq_drop);
 EXPORT_SYMBOL(dqget);
 EXPORT_SYMBOL(dqput);
-EXPORT_SYMBOL(dquot_is_cached);
 EXPORT_SYMBOL(dquot_alloc_space);
 EXPORT_SYMBOL(dquot_alloc_inode);
 EXPORT_SYMBOL(dquot_free_space);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 21b781a..0b35b3a 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -24,10 +24,8 @@ void sync_dquots(struct super_block *sb, int type);
 
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
-int dquot_drop_locked(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
 void dqput(struct dquot *dquot);
-int dquot_is_cached(struct super_block *sb, unsigned int id, int type);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
 		      unsigned long priv);
-- 
1.6.0.2

