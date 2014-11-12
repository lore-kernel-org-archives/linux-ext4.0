From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v2 2/3] e2fsprogs/tune2fs: rewrite metadata checksums when resizing inode size
Date: Wed, 12 Nov 2014 17:49:39 +0800
Message-ID: <1415785780-3832-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
References: <1415785780-3832-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <darrick.wong@oracle.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42315 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752511AbaKLJwn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2014 04:52:43 -0500
In-Reply-To: <1415785780-3832-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we use tune2fs -I new_ino_size to change inode size, if everything is OK,
the corresponding ext4_group_desc.bg_free_blocks_count will be decreased, so
obviously, we need to re-compute the group descriptor checksums, fix this. If
not doing this, mount operation will fail.

Meanwhile, the patch will trigger an existing memory write overflow, which will
casue segfault, please see the next patch.

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 misc/tune2fs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 065b483..91dc7c1 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2908,8 +2908,7 @@ retry_open:
 				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 			rewrite_checksums = 1;
 	}
-	if (rewrite_checksums)
-		rewrite_metadata_checksums(fs);
+
 	if (I_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "
@@ -2935,6 +2934,7 @@ retry_open:
 		if (resize_inode(fs, new_inode_size) == 0) {
 			printf(_("Setting inode size %lu\n"),
 							new_inode_size);
+			rewrite_checksums = 1;
 		} else {
 			printf("%s", _("Failed to change inode size\n"));
 			rc = 1;
@@ -2942,6 +2942,9 @@ retry_open:
 		}
 	}
 
+	if (rewrite_checksums)
+		rewrite_metadata_checksums(fs);
+
 	if (l_flag)
 		list_super(sb);
 	if (stride_set) {
-- 
1.8.2.1

