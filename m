From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: prevent ext4_quota_write() from failing due to
 ENOSPC
Date: Fri, 26 Jun 2015 17:00:41 +0200
Message-ID: <20150626150041.GI6271@quack.suse.cz>
References: <1434864462-24300-1-git-send-email-tytso@mit.edu>
 <20150623142545.GA11771@thunk.org>
 <20150623162917.GQ2427@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbbFZPAr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jun 2015 11:00:47 -0400
Content-Disposition: inline
In-Reply-To: <20150623162917.GQ2427@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 23-06-15 18:29:17, Jan Kara wrote:
> On Tue 23-06-15 10:25:45, Ted Tso wrote:
> > On Sun, Jun 21, 2015 at 01:27:42AM -0400, Theodore Ts'o wrote:
> > > In order to prevent quota block tracking to be inaccurate when
> > > ext4_quota_write() fails with ENOSPC, we make two changes.  The quota
> > > file can now use the reserved block (since the quota file is arguably
> > > file system metadata), and ext4_quota_write() now uses
> > > ext4_should_retry_alloc() to retry the block allocation after a commit
> > > has completed and released some blocks for allocation.
> > > 
> > > This fixes failures of xfstests generic/270:
> > > 
> > > Quota error (device vdc): write_blk: dquota write failed
> > > Quota error (device vdc): qtree_write_dquot: Error -28 occurred while creating quota
> > > 
> > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > 
> > This patch significantly reduces the incidence of generic/270 failing,
> > but it doesn't completely eliminate them, especially when using a 1k
> > block size.  This makes sense, because what this generic/270 does is
> > to chown files to random uid's using an ENOSPC hitter as an
> > antagonist.  This means the quota system needs to allocate a huge
> > number of blocks, and with a 1k block, it's doing 4x the number
> > allocations.
> > 
> > Something we could do that would help this situation is if there was
> > an interface in the quota system that initialized the quota records
> > for a particular uid or gid, which we could call from ext4_setattr()
> > or ext4_open() *before* we actually need to allocate a block quota
> > record for the file.
> 
> So quota record is actually first written from dquot_acquire() function
> which gets called (through ->acquire_dquot() callback) when we get the
> first reference to a quota structure in dqget() (called from
> dquot_initialize() / dquot_transfer()). So the problem really is in the
> lack of error propagation from dqget() up through dquot_initialize() /
> dquot_transfer() to the filesystem.
> 
> Doing the propagation for dquot_transfer() should be pretty easy since that
> already reports other errors. With dquot_initialize() it is more difficult
> since that doesn't return any errors currently so we have to add error
> handling into filesystems to the inode creation path.
> 
> I'll look into this.

The attached patch propagates errors from quota creation up into the caller
so now chown will return ENOSPC... The patch seems to work for me. Can you
check whether it fixes the failures you are seeing? If yes, I'll merge the
patch through my tree.

Missing is still handling of errors from dquot_initialize() in filesystems.
I'll add that on top if this patch works for you.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--fdj2RfSjLxBAspz7
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-quota-Propagate-error-from-acquire_dquot.patch"

>From 727cbcbb7776efb7185fd8835c79737b4387dcae Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 24 Jun 2015 18:07:02 +0200
Subject: [PATCH] quota: Propagate error from ->acquire_dquot()

Currently when some error happened in ->acquire_dquot(), dqget() just
returned NULL. That was indistinguishable from a case when e.g. someone
run quotaoff and so was generally silently ignored. However
->acquire_dquot() can fail because of ENOSPC or EIO in which case user
should better know. So propagate error up from ->acquire_dquot properly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c          |  8 ++---
 fs/ocfs2/quota_local.c   |  4 +--
 fs/quota/dquot.c         | 88 ++++++++++++++++++++++++++++++++++--------------
 include/linux/quotaops.h |  2 +-
 4 files changed, 70 insertions(+), 32 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d8b670cbd909..474176b35ffb 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1208,8 +1208,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
 		    OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
 			transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(attr->ia_uid));
-			if (!transfer_to[USRQUOTA]) {
-				status = -ESRCH;
+			if (IS_ERR(transfer_to[USRQUOTA])) {
+				status = PTR_ERR(transfer_to[USRQUOTA]);
 				goto bail_unlock;
 			}
 		}
@@ -1217,8 +1217,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 		    && OCFS2_HAS_RO_COMPAT_FEATURE(sb,
 		    OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)) {
 			transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(attr->ia_gid));
-			if (!transfer_to[GRPQUOTA]) {
-				status = -ESRCH;
+			if (IS_ERR(transfer_to[GRPQUOTA])) {
+				status = PTR_ERR(transfer_to[GRPQUOTA]);
 				goto bail_unlock;
 			}
 		}
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 3d0b63d34225..bb07004df72a 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -499,8 +499,8 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 			dquot = dqget(sb,
 				      make_kqid(&init_user_ns, type,
 						le64_to_cpu(dqblk->dqb_id)));
-			if (!dquot) {
-				status = -EIO;
+			if (IS_ERR(dquot)) {
+				status = PTR_ERR(dquot);
 				mlog(ML_ERROR, "Failed to get quota structure "
 				     "for id %u, type %d. Cannot finish quota "
 				     "file recovery.\n",
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 20d1f74561cf..c61ed126fa4c 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -247,7 +247,7 @@ struct dqstats dqstats;
 EXPORT_SYMBOL(dqstats);
 
 static qsize_t inode_get_rsv_space(struct inode *inode);
-static void __dquot_initialize(struct inode *inode, int type);
+static int __dquot_initialize(struct inode *inode, int type);
 
 static inline unsigned int
 hashfn(const struct super_block *sb, struct kqid qid)
@@ -832,16 +832,17 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
 struct dquot *dqget(struct super_block *sb, struct kqid qid)
 {
 	unsigned int hashent = hashfn(sb, qid);
-	struct dquot *dquot = NULL, *empty = NULL;
+	struct dquot *dquot, *empty = NULL;
 
         if (!sb_has_quota_active(sb, qid.type))
-		return NULL;
+		return ERR_PTR(-ESRCH);
 we_slept:
 	spin_lock(&dq_list_lock);
 	spin_lock(&dq_state_lock);
 	if (!sb_has_quota_active(sb, qid.type)) {
 		spin_unlock(&dq_state_lock);
 		spin_unlock(&dq_list_lock);
+		dquot = ERR_PTR(-ESRCH);
 		goto out;
 	}
 	spin_unlock(&dq_state_lock);
@@ -876,11 +877,15 @@ we_slept:
 	 * already finished or it will be canceled due to dq_count > 1 test */
 	wait_on_dquot(dquot);
 	/* Read the dquot / allocate space in quota file */
-	if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags) &&
-	    sb->dq_op->acquire_dquot(dquot) < 0) {
-		dqput(dquot);
-		dquot = NULL;
-		goto out;
+	if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
+		int err;
+
+		err = sb->dq_op->acquire_dquot(dquot);
+		if (err < 0) {
+			dqput(dquot);
+			dquot = ERR_PTR(err);
+			goto out;
+		}
 	}
 #ifdef CONFIG_QUOTA_DEBUG
 	BUG_ON(!dquot->dq_sb);	/* Has somebody invalidated entry under us? */
@@ -1390,15 +1395,16 @@ static int dquot_active(const struct inode *inode)
  * It is better to call this function outside of any transaction as it
  * might need a lot of space in journal for dquot structure allocation.
  */
-static void __dquot_initialize(struct inode *inode, int type)
+static int __dquot_initialize(struct inode *inode, int type)
 {
 	int cnt, init_needed = 0;
 	struct dquot **dquots, *got[MAXQUOTAS];
 	struct super_block *sb = inode->i_sb;
 	qsize_t rsv;
+	int ret = 0;
 
 	if (!dquot_active(inode))
-		return;
+		return 0;
 
 	dquots = i_dquot(inode);
 
@@ -1407,6 +1413,7 @@ static void __dquot_initialize(struct inode *inode, int type)
 		struct kqid qid;
 		kprojid_t projid;
 		int rc;
+		struct dquot *dquot;
 
 		got[cnt] = NULL;
 		if (type != -1 && cnt != type)
@@ -1438,16 +1445,25 @@ static void __dquot_initialize(struct inode *inode, int type)
 			qid = make_kqid_projid(projid);
 			break;
 		}
-		got[cnt] = dqget(sb, qid);
+		dquot = dqget(sb, qid);
+		if (IS_ERR(dquot)) {
+			/* We raced with somebody turning quotas off... */
+			if (PTR_ERR(dquot) != -ESRCH) {
+				ret = PTR_ERR(dquot);
+				goto out_put;
+			}
+			dquot = NULL;
+		}
+		got[cnt] = dquot;
 	}
 
 	/* All required i_dquot has been initialized */
 	if (!init_needed)
-		return;
+		return 0;
 
 	spin_lock(&dq_data_lock);
 	if (IS_NOQUOTA(inode))
-		goto out_err;
+		goto out_lock;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
@@ -1469,15 +1485,18 @@ static void __dquot_initialize(struct inode *inode, int type)
 				dquot_resv_space(dquots[cnt], rsv);
 		}
 	}
-out_err:
+out_lock:
 	spin_unlock(&dq_data_lock);
+out_put:
 	/* Drop unused references */
 	dqput_all(got);
+
+	return ret;
 }
 
-void dquot_initialize(struct inode *inode)
+int dquot_initialize(struct inode *inode)
 {
-	__dquot_initialize(inode, -1);
+	return __dquot_initialize(inode, -1);
 }
 EXPORT_SYMBOL(dquot_initialize);
 
@@ -1961,18 +1980,37 @@ EXPORT_SYMBOL(__dquot_transfer);
 int dquot_transfer(struct inode *inode, struct iattr *iattr)
 {
 	struct dquot *transfer_to[MAXQUOTAS] = {};
+	struct dquot *dquot;
 	struct super_block *sb = inode->i_sb;
 	int ret;
 
 	if (!dquot_active(inode))
 		return 0;
 
-	if (iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid))
-		transfer_to[USRQUOTA] = dqget(sb, make_kqid_uid(iattr->ia_uid));
-	if (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid))
-		transfer_to[GRPQUOTA] = dqget(sb, make_kqid_gid(iattr->ia_gid));
-
+	if (iattr->ia_valid & ATTR_UID && !uid_eq(iattr->ia_uid, inode->i_uid)){
+		dquot = dqget(sb, make_kqid_uid(iattr->ia_uid));
+		if (IS_ERR(dquot)) {
+			if (PTR_ERR(dquot) != -ESRCH) {
+				ret = PTR_ERR(dquot);
+				goto out_put;
+			}
+			dquot = NULL;
+		}
+		transfer_to[USRQUOTA] = dquot;;
+	}
+	if (iattr->ia_valid & ATTR_GID && !gid_eq(iattr->ia_gid, inode->i_gid)){
+		dquot = dqget(sb, make_kqid_gid(iattr->ia_gid));
+		if (IS_ERR(dquot)) {
+			if (PTR_ERR(dquot) != -ESRCH) {
+				ret = PTR_ERR(dquot);
+				goto out_put;
+			}
+			dquot = NULL;
+		}
+		transfer_to[GRPQUOTA] = dquot;
+	}
 	ret = __dquot_transfer(inode, transfer_to);
+out_put:
 	dqput_all(transfer_to);
 	return ret;
 }
@@ -2518,8 +2556,8 @@ int dquot_get_dqblk(struct super_block *sb, struct kqid qid,
 	struct dquot *dquot;
 
 	dquot = dqget(sb, qid);
-	if (!dquot)
-		return -ESRCH;
+	if (IS_ERR(dquot))
+		return PTR_ERR(dquot);
 	do_get_dqblk(dquot, di);
 	dqput(dquot);
 
@@ -2631,8 +2669,8 @@ int dquot_set_dqblk(struct super_block *sb, struct kqid qid,
 	int rc;
 
 	dquot = dqget(sb, qid);
-	if (!dquot) {
-		rc = -ESRCH;
+	if (!IS_ERR(dquot)) {
+		rc = PTR_ERR(dquot);
 		goto out;
 	}
 	rc = do_set_dqblk(dquot, di);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 77ca6601ff25..06c9ea8971fb 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -43,7 +43,7 @@ void inode_claim_rsv_space(struct inode *inode, qsize_t number);
 void inode_sub_rsv_space(struct inode *inode, qsize_t number);
 void inode_reclaim_rsv_space(struct inode *inode, qsize_t number);
 
-void dquot_initialize(struct inode *inode);
+int dquot_initialize(struct inode *inode);
 void dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, struct kqid qid);
 static inline struct dquot *dqgrab(struct dquot *dquot)
-- 
2.1.4


--fdj2RfSjLxBAspz7--
