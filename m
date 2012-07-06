From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] e2fsck: rename "bool" variables
Date: Thu,  5 Jul 2012 19:44:20 -0600
Message-ID: <1341539060-97676-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>,
	Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32259 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2GFBoW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2012 21:44:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since "bool" is a valid C type, declarations of the form "int bool"
will cause compiler errors if <stdbool.h> is included.  Rename these
variables to avoid this name clash.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/e2fsck.h  | 2 +-
 e2fsck/pass1.c   | 4 ++--
 e2fsck/problem.c | 8 ++++----
 misc/e2image.c   | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 971390e..420b67f 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -466,7 +466,7 @@ extern void e2fsck_hide_quota(e2fsck_t ctx);
 /* pass1.c */
 extern void e2fsck_setup_tdb_icount(e2fsck_t ctx, int flags,
 				    ext2_icount_t *ret);
-extern void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int bool);
+extern void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int use_shortcuts);
 extern int e2fsck_pass1_check_device_inode(ext2_filsys fs,
 					   struct ext2_inode *inode);
 extern int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 72dcd97..78fbe8d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2822,11 +2822,11 @@ static void e2fsck_block_alloc_stats(ext2_filsys fs, blk64_t blk, int inuse)
 	}
 }
 
-void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int bool)
+void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int use_shortcuts)
 {
 	ext2_filsys fs = ctx->fs;
 
-	if (bool) {
+	if (use_shortcuts) {
 		fs->get_blocks = pass1_get_blocks;
 		fs->check_directory = pass1_check_directory;
 		fs->read_inode = pass1_read_inode;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0948bdb..06640cb 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1789,11 +1789,11 @@ void clear_problem_context(struct problem_context *ctx)
 static void reconfigure_bool(e2fsck_t ctx, struct e2fsck_problem *ptr,
 			     const char *key, int mask, const char *name)
 {
-	int	bool;
+	int	val;
 
-	bool = (ptr->flags & mask);
-	profile_get_boolean(ctx->profile, "problems", key, name, bool, &bool);
-	if (bool)
+	val = (ptr->flags & mask);
+	profile_get_boolean(ctx->profile, "problems", key, name, val, &val);
+	if (val)
 		ptr->flags |= mask;
 	else
 		ptr->flags &= ~mask;
diff --git a/misc/e2image.c b/misc/e2image.c
index 3a956ef..e6ea52a 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -270,9 +270,9 @@ static errcode_t meta_read_inode(ext2_filsys fs EXT2FS_ATTR((unused)),
 	return 0;
 }
 
-static void use_inode_shortcuts(ext2_filsys fs, int bool)
+static void use_inode_shortcuts(ext2_filsys fs, int use_shortcuts)
 {
-	if (bool) {
+	if (use_shortcuts) {
 		fs->get_blocks = meta_get_blocks;
 		fs->check_directory = meta_check_directory;
 		fs->read_inode = meta_read_inode;
-- 
1.7.11.1

