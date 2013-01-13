From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/3] mke2fs: indicate bigalloc feature explicity when cluster-size is enabled
Date: Sun, 13 Jan 2013 17:08:13 +0800
Message-ID: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:33625 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3AMIyr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2013 03:54:47 -0500
Received: by mail-pb0-f41.google.com with SMTP id xa7so1651577pbc.14
        for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2013 00:54:46 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When cluster-size is enabled without bigalloc feature, mke2fs will ignore this
argument silently.  But user might think bigalloc feature has been enabled
unless they use 'stats' command to check it in debugfs.  So now we ask user
to set bigalloc feature explicity when cluster-size is enabled.  This can
make sure that users understand what they are doing because bigalloc might
impact the performance for some workloads.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a288147..bf4d7a2 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1915,8 +1915,14 @@ profile_error:
 							    blocksize*16);
 		fs_param.s_log_cluster_size =
 			int_log2(cluster_size >> EXT2_MIN_CLUSTER_LOG_SIZE);
-	} else
+	} else if (cluster_size) {
+		com_err(program_name, EINVAL,
+			_("while setting clustersize; You need to enable "
+			  "bigalloc feature explicity"));
+		exit(1);
+	} else {
 		fs_param.s_log_cluster_size = fs_param.s_log_block_size;
+	}
 
 	if (inode_ratio == 0) {
 		inode_ratio = get_int_from_profile(fs_types, "inode_ratio",
-- 
1.7.12.rc2.18.g61b472e

