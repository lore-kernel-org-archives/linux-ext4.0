From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/7] libext2fs: call numeric_progress functions through a operations struct
Date: Mon, 30 Jul 2012 17:47:40 -0400
Message-ID: <1343684862-13181-5-git-send-email-tytso@mit.edu>
References: <20120628024356.GB17989@thor.bakeyournoodle.com>
 <1343684862-13181-1-git-send-email-tytso@mit.edu>
Cc: tony@bakeyournoodle.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42140 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab2G3Vro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 17:47:44 -0400
In-Reply-To: <1343684862-13181-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of calling ext2fs_numeric_progress_*() directly from closefs.c
and alloc_tables.c, call it via a operations structure which is only
initialized by the one program (mke2fs) which needs it.

This reduces the number of C library symbols needed by boot loader
systems such as yaboot.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/alloc_tables.c | 11 +++++++----
 lib/ext2fs/closefs.c      | 11 +++++++----
 lib/ext2fs/ext2fs.h       |  3 +++
 lib/ext2fs/ext2fsP.h      | 17 +++++++++++++++++
 lib/ext2fs/progress.c     |  6 ++++++
 misc/mke2fs.c             |  1 +
 6 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 9f3d4e0..5e6e556 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -230,16 +230,19 @@ errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 	dgrp_t		i;
 	struct ext2fs_numeric_progress_struct progress;
 
-	ext2fs_numeric_progress_init(fs, &progress, NULL,
-				     fs->group_desc_count);
+	if (fs->progress_ops && fs->progress_ops->init)
+		(fs->progress_ops->init)(fs, &progress, NULL,
+					 fs->group_desc_count);
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		ext2fs_numeric_progress_update(fs, &progress, i);
+		if (fs->progress_ops && fs->progress_ops->update)
+			(fs->progress_ops->update)(fs, &progress, i);
 		retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
 		if (retval)
 			return retval;
 	}
-	ext2fs_numeric_progress_close(fs, &progress, NULL);
+	if (fs->progress_ops && fs->progress_ops->close)
+		(fs->progress_ops->close)(fs, &progress, NULL);
 	return 0;
 }
 
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 973c2a2..bb7f8b3 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -340,14 +340,16 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	else
 		old_desc_blocks = fs->desc_blocks;
 
-	ext2fs_numeric_progress_init(fs, &progress, NULL,
-				     fs->group_desc_count);
+	if (fs->progress_ops && fs->progress_ops->init)
+		(fs->progress_ops->init)(fs, &progress, NULL,
+					 fs->group_desc_count);
 
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		blk64_t	super_blk, old_desc_blk, new_desc_blk;
 
-		ext2fs_numeric_progress_update(fs, &progress, i);
+		if (fs->progress_ops && fs->progress_ops->update)
+			(fs->progress_ops->update)(fs, &progress, i);
 		ext2fs_super_and_bgd_loc2(fs, i, &super_blk, &old_desc_blk,
 					 &new_desc_blk, 0);
 
@@ -376,7 +378,8 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 		}
 	}
 
-	ext2fs_numeric_progress_close(fs, &progress, NULL);
+	if (fs->progress_ops && fs->progress_ops->close)
+		(fs->progress_ops->close)(fs, &progress, NULL);
 
 	/*
 	 * If the write_bitmaps() function is present, call it to
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 62282b1..5746b4f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -267,6 +267,9 @@ struct struct_ext2_filsys {
 	 * Time at which e2fsck last updated the MMP block.
 	 */
 	long mmp_last_written;
+
+	/* progress operation functions */
+	struct ext2fs_progress_ops *progress_ops;
 };
 
 #if EXT2_FLAT_INCLUDES
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 729d5c5..bdfb85e 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -95,6 +95,23 @@ struct ext2fs_numeric_progress_struct {
 	int		skip_progress;
 };
 
+/*
+ * progress callback functions
+ */
+struct ext2fs_progress_ops {
+	void (*init)(ext2_filsys fs,
+		     struct ext2fs_numeric_progress_struct * progress,
+		     const char *label, __u64 max);
+	void (*update)(ext2_filsys fs,
+		       struct ext2fs_numeric_progress_struct * progress,
+		       __u64 val);
+	void (*close)(ext2_filsys fs,
+		      struct ext2fs_numeric_progress_struct * progress,
+		      const char *message);
+};
+
+extern struct ext2fs_progress_ops ext2fs_numeric_progress_ops;
+
 extern void ext2fs_numeric_progress_init(ext2_filsys fs,
 					 struct ext2fs_numeric_progress_struct * progress,
 					 const char *label, __u64 max);
diff --git a/lib/ext2fs/progress.c b/lib/ext2fs/progress.c
index 37d1509..432816b 100644
--- a/lib/ext2fs/progress.c
+++ b/lib/ext2fs/progress.c
@@ -16,6 +16,12 @@
 
 static char spaces[80], backspaces[80];
 
+struct ext2fs_progress_ops ext2fs_numeric_progress_ops = {
+	.init		= ext2fs_numeric_progress_init,
+	.update		= ext2fs_numeric_progress_update,
+	.close		= ext2fs_numeric_progress_close,
+};
+
 static int int_log10(unsigned int arg)
 {
 	int	l;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7ec8cc2..01b2111 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2277,6 +2277,7 @@ int main (int argc, char *argv[])
 		com_err(device_name, retval, _("while setting up superblock"));
 		exit(1);
 	}
+	fs->progress_ops = &ext2fs_numeric_progress_ops;
 
 	/* Can't undo discard ... */
 	if (!noaction && discard && (io_ptr != undo_io_manager)) {
-- 
1.7.12.rc0.22.gcdd159b

