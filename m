Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43FF3CCA1B
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 12:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773921837; cv=none; b=kHAzGdbrWtAx7qa2v6Bct8Ts0yfMcDgL4lAoBvyUELl3onS7FYlSEfnFhOrqvk7L8AW2GzsBU1RdCPlqZZFVFmmWv0N1ju9GuVPopHl/9M1D4O42Y48pOHjqxZcKdTq8MckIx/92qHZ2hErI+cZ16WbEmIiooXG552DizIwuvZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773921837; c=relaxed/simple;
	bh=TTFnU2uI25t0qEo42B6KZAMQJpcObMb+KlmoN6QG7I4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WNH9E+Kd4YBNAUQUcIsBMplxW/leQndNK6Cve0uC7nVI7V619d8w8cJ0LaO9YNngAL1loGFcgLhdbZKWw7cSe0fXWqpDmlUc9+daZZ3DWX6o/LAjh/zrjV58Ugj8UpCImocaIm1sRLnlC8RFmnd/nFRs1VBWSuJ0k/7/zGRwX4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SaZgfOkY; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SaZgfOkY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773921824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6MO9AsQ8DAUmqB+eLEHX2w5WKMYH0ZssEs2tf/RuVa8=;
	b=SaZgfOkY0YFPM1er/MXT7U0jr+TPg4AfO0QUN7by68x59xOmXmPyFGr4bk8j0jBS3RJZHW
	YPHlKvP/GnxNR88xE0PzR+KeuQsI+xf7+2DdaxQ/C8Z6IVHs+RwGyjfXqlBGSZlwYPM1vc
	E5GQKNBisRHlv3JzxftrhH9WQkAvWl0=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-ext4@vger.kernel.org,
	jack@suse.cz
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Ritesh Harjani <riteshh@linux.ibm.com>,
	Ye Bin <yebin10@huawei.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] ext4: fix use-after-free in update_super_work when racing with umount
Date: Thu, 19 Mar 2026 20:03:35 +0800
Message-ID: <20260319120336.157873-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Commit b98535d09179 ("ext4: fix bug_on in start_this_handle during umount
filesystem") moved ext4_unregister_sysfs() before flushing s_sb_upd_work
to prevent new error work from being queued via /proc/fs/ext4/xx/mb_groups
reads during unmount. However, this introduced a use-after-free because
update_super_work calls ext4_notify_error_sysfs() -> sysfs_notify() which
accesses the kobject's kernfs_node after it has been freed by kobject_del()
in ext4_unregister_sysfs():

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

Instead of reordering the teardown sequence, fix this by making
ext4_notify_error_sysfs() detect that sysfs has already been torn down
by checking s_kobj.state_in_sysfs, and skipping the sysfs_notify() call
in that case. A dedicated mutex (s_error_notify_mutex) serializes
ext4_notify_error_sysfs() against kobject_del() in ext4_unregister_sysfs()
to prevent TOCTOU races where the kobject could be deleted between the
state_in_sysfs check and the sysfs_notify() call.

Fixes: b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

---
v2 -> v3: Fix issues reported by AI.
https://sashiko.dev/#/patchset/20260319073651.79209-1-jiayuan.chen%40linux.dev

v1 -> v2: Use state_in_sysfs instead of reordering the teardown
sequence.
https://lore.kernel.org/linux-ext4/20260313065206.152645-1-jiayuan.chen@linux.dev/
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c |  1 +
 fs/ext4/sysfs.c | 10 +++++++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b76966dc06c0..c012e85d2515 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1574,6 +1574,7 @@ struct ext4_sb_info {
 	struct proc_dir_entry *s_proc;
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
+	struct mutex s_error_notify_mutex; /* protects sysfs_notify vs kobject_del */
 	struct super_block *s_sb;
 	struct buffer_head *s_mmp_bh;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 752f414aa06b..b2d58a9b0413 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5397,6 +5397,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 
 	timer_setup(&sbi->s_err_report, print_daily_error_info, 0);
 	spin_lock_init(&sbi->s_error_lock);
+	mutex_init(&sbi->s_error_notify_mutex);
 	INIT_WORK(&sbi->s_sb_upd_work, update_super_work);
 
 	err = ext4_group_desc_init(sb, es, logical_sb_block, &first_not_zeroed);
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index d2ecc1026c0c..0503bf02aea1 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -597,7 +597,10 @@ static const struct kobj_type ext4_feat_ktype = {
 
 void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)
 {
-	sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
+	mutex_lock(&sbi->s_error_notify_mutex);
+	if (sbi->s_kobj.state_in_sysfs)
+		sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
+	mutex_unlock(&sbi->s_error_notify_mutex);
 }
 
 static struct kobject *ext4_root;
@@ -610,8 +613,10 @@ int ext4_register_sysfs(struct super_block *sb)
 	int err;
 
 	init_completion(&sbi->s_kobj_unregister);
+	mutex_lock(&sbi->s_error_notify_mutex);
 	err = kobject_init_and_add(&sbi->s_kobj, &ext4_sb_ktype, ext4_root,
 				   "%s", sb->s_id);
+	mutex_unlock(&sbi->s_error_notify_mutex);
 	if (err) {
 		kobject_put(&sbi->s_kobj);
 		wait_for_completion(&sbi->s_kobj_unregister);
@@ -644,7 +649,10 @@ void ext4_unregister_sysfs(struct super_block *sb)
 
 	if (sbi->s_proc)
 		remove_proc_subtree(sb->s_id, ext4_proc_root);
+
+	mutex_lock(&sbi->s_error_notify_mutex);
 	kobject_del(&sbi->s_kobj);
+	mutex_unlock(&sbi->s_error_notify_mutex);
 }
 
 int __init ext4_init_sysfs(void)
-- 
2.43.0

