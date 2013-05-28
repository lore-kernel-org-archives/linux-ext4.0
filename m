From: Jan Kara <jack@suse.cz>
Subject: [PATCH RESEND] libext2fs: Provide functions to safely access name_len and file_type
Date: Tue, 28 May 2013 22:45:35 +0200
Message-ID: <1369773935-16889-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339Ab3E1Upn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 16:45:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Accessing name_len (and file_type) in ext4_dir_entry structure is somewhat
problematic because on big endian architecture we need to now whether we
are really dealing with ext4_dir_entry (which has u16 name_len which
needs byte swapping) or ext4_dir_entry_2 (which has u8 name_len which
must not be byte swapped).

Currently the code is somewhat surprising and name_len is always treated
as u16 and byte swapped (flag EXT2_DIRBLOCK_V2_STRUCT isn't ever used)
and then masking of name_len is used to access real name_len or
file_type. Doing things this way in applications using libext2fs is
unexpected to say the least (more natural is to type struct
ext4_dir_entry * to struct ext4_dir_entry_2 * but that gives wrong
results on big endian architectures. So provide helper functions that
give endian-safe access to these fields. Also convert users in e2fsprogs
to use these functions.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 I didn't get any reply last time so I'm resending the patch. Ted?

 debugfs/debugfs.c         |  4 +--
 debugfs/dump.c            |  2 +-
 debugfs/filefrag.c        |  2 +-
 debugfs/htree.c           |  6 ++--
 debugfs/ls.c              |  5 +--
 debugfs/ncheck.c          |  8 +++--
 e2fsck/message.c          |  6 ++--
 e2fsck/pass1.c            |  4 +--
 e2fsck/pass2.c            | 48 +++++++++++++++-------------
 e2fsck/pass3.c            |  7 ++---
 e2fsck/rehash.c           | 80 ++++++++++++++++++++++++++---------------------
 lib/ext2fs/dir_iterate.c  |  6 ++--
 lib/ext2fs/ext2_fs.h      |  8 +++++
 lib/ext2fs/ext2fs.h       | 20 ++++++++++++
 lib/ext2fs/get_pathname.c | 11 +++----
 lib/ext2fs/link.c         |  9 +++---
 lib/ext2fs/lookup.c       |  4 +--
 lib/ext2fs/newdir.c       |  8 +++--
 lib/ext2fs/unlink.c       |  4 +--
 misc/tune2fs.c            |  2 +-
 resize/resize2fs.c        |  2 +-
 21 files changed, 145 insertions(+), 101 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 969dbe0..dcf16e2 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1911,9 +1911,9 @@ static int rmdir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 
 	if (dirent->inode == 0)
 		return 0;
-	if (((dirent->name_len&0xFF) == 1) && (dirent->name[0] == '.'))
+	if ((ext2fs_dirent_name_len(dirent) == 1) && (dirent->name[0] == '.'))
 		return 0;
-	if (((dirent->name_len&0xFF) == 2) && (dirent->name[0] == '.') &&
+	if ((ext2fs_dirent_name_len(dirent) == 2) && (dirent->name[0] == '.') &&
 	    (dirent->name[1] == '.')) {
 		rds->parent = dirent->inode;
 		return 0;
diff --git a/debugfs/dump.c b/debugfs/dump.c
index 9409ab6..c75b9f1 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -308,7 +308,7 @@ static int rdump_dirent(struct ext2_dir_entry *dirent,
 	const char *dumproot = private;
 	struct ext2_inode inode;
 
-	thislen = dirent->name_len & 0xFF;
+	thislen = ext2fs_dirent_name_len(dirent);
 	strncpy(name, dirent->name, thislen);
 	name[thislen] = 0;
 
diff --git a/debugfs/filefrag.c b/debugfs/filefrag.c
index 7f28bc0..e82d133 100644
--- a/debugfs/filefrag.c
+++ b/debugfs/filefrag.c
@@ -183,7 +183,7 @@ static int filefrag_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	if (entry == DIRENT_DELETED_FILE)
 		return 0;
 
-	thislen = dirent->name_len & 0xFF;
+	thislen = ext2fs_dirent_name_len(dirent);
 	strncpy(name, dirent->name, thislen);
 	name[thislen] = '\0';
 	ino = dirent->inode;
diff --git a/debugfs/htree.c b/debugfs/htree.c
index d94dbea..4f0118d 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -79,15 +79,15 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 				(unsigned long) blk);
 			return;
 		}
+		thislen = ext2fs_dirent_name_len(dirent);
 		if (((offset + rec_len) > fs->blocksize) ||
 		    (rec_len < 8) ||
 		    ((rec_len % 4) != 0) ||
-		    ((((unsigned) dirent->name_len & 0xFF)+8) > rec_len)) {
+		    (thislen + 8 > rec_len)) {
 			fprintf(pager, "Corrupted directory block (%llu)!\n",
 				blk);
 			break;
 		}
-		thislen = dirent->name_len & 0xFF;
 		strncpy(name, dirent->name, thislen);
 		name[thislen] = '\0';
 		errcode = ext2fs_dirhash(hash_alg, name,
@@ -428,7 +428,7 @@ static int search_dir_block(ext2_filsys fs, blk64_t *blocknr,
 			return BLOCK_ABORT;
 		}
 		if (dirent->inode &&
-		    p->len == (dirent->name_len & 0xFF) &&
+		    p->len == ext2fs_dirent_name_len(dirent) &&
 		    strncmp(p->search_name, dirent->name,
 			    p->len) == 0) {
 			printf("Entry found at logical block %lld, "
diff --git a/debugfs/ls.c b/debugfs/ls.c
index 032d12d..69c7897 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -61,7 +61,7 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	struct list_dir_struct *ls = (struct list_dir_struct *) private;
 	struct ext2_dir_entry_tail *t = (struct ext2_dir_entry_tail *) dirent;
 
-	thislen = dirent->name_len & 0xFF;
+	thislen = ext2fs_dirent_name_len(dirent);
 	strncpy(name, dirent->name, thislen);
 	name[thislen] = '\0';
 	ino = dirent->inode;
@@ -105,7 +105,8 @@ static int list_dir_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 				t->det_checksum);
 			return 0;
 		}
-		fprintf(ls->f, "(%d)  %5d  %5d   ", dirent->name_len >> 8,
+		fprintf(ls->f, "(%d)  %5d  %5d   ",
+			ext2fs_dirent_file_type(dirent),
 			inode_uid(inode), inode_gid(inode));
 		if (LINUX_S_ISDIR(inode.i_mode))
 			fprintf(ls->f, "%5d", inode.i_size);
diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 58f3a50..5d9b5d2 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -45,7 +45,7 @@ static int ncheck_proc(struct ext2_dir_entry *dirent,
 	struct inode_walk_struct *iw = (struct inode_walk_struct *) private;
 	struct ext2_inode inode;
 	errcode_t	retval;
-	int		filetype = dirent->name_len >> 8;
+	int		filetype = ext2fs_dirent_file_type(dirent);
 	int		i;
 
 	iw->position++;
@@ -66,11 +66,13 @@ static int ncheck_proc(struct ext2_dir_entry *dirent,
 			if (iw->parent)
 				printf("%u\t%s/%.*s", iw->iarray[i],
 				       iw->parent,
-				       (dirent->name_len & 0xFF), dirent->name);
+				       ext2fs_dirent_name_len(dirent),
+				       dirent->name);
 			else
 				printf("%u\t<%u>/%.*s", iw->iarray[i],
 				       iw->dir,
-				       (dirent->name_len & 0xFF), dirent->name);
+				       ext2fs_dirent_name_len(dirent),
+				       dirent->name);
 			if (iw->check_dirent && filetype) {
 				if (!debugfs_read_inode(dirent->inode, &inode,
 							"ncheck") &&
diff --git a/e2fsck/message.c b/e2fsck/message.c
index b99473d..72a56ca 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -373,7 +373,7 @@ static _INLINE_ void expand_dirent_expression(FILE *f, ext2_filsys fs, char ch,
 		fprintf(f, "%u", dirent->inode);
 		break;
 	case 'n':
-		len = dirent->name_len & 0xFF;
+		len = ext2fs_dirent_name_len(dirent);
 		if ((ext2fs_get_rec_len(fs, dirent, &rec_len) == 0) &&
 		    (len > rec_len))
 			len = rec_len;
@@ -384,10 +384,10 @@ static _INLINE_ void expand_dirent_expression(FILE *f, ext2_filsys fs, char ch,
 		fprintf(f, "%u", rec_len);
 		break;
 	case 'l':
-		fprintf(f, "%u", dirent->name_len & 0xFF);
+		fprintf(f, "%u", ext2fs_dirent_name_len(dirent));
 		break;
 	case 't':
-		fprintf(f, "%u", dirent->name_len >> 8);
+		fprintf(f, "%u", ext2fs_dirent_file_type(dirent));
 		break;
 	default:
 	no_dirent:
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 1b410be..df9457e 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -482,7 +482,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	retval = ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
 	if (retval)
 		return;
-	if (((dirent->name_len & 0xFF) != 1) ||
+	if ((ext2fs_dirent_name_len(dirent) != 1) ||
 	    (dirent->name[0] != '.') ||
 	    (dirent->inode != pctx->ino) ||
 	    (rec_len < 12) ||
@@ -494,7 +494,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	retval = ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
 	if (retval)
 		return;
-	if (((dirent->name_len & 0xFF) != 2) ||
+	if ((ext2fs_dirent_name_len(dirent) != 2) ||
 	    (dirent->name[0] != '.') ||
 	    (dirent->name[1] != '.') ||
 	    (rec_len < 12) ||
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 257589c..85ce982 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -302,9 +302,9 @@ static int dict_de_cmp(const void *a, const void *b)
 	int	a_len, b_len;
 
 	de_a = (const struct ext2_dir_entry *) a;
-	a_len = de_a->name_len & 0xFF;
+	a_len = ext2fs_dirent_name_len(de_a);
 	de_b = (const struct ext2_dir_entry *) b;
-	b_len = de_b->name_len & 0xFF;
+	b_len = ext2fs_dirent_name_len(de_b);
 
 	if (a_len != b_len)
 		return (a_len - b_len);
@@ -357,7 +357,7 @@ static int check_dot(e2fsck_t ctx,
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT;
-	else if (((dirent->name_len & 0xFF) != 1) ||
+	else if ((ext2fs_dirent_name_len(dirent) != 1) ||
 		 (dirent->name[0] != '.'))
 		problem = PR_2_1ST_NOT_DOT;
 	else if (dirent->name[1] != '\0')
@@ -369,7 +369,8 @@ static int check_dot(e2fsck_t ctx,
 			if (rec_len < 12)
 				rec_len = dirent->rec_len = 12;
 			dirent->inode = ino;
-			dirent->name_len = 1;
+			ext2fs_dirent_set_name_len(dirent, 1);
+			ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
 			dirent->name[0] = '.';
 			dirent->name[1] = '\0';
 			status = 1;
@@ -393,7 +394,9 @@ static int check_dot(e2fsck_t ctx,
 				(void) ext2fs_set_rec_len(ctx->fs, new_len,
 							  nextdir);
 				nextdir->inode = 0;
-				nextdir->name_len = 0;
+				ext2fs_dirent_set_name_len(nextdir, 0);
+				ext2fs_dirent_set_file_type(nextdir,
+							    EXT2_FT_UNKNOWN);
 				status = 1;
 			}
 		}
@@ -415,7 +418,7 @@ static int check_dotdot(e2fsck_t ctx,
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT_DOT;
-	else if (((dirent->name_len & 0xFF) != 2) ||
+	else if ((ext2fs_dirent_name_len(dirent) != 2) ||
 		 (dirent->name[0] != '.') ||
 		 (dirent->name[1] != '.'))
 		problem = PR_2_2ND_NOT_DOT_DOT;
@@ -433,7 +436,8 @@ static int check_dotdot(e2fsck_t ctx,
 			 * inode.  This will get fixed in pass 3.
 			 */
 			dirent->inode = EXT2_ROOT_INO;
-			dirent->name_len = 2;
+			ext2fs_dirent_set_name_len(dirent, 2);
+			ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
 			dirent->name[0] = '.';
 			dirent->name[1] = '.';
 			dirent->name[2] = '\0';
@@ -461,7 +465,7 @@ static int check_name(e2fsck_t ctx,
 	int	fixup = -1;
 	int	ret = 0;
 
-	for ( i = 0; i < (dirent->name_len & 0xFF); i++) {
+	for ( i = 0; i < ext2fs_dirent_name_len(dirent); i++) {
 		if (dirent->name[i] == '/' || dirent->name[i] == '\0') {
 			if (fixup < 0) {
 				fixup = fix_problem(ctx, PR_2_BAD_NAME, pctx);
@@ -483,7 +487,7 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 				   ext2_ino_t dir_ino EXT2FS_ATTR((unused)),
 				   struct problem_context *pctx)
 {
-	int	filetype = dirent->name_len >> 8;
+	int	filetype = ext2fs_dirent_file_type(dirent);
 	int	should_be = EXT2_FT_UNKNOWN;
 	struct ext2_inode	inode;
 
@@ -492,7 +496,7 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 		if (filetype == 0 ||
 		    !fix_problem(ctx, PR_2_CLEAR_FILETYPE, pctx))
 			return 0;
-		dirent->name_len = dirent->name_len & 0xFF;
+		ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
 		return 1;
 	}
 
@@ -518,7 +522,7 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 			pctx) == 0)
 		return 0;
 
-	dirent->name_len = (dirent->name_len & 0xFF) | should_be << 8;
+	ext2fs_dirent_set_file_type(dirent, should_be);
 	return 1;
 }
 
@@ -666,7 +670,7 @@ static void salvage_directory(ext2_filsys fs,
 	char	*cp = (char *) dirent;
 	int left;
 	unsigned int rec_len, prev_rec_len;
-	unsigned int name_len = dirent->name_len & 0xFF;
+	unsigned int name_len = ext2fs_dirent_name_len(dirent);
 
 	(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 	left = fs->blocksize - *offset - rec_len;
@@ -720,7 +724,8 @@ static void salvage_directory(ext2_filsys fs,
 	} else {
 		rec_len = fs->blocksize - *offset;
 		(void) ext2fs_set_rec_len(fs, rec_len, dirent);
-		dirent->name_len = 0;
+		ext2fs_dirent_set_name_len(dirent, 0);
+		ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
 		dirent->inode = 0;
 	}
 }
@@ -868,7 +873,7 @@ static int check_dir_block(ext2_filsys fs,
 			dx_dir->depth = root->indirect_levels + 1;
 		} else if ((dirent->inode == 0) &&
 			   (rec_len == fs->blocksize) &&
-			   (dirent->name_len == 0) &&
+			   (ext2fs_dirent_name_len(dirent) == 0) &&
 			   (ext2fs_le16_to_cpu(limit->limit) ==
 			    ((fs->blocksize - (8 + dx_csum_size)) /
 			     sizeof(struct ext2_dx_entry))))
@@ -915,6 +920,7 @@ skip_checksum:
 	do {
 		int group;
 		ext2_ino_t first_unused_inode;
+		unsigned int name_len;
 
 		problem = 0;
 		dirent = (struct ext2_dir_entry *) (buf + offset);
@@ -924,7 +930,7 @@ skip_checksum:
 		if (((offset + rec_len) > fs->blocksize) ||
 		    (rec_len < 12) ||
 		    ((rec_len % 4) != 0) ||
-		    (((dirent->name_len & (unsigned) 0xFF)+8) > rec_len)) {
+		    ((ext2fs_dirent_name_len(dirent) + 8) > rec_len)) {
 			if (fix_problem(ctx, PR_2_DIR_CORRUPTED, &cd->pctx)) {
 				salvage_directory(fs, dirent, prev, &offset);
 				dir_modified++;
@@ -956,6 +962,7 @@ skip_checksum:
 		/*
 		 * Make sure the inode listed is a legal one.
 		 */
+		name_len = ext2fs_dirent_name_len(dirent);
 		if (((dirent->inode != EXT2_ROOT_INO) &&
 		     (dirent->inode < EXT2_FIRST_INODE(fs->super))) ||
 		    (dirent->inode > fs->super->s_inodes_count)) {
@@ -968,8 +975,7 @@ skip_checksum:
 			 * clear it.
 			 */
 			problem = PR_2_BB_INODE;
-		} else if ((dot_state > 1) &&
-			   ((dirent->name_len & 0xFF) == 1) &&
+		} else if ((dot_state > 1) && (name_len == 1) &&
 			   (dirent->name[0] == '.')) {
 			/*
 			 * If there's a '.' entry in anything other
@@ -977,8 +983,7 @@ skip_checksum:
 			 * duplicate entry that should be removed.
 			 */
 			problem = PR_2_DUP_DOT;
-		} else if ((dot_state > 1) &&
-			   ((dirent->name_len & 0xFF) == 2) &&
+		} else if ((dot_state > 1) && (name_len == 2) &&
 			   (dirent->name[0] == '.') &&
 			   (dirent->name[1] == '.')) {
 			/*
@@ -996,8 +1001,7 @@ skip_checksum:
 			 * directory hasn't been created yet.
 			 */
 			problem = PR_2_LINK_ROOT;
-		} else if ((dot_state > 1) &&
-			   (dirent->name_len & 0xFF) == 0) {
+		} else if ((dot_state > 1) && (name_len == 0)) {
 			/*
 			 * Don't allow zero-length directory names.
 			 */
@@ -1110,7 +1114,7 @@ skip_checksum:
 #ifdef ENABLE_HTREE
 		if (dx_db) {
 			ext2fs_dirhash(dx_dir->hashversion, dirent->name,
-				       (dirent->name_len & 0xFF),
+				       ext2fs_dirent_name_len(dirent),
 				       fs->super->s_hash_seed, &hash, 0);
 			if (hash < dx_db->min_hash)
 				dx_db->min_hash = hash;
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index a379e9b..193ec1c 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -612,7 +612,7 @@ static int fix_dotdot_proc(struct ext2_dir_entry *dirent,
 	errcode_t	retval;
 	struct problem_context pctx;
 
-	if ((dirent->name_len & 0xFF) != 2)
+	if (ext2fs_dirent_name_len(dirent) != 2)
 		return 0;
 	if (strncmp(dirent->name, "..", 2))
 		return 0;
@@ -632,10 +632,9 @@ static int fix_dotdot_proc(struct ext2_dir_entry *dirent,
 	dirent->inode = fp->parent;
 	if (fp->ctx->fs->super->s_feature_incompat &
 	    EXT2_FEATURE_INCOMPAT_FILETYPE)
-		dirent->name_len = (dirent->name_len & 0xFF) |
-			(EXT2_FT_DIR << 8);
+		ext2fs_dirent_set_file_type(dirent, EXT2_FT_DIR);
 	else
-		dirent->name_len = dirent->name_len & 0xFF;
+		ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
 
 	fp->done++;
 	return DIRENT_ABORT | DIRENT_CHANGED;
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 5592e3f..c1c74c8 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -109,7 +109,7 @@ static int fill_dir_block(ext2_filsys fs,
 	struct hash_entry 	*new_array, *ent;
 	struct ext2_dir_entry 	*dirent;
 	char			*dir;
-	unsigned int		offset, dir_offset, rec_len;
+	unsigned int		offset, dir_offset, rec_len, name_len;
 	int			hash_alg;
 
 	if (blockcnt < 0)
@@ -142,20 +142,21 @@ static int fill_dir_block(ext2_filsys fs,
 	while (dir_offset < fs->blocksize) {
 		dirent = (struct ext2_dir_entry *) (dir + dir_offset);
 		(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
+		name_len = ext2fs_dirent_name_len(dirent);
 		if (((dir_offset + rec_len) > fs->blocksize) ||
 		    (rec_len < 8) ||
 		    ((rec_len % 4) != 0) ||
-		    (((dirent->name_len & 0xFF)+8U) > rec_len)) {
+		    (name_len + 8 > rec_len)) {
 			fd->err = EXT2_ET_DIR_CORRUPTED;
 			return BLOCK_ABORT;
 		}
 		dir_offset += rec_len;
 		if (dirent->inode == 0)
 			continue;
-		if (!fd->compress && ((dirent->name_len&0xFF) == 1) &&
+		if (!fd->compress && (name_len == 1) &&
 		    (dirent->name[0] == '.'))
 			continue;
-		if (!fd->compress && ((dirent->name_len&0xFF) == 2) &&
+		if (!fd->compress && (name_len == 2) &&
 		    (dirent->name[0] == '.') && (dirent->name[1] == '.')) {
 			fd->parent = dirent->inode;
 			continue;
@@ -172,13 +173,13 @@ static int fill_dir_block(ext2_filsys fs,
 		}
 		ent = fd->harray + fd->num_array++;
 		ent->dir = dirent;
-		fd->dir_size += EXT2_DIR_REC_LEN(dirent->name_len & 0xFF);
+		fd->dir_size += EXT2_DIR_REC_LEN(name_len);
 		ent->ino = dirent->inode;
 		if (fd->compress)
 			ent->hash = ent->minor_hash = 0;
 		else {
 			fd->err = ext2fs_dirhash(hash_alg, dirent->name,
-						 dirent->name_len & 0xFF,
+						 name_len,
 						 fs->super->s_hash_seed,
 						 &ent->hash, &ent->minor_hash);
 			if (fd->err)
@@ -203,18 +204,21 @@ static EXT2_QSORT_TYPE name_cmp(const void *a, const void *b)
 {
 	const struct hash_entry *he_a = (const struct hash_entry *) a;
 	const struct hash_entry *he_b = (const struct hash_entry *) b;
+	unsigned int he_a_len, he_b_len;
 	int	ret;
 	int	min_len;
 
-	min_len = he_a->dir->name_len;
-	if (min_len > he_b->dir->name_len)
-		min_len = he_b->dir->name_len;
+	he_a_len = ext2fs_dirent_name_len(he_a->dir);
+	he_b_len = ext2fs_dirent_name_len(he_b->dir);
+	min_len = he_a_len;
+	if (min_len > he_b_len)
+		min_len = he_b_len;
 
 	ret = strncmp(he_a->dir->name, he_b->dir->name, min_len);
 	if (ret == 0) {
-		if (he_a->dir->name_len > he_b->dir->name_len)
+		if (he_a_len > he_b_len)
 			ret = 1;
-		else if (he_a->dir->name_len < he_b->dir->name_len)
+		else if (he_a_len < he_b_len)
 			ret = -1;
 		else
 			ret = he_b->dir->inode - he_a->dir->inode;
@@ -297,10 +301,10 @@ static errcode_t get_next_block(ext2_filsys fs, struct out_dir *outdir,
  * expand the length of the filename beyond the padding available in
  * the directory entry.
  */
-static void mutate_name(char *str, __u16 *len)
+static void mutate_name(char *str, unsigned int *len)
 {
 	int	i;
-	__u16	l = *len & 0xFF, h = *len & 0xff00;
+	unsigned int l = *len;
 
 	/*
 	 * First check to see if it looks the name has been mutated
@@ -317,7 +321,7 @@ static void mutate_name(char *str, __u16 *len)
 			l = (l+3) & ~3;
 		str[l-2] = '~';
 		str[l-1] = '0';
-		*len = l | h;
+		*len = l;
 		return;
 	}
 	for (i = l-1; i >= 0; i--) {
@@ -360,7 +364,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 	int			i, j;
 	int			fixed = 0;
 	char			new_name[256];
-	__u16			new_len;
+	unsigned int		new_len;
 	int			hash_alg;
 
 	clear_problem_context(&pctx);
@@ -375,10 +379,10 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 		ent = fd->harray + i;
 		prev = ent - 1;
 		if (!ent->dir->inode ||
-		    ((ent->dir->name_len & 0xFF) !=
-		     (prev->dir->name_len & 0xFF)) ||
-		    (strncmp(ent->dir->name, prev->dir->name,
-			     ent->dir->name_len & 0xFF)))
+		    (ext2fs_dirent_name_len(ent->dir) !=
+		     ext2fs_dirent_name_len(prev->dir)) ||
+		    strncmp(ent->dir->name, prev->dir->name,
+			     ext2fs_dirent_name_len(ent->dir)))
 			continue;
 		pctx.dirent = ent->dir;
 		if ((ent->dir->inode == prev->dir->inode) &&
@@ -388,27 +392,25 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 			fixed++;
 			continue;
 		}
-		memcpy(new_name, ent->dir->name, ent->dir->name_len & 0xFF);
-		new_len = ent->dir->name_len;
+		new_len = ext2fs_dirent_name_len(ent->dir);
+		memcpy(new_name, ent->dir->name, new_len);
 		mutate_name(new_name, &new_len);
 		for (j=0; j < fd->num_array; j++) {
 			if ((i==j) ||
-			    ((new_len & 0xFF) !=
-			     (fd->harray[j].dir->name_len & 0xFF)) ||
-			    (strncmp(new_name, fd->harray[j].dir->name,
-				     new_len & 0xFF)))
+			    (new_len !=
+			     ext2fs_dirent_name_len(fd->harray[j].dir)) ||
+			    strncmp(new_name, fd->harray[j].dir->name, new_len))
 				continue;
 			mutate_name(new_name, &new_len);
 
 			j = -1;
 		}
-		new_name[new_len & 0xFF] = 0;
+		new_name[new_len] = 0;
 		pctx.str = new_name;
 		if (fix_problem(ctx, PR_2_NON_UNIQUE_FILE, &pctx)) {
-			memcpy(ent->dir->name, new_name, new_len & 0xFF);
-			ent->dir->name_len = new_len;
-			ext2fs_dirhash(hash_alg, ent->dir->name,
-				       ent->dir->name_len & 0xFF,
+			memcpy(ent->dir->name, new_name, new_len);
+			ext2fs_dirent_set_name_len(ent->dir, new_len);
+			ext2fs_dirhash(hash_alg, ent->dir->name, new_len,
 				       fs->super->s_hash_seed,
 				       &ent->hash, &ent->minor_hash);
 			fixed++;
@@ -469,7 +471,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		ent = fd->harray + i;
 		if (ent->dir->inode == 0)
 			continue;
-		rec_len = EXT2_DIR_REC_LEN(ent->dir->name_len & 0xFF);
+		rec_len = EXT2_DIR_REC_LEN(ext2fs_dirent_name_len(ent->dir));
 		if (rec_len > left) {
 			if (left) {
 				left += prev_rec_len;
@@ -496,12 +498,16 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 				outdir->hashes[outdir->num-1] = ent->hash;
 		}
 		dirent->inode = ent->dir->inode;
-		dirent->name_len = ent->dir->name_len;
+		ext2fs_dirent_set_name_len(dirent,
+					   ext2fs_dirent_name_len(ent->dir));
+		ext2fs_dirent_set_file_type(dirent,
+					    ext2fs_dirent_file_type(ent->dir));
 		retval = ext2fs_set_rec_len(fs, rec_len, dirent);
 		if (retval)
 			return retval;
 		prev_rec_len = rec_len;
-		memcpy(dirent->name, ent->dir->name, dirent->name_len & 0xFF);
+		memcpy(dirent->name, ent->dir->name,
+		       ext2fs_dirent_name_len(dirent));
 		offset += rec_len;
 		left -= rec_len;
 		if (left < slack) {
@@ -535,19 +541,21 @@ static struct ext2_dx_root_info *set_root_node(ext2_filsys fs, char *buf,
 	int				csum_size = 0;
 
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_FILETYPE)
-		filetype = EXT2_FT_DIR << 8;
+		filetype = EXT2_FT_DIR;
 
 	memset(buf, 0, fs->blocksize);
 	dir = (struct ext2_dir_entry *) buf;
 	dir->inode = ino;
 	dir->name[0] = '.';
-	dir->name_len = 1 | filetype;
+	ext2fs_dirent_set_name_len(dir, 1);
+	ext2fs_dirent_set_file_type(dir, filetype);
 	dir->rec_len = 12;
 	dir = (struct ext2_dir_entry *) (buf + 12);
 	dir->inode = parent;
 	dir->name[0] = '.';
 	dir->name[1] = '.';
-	dir->name_len = 2 | filetype;
+	ext2fs_dirent_set_name_len(dir, 2);
+	ext2fs_dirent_set_file_type(dir, filetype);
 	dir->rec_len = fs->blocksize - 12;
 
 	root = (struct ext2_dx_root_info *) (buf+24);
diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index 1a4bf5c..8be0ac2 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -83,7 +83,7 @@ static int ext2fs_validate_entry(ext2_filsys fs, char *buf,
 		offset += rec_len;
 		if ((rec_len < 8) ||
 		    ((rec_len % 4) != 0) ||
-		    ((((unsigned) dirent->name_len & 0xFF)+8) > rec_len))
+		    ((ext2fs_dirent_name_len(dirent)+8) > rec_len))
 			return 0;
 	}
 	return (offset == final_offset);
@@ -215,7 +215,7 @@ int ext2fs_process_dir_block(ext2_filsys fs,
 		if (((offset + rec_len) > fs->blocksize) ||
 		    (rec_len < 8) ||
 		    ((rec_len % 4) != 0) ||
-		    ((((unsigned) dirent->name_len & 0xFF)+8) > rec_len)) {
+		    ((ext2fs_dirent_name_len(dirent)+8) > rec_len)) {
 			ctx->errcode = EXT2_ET_DIR_CORRUPTED;
 			return BLOCK_ABORT;
 		}
@@ -253,7 +253,7 @@ next:
 			next_real_entry += rec_len;
 
  		if (ctx->flags & DIRENT_FLAG_INCLUDE_REMOVED) {
-			size = ((dirent->name_len & 0xFF) + 11) & ~3;
+			size = (ext2fs_dirent_name_len(dirent) + 11) & ~3;
 
 			if (rec_len != size)  {
 				unsigned int final_offset;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0c0bbcb..6a28d55 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -803,6 +803,14 @@ struct ext2_dir_entry {
  * stored in intel byte order, and the name_len field could never be
  * bigger than 255 chars, it's safe to reclaim the extra byte for the
  * file_type field.
+ *
+ * This structure is deprecated due to endianity issues. Please use struct
+ * ext2_dir_entry and accessor functions
+ *   ext2fs_dirent_name_len
+ *   ext2fs_dirent_set_name_len
+ *   ext2fs_dirent_file_type
+ *   ext2fs_dirent_set_file_type
+ * to get and set name_len and file_type fields.
  */
 struct ext2_dir_entry_2 {
 	__u32	inode;			/* Inode number */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 6923f34..48bc8bb 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1805,6 +1805,26 @@ _INLINE_ __u64 ext2fs_div64_ceil(__u64 a, __u64 b)
 	return ((a - 1) / b) + 1;
 }
 
+_INLINE_ int ext2fs_dirent_name_len(const struct ext2_dir_entry *entry)
+{
+	return entry->name_len & 0xff;
+}
+
+_INLINE_ void ext2fs_dirent_set_name_len(struct ext2_dir_entry *entry, int len)
+{
+	entry->name_len = (entry->name_len & 0xff00) | (len & 0xff);
+}
+
+_INLINE_ int ext2fs_dirent_file_type(const struct ext2_dir_entry *entry)
+{
+	return entry->name_len >> 8;
+}
+
+_INLINE_ void ext2fs_dirent_set_file_type(struct ext2_dir_entry *entry, int type)
+{
+	entry->name_len = (entry->name_len & 0xff) | (type << 8);
+}
+
 #undef _INLINE_
 #endif
 
diff --git a/lib/ext2fs/get_pathname.c b/lib/ext2fs/get_pathname.c
index 52aea62..4c9c765 100644
--- a/lib/ext2fs/get_pathname.c
+++ b/lib/ext2fs/get_pathname.c
@@ -49,21 +49,20 @@ static int get_pathname_proc(struct ext2_dir_entry *dirent,
 {
 	struct get_pathname_struct	*gp;
 	errcode_t			retval;
+	int name_len = ext2fs_dirent_name_len(dirent);
 
 	gp = (struct get_pathname_struct *) priv_data;
 
-	if (((dirent->name_len & 0xFF) == 2) &&
-	    !strncmp(dirent->name, "..", 2))
+	if ((name_len == 2) && !strncmp(dirent->name, "..", 2))
 		gp->parent = dirent->inode;
 	if (dirent->inode == gp->search_ino) {
-		retval = ext2fs_get_mem((dirent->name_len & 0xFF) + 1,
-					&gp->name);
+		retval = ext2fs_get_mem(name_len + 1, &gp->name);
 		if (retval) {
 			gp->errcode = retval;
 			return DIRENT_ABORT;
 		}
-		strncpy(gp->name, dirent->name, (dirent->name_len & 0xFF));
-		gp->name[dirent->name_len & 0xFF] = '\0';
+		strncpy(gp->name, dirent->name, name_len);
+		gp->name[name_len] = '\0';
 		return DIRENT_ABORT;
 	}
 	return 0;
diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 2dec5dc..f715067 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -73,7 +73,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	 * truncate it and return.
 	 */
 	if (dirent->inode) {
-		min_rec_len = EXT2_DIR_REC_LEN(dirent->name_len & 0xFF);
+		min_rec_len = EXT2_DIR_REC_LEN(ext2fs_dirent_name_len(dirent));
 		if (curr_rec_len < (min_rec_len + rec_len))
 			return ret;
 		rec_len = curr_rec_len - min_rec_len;
@@ -83,7 +83,8 @@ static int link_proc(struct ext2_dir_entry *dirent,
 		next = (struct ext2_dir_entry *) (buf + offset +
 						  dirent->rec_len);
 		next->inode = 0;
-		next->name_len = 0;
+		ext2fs_dirent_set_name_len(next, 0);
+		ext2fs_dirent_set_file_type(next, 0);
 		ls->err = ext2fs_set_rec_len(ls->fs, rec_len, next);
 		if (ls->err)
 			return DIRENT_ABORT;
@@ -97,10 +98,10 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	if (curr_rec_len < rec_len)
 		return ret;
 	dirent->inode = ls->inode;
-	dirent->name_len = ls->namelen;
+	ext2fs_dirent_set_name_len(dirent, ls->namelen);
 	strncpy(dirent->name, ls->name, ls->namelen);
 	if (ls->sb->s_feature_incompat & EXT2_FEATURE_INCOMPAT_FILETYPE)
-		dirent->name_len |= (ls->flags & 0x7) << 8;
+		ext2fs_dirent_set_file_type(dirent, ls->flags & 0x7);
 
 	ls->done++;
 	return DIRENT_ABORT|DIRENT_CHANGED;
diff --git a/lib/ext2fs/lookup.c b/lib/ext2fs/lookup.c
index 0e66e71..c1d802c 100644
--- a/lib/ext2fs/lookup.c
+++ b/lib/ext2fs/lookup.c
@@ -37,9 +37,9 @@ static int lookup_proc(struct ext2_dir_entry *dirent,
 {
 	struct lookup_struct *ls = (struct lookup_struct *) priv_data;
 
-	if (ls->len != (dirent->name_len & 0xFF))
+	if (ls->len != ext2fs_dirent_name_len(dirent))
 		return 0;
-	if (strncmp(ls->name, dirent->name, (dirent->name_len & 0xFF)))
+	if (strncmp(ls->name, dirent->name, ext2fs_dirent_name_len(dirent)))
 		return 0;
 	*ls->inode = dirent->inode;
 	ls->found++;
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index 2cd541d..d134bdf 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -56,12 +56,13 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 	if (dir_ino) {
 		if (fs->super->s_feature_incompat &
 		    EXT2_FEATURE_INCOMPAT_FILETYPE)
-			filetype = EXT2_FT_DIR << 8;
+			filetype = EXT2_FT_DIR;
 		/*
 		 * Set up entry for '.'
 		 */
 		dir->inode = dir_ino;
-		dir->name_len = 1 | filetype;
+		ext2fs_dirent_set_name_len(dir, 1);
+		ext2fs_dirent_set_file_type(dir, filetype);
 		dir->name[0] = '.';
 		rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
 		dir->rec_len = EXT2_DIR_REC_LEN(1);
@@ -74,7 +75,8 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 		if (retval)
 			return retval;
 		dir->inode = parent_ino;
-		dir->name_len = 2 | filetype;
+		ext2fs_dirent_set_name_len(dir, 2);
+		ext2fs_dirent_set_file_type(dir, filetype);
 		dir->name[0] = '.';
 		dir->name[1] = '.';
 
diff --git a/lib/ext2fs/unlink.c b/lib/ext2fs/unlink.c
index d2d31cc..8ab27ee 100644
--- a/lib/ext2fs/unlink.c
+++ b/lib/ext2fs/unlink.c
@@ -44,9 +44,9 @@ static int unlink_proc(struct ext2_dir_entry *dirent,
 	ls->prev = dirent;
 
 	if (ls->name) {
-		if ((dirent->name_len & 0xFF) != ls->namelen)
+		if (ext2fs_dirent_name_len(dirent) != ls->namelen)
 			return 0;
-		if (strncmp(ls->name, dirent->name, dirent->name_len & 0xFF))
+		if (strncmp(ls->name, dirent->name, ext2fs_dirent_name_len(dirent)))
 			return 0;
 	}
 	if (ls->inode) {
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 7d6520e..c38711d 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -515,7 +515,7 @@ static int rewrite_dir_block(ext2_filsys fs,
 		ctx->errcode = ext2fs_get_rec_len(fs, last_de, &rec_len);
 		if (ctx->errcode)
 			return BLOCK_ABORT;
-		name_size = last_de->name_len & 0xFF;
+		name_size = ext2fs_dirent_name_len(last_de);
 
 		if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index e40a85c..aa2364c 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1591,7 +1591,7 @@ static int check_and_change_inodes(ext2_ino_t dir,
 #ifdef RESIZE2FS_DEBUG
 	if (is->rfs->flags & RESIZE_DEBUG_INODEMAP)
 		printf("Inode translate (dir=%u, name=%.*s, %u->%u)\n",
-		       dir, dirent->name_len&0xFF, dirent->name,
+		       dir, ext2fs_dirent_name_len(dirent), dirent->name,
 		       dirent->inode, new_inode);
 #endif
 
-- 
1.8.1.4

