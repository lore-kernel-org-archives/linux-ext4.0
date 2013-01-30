From: Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] ext4: only define label failed_mount8 when used
Date: Tue, 29 Jan 2013 17:09:00 -0700
Message-ID: <1359504540-23474-1-git-send-email-swarren@wwwdotorg.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Warren <swarren@nvidia.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:35326 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3A3AJT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2013 19:09:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Stephen Warren <swarren@nvidia.com>

This fixes:

fs/ext4/super.c: In function 'ext4_fill_super':
fs/ext4/super.c:4040:1: warning: label 'failed_mount8' defined but not used

This label is only jumped to by code under ifdef CONFIG_QUOTA, so only
define the label in that case too.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 fs/ext4/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 861ffa0..3b04d15 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4037,8 +4037,10 @@ cantfind_ext4:
 		ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
 	goto failed_mount;
 
+#ifdef CONFIG_QUOTA
 failed_mount8:
 	kobject_del(&sbi->s_kobj);
+#endif
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
-- 
1.7.10.4

