From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/3] mke2fs: reduce the range of cluster-size
Date: Sun, 13 Jan 2013 17:08:14 +0800
Message-ID: <1358068095-9034-2-git-send-email-wenqing.lz@taobao.com>
References: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62181 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3AMIyw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2013 03:54:52 -0500
Received: by mail-pa0-f45.google.com with SMTP id bg2so1714404pad.4
        for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2013 00:54:51 -0800 (PST)
In-Reply-To: <1358068095-9034-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

There are two bugs need to be fixed, which are about cluster-size.  Now the
range of cluster-size is from 1024 to 512M bytes.  Although with '-C 1024',
the cluster-size will be 4096 after making a filesystem because in
ext2fs_initialize() set_field() needs to check 'param->s_log_cluster_size' and
s_log_cluster_size is 0 as cluster-size is 1024.  Then s_log_cluster_size will
be assigned to s_log_block_size+4.  So we never set cluster-size to 1024.

Another bug is that when cluster-size is 512M EXT2FS_C2B will return 0.  So
s_blocks_per_group will be assigned to zero and we will meet a 'division by
zero' error.

Here we reduce the range of cluster-size and check s_blocks_per_group=0 to avoid
'division by zero' error.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/initialize.c | 4 ++++
 misc/mke2fs.c           | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index dca0d9a..0eccd59 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -226,6 +226,10 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 			super->s_clusters_per_group = EXT2_MAX_CLUSTERS_PER_GROUP(super);
 		super->s_blocks_per_group = EXT2FS_C2B(fs,
 				       super->s_clusters_per_group);
+		if (super->s_blocks_per_group == 0) {
+			retval = EXT2_ET_TOOSMALL;
+			goto cleanup;
+		}
 	} else {
 		set_field(s_blocks_per_group, fs->blocksize * 8);
 		if (super->s_blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(super))
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index bf4d7a2..f4140a1 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1384,8 +1384,8 @@ profile_error:
 			break;
 		case 'C':
 			cluster_size = strtoul(optarg, &tmp, 0);
-			if (cluster_size < EXT2_MIN_CLUSTER_SIZE ||
-			    cluster_size > EXT2_MAX_CLUSTER_SIZE || *tmp) {
+			if (cluster_size <= EXT2_MIN_CLUSTER_SIZE ||
+			    cluster_size >= EXT2_MAX_CLUSTER_SIZE || *tmp) {
 				com_err(program_name, 0,
 					_("invalid cluster size - %s"),
 					optarg);
-- 
1.7.12.rc2.18.g61b472e

