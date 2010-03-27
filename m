From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] ext4: journalled quota optimization
Date: Sat, 27 Mar 2010 15:15:39 +0300
Message-ID: <1269692140-5375-3-git-send-email-dmonakhov@openvz.org>
References: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently each quota modification result in write_dquot()
and later dquot_commit().  This means what each quota modification
function must wait for dqio_mutex. Which is *huge* performance
penalty on big SMP systems. ASAIU The core idea of this implementation
is to guarantee that each quota modification will be written to journal
atomically. But in fact this is not always true, because dquot may be
changed after dquot modification, but before it was committed to disk.

 | Task 1                           | Task 2                      |
 | alloc_space(nr)                  |                             |
 | ->spin_lock(dq_data_lock)        |                             |
 | ->curspace += nr                 |                             |
 | ->spin_unlock(dq_data_lock)      |                             |
 | ->mark_dirty()                   | free_space(nr)              |
 | -->write_dquot()                 | ->spin_lock(dq_data_lock)   |
 | --->dquot_commit()               | ->curspace -= nr            |
 | ---->commit_dqblk()              | ->spin_unlock(dq_data_lock) |
 | ----->spin_lock(dq_data_lock)    |                             |
 | ----->mem2disk_dqblk(ddq, dquot) | <<< Copy updated value      |
 | ----->spin_unlock(dq_data_lock)  |                             |
 | ----->quota_write()              |                             |
Quota corruption not happens only because quota modification caller
started journal already. And ext3/4 allow only one running quota
at a time. Let's exploit this fact and avoid writing quota each time.
Act similar to dirty_for_io in general write_back path in page-cache.
If we have found what other task already started on copy and write the
dquot then we skip actual quota_write stage. And let that task do the job.
This patch fix only contention on dqio_mutex.

Side effect: Task which skip real quota_write() will not get an error
(if any). But this is not big deal because:
 1) Any error has global consequences (RO_remount, err_print, etc).
 2) Real IO is differed till the journall_commit.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 29c6875..b7b5707 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3874,14 +3874,37 @@ static int ext4_release_dquot(struct dquot *dquot)
 
 static int ext4_mark_dquot_dirty(struct dquot *dquot)
 {
-	/* Are we journaling quotas? */
-	if (EXT4_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] ||
-	    EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
-		dquot_mark_dquot_dirty(dquot);
-		return ext4_write_dquot(dquot);
-	} else {
+	int ret, err;
+	handle_t *handle;
+	struct inode *inode;
+
+	/* Are we not journaling quotas? */
+	if (!EXT4_SB(dquot->dq_sb)->s_qf_names[USRQUOTA] &&
+	    !EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA])
 		return dquot_mark_dquot_dirty(dquot);
-	}
+
+	/* journaling quotas case */
+	inode = dquot_to_inode(dquot);
+	handle = ext4_journal_start(inode,
+				EXT4_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+	if (!dquot_mark_dquot_dirty(dquot))
+		ret = dquot_commit(dquot);
+	else
+		/*
+		 * Dquot was already dirty. This means that other task already
+		 * started a transaction but not clear dirty bit yet (see
+		 * dquot_commit). Since the only one running transaction is
+		 * possible at a time. Then that task belongs to the same
+		 * transaction. We don'n have to actually write dquot changes
+		 * because that task will write it for us.
+		 */
+		ret = 0;
+	err = ext4_journal_stop(handle);
+	if (!ret)
+		ret = err;
+	return ret;
 }
 
 static int ext4_write_info(struct super_block *sb, int type)
-- 
1.6.6.1

