Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9AE25B2F4
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 06:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773384752; cv=none; b=JywmbAr0YswULy/PDAp2KvdUDx12PTdyTlVmhaGhLfkRTlhpYDqGvX/j68jAriFMnLT7/TRytr3F1Fyj7KyB/chcUkQhPIa6kjbp7NjHOJoGMkpQN8cNTMKO2sKG7n6kHA/9w2THaYIX9YCLJIWmv/Gohr2y/24ItVVveaciRFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773384752; c=relaxed/simple;
	bh=lnXznoh4eRPDC1+AF5JR8t4zKh9zb7OBFMZMwg1gDyE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O44aGP8ffU/6QekKPwGBkXyp6qTkEc0snA0j6IZrI0cN8qotbPjMF/PB9DddD24a/WhV+e4/JNEAF6XztbQ4EfkpYq8tsg06we9UTDLzBg8TICYhcNA2Lwy8RaAajFZsOcRjJT6DSzXUZ4TotxvEdnb1gUIJ6IM4Co4+lNVX6MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A3AzdTPd; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A3AzdTPd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773384747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fCQmTQ1i3JDf1RGPzVxeU9rKKeNUhD3j3domEMgZg5A=;
	b=A3AzdTPdFQwMdXv++eKVPrlv7BTiZW1BT/LAMnq8l+t4CKkwVGBDLJuDwfwtcUuiyacc0u
	15J3tgpmJYlwLJIlX5Yvlm+Xe36275PWrN4L05nCpErWTIGMQpURVdwQpN1QYaKmiA7+4B
	oRj6/wGjdd3hHPV7ao5boL1/360nTjE=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-ext4@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Ritesh Harjani <riteshh@linux.ibm.com>,
	Ye Bin <yebin10@huawei.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] ext4: fix use-after-free in update_super_work when racing with umount
Date: Fri, 13 Mar 2026 14:52:04 +0800
Message-ID: <20260313065206.152645-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Commit b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
moved ext4_unregister_sysfs() before flushing s_sb_upd_work to prevent new
error work from being queued via /proc/fs/ext4/xx/mb_groups reads during
unmount. However, this introduced a use-after-free because
update_super_work calls ext4_notify_error_sysfs() -> sysfs_notify() which
accesses the kobject's kernfs_node after it has been freed:

  update_super_work                ext4_put_super
  -----------------                --------------
                                   ext4_unregister_sysfs(sb)
                                     kobject_del(&sbi->s_kobj)
                                       __kobject_del()
                                         sysfs_remove_dir()
                                           kobj->sd = NULL
                                         sysfs_put(sd)
                                           kernfs_put()  // RCU free
  ext4_notify_error_sysfs(sbi)
    sysfs_notify(&sbi->s_kobj)
      kn = kobj->sd              // stale pointer
      kernfs_get(kn)             // UAF on freed kernfs_node
                                   ext4_journal_destroy()
                                     flush_work(&sbi->s_sb_upd_work)

The original blamed commit needed procfs removal before the work
flush to prevent /proc/fs/ext4/xx/mb_groups reads from queuing new error
work. But it bundled procfs removal and kobject_del together in
ext4_unregister_sysfs(), causing the sysfs kobject to be torn down too
early.

The correct teardown ordering has three constraints:

  1. procfs removal must happen before flushing s_sb_upd_work, to prevent
     /proc reads from queuing new error work that would BUG_ON.
  2. sysfs kobject removal must happen after flushing s_sb_upd_work, since
     the work calls sysfs_notify() which accesses the kernfs_node.
  3. sysfs kobject removal must happen before jbd2_journal_destroy(), since
     userspace could read the journal_task sysfs attribute and dereference
     j_task after the journal thread has been killed.

Fix this by:
  - Adding ext4_sb_release_proc() to remove procfs entries early.
  - Splitting ext4_journal_destroy() into ext4_journal_stop_work() and
    ext4_journal_finish(), so that ext4_unregister_sysfs() can be placed
    between them to satisfy all three ordering constraints.

Fixes: b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 fs/ext4/ext4.h      |  1 +
 fs/ext4/ext4_jbd2.h | 45 ++++++++++++++++++++++++++++-----------------
 fs/ext4/super.c     | 34 +++++++++++++++++++++++-----------
 fs/ext4/sysfs.c     | 10 ++++++++++
 4 files changed, 62 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b76966dc06c0..a693365d224c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3757,6 +3757,7 @@ extern const struct inode_operations ext4_fast_symlink_inode_operations;
 /* sysfs.c */
 extern void ext4_notify_error_sysfs(struct ext4_sb_info *sbi);
 extern int ext4_register_sysfs(struct super_block *sb);
+extern void ext4_sb_release_proc(struct super_block *sb);
 extern void ext4_unregister_sysfs(struct super_block *sb);
 extern int __init ext4_init_sysfs(void);
 extern void ext4_exit_sysfs(void);
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 63d17c5201b5..2b7d68b11578 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -430,32 +430,43 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 }
 
 /*
- * Pass journal explicitly as it may not be cached in the sbi->s_journal in some
- * cases
+ * Stop new s_sb_upd_work from being queued and flush any pending work.
+ *
+ * At this point only two things can be operating on the journal:
+ * JBD2 thread performing transaction commit and s_sb_upd_work
+ * issuing sb update through the journal. Once we set
+ * EXT4_MF_JOURNAL_DESTROY, new ext4_handle_error() calls will not
+ * queue s_sb_upd_work and ext4_force_commit() makes sure any
+ * ext4_handle_error() calls from the running transaction commit are
+ * finished. Hence no new s_sb_upd_work can be queued after we
+ * flush it here.
  */
-static inline int ext4_journal_destroy(struct ext4_sb_info *sbi, journal_t *journal)
+static inline void ext4_journal_stop_work(struct ext4_sb_info *sbi)
 {
-	int err = 0;
-
-	/*
-	 * At this point only two things can be operating on the journal.
-	 * JBD2 thread performing transaction commit and s_sb_upd_work
-	 * issuing sb update through the journal. Once we set
-	 * EXT4_JOURNAL_DESTROY, new ext4_handle_error() calls will not
-	 * queue s_sb_upd_work and ext4_force_commit() makes sure any
-	 * ext4_handle_error() calls from the running transaction commit are
-	 * finished. Hence no new s_sb_upd_work can be queued after we
-	 * flush it here.
-	 */
 	ext4_set_mount_flag(sbi->s_sb, EXT4_MF_JOURNAL_DESTROY);
-
 	ext4_force_commit(sbi->s_sb);
 	flush_work(&sbi->s_sb_upd_work);
+}
+
+/*
+ * Destroy the journal. Must be called after ext4_journal_stop_work().
+ * Pass journal explicitly as it may not be cached in the sbi->s_journal
+ * in some cases.
+ */
+static inline int ext4_journal_finish(struct ext4_sb_info *sbi,
+				      journal_t *journal)
+{
+	int err;
 
 	err = jbd2_journal_destroy(journal);
 	sbi->s_journal = NULL;
-
 	return err;
 }
 
+static inline int ext4_journal_destroy(struct ext4_sb_info *sbi, journal_t *journal)
+{
+	ext4_journal_stop_work(sbi);
+	return ext4_journal_finish(sbi, journal);
+}
+
 #endif	/* _EXT4_JBD2_H */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 752f414aa06b..9bba783f44e1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1280,16 +1280,12 @@ static void ext4_put_super(struct super_block *sb)
 	int err;
 
 	/*
-	 * Unregister sysfs before destroying jbd2 journal.
-	 * Since we could still access attr_journal_task attribute via sysfs
-	 * path which could have sbi->s_journal->j_task as NULL
-	 * Unregister sysfs before flush sbi->s_sb_upd_work.
-	 * Since user may read /proc/fs/ext4/xx/mb_groups during umount, If
-	 * read metadata verify failed then will queue error work.
-	 * update_super_work will call start_this_handle may trigger
-	 * BUG_ON.
+	 * Remove procfs entries before flush s_sb_upd_work. Since user may
+	 * read /proc/fs/ext4/xx/mb_groups during umount, if read metadata
+	 * verify failed then will queue error work. update_super_work will
+	 * call start_this_handle which may trigger BUG_ON.
 	 */
-	ext4_unregister_sysfs(sb);
+	ext4_sb_release_proc(sb);
 
 	if (___ratelimit(&ext4_mount_msg_ratelimit, "EXT4-fs unmount"))
 		ext4_msg(sb, KERN_INFO, "unmounting filesystem %pU.",
@@ -1301,14 +1297,30 @@ static void ext4_put_super(struct super_block *sb)
 	destroy_workqueue(sbi->rsv_conversion_wq);
 	ext4_release_orphan_info(sb);
 
+	/*
+	 * Flush s_sb_upd_work before unregistering sysfs, since
+	 * update_super_work calls ext4_notify_error_sysfs() which accesses
+	 * the kobject's kernfs_node via sysfs_notify(). Unregistering sysfs
+	 * before the flush could lead to a use-after-free on the
+	 * kernfs_node.
+	 *
+	 * Also unregister sysfs before destroying jbd2 journal, since
+	 * userspace could read the journal_task sysfs attribute while
+	 * jbd2_journal_destroy() is killing the journal thread, leading to
+	 * a NULL pointer dereference of j_task in journal_task_show().
+	 */
 	if (sbi->s_journal) {
 		aborted = is_journal_aborted(sbi->s_journal);
-		err = ext4_journal_destroy(sbi, sbi->s_journal);
+		ext4_journal_stop_work(sbi);
+		ext4_unregister_sysfs(sb);
+		err = ext4_journal_finish(sbi, sbi->s_journal);
 		if ((err < 0) && !aborted) {
 			ext4_abort(sb, -err, "Couldn't clean up the journal");
 		}
-	} else
+	} else {
 		flush_work(&sbi->s_sb_upd_work);
+		ext4_unregister_sysfs(sb);
+	}
 
 	ext4_es_unregister_shrinker(sbi);
 	timer_shutdown_sync(&sbi->s_err_report);
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index d2ecc1026c0c..f6947416c1e7 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -638,6 +638,16 @@ int ext4_register_sysfs(struct super_block *sb)
 	return 0;
 }
 
+void ext4_sb_release_proc(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (sbi->s_proc) {
+		remove_proc_subtree(sb->s_id, ext4_proc_root);
+		sbi->s_proc = NULL;
+	}
+}
+
 void ext4_unregister_sysfs(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-- 
2.43.0

