From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/74] e2fsck: fix memory leaks
Date: Tue, 10 Dec 2013 17:20:20 -0800
Message-ID: <20131211012020.30655.57874.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42545 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3LKBU1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:20:27 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/journal.c |    4 +++-
 e2fsck/pass3.c   |    5 +++--
 e2fsck/profile.c |    2 ++
 e2fsck/unix.c    |    2 ++
 4 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index e3f80bc..22f06e7 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -1139,8 +1139,10 @@ int e2fsck_fix_ext3_journal_hint(e2fsck_t ctx)
 	if (!journal_name)
 		return 0;
 
-	if (stat(journal_name, &st) < 0)
+	if (stat(journal_name, &st) < 0) {
+		free(journal_name);
 		return 0;
+	}
 
 	if (st.st_rdev != sb->s_journal_dev) {
 		clear_problem_context(&pctx);
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index fbaadcf..6989f17 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -53,7 +53,7 @@ static ext2fs_inode_bitmap inode_done_map = 0;
 void e2fsck_pass3(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
-	struct dir_info_iter *iter;
+	struct dir_info_iter *iter = NULL;
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 #endif
@@ -108,7 +108,6 @@ void e2fsck_pass3(e2fsck_t ctx)
 			if (check_directory(ctx, dir->ino, &pctx))
 				goto abort_exit;
 	}
-	e2fsck_dir_info_iter_end(ctx, iter);
 
 	/*
 	 * Force the creation of /lost+found if not present
@@ -123,6 +122,8 @@ void e2fsck_pass3(e2fsck_t ctx)
 	e2fsck_rehash_directories(ctx);
 
 abort_exit:
+	if (iter)
+		e2fsck_dir_info_iter_end(ctx, iter);
 	e2fsck_free_dir_info(ctx);
 	if (inode_loop_detect) {
 		ext2fs_free_inode_bitmap(inode_loop_detect);
diff --git a/e2fsck/profile.c b/e2fsck/profile.c
index 019c6f5..92aa893 100644
--- a/e2fsck/profile.c
+++ b/e2fsck/profile.c
@@ -318,6 +318,8 @@ profile_init(const char **files, profile_t *ret_profile)
         /* if the filenames list is not specified return an empty profile */
         if ( files ) {
 	    for (fs = files; !PROFILE_LAST_FILESPEC(*fs); fs++) {
+		if (array)
+			free_list(array);
 		retval = get_dirlist(*fs, &array);
 		if (retval == 0) {
 			if (!array)
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index a6c8d25..7a8fce2 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -869,6 +869,8 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 		case 'L':
 			replace_bad_blocks++;
 		case 'l':
+			if (bad_blocks_file)
+				free(bad_blocks_file);
 			bad_blocks_file = string_copy(ctx, optarg, 0);
 			break;
 		case 'd':

