From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] e2fsck: recreate extent mapped lost+found
Date: Thu, 16 Mar 2017 11:39:48 -0400
Message-ID: <20170316153948.GA20690@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36181 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752305AbdCPPjA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Mar 2017 11:39:00 -0400
Received: by mail-qk0-f194.google.com with SMTP id n141so6446107qke.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Mar 2017 08:38:59 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When e2fsck recreates a missing lost+found directory, it uses indirect
block mapping.  It does this even if the file system being repaired is
extent mapped and where the original lost+found was extent mapped when
created by mkfs.

This inconsistency exists because the kernel code handling indirect
block mapping was considered more trustworthy in ext4's early days;
today, the extent handling code is robust.

This inconsistency also causes potential behavioral problems on
bigalloc file systems.  The ext4 kernel code does not support indirect
block mapped directories when bigalloc is enabled.  For example, it is
not possible to extend lost+found on a mounted bigalloc file system
with the current implementation, so the behavior of that directory
differs from all others, potentially surprising users.

To make the handling of lost+found more consistent, and to avoid
behavioral problems on bigalloc file systems, recreate lost+found
with extent mapping if the file system under repair is extent mapped.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 e2fsck/pass3.c   | 29 +++++++++++++++++++++++++++--
 e2fsck/problem.c | 10 ++++++++++
 e2fsck/problem.h |  6 ++++++
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 44203ca..259c978 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -378,7 +378,7 @@ static int check_directory(e2fsck_t ctx, ext2_ino_t dir,
 ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 {
 	ext2_filsys fs = ctx->fs;
-	ext2_ino_t			ino;
+	ext2_ino_t		ino;
 	blk64_t			blk;
 	errcode_t		retval;
 	struct ext2_inode_large	inode;
@@ -386,6 +386,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 	static const char	name[] = "lost+found";
 	struct 	problem_context	pctx;
 	int			will_rehash, flags;
+	ext2_extent_handle_t	handle;
 
 	if (ctx->lost_and_found)
 		return ctx->lost_and_found;
@@ -520,7 +521,10 @@ skip_new_block:
 	inode.i_atime = inode.i_ctime = inode.i_mtime = ctx->now;
 	inode.i_links_count = 2;
 	ext2fs_iblk_set(fs, EXT2_INODE(&inode), 1);
-	inode.i_block[0] = blk;
+	if (ext2fs_has_feature_extents(fs->super))
+		inode.i_flags |= EXT4_EXTENTS_FL;
+	else
+		inode.i_block[0] = blk;
 
 	/*
 	 * Next, write out the inode.
@@ -553,6 +557,27 @@ skip_new_block:
 	}
 
 	/*
+	 * If the new lost+found is extent mapped, map its first new
+	 * directory block
+	 */
+	if (ext2fs_has_feature_extents(fs->super)) {
+		retval = ext2fs_extent_open2(fs, ino, EXT2_INODE(&inode),
+					     &handle);
+		if (retval) {
+			pctx.errcode = retval;
+			fix_problem(ctx, PR_3_ERR_LPF_OPEN_EXTENT, &pctx);
+			return 0;
+		}
+		retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
+		ext2fs_extent_free(handle);
+		if (retval) {
+			pctx.errcode = retval;
+			fix_problem(ctx, PR_3_ERR_LPF_SET_BMAP, &pctx);
+			return 0;
+		}
+	}
+
+	/*
 	 * Finally, create the directory link
 	 */
 	pctx.errcode = ext2fs_link(fs, EXT2_ROOT_INO, name, ino, EXT2_FT_DIR);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index c3e4f6a..736b822 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1791,6 +1791,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("/@l is encrypted\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Error while creating an extent for /lost+found */
+	{ PR_3_ERR_LPF_OPEN_EXTENT,
+	  N_("ext2fs_@x_open2: %m while creating an @x for /@l\n"),
+	  PROMPT_NONE, 0 },
+
+	/* Error while mapping a directory block for /lost+found */
+	{ PR_3_ERR_LPF_SET_BMAP,
+	  N_("ext2fs_@x_set_bmap: %m while mapping a @d @b for /@l\n"),
+	  PROMPT_NONE, 0 },
+
 	/* Pass 3A Directory Optimization	*/
 
 	/* Pass 3A: Optimizing directories */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index d291e26..dfdb6d0 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1078,6 +1078,12 @@ struct problem_context {
 /* Lost+found is encrypted */
 #define PR_3_LPF_ENCRYPTED		0x03001B
 
+/* Error while creating an extent for /lost+found */
+#define PR_3_ERR_LPF_OPEN_EXTENT	0x03001C
+
+/* Error while mapping a directory block for /lost+found */
+#define PR_3_ERR_LPF_SET_BMAP		0x03001D
+
 /*
  * Pass 3a --- rehashing diretories
  */
-- 
2.1.4
