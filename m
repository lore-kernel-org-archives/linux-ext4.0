Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7975F3E63A1;
	Fri, 15 May 2026 09:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778836887; cv=pass; b=UT4woxVf2NnVVSCKZDHTrJlU6tY1AN3Lb0mtVh0j9mJcn8WmtlT02quwta2tQDbtjxja4YyQ/X8cE+jqFC+AAMhMbFTMUSBsyK8BDn5U0gKjZyz1A9ueSCJVvEpAKRGmF9NGLT3+yGUz4TDd3BjDOXK8gq4IxAMmslnBcmjPQ/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778836887; c=relaxed/simple;
	bh=Xt/ahvJmwKHteBIpVw53WzFYa54uGiIc5Bo5tfB31Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4tqFZjJq0qLm5XdtEUWCRG0AXqbEUFX66At88HLXnnLCHyegs/7U/I42SIay/fc4ml3MEYO2QU/T/4NxRcJF80DWu2ztVzvb68f76ZwuiYiaBEQBp+i9yOdnHacvMHXjK7EuytIQR9bEVwuDw6NxvkmeO6Xo6j+iVyA0XkHIi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=iYkSbIo6; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="iYkSbIo6"
ARC-Seal: i=1; a=rsa-sha256; t=1778836744; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=InrSNpUr6z9xbgjh92w6rn2llEuZ9E9HTBk7aAAv2Z03CRB9++Z2x/fMjkTIvsUy+dkvg5hMl6O0KGRN+dn7OY3gKAWbd01ITeLCgNd0n4wHIzi7fDY4pKK8cQwSMeDbBXuHnmv1kkuPMaEN1pkisC1xTQHqe7+Z9oJp12oqvZo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778836744; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Sz8qtSYhZtjZ4PMIfLjdvl6NlWuqHAph/mv9kOZyj48=; 
	b=c8IjSnbBLNpMa+WMTLFpDjSdY6EpzMgAKMxtB3BDzFhiD1wBFQq6a9hjJlJDMoA03Dcs2weMUSEri0R/RFyW9qzlKgBMmYBB6VRFkm4G0uCH7Q8LiBd7UHdZmKMOxRK5+uoNZu1v8rdyLsCzfzXefals/cWwKNClA0RRDhO7GEM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778836744;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Sz8qtSYhZtjZ4PMIfLjdvl6NlWuqHAph/mv9kOZyj48=;
	b=iYkSbIo6xcgc0/3k0xTeo+xg+APmv00IcNQPIaSvTMOmJwlEe7IPQ9UV8dycI/6a
	BXnAEhPIUatELx9vHyvKsjD0NYfLITnMTSq7kFXZmaeps7gUUenxzXAUXcBp2aINIO8
	MMSbFJr4DCSCO5e52Yx+b4viJp8CiP3HjTaPj+D8=
Received: by mx.zohomail.com with SMTPS id 1778836742942651.9187030545834;
	Fri, 15 May 2026 02:19:02 -0700 (PDT)
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
Subject: [RFC v8 4/7] ext4: fast commit: avoid self-deadlock in inode snapshotting
Date: Fri, 15 May 2026 17:18:24 +0800
Message-ID: <20260515091829.194810-5-me@linux.beauty>
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

ext4_fc_snapshot_inodes() used igrab()/iput() to pin inodes while building
commit-time snapshots. With ext4_fc_del() waiting for
EXT4_STATE_FC_COMMITTING, iput() can trigger
ext4_clear_inode()->ext4_fc_del() in the commit thread and deadlock waiting
for the fast commit to finish.

ext4_fc_del() also has to re-check EXT4_STATE_FC_COMMITTING after
waiting on EXT4_STATE_FC_FLUSHING_DATA. The commit thread clears
FLUSHING_DATA before it sets COMMITTING, so a waiter woken from the
flush wait must not delete the inode based on an old COMMITTING
check.

Avoid taking extra references. Collect inode pointers under s_fc_lock and
rely on EXT4_STATE_FC_COMMITTING to pin inodes until ext4_fc_cleanup()
clears the bit.

Also set EXT4_STATE_FC_COMMITTING for create-only inodes referenced
from the dentry update queue, and wake up waiters when ext4_fc_cleanup()
clears the bit.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
Changes in v8:
- Factor out small ext4_fc_wait_inode_state()/ext4_fc_wake_inode_state()
  helpers so the repeated FC state wait/wake mapping is kept in one place.
- Re-check EXT4_STATE_FC_COMMITTING after waking from
  EXT4_STATE_FC_FLUSHING_DATA in ext4_fc_del(), so list deletion only
  happens after both predicates pass under the same s_fc_lock critical
  section.

 fs/ext4/fast_commit.c | 124 +++++++++++++++++++++++++-----------------
 1 file changed, 75 insertions(+), 49 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 673668860e2d..8a6981e50ffe 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -235,6 +235,37 @@ static bool ext4_fc_eligible(struct super_block *sb)
 		!(ext4_test_mount_flag(sb, EXT4_MF_FC_INELIGIBLE));
 }
 
+/*
+ * Wait for an inode fast-commit state bit to clear while dropping the
+ * fast-commit lock around schedule().
+ */
+static void ext4_fc_wait_inode_state(struct inode *inode, int bit,
+				     int *alloc_ctx)
+{
+	wait_queue_head_t *wq;
+	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
+	int wait_bit = ext4_inode_state_wait_bit(bit);
+
+	while (ext4_test_inode_state(inode, bit)) {
+		DEFINE_WAIT_BIT(wait, wait_word, wait_bit);
+
+		wq = bit_waitqueue(wait_word, wait_bit);
+		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
+		if (ext4_test_inode_state(inode, bit)) {
+			ext4_fc_unlock(inode->i_sb, *alloc_ctx);
+			schedule();
+			*alloc_ctx = ext4_fc_lock(inode->i_sb);
+		}
+		finish_wait(wq, &wait.wq_entry);
+	}
+}
+
+static inline void ext4_fc_wake_inode_state(struct inode *inode, int bit)
+{
+	wake_up_bit(ext4_inode_state_wait_word(inode),
+		    ext4_inode_state_wait_bit(bit));
+}
+
 /*
  * Remove inode from fast commit list. If the inode is being committed
  * we wait until inode commit is done.
@@ -243,12 +274,6 @@ void ext4_fc_del(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_dentry_update *fc_dentry;
-	wait_queue_head_t *wq;
-	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
-	int committing_wait_bit =
-		ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
-	int flushing_wait_bit =
-		ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
 	int alloc_ctx;
 
 	if (ext4_fc_disabled(inode->i_sb))
@@ -263,32 +288,19 @@ void ext4_fc_del(struct inode *inode)
 
 	/*
 	 * Wait for ongoing fast commit to finish. We cannot remove the inode
-	 * from fast commit lists while it is being committed.
+	 * from fast commit lists while it is being committed. If we wake from
+	 * FC_FLUSHING_DATA, re-check FC_COMMITTING before deleting because the
+	 * commit thread sets FC_COMMITTING only after clearing FLUSHING_DATA.
 	 */
-	while (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)) {
-		DEFINE_WAIT_BIT(wait, wait_word, committing_wait_bit);
+	for (;;) {
+		ext4_fc_wait_inode_state(inode, EXT4_STATE_FC_COMMITTING,
+					 &alloc_ctx);
 
-		wq = bit_waitqueue(wait_word, committing_wait_bit);
-		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
-		if (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)) {
-			ext4_fc_unlock(inode->i_sb, alloc_ctx);
-			schedule();
-			alloc_ctx = ext4_fc_lock(inode->i_sb);
-		}
-		finish_wait(wq, &wait.wq_entry);
-	}
-
-	while (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
-		DEFINE_WAIT_BIT(wait, wait_word, flushing_wait_bit);
+		if (!ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA))
+			break;
 
-		wq = bit_waitqueue(wait_word, flushing_wait_bit);
-		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
-		if (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
-			ext4_fc_unlock(inode->i_sb, alloc_ctx);
-			schedule();
-			alloc_ctx = ext4_fc_lock(inode->i_sb);
-		}
-		finish_wait(wq, &wait.wq_entry);
+		ext4_fc_wait_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA,
+					 &alloc_ctx);
 	}
 
 	ext4_fc_free_inode_snap(inode);
@@ -1184,13 +1196,12 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
-		inodes[i] = igrab(&iter->vfs_inode);
-		if (inodes[i])
-			i++;
+		inodes[i++] = &iter->vfs_inode;
 	}
 
 	list_for_each_entry(fc_dentry, &sbi->s_fc_dentry_q[FC_Q_MAIN], fcd_list) {
 		struct ext4_inode_info *ei;
+		struct inode *inode;
 
 		if (fc_dentry->fcd_op != EXT4_FC_TAG_CREAT)
 			continue;
@@ -1200,12 +1211,20 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 		/* See the comment in ext4_fc_commit_dentry_updates(). */
 		ei = list_first_entry(&fc_dentry->fcd_dilist,
 				      struct ext4_inode_info, i_fc_dilist);
+		inode = &ei->vfs_inode;
 		if (!list_empty(&ei->i_fc_list))
 			continue;
 
-		inodes[i] = igrab(&ei->vfs_inode);
-		if (inodes[i])
-			i++;
+		/*
+		 * Create-only inodes may only be referenced via fcd_dilist and
+		 * not appear on s_fc_q[MAIN]. They may hit the last iput while
+		 * we are snapshotting, but inode eviction calls ext4_fc_del(),
+		 * which waits for FC_COMMITTING to clear. Mark them FC_COMMITTING
+		 * so the inode stays pinned and the snapshot stays valid until
+		 * ext4_fc_cleanup().
+		 */
+		ext4_set_inode_state(inode, EXT4_STATE_FC_COMMITTING);
+		inodes[i++] = inode;
 	}
 	ext4_fc_unlock(sb, alloc_ctx);
 
@@ -1215,10 +1234,6 @@ static int ext4_fc_snapshot_inodes(journal_t *journal)
 			break;
 	}
 
-	for (nr_inodes = 0; nr_inodes < i; nr_inodes++) {
-		if (inodes[nr_inodes])
-			iput(inodes[nr_inodes]);
-	}
 	kvfree(inodes);
 	return ret;
 }
@@ -1234,8 +1249,6 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	int ret = 0;
 	u32 crc = 0;
 	int alloc_ctx;
-	int flushing_wait_bit =
-		ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
 
 	/*
 	 * Step 1: Mark all inodes on s_fc_q[MAIN] with
@@ -1261,8 +1274,8 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		ext4_clear_inode_state(&iter->vfs_inode,
 				       EXT4_STATE_FC_FLUSHING_DATA);
-		wake_up_bit(ext4_inode_state_wait_word(&iter->vfs_inode),
-			    flushing_wait_bit);
+		ext4_fc_wake_inode_state(&iter->vfs_inode,
+					 EXT4_STATE_FC_FLUSHING_DATA);
 	}
 
 	/*
@@ -1285,8 +1298,9 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	jbd2_journal_lock_updates(journal);
 	/*
 	 * The journal is now locked. No more handles can start and all the
-	 * previous handles are now drained. We now mark the inodes on the
-	 * commit queue as being committed.
+	 * previous handles are now drained. Snapshotting happens in this
+	 * window so log writing can consume only stable snapshots without
+	 * doing logical-to-physical mapping.
 	 */
 	alloc_ctx = ext4_fc_lock(sb);
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
@@ -1482,8 +1496,6 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 	struct ext4_inode_info *ei;
 	struct ext4_fc_dentry_update *fc_dentry;
 	int alloc_ctx;
-	int committing_wait_bit =
-		ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
 
 	if (full && sbi->s_fc_bh)
 		sbi->s_fc_bh = NULL;
@@ -1521,8 +1533,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 		 * barrier in prepare_to_wait() in ext4_fc_del().
 		 */
 		smp_mb();
-		wake_up_bit(ext4_inode_state_wait_word(&ei->vfs_inode),
-			    committing_wait_bit);
+		ext4_fc_wake_inode_state(&ei->vfs_inode,
+					 EXT4_STATE_FC_COMMITTING);
 	}
 
 	while (!list_empty(&sbi->s_fc_dentry_q[FC_Q_MAIN])) {
@@ -1537,6 +1549,20 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 					      struct ext4_inode_info,
 					      i_fc_dilist);
 			ext4_fc_free_inode_snap(&ei->vfs_inode);
+			spin_lock(&ei->i_fc_lock);
+			ext4_clear_inode_state(&ei->vfs_inode,
+					       EXT4_STATE_FC_REQUEUE);
+			ext4_clear_inode_state(&ei->vfs_inode,
+					       EXT4_STATE_FC_COMMITTING);
+			spin_unlock(&ei->i_fc_lock);
+			/*
+			 * Make sure clearing of EXT4_STATE_FC_COMMITTING is
+			 * visible before we send the wakeup. Pairs with implicit
+			 * barrier in prepare_to_wait() in ext4_fc_del().
+			 */
+			smp_mb();
+			ext4_fc_wake_inode_state(&ei->vfs_inode,
+						 EXT4_STATE_FC_COMMITTING);
 		}
 		list_del_init(&fc_dentry->fcd_dilist);
 
-- 
2.53.0
