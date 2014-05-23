From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] coverity fixes, part 3
Date: Fri, 23 May 2014 00:08:15 -0700
Message-ID: <20140523070815.GB17413@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27243 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaEWHIU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 May 2014 03:08:20 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various small resource leaks and error code handling issues that
Coverity pointed out.

Fixes-Coverity-Bugs: 1215250, 1193379, 119194[2-4], 1049160
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/xattrs.c    |    4 ++++
 e2fsck/pass1.c      |    8 ++++++--
 e2fsck/super.c      |    4 +++-
 lib/ext2fs/punch.c  |    8 ++++++--
 misc/create_inode.c |   11 ++++++-----
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
index 7109719..f2d7128 100644
--- a/debugfs/xattrs.c
+++ b/debugfs/xattrs.c
@@ -113,6 +113,8 @@ void do_get_xattr(int argc, char **argv)
 	while ((i = getopt(argc, argv, "f:")) != -1) {
 		switch (i) {
 		case 'f':
+			if (fp)
+				fclose(fp);
 			fp = fopen(optarg, "w");
 			if (fp == NULL) {
 				perror(optarg);
@@ -182,6 +184,8 @@ void do_set_xattr(int argc, char **argv)
 	while ((i = getopt(argc, argv, "f:")) != -1) {
 		switch (i) {
 		case 'f':
+			if (fp)
+				fclose(fp);
 			fp = fopen(optarg, "r");
 			if (fp == NULL) {
 				perror(optarg);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 180ecc8..e1012c0 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2013,8 +2013,12 @@ fix_problem_now:
 				pctx->blk2 = extent.e_lblk;
 				pctx->num = e_info.curr_level - 1;
 				problem = PR_1_EXTENT_INDEX_START_INVALID;
-				if (fix_problem(ctx, problem, pctx))
-					ext2fs_extent_fix_parents(ehandle);
+				if (fix_problem(ctx, problem, pctx)) {
+					pctx->errcode =
+						ext2fs_extent_fix_parents(ehandle);
+					if (pctx->errcode)
+						return;
+				}
 			}
 			scan_extent_node(ctx, pctx, pb, extent.e_lblk,
 					 last_lblk, eof_block, ehandle);
diff --git a/e2fsck/super.c b/e2fsck/super.c
index e9892e2..c8669f8 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -570,7 +570,9 @@ void check_super_block(e2fsck_t ctx)
 		return;
 	}
 
-	should_be = sb->s_inodes_per_group * fs->group_desc_count;
+	should_be = (blk64_t)sb->s_inodes_per_group * fs->group_desc_count;
+	if (should_be > UINT_MAX)
+		should_be = UINT_MAX;
 	if (sb->s_inodes_count != should_be) {
 		pctx.ino = sb->s_inodes_count;
 		pctx.ino2 = should_be;
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index a43beb4..3cce1f8 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -402,8 +402,12 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 				goto errout;
 			retval = 0;
 
-			/* Jump forward to the next extent. */
-			(void) ext2fs_extent_goto(handle, next_lblk);
+			/*
+			 * Jump forward to the next extent.  If there are
+			 * errors, the ext2fs_extent_get down below will
+			 * capture them for us.
+			 */
+			(void)ext2fs_extent_goto(handle, next_lblk);
 			op = EXT2_EXTENT_CURRENT;
 		}
 		if (retval)
diff --git a/misc/create_inode.c b/misc/create_inode.c
index 0b1e74e..74a2b95 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -117,9 +117,9 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 	case S_IFSOCK:
 		mode = LINUX_S_IFSOCK;
 		filetype = EXT2_FT_SOCK;
+		break;
 	default:
-		abort();
-		/* NOTREACHED */
+		return EXT2_ET_INVALID_ARGUMENT;
 	}
 
 	if (!(fs->flags & EXT2_FLAG_RW)) {
@@ -146,7 +146,7 @@ errcode_t do_mknod_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 	}
 	if (retval) {
 		com_err(name, retval, 0);
-		return -1;
+		return retval;
 	}
 	if (ext2fs_test_inode_bitmap2(fs->inode_map, ino))
 		com_err(__func__, 0, "Warning: inode already set");
@@ -354,7 +354,7 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 	int		bufsize = IO_BUFSIZE;
 	int		make_holes = 0;
 
-	fd = open(src, O_RDONLY);
+	fd = ext2fs_open_file(src, O_RDONLY, 0);
 	if (fd < 0) {
 		com_err(src, errno, 0);
 		return errno;
@@ -535,7 +535,8 @@ static errcode_t __populate_fs(ext2_filsys fs, ext2_ino_t parent_ino,
 				com_err(__func__, errno,
 					_("while trying to readlink \"%s\""),
 					name);
-				return errno;
+				retval = errno;
+				goto out;
 			}
 			ln_target[read_cnt] = '\0';
 			retval = do_symlink_internal(fs, parent_ino, name,
