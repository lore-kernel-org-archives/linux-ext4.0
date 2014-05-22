From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH] quota: remove dqptr_sem for scalability
Date: Thu, 22 May 2014 18:47:22 +0800
Message-ID: <537DD5BA.1050105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: yawei.niu@intel.com, andreas.dilger@intel.com, jack@suse.cz,
	lai.siyao@intel.com
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:44960 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaEVKrv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 May 2014 06:47:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are several global locks in the VFS quota code which hurts
performance a lot when quota accounting enabled, dqptr_sem is the major one.

This patch tries to make the VFS quota code scalable with minimal changes.

Following tests (mdtest & dbench) were running over ext4 fs in a
centos6.5 vm (8 cpus, 4G mem, kenrel: 3.15.0-rc5+), and the result shows
the patch relieved the lock congestion a lot.

=== mdtest (http://sourceforge.net/projects/mdtest/)

mdtest creation:
threads              1       2       4       8       16
disabled quota:   40045    78379   128652   89176   103666
enabled quota:    34939    46725   24095    14321   16510
patched/disabled: 39120    75325   124181   72012   86622
patched/enabled:  34769    67086   111854   85923   87982

mdtest unlink:
threads              1       2       4       8       16
disabled quota:   91587    148808  227496   193661  190477
enabled quota:    72426    48726   14845    12825   15907
patched/disabled: 85246    146369  228514   194053  192407
patched/enabled:  78257    124332  166146   180874  174715

=== dbench test (8 threads)

disabled quota:

 Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                     32     3.585     8.437
 Flush                    82625     3.797   207.561
 Close                   865785     0.004     1.353
 LockX                     3840     0.005     0.182
 Mkdir                       16     0.005     0.007
 Rename                   49897     0.050     6.085
 ReadX                  1847719     0.006     6.332
 WriteX                  588019     0.033     6.968
 Unlink                  238061     0.050     6.537
 UnlockX                   3840     0.004     0.302
 FIND_FIRST              413054     0.024     2.920
 SET_FILE_INFORMATION     95961     0.035     6.998
 QUERY_FILE_INFORMATION  187253     0.003     0.478
 QUERY_PATH_INFORMATION 1068225     0.010     6.211
 QUERY_FS_INFORMATION    195932     0.006     0.541
 NTCreateX              1178614     0.021    64.684

Throughput 616.998 MB/sec  8 clients  8 procs  max_latency=207.575 ms

enabled quota:

 Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                     16    11.240    54.888
 Flush                    61421     3.627   127.876
 Close                   643369     0.004     0.924
 LockX                     2848     0.005     0.253
 Mkdir                        8     0.005     0.008
 Rename                   37088     0.116     3.845
 ReadX                  1372315     0.007     5.024
 WriteX                  435537     0.106    18.304
 Unlink                  176928     0.351    29.266
 UnlockX                   2848     0.004     0.095
 FIND_FIRST              306847     0.024     1.689
 SET_FILE_INFORMATION     71406     0.040     8.933
 QUERY_FILE_INFORMATION  138904     0.003     0.421
 QUERY_PATH_INFORMATION  794000     0.011     4.027
 QUERY_FS_INFORMATION    145520     0.006     0.473
 NTCreateX               875964     0.072    52.923

Throughput 457.433 MB/sec  8 clients  8 procs  max_latency=127.902 ms

patched/disabled:

 Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                     32     3.332     8.210
 Flush                    82543     3.790   146.987
 Close                   865200     0.004     1.289
 LockX                     3836     0.005     0.142
 Mkdir                       16     0.008     0.038
 Rename                   49870     0.052     4.907
 ReadX                  1846334     0.006     6.107
 WriteX                  587645     0.033     8.086
 Unlink                  237737     0.052     6.440
 UnlockX                   3836     0.004     0.105
 FIND_FIRST              412704     0.024     1.597
 SET_FILE_INFORMATION     95948     0.034     7.854
 QUERY_FILE_INFORMATION  187179     0.003     0.408
 QUERY_PATH_INFORMATION 1067460     0.010     5.316
 QUERY_FS_INFORMATION    195706     0.006     0.613
 NTCreateX              1177689     0.021     6.521

Throughput 616.574 MB/sec  8 clients  8 procs  max_latency=147.007 ms

patched/enabled:

 Operation                Count    AvgLat    MaxLat
 --------------------------------------------------
 Deltree                     32     3.248     8.430
 Flush                    80481     3.908   241.537
 Close                   843781     0.004     0.561
 LockX                     3746     0.005     0.141
 Mkdir                       16     0.005     0.007
 Rename                   48642     0.051     6.466
 ReadX                  1800754     0.006    87.027
 WriteX                  573185     0.033     6.750
 Unlink                  231880     0.058    14.507
 UnlockX                   3746     0.004     0.103
 FIND_FIRST              402463     0.024     1.342
 SET_FILE_INFORMATION     93557     0.035    42.348
 QUERY_FILE_INFORMATION  182573     0.003     1.305
 QUERY_PATH_INFORMATION 1041026     0.010    86.289
 QUERY_FS_INFORMATION    190869     0.006     1.240
 NTCreateX              1148570     0.022     6.285

Throughput 602.147 MB/sec  8 clients  8 procs  max_latency=241.561 ms


[PATCH] quota: remove dqptr_sem for scalability

Remove dqptr_sem (but kept in struct quota_info to keep kernel ABI
unchanged), and the functionality of this lock is implemented by
other locks:
* i_dquot is protected by i_lock, however only this pointer, the
  content of this struct is by dq_data_lock.
* Q_GETFMT is now protected with dqonoff_mutex instead of dqptr_sem.
* Small changes in __dquot_initialize() to avoid unnecessary
  dqget()/dqput() calls.

Signed-off-by: Lai Siyao <lai.siyao@intel.com>
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
---
 fs/quota/dquot.c   |  171 ++++++++++++++++++++++++++-------------------------
 fs/quota/quota.c   |    6 +-
 fs/stat.c          |    7 ++-
 fs/super.c         |    1 -
 include/linux/fs.h |    1 +
 5 files changed, 97 insertions(+), 89 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 9cd5f63..99394b2 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -83,26 +83,21 @@
 /*
  * There are three quota SMP locks. dq_list_lock protects all lists with quotas
  * and quota formats.
- * dq_data_lock protects data from dq_dqb and also mem_dqinfo structures and
- * also guards consistency of dquot->dq_dqb with inode->i_blocks, i_bytes.
- * i_blocks and i_bytes updates itself are guarded by i_lock acquired directly
- * in inode_add_bytes() and inode_sub_bytes(). dq_state_lock protects
- * modifications of quota state (on quotaon and quotaoff) and readers who care
- * about latest values take it as well.
- *
- * The spinlock ordering is hence: dq_data_lock > dq_list_lock > i_lock,
+ * dq_data_lock protects data from dq_dqb and also mem_dqinfo structures.
+ * dq_state_lock protects modifications of quota state (on quotaon and quotaoff)
+ * and readers who care about latest values take it as well.
+ * 
+ * The spinlock ordering is hence: i_lock > dq_data_lock > dq_list_lock,
  *   dq_list_lock > dq_state_lock
  *
  * Note that some things (eg. sb pointer, type, id) doesn't change during
  * the life of the dquot structure and so needn't to be protected by a lock
  *
- * Any operation working on dquots via inode pointers must hold dqptr_sem.  If
- * operation is just reading pointers from inode (or not using them at all) the
- * read lock is enough. If pointers are altered function must hold write lock.
+ * Any operation working on dquots via inode pointers must hold i_lock.
  * Special care needs to be taken about S_NOQUOTA inode flag (marking that
  * inode is a quota file). Functions adding pointers from inode to dquots have
- * to check this flag under dqptr_sem and then (if S_NOQUOTA is not set) they
- * have to do all pointer modifications before dropping dqptr_sem. This makes
+ * to check this flag under i_lock and then (if S_NOQUOTA is not set) they
+ * have to do all pointer modifications before dropping i_lock. This makes
  * sure they cannot race with quotaon which first sets S_NOQUOTA flag and
  * then drops all pointers to dquots from an inode.
  *
@@ -116,16 +111,9 @@
  * spinlock to internal buffers before writing.
  *
  * Lock ordering (including related VFS locks) is the following:
- *   dqonoff_mutex > i_mutex > journal_lock > dqptr_sem > dquot->dq_lock >
- *   dqio_mutex
+ *   i_mutex > dqonoff_sem > journal_lock > dquot->dq_lock > dqio_mutex
  * dqonoff_mutex > i_mutex comes from dquot_quota_sync, dquot_enable, etc.
- * The lock ordering of dqptr_sem imposed by quota code is only dqonoff_sem >
- * dqptr_sem. But filesystem has to count with the fact that functions such as
- * dquot_alloc_space() acquire dqptr_sem and they usually have to be called
- * from inside a transaction to keep filesystem consistency after a crash. Also
- * filesystems usually want to do some IO on dquot from ->mark_dirty which is
- * called with dqptr_sem held.
- */
+  */
 
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_list_lock);
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_state_lock);
@@ -974,7 +962,6 @@ static inline int dqput_blocks(struct dquot *dquot)
 /*
  * Remove references to dquots from inode and add dquot to list for freeing
  * if we have the last reference to dquot
- * We can't race with anybody because we hold dqptr_sem for writing...
  */
 static int remove_inode_dquot_ref(struct inode *inode, int type,
 				  struct list_head *tofree_head)
@@ -1035,13 +1022,15 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 		 *  We have to scan also I_NEW inodes because they can already
 		 *  have quota pointer initialized. Luckily, we need to touch
 		 *  only quota pointers and these have separate locking
-		 *  (dqptr_sem).
+		 *  (i_lock).
 		 */
+		spin_lock(&inode->i_lock);
 		if (!IS_NOQUOTA(inode)) {
 			if (unlikely(inode_get_rsv_space(inode) > 0))
 				reserved = 1;
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
+		spin_unlock(&inode->i_lock);
 	}
 	spin_unlock(&inode_sb_list_lock);
 #ifdef CONFIG_QUOTA_DEBUG
@@ -1059,9 +1048,7 @@ static void drop_dquot_ref(struct super_block *sb, int type)
 	LIST_HEAD(tofree_head);
 
 	if (sb->dq_op) {
-		down_write(&sb_dqopt(sb)->dqptr_sem);
 		remove_dquot_ref(sb, type, &tofree_head);
-		up_write(&sb_dqopt(sb)->dqptr_sem);
 		put_dquot_list(&tofree_head);
 	}
 }
@@ -1392,25 +1379,27 @@ static int dquot_active(const struct inode *inode)
 /*
  * Initialize quota pointers in inode
  *
- * We do things in a bit complicated way but by that we avoid calling
- * dqget() and thus filesystem callbacks under dqptr_sem.
- *
  * It is better to call this function outside of any transaction as it
  * might need a lot of space in journal for dquot structure allocation.
  */
 static void __dquot_initialize(struct inode *inode, int type)
 {
-	int cnt;
-	struct dquot *got[MAXQUOTAS];
+	int cnt, dq_get = 0;
+	struct dquot *got[MAXQUOTAS] = { NULL, NULL };
 	struct super_block *sb = inode->i_sb;
 	qsize_t rsv;
 
-	/* First test before acquiring mutex - solves deadlocks when we
-         * re-enter the quota code and are already holding the mutex */
 	if (!dquot_active(inode))
 		return;
 
-	/* First get references to structures we might need. */
+	/* In most case, the i_dquot should have been initialized, except
+	 * the newly allocated one. We'd always try to skip the dqget() and
+	 * dqput() calls to avoid unnecessary global lock contention. */
+	if (!(inode->i_state & I_NEW))
+		goto init_idquot;
+
+get_dquots:
+	dq_get = 1;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		struct kqid qid;
 		got[cnt] = NULL;
@@ -1426,8 +1415,8 @@ static void __dquot_initialize(struct inode *inode, int type)
 		}
 		got[cnt] = dqget(sb, qid);
 	}
-
-	down_write(&sb_dqopt(sb)->dqptr_sem);
+init_idquot:
+	spin_lock(&inode->i_lock);
 	if (IS_NOQUOTA(inode))
 		goto out_err;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -1437,9 +1426,13 @@ static void __dquot_initialize(struct inode *inode, int type)
 		if (!sb_has_quota_active(sb, cnt))
 			continue;
 		/* We could race with quotaon or dqget() could have failed */
-		if (!got[cnt])
+		if (!got[cnt] && dq_get)
 			continue;
 		if (!inode->i_dquot[cnt]) {
+			if (dq_get == 0) {
+				spin_unlock(&inode->i_lock);
+				goto get_dquots;
+			}
 			inode->i_dquot[cnt] = got[cnt];
 			got[cnt] = NULL;
 			/*
@@ -1455,7 +1448,7 @@ static void __dquot_initialize(struct inode *inode, int type)
 		}
 	}
 out_err:
-	up_write(&sb_dqopt(sb)->dqptr_sem);
+	spin_unlock(&inode->i_lock);
 	/* Drop unused references */
 	dqput_all(got);
 }
@@ -1474,12 +1467,12 @@ static void __dquot_drop(struct inode *inode)
 	int cnt;
 	struct dquot *put[MAXQUOTAS];
 
-	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_lock(&inode->i_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		put[cnt] = inode->i_dquot[cnt];
 		inode->i_dquot[cnt] = NULL;
 	}
-	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_unlock(&inode->i_lock);
 	dqput_all(put);
 }
 
@@ -1519,36 +1512,57 @@ static qsize_t *inode_reserved_space(struct inode * inode)
 	return inode->i_sb->dq_op->get_reserved_space(inode);
 }
 
+static inline void __inode_add_rsv_space(struct inode *inode, qsize_t number)
+{
+	*inode_reserved_space(inode) += number;
+}
+
 void inode_add_rsv_space(struct inode *inode, qsize_t number)
 {
 	spin_lock(&inode->i_lock);
-	*inode_reserved_space(inode) += number;
+	__inode_add_rsv_space(inode, number);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(inode_add_rsv_space);
 
+static inline void __inode_claim_rsv_space(struct inode *inode, qsize_t number)
+{
+ 	*inode_reserved_space(inode) -= number;
+ 	__inode_add_bytes(inode, number);
+}
+
 void inode_claim_rsv_space(struct inode *inode, qsize_t number)
 {
 	spin_lock(&inode->i_lock);
-	*inode_reserved_space(inode) -= number;
-	__inode_add_bytes(inode, number);
+	__inode_claim_rsv_space(inode, number);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(inode_claim_rsv_space);
 
-void inode_reclaim_rsv_space(struct inode *inode, qsize_t number)
+static inline void __inode_reclaim_rsv_space(struct inode *inode,
+					     qsize_t number)
 {
-	spin_lock(&inode->i_lock);
 	*inode_reserved_space(inode) += number;
 	__inode_sub_bytes(inode, number);
+}
+
+void inode_reclaim_rsv_space(struct inode *inode, qsize_t number)
+{
+	spin_lock(&inode->i_lock);
+	__inode_reclaim_rsv_space(inode, number);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(inode_reclaim_rsv_space);
 
+static inline void __inode_sub_rsv_space(struct inode *inode, qsize_t number)
+{
+	*inode_reserved_space(inode) -= number;
+}
+
 void inode_sub_rsv_space(struct inode *inode, qsize_t number)
 {
 	spin_lock(&inode->i_lock);
-	*inode_reserved_space(inode) -= number;
+	__inode_sub_rsv_space(inode, number);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(inode_sub_rsv_space);
@@ -1559,9 +1573,8 @@ static qsize_t inode_get_rsv_space(struct inode *inode)
 
 	if (!inode->i_sb->dq_op->get_reserved_space)
 		return 0;
-	spin_lock(&inode->i_lock);
+
 	ret = *inode_reserved_space(inode);
-	spin_unlock(&inode->i_lock);
 	return ret;
 }
 
@@ -1569,17 +1582,17 @@ static void inode_incr_space(struct inode *inode, qsize_t number,
 				int reserve)
 {
 	if (reserve)
-		inode_add_rsv_space(inode, number);
+		__inode_add_rsv_space(inode, number);
 	else
-		inode_add_bytes(inode, number);
+		__inode_add_bytes(inode, number);
 }
 
 static void inode_decr_space(struct inode *inode, qsize_t number, int reserve)
 {
 	if (reserve)
-		inode_sub_rsv_space(inode, number);
+		__inode_sub_rsv_space(inode, number);
 	else
-		inode_sub_bytes(inode, number);
+		__inode_sub_bytes(inode, number);
 }
 
 /*
@@ -1602,10 +1615,6 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 	struct dquot **dquots = inode->i_dquot;
 	int reserve = flags & DQUOT_SPACE_RESERVE;
 
-	/*
-	 * First test before acquiring mutex - solves deadlocks when we
-	 * re-enter the quota code and are already holding the mutex
-	 */
 	if (!dquot_active(inode)) {
 		inode_incr_space(inode, number, reserve);
 		goto out;
@@ -1614,7 +1623,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warn[cnt].w_type = QUOTA_NL_NOWARN;
 
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_lock(&inode->i_lock);
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (!dquots[cnt])
@@ -1623,6 +1632,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 				!(flags & DQUOT_SPACE_WARN), &warn[cnt]);
 		if (ret && !(flags & DQUOT_SPACE_NOFAIL)) {
 			spin_unlock(&dq_data_lock);
+			spin_unlock(&inode->i_lock);
 			goto out_flush_warn;
 		}
 	}
@@ -1636,12 +1646,12 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 	}
 	inode_incr_space(inode, number, reserve);
 	spin_unlock(&dq_data_lock);
+	spin_unlock(&inode->i_lock);
 
 	if (reserve)
 		goto out_flush_warn;
 	mark_all_dquot_dirty(dquots);
 out_flush_warn:
-	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	flush_warnings(warn);
 out:
 	return ret;
@@ -1657,13 +1667,12 @@ int dquot_alloc_inode(const struct inode *inode)
 	struct dquot_warn warn[MAXQUOTAS];
 	struct dquot * const *dquots = inode->i_dquot;
 
-	/* First test before acquiring mutex - solves deadlocks when we
-         * re-enter the quota code and are already holding the mutex */
 	if (!dquot_active(inode))
 		return 0;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warn[cnt].w_type = QUOTA_NL_NOWARN;
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+
+	spin_lock((spinlock_t *)&inode->i_lock);
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (!dquots[cnt])
@@ -1681,9 +1690,9 @@ int dquot_alloc_inode(const struct inode *inode)
 
 warn_put_all:
 	spin_unlock(&dq_data_lock);
+	spin_unlock((spinlock_t *)&inode->i_lock);
 	if (ret == 0)
 		mark_all_dquot_dirty(dquots);
-	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	flush_warnings(warn);
 	return ret;
 }
@@ -1701,7 +1710,7 @@ int dquot_claim_space_nodirty(struct inode *inode, qsize_t number)
 		return 0;
 	}
 
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_lock(&inode->i_lock);
 	spin_lock(&dq_data_lock);
 	/* Claim reserved quotas to allocated quotas */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -1710,10 +1719,10 @@ int dquot_claim_space_nodirty(struct inode *inode, qsize_t number)
 							number);
 	}
 	/* Update inode bytes */
-	inode_claim_rsv_space(inode, number);
+	__inode_claim_rsv_space(inode, number);
 	spin_unlock(&dq_data_lock);
+	spin_unlock(&inode->i_lock);
 	mark_all_dquot_dirty(inode->i_dquot);
-	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return 0;
 }
 EXPORT_SYMBOL(dquot_claim_space_nodirty);
@@ -1730,7 +1739,7 @@ void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number)
 		return;
 	}
 
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_lock(&inode->i_lock);
 	spin_lock(&dq_data_lock);
 	/* Claim reserved quotas to allocated quotas */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -1739,10 +1748,10 @@ void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number)
 						     number);
 	}
 	/* Update inode bytes */
-	inode_reclaim_rsv_space(inode, number);
+	__inode_reclaim_rsv_space(inode, number);
 	spin_unlock(&dq_data_lock);
+	spin_unlock(&inode->i_lock);
 	mark_all_dquot_dirty(inode->i_dquot);
-	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return;
 }
 EXPORT_SYMBOL(dquot_reclaim_space_nodirty);
@@ -1757,14 +1766,12 @@ void __dquot_free_space(struct inode *inode, qsize_t number, int flags)
 	struct dquot **dquots = inode->i_dquot;
 	int reserve = flags & DQUOT_SPACE_RESERVE;
 
-	/* First test before acquiring mutex - solves deadlocks when we
-         * re-enter the quota code and are already holding the mutex */
 	if (!dquot_active(inode)) {
 		inode_decr_space(inode, number, reserve);
 		return;
 	}
 
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_lock(&inode->i_lock);
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		int wtype;
@@ -1782,12 +1789,12 @@ void __dquot_free_space(struct inode *inode, qsize_t number, int flags)
 	}
 	inode_decr_space(inode, number, reserve);
 	spin_unlock(&dq_data_lock);
+	spin_unlock(&inode->i_lock);
 
 	if (reserve)
-		goto out_unlock;
+		goto out;
 	mark_all_dquot_dirty(dquots);
-out_unlock:
-	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+out:
 	flush_warnings(warn);
 }
 EXPORT_SYMBOL(__dquot_free_space);
@@ -1801,12 +1808,10 @@ void dquot_free_inode(const struct inode *inode)
 	struct dquot_warn warn[MAXQUOTAS];
 	struct dquot * const *dquots = inode->i_dquot;
 
-	/* First test before acquiring mutex - solves deadlocks when we
-         * re-enter the quota code and are already holding the mutex */
 	if (!dquot_active(inode))
 		return;
 
-	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_lock((spinlock_t *)&inode->i_lock);
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		int wtype;
@@ -1820,8 +1825,8 @@ void dquot_free_inode(const struct inode *inode)
 		dquot_decr_inodes(dquots[cnt], 1);
 	}
 	spin_unlock(&dq_data_lock);
+	spin_unlock((spinlock_t *)&inode->i_lock);
 	mark_all_dquot_dirty(dquots);
-	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	flush_warnings(warn);
 }
 EXPORT_SYMBOL(dquot_free_inode);
@@ -1847,8 +1852,6 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 	struct dquot_warn warn_from_inodes[MAXQUOTAS];
 	struct dquot_warn warn_from_space[MAXQUOTAS];
 
-	/* First test before acquiring mutex - solves deadlocks when we
-         * re-enter the quota code and are already holding the mutex */
 	if (IS_NOQUOTA(inode))
 		return 0;
 	/* Initialize the arrays */
@@ -1857,9 +1860,9 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 		warn_from_inodes[cnt].w_type = QUOTA_NL_NOWARN;
 		warn_from_space[cnt].w_type = QUOTA_NL_NOWARN;
 	}
-	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_lock(&inode->i_lock);
 	if (IS_NOQUOTA(inode)) {	/* File without quota accounting? */
-		up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+		spin_unlock(&inode->i_lock);
 		return 0;
 	}
 	spin_lock(&dq_data_lock);
@@ -1916,7 +1919,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 		inode->i_dquot[cnt] = transfer_to[cnt];
 	}
 	spin_unlock(&dq_data_lock);
-	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_unlock(&inode->i_lock);
 
 	mark_all_dquot_dirty(transfer_from);
 	mark_all_dquot_dirty(transfer_to);
@@ -1930,7 +1933,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 	return 0;
 over_quota:
 	spin_unlock(&dq_data_lock);
-	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	spin_unlock(&inode->i_lock);
 	flush_warnings(warn_to);
 	return ret;
 }
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 2b363e2..e4851cb 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -79,13 +79,13 @@ static int quota_getfmt(struct super_block *sb, int type, void __user *addr)
 {
 	__u32 fmt;
 
-	down_read(&sb_dqopt(sb)->dqptr_sem);
+	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
 	if (!sb_has_quota_active(sb, type)) {
-		up_read(&sb_dqopt(sb)->dqptr_sem);
+		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 		return -ESRCH;
 	}
 	fmt = sb_dqopt(sb)->info[type].dqi_format->qf_fmt_id;
-	up_read(&sb_dqopt(sb)->dqptr_sem);
+	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	if (copy_to_user(addr, &fmt, sizeof(fmt)))
 		return -EFAULT;
 	return 0;
diff --git a/fs/stat.c b/fs/stat.c
index ae0c3ce..b0e6898 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -488,12 +488,17 @@ void inode_sub_bytes(struct inode *inode, loff_t bytes)
 
 EXPORT_SYMBOL(inode_sub_bytes);
 
+loff_t __inode_get_bytes(struct inode *inode)
+{
+	return (((loff_t)inode->i_blocks) << 9) + inode->i_bytes;
+}
+
 loff_t inode_get_bytes(struct inode *inode)
 {
 	loff_t ret;
 
 	spin_lock(&inode->i_lock);
-	ret = (((loff_t)inode->i_blocks) << 9) + inode->i_bytes;
+	ret = __inode_get_bytes(inode);
 	spin_unlock(&inode->i_lock);
 	return ret;
 }
diff --git a/fs/super.c b/fs/super.c
index 48377f7..a97aecf 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -214,7 +214,6 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
 	mutex_init(&s->s_dquot.dqio_mutex);
 	mutex_init(&s->s_dquot.dqonoff_mutex);
-	init_rwsem(&s->s_dquot.dqptr_sem);
 	s->s_maxbytes = MAX_NON_LFS;
 	s->s_op = &default_op;
 	s->s_time_gran = 1000000000;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8780312..cd2f427 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2518,6 +2518,7 @@ void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void __inode_sub_bytes(struct inode *inode, loff_t bytes);
 void inode_sub_bytes(struct inode *inode, loff_t bytes);
+loff_t __inode_get_bytes(struct inode *inode);
 loff_t inode_get_bytes(struct inode *inode);
 void inode_set_bytes(struct inode *inode, loff_t bytes);
 
-- 
1.7.1

