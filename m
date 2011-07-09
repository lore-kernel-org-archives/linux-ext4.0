From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 2/2] e2fsck: allow shared blocks to be handled safely
Date: Fri,  8 Jul 2011 18:49:04 -0600
Message-ID: <1310172544-18650-2-git-send-email-adilger@whamcloud.com>
References: <1310172544-18650-1-git-send-email-adilger@whamcloud.com>
Cc: Jim Garlick <garlick@llnl.gov>,
	Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:58734 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1GIAtI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jul 2011 20:49:08 -0400
In-Reply-To: <1310172544-18650-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

E2fsck fixes files that are found to be sharing blocks by cloning
the shared blocks and giving each file a private copy in pass 1D.

Allowing all files claiming the shared blocks to have copies can
inadvertantly bypass access restrictions.  Deleting all the files,
zeroing the cloned blocks, or placing the files in the /lost+found
directory after cloning may be preferable in some secure environments.
Handle all hard links to inodes with shared blocks in a similar way.

Add support for config file and command line options to e2fsck that
allow pass 1D behavior to be tuned according to site policy.  It adds
two extended options and config file counterparts.  On the command line:

 -E clone=dup|zero

    Select the block cloning method.  "dup" is old behavior which remains
    the default.  "zero" is a new method that substitutes zero-filled
    blocks for the shared blocks in all the files that claim them.

 -E shared=preserve|lost+found|delete

    Select the disposition of files containing shared blocks.  "preserve"
    is the old behavior which remains the default.  "lost+found" causes
    files to be unlinked after cloning so they will be reconnected to
    /lost+found in pass 3.   "delete" skips cloning entirely and simply
    deletes the files.

In the config file:
  [options]
      clone=dup|zero
      shared=preserve|lost+found|delete

Signed-off-by: Jim Garlick <garlick@llnl.gov>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/e2fsck.8.in      |   13 ++++++
 e2fsck/e2fsck.conf.5.in |   13 ++++++
 e2fsck/e2fsck.h         |   13 ++++++
 e2fsck/pass1b.c         |  102 ++++++++++++++++++++++++++++++++++++++---------
 e2fsck/problem.c        |    8 ++++
 e2fsck/problem.h        |    7 +++
 e2fsck/unix.c           |   77 +++++++++++++++++++++++++++++++++++
 7 files changed, 214 insertions(+), 19 deletions(-)

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 178eecf..8db4173 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -180,6 +180,19 @@ separated, and may take an argument using the equals ('=') sign.  The
 following options are supported:
 .RS 1.2i
 .TP
+.BI clone= dup|zero
+Resolve files with shared blocks in pass 1D by giving each file a private
+copy of the blocks (dup);
+or replacing the shared blocks with private, zero-filled blocks (zero).  
+The default is dup.
+.TP
+.BI shared= preserve|lost+found|delete
+Files with shared blocks discovered in pass 1D are cloned and then left 
+in place (preserve); 
+cloned and then disconnected from their parent directory,
+then reconnected to /lost+found in pass 3 (lost+found); 
+or simply deleted (delete).  The default is preserve.
+.TP
 .BI ea_ver= extended_attribute_version
 Set the version of the extended attribute blocks which
 .B e2fsck
diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index 2a600d0..83d2980 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -129,6 +129,19 @@ This boolean relation controls whether or not
 will offer to clear
 the test_fs flag if the ext4 filesystem is available on the system.  It
 defaults to true.
+.TP
+.I clone
+This string relation controls the default handling of shared blocks in pass 1D.
+It can be set to dup or zero.  See the
+.I "-E clone" 
+option description in e2fsck(8).
+.TP
+.I shared
+This string relation controls the default disposition of files discovered to 
+have shared blocks in pass 1D.  It can be set to preserve, lost+found, 
+or delete.  See the
+.I "-E shared" 
+option description in e2fsck(8).
 .TP 
 .I defer_check_on_battery
 This boolean relation controls whether or not the interval between 
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 2574824..2b46f46 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -192,6 +192,17 @@ struct resource_track {
 #define E2F_PASS_5	5
 #define E2F_PASS_1B	6
 
+typedef	enum {
+	E2F_SHARED_PRESERVE = 0,
+	E2F_SHARED_DELETE,
+	E2F_SHARED_LPF
+} shared_opt_t;
+
+typedef enum {
+	E2F_CLONE_DUP = 0,
+	E2F_CLONE_ZERO
+} clone_opt_t;
+
 /*
  * Define the extended attribute refcount structure
  */
@@ -350,6 +361,8 @@ struct e2fsck_struct {
 	int ext_attr_ver;
 	profile_t	profile;
 	int blocks_per_page;
+	shared_opt_t shared;
+	clone_opt_t clone;
 
 	/*
 	 * For the use of callers of the e2fsck functions; not used by
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 9bef368..3c651a4 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -63,6 +63,11 @@ struct inode_el {
 	struct inode_el *next;
 };
 
+struct dir_el {
+	ext2_ino_t	dir;
+	struct dir_el	*next;
+};
+
 struct dup_block {
 	int		num_bad;
 	struct inode_el *inode_list;
@@ -76,10 +81,10 @@ struct dup_block {
  * of multiply-claimed blocks.
  */
 struct dup_inode {
-	ext2_ino_t		dir;
 	int			num_dupblocks;
 	struct ext2_inode	inode;
 	struct block_el		*block_list;
+	struct dir_el		*dir_list;
 };
 
 static int process_pass1b_block(ext2_filsys fs, blk64_t	*blocknr,
@@ -123,6 +128,7 @@ static void add_dupe(e2fsck_t ctx, ext2_ino_t ino, blk64_t blk,
 	struct dup_inode	*di;
 	struct block_el		*blk_el;
 	struct inode_el 	*ino_el;
+	struct dir_el 		*dir_el;
 
 	n = dict_lookup(&blk_dict, INT_TO_VOIDPTR(blk));
 	if (n)
@@ -147,11 +153,17 @@ static void add_dupe(e2fsck_t ctx, ext2_ino_t ino, blk64_t blk,
 	else {
 		di = (struct dup_inode *) e2fsck_allocate_memory(ctx,
 			 sizeof(struct dup_inode), "duplicate inode header");
+		di->dir_list = NULL;
 		if (ino == EXT2_ROOT_INO) {
-			di->dir = EXT2_ROOT_INO;
+			dir_el = (struct dir_el *) e2fsck_allocate_memory(ctx,
+					sizeof(struct dir_el),
+					"duplicate inode element");
+			dir_el->dir = EXT2_ROOT_INO;
+			dir_el->next = di->dir_list;
+			di->dir_list = dir_el;
 			dup_inode_founddir++;
 		} else
-			di->dir = 0;
+			di->dir_list = NULL;
 
 		di->num_dupblocks = 0;
 		di->block_list = 0;
@@ -174,12 +186,17 @@ static void inode_dnode_free(dnode_t *node,
 {
 	struct dup_inode	*di;
 	struct block_el		*p, *next;
+	struct dir_el           *dp, *dnext;
 
 	di = (struct dup_inode *) dnode_get(node);
 	for (p = di->block_list; p; p = next) {
 		next = p->next;
 		free(p);
 	}
+	for (dp = di->dir_list; dp; dp = dnext) {
+		dnext = dp->next;
+		free(dp);
+	}
 	free(di);
 	free(node);
 }
@@ -371,6 +388,8 @@ struct search_dir_struct {
 	int		count;
 	ext2_ino_t	first_inode;
 	ext2_ino_t	max_inode;
+	e2fsck_t	ctx;
+	int		allflag;
 };
 
 static int search_dirent_proc(ext2_ino_t dir, int entry,
@@ -382,6 +401,7 @@ static int search_dirent_proc(ext2_ino_t dir, int entry,
 {
 	struct search_dir_struct *sd;
 	struct dup_inode	*p;
+	struct dir_el		*dd_el;
 	dnode_t			*n;
 
 	sd = (struct search_dir_struct *) priv_data;
@@ -398,12 +418,16 @@ static int search_dirent_proc(ext2_ino_t dir, int entry,
 	if (!n)
 		return 0;
 	p = (struct dup_inode *) dnode_get(n);
-	if (!p->dir) {
-		p->dir = dir;
+	if (sd->allflag || !p->dir_list) {
+		dd_el = (struct dir_el *) e2fsck_allocate_memory(sd->ctx,
+			sizeof(struct dir_el), "duplicate directory element");
+		dd_el->dir = dir;
+		dd_el->next = p->dir_list;
+		p->dir_list = dd_el;
 		sd->count--;
 	}
 
-	return(sd->count ? 0 : DIRENT_ABORT);
+	return((sd->allflag || sd->count) ? 0 : DIRENT_ABORT);
 }
 
 
@@ -420,15 +444,30 @@ static void pass1c(e2fsck_t ctx, char *block_buf)
 
 	/*
 	 * Search through all directories to translate inodes to names
-	 * (by searching for the containing directory for that inode.)
+	 * (by searching for the containing directories for that inode.)
 	 */
 	sd.count = dup_inode_count - dup_inode_founddir;
 	sd.first_inode = EXT2_FIRST_INODE(fs->super);
 	sd.max_inode = fs->super->s_inodes_count;
+	sd.ctx = ctx;
+	sd.allflag = (ctx->shared == E2F_SHARED_LPF);
 	ext2fs_dblist_dir_iterate(fs->dblist, 0, block_buf,
 				  search_dirent_proc, &sd);
 }
 
+static errcode_t unlink_all(e2fsck_t ctx, struct dup_inode *dup, ext2_ino_t ino)
+{
+	struct dir_el *dp;
+	errcode_t err, result = 0;
+
+	for (dp = dup->dir_list; dp; dp = dp->next) {
+		err = ext2fs_unlink(ctx->fs, dp->dir, NULL, ino, 0);
+			if (err)
+				result = err;
+	}
+	return result;
+}
+
 static void pass1d(e2fsck_t ctx, char *block_buf)
 {
 	ext2_filsys fs = ctx->fs;
@@ -476,6 +515,9 @@ static void pass1d(e2fsck_t ctx, char *block_buf)
 			q = (struct dup_block *) dnode_get(m);
 			if (q->num_bad > 1)
 				file_ok = 0;
+			if (q->num_bad == 1 && (ctx->clone == E2F_CLONE_ZERO ||
+			    ctx->shared != E2F_SHARED_PRESERVE))
+				file_ok = 0;
 			if (check_if_fs_block(ctx, s->block)) {
 				file_ok = 0;
 				meta_data = 1;
@@ -504,7 +546,7 @@ static void pass1d(e2fsck_t ctx, char *block_buf)
 		 */
 		pctx.inode = &p->inode;
 		pctx.ino = ino;
-		pctx.dir = p->dir;
+		pctx.dir = p->dir_list ? p->dir_list->dir : 0;
 		pctx.blkcount = p->num_dupblocks;
 		pctx.num = meta_data ? shared_len+1 : shared_len;
 		fix_problem(ctx, PR_1D_DUP_FILE, &pctx);
@@ -524,20 +566,32 @@ static void pass1d(e2fsck_t ctx, char *block_buf)
 			 */
 			pctx.inode = &t->inode;
 			pctx.ino = shared[i];
-			pctx.dir = t->dir;
+			pctx.dir = t->dir_list ? t->dir_list->dir : 0;
 			fix_problem(ctx, PR_1D_DUP_FILE_LIST, &pctx);
 		}
 		if (file_ok) {
 			fix_problem(ctx, PR_1D_DUP_BLOCKS_DEALT, &pctx);
 			continue;
 		}
-		if (fix_problem(ctx, PR_1D_CLONE_QUESTION, &pctx)) {
+		if (ctx->shared != E2F_SHARED_DELETE &&
+		    fix_problem(ctx, PR_1D_CLONE_QUESTION, &pctx)) {
 			pctx.errcode = clone_file(ctx, ino, p, block_buf);
-			if (pctx.errcode)
+			if (pctx.errcode) {
 				fix_problem(ctx, PR_1D_CLONE_ERROR, &pctx);
-			else
-				continue;
+				goto delete;
+			}
+			if (ctx->shared == E2F_SHARED_LPF &&
+			    fix_problem(ctx, PR_1D_DISCONNECT_QUESTION, &pctx)) {
+				pctx.errcode = unlink_all(ctx, p, ino);
+				if (pctx.errcode) {
+					fix_problem(ctx, PR_1D_DISCONNECT_ERROR,
+						    &pctx);
+					goto delete;
+				}
+			}
+			continue;
 		}
+delete:
 		if (fix_problem(ctx, PR_1D_DELETE_QUESTION, &pctx))
 			delete_file(ctx, ino, p, block_buf);
 		else
@@ -554,7 +608,8 @@ static void decrement_badcount(e2fsck_t ctx, blk64_t block, struct dup_block *p)
 {
 	p->num_bad--;
 	if (p->num_bad <= 0 ||
-	    (p->num_bad == 1 && !check_if_fs_block(ctx, block)))
+	    (p->num_bad == 1 && !check_if_fs_block(ctx, block) &&
+	    ctx->clone == E2F_CLONE_DUP))
 		ext2fs_unmark_block_bitmap2(ctx->block_dup_map, block);
 }
 
@@ -700,11 +755,15 @@ static int clone_file_block(ext2_filsys fs,
 			printf("Cloning block %u to %u\n", *block_nr,
 			       new_block);
 #endif
-			retval = io_channel_read_blk64(fs->io, *block_nr, 1,
-						     cs->buf);
-			if (retval) {
-				cs->errcode = retval;
-				return BLOCK_ABORT;
+			if (ctx->clone == E2F_CLONE_ZERO) {
+				memset(cs->buf, 0, fs->blocksize);
+			} else {
+				retval = io_channel_read_blk(fs->io, *block_nr,
+							1, cs->buf);
+				if (retval) {
+					cs->errcode = retval;
+					return BLOCK_ABORT;
+				}
 			}
 			retval = io_channel_write_blk64(fs->io, new_block, 1,
 						      cs->buf);
@@ -713,6 +772,11 @@ static int clone_file_block(ext2_filsys fs,
 				return BLOCK_ABORT;
 			}
 			decrement_badcount(ctx, *block_nr, p);
+			if (ctx->clone == E2F_CLONE_ZERO && p->num_bad == 0) {
+				ext2fs_unmark_block_bitmap2(ctx->block_found_map,
+							   *block_nr);
+				ext2fs_block_alloc_stats(fs, *block_nr, -1);
+			}
 			*block_nr = new_block;
 			ext2fs_mark_block_bitmap2(ctx->block_found_map,
 						 new_block);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index c5bebf8..286dd9d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -998,6 +998,14 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_1D_CLONE_ERROR,
 	  N_("Couldn't clone file: %m\n"), PROMPT_NONE, 0 },
 
+	/* File with shared blocks found */
+	{ PR_1D_DISCONNECT_QUESTION,
+	  N_("File with shared blocks found\n"), PROMPT_CONNECT, 0 },
+
+	/* Couldn't unlink file (error) */
+	{ PR_1D_DISCONNECT_ERROR,
+	  N_("Couldn't unlink file: %m\n"), PROMPT_NONE, 0 },
+
 	/* Pass 2 errors */
 
 	/* Pass 2: Checking directory structure */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 8379e0c..e8ab738 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -589,6 +589,13 @@ struct problem_context {
 /* Couldn't clone file (error) */
 #define PR_1D_CLONE_ERROR	0x013008
 
+/* File with shared blocks found */
+#define PR_1D_DISCONNECT_QUESTION 0x013009
+
+/* Couldn't unlink file (error) */
+#define PR_1D_DISCONNECT_ERROR	0x01300A
+
+
 /*
  * Pass 2 errors
  */
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 0830175..825243c 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -593,6 +593,49 @@ static void signal_cancel(int sig EXT2FS_ATTR((unused)))
 }
 #endif
 
+static void initialize_profile_options(e2fsck_t ctx)
+{
+	char *tmp = NULL;
+
+	/* [options] shared=preserve|lost+found|delete */
+	ctx->shared = E2F_SHARED_PRESERVE;
+	profile_get_string(ctx->profile, "options", "shared", 0, "preserve",
+			   &tmp);
+	if (tmp) {
+		if (strcmp(tmp, "preserve") == 0) {
+			ctx->shared = E2F_SHARED_PRESERVE;
+		} else if (strcmp(tmp, "delete") == 0) {
+			ctx->shared = E2F_SHARED_DELETE;
+		} else if (strcmp(tmp, "lost+found") == 0) {
+			ctx->shared = E2F_SHARED_LPF;
+		} else {
+			com_err(ctx->program_name, 0,
+				_("unknown configuration option: 'shared=%s'"),
+				tmp);
+			fatal_error(ctx, 0);
+		}
+		free(tmp);
+	}
+
+	/* [options] clone=dup|zero */
+	tmp = NULL;
+	ctx->clone = E2F_CLONE_DUP;
+	profile_get_string(ctx->profile, "options", "clone", 0, "dup", &tmp);
+	if (tmp) {
+		if (strcmp(tmp, "dup") == 0){
+			ctx->clone = E2F_CLONE_DUP;
+		} else if (strcmp(tmp, "zero") == 0) {
+			ctx->clone = E2F_CLONE_ZERO;
+		} else {
+			com_err(ctx->program_name, 0,
+				_("unknown configuration option: 'clone=%s'"),
+				tmp);
+			fatal_error(ctx, 0);
+		}
+		free(tmp);
+	}
+}
+
 static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 {
 	char	*buf, *token, *next, *p, *arg;
@@ -628,6 +671,36 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		} else if (strcmp(token, "fragcheck") == 0) {
 			ctx->options |= E2F_OPT_FRAGCHECK;
 			continue;
+		/* -E shared=preserve|lost+found|delete */
+		} else if (strcmp(token, "shared") == 0) {
+			if (!arg) {
+				extended_usage++;
+				continue;
+			}
+			if (strcmp(arg, "preserve") == 0) {
+				ctx->shared = E2F_SHARED_PRESERVE;
+			} else if (strcmp(arg, "lost+found") == 0) {
+				ctx->shared = E2F_SHARED_LPF;
+			} else if (strcmp(arg, "delete") == 0) {
+				ctx->shared = E2F_SHARED_DELETE;
+			} else {
+				extended_usage++;
+				continue;
+			}
+		/* -E clone=dup|zero */
+		} else if (strcmp(token, "clone") == 0) {
+			if (!arg) {
+				extended_usage++;
+				continue;
+			}
+			if (strcmp(arg, "dup") == 0) {
+				ctx->clone = E2F_CLONE_DUP;
+			} else if (strcmp(arg, "zero") == 0) {
+				ctx->clone = E2F_CLONE_ZERO;
+			} else {
+				extended_usage++;
+				continue;
+			}
 		} else if (strcmp(token, "journal_only") == 0) {
 			if (arg) {
 				extended_usage++;
@@ -658,6 +731,8 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		fputs(("\tjournal_only\n"), stderr);
 		fputs(("\tdiscard\n"), stderr);
 		fputs(("\tnodiscard\n"), stderr);
+		fputs(("\tshared=<preserve|lost+found|delete>\n"), stderr);
+		fputs(("\tclone=<dup|zero>\n"), stderr);
 		fputc('\n', stderr);
 		exit(1);
 	}
@@ -717,6 +792,8 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	else
 		ctx->program_name = "e2fsck";
 
+	initialize_profile_options(ctx);
+
 	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
 		switch (c) {
 		case 'C':
-- 
1.7.3.4

