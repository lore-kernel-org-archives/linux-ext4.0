From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/14] misc: fix Coverity bugs
Date: Wed, 13 May 2015 17:21:15 -0700
Message-ID: <20150514002114.10785.41768.stgit@birch.djwong.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31852 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbbENAVT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2015 20:21:19 -0400
In-Reply-To: <20150514002108.10785.85860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix Coverity bugs 1297093,1297096, 1297489, 1297491, 1297493, 1297506,
1297507, 1297514, 1297516, and 1297517.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/util.c     |    2 +-
 e2fsck/extents.c   |   12 +++++++++---
 e2fsck/readahead.c |    2 +-
 e2fsck/unix.c      |    4 ++++
 lib/e2p/feature.c  |    4 ++--
 lib/e2p/mntopts.c  |    2 +-
 misc/e4defrag.c    |    4 +++-
 misc/logsave.c     |    2 +-
 8 files changed, 22 insertions(+), 10 deletions(-)


diff --git a/debugfs/util.c b/debugfs/util.c
index af14539..4fef89a 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -390,7 +390,7 @@ int common_block_args_process(int argc, char *argv[],
 		return 1;
 	if (*block == 0) {
 		com_err(argv[0], 0, "Invalid block number 0");
-		err = 1;
+		return 1;
 	}
 
 	if (argc > 2) {
diff --git a/e2fsck/extents.c b/e2fsck/extents.c
index a08fa94..407dafb 100644
--- a/e2fsck/extents.c
+++ b/e2fsck/extents.c
@@ -27,6 +27,8 @@ static errcode_t e2fsck_rebuild_extents(e2fsck_t ctx, ext2_ino_t ino);
 /* Schedule an inode to have its extent tree rebuilt during pass 1E. */
 errcode_t e2fsck_rebuild_extents_later(e2fsck_t ctx, ext2_ino_t ino)
 {
+	errcode_t retval = 0;
+
 	if (!EXT2_HAS_INCOMPAT_FEATURE(ctx->fs->super,
 				       EXT3_FEATURE_INCOMPAT_EXTENTS) ||
 	    (ctx->options & E2F_OPT_NO) ||
@@ -37,13 +39,15 @@ errcode_t e2fsck_rebuild_extents_later(e2fsck_t ctx, ext2_ino_t ino)
 		return e2fsck_rebuild_extents(ctx, ino);
 
 	if (!ctx->inodes_to_rebuild)
-		e2fsck_allocate_inode_bitmap(ctx->fs,
+		retval = e2fsck_allocate_inode_bitmap(ctx->fs,
 					     _("extent rebuild inode map"),
 					     EXT2FS_BMAP64_RBTREE,
 					     "inodes_to_rebuild",
 					     &ctx->inodes_to_rebuild);
-	if (ctx->inodes_to_rebuild)
-		ext2fs_mark_inode_bitmap2(ctx->inodes_to_rebuild, ino);
+	if (retval)
+		return retval;
+
+	ext2fs_mark_inode_bitmap2(ctx->inodes_to_rebuild, ino);
 	return 0;
 }
 
@@ -225,6 +229,8 @@ static errcode_t rebuild_extent_tree(e2fsck_t ctx, struct extent_list *list,
 	/* Collect lblk->pblk mappings */
 	if (inode.i_flags & EXT4_EXTENTS_FL) {
 		retval = load_extents(ctx, list);
+		if (retval)
+			goto err;
 		goto extents_loaded;
 	}
 
diff --git a/e2fsck/readahead.c b/e2fsck/readahead.c
index 4429a37..a860f2b 100644
--- a/e2fsck/readahead.c
+++ b/e2fsck/readahead.c
@@ -242,7 +242,7 @@ unsigned long long e2fsck_guess_readahead(ext2_filsys fs)
 	 * worth of inode table blocks seems to yield the largest reductions
 	 * in e2fsck runtime.
 	 */
-	guess = 2 * fs->blocksize * fs->inode_blocks_per_group;
+	guess = 2ULL * fs->blocksize * fs->inode_blocks_per_group;
 
 	/* Disable RA if it'd use more 1/50th of RAM. */
 	if (get_memory_size() > (guess * 50))
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 4bad553..940ecb4 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -682,6 +682,10 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 			}
 			ctx->ext_attr_ver = ea_ver;
 		} else if (strcmp(token, "readahead_kb") == 0) {
+			if (!arg) {
+				extended_usage++;
+				continue;
+			}
 			reada_kb = strtoull(arg, &p, 0);
 			if (*p) {
 				fprintf(stderr, "%s",
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 73884f2..d1d4762 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -187,7 +187,7 @@ int e2p_string2feature(char *string, int *compat_type, unsigned int *mask)
 	if (string[9] == 0)
 		return 1;
 	num = strtol(string+9, &eptr, 10);
-	if (num > 32 || num < 0)
+	if (num > 31 || num < 0)
 		return 1;
 	if (*eptr)
 		return 1;
@@ -261,7 +261,7 @@ int e2p_jrnl_string2feature(char *string, int *compat_type, unsigned int *mask)
 	if (string[9] == 0)
 		return 1;
 	num = strtol(string+9, &eptr, 10);
-	if (num > 32 || num < 0)
+	if (num > 31 || num < 0)
 		return 1;
 	if (*eptr)
 		return 1;
diff --git a/lib/e2p/mntopts.c b/lib/e2p/mntopts.c
index d56cc52..ff2e5de 100644
--- a/lib/e2p/mntopts.c
+++ b/lib/e2p/mntopts.c
@@ -72,7 +72,7 @@ int e2p_string2mntopt(char *string, unsigned int *mask)
 	if (string[8] == 0)
 		return 1;
 	num = strtol(string+8, &eptr, 10);
-	if (num > 32 || num < 0)
+	if (num > 31 || num < 0)
 		return 1;
 	if (*eptr)
 		return 1;
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index d0eac60..3f949d0 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -387,8 +387,10 @@ static int page_in_core(int fd, struct move_extent defrag_data,
 	*page_num = 0;
 	*page_num = (length + pagesize - 1) / pagesize;
 	*vec = (unsigned char *)calloc(*page_num, 1);
-	if (*vec == NULL)
+	if (*vec == NULL) {
+		munmap(page, length);
 		return -1;
+	}
 
 	/* Get information on whether pages are in core */
 	if (mincore(page, (size_t)length, *vec) == -1 ||
diff --git a/misc/logsave.c b/misc/logsave.c
index f6cc42a..6a624de 100644
--- a/misc/logsave.c
+++ b/misc/logsave.c
@@ -219,7 +219,7 @@ static int run_program(char **argv)
 			sprintf(buffer, "died with signal %d\n",
 				WTERMSIG(status));
 			send_output(buffer, 0, SEND_BOTH);
-			rc = 1;
+			return 1;
 		}
 		rc = 0;
 	}

