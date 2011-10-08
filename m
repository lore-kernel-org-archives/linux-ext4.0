From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 24/47] libext2fs: Introduce dir_entry_tail to provide
	checksums for directory leaf nodes
Date: Sat, 08 Oct 2011 00:35:48 -0700
Message-ID: <20111008073548.17888.69972.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51215 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1JHHiF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:38:05 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p986xv7o003928
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 02:59:57 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987ZpIb071450
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:35:51 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987ZogW009134
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:35:51 -0400
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduce small structures for recording directory tree checksums, and some API
changes to support writing out directory blocks with checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/htree.c          |    9 ++-
 e2fsck/pass1.c           |    4 +
 e2fsck/pass2.c           |    9 ++-
 e2fsck/pass3.c           |   10 ++-
 e2fsck/rehash.c          |   49 ++++++++------
 lib/ext2fs/csum.c        |  165 ++++++++++++++++++++++++++++++++++++++++++++--
 lib/ext2fs/dir_iterate.c |   14 +++-
 lib/ext2fs/dirblock.c    |   96 +++++++++++----------------
 lib/ext2fs/expanddir.c   |    5 +
 lib/ext2fs/ext2_fs.h     |   19 +++++
 lib/ext2fs/ext2fs.h      |   22 ++++++
 lib/ext2fs/link.c        |    6 +-
 lib/ext2fs/mkdir.c       |    2 -
 lib/ext2fs/newdir.c      |   15 ++++
 lib/ext2fs/swapfs.c      |   62 +++++++++++++++++
 15 files changed, 385 insertions(+), 102 deletions(-)


diff --git a/debugfs/htree.c b/debugfs/htree.c
index cfdfdd6..90e5563 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -44,6 +44,11 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 	ext2_dirhash_t 	hash, minor_hash;
 	unsigned int	rec_len;
 	int		hash_alg;
+	int		csum_size = 0;
+
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dir_entry_tail);
 
 	errcode = ext2fs_bmap2(fs, ino, inode, buf, 0, blk, 0, &pblk);
 	if (errcode) {
@@ -53,7 +58,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 	}
 
 	printf("Reading directory block %llu, phys %llu\n", blk, pblk);
-	errcode = ext2fs_read_dir_block2(current_fs, pblk, buf, 0);
+	errcode = ext2fs_read_dir_block4(current_fs, pblk, buf, 0, ino);
 	if (errcode) {
 		com_err("htree_dump_leaf_node", errcode,
 			"while reading block %llu (%llu)\n",
@@ -65,7 +70,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 	    (fs->super->s_flags & EXT2_FLAGS_UNSIGNED_HASH))
 		hash_alg += 3;
 
-	while (offset < fs->blocksize) {
+	while (offset < (fs->blocksize - csum_size)) {
 		dirent = (struct ext2_dir_entry *) (buf + offset);
 		errcode = ext2fs_get_rec_len(fs, dirent, &rec_len);
 		if (errcode) {
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 96f87e8..e2fe53c 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -473,7 +473,9 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 
 	/* read the first block */
 	ehandler_operation(_("reading directory block"));
-	retval = ext2fs_read_dir_block3(ctx->fs, blk, buf, 0);
+	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	retval = ext2fs_read_dir_block4(ctx->fs, blk, buf, 0, pctx->ino);
+	ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	ehandler_operation(0);
 	if (retval)
 		return;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 11c469b..6b103fc 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -799,7 +799,9 @@ static int check_dir_block(ext2_filsys fs,
 #endif
 
 	ehandler_operation(_("reading directory block"));
-	cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, 0);
+	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	cd->pctx.errcode = ext2fs_read_dir_block4(fs, block_nr, buf, 0, ino);
+	ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
@@ -1151,7 +1153,8 @@ out_htree:
 		}
 	}
 	if (dir_modified) {
-		cd->pctx.errcode = ext2fs_write_dir_block(fs, block_nr, buf);
+		cd->pctx.errcode = ext2fs_write_dir_block4(fs, block_nr, buf,
+							   0, ino);
 		if (cd->pctx.errcode) {
 			if (!fix_problem(ctx, PR_2_WRITE_DIRBLOCK,
 					 &cd->pctx))
@@ -1471,7 +1474,7 @@ static int allocate_dir_block(e2fsck_t ctx,
 		return 1;
 	}
 
-	pctx->errcode = ext2fs_write_dir_block(fs, blk, block);
+	pctx->errcode = ext2fs_write_dir_block4(fs, blk, block, 0, db->ino);
 	ext2fs_free_mem(&block);
 	if (pctx->errcode) {
 		pctx->str = "ext2fs_write_dir_block";
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 7164aa9..86a509c 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -197,7 +197,8 @@ static void check_root(e2fsck_t ctx)
 		return;
 	}
 
-	pctx.errcode = ext2fs_write_dir_block(fs, blk, block);
+	pctx.errcode = ext2fs_write_dir_block4(fs, blk, block, 0,
+					       EXT2_ROOT_INO);
 	if (pctx.errcode) {
 		pctx.str = "ext2fs_write_dir_block";
 		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
@@ -443,7 +444,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 		return 0;
 	}
 
-	retval = ext2fs_write_dir_block(fs, blk, block);
+	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
 	ext2fs_free_mem(&block);
 	if (retval) {
 		pctx.errcode = retval;
@@ -684,6 +685,7 @@ struct expand_dir_struct {
 	blk64_t			last_block;
 	errcode_t		err;
 	e2fsck_t		ctx;
+	ext2_ino_t		dir;
 };
 
 static int expand_dir_proc(ext2_filsys fs,
@@ -724,7 +726,8 @@ static int expand_dir_proc(ext2_filsys fs,
 			return BLOCK_ABORT;
 		}
 		es->num--;
-		retval = ext2fs_write_dir_block(fs, new_blk, block);
+		retval = ext2fs_write_dir_block4(fs, new_blk, block, 0,
+						 es->dir);
 	} else {
 		retval = ext2fs_get_mem(fs->blocksize, &block);
 		if (retval) {
@@ -777,6 +780,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	es.err = 0;
 	es.newblocks = 0;
 	es.ctx = ctx;
+	es.dir = dir;
 
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 5fbe862..ff5e000 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -62,6 +62,7 @@ struct fill_dir_struct {
 	int dir_size;
 	int compress;
 	ino_t parent;
+	ext2_ino_t dir;
 };
 
 struct hash_entry {
@@ -106,7 +107,10 @@ static int fill_dir_block(ext2_filsys fs,
 		dirent = (struct ext2_dir_entry *) dir;
 		(void) ext2fs_set_rec_len(fs, fs->blocksize, dirent);
 	} else {
-		fd->err = ext2fs_read_dir_block3(fs, *block_nr, dir, 0);
+		fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		fd->err = ext2fs_read_dir_block4(fs, *block_nr, dir, 0,
+						 fd->dir);
+		fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		if (fd->err)
 			return BLOCK_ABORT;
 	}
@@ -397,7 +401,8 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 
 static errcode_t copy_dir_entries(e2fsck_t ctx,
 				  struct fill_dir_struct *fd,
-				  struct out_dir *outdir)
+				  struct out_dir *outdir,
+				  ext2_ino_t ino)
 {
 	ext2_filsys 		fs = ctx->fs;
 	errcode_t		retval;
@@ -408,6 +413,8 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 	int			i, left;
 	ext2_dirhash_t		prev_hash;
 	int			offset, slack;
+	int			csum_size = 0;
+	struct			ext2_dir_entry_tail *t;
 
 	if (ctx->htree_slack_percentage == 255) {
 		profile_get_uint(ctx->profile, "options",
@@ -418,6 +425,10 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 			ctx->htree_slack_percentage = 20;
 	}
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dir_entry_tail);
+
 	outdir->max = 0;
 	retval = alloc_size_dir(fs, outdir,
 				(fd->dir_size / fs->blocksize) + 2);
@@ -432,9 +443,9 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 	dirent = (struct ext2_dir_entry *) block_start;
 	prev_rec_len = 0;
 	rec_len = 0;
-	left = fs->blocksize;
+	left = fs->blocksize - csum_size;
 	slack = fd->compress ? 12 :
-		(fs->blocksize * ctx->htree_slack_percentage)/100;
+		((fs->blocksize - csum_size) * ctx->htree_slack_percentage)/100;
 	if (slack < 12)
 		slack = 12;
 	for (i = 0; i < fd->num_array; i++) {
@@ -449,12 +460,17 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 				if (retval)
 					return retval;
 			}
+			if (csum_size) {
+				t = EXT2_DIRENT_TAIL(block_start,
+						     fs->blocksize, csum_size);
+				ext2fs_initialize_dirent_tail(fs, t);
+			}
 			if ((retval = get_next_block(fs, outdir,
 						      &block_start)))
 				return retval;
 			offset = 0;
 		}
-		left = fs->blocksize - offset;
+		left = (fs->blocksize - csum_size) - offset;
 		dirent = (struct ext2_dir_entry *) (block_start + offset);
 		if (offset == 0) {
 			if (ent->hash == prev_hash)
@@ -483,6 +499,10 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 	}
 	if (left)
 		retval = ext2fs_set_rec_len(fs, rec_len + left, dirent);
+	if (csum_size) {
+		t = EXT2_DIRENT_TAIL(block_start, fs->blocksize, csum_size);
+		ext2fs_initialize_dirent_tail(fs, t);
+	}
 
 	return retval;
 }
@@ -603,10 +623,6 @@ static errcode_t calculate_tree(ext2_filsys fs,
 				if (limit) {
 					limit->limit = limit->count =
 		ext2fs_cpu_to_le16(limit->limit);
-					retval = ext2fs_dx_csum_set(fs, ino,
-		(struct ext2_dir_entry *)(((void *)limit) - 8));
-					if (retval)
-						return retval;
 				}
 				root = (struct ext2_dx_entry *)
 					(outdir->buf + root_offset);
@@ -632,18 +648,10 @@ static errcode_t calculate_tree(ext2_filsys fs,
 		}
 		limit->count = ext2fs_cpu_to_le16(limit->limit - c2);
 		limit->limit = ext2fs_cpu_to_le16(limit->limit);
-		retval = ext2fs_dx_csum_set(fs, ino,
-				(struct ext2_dir_entry *)(((void *)limit) - 8));
-		if (retval)
-			return retval;
 	}
 	root_limit = (struct ext2_dx_countlimit *) (outdir->buf + limit_offset);
 	root_limit->count = ext2fs_cpu_to_le16(root_limit->limit - c1);
 	root_limit->limit = ext2fs_cpu_to_le16(root_limit->limit);
-	retval = ext2fs_dx_csum_set(fs, ino,
-				    (struct ext2_dir_entry *)outdir->buf);
-	if (retval)
-		return retval;
 
 	return 0;
 }
@@ -653,6 +661,7 @@ struct write_dir_struct {
 	errcode_t	err;
 	e2fsck_t	ctx;
 	int		cleared;
+	ext2_ino_t	dir;
 };
 
 /*
@@ -684,7 +693,7 @@ static int write_dir_block(ext2_filsys fs,
 		return 0;
 
 	dir = wd->outdir->buf + (blockcnt * fs->blocksize);
-	wd->err = ext2fs_write_dir_block3(fs, *block_nr, dir, 0);
+	wd->err = ext2fs_write_dir_block4(fs, *block_nr, dir, 0, wd->dir);
 	if (wd->err)
 		return BLOCK_ABORT;
 	return 0;
@@ -706,6 +715,7 @@ static errcode_t write_directory(e2fsck_t ctx, ext2_filsys fs,
 	wd.err = 0;
 	wd.ctx = ctx;
 	wd.cleared = 0;
+	wd.dir = ino;
 
 	retval = ext2fs_block_iterate3(fs, ino, 0, 0,
 				       write_dir_block, &wd);
@@ -758,6 +768,7 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino)
 	fd.err = 0;
 	fd.dir_size = 0;
 	fd.compress = 0;
+	fd.dir = ino;
 	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) ||
 	    (inode.i_size / fs->blocksize) < 2)
 		fd.compress = 1;
@@ -817,7 +828,7 @@ resort:
 	 * Copy the directory entries.  In a htree directory these
 	 * will become the leaf nodes.
 	 */
-	retval = copy_dir_entries(ctx, &fd, &outdir);
+	retval = copy_dir_entries(ctx, &fd, &outdir, ino);
 	if (retval)
 		goto errout;
 
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index cd788c8..133cf84 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,130 @@
 #define STATIC static
 #endif
 
+void ext2fs_initialize_dirent_tail(ext2_filsys fs,
+				   struct ext2_dir_entry_tail *t)
+{
+	memset(t, 0, sizeof(struct ext2_dir_entry_tail));
+	ext2fs_set_rec_len(fs, sizeof(struct ext2_dir_entry_tail),
+			   (struct ext2_dir_entry *)t);
+	t->reserved_name_len = EXT2_DIR_NAME_LEN_CSUM;
+}
+
+static struct ext2_dir_entry_tail *get_dirent_tail(ext2_filsys fs,
+						struct ext2_dir_entry *dirent)
+{
+	struct ext2_dir_entry *d, *top;
+	struct ext2_dir_entry_tail *t;
+	unsigned int rec_len;
+	errcode_t retval;
+
+	d = dirent;
+	top = (struct ext2_dir_entry *)
+			(((void *)dirent) +
+			 (fs->blocksize - sizeof(struct ext2_dir_entry_tail)));
+
+	retval = ext2fs_get_rec_len(fs, d, &rec_len);
+	while (d < top && !retval && rec_len) {
+		d = (struct ext2_dir_entry *)(((void *)d) + rec_len);
+		retval = ext2fs_get_rec_len(fs, d, &rec_len);
+	}
+
+	if (d != top)
+		return NULL;
+
+	t = (struct ext2_dir_entry_tail *)d;
+	if (t->reserved_zero1 ||
+	    t->rec_len != sizeof(struct ext2_dir_entry_tail) ||
+	    t->reserved_name_len != EXT2_DIR_NAME_LEN_CSUM)
+		return NULL;
+
+	return t;
+}
+
+int ext2fs_dirent_has_tail(ext2_filsys fs, struct ext2_dir_entry *dirent)
+{
+	return get_dirent_tail(fs, dirent) != NULL;
+}
+
+static errcode_t ext2fs_dirent_csum(ext2_filsys fs, ext2_ino_t inum,
+				    struct ext2_dir_entry *dirent, __u32 *crc,
+				    int size)
+{
+	errcode_t retval = 0;
+	char *buf = (char *)dirent;
+	__u32 ncrc;
+
+#ifdef WORDS_BIGENDIAN
+	retval = ext2fs_get_mem(fs->blocksize, &buf);
+	if (retval)
+		return retval;
+	memcpy(buf, dirent, fs->blocksize);
+	retval = ext2fs_dirent_swab_out(fs, buf, 0);
+	if (retval)
+		goto out;
+#endif
+
+	inum = ext2fs_cpu_to_le32(inum);
+	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+				sizeof(fs->super->s_uuid));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
+	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)buf, size);
+	*crc = ncrc;
+
+#ifdef WORDS_BIGENDIAN
+out:
+	ext2fs_free_mem(&buf);
+#endif
+
+	return retval;
+}
+
+int ext2fs_dirent_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+			      struct ext2_dir_entry *dirent)
+{
+	errcode_t retval;
+	__u32 calculated;
+	struct ext2_dir_entry_tail *t;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	t = get_dirent_tail(fs, dirent);
+	if (!t)
+		return 1;
+
+	/*
+	 * The checksum field is overlaid with the dirent->name field
+	 * so the swapfs.c functions won't change the endianness.
+	 */
+	retval = ext2fs_dirent_csum(fs, inum, dirent, &calculated,
+				    (void *)t - (void *)dirent);
+	if (retval)
+		return 0;
+	return ext2fs_le32_to_cpu(t->checksum) == calculated;
+}
+
+static errcode_t ext2fs_dirent_csum_set(ext2_filsys fs, ext2_ino_t inum,
+					struct ext2_dir_entry *dirent)
+{
+	errcode_t retval;
+	__u32 crc;
+	struct ext2_dir_entry_tail *t;
+
+	t = get_dirent_tail(fs, dirent);
+	if (!t)
+		return 0;
+
+	/* swapfs.c functions don't change the checksum endianness */
+	retval = ext2fs_dirent_csum(fs, inum, dirent, &crc,
+				    (void *)t - (void *)dirent);
+	if (retval)
+		return retval;
+	t->checksum = ext2fs_cpu_to_le32(crc);
+	return 0;
+}
+
 static errcode_t ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
 				struct ext2_dir_entry *dirent,
 				__u32 *crc, int count_offset, int count)
@@ -102,8 +226,8 @@ int ext2fs_dx_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 	return ext2fs_le32_to_cpu(t->checksum) == calculated;
 }
 
-errcode_t ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
-			     struct ext2_dir_entry *dirent)
+static errcode_t ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				    struct ext2_dir_entry *dirent)
 {
 	__u32 crc;
 	errcode_t retval = 0;
@@ -111,10 +235,6 @@ errcode_t ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
 	struct ext2_dx_tail *t;
 	int count_offset, limit, count;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
-		return 0;
-
 	c = ext2fs_get_dx_countlimit(fs, dirent, &count_offset);
 	if (!c)
 		return 0;
@@ -133,6 +253,39 @@ errcode_t ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
 	return retval;
 }
 
+int ext2fs_dir_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				 struct ext2_dir_entry *dirent)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	if (get_dirent_tail(fs, dirent))
+		return ext2fs_dirent_csum_verify(fs, inum, dirent);
+	if (ext2fs_get_dx_countlimit(fs, dirent, NULL))
+		return ext2fs_dx_csum_verify(fs, inum, dirent);
+
+	return 0;
+}
+
+errcode_t ext2fs_dir_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				    struct ext2_dir_entry *dirent)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	if (get_dirent_tail(fs, dirent))
+		return ext2fs_dirent_csum_set(fs, inum, dirent);
+	if (ext2fs_get_dx_countlimit(fs, dirent, NULL))
+		return ext2fs_dx_csum_set(fs, inum, dirent);
+
+	if (fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)
+		return 0;
+	printf("%s: Not htree or leaf dir block?\n", __func__);
+	abort();
+}
+
 #define EXT3_EXTENT_TAIL_OFFSET(hdr)	(sizeof(struct ext3_extent_header) + \
 	(sizeof(struct ext3_extent) * ext2fs_le16_to_cpu((hdr)->eh_max)))
 
diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index 5125d19..c24015c 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -192,17 +192,23 @@ int ext2fs_process_dir_block(ext2_filsys fs,
 	unsigned int	rec_len, size;
 	int		entry;
 	struct ext2_dir_entry *dirent;
+	int		csum_size = 0;
 
 	if (blockcnt < 0)
 		return 0;
 
 	entry = blockcnt ? DIRENT_OTHER_FILE : DIRENT_DOT_FILE;
 
-	ctx->errcode = ext2fs_read_dir_block3(fs, *blocknr, ctx->buf, 0);
+	ctx->errcode = ext2fs_read_dir_block4(fs, *blocknr, ctx->buf, 0,
+					      ctx->dir);
 	if (ctx->errcode)
 		return BLOCK_ABORT;
 
-	while (offset < fs->blocksize) {
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dir_entry_tail);
+
+	while (offset < (fs->blocksize - csum_size)) {
 		dirent = (struct ext2_dir_entry *) (ctx->buf + offset);
 		if (ext2fs_get_rec_len(fs, dirent, &rec_len))
 			return BLOCK_ABORT;
@@ -259,8 +265,8 @@ next:
 	}
 
 	if (changed) {
-		ctx->errcode = ext2fs_write_dir_block3(fs, *blocknr, ctx->buf,
-						       0);
+		ctx->errcode = ext2fs_write_dir_block4(fs, *blocknr, ctx->buf,
+						       0, ctx->dir);
 		if (ctx->errcode)
 			return BLOCK_ABORT;
 	}
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index cb3a104..347d422 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -20,45 +20,34 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
-				 void *buf, int flags EXT2FS_ATTR((unused)))
+errcode_t ext2fs_read_dir_block4(ext2_filsys fs, blk64_t block,
+				 void *buf, int flags EXT2FS_ATTR((unused)),
+				 ext2_ino_t ino)
 {
 	errcode_t	retval;
-	char		*p, *end;
-	struct ext2_dir_entry *dirent;
-	unsigned int	name_len, rec_len;
-
 
 	retval = io_channel_read_blk64(fs->io, block, 1, buf);
 	if (retval)
 		return retval;
-
-	p = (char *) buf;
-	end = (char *) buf + fs->blocksize;
-	while (p < end-8) {
-		dirent = (struct ext2_dir_entry *) p;
 #ifdef WORDS_BIGENDIAN
-		dirent->inode = ext2fs_swab32(dirent->inode);
-		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
-		dirent->name_len = ext2fs_swab16(dirent->name_len);
-#endif
-		name_len = dirent->name_len;
-#ifdef WORDS_BIGENDIAN
-		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
-			dirent->name_len = ext2fs_swab16(dirent->name_len);
+	retval = ext2fs_dirent_swab_in(fs, buf, flags);
+	if (retval)
+		return retval;
 #endif
-		if ((retval = ext2fs_get_rec_len(fs, dirent, &rec_len)) != 0)
-			return retval;
-		if ((rec_len < 8) || (rec_len % 4)) {
-			rec_len = 8;
-			retval = EXT2_ET_DIR_CORRUPTED;
-		} else if (((name_len & 0xFF) + 8) > rec_len)
-			retval = EXT2_ET_DIR_CORRUPTED;
-		p += rec_len;
-	}
+
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_dir_block_csum_verify(fs, ino,
+					  (struct ext2_dir_entry *)buf))
+		return EXT2_ET_DIR_CORRUPTED;
 	return retval;
 }
 
+errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
+				 void *buf, int flags EXT2FS_ATTR((unused)))
+{
+	return ext2fs_read_dir_block4(fs, block, buf, flags, 0);
+}
+
 errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
 				 void *buf, int flags EXT2FS_ATTR((unused)))
 {
@@ -72,45 +61,38 @@ errcode_t ext2fs_read_dir_block(ext2_filsys fs, blk_t block,
 }
 
 
-errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
-				  void *inbuf, int flags EXT2FS_ATTR((unused)))
+errcode_t ext2fs_write_dir_block4(ext2_filsys fs, blk64_t block,
+				  void *inbuf, int flags EXT2FS_ATTR((unused)),
+				  ext2_ino_t ino)
 {
-#ifdef WORDS_BIGENDIAN
 	errcode_t	retval;
-	char		*p, *end;
-	char		*buf = 0;
-	unsigned int	rec_len;
-	struct ext2_dir_entry *dirent;
+	char		*buf = inbuf;
+
+	retval = ext2fs_dir_block_csum_set(fs, ino,
+					   (struct ext2_dir_entry *)inbuf);
+	if (retval)
+		return retval;
 
+#ifdef WORDS_BIGENDIAN
 	retval = ext2fs_get_mem(fs->blocksize, &buf);
 	if (retval)
 		return retval;
 	memcpy(buf, inbuf, fs->blocksize);
-	p = buf;
-	end = buf + fs->blocksize;
-	while (p < end) {
-		dirent = (struct ext2_dir_entry *) p;
-		if ((retval = ext2fs_get_rec_len(fs, dirent, &rec_len)) != 0)
-			return retval;
-		if ((rec_len < 8) ||
-		    (rec_len % 4)) {
-			ext2fs_free_mem(&buf);
-			return (EXT2_ET_DIR_CORRUPTED);
-		}
-		p += rec_len;
-		dirent->inode = ext2fs_swab32(dirent->inode);
-		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
-		dirent->name_len = ext2fs_swab16(dirent->name_len);
-
-		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
-			dirent->name_len = ext2fs_swab16(dirent->name_len);
-	}
+	retval = ext2fs_dirent_swab_out(fs, buf, flags);
+	if (retval)
+		return retval;
+#endif
 	retval = io_channel_write_blk64(fs->io, block, 1, buf);
+#ifdef WORDS_BIGENDIAN
 	ext2fs_free_mem(&buf);
-	return retval;
-#else
-	return io_channel_write_blk64(fs->io, block, 1, (char *) inbuf);
 #endif
+	return retval;
+}
+
+errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
+				  void *inbuf, int flags EXT2FS_ATTR((unused)))
+{
+	return ext2fs_write_dir_block4(fs, block, inbuf, flags, 0);
 }
 
 errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 41c4088..22558d6 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -24,6 +24,7 @@ struct expand_dir_struct {
 	int		newblocks;
 	blk64_t		goal;
 	errcode_t	err;
+	ext2_ino_t	dir;
 };
 
 static int expand_dir_proc(ext2_filsys	fs,
@@ -62,7 +63,8 @@ static int expand_dir_proc(ext2_filsys	fs,
 			return BLOCK_ABORT;
 		}
 		es->done = 1;
-		retval = ext2fs_write_dir_block(fs, new_blk, block);
+		retval = ext2fs_write_dir_block4(fs, new_blk, block, 0,
+						 es->dir);
 	} else {
 		retval = ext2fs_get_mem(fs->blocksize, &block);
 		if (retval) {
@@ -110,6 +112,7 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 	es.err = 0;
 	es.goal = 0;
 	es.newblocks = 0;
+	es.dir = dir;
 
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 65d205a..3d2ade0 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -798,6 +798,17 @@ struct ext2_dir_entry_2 {
 };
 
 /*
+ * This is a bogus directory entry at the end of each leaf block that
+ * records checksums.
+ */
+struct ext2_dir_entry_tail {
+	__u32	reserved_zero1;		/* Pretend to be unused */
+	__u16	rec_len;		/* 12 */
+	__u16	reserved_name_len;	/* 0xDE00, fake namelen/filetype */
+	__u32	checksum;		/* crc32c(uuid+inode+dirent) */
+};
+
+/*
  * Ext2 directory file types.  Only the low 3 bits are used.  The
  * other bits are reserved for now.
  */
@@ -813,6 +824,14 @@ struct ext2_dir_entry_2 {
 #define EXT2_FT_MAX		8
 
 /*
+ * Annoyingly, e2fsprogs always swab16s ext2_dir_entry.name_len, so we
+ * have to build ext2_dir_entry_tail with that assumption too.  This
+ * constant helps to build the dir_entry_tail to look like it has an
+ * "invalid" file type.
+ */
+#define EXT2_DIR_NAME_LEN_CSUM	0xDE00
+
+/*
  * EXT2_DIR_PAD defines the directory entries boundaries
  *
  * NOTE: It must be a multiple of 4
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7836fd2..77a92af 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -929,8 +929,20 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
-extern errcode_t ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
-				    struct ext2_dir_entry *dirent);
+#define EXT2_DIRENT_TAIL(block, blocksize, csum_size) \
+	((struct ext2_dir_entry_tail *)(((void *)(block)) + \
+					(blocksize) - (csum_size)))
+
+extern void ext2fs_initialize_dirent_tail(ext2_filsys fs,
+					  struct ext2_dir_entry_tail *t);
+extern int ext2fs_dirent_has_tail(ext2_filsys fs,
+				  struct ext2_dir_entry *dirent);
+extern int ext2fs_dir_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+					struct ext2_dir_entry *dirent);
+extern errcode_t ext2fs_dir_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
+					   struct ext2_dir_entry *dirent);
+extern int ext2fs_dirent_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				     struct ext2_dir_entry *dirent);
 extern int ext2fs_dx_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 				 struct ext2_dir_entry *dirent);
 extern errcode_t ext2fs_extent_block_csum_set(ext2_filsys fs,
@@ -1012,12 +1024,16 @@ extern errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
 					void *buf, int flags);
 extern errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
 					void *buf, int flags);
+extern errcode_t ext2fs_read_dir_block4(ext2_filsys fs, blk64_t block,
+					void *buf, int flags, ext2_ino_t ino);
 extern errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
 					void *buf);
 extern errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
 					 void *buf, int flags);
 extern errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
 					 void *buf, int flags);
+extern errcode_t ext2fs_write_dir_block4(ext2_filsys fs, blk64_t block,
+					 void *buf, int flags, ext2_ino_t ino);
 
 /* dirhash.c */
 extern struct ext2_dx_countlimit *ext2fs_get_dx_countlimit(ext2_filsys fs,
@@ -1408,6 +1424,8 @@ extern errcode_t ext2fs_read_bb_FILE(ext2_filsys fs, FILE *f,
 extern errcode_t ext2fs_create_resize_inode(ext2_filsys fs);
 
 /* swapfs.c */
+extern errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags);
+extern errcode_t ext2fs_dirent_swab_out(ext2_filsys fs, char *buf, int flags);
 extern void ext2fs_swap_ext_attr(char *to, char *from, int bufsize,
 				 int has_header);
 extern void ext2fs_swap_ext_attr_header(struct ext2_ext_attr_header *to_header,
diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 2d03b57..2dec5dc 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -41,6 +41,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	struct ext2_dir_entry *next;
 	unsigned int rec_len, min_rec_len, curr_rec_len;
 	int ret = 0;
+	int csum_size = 0;
 
 	rec_len = EXT2_DIR_REC_LEN(ls->namelen);
 
@@ -48,12 +49,15 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	if (ls->err)
 		return DIRENT_ABORT;
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(ls->fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dir_entry_tail);
 	/*
 	 * See if the following directory entry (if any) is unused;
 	 * if so, absorb it into this one.
 	 */
 	next = (struct ext2_dir_entry *) (buf + offset + curr_rec_len);
-	if ((offset + (int) curr_rec_len < blocksize - 8) &&
+	if ((offset + (int) curr_rec_len < blocksize - (8 + csum_size)) &&
 	    (next->inode == 0) &&
 	    (offset + (int) curr_rec_len + (int) next->rec_len <= blocksize)) {
 		curr_rec_len += next->rec_len;
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index b12bf2d..0d1b7b8 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -95,7 +95,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Write out the inode and inode data block
 	 */
-	retval = ext2fs_write_dir_block(fs, blk, block);
+	retval = ext2fs_write_dir_block4(fs, blk, block, 0, ino);
 	if (retval)
 		goto cleanup;
 	retval = ext2fs_write_new_inode(fs, ino, &inode);
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index b0a1e47..7c3ac65 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -34,6 +34,8 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 	char			*buf;
 	int			rec_len;
 	int			filetype = 0;
+	struct ext2_dir_entry_tail	*t;
+	int			csum_size = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -43,7 +45,11 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 	memset(buf, 0, fs->blocksize);
 	dir = (struct ext2_dir_entry *) buf;
 
-	retval = ext2fs_set_rec_len(fs, fs->blocksize, dir);
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dir_entry_tail);
+
+	retval = ext2fs_set_rec_len(fs, fs->blocksize - csum_size, dir);
 	if (retval)
 		return retval;
 
@@ -57,7 +63,7 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 		dir->inode = dir_ino;
 		dir->name_len = 1 | filetype;
 		dir->name[0] = '.';
-		rec_len = fs->blocksize - EXT2_DIR_REC_LEN(1);
+		rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
 		dir->rec_len = EXT2_DIR_REC_LEN(1);
 
 		/*
@@ -73,6 +79,11 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 		dir->name[1] = '.';
 
 	}
+
+	if (csum_size) {
+		t = EXT2_DIRENT_TAIL(buf, fs->blocksize, csum_size);
+		ext2fs_initialize_dirent_tail(fs, t);
+	}
 	*block = buf;
 	return 0;
 }
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 7c99373..69916e5 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -350,4 +350,66 @@ void ext2fs_swap_mmp(struct mmp_struct *mmp)
 	mmp->mmp_check_interval = ext2fs_swab16(mmp->mmp_check_interval);
 }
 
+errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags)
+{
+	errcode_t	retval;
+	char		*p, *end;
+	struct ext2_dir_entry *dirent;
+	unsigned int	name_len, rec_len;
+
+	p = (char *) buf;
+	end = (char *) buf + fs->blocksize;
+	while (p < end-8) {
+		dirent = (struct ext2_dir_entry *) p;
+		dirent->inode = ext2fs_swab32(dirent->inode);
+		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
+		dirent->name_len = ext2fs_swab16(dirent->name_len);
+		name_len = dirent->name_len;
+		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
+			dirent->name_len = ext2fs_swab16(dirent->name_len);
+		retval = ext2fs_get_rec_len(fs, dirent, &rec_len);
+		if (retval)
+			return retval;
+		if ((rec_len < 8) || (rec_len % 4)) {
+			rec_len = 8;
+			retval = EXT2_ET_DIR_CORRUPTED;
+		} else if (((name_len & 0xFF) + 8) > rec_len)
+			retval = EXT2_ET_DIR_CORRUPTED;
+		p += rec_len;
+	}
+
+	return 0;
+}
+
+errcode_t ext2fs_dirent_swab_out(ext2_filsys fs, char *buf, int flags)
+{
+	errcode_t	retval;
+	char		*p, *end;
+	unsigned int	rec_len;
+	struct ext2_dir_entry *dirent;
+
+	p = buf;
+	end = buf + fs->blocksize;
+	while (p < end) {
+		dirent = (struct ext2_dir_entry *) p;
+		retval = ext2fs_get_rec_len(fs, dirent, &rec_len);
+		if (retval)
+			return retval;
+		if ((rec_len < 8) ||
+		    (rec_len % 4)) {
+			ext2fs_free_mem(&buf);
+			return EXT2_ET_DIR_CORRUPTED;
+		}
+		p += rec_len;
+		dirent->inode = ext2fs_swab32(dirent->inode);
+		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
+		dirent->name_len = ext2fs_swab16(dirent->name_len);
+
+		if (flags & EXT2_DIRBLOCK_V2_STRUCT)
+			dirent->name_len = ext2fs_swab16(dirent->name_len);
+	}
+
+	return 0;
+}
+
 #endif

