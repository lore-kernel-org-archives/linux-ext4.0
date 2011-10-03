From: Yargil <yargil@free.fr>
Subject: [PATCH] ext4: don't work without procfs
Date: Mon,  3 Oct 2011 22:46:01 +0200
Message-ID: <1317674761-17837-1-git-send-email-yargil@free.fr>
Cc: Yargil <yargil@free.fr>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:50573 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab1JCUqV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 16:46:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Regression from commit dd68314ccf3fb918c1fb6471817edbc60ece4b52
---
 fs/ext4/super.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..8e7298d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -53,7 +53,9 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
 
+#ifdef CONFIG_PROC_FS
 static struct proc_dir_entry *ext4_proc_root;
+#endif
 static struct kset *ext4_kset;
 static struct ext4_lazy_init *ext4_li_info;
 static struct mutex ext4_li_mtx;
@@ -812,9 +814,11 @@ static void ext4_put_super(struct super_block *sb)
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 		ext4_commit_super(sb, 1);
 	}
+#ifdef CONFIG_PROC_FS
 	if (sbi->s_proc) {
 		remove_proc_entry(sb->s_id, ext4_proc_root);
 	}
+#endif
 	kobject_del(&sbi->s_kobj);
 
 	for (i = 0; i < sbi->s_gdb_count; i++)
@@ -4984,9 +4988,11 @@ static int __init ext4_init_fs(void)
 	ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
 	if (!ext4_kset)
 		goto out6;
+#ifdef CONFIG_PROC_FS
 	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
 	if (!ext4_proc_root)
 		goto out5;
+#endif
 
 	err = ext4_init_feat_adverts();
 	if (err)
@@ -5022,8 +5028,10 @@ out2:
 out3:
 	ext4_exit_feat_adverts();
 out4:
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("fs/ext4", NULL);
 out5:
+#endif
 	kset_unregister(ext4_kset);
 out6:
 	ext4_exit_system_zone();
-- 
1.7.2.5

