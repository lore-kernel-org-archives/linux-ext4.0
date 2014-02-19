From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsprogs: make ext2fs_free() to set the pointer to NULL
Date: Wed, 19 Feb 2014 12:48:16 +0100
Message-ID: <1392810496-9090-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaBSLs2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Feb 2014 06:48:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently someone uses ext2fs_free() to free the ext2_filsys structure,
he is also responsible to set the pointer to that structure to NULL,
because ext2fs_free() is not able to do that.

This however is in contrast with ext2fs_free_mem() which requires as an
argument pointer to the pointer and it will in fact set the pointer to
NULL for us. This is probably the reason why majority of places where we
use ext2fs_free() does not set the pointer to NULL afterwards.

Fix this by changing function ext2fs_free() so that it'll require
pointer to the ext2_filsys as an argument and will be able to set the
pointer to NULL for us.

I do not currently have any way to trigger the issue in recent
e2fsprogs. Part of the reason is that there are some fixes which just
obfuscates the real problem (for example
7ff040f30f0ff3bf5e2c832da3cb577e00a52d60) and the other part might be
just coincidence.

I was however able to reproduce this with e2fsprogs 1.42.9 using the
image in bug https://bugzilla.redhat.com/show_bug.cgi?id=997982. With
this patch it fixes it. However I am not sure why it got fixed in the
recent e2fsprogs since git bisect lands into the merge commit - however
I think it's just a coincidence rather than targeted fix.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/journal.c        |  2 +-
 e2fsck/unix.c           | 12 ++++--------
 lib/ext2fs/closefs.c    |  2 +-
 lib/ext2fs/dupfs.c      |  2 +-
 lib/ext2fs/ext2fs.h     |  2 +-
 lib/ext2fs/freefs.c     | 10 ++++++++--
 lib/ext2fs/initialize.c |  2 +-
 lib/ext2fs/openfs.c     |  7 +++----
 misc/tune2fs.c          |  2 +-
 resize/online.c         |  2 +-
 resize/resize2fs.c      |  4 ++--
 11 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index a7b1150..ef964a0 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -965,7 +965,7 @@ errcode_t e2fsck_run_ext3_journal(e2fsck_t ctx)
 		kbytes_written = stats->bytes_written >> 10;
 
 	ext2fs_mmp_stop(ctx->fs);
-	ext2fs_free(ctx->fs);
+	ext2fs_free(&ctx->fs);
 	retval = ext2fs_open(ctx->filesystem_name, EXT2_FLAG_RW,
 			     ctx->superblock, blocksize, io_ptr,
 			     &ctx->fs);
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 429f1cd..b4d23de 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1051,10 +1051,8 @@ static errcode_t try_open_fs(e2fsck_t ctx, int flags, io_manager io_ptr,
 		int blocksize;
 		for (blocksize = EXT2_MIN_BLOCK_SIZE;
 		     blocksize <= EXT2_MAX_BLOCK_SIZE; blocksize *= 2) {
-			if (*ret_fs) {
-				ext2fs_free(*ret_fs);
-				*ret_fs = NULL;
-			}
+			if (*ret_fs)
+				ext2fs_free(ret_fs);
 			retval = ext2fs_open2(ctx->filesystem_name,
 					      ctx->io_options, flags,
 					      ctx->superblock, blocksize,
@@ -1292,10 +1290,8 @@ restart:
 			retval = retval2;
 			goto failure;
 		}
-		if (fs->flags & EXT2_FLAG_NOFREE_ON_ERROR) {
-			ext2fs_free(fs);
-			fs = NULL;
-		}
+		if (fs->flags & EXT2_FLAG_NOFREE_ON_ERROR)
+			ext2fs_free(&fs);
 		if (!fs || (fs->group_desc_count > 1)) {
 			log_out(ctx, _("%s: %s trying backup blocks...\n"),
 				ctx->program_name,
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index c2eaec1..b0e515d 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -490,7 +490,7 @@ errcode_t ext2fs_close2(ext2_filsys fs, int flags)
 	if (retval)
 		return retval;
 
-	ext2fs_free(fs);
+	ext2fs_free(&fs);
 	return 0;
 }
 
diff --git a/lib/ext2fs/dupfs.c b/lib/ext2fs/dupfs.c
index 02721e1..7568d89 100644
--- a/lib/ext2fs/dupfs.c
+++ b/lib/ext2fs/dupfs.c
@@ -115,7 +115,7 @@ errcode_t ext2fs_dup_handle(ext2_filsys src, ext2_filsys *dest)
 	*dest = fs;
 	return 0;
 errout:
-	ext2fs_free(fs);
+	ext2fs_free(&fs);
 	return retval;
 
 }
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7f7fd1f..a084888 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1213,7 +1213,7 @@ extern char *ext2fs_find_block_device(dev_t device);
 extern errcode_t ext2fs_sync_device(int fd, int flushb);
 
 /* freefs.c */
-extern void ext2fs_free(ext2_filsys fs);
+extern void ext2fs_free(ext2_filsys *fs);
 extern void ext2fs_free_dblist(ext2_dblist dblist);
 extern void ext2fs_badblocks_list_free(ext2_badblocks_list bb);
 extern void ext2fs_u32_list_free(ext2_u32_list bb);
diff --git a/lib/ext2fs/freefs.c b/lib/ext2fs/freefs.c
index 89a157b..be7c677 100644
--- a/lib/ext2fs/freefs.c
+++ b/lib/ext2fs/freefs.c
@@ -18,8 +18,14 @@
 #include "ext2_fs.h"
 #include "ext2fsP.h"
 
-void ext2fs_free(ext2_filsys fs)
+/*
+ * Free ext2_filsys.  The 'fs_ptr' arg must point to a ext2_filsys
+ * which is the pointer to struct_ext2_filsys.
+ */
+void ext2fs_free(ext2_filsys *fs_ptr)
 {
+	ext2_filsys fs = *fs_ptr;
+
 	if (!fs || (fs->magic != EXT2_ET_MAGIC_EXT2FS_FILSYS))
 		return;
 	if (fs->image_io != fs->io) {
@@ -61,7 +67,7 @@ void ext2fs_free(ext2_filsys fs)
 
 	fs->magic = 0;
 
-	ext2fs_free_mem(&fs);
+	ext2fs_free_mem(fs_ptr);
 }
 
 /*
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 75fbf8e..72ff090 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -530,6 +530,6 @@ ipg_retry:
 	return 0;
 cleanup:
 	free(buf);
-	ext2fs_free(fs);
+	ext2fs_free(&fs);
 	return retval;
 }
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index aba8a50..6a49083 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -476,10 +476,9 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 
 	return 0;
 cleanup:
-	if (flags & EXT2_FLAG_NOFREE_ON_ERROR)
-		*ret_fs = fs;
-	else
-		ext2fs_free(fs);
+	if (!(flags & EXT2_FLAG_NOFREE_ON_ERROR))
+		ext2fs_free(&fs);
+	*ret_fs = fs;
 	return retval;
 }
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 8ff47d2..5a3f6db 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2471,7 +2471,7 @@ retry_open:
 			fprintf(stderr, "%s",
 			     _("Couldn't find valid filesystem superblock.\n"));
 
-		ext2fs_free(fs);
+		ext2fs_free(&fs);
 		exit(1);
 	}
 	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
diff --git a/resize/online.c b/resize/online.c
index 46d86b0..afd5bb6 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -290,7 +290,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 		}
 	}
 
-	ext2fs_free(new_fs);
+	ext2fs_free(&new_fs);
 	close(fd);
 
 	return 0;
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 498cf99..6f19528 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -208,7 +208,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 
 	rfs->flags = flags;
 
-	ext2fs_free(rfs->old_fs);
+	ext2fs_free(&rfs->old_fs);
 	if (rfs->itable_buf)
 		ext2fs_free_mem(&rfs->itable_buf);
 	if (rfs->reserve_blocks)
@@ -221,7 +221,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 
 errout:
 	if (rfs->new_fs)
-		ext2fs_free(rfs->new_fs);
+		ext2fs_free(&rfs->new_fs);
 	if (rfs->itable_buf)
 		ext2fs_free_mem(&rfs->itable_buf);
 	ext2fs_free_mem(&rfs);
-- 
1.8.3.1

