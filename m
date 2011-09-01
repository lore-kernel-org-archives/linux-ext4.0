From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 26/37] libext2fs: Introduce dir_entry_tail to provide
	checksums for directory leaf nodes
Date: Wed, 31 Aug 2011 17:37:57 -0700
Message-ID: <20110901003757.1176.70724.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59253 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132Ab1IAAiC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:38:02 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8107noh000998
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:07:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810c1TZ241052
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:38:01 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810bxrU028458
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:38:01 -0400
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduce small structures for recording directory tree checksums, and some API
changes to support writing out directory blocks with checksums.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/htree.c          |    9 ++-
 e2fsck/pass1.c           |    4 +
 e2fsck/pass2.c           |    9 ++-
 e2fsck/pass3.c           |    8 +-
 e2fsck/rehash.c          |   48 ++++++++++----
 lib/ext2fs/csum.c        |  159 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/dir_iterate.c |   12 +++
 lib/ext2fs/dirblock.c    |   94 +++++++++------------------
 lib/ext2fs/expanddir.c   |    4 +
 lib/ext2fs/ext2_fs.h     |   11 +++
 lib/ext2fs/ext2fs.h      |   26 ++++++--
 lib/ext2fs/link.c        |    6 +-
 lib/ext2fs/mkdir.c       |    2 -
 lib/ext2fs/newdir.c      |   17 ++++-
 lib/ext2fs/swapfs.c      |   62 ++++++++++++++++++
 15 files changed, 372 insertions(+), 99 deletions(-)


diff --git a/debugfs/htree.c b/debugfs/htree.c
index 9b4758a..1850978 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -43,6 +43,11 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
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
@@ -52,7 +57,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 	}
 
 	printf("Reading directory block %llu, phys %llu\n", blk, pblk);
-	errcode = ext2fs_read_dir_block2(current_fs, pblk, buf, 0);
+	errcode = ext2fs_read_dir_block2(current_fs, pblk, buf, 0, ino);
 	if (errcode) {
 		com_err("htree_dump_leaf_node", errcode,
 			"while reading block %llu (%llu)\n",
@@ -64,7 +69,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 	    (fs->super->s_flags & EXT2_FLAGS_UNSIGNED_HASH))
 		hash_alg += 3;
 
-	while (offset < fs->blocksize) {
+	while (offset < (fs->blocksize - csum_size)) {
 		dirent = (struct ext2_dir_entry *) (buf + offset);
 		errcode = ext2fs_get_rec_len(fs, dirent, &rec_len);
 		if (errcode) {
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index e9b0876..71cbddb 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -473,7 +473,9 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 
 	/* read the first block */
 	old_op = ehandler_operation(_("reading directory block"));
-	retval = ext2fs_read_dir_block3(ctx->fs, blk, buf, 0);
+	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	retval = ext2fs_read_dir_block3(ctx->fs, blk, buf, 0, pctx->ino);
+	ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	ehandler_operation(0);
 	if (retval)
 		return;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 586bcec..93a09d1 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -799,7 +799,9 @@ static int check_dir_block(ext2_filsys fs,
 #endif
 
 	old_op = ehandler_operation(_("reading directory block"));
-	cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, 0);
+	ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, 0, ino);
+	ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
@@ -1157,7 +1159,8 @@ out_htree:
 		}
 	}
 	if (dir_modified) {
-		cd->pctx.errcode = ext2fs_write_dir_block(fs, block_nr, buf);
+		cd->pctx.errcode = ext2fs_write_dir_block(fs, block_nr, buf,
+							  ino);
 		if (cd->pctx.errcode) {
 			if (!fix_problem(ctx, PR_2_WRITE_DIRBLOCK,
 					 &cd->pctx))
@@ -1467,7 +1470,7 @@ static int allocate_dir_block(e2fsck_t ctx,
 		return 1;
 	}
 
-	pctx->errcode = ext2fs_write_dir_block(fs, blk, block);
+	pctx->errcode = ext2fs_write_dir_block(fs, blk, block, db->ino);
 	ext2fs_free_mem(&block);
 	if (pctx->errcode) {
 		pctx->str = "ext2fs_write_dir_block";
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 2330aab..2360aff 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -196,7 +196,7 @@ static void check_root(e2fsck_t ctx)
 		return;
 	}
 
-	pctx.errcode = ext2fs_write_dir_block(fs, blk, block);
+	pctx.errcode = ext2fs_write_dir_block(fs, blk, block, EXT2_ROOT_INO);
 	if (pctx.errcode) {
 		pctx.str = "ext2fs_write_dir_block";
 		fix_problem(ctx, PR_3_CREATE_ROOT_ERROR, &pctx);
@@ -442,7 +442,7 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 		return 0;
 	}
 
-	retval = ext2fs_write_dir_block(fs, blk, block);
+	retval = ext2fs_write_dir_block(fs, blk, block, ino);
 	ext2fs_free_mem(&block);
 	if (retval) {
 		pctx.errcode = retval;
@@ -681,6 +681,7 @@ struct expand_dir_struct {
 	blk64_t			last_block;
 	errcode_t		err;
 	e2fsck_t		ctx;
+	ext2_ino_t		dir;
 };
 
 static int expand_dir_proc(ext2_filsys fs,
@@ -721,7 +722,7 @@ static int expand_dir_proc(ext2_filsys fs,
 			return BLOCK_ABORT;
 		}
 		es->num--;
-		retval = ext2fs_write_dir_block(fs, new_blk, block);
+		retval = ext2fs_write_dir_block(fs, new_blk, block, es->dir);
 	} else {
 		retval = ext2fs_get_mem(fs->blocksize, &block);
 		if (retval) {
@@ -774,6 +775,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 	es.err = 0;
 	es.newblocks = 0;
 	es.ctx = ctx;
+	es.dir = dir;
 
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 97d2b83..25cc8b8 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -61,6 +61,7 @@ struct fill_dir_struct {
 	int dir_size;
 	int compress;
 	ino_t parent;
+	ext2_ino_t dir;
 };
 
 struct hash_entry {
@@ -105,7 +106,10 @@ static int fill_dir_block(ext2_filsys fs,
 		dirent = (struct ext2_dir_entry *) dir;
 		(void) ext2fs_set_rec_len(fs, fs->blocksize, dirent);
 	} else {
-		fd->err = ext2fs_read_dir_block3(fs, *block_nr, dir, 0);
+		fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		fd->err = ext2fs_read_dir_block3(fs, *block_nr, dir, 0,
+						 fd->dir);
+		fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		if (fd->err)
 			return BLOCK_ABORT;
 	}
@@ -396,7 +400,8 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 
 static errcode_t copy_dir_entries(e2fsck_t ctx,
 				  struct fill_dir_struct *fd,
-				  struct out_dir *outdir)
+				  struct out_dir *outdir,
+				  ext2_ino_t ino)
 {
 	ext2_filsys 		fs = ctx->fs;
 	errcode_t		retval;
@@ -407,6 +412,8 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 	int			i, left;
 	ext2_dirhash_t		prev_hash;
 	int			offset, slack;
+	int			csum_size = 0;
+	struct			ext2_dir_entry_tail *t;
 
 	if (ctx->htree_slack_percentage == 255) {
 		profile_get_uint(ctx->profile, "options",
@@ -417,6 +424,10 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 			ctx->htree_slack_percentage = 20;
 	}
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext2_dir_entry_tail);
+
 	outdir->max = 0;
 	retval = alloc_size_dir(fs, outdir,
 				(fd->dir_size / fs->blocksize) + 2);
@@ -431,9 +442,9 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
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
@@ -448,12 +459,20 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 				if (retval)
 					return retval;
 			}
+			if (csum_size) {
+				t = (struct ext2_dir_entry_tail *)
+						(block_start + fs->blocksize -
+						 csum_size);
+				memset(t, 0, csum_size);
+				ext2fs_set_rec_len(fs, csum_size,
+						   (struct ext2_dir_entry *)t);
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
@@ -482,6 +501,12 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 	}
 	if (left)
 		retval = ext2fs_set_rec_len(fs, rec_len + left, dirent);
+	if (csum_size) {
+		t = (struct ext2_dir_entry_tail *)
+				(block_start + fs->blocksize - csum_size);
+		memset(t, 0, csum_size);
+		ext2fs_set_rec_len(fs, csum_size, (struct ext2_dir_entry *)t);
+	}
 
 	return retval;
 }
@@ -602,8 +627,6 @@ static errcode_t calculate_tree(ext2_filsys fs,
 				if (limit) {
 					limit->limit = limit->count =
 		ext2fs_cpu_to_le16(limit->limit);
-					ext2fs_dx_csum_set(fs, ino,
-		(struct ext2_dir_entry *)(((void *)limit) - 8));
 				}
 				root = (struct ext2_dx_entry *)
 					(outdir->buf + root_offset);
@@ -629,14 +652,10 @@ static errcode_t calculate_tree(ext2_filsys fs,
 		}
 		limit->count = ext2fs_cpu_to_le16(limit->limit - c2);
 		limit->limit = ext2fs_cpu_to_le16(limit->limit);
-		ext2fs_dx_csum_set(fs, ino,
-				   (struct ext2_dir_entry *)(((void *)limit) -
-							     8));
 	}
 	root_limit = (struct ext2_dx_countlimit *) (outdir->buf + limit_offset);
 	root_limit->count = ext2fs_cpu_to_le16(root_limit->limit - c1);
 	root_limit->limit = ext2fs_cpu_to_le16(root_limit->limit);
-	ext2fs_dx_csum_set(fs, ino, (struct ext2_dir_entry *)outdir->buf);
 
 	return 0;
 }
@@ -646,6 +665,7 @@ struct write_dir_struct {
 	errcode_t	err;
 	e2fsck_t	ctx;
 	int		cleared;
+	ext2_ino_t	dir;
 };
 
 /*
@@ -677,7 +697,7 @@ static int write_dir_block(ext2_filsys fs,
 		return 0;
 
 	dir = wd->outdir->buf + (blockcnt * fs->blocksize);
-	wd->err = ext2fs_write_dir_block3(fs, *block_nr, dir, 0);
+	wd->err = ext2fs_write_dir_block3(fs, *block_nr, dir, 0, wd->dir);
 	if (wd->err)
 		return BLOCK_ABORT;
 	return 0;
@@ -699,6 +719,7 @@ static errcode_t write_directory(e2fsck_t ctx, ext2_filsys fs,
 	wd.err = 0;
 	wd.ctx = ctx;
 	wd.cleared = 0;
+	wd.dir = ino;
 
 	retval = ext2fs_block_iterate3(fs, ino, 0, 0,
 				       write_dir_block, &wd);
@@ -751,6 +772,7 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino)
 	fd.err = 0;
 	fd.dir_size = 0;
 	fd.compress = 0;
+	fd.dir = ino;
 	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) ||
 	    (inode.i_size / fs->blocksize) < 2)
 		fd.compress = 1;
@@ -810,7 +832,7 @@ resort:
 	 * Copy the directory entries.  In a htree directory these
 	 * will become the leaf nodes.
 	 */
-	retval = copy_dir_entries(ctx, &fd, &outdir);
+	retval = copy_dir_entries(ctx, &fd, &outdir, ino);
 	if (retval)
 		goto errout;
 
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 4963524..a606b7c 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -29,6 +29,126 @@
 #define STATIC static
 #endif
 
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
+	    t->reserved_zero2)
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
+__u32 ext2fs_dirent_csum(ext2_filsys fs, ext2_ino_t inum,
+			 struct ext2_dir_entry *dirent)
+{
+	errcode_t retval;
+	char *buf = (char *)dirent;
+	struct ext2_dir_entry_tail *t;
+	int size;
+	__u32 crc = 0;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	t = get_dirent_tail(fs, dirent);
+	if (!t)
+		return 0;
+
+#ifdef WORDS_BIGENDIAN
+	retval = ext2fs_get_mem(fs->blocksize, &buf);
+	if (retval)
+		return 0;
+	memcpy(buf, dirent, fs->blocksize);
+	retval = ext2fs_dirent_swab_out(fs, buf, 0);
+	if (retval) {
+		crc = 0;
+		goto out;
+	}
+#endif
+
+	size = (void *)t - (void *)dirent;
+	inum = ext2fs_cpu_to_le32(inum);
+	crc = crc32c_le(~0, fs->super->s_uuid, sizeof(fs->super->s_uuid));
+	crc = crc32c_le(crc, (char *)&inum, sizeof(inum));
+	crc = crc32c_le(crc, buf, size);
+
+#ifdef WORDS_BIGENDIAN
+out:
+	ext2fs_free_mem(&buf);
+#endif
+
+	return crc;
+}
+
+int ext2fs_dirent_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+			      struct ext2_dir_entry *dirent)
+{
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
+	if (ext2fs_le32_to_cpu(t->checksum) !=
+	    ext2fs_dirent_csum(fs, inum, dirent))
+		return 0;
+
+	return 1;
+}
+
+void ext2fs_dirent_csum_set(ext2_filsys fs, ext2_ino_t inum,
+			    struct ext2_dir_entry *dirent)
+{
+	struct ext2_dir_entry_tail *t;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	t = get_dirent_tail(fs, dirent);
+	if (!t)
+		return;
+
+	/* swapfs.c functions don't change the checksum endianness */
+	t->checksum = ext2fs_cpu_to_le32(ext2fs_dirent_csum(fs, inum, dirent));
+}
+
 __u32 ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
 		     struct ext2_dir_entry *dirent)
 {
@@ -136,6 +256,45 @@ void ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
 	t->checksum = ext2fs_cpu_to_le32(ext2fs_dx_csum(fs, inum, dirent));
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
+	printf("%s: Not htree or leaf dir block?\n", __func__);
+	abort();
+}
+
+void ext2fs_dir_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
+			       struct ext2_dir_entry *dirent)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	if (get_dirent_tail(fs, dirent)) {
+		ext2fs_dirent_csum_set(fs, inum, dirent);
+		return;
+	}
+
+	if (ext2fs_get_dx_countlimit(fs, dirent, NULL)) {
+		ext2fs_dx_csum_set(fs, inum, dirent);
+		return;
+	}
+
+	if (fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)
+		return;
+	printf("%s: Not htree or leaf dir block?\n", __func__);
+	abort();
+}
+
 #define EXT3_EXTENT_TAIL_OFFSET(hdr)	(sizeof(struct ext3_extent_header) + \
 	(sizeof(struct ext3_extent) * ext2fs_le16_to_cpu((hdr)->eh_max)))
 
diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index 88f6b47..b5a27e2 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -191,17 +191,23 @@ int ext2fs_process_dir_block(ext2_filsys fs,
 	unsigned int	rec_len, size;
 	int		entry;
 	struct ext2_dir_entry *dirent;
+	int		csum_size = 0;
 
 	if (blockcnt < 0)
 		return 0;
 
 	entry = blockcnt ? DIRENT_OTHER_FILE : DIRENT_DOT_FILE;
 
-	ctx->errcode = ext2fs_read_dir_block3(fs, *blocknr, ctx->buf, 0);
+	ctx->errcode = ext2fs_read_dir_block3(fs, *blocknr, ctx->buf, 0,
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
@@ -259,7 +265,7 @@ next:
 
 	if (changed) {
 		ctx->errcode = ext2fs_write_dir_block3(fs, *blocknr, ctx->buf,
-						       0);
+						       0, ctx->dir);
 		if (ctx->errcode)
 			return BLOCK_ABORT;
 	}
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index 73e1f0a..bc7959f 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -20,107 +20,75 @@
 #include "ext2fs.h"
 
 errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
-				 void *buf, int flags EXT2FS_ATTR((unused)))
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
-#ifdef WORDS_BIGENDIAN
-		dirent->inode = ext2fs_swab32(dirent->inode);
-		dirent->rec_len = ext2fs_swab16(dirent->rec_len);
-		dirent->name_len = ext2fs_swab16(dirent->name_len);
-#endif
-		name_len = dirent->name_len;
 #ifdef WORDS_BIGENDIAN
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
+	if (!fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS &&
+	    !ext2fs_dir_block_csum_verify(fs, ino,
+					  (struct ext2_dir_entry *)buf))
+		return EXT2_ET_DIR_CORRUPTED;
 	return retval;
 }
 
 errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
-				 void *buf, int flags EXT2FS_ATTR((unused)))
+				 void *buf, int flags EXT2FS_ATTR((unused)),
+				 ext2_ino_t ino)
 {
-	return ext2fs_read_dir_block3(fs, block, buf, flags);
+	return ext2fs_read_dir_block3(fs, block, buf, flags, ino);
 }
 
 errcode_t ext2fs_read_dir_block(ext2_filsys fs, blk_t block,
-				 void *buf)
+				 void *buf, ext2_ino_t ino)
 {
-	return ext2fs_read_dir_block3(fs, block, buf, 0);
+	return ext2fs_read_dir_block3(fs, block, buf, 0, ino);
 }
 
 
 errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
-				  void *inbuf, int flags EXT2FS_ATTR((unused)))
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
 
+	ext2fs_dir_block_csum_set(fs, ino, (struct ext2_dir_entry *)inbuf);
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
 }
 
 errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
-				 void *inbuf, int flags EXT2FS_ATTR((unused)))
+				 void *inbuf, int flags EXT2FS_ATTR((unused)),
+				 ext2_ino_t ino)
 {
-	return ext2fs_write_dir_block3(fs, block, inbuf, flags);
+	return ext2fs_write_dir_block3(fs, block, inbuf, flags, ino);
 }
 
 errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
-				 void *inbuf)
+				 void *inbuf, ext2_ino_t ino)
 {
-	return ext2fs_write_dir_block3(fs, block, inbuf, 0);
+	return ext2fs_write_dir_block3(fs, block, inbuf, 0, ino);
 }
 
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index ee90970..e7e6e05 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -23,6 +23,7 @@ struct expand_dir_struct {
 	int		newblocks;
 	blk64_t		goal;
 	errcode_t	err;
+	ext2_ino_t	dir;
 };
 
 static int expand_dir_proc(ext2_filsys	fs,
@@ -61,7 +62,7 @@ static int expand_dir_proc(ext2_filsys	fs,
 			return BLOCK_ABORT;
 		}
 		es->done = 1;
-		retval = ext2fs_write_dir_block(fs, new_blk, block);
+		retval = ext2fs_write_dir_block(fs, new_blk, block, es->dir);
 	} else {
 		retval = ext2fs_get_mem(fs->blocksize, &block);
 		if (retval) {
@@ -109,6 +110,7 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 	es.err = 0;
 	es.goal = 0;
 	es.newblocks = 0;
+	es.dir = dir;
 
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 64adff9..1c27249 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -716,6 +716,17 @@ struct ext2_dir_entry_2 {
 };
 
 /*
+ * This is a bogus directory entry at the end of each leaf block that
+ * records checksums.
+ */
+struct ext2_dir_entry_tail {
+	__u32	reserved_zero1;		/* Pretend to be unused */
+	__u16	rec_len;
+	__u16	reserved_zero2;		/* Zero name length */
+	__u32	checksum;		/* crc32c(uuid+inode+dirent) */
+};
+
+/*
  * Ext2 directory file types.  Only the low 3 bits are used.  The
  * other bits are reserved for now.
  */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7110f72..706357a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -894,6 +894,18 @@ extern __u32 crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern int ext2fs_dirent_has_tail(ext2_filsys fs,
+				  struct ext2_dir_entry *dirent);
+extern int ext2fs_dir_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				     struct ext2_dir_entry *dirent);
+extern void ext2fs_dir_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				   struct ext2_dir_entry *dirent);
+extern __u32 ext2fs_dirent_csum(ext2_filsys fs, ext2_ino_t inum,
+				struct ext2_dir_entry *dirent);
+extern int ext2fs_dirent_csum_verify(ext2_filsys fs, ext2_ino_t inum,
+				     struct ext2_dir_entry *dirent);
+extern void ext2fs_dirent_csum_set(ext2_filsys fs, ext2_ino_t inum,
+				   struct ext2_dir_entry *dirent);
 extern __u32 ext2fs_dx_csum(ext2_filsys fs, ext2_ino_t inum,
 			    struct ext2_dir_entry *dirent);
 extern int ext2fs_dx_csum_verify(ext2_filsys fs, ext2_ino_t inum,
@@ -976,17 +988,17 @@ extern errcode_t
 
 /* dirblock.c */
 extern errcode_t ext2fs_read_dir_block(ext2_filsys fs, blk_t block,
-				       void *buf);
+				       void *buf, ext2_ino_t ino);
 extern errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
-					void *buf, int flags);
+					void *buf, int flags, ext2_ino_t ino);
 extern errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
-					void *buf, int flags);
+					void *buf, int flags, ext2_ino_t ino);
 extern errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
-					void *buf);
+					void *buf, ext2_ino_t ino);
 extern errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
-					 void *buf, int flags);
+					 void *buf, int flags, ext2_ino_t ino);
 extern errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
-					 void *buf, int flags);
+					 void *buf, int flags, ext2_ino_t ino);
 
 /* dirhash.c */
 extern struct ext2_dx_countlimit *ext2fs_get_dx_countlimit(ext2_filsys fs,
@@ -1368,6 +1380,8 @@ extern errcode_t ext2fs_read_bb_FILE(ext2_filsys fs, FILE *f,
 extern errcode_t ext2fs_create_resize_inode(ext2_filsys fs);
 
 /* swapfs.c */
+extern errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags);
+extern errcode_t ext2fs_dirent_swab_out(ext2_filsys fs, char *buf, int flags);
 extern void ext2fs_swap_ext_attr(char *to, char *from, int bufsize,
 				 int has_header);
 extern void ext2fs_swap_ext_attr_header(struct ext2_ext_attr_header *to_header,
diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index a32ec03..c4d66b0 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -40,6 +40,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	struct ext2_dir_entry *next;
 	unsigned int rec_len, min_rec_len, curr_rec_len;
 	int ret = 0;
+	int csum_size = 0;
 
 	rec_len = EXT2_DIR_REC_LEN(ls->namelen);
 
@@ -47,12 +48,15 @@ static int link_proc(struct ext2_dir_entry *dirent,
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
index 08a0bd6..5fa6274 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -94,7 +94,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Write out the inode and inode data block
 	 */
-	retval = ext2fs_write_dir_block(fs, blk, block);
+	retval = ext2fs_write_dir_block(fs, blk, block, ino);
 	if (retval)
 		goto cleanup;
 	retval = ext2fs_write_new_inode(fs, ino, &inode);
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index 6bc5719..d1ccf9a 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -33,6 +33,8 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 	char			*buf;
 	int			rec_len;
 	int			filetype = 0;
+	struct ext2_dir_entry_tail	*t;
+	int			csum_size = 0;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -42,7 +44,11 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
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
 
@@ -56,7 +62,7 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 		dir->inode = dir_ino;
 		dir->name_len = 1 | filetype;
 		dir->name[0] = '.';
-		rec_len = fs->blocksize - EXT2_DIR_REC_LEN(1);
+		rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
 		dir->rec_len = EXT2_DIR_REC_LEN(1);
 
 		/*
@@ -72,6 +78,13 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 		dir->name[1] = '.';
 
 	}
+
+	if (csum_size) {
+		t = (struct ext2_dir_entry_tail *)
+				(buf + fs->blocksize - csum_size);
+		memset(t, 0, csum_size);
+		ext2fs_set_rec_len(fs, csum_size, (struct ext2_dir_entry *)t);
+	}
 	*block = buf;
 	return 0;
 }
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index f657c47..570ab7d 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -320,4 +320,66 @@ void ext2fs_swap_inode(ext2_filsys fs, struct ext2_inode_large *t,
 				sizeof(struct ext2_inode_large));
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

