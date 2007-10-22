From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 05/14] Add support for creating filesystems using uninit block group.
Date: Sun, 21 Oct 2007 21:03:36 -0500
Message-ID: <20071022020335.23849.59727.stgit@toolssf2>
References: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:44274 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbXJVCHB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:07:01 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9M2711j021801
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 22:07:01 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M271bU069460
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:01 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M271xj008345
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:01 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M270f4008339
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:07:01 -0600
In-Reply-To: <20071022020308.23849.98773.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Add support for creating filesystems using uninit block group.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-Off-By: Andreas Dilger <adilger@clusterfs.com>
--

 misc/mke2fs.c |   44 ++++++++++++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4a6cace..8360c51 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -432,6 +432,8 @@ static void write_inode_tables(ext2_filsys fs)
 					num, blk, error_message(retval));
 				exit(1);
 			}
+			/* The kernel doesn't need to zero the itable blocks */
+			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
 		}
 		if (sync_kludge) {
 			if (sync_kludge == 1)
@@ -447,34 +449,49 @@ static void write_inode_tables(ext2_filsys fs)
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
@@ -874,7 +891,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG,
-	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
+	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|	/* R/O compat */
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
 
 
@@ -1750,6 +1768,8 @@ int main (int argc, char *argv[])
 	}
 no_journal:
 
+	if (!super_only)
+		ext2fs_set_gdt_csum(fs);
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));
