From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 3/4] e2fsck: factor out code to clear an inode into e2fsck_clear_inode()
Date: Sun, 16 Sep 2007 22:57:40 -0400
Message-ID: <11899978613124-git-send-email-tytso@mit.edu>
References: <1189997861181-git-send-email-tytso@mit.edu>
 <11899978613069-git-send-email-tytso@mit.edu>
 <11899978612166-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33742 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXIQC5s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Sep 2007 22:57:48 -0400
In-Reply-To: <11899978612166-git-send-email-tytso@mit.edu>
Message-Id: <a9a80d79bfa5e48273459a8a6a4d42d23aa791ad.1189997130.git.tytso@mit.edu>
In-Reply-To: <5db31092e4fe5c89eb093da1aff6fda8c100647d.1189997130.git.tytso@mit.edu>
References: <5db31092e4fe5c89eb093da1aff6fda8c100647d.1189997130.git.tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Factor out code to clear a bogus inode and update e2fsck's internal
data structures accordingly into a common routine,
e2fsck_clear_inode().  This saves about 200 bytes in the compiled x86
e2fsck executable, and makes the code more maintainable in the
long-term.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/e2fsck.h |    3 ++
 e2fsck/pass1.c  |   61 ++++++++++++++++++++++++++++--------------------------
 e2fsck/pass1b.c |    6 +----
 e2fsck/pass2.c  |    9 +-------
 e2fsck/pass4.c  |    7 +-----
 5 files changed, 38 insertions(+), 48 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 99c0ae5..d8e85ad 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -430,6 +430,9 @@ extern int e2fsck_pass1_check_device_inode(ext2_filsys fs,
 					   struct ext2_inode *inode);
 extern int e2fsck_pass1_check_symlink(ext2_filsys fs,
 				      struct ext2_inode *inode, char *buf);
+extern void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino, 
+			       struct ext2_inode *inode, int restart_flag,
+			       const char *source);
 
 /* pass2.c */
 extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ceb9c7f..7fba823 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -696,14 +696,9 @@ void e2fsck_pass1(e2fsck_t ctx)
 			 */
 			if (!LINUX_S_ISDIR(inode->i_mode)) {
 				if (fix_problem(ctx, PR_1_ROOT_NO_DIR, &pctx)) {
-					inode->i_dtime = ctx->now;
-					inode->i_links_count = 0;
-					ext2fs_icount_store(ctx->inode_link_info,
-							    ino, 0);
-					e2fsck_write_inode(ctx, ino, inode,
-							   "pass1");
+					e2fsck_clear_inode(ctx, ino, inode,
+							   0, "pass1");
 				}
-
 			}
 			/*
 			 * If dtime is set, offer to clear it.  mke2fs
@@ -1468,6 +1463,31 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 	return 0;
 }
 
+void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino, 
+			struct ext2_inode *inode, int restart_flag,
+			const char *source)
+{
+
+	inode->i_links_count = 0;
+	ext2fs_icount_store(ctx->inode_link_info, ino, 0);
+	inode->i_dtime = ctx->now;
+
+	ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, ino);
+	ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
+	if (ctx->inode_reg_map)
+		ext2fs_unmark_inode_bitmap(ctx->inode_reg_map, ino);
+	if (ctx->inode_bad_map)
+		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
+
+	/*
+	 * If the inode was partially accounted for before processing
+	 * was aborted, we need to restart the pass 1 scan.
+	 */
+	ctx->flags |= restart_flag;
+
+	e2fsck_write_inode(ctx, ino, inode, source);
+}
+
 /*
  * This subroutine is called on each inode to account for all of the
  * blocks used by that inode.
@@ -1530,20 +1550,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		ctx->fs_fragmented++;
 
 	if (pb.clear) {
-		inode->i_links_count = 0;
-		ext2fs_icount_store(ctx->inode_link_info, ino, 0);
-		inode->i_dtime = ctx->now;
-		dirty_inode++;
-		ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, ino);
-		ext2fs_unmark_inode_bitmap(ctx->inode_reg_map, ino);
-		ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
-		/*
-		 * The inode was probably partially accounted for
-		 * before processing was aborted, so we need to
-		 * restart the pass 1 scan.
-		 */
-		ctx->flags |= E2F_FLAG_RESTART;
-		goto out;
+		e2fsck_clear_inode(ctx, ino, inode, E2F_FLAG_RESTART, 
+				   "check_blocks");
+		return;
 	}
 	
 	if (inode->i_flags & EXT2_INDEX_FL) {
@@ -1563,15 +1572,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		
 	if (!pb.num_blocks && pb.is_dir) {
 		if (fix_problem(ctx, PR_1_ZERO_LENGTH_DIR, pctx)) {
-			inode->i_links_count = 0;
-			ext2fs_icount_store(ctx->inode_link_info, ino, 0);
-			inode->i_dtime = ctx->now;
-			dirty_inode++;
-			ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, ino);
-			ext2fs_unmark_inode_bitmap(ctx->inode_reg_map, ino);
-			ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
+			e2fsck_clear_inode(ctx, ino, inode, 0, "check_blocks");
 			ctx->fs_directory_count--;
-			goto out;
+			return;
 		}
 	}
 
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 118f956..5d062ca 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -594,16 +594,13 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 						     delete_file_block, &pb);
 	if (pctx.errcode)
 		fix_problem(ctx, PR_1B_BLOCK_ITERATE, &pctx);
-	ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
-	ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, ino);
 	if (ctx->inode_bad_map)
 		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
 
 	/* Inode may have changed by block_iterate, so reread it */
 	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
-	inode.i_links_count = 0;
-	inode.i_dtime = ctx->now;
+	e2fsck_clear_inode(ctx, ino, &inode, 0, "delete_file");
 	if (inode.i_file_acl &&
 	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
 		count = 1;
@@ -629,7 +626,6 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 			delete_file_block(fs, &inode.i_file_acl,
 					  BLOCK_COUNT_EXTATTR, 0, 0, &pb);
 	}
-	e2fsck_write_inode(ctx, ino, &inode, "delete_file");
 }
 
 struct clone_struct {
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7f7635f..8e651c7 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1109,11 +1109,8 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	struct problem_context	pctx;
 	__u32			count;
 	
-	ext2fs_icount_store(ctx->inode_link_info, ino, 0);
 	e2fsck_read_inode(ctx, ino, &inode, "deallocate_inode");
-	inode.i_links_count = 0;
-	inode.i_dtime = ctx->now;
-	e2fsck_write_inode(ctx, ino, &inode, "deallocate_inode");
+	e2fsck_clear_inode(ctx, ino, &inode, 0, "deallocate_inode");
 	clear_problem_context(&pctx);
 	pctx.ino = ino;
 
@@ -1121,10 +1118,6 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	 * Fix up the bitmaps...
 	 */
 	e2fsck_read_bitmaps(ctx);
-	ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
-	ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, ino);
-	if (ctx->inode_bad_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
 
 	if (inode.i_file_acl &&
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 0fb8ee7..3eca1c2 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -43,17 +43,12 @@ static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i)
 	if (!inode.i_blocks && (LINUX_S_ISREG(inode.i_mode) ||
 				LINUX_S_ISDIR(inode.i_mode))) {
 		if (fix_problem(ctx, PR_4_ZERO_LEN_INODE, &pctx)) {
-			ext2fs_icount_store(ctx->inode_link_info, i, 0);
-			inode.i_links_count = 0;
-			inode.i_dtime = ctx->now;
-			e2fsck_write_inode(ctx, i, &inode,
+			e2fsck_clear_inode(ctx, i, &inode, 0, 
 					   "disconnect_inode");
 			/*
 			 * Fix up the bitmaps...
 			 */
 			e2fsck_read_bitmaps(ctx);
-			ext2fs_unmark_inode_bitmap(ctx->inode_used_map, i);
-			ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, i);
 			ext2fs_inode_alloc_stats2(fs, i, -1,
 						  LINUX_S_ISDIR(inode.i_mode));
 			return 0;
-- 
1.5.3.1.19.gb5ef6
