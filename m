From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, REWORKED 06/11] Make dumpe2fs uninit block group aware
Date: Mon, 17 Mar 2008 09:28:42 -0400
Message-ID: <1205760527-14858-7-git-send-email-tytso@mit.edu>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
 <1205760527-14858-2-git-send-email-tytso@mit.edu>
 <1205760527-14858-3-git-send-email-tytso@mit.edu>
 <1205760527-14858-4-git-send-email-tytso@mit.edu>
 <1205760527-14858-5-git-send-email-tytso@mit.edu>
 <1205760527-14858-6-git-send-email-tytso@mit.edu>
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60389 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753434AbYCQN3F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 09:29:05 -0400
In-Reply-To: <1205760527-14858-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/dumpe2fs.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index f6e7972..10ec5c0 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -112,7 +112,8 @@ static void print_bg_opts(ext2_filsys fs, dgrp_t i)
 {
 	int first = 1, bg_flags;
 
-	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_LAZY_BG)
+	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_LAZY_BG ||
+	    fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
 		bg_flags = fs->group_desc[i].bg_flags;
 	else
 		bg_flags = 0;
@@ -210,11 +211,15 @@ static void list_desc (ext2_filsys fs)
 		diff = fs->group_desc[i].bg_inode_table - first_block;
 		if (diff > 0)
 			printf(" (+%ld)", diff);
-		printf (_("\n  %d free blocks, %d free inodes, "
-			  "%d directories\n"),
+		printf (_("\n  %u free blocks, %u free inodes, "
+			  "%u directories%s"),
 			fs->group_desc[i].bg_free_blocks_count,
 			fs->group_desc[i].bg_free_inodes_count,
-			fs->group_desc[i].bg_used_dirs_count);
+			fs->group_desc[i].bg_used_dirs_count,
+			fs->group_desc[i].bg_itable_unused ? "" : "\n");
+		if (fs->group_desc[i].bg_itable_unused)
+			printf (_(", %u unused inodes\n"),
+				fs->group_desc[i].bg_itable_unused);
 		if (block_bitmap) {
 			fputs(_("  Free blocks: "), stdout);
 			ext2fs_get_block_bitmap_range(fs->block_map, 
-- 
1.5.4.1.144.gdfee-dirty

