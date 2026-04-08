Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071DF28B40E;
	Wed,  8 Apr 2026 11:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647347; cv=pass; b=kgUCg5/s14vJ1NWrJPZhRP6jlwjd2Qs2hbBAy2jG/k6rvgbTZeXHOZMBuaxwr68hYRUaM1jjtZDcQmasJTMSm/QGLnPSPHEFtXoNgLcsGcGS7E3BgT+uijO5eNl6MzMAbySxBKf29Vbwboz5sD1d7rrIlX987bTPRN/22QbVs24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647347; c=relaxed/simple;
	bh=wP/Lj8Nmg9Z7GynDqx4E77vfRuzaz7TbAhWavBiXaVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REroQwpR28MtiWZq4chhyTRSWCmkcEDt/qSKJ4JqJPdAiZL76CsQhJKdDYSF5aJw6CPxT6WMu6O4G4QQenI86IQmqb1kBCqlmj/xZvjpdtF8n6Jwj3hL13RNXFssr/LjoIRd0/VbyqejjdZIjsQxlVd1SZAmsWn+5UngNVac6TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=i9Il6+6v; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="i9Il6+6v"
ARC-Seal: i=1; a=rsa-sha256; t=1775647266; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=cDC83utS/N2KA5GCfP/I30nJ6JKoBaRiCokHTzLUpYmyzP6U2vg6bigazV7KX0FhgLqU6P220wQK20SO3jVM72iyPzGtq30xYyPOaZB34J12/XU4mmwsbK+auDyWGKANQdZFcXQi/B6K9RZ3BB6fnCMQU/r9ZVmFP9QvGIonQGc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1775647266; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7DHohuacvWLe914BsI3nlud+lO8IjE4svsDoWkMutgY=; 
	b=SWarF06rA46QhIGP7NhnpH7n4s5jAAywM0xpgRqhtZ7ehH+d+JHKHIg4jUIneZDvlkjes41ny2RBlN00CBdxzHkildbVIxOUyS24e1fuoJORogyUQOo4yRv3wRxi+4I8IkR/cDQYaAh+beLY9ZYeaBMZbusP8kSjzafquHeJrmE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775647266;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=7DHohuacvWLe914BsI3nlud+lO8IjE4svsDoWkMutgY=;
	b=i9Il6+6vMe6Tde/p/TcqfJRzi6mDUZWubWLyddeRKGQCp4rR4EmSO3T/JVW8fHhR
	LZfyzVTYKXvipSaFmh0CwQO38FlepmzM+4f4NTMqvvwJkcVMq/khKHD2RN4Xl4YvDrr
	Gzbmu/D/J7vftSZ9wiZrS1vxQaM1nagGMpnDG2Cs=
Received: by mx.zohomail.com with SMTPS id 1775647263397236.02762892367753;
	Wed, 8 Apr 2026 04:21:03 -0700 (PDT)
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
	linux-trace-kernel@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [RFC v6 3/7] ext4: fast commit: avoid waiting for FC_COMMITTING
Date: Wed,  8 Apr 2026 19:20:14 +0800
Message-ID: <20260408112020.716706-4-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408112020.716706-1-me@linux.beauty>
References: <20260408112020.716706-1-me@linux.beauty>
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

Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/ext4/ext4.h        |   1 +
 fs/ext4/fast_commit.c | 111 ++++++++++++++++++++----------------------
 2 files changed, 53 insertions(+), 59 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 66de888ae411..13fe4fdf9bda 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1995,6 +1995,7 @@ enum {
 	EXT4_STATE_FC_COMMITTING,	/* Fast commit ongoing */
 	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
 	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
+	EXT4_STATE_FC_REQUEUE,		/* Inode modified during fast commit */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index dc19795dacdd..5ed884cc4b5c 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -61,9 +61,8 @@
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
@@ -217,6 +216,7 @@ void ext4_fc_init_inode(struct inode *inode)
 
 	ext4_fc_reset_inode(inode);
 	ext4_clear_inode_state(inode, EXT4_STATE_FC_COMMITTING);
+	ext4_clear_inode_state(inode, EXT4_STATE_FC_REQUEUE);
 	INIT_LIST_HEAD(&ei->i_fc_list);
 	INIT_LIST_HEAD(&ei->i_fc_dilist);
 	ei->i_fc_snap = NULL;
@@ -251,22 +251,30 @@ void ext4_fc_del(struct inode *inode)
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
+#if (BITS_PER_LONG < 64)
+		DEFINE_WAIT_BIT(wait, &ei->i_state_flags,
+				EXT4_STATE_FC_COMMITTING);
+		wq = bit_waitqueue(&ei->i_state_flags,
+				   EXT4_STATE_FC_COMMITTING);
+#else
+		DEFINE_WAIT_BIT(wait, &ei->i_flags,
+				EXT4_STATE_FC_COMMITTING);
+		wq = bit_waitqueue(&ei->i_flags,
+				   EXT4_STATE_FC_COMMITTING);
+#endif
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
 #if (BITS_PER_LONG < 64)
 		DEFINE_WAIT_BIT(wait, &ei->i_state_flags,
@@ -287,19 +295,22 @@ void ext4_fc_del(struct inode *inode)
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
@@ -371,6 +382,8 @@ static int ext4_fc_track_template(
 
 	tid = handle->h_transaction->t_tid;
 	spin_lock(&ei->i_fc_lock);
+	if (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING))
+		ext4_set_inode_state(inode, EXT4_STATE_FC_REQUEUE);
 	if (tid == ei->i_sync_tid) {
 		update = true;
 	} else {
@@ -557,8 +570,6 @@ static int __track_inode(handle_t *handle, struct inode *inode, void *arg,
 
 void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 {
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	wait_queue_head_t *wq;
 	int ret;
 
 	if (S_ISDIR(inode->i_mode))
@@ -577,29 +588,11 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
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
-#if (BITS_PER_LONG < 64)
-		DEFINE_WAIT_BIT(wait, &ei->i_state_flags,
-				EXT4_STATE_FC_COMMITTING);
-		wq = bit_waitqueue(&ei->i_state_flags,
-				   EXT4_STATE_FC_COMMITTING);
-#else
-		DEFINE_WAIT_BIT(wait, &ei->i_flags,
-				EXT4_STATE_FC_COMMITTING);
-		wq = bit_waitqueue(&ei->i_flags,
-				   EXT4_STATE_FC_COMMITTING);
-#endif
-		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
-		if (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING))
-			schedule();
-		finish_wait(wq, &wait.wq_entry);
-	}
 
 	/*
 	 * From this point on, this inode will not be committed either
@@ -1526,32 +1519,32 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 
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
 #if (BITS_PER_LONG < 64)
-- 
2.53.0

