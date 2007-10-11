From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 04/13][e2fsprogs] Add support for creating filesystems using uninit block group.
Date: Thu, 11 Oct 2007 14:16:23 -0500
Message-ID: <20071011191623.4599.6644.stgit@gara>
References: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39237 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263AbXJKTQb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 15:16:31 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJGUCq024263
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:30 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJGUhq075164
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:30 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJGK3G019366
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:20 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJGKf4018788
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:20 -0400
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJG93w040724
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:16:09 -0500
In-Reply-To: <20071011191559.4599.69332.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Add support for creating filesystems using uninit block group.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
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
