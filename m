From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] misc: use EXT2_I_SIZE() consistently to get size
Date: Mon, 27 Jun 2011 23:26:03 -0600
Message-ID: <1309238763-22562-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15903 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab1F1F0H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 01:26:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the EXT2_I_SIZE() macro consistently to access the inode size.
The i_size/i_size_high combination is open coded in several places.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 debugfs/debugfs.c   |   13 ++++---------
 debugfs/ls.c        |    5 ++---
 debugfs/lsdel.c     |    5 +----
 e2fsck/message.c    |    3 +--
 e2fsck/pass1.c      |    5 ++---
 e2fsck/pass2.c      |    3 +--
 e2fsck/super.c      |    3 +--
 lib/ext2fs/extent.c |    5 ++---
 lib/ext2fs/fileio.c |    3 +--
 9 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 55d16af..12ee638 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -722,12 +722,9 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	}
 	fprintf(out, "%sUser: %5d   Group: %5d   Size: ",
 		prefix, inode_uid(*inode), inode_gid(*inode));
-	if (LINUX_S_ISREG(inode->i_mode)) {
-		unsigned long long i_size = (inode->i_size |
-				    ((unsigned long long)inode->i_size_high << 32));
-
-		fprintf(out, "%llu\n", i_size);
-	} else
+	if (LINUX_S_ISREG(inode->i_mode))
+		fprintf(out, "%llu\n", EXT2_I_SIZE(inode));
+	else
 		fprintf(out, "%d\n", inode->i_size);
 	if (os == EXT2_OS_HURD)
 		fprintf(out,
@@ -901,9 +898,7 @@ void do_dump_extents(int argc, char **argv)
 		return;
 	}
 
-	logical_width = int_log10(((inode.i_size |
-				    (__u64) inode.i_size_high << 32) +
-				   current_fs->blocksize - 1) /
+	logical_width = int_log10((EXT2_I_SIZE(&inode)+current_fs->blocksize-1)/
 				  current_fs->blocksize) + 1;
 	if (logical_width < 5)
 		logical_width = 5;
diff --git a/debugfs/ls.c b/debugfs/ls.c
index 906504e..8e019d2 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -79,7 +79,7 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 		if (LINUX_S_ISDIR(inode.i_mode))
 			fprintf(ls->f, "/");
 		else
-			fprintf(ls->f, "%lld/", inode.i_size | ((__u64)inode.i_size_high << 32));
+			fprintf(ls->f, "%lld/", EXT2_I_SIZE(&inode));
 		fprintf(ls->f, "\n");
 	}
 	else if (ls->options & LONG_OPT) {
@@ -102,8 +102,7 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 		if (LINUX_S_ISDIR(inode.i_mode))
 			fprintf(ls->f, "%5d", inode.i_size);
 		else
-			fprintf(ls->f, "%5llu", inode.i_size |
-				((unsigned long long) inode.i_size_high << 32));
+			fprintf(ls->f, "%5llu", EXT2_I_SIZE(&inode));
 		fprintf (ls->f, " %s %s\n", datestr, name);
 	} else {
 		sprintf(tmp, "%c%u%c (%d) %s   ", lbr, dirent->inode, rbr,
diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index 91ac06a..ba7a90f 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -164,10 +164,7 @@ void do_lsdel(int argc, char **argv)
 			delarray[num_delarray].ino = ino;
 			delarray[num_delarray].mode = inode.i_mode;
 			delarray[num_delarray].uid = inode_uid(inode);
-			delarray[num_delarray].size = inode.i_size;
-			if (!LINUX_S_ISDIR(inode.i_mode))
-				delarray[num_delarray].size |=
-					((__u64) inode.i_size_high << 32);
+			delarray[num_delarray].size = EXT2_I_SIZE(&inode);
 			delarray[num_delarray].dtime = inode.i_dtime;
 			delarray[num_delarray].num_blocks = lsd.num_blocks;
 			delarray[num_delarray].free_blocks = lsd.free_blocks;
diff --git a/e2fsck/message.c b/e2fsck/message.c
index d560cf8..c456752 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -282,8 +282,7 @@ static _INLINE_ void expand_inode_expression(ext2_filsys fs, char ch,
 			else
 				printf("%u", inode->i_size);
 #else
-			printf("%llu", inode->i_size |
-				       ((long long)inode->i_size_high << 32));
+			printf("%llu", EXT2_I_SIZE(inode));
 #endif
 		}
 		break;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index dbf3c94..75491cf 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -256,7 +256,7 @@ static void check_size(e2fsck_t ctx, struct problem_context *pctx)
 {
 	struct ext2_inode *inode = pctx->inode;
 
-	if ((inode->i_size == 0) && (inode->i_size_high == 0))
+	if (EXT2_I_SIZE(inode) == 0)
 		return;
 
 	if (!fix_problem(ctx, PR_1_SET_NONZSIZE, pctx))
@@ -2045,8 +2045,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 		pctx->num = 0;
 	}
-	if (LINUX_S_ISREG(inode->i_mode) &&
-	    (inode->i_size_high || inode->i_size & 0x80000000UL))
+	if (LINUX_S_ISREG(inode->i_mode) && EXT2_I_SIZE(inode) >= 0x80000000UL)
 		ctx->large_files++;
 	if ((pb.num_blocks != ext2fs_inode_i_blocks(fs, inode)) ||
 	    ((fs->super->s_feature_ro_compat &
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index b97a0b3..2863699 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1220,8 +1220,7 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	if (!ext2fs_inode_has_valid_blocks(&inode))
 		return;
 
-	if (LINUX_S_ISREG(inode.i_mode) &&
-	    (inode.i_size_high || inode.i_size & 0x80000000UL))
+	if (LINUX_S_ISREG(inode.i_mode) && EXT2_I_SIZE(&inode) >= 0x80000000UL)
 		ctx->large_files--;
 
 	pctx.errcode = ext2fs_block_iterate3(fs, ino, 0, block_buf,
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 40cfc4f..b5d173a 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -170,8 +170,7 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 	if (inode->i_links_count) {
 		pb.truncating = 1;
 		pb.truncate_block = (e2_blkcnt_t)
-			((((long long)inode->i_size_high << 32) +
-			  inode->i_size + fs->blocksize - 1) /
+			((EXT2_I_SIZE(inode) + fs->blocksize - 1) /
 			 fs->blocksize);
 		pb.truncate_offset = inode->i_size % fs->blocksize;
 	} else {
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 5e07092..abb60dd 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -253,9 +253,8 @@ extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
 	handle->path[0].max_entries = ext2fs_le16_to_cpu(eh->eh_max);
 	handle->path[0].curr = 0;
 	handle->path[0].end_blk =
-		((((__u64) handle->inode->i_size_high << 32) +
-		  handle->inode->i_size + (fs->blocksize - 1))
-		 >> EXT2_BLOCK_SIZE_BITS(fs->super));
+		(EXT2_I_SIZE(handle->inode) + fs->blocksize - 1) >>
+		 EXT2_BLOCK_SIZE_BITS(fs->super);
 	handle->path[0].visit_num = 1;
 	handle->level = 0;
 	handle->magic = EXT2_ET_MAGIC_EXTENT_HANDLE;
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index d62ef35..324f046 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -376,8 +376,7 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 
 	truncate_block = ((size + file->fs->blocksize - 1) >>
 			  EXT2_BLOCK_SIZE_BITS(file->fs->super)) + 1;
-	old_size = file->inode.i_size +
-		((blk64_t)file->inode.i_size_high << 32);
+	old_size = EXT2_I_SIZE(&file->inode);
 	old_truncate = ((old_size + file->fs->blocksize - 1) >>
 		      EXT2_BLOCK_SIZE_BITS(file->fs->super)) + 1;
 
-- 
1.7.3.4

