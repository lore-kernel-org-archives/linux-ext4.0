From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, REWORKED 04/11] Add support for creating filesystems using uninit block group
Date: Mon, 17 Mar 2008 09:28:40 -0400
Message-ID: <1205760527-14858-5-git-send-email-tytso@mit.edu>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
 <1205760527-14858-2-git-send-email-tytso@mit.edu>
 <1205760527-14858-3-git-send-email-tytso@mit.edu>
 <1205760527-14858-4-git-send-email-tytso@mit.edu>
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60380 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752907AbYCQN3F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 09:29:05 -0400
In-Reply-To: <1205760527-14858-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.8.in |    7 +++++++
 misc/mke2fs.c    |   44 ++++++++++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 14c3ca5..a32c34a 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -427,6 +427,13 @@ Store file type information in directory entries.
 .TP
 .B has_journal
 Create an ext3 journal (as if using the
+.TP
+.B uninit_groups
+Create a filesystem without initializing all of the groups.  This speeds
+up filesystem creation time noticably, and can also reduce
+.BR e2fsck time
+dramatically.  This feature causes the filesystem to be read-only in
+older kernels is not supported in most Linux kernels, use with caution.
 .B \-j
 option).
 @JDEV@.TP
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 072a3a8..acff08b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -433,6 +433,8 @@ static void write_inode_tables(ext2_filsys fs)
 					num, blk, error_message(retval));
 				exit(1);
 			}
+			/* The kernel doesn't need to zero the itable blocks */
+			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
 		}
 		if (sync_kludge) {
 			if (sync_kludge == 1)
@@ -448,34 +450,49 @@ static void write_inode_tables(ext2_filsys fs)
 static void setup_lazy_bg(ext2_filsys fs)
 {
 	dgrp_t i;
-	int blks;
+	int blks, csum_flag;
 	struct ext2_super_block *sb = fs->super;
 	struct ext2_group_desc *bg = fs->group_desc;
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
-				    EXT2_FEATURE_COMPAT_LAZY_BG)) {
+	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super, EXT2_FEATURE_COMPAT_LAZY_BG) ||
+	    csum_flag) {
 		for (i = 0; i < fs->group_desc_count; i++, bg++) {
 			if ((i == 0) ||
-			    (i == fs->group_desc_count-1))
+			    (i == fs->group_desc_count - 1 && !csum_flag))
 				continue;
 			if (bg->bg_free_inodes_count ==
 			    sb->s_inodes_per_group) {
-				bg->bg_free_inodes_count = 0;
 				bg->bg_flags |= EXT2_BG_INODE_UNINIT;
-				sb->s_free_inodes_count -= 
-					sb->s_inodes_per_group;
+				if (!csum_flag) {
+					bg->bg_free_inodes_count = 0;
+					sb->s_free_inodes_count -=
+						sb->s_inodes_per_group;
+				}
 			}
+
+			/* Skip groups with GDT backups because the resize
+			 * inode has blocks allocated in them, and the last
+			 * group because it needs block bitmap padding. */
+			if ((ext2fs_bg_has_super(fs, i) &&
+			     sb->s_reserved_gdt_blocks) ||
+			    i == fs->group_desc_count - 1)
+				continue;
+
 			blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
-			if (bg->bg_free_blocks_count == blks) {
-				bg->bg_free_blocks_count = 0;
+			if (bg->bg_free_blocks_count == blks &&
+			    bg->bg_flags & EXT2_BG_INODE_UNINIT) {
 				bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
-				sb->s_free_blocks_count -= blks;
+				if (!csum_flag) {
+					bg->bg_free_blocks_count = 0;
+					sb->s_free_blocks_count -= blks;
+				}
 			}
 		}
 	}
 }
 
-
 static void create_root_dir(ext2_filsys fs)
 {
 	errcode_t		retval;
@@ -912,7 +929,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
-		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER
+		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
 
 
@@ -1774,6 +1792,8 @@ int main (int argc, char *argv[])
 	}
 no_journal:
 
+	if (!super_only)
+		ext2fs_set_gdt_csum(fs);
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));
-- 
1.5.4.1.144.gdfee-dirty

