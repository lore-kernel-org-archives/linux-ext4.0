From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Free resources in some error path in ext4_fill_super.
Date: Fri, 19 Aug 2011 23:28:09 +0800
Message-ID: <1313767689-2786-2-git-send-email-tm@tao.ma>
References: <1313767689-2786-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36953 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751832Ab1HSPaT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Aug 2011 11:30:19 -0400
Received: from [221.217.45.152] (helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1QuR1V-0004kH-TN
	for linux-ext4@vger.kernel.org; Fri, 19 Aug 2011 09:30:18 -0600
In-Reply-To: <1313767689-2786-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Some of the error path in ext4_fill_super don't release the
resouces properly. So this patch just try to release them
in the right way.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/super.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4687fea..552b465 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3711,22 +3711,19 @@ no_journal:
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
 			 err);
-		goto failed_mount4;
+		goto failed_mount5;
 	}
 
 	err = ext4_register_li_request(sb, first_not_zeroed);
 	if (err)
-		goto failed_mount4;
+		goto failed_mount6;
 
 	sbi->s_kobj.kset = ext4_kset;
 	init_completion(&sbi->s_kobj_unregister);
 	err = kobject_init_and_add(&sbi->s_kobj, &ext4_ktype, NULL,
 				   "%s", sb->s_id);
-	if (err) {
-		ext4_mb_release(sb);
-		ext4_ext_release(sb);
-		goto failed_mount4;
-	};
+	if (err)
+		goto failed_mount7;
 
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
@@ -3760,13 +3757,19 @@ cantfind_ext4:
 		ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
 	goto failed_mount;
 
+failed_mount7:
+	ext4_unregister_li_request(sb);
+failed_mount6:
+	ext4_ext_release(sb);
+failed_mount5:
+	ext4_mb_release(sb);
+	ext4_release_system_zone(sb);
 failed_mount4:
 	iput(root);
 	sb->s_root = NULL;
 	ext4_msg(sb, KERN_ERR, "mount failed");
 	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
 failed_mount_wq:
-	ext4_release_system_zone(sb);
 	if (sbi->s_journal) {
 		jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
-- 
1.7.1

