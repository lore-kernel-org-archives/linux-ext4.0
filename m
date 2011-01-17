From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Unregister features interface on module unload
Date: Mon, 17 Jan 2011 16:00:37 +0100
Message-ID: <1295276437-27966-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, lczerner@redhat.com, sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab1AQPAo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jan 2011 10:00:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4 features interface was not properly unregistered which led to
problems while unloading/reloading ext4 module. This commit fixes that by
adding proper kobject unregistration code into ext4_exit_fs() as well as
fail-path of ext4_init_fs()

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/super.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb10a06..124d304 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4779,7 +4779,7 @@ static struct file_system_type ext4_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-int __init ext4_init_feat_adverts(void)
+static int __init ext4_init_feat_adverts(void)
 {
 	struct ext4_features *ef;
 	int ret = -ENOMEM;
@@ -4803,6 +4803,13 @@ out:
 	return ret;
 }
 
+static void ext4_exit_feat_adverts(void)
+{
+	kobject_put(&ext4_feat->f_kobj);
+	wait_for_completion(&ext4_feat->f_kobj_unregister);
+	kfree(ext4_feat);
+}
+
 static int __init ext4_init_fs(void)
 {
 	int err;
@@ -4849,7 +4856,7 @@ out1:
 out2:
 	ext4_exit_mballoc();
 out3:
-	kfree(ext4_feat);
+	ext4_exit_feat_adverts();
 	remove_proc_entry("fs/ext4", NULL);
 	kset_unregister(ext4_kset);
 out4:
@@ -4868,6 +4875,7 @@ static void __exit ext4_exit_fs(void)
 	destroy_inodecache();
 	ext4_exit_xattr();
 	ext4_exit_mballoc();
+	ext4_exit_feat_adverts();
 	remove_proc_entry("fs/ext4", NULL);
 	kset_unregister(ext4_kset);
 	ext4_exit_system_zone();
-- 
1.7.2.3

