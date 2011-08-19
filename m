From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Free resources in the error path of ext4_mb_init.
Date: Fri, 19 Aug 2011 23:28:08 +0800
Message-ID: <1313767689-2786-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:45781 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751832Ab1HSPaR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Aug 2011 11:30:17 -0400
Received: from [221.217.45.152] (helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1QuR1T-0004kH-Rp
	for linux-ext4@vger.kernel.org; Fri, 19 Aug 2011 09:30:16 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In commit 79a77c5ac, we move ext4_mb_init_backend after the allocation
of s_locality_group to avoid memory leak in error path, but there are
still some other error paths in ext4_mb_init that need to do the same
work. So this patch adds all the error patch for ext4_mb_init. And all
the pointers are reset to NULL in case the caller may double free them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..e7d64d8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2490,7 +2490,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
 	if (sbi->s_locality_groups == NULL) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_free_groupinfo_slab;
 	}
 	for_each_possible_cpu(i) {
 		struct ext4_locality_group *lg;
@@ -2503,9 +2503,8 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 
 	/* init file for buddy data */
 	ret = ext4_mb_init_backend(sb);
-	if (ret != 0) {
-		goto out;
-	}
+	if (ret != 0)
+		goto out_free_locality_groups;
 
 	if (sbi->s_proc)
 		proc_create_data("mb_groups", S_IRUGO, sbi->s_proc,
@@ -2513,11 +2512,19 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 
 	if (sbi->s_journal)
 		sbi->s_journal->j_commit_callback = release_blocks_on_commit;
+
+	return 0;
+
+out_free_groupinfo_slab:
+	ext4_groupinfo_destroy_slabs();
+out_free_locality_groups:
+	free_percpu(sbi->s_locality_groups);
+	sbi->s_locality_groups = NULL;
 out:
-	if (ret) {
-		kfree(sbi->s_mb_offsets);
-		kfree(sbi->s_mb_maxs);
-	}
+	kfree(sbi->s_mb_offsets);
+	sbi->s_mb_offsets = NULL;
+	kfree(sbi->s_mb_maxs);
+	sbi->s_mb_maxs = NULL;
 	return ret;
 }
 
-- 
1.7.1

