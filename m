From: Riccardo Schirone <sirmy15@gmail.com>
Subject: [PATCH 1/3] fs/ext4: release kobject/kset even when init/register fail
Date: Tue, 28 Nov 2017 00:17:59 +0100
Message-ID: <20171127231801.27652-2-sirmy15@gmail.com>
References: <20171127231801.27652-1-sirmy15@gmail.com>
Cc: Riccardo Schirone <sirmy15@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34459 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752759AbdK0XSU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Nov 2017 18:18:20 -0500
Received: by mail-wr0-f194.google.com with SMTP id k18so23143325wre.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2017 15:18:19 -0800 (PST)
In-Reply-To: <20171127231801.27652-1-sirmy15@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Even when kobject_init_and_add/kset_register fail, the kobject has been
already initialized and the refcount set to 1. Thus it is necessary to
release the kobject/kset, to avoid the memory associated with it hanging
around forever.

Signed-off-by: Riccardo Schirone <sirmy15@gmail.com>
---
 fs/ext4/sysfs.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 48c7a7d55ed3..b096e157934f 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -395,8 +395,11 @@ int ext4_register_sysfs(struct super_block *sb)
 	init_completion(&sbi->s_kobj_unregister);
 	err = kobject_init_and_add(&sbi->s_kobj, &ext4_sb_ktype, NULL,
 				   "%s", sb->s_id);
-	if (err)
+	if (err) {
+		kobject_put(&sbi->s_kobj);
+		wait_for_completion(&sbi->s_kobj_unregister);
 		return err;
+	}
 
 	if (ext4_proc_root)
 		sbi->s_proc = proc_mkdir(sb->s_id, ext4_proc_root);
@@ -429,15 +432,19 @@ int __init ext4_init_sysfs(void)
 	kobject_set_name(&ext4_kset.kobj, "ext4");
 	ext4_kset.kobj.parent = fs_kobj;
 	ret = kset_register(&ext4_kset);
-	if (ret)
+	if (ret) {
+		kset_unregister(&ext4_kset);
 		return ret;
+	}
 
 	ret = kobject_init_and_add(&ext4_feat, &ext4_feat_ktype,
 				   NULL, "features");
-	if (ret)
+	if (ret) {
+		kobject_put(&ext4_feat);
 		kset_unregister(&ext4_kset);
-	else
+	} else {
 		ext4_proc_root = proc_mkdir(proc_dirname, NULL);
+	}
 	return ret;
 }
 
-- 
2.14.3
