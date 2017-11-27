From: Riccardo Schirone <sirmy15@gmail.com>
Subject: [PATCH 2/3] fs/ext4: create ext4_feat kobject dynamically
Date: Tue, 28 Nov 2017 00:18:00 +0100
Message-ID: <20171127231801.27652-3-sirmy15@gmail.com>
References: <20171127231801.27652-1-sirmy15@gmail.com>
Cc: Riccardo Schirone <sirmy15@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34820 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752411AbdK0XSV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Nov 2017 18:18:21 -0500
Received: by mail-wr0-f193.google.com with SMTP id w95so28139162wrc.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2017 15:18:20 -0800 (PST)
In-Reply-To: <20171127231801.27652-1-sirmy15@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

kobjects should always be allocated dynamically, because it is unknown
to whoever creates them when kobjects can be released.

Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>
---
 fs/ext4/sysfs.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index b096e157934f..c447f23cc876 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 #include <linux/proc_fs.h>
 
 #include "ext4.h"
@@ -350,11 +351,10 @@ static struct kset ext4_kset = {
 static struct kobj_type ext4_feat_ktype = {
 	.default_attrs	= ext4_feat_attrs,
 	.sysfs_ops	= &ext4_attr_ops,
+	.release	= (void (*)(struct kobject *))kfree,
 };
 
-static struct kobject ext4_feat = {
-	.kset	= &ext4_kset,
-};
+static struct kobject *ext4_feat;
 
 #define PROC_FILE_SHOW_DEFN(name) \
 static int name##_open(struct inode *inode, struct file *file) \
@@ -437,20 +437,31 @@ int __init ext4_init_sysfs(void)
 		return ret;
 	}
 
-	ret = kobject_init_and_add(&ext4_feat, &ext4_feat_ktype,
-				   NULL, "features");
-	if (ret) {
-		kobject_put(&ext4_feat);
-		kset_unregister(&ext4_kset);
-	} else {
-		ext4_proc_root = proc_mkdir(proc_dirname, NULL);
+	ext4_feat = kzalloc(sizeof(*ext4_feat), GFP_KERNEL);
+	if (!ext4_feat) {
+		ret = -ENOMEM;
+		goto kset_err;
 	}
+
+	ext4_feat->kset = &ext4_kset;
+	ret = kobject_init_and_add(ext4_feat, &ext4_feat_ktype,
+				   NULL, "features");
+	if (ret)
+		goto feat_err;
+
+	ext4_proc_root = proc_mkdir(proc_dirname, NULL);
+	return ret;
+
+feat_err:
+	kobject_put(ext4_feat);
+kset_err:
+	kset_unregister(&ext4_kset);
 	return ret;
 }
 
 void ext4_exit_sysfs(void)
 {
-	kobject_put(&ext4_feat);
+	kobject_put(ext4_feat);
 	kset_unregister(&ext4_kset);
 	remove_proc_entry(proc_dirname, NULL);
 	ext4_proc_root = NULL;
-- 
2.14.3
