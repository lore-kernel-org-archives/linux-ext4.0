Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A003E6391;
	Wed, 13 May 2026 09:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662807; cv=pass; b=FvgTUB6ssT/VP94vbgZMadmj0SSunE0GRz8nEr7l+cBQ8VLArWAZ6GTh5bWEhfhrmt3V40zWal054p1gnZWC5EsIy3nowU5lVcjresA7LjDXmLSnqWjgKtTeCN1/PykG/KGtUWRO8jZ5WrBXyHCN1Gzlh0A9Fn1YWrFFGuSpm1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662807; c=relaxed/simple;
	bh=1x7FzaR+KKV0HiMyw30vSr5FdLUKdkXayth19UrZIAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=edozY9Ag5n6V+0qSxNwVj/Ez4uYV93230fxbV7AN22J0I4WbKL3+fVTo3PwEUSVCJAyuFTr7Ut0xOS9JbWaQ5vXvEpshXoHib3M1vnaiAto4MW+iFZk1msQ8KSU/qGtNq92wcp0AMfxp19Ql1oJft6B7AxLBy1zUKGgXBVRZC74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=pfoT54Pn; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="pfoT54Pn"
ARC-Seal: i=1; a=rsa-sha256; t=1778662772; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mEoiWKpCFVZI4x3NNvdV0T2tGq0XdHmJCmqoHK8V3SjPu61O2CnScWqrvXc6RjnH3Om6Z1zUNCrNbTz2Jihjxbg5Zk26CjxF+Hy1yAF8AKn0v8sHzlYhvkz8XRJEO3RY47THEmYzM3Qo4+MrWRGcqYOxGKXslzIKaUdSBCB2fNY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778662772; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Svvy6b6xJ+8FL+W9lbK9htB2vRX1BuPW5ed/K952k3M=; 
	b=dc8SwNEjtw4NaHd/8xMzrKIwKKLBR85nogioAQUpHRBGD9ZHsk3Rz4oe1KiQk+V7wC5ySAnJ5kgqcungORff0cJhLuXci400rtZ+/cVP9UKkxefTmmbpdfZKWz96BwN2BaA3S7yy6alShEYrdlPcx1PAFc+nerLXXNY4AkYJmPQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778662772;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Svvy6b6xJ+8FL+W9lbK9htB2vRX1BuPW5ed/K952k3M=;
	b=pfoT54PnXsChr7hgnCc4Lc/N3anrsBZzY8LkDk+wcdvDbAtL5R/rkQz5POKibdsA
	CNlT8N5H2DN6RAxemIoDTSwR0mvECx7DYwKrFlbazAfnpceoDJBuXwlM/jeLpaw9Ofa
	1nn0b80tkANYy7ThS9BE836yB5/dSrJTjQeG+LA8=
Received: by mx.zohomail.com with SMTPS id 1778662769181568.228237150514;
	Wed, 13 May 2026 01:59:29 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>
Subject: [PATCH] ext4: fix fast commit wait/wake bit mapping on 64-bit
Date: Wed, 13 May 2026 16:58:17 +0800
Message-ID: <20260513085818.552432-1-me@linux.beauty>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On 64-bit, ext4 dynamic inode states live in the upper half of i_flags,
and ext4_test_inode_state() applies the corresponding +32 offset.

The fast-commit wait and wake paths open-coded the wait key with the raw
EXT4_STATE_* value. Add small helpers for the state wait word and bit,
and use them for the FC_COMMITTING and FC_FLUSHING_DATA waits so the wait
key follows the same mapping as the state helpers.

Fixes: 857d32f26181 ("ext4: rework fast commit commit path")
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
 fs/ext4/ext4.h        | 20 +++++++++++++++++
 fs/ext4/fast_commit.c | 50 ++++++++++++++++---------------------------
 2 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 94283a991e5c..6569d1d575a0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2000,6 +2000,8 @@ EXT4_INODE_BIT_FNS(flag, flags, 0)
 static inline int ext4_test_inode_state(struct inode *inode, int bit);
 static inline void ext4_set_inode_state(struct inode *inode, int bit);
 static inline void ext4_clear_inode_state(struct inode *inode, int bit);
+static inline unsigned long *ext4_inode_state_wait_word(struct inode *inode);
+static inline int ext4_inode_state_wait_bit(int bit);
 #if (BITS_PER_LONG < 64)
 EXT4_INODE_BIT_FNS(state, state_flags, 0)
 
@@ -2015,6 +2017,24 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 	/* We depend on the fact that callers will set i_flags */
 }
 #endif
+
+static inline unsigned long *ext4_inode_state_wait_word(struct inode *inode)
+{
+#if (BITS_PER_LONG < 64)
+	return &EXT4_I(inode)->i_state_flags;
+#else
+	return &EXT4_I(inode)->i_flags;
+#endif
+}
+
+static inline int ext4_inode_state_wait_bit(int bit)
+{
+#if (BITS_PER_LONG < 64)
+	return bit;
+#else
+	return bit + 32;
+#endif
+}
 #else
 /* Assume that user mode programs are passing in an ext4fs superblock, not
  * a kernel struct super_block.  This will allow us to call the feature-test
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b3c22636251d..1775bce9649a 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -239,6 +239,8 @@ void ext4_fc_del(struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_fc_dentry_update *fc_dentry;
 	wait_queue_head_t *wq;
+	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
+	int wait_bit = ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
 	int alloc_ctx;
 
 	if (ext4_fc_disabled(inode->i_sb))
@@ -268,17 +270,9 @@ void ext4_fc_del(struct inode *inode)
 	WARN_ON(ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)
 		&& !ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE));
 	while (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
-#if (BITS_PER_LONG < 64)
-		DEFINE_WAIT_BIT(wait, &ei->i_state_flags,
-				EXT4_STATE_FC_FLUSHING_DATA);
-		wq = bit_waitqueue(&ei->i_state_flags,
-				   EXT4_STATE_FC_FLUSHING_DATA);
-#else
-		DEFINE_WAIT_BIT(wait, &ei->i_flags,
-				EXT4_STATE_FC_FLUSHING_DATA);
-		wq = bit_waitqueue(&ei->i_flags,
-				   EXT4_STATE_FC_FLUSHING_DATA);
-#endif
+		DEFINE_WAIT_BIT(wait, wait_word, wait_bit);
+
+		wq = bit_waitqueue(wait_word, wait_bit);
 		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
 		if (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
 			ext4_fc_unlock(inode->i_sb, alloc_ctx);
@@ -542,6 +536,8 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	wait_queue_head_t *wq;
+	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
+	int wait_bit = ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
 	int ret;
 
 	if (S_ISDIR(inode->i_mode))
@@ -564,17 +560,9 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 	lockdep_assert_not_held(&ei->i_data_sem);
 
 	while (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)) {
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
+		DEFINE_WAIT_BIT(wait, wait_word, wait_bit);
+
+		wq = bit_waitqueue(wait_word, wait_bit);
 		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
 		if (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING))
 			schedule();
@@ -1034,6 +1022,8 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	int ret = 0;
 	u32 crc = 0;
 	int alloc_ctx;
+	int flushing_wait_bit =
+		ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
 
 	/*
 	 * Step 1: Mark all inodes on s_fc_q[MAIN] with
@@ -1059,11 +1049,8 @@ static int ext4_fc_perform_commit(journal_t *journal)
 	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		ext4_clear_inode_state(&iter->vfs_inode,
 				       EXT4_STATE_FC_FLUSHING_DATA);
-#if (BITS_PER_LONG < 64)
-		wake_up_bit(&iter->i_state_flags, EXT4_STATE_FC_FLUSHING_DATA);
-#else
-		wake_up_bit(&iter->i_flags, EXT4_STATE_FC_FLUSHING_DATA);
-#endif
+		wake_up_bit(ext4_inode_state_wait_word(&iter->vfs_inode),
+			    flushing_wait_bit);
 	}
 
 	/*
@@ -1279,6 +1266,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 	struct ext4_inode_info *ei;
 	struct ext4_fc_dentry_update *fc_dentry;
 	int alloc_ctx;
+	int committing_wait_bit =
+		ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
 
 	if (full && sbi->s_fc_bh)
 		sbi->s_fc_bh = NULL;
@@ -1315,11 +1304,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 		 * barrier in prepare_to_wait() in ext4_fc_track_inode().
 		 */
 		smp_mb();
-#if (BITS_PER_LONG < 64)
-		wake_up_bit(&ei->i_state_flags, EXT4_STATE_FC_COMMITTING);
-#else
-		wake_up_bit(&ei->i_flags, EXT4_STATE_FC_COMMITTING);
-#endif
+		wake_up_bit(ext4_inode_state_wait_word(&ei->vfs_inode),
+			    committing_wait_bit);
 	}
 
 	while (!list_empty(&sbi->s_fc_dentry_q[FC_Q_MAIN])) {
-- 
2.53.0

