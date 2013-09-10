From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/2] ext4: use kobj_completion in ext4_sb_info
Date: Tue, 10 Sep 2013 13:44:13 -0400
Message-ID: <522F5A6D.50100@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Greg KH <gregkh@linux.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab3IJRoS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Sep 2013 13:44:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we have the kobj_completion structure available, let's use it
in ext4.

Note that we aggregate the del/put/wait_for_completion in one
kobj_completion_del_and_wait call. Since the kobject isn't used for
anything while the fs is shutting down and we wait until it's released
before continuing anyway, this is safe.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/ext4/ext4.h  |    4 ++--
 fs/ext4/super.c |   41 ++++++++++++-----------------------------
 2 files changed, 14 insertions(+), 31 deletions(-)

--- a/fs/ext4/ext4.h	2013-09-03 11:23:20.054928553 -0400
+++ b/fs/ext4/ext4.h	2013-09-10 13:03:42.794548845 -0400
@@ -30,6 +30,7 @@
 #include <linux/blockgroup_lock.h>
 #include <linux/percpu_counter.h>
 #include <crypto/hash.h>
+#include <linux/kobj_completion.h>
 #ifdef __KERNEL__
 #include <linux/compat.h>
 #endif
@@ -1198,8 +1199,7 @@ struct ext4_sb_info {
 	struct percpu_counter s_dirtyclusters_counter;
 	struct blockgroup_lock *s_blockgroup_lock;
 	struct proc_dir_entry *s_proc;
-	struct kobject s_kobj;
-	struct completion s_kobj_unregister;
+	struct kobj_completion s_kobjc;
 	struct super_block *s_sb;

 	/* Journaling */
--- a/fs/ext4/super.c	2013-09-03 11:23:20.066928375 -0400
+++ b/fs/ext4/super.c	2013-09-10 13:04:16.702156431 -0400
@@ -793,7 +793,8 @@ static void ext4_put_super(struct super_
 		remove_proc_entry("options", sbi->s_proc);
 		remove_proc_entry(sb->s_id, ext4_proc_root);
 	}
-	kobject_del(&sbi->s_kobj);
+
+	kobj_completion_del_and_wait(&sbi->s_kobjc);

 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
@@ -832,12 +833,6 @@ static void ext4_put_super(struct super_
 	if (sbi->s_mmp_tsk)
 		kthread_stop(sbi->s_mmp_tsk);
 	sb->s_fs_info = NULL;
-	/*
-	 * Now that we are completely done shutting down the
-	 * superblock, we need to actually destroy the kobject.
-	 */
-	kobject_put(&sbi->s_kobj);
-	wait_for_completion(&sbi->s_kobj_unregister);
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
 	kfree(sbi->s_blockgroup_lock);
@@ -2622,11 +2617,12 @@ static struct attribute *ext4_feat_attrs
 	NULL,
 };

+#define kobj_to_sb_info(kobj) \
+	container_of(kobj, struct ext4_sb_info, s_kobjc.kc_kobj)
 static ssize_t ext4_attr_show(struct kobject *kobj,
 			      struct attribute *attr, char *buf)
 {
-	struct ext4_sb_info *sbi = container_of(kobj, struct ext4_sb_info,
-						s_kobj);
+	struct ext4_sb_info *sbi = kobj_to_sb_info(kobj);
 	struct ext4_attr *a = container_of(attr, struct ext4_attr, attr);

 	return a->show ? a->show(a, sbi, buf) : 0;
@@ -2636,19 +2632,12 @@ static ssize_t ext4_attr_store(struct ko
 			       struct attribute *attr,
 			       const char *buf, size_t len)
 {
-	struct ext4_sb_info *sbi = container_of(kobj, struct ext4_sb_info,
-						s_kobj);
+	struct ext4_sb_info *sbi = kobj_to_sb_info(kobj);
 	struct ext4_attr *a = container_of(attr, struct ext4_attr, attr);

 	return a->store ? a->store(a, sbi, buf, len) : 0;
 }

-static void ext4_sb_release(struct kobject *kobj)
-{
-	struct ext4_sb_info *sbi = container_of(kobj, struct ext4_sb_info,
-						s_kobj);
-	complete(&sbi->s_kobj_unregister);
-}

 static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
@@ -2658,18 +2647,13 @@ static const struct sysfs_ops ext4_attr_
 static struct kobj_type ext4_ktype = {
 	.default_attrs	= ext4_attrs,
 	.sysfs_ops	= &ext4_attr_ops,
-	.release	= ext4_sb_release,
+	.release	= kobj_completion_release,
 };

-static void ext4_feat_release(struct kobject *kobj)
-{
-	complete(&ext4_feat->f_kobj_unregister);
-}
-
 static struct kobj_type ext4_feat_ktype = {
 	.default_attrs	= ext4_feat_attrs,
 	.sysfs_ops	= &ext4_attr_ops,
-	.release	= ext4_feat_release,
+	.release	= kobj_completion_release,
 };

 /*
@@ -4066,10 +4050,9 @@ no_journal:
 	if (err)
 		goto failed_mount6;

-	sbi->s_kobj.kset = ext4_kset;
-	init_completion(&sbi->s_kobj_unregister);
-	err = kobject_init_and_add(&sbi->s_kobj, &ext4_ktype, NULL,
-				   "%s", sb->s_id);
+	sbi->s_kobjc.kc_kobj.kset = ext4_kset;
+	kobj_completion_init(&sbi->s_kobjc, &ext4_ktype);
+	err = kobject_add(&sbi->s_kobjc.kc_kobj, NULL, "%s", sb->s_id);
 	if (err)
 		goto failed_mount7;

@@ -4125,7 +4108,7 @@ cantfind_ext4:

 #ifdef CONFIG_QUOTA
 failed_mount8:
-	kobject_del(&sbi->s_kobj);
+	kobj_completion_del_and_wait(&sbi->s_kobjc);
 #endif
 failed_mount7:
 	ext4_unregister_li_request(sb);

-- 
Jeff Mahoney
SUSE Labs
