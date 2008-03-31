From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] ext2fs_set_gdt_csum(): Return an error code on errors instead of void
Date: Mon, 31 Mar 2008 19:36:27 -0400
Message-ID: <1207006592-13980-6-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
 <1207006592-13980-1-git-send-email-tytso@mit.edu>
 <1207006592-13980-2-git-send-email-tytso@mit.edu>
 <1207006592-13980-3-git-send-email-tytso@mit.edu>
 <1207006592-13980-4-git-send-email-tytso@mit.edu>
 <1207006592-13980-5-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61480 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455AbYCaXjT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:39:19 -0400
In-Reply-To: <1207006592-13980-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <adilger@dilger.ca>

Change the function signature so that ext2fs_set_gdt_csum() returns an
error code.

If the inode bitmap hasn't been loaded return EXT2_ET_NO_INODE_BITMAP.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/unix.c       |   10 ++++++++--
 lib/ext2fs/csum.c   |    8 ++++++--
 lib/ext2fs/ext2fs.h |    2 +-
 misc/mke2fs.c       |   10 ++++++++--
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index deec442..93af87b 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1349,8 +1349,14 @@ no_journal:
 	}
 
 	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM &&
-	    !(ctx->options & E2F_OPT_READONLY))
-		ext2fs_set_gdt_csum(ctx->fs);
+	    !(ctx->options & E2F_OPT_READONLY)) {
+		retval = ext2fs_set_gdt_csum(ctx->fs);
+		if (retval) {
+			com_err(ctx->program_name, retval,
+				_("while setting block group checksum info"));
+			fatal_error(ctx, 0);
+		}
+	}
 
 	e2fsck_write_bitmaps(ctx);
 #ifdef RESOURCE_TRACK
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 70deaa9..0774e00 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -89,18 +89,21 @@ static __u32 find_last_inode_ingrp(ext2fs_inode_bitmap bitmap,
 
 /* update the bitmap flags, set the itable high watermark, and calculate
  * checksums for the group descriptors */
-void ext2fs_set_gdt_csum(ext2_filsys fs)
+errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 {
 	struct ext2_super_block *sb = fs->super;
 	struct ext2_group_desc *bg = fs->group_desc;
 	int blks, csum_flag, dirty = 0;
 	dgrp_t i;
 
+	if (!fs->inode_map)
+		return EXT2_ET_NO_INODE_BITMAP;
+
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
 				     EXT2_FEATURE_COMPAT_LAZY_BG) && !csum_flag)
-		return;
+		return 0;
 
 	for (i = 0; i < fs->group_desc_count; i++, bg++) {
 		int old_csum = bg->bg_checksum;
@@ -153,4 +156,5 @@ checksum:
 	}
 	if (dirty)
 		ext2fs_mark_super_dirty(fs);
+	return 0;
 }
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b6c1b8d..1a7cb86 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -710,7 +710,7 @@ extern void ext2fs_update_dynamic_rev(ext2_filsys fs);
 /* csum.c */
 extern void ext2fs_group_desc_csum_set(ext2_filsys fs, dgrp_t group);
 extern int ext2fs_group_desc_csum_verify(ext2_filsys fs, dgrp_t group);
-extern void ext2fs_set_gdt_csum(ext2_filsys fs);
+extern errcode_t ext2fs_set_gdt_csum(ext2_filsys fs);
 
 /* dblist.c */
 
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 857d345..fd48b83 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1792,8 +1792,14 @@ int main (int argc, char *argv[])
 	}
 no_journal:
 
-	if (!super_only)
-		ext2fs_set_gdt_csum(fs);
+	if (!super_only) {
+		retval = ext2fs_set_gdt_csum(fs);
+		if (retval) {
+			com_err(program_name, retval, 
+				_("\n\twhile setting block group checksum info"));
+			exit(1);
+		}
+	}
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));
-- 
1.5.4.1.144.gdfee-dirty

