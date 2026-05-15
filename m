Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA8D413229;
	Fri, 15 May 2026 09:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778836859; cv=pass; b=gWCMfpqSMPbxO6bRVBwy1E1O4p4auazQqrgyUwj+T53bj4cvV7koznMsYVXoewogpM/3as4RPtwa+JWvAK1IB5msNNF03AYb0ToJINc8T4S019Yzm/5/sizWFqqA4kbrse1CSzy8ExkdJ1fxpCSLz1KbSz33si7TcDkaTKLG2qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778836859; c=relaxed/simple;
	bh=/kckBpy6agkgFHP1mgX65jS5gT6EpXalE2T0ZAbDP2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp+EJ92MNetW1WVslYWILxc6cfqVCPXfjPq8LJcmy8VEgV1b6Gf5m6Y4egyJQvSpdiC8k0EWxnXaVQ+gOgjo8/uZcFIThexdo8hqTWxEcRdw8KRskCo6CYv8b64xNgu9vJn9x74yW6dF0RTxuackElj5oQbjQpTgDJHicC9N0hQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=XnRkFGZa; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="XnRkFGZa"
ARC-Seal: i=1; a=rsa-sha256; t=1778836740; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=jCH2u5N57X4Wvygo2dZG/3kXml1tuqHASsTP5UxPt3p+Z8kbV03m+pTsNO+eovkZi7O20Qq4+IY9/Z2opWsRKyy1up+LdrYhmo6ldvPNApNDLtZo+DZ7VGvxYcXUGmub6wfDEppS+9JcjcD3A0BEkPRAuiMd42kWTzsbziOvSwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778836740; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=u5OiQ42AfpfxxdPNi2Pytx4tCCnkm/451hbAvgMObT4=; 
	b=SIMWjrmrg2EH7wm8DwcsNzonASCQ127LL7QQvdgS5tnyHbRXsLQJEnPcKMasoEIVSU2gkahVRplOCgs4RK7sQfsL4wYTKGiVQuGdX9Y/eBziAaeqbsqbhyv3c7TYUn0eLuqAdQf6T6Iyu8VRlzTCMuEs3eDKLxs9Iqa/zj8rwO0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778836740;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=u5OiQ42AfpfxxdPNi2Pytx4tCCnkm/451hbAvgMObT4=;
	b=XnRkFGZajPZyRV+R/ovXei0PxYeSKKYgnNT/MxY+wjEdzCtfzcclvC2Mu17emn/4
	8Fv59qMgCaYG04sPyPtWBDteS8UAnYmYfGlZOMPhtvIKl/YDvM9kYkh6/zPDykMTXSK
	+CNkR+CeDlGWajjX4cXuG/n+yo8or0ngUhDblit0=
Received: by mx.zohomail.com with SMTPS id 17788367384381022.0562180561279;
	Fri, 15 May 2026 02:18:58 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Zhang Yi <yi.zhang@huaweicloud.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Subject: [RFC v8 3/7] ext4: fast commit: avoid waiting for FC_COMMITTING
Date: Fri, 15 May 2026 17:18:23 +0800
Message-ID: <20260515091829.194810-4-me@linux.beauty>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515091829.194810-1-me@linux.beauty>
References: <20260515091829.194810-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

ext4_fc_track_inode() can be called while holding i_data_sem (e.g.
fallocate). Waiting for EXT4_STATE_FC_COMMITTING in that case risks an
ABBA deadlock: i_data_sem -> wait(FC_COMMITTING) vs FC_COMMITTING ->
wait(i_data_sem) in the commit task.

Now that fast commit snapshots inode state at commit time, updates during
log writing do not need to block. Drop the wait and lockdep assertion in
ext4_fc_track_inode(), and make ext4_fc_del() wait for FC_COMMITTING so an
inode cannot be removed while the commit thread is still using it.

When an inode is modified during a fast commit, mark it with
EXT4_STATE_FC_REQUEUE so cleanup keeps it queued for the next fast commit.
This is needed because jbd2_fc_end_commit() invokes the cleanup callback
with tid == 0, so tid-based requeue logic would requeue every inode.

Testing: tracepoint ext4:ext4_fc_commit_stop with two fsyncs in the same
transaction. nblks is the number of journal blocks written for that fast
commit. Before this change, the second fsync still wrote almost the same
fast commit log (nblks 10->9), because tid == 0 in jbd2_fc_end_commit()
caused the tid-based requeue logic to keep all inodes queued. After this
change, only inodes modified during the commit are requeued, and the
second fsync wrote a nearly empty fast commit (nblks 10->1).

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
Changes in RFC v8:
- Base the series on "ext4: fix fast commit wait/wake bit mapping on
  64-bit", so the FC_COMMITTING/FC_FLUSHING_DATA wait and wake paths use
  the shared helper mapping.

 fs/ext4/ext4.h        |   1 +
 fs/ext4/fast_commit.c | 106 ++++++++++++++++++++----------------------
 2 files changed, 51 insertions(+), 56 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 115a3c94db16..927173bc8381 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1991,6 +1991,7 @@ enum {
 	EXT4_STATE_FC_COMMITTING,	/* Fast commit ongoing */
 	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
 	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
+	EXT4_STATE_FC_REQUEUE,		/* Inode modified during fast commit */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0c49144e8ca2..673668860e2d 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -62,9 +62,8 @@
  *     setting "EXT4_STATE_FC_COMMITTING" state, and snapshot the inode state
  *     needed for log writing.
  * [5] Unlock the journal by calling jbd2_journal_unlock_updates(). This allows
- *     starting of new handles. If new handles try to start an update on
- *     any of the inodes that are being committed, ext4_fc_track_inode()
- *     will block until those inodes have finished the fast commit.
+ *     starting of new handles. Updates to inodes being fast committed are
+ *     tracked for requeue rather than blocking.
  * [6] Commit all the directory entry updates in the fast commit space.
  * [7] Commit all the changed inodes in the fast commit space.
  * [8] Write tail tag (this tag ensures the atomicity, please read the following
@@ -218,6 +217,7 @@ void ext4_fc_init_inode(struct inode *inode)
 
 	ext4_fc_reset_inode(inode);
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_COMMITTING);
+	ext4_clear_inode_state(inode, EXT4_STATE_FC_REQUEUE);
 	INIT_LIST_HEAD(&ei->i_fc_list);
 	INIT_LIST_HEAD(&ei->i_fc_dilist);
 	ei->i_fc_snap = NULL;
@@ -245,7 +245,10 @@ void ext4_fc_del(struct inode *inode)
 	struct ext4_fc_dentry_update *fc_dentry;
 	wait_queue_head_t *wq;
 	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
-	int wait_bit = ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
+	int committing_wait_bit =
+		ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
+	int flushing_wait_bit =
+		ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
 	int alloc_ctx;
 
 	if (ext4_fc_disabled(inode->i_sb))
@@ -259,26 +262,26 @@ void ext4_fc_del(struct inode *inode)
 	}
 
 	/*
-	 * Since ext4_fc_del is called from ext4_evict_inode while having a
-	 * handle open, there is no need for us to wait here even if a fast
-	 * commit is going on. That is because, if this inode is being
-	 * committed, ext4_mark_inode_dirty would have waited for inode commit
-	 * operation to finish before we come here. So, by the time we come
-	 * here, inode's EXT4_STATE_FC_COMMITTING would have been cleared. So,
-	 * we shouldn't see EXT4_STATE_FC_COMMITTING to be set on this inode
-	 * here.
-	 *
-	 * We may come here without any handles open in the "no_delete" case of
-	 * ext4_evict_inode as well. However, if that happens, we first mark the
-	 * file system as fast commit ineligible anyway. So, even in that case,
-	 * it is okay to remove the inode from the fc list.
+	 * Wait for ongoing fast commit to finish. We cannot remove the inode
+	 * from fast commit lists while it is being committed.
 	 */
-	WARN_ON(ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)
-		&& !ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE));
+	while (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)) {
+		DEFINE_WAIT_BIT(wait, wait_word, committing_wait_bit);
+
+		wq = bit_waitqueue(wait_word, committing_wait_bit);
+		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
+		if (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)) {
+			ext4_fc_unlock(inode->i_sb, alloc_ctx);
+			schedule();
+			alloc_ctx = ext4_fc_lock(inode->i_sb);
+		}
+		finish_wait(wq, &wait.wq_entry);
+	}
+
 	while (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
-		DEFINE_WAIT_BIT(wait, wait_word, wait_bit);
+		DEFINE_WAIT_BIT(wait, wait_word, flushing_wait_bit);
 
-		wq = bit_waitqueue(wait_word, wait_bit);
+		wq = bit_waitqueue(wait_word, flushing_wait_bit);
 		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
 		if (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
 			ext4_fc_unlock(inode->i_sb, alloc_ctx);
@@ -287,19 +290,22 @@ void ext4_fc_del(struct inode *inode)
 		}
 		finish_wait(wq, &wait.wq_entry);
 	}
+
 	ext4_fc_free_inode_snap(inode);
 	list_del_init(&ei->i_fc_list);
 
 	/*
-	 * Since this inode is getting removed, let's also remove all FC
-	 * dentry create references, since it is not needed to log it anyways.
+	 * Since this inode is getting removed, let's also remove all FC dentry
+	 * create references, since it is not needed to log it anyways.
 	 */
 	if (list_empty(&ei->i_fc_dilist)) {
 		ext4_fc_unlock(inode->i_sb, alloc_ctx);
 		return;
 	}
 
-	fc_dentry = list_first_entry(&ei->i_fc_dilist, struct ext4_fc_dentry_update, fcd_dilist);
+	fc_dentry = list_first_entry(&ei->i_fc_dilist,
+				     struct ext4_fc_dentry_update,
+				     fcd_dilist);
 	WARN_ON(fc_dentry->fcd_op != EXT4_FC_TAG_CREAT);
 	list_del_init(&fc_dentry->fcd_list);
 	list_del_init(&fc_dentry->fcd_dilist);
@@ -371,6 +377,8 @@ static int ext4_fc_track_template(
 
 	tid = handle->h_transaction->t_tid;
 	spin_lock(&ei->i_fc_lock);
+	if (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING))
+		ext4_set_inode_state(inode, EXT4_STATE_FC_REQUEUE);
 	if (tid == ei->i_sync_tid) {
 		update = true;
 	} else {
@@ -541,10 +549,6 @@ static int __track_inode(handle_t *handle, struct inode *inode, void *arg,
 
 void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 {
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	wait_queue_head_t *wq;
-	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
-	int wait_bit = ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
 	int ret;
 
 	if (S_ISDIR(inode->i_mode))
@@ -560,21 +564,11 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 		return;
 
 	/*
-	 * If we come here, we may sleep while waiting for the inode to
-	 * commit. We shouldn't be holding i_data_sem when we go to sleep since
-	 * the commit path needs to grab the lock while committing the inode.
+	 * Fast commit snapshots inode state at commit time, so there's no need
+	 * to wait for EXT4_STATE_FC_COMMITTING here. If the inode is already
+	 * on the commit queue, ext4_fc_cleanup() will requeue it for the new
+	 * transaction once the current commit finishes.
 	 */
-	lockdep_assert_not_held(&ei->i_data_sem);
-
-	while (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)) {
-		DEFINE_WAIT_BIT(wait, wait_word, wait_bit);
-
-		wq = bit_waitqueue(wait_word, wait_bit);
-		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
-		if (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING))
-			schedule();
-		finish_wait(wq, &wait.wq_entry);
-	}
 
 	/*
 	 * From this point on, this inode will not be committed either
@@ -1499,32 +1493,32 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 
 	alloc_ctx = ext4_fc_lock(sb);
 	while (!list_empty(&sbi->s_fc_q[FC_Q_MAIN])) {
+		bool requeue;
+
 		ei = list_first_entry(&sbi->s_fc_q[FC_Q_MAIN],
 					struct ext4_inode_info,
 					i_fc_list);
 		list_del_init(&ei->i_fc_list);
 		ext4_fc_free_inode_snap(&ei->vfs_inode);
+		spin_lock(&ei->i_fc_lock);
+		if (full)
+			requeue = !tid_geq(tid, ei->i_sync_tid);
+		else
+			requeue = ext4_test_inode_state(&ei->vfs_inode,
+							EXT4_STATE_FC_REQUEUE);
+		if (!requeue)
+			ext4_fc_reset_inode(&ei->vfs_inode);
+		ext4_clear_inode_state(&ei->vfs_inode, EXT4_STATE_FC_REQUEUE);
 		ext4_clear_inode_state(&ei->vfs_inode,
 				       EXT4_STATE_FC_COMMITTING);
-		if (tid_geq(tid, ei->i_sync_tid)) {
-			ext4_fc_reset_inode(&ei->vfs_inode);
-		} else if (full) {
-			/*
-			 * We are called after a full commit, inode has been
-			 * modified while the commit was running. Re-enqueue
-			 * the inode into STAGING, which will then be splice
-			 * back into MAIN. This cannot happen during
-			 * fastcommit because the journal is locked all the
-			 * time in that case (and tid doesn't increase so
-			 * tid check above isn't reliable).
-			 */
+		spin_unlock(&ei->i_fc_lock);
+		if (requeue)
 			list_add_tail(&ei->i_fc_list,
 				      &sbi->s_fc_q[FC_Q_STAGING]);
-		}
 		/*
 		 * Make sure clearing of EXT4_STATE_FC_COMMITTING is
 		 * visible before we send the wakeup. Pairs with implicit
-		 * barrier in prepare_to_wait() in ext4_fc_track_inode().
+		 * barrier in prepare_to_wait() in ext4_fc_del().
 		 */
 		smp_mb();
 		wake_up_bit(ext4_inode_state_wait_word(&ei->vfs_inode),
-- 
2.53.0
