From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH V5 1/5] quota: Add reservation support for delayed
	block allocation
Date: Tue, 13 Jan 2009 16:42:55 -0800
Message-ID: <1231893775.8719.22.camel@mingming-laptop>
References: <1231216808.9267.22.camel@mingming-laptop>
	 <20090106100645.GH10705@duck.suse.cz>
	 <1231805946.6752.17.camel@mingming-laptop>
	 <20090113153748.GE10064@duck.suse.cz>
	 <1231872797.8719.6.camel@mingming-laptop>
	 <20090113190931.GI10064@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ECs7TLUzRUc3L/TIsVX+"
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:47053 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZANAm6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jan 2009 19:42:58 -0500
In-Reply-To: <20090113190931.GI10064@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-ECs7TLUzRUc3L/TIsVX+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


在 2009-01-13二的 20:09 +0100，Jan Kara写道：
> On Tue 13-01-09 10:53:17, Mingming Cao wrote:
> > 在 2009-01-13二的 16:37 +0100，Jan Kara写道：
> > > On Mon 12-01-09 16:19:06, Mingming Cao wrote:
> > > > Thanks for your review and suggestions. All points are taken. I have
> > > > updated the quota patches.I am attaching the updated patch here just for
> > > > your review.
> > > > 
> > > > I am waiting for the ext4 tree to updated to rebase the whole series
> > > > against 2.6.29-rc1 plus ext4 patch queue.  
> > > > 
> > >   <snip>
> > > > Quota: Add quota reservation support
> > > > 
> > > > Delayed allocation defers the block allocation at the dirty pages
> > > > flush-out time, doing quota charge/check at that time is too late.
> > > > But we can't charge the quota blocks until blocks are really allocated,
> > > > otherwise users could get overcharged after reboot from system crash.
> > > > 
> > > > This patch adds quota reservation for delayed llocation. Quota blocks
> > > > are reserved in memory, inode and quota won't gets dirtied until later
> > > > block allocation time.
> > > > 
> > > > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > >   The patch is fine. You can add
> > > 
> > >   Acked-by: Jan Kara <jack@suse.cz>
> > > 
> > >   How do you want to merge the patches? Via ext4 patch queue?
> > > There's one generic quota patch that I also need to push to fix some OCFS2
> > > issue and it collides with your patchset. And also there're further
> > > cleanups in quota code which are long overdue which I want to base on all
> > > other patches. So I've decided to setup quota git tree. I'll pull in your
> > > two VFS quota patches. Will that work for you?
> > 
> > I think a quota tree is the best place to hold all these quota changes.
> > The ext4 part probably make sense to stay together with the vfs changes,
> > but it will need to coordinate with Ted's ext4 tree.  Ted, what do you
> > think?
>   Yes. The best would be if could pull quota changes from my tree but you
> could also just carry your two patches and only leave merging them with
> vanilla to me.
> 
Sure, that works for me.

> > BTW, there are other two quota cleanup patches that you have already
> > acked. I will sent the 2.6.29-rc1 based version.
>   Yes. Thanks.
> 

Attached are all the 5 2.6.29-rc1 based patches, including the two
cleanups.

Thanks!

Mingming

--=-ECs7TLUzRUc3L/TIsVX+
Content-Disposition: attachment; filename=quota-make-reservation-vfs.patch
Content-Type: text/x-patch; name=quota-make-reservation-vfs.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Quota: Add quota reservation support

Delayed allocation defers the block allocation at the dirty pages
flush-out time, doing quota charge/check at that time is too late.
But we can't charge the quota blocks until blocks are really allocated,
otherwise users could get overcharged after reboot from system crash.

This patch adds quota reservation for delayed llocation. Quota blocks
are reserved in memory, inode and quota won't gets dirtied until later
block allocation time.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>


---
 fs/dquot.c               |  117 ++++++++++++++++++++++++++++++++++-------------
 include/linux/quota.h    |    3 +
 include/linux/quotaops.h |   21 ++++++++
 3 files changed, 110 insertions(+), 31 deletions(-)

Index: linux-2.6.29-rc1/fs/dquot.c
===================================================================
--- linux-2.6.29-rc1.orig/fs/dquot.c	2009-01-10 15:43:05.000000000 -0800
+++ linux-2.6.29-rc1/fs/dquot.c	2009-01-12 16:28:34.000000000 -0800
@@ -898,6 +898,11 @@ static inline void dquot_incr_space(stru
 	dquot->dq_dqb.dqb_curspace += number;
 }
 
+static inline void dquot_resv_space(struct dquot *dquot, qsize_t number)
+{
+	dquot->dq_dqb.dqb_rsvspace += number;
+}
+
 static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 {
 	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
@@ -1067,7 +1072,11 @@ err_out:
 	kfree_skb(skb);
 }
 #endif
-
+/*
+ * Write warnings to the console and send warning messages over netlink.
+ *
+ * Note that this function can sleep.
+ */
 static inline void flush_warnings(struct dquot * const *dquots, char *warntype)
 {
 	int i;
@@ -1128,13 +1137,18 @@ static int check_idq(struct dquot *dquot
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
@@ -1142,7 +1156,7 @@ static int check_bdq(struct dquot *dquot
 	}
 
 	if (dquot->dq_dqb.dqb_bsoftlimit &&
-	    dquot->dq_dqb.dqb_curspace + space > dquot->dq_dqb.dqb_bsoftlimit &&
+	    tspace > dquot->dq_dqb.dqb_bsoftlimit &&
 	    dquot->dq_dqb.dqb_btime && get_seconds() >= dquot->dq_dqb.dqb_btime &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
@@ -1151,7 +1165,7 @@ static int check_bdq(struct dquot *dquot
 	}
 
 	if (dquot->dq_dqb.dqb_bsoftlimit &&
-	    dquot->dq_dqb.dqb_curspace + space > dquot->dq_dqb.dqb_bsoftlimit &&
+	    tspace > dquot->dq_dqb.dqb_bsoftlimit &&
 	    dquot->dq_dqb.dqb_btime == 0) {
 		if (!prealloc) {
 			*warntype = QUOTA_NL_BSOFTWARN;
@@ -1292,51 +1306,92 @@ void vfs_dq_drop(struct inode *inode)
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
+	if (!reserve)
+		inode_add_bytes(inode, number);
+out_unlock:
 	spin_unlock(&dq_data_lock);
-	if (ret == QUOTA_OK)
-		/* Dirtify all the dquots - this can block when journalling */
-		for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-			if (inode->i_dquot[cnt])
-				mark_dquot_dirty(inode->i_dquot[cnt]);
 	flush_warnings(inode->i_dquot, warntype);
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
+	if (IS_NOQUOTA(inode)) {
+		inode_add_bytes(inode, number);
+		goto out;
+	}
+
+	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	if (IS_NOQUOTA(inode)) {
+		inode_add_bytes(inode, number);
+		goto out_unlock;
+	}
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
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+out:
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
+	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
+out:
 	return ret;
 }
+EXPORT_SYMBOL(dquot_reserve_space);
 
 /*
  * This operation can block, but only after everything is updated
@@ -2025,7 +2080,7 @@ static void do_get_dqblk(struct dquot *d
 	spin_lock(&dq_data_lock);
 	di->dqb_bhardlimit = stoqb(dm->dqb_bhardlimit);
 	di->dqb_bsoftlimit = stoqb(dm->dqb_bsoftlimit);
-	di->dqb_curspace = dm->dqb_curspace;
+	di->dqb_curspace = dm->dqb_curspace + dm->dqb_rsvspace;
 	di->dqb_ihardlimit = dm->dqb_ihardlimit;
 	di->dqb_isoftlimit = dm->dqb_isoftlimit;
 	di->dqb_curinodes = dm->dqb_curinodes;
@@ -2067,7 +2122,7 @@ static int do_set_dqblk(struct dquot *dq
 
 	spin_lock(&dq_data_lock);
 	if (di->dqb_valid & QIF_SPACE) {
-		dm->dqb_curspace = di->dqb_curspace;
+		dm->dqb_curspace = di->dqb_curspace - dm->dqb_rsvspace;
 		check_blim = 1;
 		__set_bit(DQ_LASTSET_B + QIF_SPACE_B, &dquot->dq_flags);
 	}
Index: linux-2.6.29-rc1/include/linux/quota.h
===================================================================
--- linux-2.6.29-rc1.orig/include/linux/quota.h	2009-01-10 15:43:05.000000000 -0800
+++ linux-2.6.29-rc1/include/linux/quota.h	2009-01-12 16:28:34.000000000 -0800
@@ -198,6 +198,7 @@ struct mem_dqblk {
 	qsize_t dqb_bhardlimit;	/* absolute limit on disk blks alloc */
 	qsize_t dqb_bsoftlimit;	/* preferred limit on disk blks */
 	qsize_t dqb_curspace;	/* current used space */
+	qsize_t dqb_rsvspace;   /* current reserved space for delalloc*/
 	qsize_t dqb_ihardlimit;	/* absolute limit on allocated inodes */
 	qsize_t dqb_isoftlimit;	/* preferred inode limit */
 	qsize_t dqb_curinodes;	/* current # allocated inodes */
@@ -308,6 +309,8 @@ struct dquot_operations {
 	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
 	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
 	int (*write_info) (struct super_block *, int);	/* Write of quota "superblock" */
+	/* reserve quota for delayed block allocation */
+	int (*reserve_space) (struct inode *, qsize_t, int);
 };
 
 /* Operations handling requests from userspace */
Index: linux-2.6.29-rc1/include/linux/quotaops.h
===================================================================
--- linux-2.6.29-rc1.orig/include/linux/quotaops.h	2009-01-10 15:43:05.000000000 -0800
+++ linux-2.6.29-rc1/include/linux/quotaops.h	2009-01-12 16:28:34.000000000 -0800
@@ -185,6 +185,16 @@ static inline int vfs_dq_alloc_space(str
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
@@ -341,6 +351,11 @@ static inline int vfs_dq_alloc_space(str
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
@@ -378,6 +393,12 @@ static inline int vfs_dq_alloc_block(str
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

--=-ECs7TLUzRUc3L/TIsVX+
Content-Disposition: attachment; filename=quota-claim-reservation-vfs.patch
Content-Type: text/x-patch; name=quota-claim-reservation-vfs.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

quota: Add quota reservation claim and released operations

Reserved quota will be claimed at the block allocation time. Over-booked
quota could be returned back with the release callback function.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/dquot.c               |  110 +++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/quota.h    |    6 ++
 include/linux/quotaops.h |   53 ++++++++++++++++++++++
 3 files changed, 165 insertions(+), 4 deletions(-)

Index: linux-2.6.29-rc1/include/linux/quota.h
===================================================================
--- linux-2.6.29-rc1.orig/include/linux/quota.h	2009-01-12 16:28:34.000000000 -0800
+++ linux-2.6.29-rc1/include/linux/quota.h	2009-01-12 16:28:41.000000000 -0800
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
Index: linux-2.6.29-rc1/include/linux/quotaops.h
===================================================================
--- linux-2.6.29-rc1.orig/include/linux/quotaops.h	2009-01-12 16:28:34.000000000 -0800
+++ linux-2.6.29-rc1/include/linux/quotaops.h	2009-01-12 16:28:41.000000000 -0800
@@ -37,6 +37,11 @@ void dquot_destroy(struct dquot *dquot);
 int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_alloc_inode(const struct inode *inode, qsize_t number);
 
+int dquot_reserve_space(struct inode *inode, qsize_t number, int prealloc);
+int dquot_claim_space(struct inode *inode, qsize_t number);
+void dquot_release_reserved_space(struct inode *inode, qsize_t number);
+qsize_t dquot_get_reserved_space(struct inode *inode);
+
 int dquot_free_space(struct inode *inode, qsize_t number);
 int dquot_free_inode(const struct inode *inode, qsize_t number);
 
@@ -205,6 +210,31 @@ static inline int vfs_dq_alloc_inode(str
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
@@ -356,6 +386,17 @@ static inline int vfs_dq_reserve_space(s
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
@@ -399,6 +440,18 @@ static inline int vfs_dq_reserve_block(s
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
Index: linux-2.6.29-rc1/fs/dquot.c
===================================================================
--- linux-2.6.29-rc1.orig/fs/dquot.c	2009-01-12 16:28:34.000000000 -0800
+++ linux-2.6.29-rc1/fs/dquot.c	2009-01-12 16:28:41.000000000 -0800
@@ -903,6 +903,23 @@ static inline void dquot_resv_space(stru
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
@@ -1438,6 +1455,72 @@ warn_put_all:
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
@@ -1515,6 +1598,19 @@ int dquot_free_inode(const struct inode 
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
@@ -1522,7 +1618,8 @@ int dquot_free_inode(const struct inode 
  */
 int dquot_transfer(struct inode *inode, struct iattr *iattr)
 {
-	qsize_t space;
+	qsize_t space, cur_space;
+	qsize_t rsv_space = 0;
 	struct dquot *transfer_from[MAXQUOTAS];
 	struct dquot *transfer_to[MAXQUOTAS];
 	int cnt, ret = NO_QUOTA, chuid = (iattr->ia_valid & ATTR_UID) && inode->i_uid != iattr->ia_uid,
@@ -1563,7 +1660,9 @@ int dquot_transfer(struct inode *inode, 
 		}
 	}
 	spin_lock(&dq_data_lock);
-	space = inode_get_bytes(inode);
+	cur_space = inode_get_bytes(inode);
+	rsv_space = dquot_get_reserved_space(inode);
+	space = cur_space + rsv_space;
 	/* Build the transfer_from list and check the limits */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (transfer_to[cnt] == NODQUOT)
@@ -1592,11 +1691,14 @@ int dquot_transfer(struct inode *inode, 
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

--=-ECs7TLUzRUc3L/TIsVX+
Content-Disposition: attachment; filename=ext4-delalloc-quota-spt.patch
Content-Type: text/x-patch; name=ext4-delalloc-quota-spt.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

ext4: quota reservation for delayed allocation

Uses quota reservation/claim/release to handle quota properly for delayed
allocation in the three steps: 1) quotas are reserved when data being copied
to cache when block allocation is defered 2) when new blocks are allocated.
reserved quotas are converted to the real allocated quota, 2) over-booked
quotas for metadata blocks are released back.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/inode.c   |   36 +++++++++++++++++++++++++++++++++---
 fs/ext4/mballoc.c |   44 ++++++++++++++++++++++++++------------------
 fs/ext4/super.c   |    4 ++++
 4 files changed, 64 insertions(+), 21 deletions(-)

Index: linux-2.6.29-rc1/fs/ext4/inode.c
===================================================================
--- linux-2.6.29-rc1.orig/fs/ext4/inode.c	2009-01-10 15:43:05.000000000 -0800
+++ linux-2.6.29-rc1/fs/ext4/inode.c	2009-01-12 16:31:34.000000000 -0800
@@ -973,6 +973,17 @@ out:
 	return err;
 }
 
+qsize_t ext4_get_reserved_space(struct inode *inode)
+{
+	unsigned long long total;
+
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+	total = EXT4_I(inode)->i_reserved_data_blocks +
+		EXT4_I(inode)->i_reserved_meta_blocks;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	return (qsize_t)total << inode->i_blkbits;
+}
 /*
  * Calculate the number of metadata blocks need to reserve
  * to allocate @blocks for non extent file based file
@@ -1034,8 +1045,14 @@ static void ext4_da_update_reserve_space
 	/* update per-inode reservations */
 	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
 	EXT4_I(inode)->i_reserved_data_blocks -= used;
-
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	/*
+	 * free those over-booking quota for metadata blocks
+	 */
+
+	if (mdb_free)
+		vfs_dq_release_reservation_block(inode, mdb_free);
 }
 
 /*
@@ -1547,8 +1564,8 @@ static int ext4_journalled_write_end(str
 static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 {
 	int retries = 0;
-       struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-       unsigned long md_needed, mdblocks, total = 0;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	unsigned long md_needed, mdblocks, total = 0;
 
 	/*
 	 * recalculate the amount of metadata blocks to reserve
@@ -1564,12 +1581,23 @@ repeat:
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
+	/*
+	 * Make quota reservation here to prevent quota overflow
+	 * later. Real quota accounting is done at pages writeout
+	 * time.
+	 */
+	if (vfs_dq_reserve_block(inode, total)) {
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		return -EDQUOT;
+	}
+
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
 		}
+		vfs_dq_release_reservation_block(inode, total);
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
@@ -1623,6 +1651,8 @@ static void ext4_da_release_space(struct
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	vfs_dq_release_reservation_block(inode, release);
 }
 
 static void ext4_da_page_release_reservation(struct page *page,
Index: linux-2.6.29-rc1/fs/ext4/super.c
===================================================================
--- linux-2.6.29-rc1.orig/fs/ext4/super.c	2009-01-10 15:43:05.000000000 -0800
+++ linux-2.6.29-rc1/fs/ext4/super.c	2009-01-12 16:28:44.000000000 -0800
@@ -945,6 +945,10 @@ static struct dquot_operations ext4_quot
 	.initialize	= ext4_dquot_initialize,
 	.drop		= ext4_dquot_drop,
 	.alloc_space	= dquot_alloc_space,
+	.reserve_space	= dquot_reserve_space,
+	.claim_space	= dquot_claim_space,
+	.release_rsv	= dquot_release_reserved_space,
+	.get_reserved_space = ext4_get_reserved_space,
 	.alloc_inode	= dquot_alloc_inode,
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
Index: linux-2.6.29-rc1/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.29-rc1.orig/fs/ext4/mballoc.c	2009-01-10 15:43:05.000000000 -0800
+++ linux-2.6.29-rc1/fs/ext4/mballoc.c	2009-01-12 16:28:44.000000000 -0800
@@ -3086,9 +3086,12 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
 		/* release all the reserved blocks if non delalloc */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
-	else
+	else {
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
 						ac->ac_b_ex.fe_len);
+		/* convert reserved quota blocks to real quota blocks */
+		vfs_dq_claim_block(ac->ac_inode, ac->ac_b_ex.fe_len);
+	}
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
@@ -4533,7 +4536,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	ext4_fsblk_t block = 0;
-	unsigned int inquota;
+	unsigned int inquota = 0;
 	unsigned int reserv_blks = 0;
 
 	sb = ar->inode->i_sb;
@@ -4551,9 +4554,17 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 		   (unsigned long long) ar->pleft,
 		   (unsigned long long) ar->pright);
 
-	if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag) {
-		/*
-		 * With delalloc we already reserved the blocks
+	/*
+	 * For delayed allocation, we could skip the ENOSPC and
+	 * EDQUOT check, as blocks and quotas have been already
+	 * reserved when data being copied into pagecache.
+	 */
+	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
+		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
+	else {
+		/* Without delayed allocation we need to verify
+		 * there is enough free blocks to do block allocation
+		 * and verify allocation doesn't exceed the quota limits.
 		 */
 		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
 			/* let others to free the space */
@@ -4565,19 +4576,16 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 			return 0;
 		}
 		reserv_blks = ar->len;
+		while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
+			ar->flags |= EXT4_MB_HINT_NOPREALLOC;
+			ar->len--;
+		}
+		inquota = ar->len;
+		if (ar->len == 0) {
+			*errp = -EDQUOT;
+			goto out3;
+		}
 	}
-	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
-		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
-		ar->len--;
-	}
-	if (ar->len == 0) {
-		*errp = -EDQUOT;
-		goto out3;
-	}
-	inquota = ar->len;
-
-	if (EXT4_I(ar->inode)->i_delalloc_reserved_flag)
-		ar->flags |= EXT4_MB_DELALLOC_RESERVED;
 
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 	if (!ac) {
@@ -4643,7 +4651,7 @@ repeat:
 out2:
 	kmem_cache_free(ext4_ac_cachep, ac);
 out1:
-	if (ar->len < inquota)
+	if (inquota && ar->len < inquota)
 		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
 out3:
 	if (!ar->len) {
Index: linux-2.6.29-rc1/fs/ext4/ext4.h
===================================================================
--- linux-2.6.29-rc1.orig/fs/ext4/ext4.h	2009-01-10 15:43:05.000000000 -0800
+++ linux-2.6.29-rc1/fs/ext4/ext4.h	2009-01-12 16:28:44.000000000 -0800
@@ -1098,6 +1098,7 @@ extern int ext4_chunk_trans_blocks(struc
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
+extern qsize_t ext4_get_reserved_space(struct inode *inode);
 
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);

--=-ECs7TLUzRUc3L/TIsVX+
Content-Disposition: attachment; filename=quota-inode-blkbits-cleanup.patch
Content-Type: text/x-patch; name=quota-inode-blkbits-cleanup.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

quota: Use inode->i_blkbits to get block bits

From: Mingming Cao <cmm@us.ibm.com>

Andrew has suggested to use inode->i_blkbits to get the block bits info,
rather than use super block's blockbits. That should be faster and emit
less code.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 include/linux/quotaops.h |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

Index: linux-2.6.29-rc1/include/linux/quotaops.h
===================================================================
--- linux-2.6.29-rc1.orig/include/linux/quotaops.h	2009-01-12 16:28:57.000000000 -0800
+++ linux-2.6.29-rc1/include/linux/quotaops.h	2009-01-12 16:44:55.000000000 -0800
@@ -412,38 +412,32 @@ static inline void vfs_dq_free_space(str
 
 static inline int vfs_dq_prealloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space_nodirty(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_prealloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_prealloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_prealloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_alloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
- 	return vfs_dq_alloc_space_nodirty(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_alloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_alloc_space(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_alloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_reserve_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_reserve_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_claim_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_claim_space(inode, nr << inode->i_blkbits);
 }
 
 static inline
@@ -454,12 +448,12 @@ void vfs_dq_release_reservation_block(st
 
 static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline void vfs_dq_free_block(struct inode *inode, qsize_t nr)
 {
-	vfs_dq_free_space(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space(inode, nr << inode->i_blkbits);
 }
 
 /*

--=-ECs7TLUzRUc3L/TIsVX+
Content-Disposition: attachment; filename=quota-exported-symbols-cleanup.patch
Content-Type: text/x-patch; name=quota-exported-symbols-cleanup.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

quota: Move EXPORT_SYMBOL immediatlely next to the functions/varibles

From: Mingming Cao <cmm@us.ibm.com>

According to checkpatch: EXPORT_SYMBOL(foo); should immediately follow its
 function/variable

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/dquot.c |   73 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 35 insertions(+), 38 deletions(-)

Index: linux-2.6.29-rc1/fs/dquot.c
===================================================================
--- linux-2.6.29-rc1.orig/fs/dquot.c	2009-01-12 16:28:57.000000000 -0800
+++ linux-2.6.29-rc1/fs/dquot.c	2009-01-12 16:44:57.000000000 -0800
@@ -127,6 +127,7 @@
 
 static DEFINE_SPINLOCK(dq_list_lock);
 DEFINE_SPINLOCK(dq_data_lock);
+EXPORT_SYMBOL(dq_data_lock);
 
 static char *quotatypes[] = INITQFNAMES;
 static struct quota_format_type *quota_formats;	/* List of registered formats */
@@ -143,6 +144,7 @@ int register_quota_format(struct quota_f
 	spin_unlock(&dq_list_lock);
 	return 0;
 }
+EXPORT_SYMBOL(register_quota_format);
 
 void unregister_quota_format(struct quota_format_type *fmt)
 {
@@ -154,6 +156,7 @@ void unregister_quota_format(struct quot
 		*actqf = (*actqf)->qf_next;
 	spin_unlock(&dq_list_lock);
 }
+EXPORT_SYMBOL(unregister_quota_format);
 
 static struct quota_format_type *find_quota_format(int id)
 {
@@ -210,6 +213,7 @@ static unsigned int dq_hash_bits, dq_has
 static struct hlist_head *dquot_hash;
 
 struct dqstats dqstats;
+EXPORT_SYMBOL(dqstats);
 
 static inline unsigned int
 hashfn(const struct super_block *sb, unsigned int id, int type)
@@ -304,6 +308,7 @@ int dquot_mark_dquot_dirty(struct dquot 
 	spin_unlock(&dq_list_lock);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 
 /* This function needs dq_list_lock */
 static inline int clear_dquot_dirty(struct dquot *dquot)
@@ -355,6 +360,7 @@ out_iolock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_acquire);
 
 /*
  *	Write dquot to disk
@@ -384,6 +390,7 @@ out_sem:
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit);
 
 /*
  *	Release dquot
@@ -412,6 +419,7 @@ out_dqlock:
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_release);
 
 void dquot_destroy(struct dquot *dquot)
 {
@@ -511,6 +519,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_scan_active);
 
 int vfs_quota_sync(struct super_block *sb, int type)
 {
@@ -558,6 +567,7 @@ int vfs_quota_sync(struct super_block *s
 
 	return 0;
 }
+EXPORT_SYMBOL(vfs_quota_sync);
 
 /* Free unused dquots from cache */
 static void prune_dqcache(int count)
@@ -668,6 +678,7 @@ we_slept:
 	put_dquot_last(dquot);
 	spin_unlock(&dq_list_lock);
 }
+EXPORT_SYMBOL(dqput);
 
 struct dquot *dquot_alloc(struct super_block *sb, int type)
 {
@@ -713,6 +724,7 @@ int dquot_is_cached(struct super_block *
 	spin_unlock(&dq_list_lock);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_is_cached);
 
 /*
  * Get reference to dquot
@@ -766,6 +778,7 @@ we_slept:
 
 	return dquot;
 }
+EXPORT_SYMBOL(dqget);
 
 static int dqinit_needed(struct inode *inode, int type)
 {
@@ -1263,6 +1276,7 @@ out_err:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_initialize);
 
 /*
  * 	Release all quotas referenced by inode
@@ -1280,6 +1294,7 @@ int dquot_drop_locked(struct inode *inod
 	}
 	return 0;
 }
+EXPORT_SYMBOL(dquot_drop_locked);
 
 int dquot_drop(struct inode *inode)
 {
@@ -1288,6 +1303,7 @@ int dquot_drop(struct inode *inode)
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return 0;
 }
+EXPORT_SYMBOL(dquot_drop);
 
 /* Wrapper to remove references to quota structures from inode */
 void vfs_dq_drop(struct inode *inode)
@@ -1310,6 +1326,7 @@ void vfs_dq_drop(struct inode *inode)
 			inode->i_sb->dq_op->drop(inode);
 	}
 }
+EXPORT_SYMBOL(vfs_dq_drop);
 
 /*
  * Following four functions update i_blocks+i_bytes fields and
@@ -1390,6 +1407,7 @@ out_unlock:
 out:
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_space);
 
 int dquot_reserve_space(struct inode *inode, qsize_t number, int warn)
 {
@@ -1454,6 +1472,7 @@ warn_put_all:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_alloc_inode);
 
 int dquot_claim_space(struct inode *inode, qsize_t number)
 {
@@ -1560,6 +1579,7 @@ out_sub:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_space);
 
 /*
  * This operation can block, but only after everything is updated
@@ -1596,6 +1616,7 @@ int dquot_free_inode(const struct inode 
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
+EXPORT_SYMBOL(dquot_free_inode);
 
 /*
  * call back function, get reserved quota space from underlying fs
@@ -1725,6 +1746,7 @@ warn_put_all:
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_transfer);
 
 /* Wrapper for transferring ownership of an inode */
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr)
@@ -1736,7 +1758,7 @@ int vfs_dq_transfer(struct inode *inode,
 	}
 	return 0;
 }
-
+EXPORT_SYMBOL(vfs_dq_transfer);
 
 /*
  * Write info of quota file to disk
@@ -1751,6 +1773,7 @@ int dquot_commit_info(struct super_block
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(dquot_commit_info);
 
 /*
  * Definitions of diskquota operations.
@@ -1898,13 +1921,14 @@ put_inodes:
 		}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_quota_disable);
 
 int vfs_quota_off(struct super_block *sb, int type, int remount)
 {
 	return vfs_quota_disable(sb, type, remount ? DQUOT_SUSPENDED :
 				 (DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED));
 }
-
+EXPORT_SYMBOL(vfs_quota_off);
 /*
  *	Turn quotas on on a device
  */
@@ -2057,6 +2081,7 @@ int vfs_quota_on_path(struct super_block
 					     DQUOT_LIMITS_ENABLED);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_path);
 
 int vfs_quota_on(struct super_block *sb, int type, int format_id, char *name,
 		 int remount)
@@ -2074,6 +2099,7 @@ int vfs_quota_on(struct super_block *sb,
 	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on);
 
 /*
  * More powerful function for turning on quotas allowing setting
@@ -2118,6 +2144,7 @@ out_lock:
 load_quota:
 	return vfs_load_quota_inode(inode, type, format_id, flags);
 }
+EXPORT_SYMBOL(vfs_quota_enable);
 
 /*
  * This function is used when filesystem needs to initialize quotas
@@ -2147,6 +2174,7 @@ out:
 	dput(dentry);
 	return error;
 }
+EXPORT_SYMBOL(vfs_quota_on_mount);
 
 /* Wrapper to turn on quotas when remounting rw */
 int vfs_dq_quota_on_remount(struct super_block *sb)
@@ -2163,6 +2191,7 @@ int vfs_dq_quota_on_remount(struct super
 	}
 	return ret;
 }
+EXPORT_SYMBOL(vfs_dq_quota_on_remount);
 
 static inline qsize_t qbtos(qsize_t blocks)
 {
@@ -2206,6 +2235,7 @@ int vfs_get_dqblk(struct super_block *sb
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqblk);
 
 /* Generic routine for setting common part of quota structure */
 static int do_set_dqblk(struct dquot *dquot, struct if_dqblk *di)
@@ -2299,6 +2329,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return rc;
 }
+EXPORT_SYMBOL(vfs_set_dqblk);
 
 /* Generic routine for getting common part of quota file information */
 int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2320,6 +2351,7 @@ int vfs_get_dqinfo(struct super_block *s
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_get_dqinfo);
 
 /* Generic routine for setting common part of quota file information */
 int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii)
@@ -2348,6 +2380,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return err;
 }
+EXPORT_SYMBOL(vfs_set_dqinfo);
 
 struct quotactl_ops vfs_quotactl_ops = {
 	.quota_on	= vfs_quota_on,
@@ -2503,39 +2536,3 @@ static int __init dquot_init(void)
 	return 0;
 }
 module_init(dquot_init);
-
-EXPORT_SYMBOL(register_quota_format);
-EXPORT_SYMBOL(unregister_quota_format);
-EXPORT_SYMBOL(dqstats);
-EXPORT_SYMBOL(dq_data_lock);
-EXPORT_SYMBOL(vfs_quota_enable);
-EXPORT_SYMBOL(vfs_quota_on);
-EXPORT_SYMBOL(vfs_quota_on_path);
-EXPORT_SYMBOL(vfs_quota_on_mount);
-EXPORT_SYMBOL(vfs_quota_disable);
-EXPORT_SYMBOL(vfs_quota_off);
-EXPORT_SYMBOL(dquot_scan_active);
-EXPORT_SYMBOL(vfs_quota_sync);
-EXPORT_SYMBOL(vfs_get_dqinfo);
-EXPORT_SYMBOL(vfs_set_dqinfo);
-EXPORT_SYMBOL(vfs_get_dqblk);
-EXPORT_SYMBOL(vfs_set_dqblk);
-EXPORT_SYMBOL(dquot_commit);
-EXPORT_SYMBOL(dquot_commit_info);
-EXPORT_SYMBOL(dquot_acquire);
-EXPORT_SYMBOL(dquot_release);
-EXPORT_SYMBOL(dquot_mark_dquot_dirty);
-EXPORT_SYMBOL(dquot_initialize);
-EXPORT_SYMBOL(dquot_drop);
-EXPORT_SYMBOL(dquot_drop_locked);
-EXPORT_SYMBOL(vfs_dq_drop);
-EXPORT_SYMBOL(dqget);
-EXPORT_SYMBOL(dqput);
-EXPORT_SYMBOL(dquot_is_cached);
-EXPORT_SYMBOL(dquot_alloc_space);
-EXPORT_SYMBOL(dquot_alloc_inode);
-EXPORT_SYMBOL(dquot_free_space);
-EXPORT_SYMBOL(dquot_free_inode);
-EXPORT_SYMBOL(dquot_transfer);
-EXPORT_SYMBOL(vfs_dq_transfer);
-EXPORT_SYMBOL(vfs_dq_quota_on_remount);

--=-ECs7TLUzRUc3L/TIsVX+--

