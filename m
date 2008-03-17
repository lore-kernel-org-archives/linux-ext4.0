From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, REWORKED 05/11] Make tune2fs uninit block group aware
Date: Mon, 17 Mar 2008 09:28:41 -0400
Message-ID: <1205760527-14858-6-git-send-email-tytso@mit.edu>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
 <1205760527-14858-2-git-send-email-tytso@mit.edu>
 <1205760527-14858-3-git-send-email-tytso@mit.edu>
 <1205760527-14858-4-git-send-email-tytso@mit.edu>
 <1205760527-14858-5-git-send-email-tytso@mit.edu>
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60387 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753446AbYCQN3F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 09:29:05 -0400
In-Reply-To: <1205760527-14858-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/tune2fs.8.in |    7 +++++++
 misc/tune2fs.c    |    8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 8b59c17..b5af4d0 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -439,10 +439,17 @@ Reserve space so the block group descriptor table may grow in the
 future.
 .B Tune2fs 
 only supports clearing this filesystem feature.
+.TP
+.B uninit_groups
+Allow the kernel to initialize bitmaps and inode tables and keep a high
+watermark for the unused inodes in a filesystem, to reduce
+.BR e2fsck (8)
+time.
 .RE
 .IP
 After setting or clearing 
 .BR sparse_super ,
+.BR uninit_groups ,
 .BR filetype ,
 or
 .B resize_inode
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index dc44d56..8f5d564 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -118,6 +118,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER
 };
 
@@ -130,7 +131,8 @@ static __u32 clear_ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
-	EXT2_FEATURE_RO_COMPAT_LARGE_FILE
+	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
 
 /*
@@ -245,6 +247,7 @@ static int release_blocks_proc(ext2_filsys fs, blk_t *blocknr,
 	ext2fs_unmark_block_bitmap(fs->block_map,block);
 	group = ext2fs_group_of_blk(fs, block);
 	fs->group_desc[group].bg_free_blocks_count++;
+	ext2fs_group_desc_csum_set(fs, group);
 	fs->super->s_free_blocks_count++;
 	return 0;
 }
@@ -315,7 +318,6 @@ static void update_mntopts(ext2_filsys fs, char *mntopts)
 static void update_feature_set(ext2_filsys fs, char *features)
 {
 	struct ext2_super_block *sb= fs->super;
-	__u32	old_compat, old_incompat, old_ro_compat;
 	__u32		old_features[3];
 	int		type_err;
 	unsigned int	mask_err;
@@ -410,6 +412,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 
 	if (FEATURE_CHANGED(E2P_FEATURE_RO_INCOMPAT,
 			    EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER) ||
+	    FEATURE_CHANGED(E2P_FEATURE_RO_INCOMPAT,
+			    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
 	    FEATURE_CHANGED(E2P_FEATURE_INCOMPAT,
 			    EXT2_FEATURE_INCOMPAT_FILETYPE) ||
 	    FEATURE_CHANGED(E2P_FEATURE_COMPAT,
-- 
1.5.4.1.144.gdfee-dirty

