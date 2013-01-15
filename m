From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] libext2fs: avoid 32-bit overflow in ext2fs_initialize with a 512M cluster size
Date: Mon, 14 Jan 2013 19:37:12 -0500
Message-ID: <1358210232-30578-5-git-send-email-tytso@mit.edu>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
Cc: gnehzuil.liu@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43380 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab3AOAhP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 19:37:15 -0500
In-Reply-To: <1358210232-30578-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the user attemps to create a 512MB cluster, we need to adjust the
defaults to avoid a 32-bit overflow of s_blocks_per_group.  Also check
to make sure that the caller of ext2fs_initialize() has not given a
value of s_clusters_per_group that would result in an overflow of
s_blocks_per_group.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/initialize.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index b0c15d2..5afdc27 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -207,6 +207,8 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 		super->s_log_block_size;
 
 	if (bigalloc_flag) {
+		unsigned long long bpg;
+
 		if (param->s_blocks_per_group &&
 		    param->s_clusters_per_group &&
 		    ((param->s_clusters_per_group * EXT2FS_CLUSTER_RATIO(fs)) !=
@@ -220,12 +222,19 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 			super->s_clusters_per_group = 
 				param->s_blocks_per_group /
 				EXT2FS_CLUSTER_RATIO(fs);
-		else
+		else if (super->s_log_cluster_size + 15 < 32)
 			super->s_clusters_per_group = fs->blocksize * 8;
+		else
+			super->s_clusters_per_group = (fs->blocksize - 1) * 8;
 		if (super->s_clusters_per_group > EXT2_MAX_CLUSTERS_PER_GROUP(super))
 			super->s_clusters_per_group = EXT2_MAX_CLUSTERS_PER_GROUP(super);
-		super->s_blocks_per_group = EXT2FS_C2B(fs,
-				       super->s_clusters_per_group);
+		bpg = EXT2FS_C2B(fs,
+			(unsigned long long) super->s_clusters_per_group);
+		if (bpg >= (((unsigned long long) 1) << 32)) {
+			retval = EXT2_ET_INVALID_ARGUMENT;
+			goto cleanup;
+		}
+		super->s_blocks_per_group = bpg;
 	} else {
 		set_field(s_blocks_per_group, fs->blocksize * 8);
 		if (super->s_blocks_per_group > EXT2_MAX_BLOCKS_PER_GROUP(super))
-- 
1.7.12.rc0.22.gcdd159b

