From: Jan Kara <jack@suse.cz>
Subject: Re: ext4/quota lockdep complaint: false positive?
Date: Wed, 6 Jan 2010 21:42:25 +0100
Message-ID: <20100106204225.GC22781@quack.suse.cz>
References: <E1NOc16-0003pi-BQ@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50061 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab0AFUmZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jan 2010 15:42:25 -0500
Content-Disposition: inline
In-Reply-To: <E1NOc16-0003pi-BQ@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Ted,

On Sat 26-12-09 14:09:32, Theodore Ts'o wrote:
> 
> While running the xfsqa regression test suite, lockdep triggered the
> following complaint, as shown below.
> 
> I *think* it is a false positive, since the issue involves chown
> triggering a write to the quota file; and during the write, we are
> extending the quota file, which means grabbing i_data_sem while we have
> already grabbed the inode mutex for the quota file.
> 
> The potential circular locking dependency that lockdep is complaining
> occurs only when we are mounting the filesystem, and reading from the
> quota file; and at that point we wouldn't be writing other files and
> needing to update quota file as aresult.  So I don't think this is a
> problem in practice, but (1) i'd like a second opinion, and (2) I'm not
> sure what's the best way to make lockdep happy.
> 
> Jan, what do you think?
  The patch below should silence the lockdep warning.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 815e4d46ad7e56d41096116f5a6927903658551f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 6 Jan 2010 17:20:35 +0100
Subject: [PATCH] quota: Cleanup S_NOQUOTA handling

Cleanup handling of S_NOQUOTA inode flag and document it a bit. The flag
does not have to be set under dqptr_sem. Only functions modifying inode's
dquot pointers have to check the flag under dqptr_sem before going forward
with the modification. This way we are sure that we cannot add new dquot
pointers to the inode which is just becoming a quota file.

The good thing about this cleanup is that there are no more places in quota
code which enforce i_mutex vs. dqptr_sem lock ordering (in particular that
dqptr_sem -> i_mutex of quota file). This should silence some (false) lockdep
warnings with ext4 + quota and generally make life of some filesystems easier.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c |   47 +++++++++++------------------------------------
 1 files changed, 11 insertions(+), 36 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index dea86ab..b4693f2 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -100,9 +100,13 @@
  *
  * Any operation working on dquots via inode pointers must hold dqptr_sem.  If
  * operation is just reading pointers from inode (or not using them at all) the
- * read lock is enough. If pointers are altered function must hold write lock
- * (these locking rules also apply for S_NOQUOTA flag in the inode - note that
- * for altering the flag i_mutex is also needed).
+ * read lock is enough. If pointers are altered function must hold write lock.
+ * Special care needs to be taken about S_NOQUOTA inode flag (marking that
+ * inode is a quota file). Functions adding pointers from inode to dquots have
+ * to check this flag under dqptr_sem and then (if S_NOQUOTA is not set) they
+ * have to do all pointer modifications before dropping dqptr_sem. This makes
+ * sure they cannot race with quotaon which first sets S_NOQUOTA flag and
+ * then drops all pointers to dquots from an inode.
  *
  * Each dquot has its dq_lock mutex. Locked dquots might not be referenced
  * from inodes (dquot_alloc_space() and such don't check the dq_lock).
@@ -1275,7 +1279,6 @@ int dquot_initialize(struct inode *inode, int type)
 	}
 
 	down_write(&sb_dqopt(sb)->dqptr_sem);
-	/* Having dqptr_sem we know NOQUOTA flags can't be altered... */
 	if (IS_NOQUOTA(inode))
 		goto out_err;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -1428,11 +1431,6 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
 	}
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	if (IS_NOQUOTA(inode)) {
-		inode_incr_space(inode, number, reserve);
-		goto out_unlock;
-	}
-
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warntype[cnt] = QUOTA_NL_NOWARN;
 
@@ -1463,7 +1461,6 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number,
 	mark_all_dquot_dirty(inode->i_dquot);
 out_flush_warn:
 	flush_warnings(inode->i_dquot, warntype);
-out_unlock:
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 out:
 	return ret;
@@ -1496,10 +1493,6 @@ int dquot_alloc_inode(const struct inode *inode, qsize_t number)
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warntype[cnt] = QUOTA_NL_NOWARN;
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	if (IS_NOQUOTA(inode)) {
-		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		return QUOTA_OK;
-	}
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (!inode->i_dquot[cnt])
@@ -1536,12 +1529,6 @@ int dquot_claim_space(struct inode *inode, qsize_t number)
 	}
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	if (IS_NOQUOTA(inode))	{
-		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		inode_claim_rsv_space(inode, number);
-		goto out;
-	}
-
 	spin_lock(&dq_data_lock);
 	/* Claim reserved quotas to allocated quotas */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -1570,17 +1557,11 @@ int __dquot_free_space(struct inode *inode, qsize_t number, int reserve)
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
 	if (IS_NOQUOTA(inode)) {
-out_sub:
 		inode_decr_space(inode, number, reserve);
 		return QUOTA_OK;
 	}
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	/* Now recheck reliably when holding dqptr_sem */
-	if (IS_NOQUOTA(inode)) {
-		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		goto out_sub;
-	}
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (!inode->i_dquot[cnt])
@@ -1633,11 +1614,6 @@ int dquot_free_inode(const struct inode *inode, qsize_t number)
 		return QUOTA_OK;
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	/* Now recheck reliably when holding dqptr_sem */
-	if (IS_NOQUOTA(inode)) {
-		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		return QUOTA_OK;
-	}
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (!inode->i_dquot[cnt])
@@ -1689,7 +1665,6 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 					      GRPQUOTA);
 
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	/* Now recheck reliably when holding dqptr_sem */
 	if (IS_NOQUOTA(inode)) {	/* File without quota accounting? */
 		up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 		goto put_all;
@@ -2007,13 +1982,15 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		/* We don't want quota and atime on quota files (deadlocks
 		 * possible) Also nobody should write to the file - we use
 		 * special IO operations which ignore the immutable bit. */
-		down_write(&dqopt->dqptr_sem);
 		mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 		oldflags = inode->i_flags & (S_NOATIME | S_IMMUTABLE |
 					     S_NOQUOTA);
 		inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
 		mutex_unlock(&inode->i_mutex);
-		up_write(&dqopt->dqptr_sem);
+		/*
+		 * When S_NOQUOTA is set, remove dquot references as no more
+		 * references can be added
+		 */
 		sb->dq_op->drop(inode);
 	}
 
@@ -2050,14 +2027,12 @@ out_file_init:
 	iput(inode);
 out_lock:
 	if (oldflags != -1) {
-		down_write(&dqopt->dqptr_sem);
 		mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 		/* Set the flags back (in the case of accidental quotaon()
 		 * on a wrong file we don't want to mess up the flags) */
 		inode->i_flags &= ~(S_NOATIME | S_NOQUOTA | S_IMMUTABLE);
 		inode->i_flags |= oldflags;
 		mutex_unlock(&inode->i_mutex);
-		up_write(&dqopt->dqptr_sem);
 	}
 	mutex_unlock(&dqopt->dqonoff_mutex);
 out_fmt:
-- 
1.6.4.2

