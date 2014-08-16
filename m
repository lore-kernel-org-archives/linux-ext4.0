From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/27] misc: fix gcc warnings
Date: Sat, 16 Aug 2014 16:46:03 -0700
Message-ID: <20140816234603.11171.57181.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23770 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaHPXqI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:46:08 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a number of warnings about unneeded variables, uninitialized
variables, and ignored return values.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c     |   11 +++--------
 debugfs/xattrs.c      |    3 ---
 debugfs/zap.c         |    1 -
 e2fsck/pass1.c        |    1 -
 e2fsck/pass2.c        |    1 -
 e2fsck/pass3.c        |    2 +-
 e2fsck/pass5.c        |    4 ----
 lib/ext2fs/ext_attr.c |   13 ++-----------
 lib/ext2fs/newdir.c   |    2 --
 misc/create_inode.c   |    5 +----
 misc/e2fuzz.c         |    3 ++-
 misc/tune2fs.c        |    4 +---
 12 files changed, 10 insertions(+), 40 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 6366465..0d8e9e8 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -498,11 +498,6 @@ static void internal_dump_inode_extra(FILE *out,
 				      ext2_ino_t inode_num EXT2FS_ATTR((unused)),
 				      struct ext2_inode_large *inode)
 {
-	struct ext2_ext_attr_entry *entry;
-	__u32 *magic;
-	char *start, *end;
-	unsigned int storage_size;
-
 	fprintf(out, "Size of extra inode fields: %u\n", inode->i_extra_isize);
 	if (inode->i_extra_isize > EXT2_INODE_SIZE(current_fs->super) -
 			EXT2_GOOD_OLD_INODE_SIZE) {
@@ -1595,9 +1590,9 @@ void do_write(int argc, char *argv[])
 
 void do_mknod(int argc, char *argv[])
 {
-	unsigned long	mode, major, minor;
+	unsigned long	major, minor;
 	errcode_t 	retval;
-	int		filetype, nr;
+	int		nr;
 	struct stat	st;
 
 	if (check_fs_open(argv[0]))
@@ -1608,7 +1603,7 @@ void do_mknod(int argc, char *argv[])
 		return;
 	}
 
-	mode = minor = major = 0;
+	minor = major = 0;
 	switch (argv[2][0]) {
 		case 'p':
 			st.st_mode = S_IFIFO;
diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
index 1c19b2f..a80fd0b 100644
--- a/debugfs/xattrs.c
+++ b/debugfs/xattrs.c
@@ -288,9 +288,6 @@ void do_rm_xattr(int argc, char **argv)
 		goto out;
 
 	for (i = 2; i < argc; i++) {
-		size_t buflen;
-		char *buf;
-
 		err = ext2fs_xattr_remove(h, argv[i]);
 		if (err)
 			goto out;
diff --git a/debugfs/zap.c b/debugfs/zap.c
index 917bddf..0a1ae9b 100644
--- a/debugfs/zap.c
+++ b/debugfs/zap.c
@@ -174,7 +174,6 @@ void do_block_dump(int argc, char *argv[])
 	errcode_t	errcode;
 	blk64_t		block;
 	char		*file = NULL;
-	unsigned int	i, j;
 	int		c, err;
 
 	if (check_fs_open(argv[0]))
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a473bd7..4fc5311 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2383,7 +2383,6 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		if (try_repairs && problem) {
 report_problem:
 			if (fix_problem(ctx, problem, pctx)) {
-fix_problem_now:
 				if (ctx->invalid_bitmaps) {
 					/*
 					 * If fsck knows the bitmaps are bad,
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index fb98af5..23310f1 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -746,7 +746,6 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 	struct ext2_dir_entry *d;
 	void *top;
 	struct ext2_dir_entry_tail *t;
-	unsigned int rec_len;
 
 	d = dirbuf;
 	top = EXT2_DIRENT_TAIL(dirbuf, fs->blocksize);
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 63b1d70..9860cdf 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -831,7 +831,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	errcode_t	retval;
 	struct expand_dir_struct es;
 	struct ext2_inode	inode;
-	blk64_t		sz, before, after;
+	blk64_t		sz;
 
 	if (!(fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index bf3f733..86ac9fd 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -327,11 +327,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	problem_t	problem, save_problem;
 	int		fixit, had_problem;
 	errcode_t	retval;
-	int	old_desc_blocks = 0;
-	int	count = 0;
-	int	cmp_block = 0;
 	int	redo_flag = 0;
-	blk64_t	super_blk, old_desc_blk, new_desc_blk;
 	char *actual_buf, *bitmap_buf;
 
 	actual_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index fc191f5..f9b9208 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -302,8 +302,7 @@ errcode_t ext2fs_free_ext_attr(ext2_filsys fs, ext2_ino_t ino,
 {
 	struct ext2_ext_attr_header *header;
 	void *block_buf = NULL;
-	dgrp_t grp;
-	blk64_t blk, goal;
+	blk64_t blk;
 	errcode_t err;
 	struct ext2_inode_large i;
 
@@ -621,7 +620,6 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 	struct ext2_xattr *x;
 	struct ext2_ext_attr_entry *entry;
 	const char *prefix;
-	void *ptr;
 	unsigned int remain, prefix_len;
 	errcode_t err;
 	unsigned int values_size = storage_size +
@@ -719,7 +717,6 @@ static void xattrs_free_keys(struct ext2_xattr_handle *h)
 
 errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 {
-	struct ext2_xattr *attrs = NULL, *x;
 	struct ext2_inode_large *inode;
 	struct ext2_ext_attr_header *header;
 	__u32 ea_inode_magic;
@@ -822,7 +819,6 @@ errcode_t ext2fs_xattrs_iterate(struct ext2_xattr_handle *h,
 				void *data)
 {
 	struct ext2_xattr *x;
-	errcode_t err;
 	int ret;
 
 	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
@@ -869,11 +865,10 @@ errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
 errcode_t ext2fs_xattr_inode_max_size(ext2_filsys fs, ext2_ino_t ino,
 				      size_t *size)
 {
-	struct ext2_ext_attr_header *header;
 	struct ext2_ext_attr_entry *entry;
 	struct ext2_inode_large *inode;
 	__u32 ea_inode_magic;
-	unsigned int storage_size, freesize, minoff;
+	unsigned int minoff;
 	void *start;
 	int i;
 	errcode_t err;
@@ -903,9 +898,6 @@ errcode_t ext2fs_xattr_inode_max_size(ext2_filsys fs, ext2_ino_t ino,
 	       inode->i_extra_isize, sizeof(__u32));
 	if (ea_inode_magic == EXT2_EXT_ATTR_MAGIC) {
 		/* has xattrs.  calculate the size */
-		storage_size = EXT2_INODE_SIZE(fs->super) -
-			EXT2_GOOD_OLD_INODE_SIZE - inode->i_extra_isize -
-			sizeof(__u32);
 		start= ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 			inode->i_extra_isize + sizeof(__u32);
 		entry = start;
@@ -1003,7 +995,6 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 			      const char *key)
 {
 	struct ext2_xattr *x;
-	errcode_t err;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
 	for (x = handle->attrs; x < handle->attrs + handle->length; x++) {
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index 506d609..f9bf8fc 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -102,9 +102,7 @@ errcode_t ext2fs_new_dir_inline_data(ext2_filsys fs, ext2_ino_t dir_ino,
 {
 	struct ext2_dir_entry 	*dir = NULL;
 	errcode_t		retval;
-	char			*buf;
 	int			rec_len;
-	int			filetype = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
diff --git a/misc/create_inode.c b/misc/create_inode.c
index 4d56719..7f57979 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -288,8 +288,6 @@ errcode_t do_symlink_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 	char			*cp;
 	ext2_ino_t		parent_ino;
 	errcode_t		retval;
-	struct ext2_inode	inode;
-	struct stat		st;
 
 	cp = strrchr(name, '/');
 	if (cp) {
@@ -324,9 +322,8 @@ errcode_t do_mkdir_internal(ext2_filsys fs, ext2_ino_t cwd, const char *name,
 			    struct stat *st, ext2_ino_t root)
 {
 	char			*cp;
-	ext2_ino_t		parent_ino, ino;
+	ext2_ino_t		parent_ino;
 	errcode_t		retval;
-	struct ext2_inode	inode;
 
 
 	cp = strrchr(name, '/');
diff --git a/misc/e2fuzz.c b/misc/e2fuzz.c
index 5794f97..c08e3df 100644
--- a/misc/e2fuzz.c
+++ b/misc/e2fuzz.c
@@ -52,7 +52,8 @@ int getseed(void)
 		perror("open");
 		exit(0);
 	}
-	read(fd, &r, sizeof(r));
+	if (read(fd, &r, sizeof(r)) != sizeof(r))
+		printf("Unable to read random seed!\n");
 	close(fd);
 	return r;
 }
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 75a2735..ee47c04 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -186,7 +186,6 @@ static __u32 clear_ok_features[3] = {
 static int get_journal_sb(ext2_filsys jfs, char buf[SUPERBLOCK_SIZE])
 {
 	int retval;
-	int start;
 	journal_superblock_t *jsb;
 
 	if (!(jfs->super->s_feature_incompat &
@@ -805,7 +804,7 @@ static void enable_uninit_bg(ext2_filsys fs)
 static errcode_t zero_empty_inodes(ext2_filsys fs)
 {
 	int length = EXT2_INODE_SIZE(fs->super);
-	struct ext2_inode *inode;
+	struct ext2_inode *inode = NULL;
 	ext2_inode_scan	scan;
 	errcode_t	retval;
 	ext2_ino_t	ino;
@@ -845,7 +844,6 @@ static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
 	dgrp_t i;
 	errcode_t retval;
 	blk64_t b, c, d;
-	int has_super;
 
 	/* Load bitmaps to ensure that the uninit ones get written out */
 	fs->super->s_feature_ro_compat |= csum_feature_flag;

