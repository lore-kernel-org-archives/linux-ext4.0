From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/11] ocfs2: Remove ocfs2_dquot_initialize() and ocfs2_dquot_drop()
Date: Fri, 16 Jan 2009 19:08:10 +0100
Message-ID: <1232129299-22018-3-git-send-email-jack@suse.cz>
References: <yes>
 <1232129299-22018-1-git-send-email-jack@suse.cz>
 <1232129299-22018-2-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1232129299-22018-2-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since ->acquire_dquot and ->release_dquot callbacks aren't called under
dqptr_sem anymore, we don't have to start a transaction and obtain locks
so early. So we can just remove all this complicated stuff.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c |  169 +----------------------------------------------
 1 files changed, 2 insertions(+), 167 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 6aff8f2..f4efa89 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -810,171 +810,6 @@ out:
 	return status;
 }
 
-/* This is difficult. We have to lock quota inode and start transaction
- * in this function but we don't want to take the penalty of exlusive
- * quota file lock when we are just going to use cached structures. So
- * we just take read lock check whether we have dquot cached and if so,
- * we don't have to take the write lock... */
-static int ocfs2_dquot_initialize(struct inode *inode, int type)
-{
-	handle_t *handle = NULL;
-	int status = 0;
-	struct super_block *sb = inode->i_sb;
-	struct ocfs2_mem_dqinfo *oinfo;
-	int exclusive = 0;
-	int cnt;
-	qid_t id;
-
-	mlog_entry_void();
-
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (type != -1 && cnt != type)
-			continue;
-		if (!sb_has_quota_active(sb, cnt))
-			continue;
-		oinfo = sb_dqinfo(sb, cnt)->dqi_priv;
-		status = ocfs2_lock_global_qf(oinfo, 0);
-		if (status < 0)
-			goto out;
-		/* This is just a performance optimization not a reliable test.
-		 * Since we hold an inode lock, noone can actually release
-		 * the structure until we are finished with initialization. */
-		if (inode->i_dquot[cnt] != NODQUOT) {
-			ocfs2_unlock_global_qf(oinfo, 0);
-			continue;
-		}
-		/* When we have inode lock, we know that no dquot_release() can
-		 * run and thus we can safely check whether we need to
-		 * read+modify global file to get quota information or whether
-		 * our node already has it. */
-		if (cnt == USRQUOTA)
-			id = inode->i_uid;
-		else if (cnt == GRPQUOTA)
-			id = inode->i_gid;
-		else
-			BUG();
-		/* Obtain exclusion from quota off... */
-		down_write(&sb_dqopt(sb)->dqptr_sem);
-		exclusive = !dquot_is_cached(sb, id, cnt);
-		up_write(&sb_dqopt(sb)->dqptr_sem);
-		if (exclusive) {
-			status = ocfs2_lock_global_qf(oinfo, 1);
-			if (status < 0) {
-				exclusive = 0;
-				mlog_errno(status);
-				goto out_ilock;
-			}
-			handle = ocfs2_start_trans(OCFS2_SB(sb),
-					ocfs2_calc_qinit_credits(sb, cnt));
-			if (IS_ERR(handle)) {
-				status = PTR_ERR(handle);
-				mlog_errno(status);
-				goto out_ilock;
-			}
-		}
-		dquot_initialize(inode, cnt);
-		if (exclusive) {
-			ocfs2_commit_trans(OCFS2_SB(sb), handle);
-			ocfs2_unlock_global_qf(oinfo, 1);
-		}
-		ocfs2_unlock_global_qf(oinfo, 0);
-	}
-	mlog_exit(0);
-	return 0;
-out_ilock:
-	if (exclusive)
-		ocfs2_unlock_global_qf(oinfo, 1);
-	ocfs2_unlock_global_qf(oinfo, 0);
-out:
-	mlog_exit(status);
-	return status;
-}
-
-static int ocfs2_dquot_drop_slow(struct inode *inode)
-{
-	int status = 0;
-	int cnt;
-	int got_lock[MAXQUOTAS] = {0, 0};
-	handle_t *handle;
-	struct super_block *sb = inode->i_sb;
-	struct ocfs2_mem_dqinfo *oinfo;
-
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!sb_has_quota_active(sb, cnt))
-			continue;
-		oinfo = sb_dqinfo(sb, cnt)->dqi_priv;
-		status = ocfs2_lock_global_qf(oinfo, 1);
-		if (status < 0)
-			goto out;
-		got_lock[cnt] = 1;
-	}
-	handle = ocfs2_start_trans(OCFS2_SB(sb),
-			ocfs2_calc_qinit_credits(sb, USRQUOTA) +
-			ocfs2_calc_qinit_credits(sb, GRPQUOTA));
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		mlog_errno(status);
-		goto out;
-	}
-	dquot_drop(inode);
-	ocfs2_commit_trans(OCFS2_SB(sb), handle);
-out:
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		if (got_lock[cnt]) {
-			oinfo = sb_dqinfo(sb, cnt)->dqi_priv;
-			ocfs2_unlock_global_qf(oinfo, 1);
-		}
-	return status;
-}
-
-/* See the comment before ocfs2_dquot_initialize. */
-static int ocfs2_dquot_drop(struct inode *inode)
-{
-	int status = 0;
-	struct super_block *sb = inode->i_sb;
-	struct ocfs2_mem_dqinfo *oinfo;
-	int exclusive = 0;
-	int cnt;
-	int got_lock[MAXQUOTAS] = {0, 0};
-
-	mlog_entry_void();
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (!sb_has_quota_active(sb, cnt))
-			continue;
-		oinfo = sb_dqinfo(sb, cnt)->dqi_priv;
-		status = ocfs2_lock_global_qf(oinfo, 0);
-		if (status < 0)
-			goto out;
-		got_lock[cnt] = 1;
-	}
-	/* Lock against anyone releasing references so that when when we check
-	 * we know we are not going to be last ones to release dquot */
-	down_write(&sb_dqopt(sb)->dqptr_sem);
-	/* Urgh, this is a terrible hack :( */
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (inode->i_dquot[cnt] != NODQUOT &&
-		    atomic_read(&inode->i_dquot[cnt]->dq_count) > 1) {
-			exclusive = 1;
-			break;
-		}
-	}
-	if (!exclusive)
-		dquot_drop_locked(inode);
-	up_write(&sb_dqopt(sb)->dqptr_sem);
-out:
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		if (got_lock[cnt]) {
-			oinfo = sb_dqinfo(sb, cnt)->dqi_priv;
-			ocfs2_unlock_global_qf(oinfo, 0);
-		}
-	/* In case we bailed out because we had to do expensive locking
-	 * do it now... */
-	if (exclusive)
-		status = ocfs2_dquot_drop_slow(inode);
-	mlog_exit(status);
-	return status;
-}
-
 static struct dquot *ocfs2_alloc_dquot(struct super_block *sb, int type)
 {
 	struct ocfs2_dquot *dquot =
@@ -991,8 +826,8 @@ static void ocfs2_destroy_dquot(struct dquot *dquot)
 }
 
 struct dquot_operations ocfs2_quota_operations = {
-	.initialize	= ocfs2_dquot_initialize,
-	.drop		= ocfs2_dquot_drop,
+	.initialize	= dquot_initialize,
+	.drop		= dquot_drop,
 	.alloc_space	= dquot_alloc_space,
 	.alloc_inode	= dquot_alloc_inode,
 	.free_space	= dquot_free_space,
-- 
1.6.0.2

