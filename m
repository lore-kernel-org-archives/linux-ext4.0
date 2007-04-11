From: Jim Garlick <garlick@llnl.gov>
Subject: Re: [repost][patch 1/2] e2fsprogs: user selectable dup block handling
 in fsck
Date: Tue, 10 Apr 2007 17:29:28 -0700 (PDT)
Message-ID: <Pine.LNX.4.61.0704101715200.6523@webb>
References: <Pine.LNX.4.61.0702041728410.31030@webb> <Pine.LNX.4.61.0702041720460.31030@webb>
 <20070406223721.GA8606@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-3.llnl.gov ([128.115.41.83]:47365 "EHLO
	nspiron-3.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbXDKA33 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Apr 2007 20:29:29 -0400
In-Reply-To: <20070406223721.GA8606@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 6 Apr 2007, Theodore Tso wrote:

> lost+found does not work as you have implemented them in your patches
> in the case of a file which is hard linked.  That's because in pass1c
> we only find the first directory where which contains a hard link to
> the file name, for the purpose of displaying a pathname that will
> hopefully have meaning to the system administrator.  Currently, as
> implemented, if you specify a disposition of "lost+found", an inode
> which has multiple hard links will have one of its hard links removed,
> and since the rest of the links to the file are presend, it will not
> be moved into the lost+found directory.

Thanks for catching this!

I like your idea of an xml log from e2fsck - meanwhile here's a 
reworked patch that deals with hard links in lost+found mode, in case
its of use to anyone.  Context assumes the following patches are
pre-applied:

   [PATCH] e2fsprogs - pass1c terminates early if hard links
   http://marc.info/?l=linux-ext4&m=117623796726589&w=2

   [PATCH] e2fsprogs - e2fsck pass1c does extra work if root dir has
   http://marc.info/?l=linux-ext4&m=117624460101811&w=2

   [repost][patch 1/2] e2fsprogs: user selectable dup block handling
   http://marc.info/?l=linux-ext4&m=117063892623654&w=2

Regards,

Jim
____________________________

E2fsck fixes files that are found to be sharing blocks by cloning
the shared blocks and giving each file a private copy in pass 1D.

Allowing all files claiming the shared blocks to have copies can
inadvertantly bypass access restrictions.  Deleting all the files, 
zeroing the cloned blocks, or placing the files in the /lost+found 
directory after cloning may be preferable in some secure environments.

The following patches implement config file and command line options in
e2fsck that allow pass 1D behavior to be tuned according to site policy.
It adds two extended options and config file counterparts.  On the 
command line:

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

Index: e2fsprogs+chaos/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/e2fsck.h
+++ e2fsprogs+chaos/e2fsck/e2fsck.h
@@ -181,6 +181,17 @@ struct resource_track {
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
@@ -332,6 +343,8 @@ struct e2fsck_struct {
  	time_t now;

  	int ext_attr_ver;
+	shared_opt_t shared;
+	clone_opt_t clone;

  	profile_t	profile;

Index: e2fsprogs+chaos/e2fsck/unix.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/unix.c
+++ e2fsprogs+chaos/e2fsck/unix.c
@@ -510,6 +510,49 @@ static void signal_cancel(int sig EXT2FS
  }
  #endif

+static void initialize_profile_options(e2fsck_t ctx)
+{
+	char *tmp;
+
+	/* [options] shared=preserve|lost+found|delete */
+	tmp = NULL;
+	ctx->shared = E2F_SHARED_PRESERVE; 
+	profile_get_string(ctx->profile, "options", "shared", 0,
+		           "preserve", &tmp);
+	if (tmp) {
+		if (strcmp(tmp, "preserve") == 0)
+			ctx->shared = E2F_SHARED_PRESERVE; 
+		else if (strcmp(tmp, "delete") == 0)
+			ctx->shared = E2F_SHARED_DELETE; 
+		else if (strcmp(tmp, "lost+found") == 0)
+			ctx->shared = E2F_SHARED_LPF; 
+		else {
+			com_err(ctx->program_name, 0, 
+				_("configuration error: 'shared=%s'"), tmp);
+			fatal_error(ctx, 0);
+		}
+		free(tmp);
+	}
+
+	/* [options] clone=dup|zero */
+	tmp = NULL;
+	ctx->clone = E2F_CLONE_DUP;
+	profile_get_string(ctx->profile, "options", "clone", 0,
+			   "dup", &tmp);
+	if (tmp) {
+		if (strcmp(tmp, "dup") == 0)
+			ctx->clone = E2F_CLONE_DUP;
+		else if (strcmp(tmp, "zero") == 0)
+			ctx->clone = E2F_CLONE_ZERO;
+		else {
+			com_err(ctx->program_name, 0, 
+				_("configuration error: 'clone=%s'"), tmp);
+			fatal_error(ctx, 0);
+		}
+		free(tmp);
+	}
+}
+
  static void parse_extended_opts(e2fsck_t ctx, const char *opts)
  {
  	char	*buf, *token, *next, *p, *arg;
@@ -543,6 +586,36 @@ static void parse_extended_opts(e2fsck_t
  				continue;
  			}
  			ctx->ext_attr_ver = ea_ver;
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
  		} else {
  			fprintf(stderr, _("Unknown extended option: %s\n"),
  				token);
@@ -556,6 +629,8 @@ static void parse_extended_opts(e2fsck_t
  		       "and may take an argument which\n"
  		       "is set off by an equals ('=') sign.  "
  			"Valid extended options are:\n"
+		       "\tshared=<preserve|lost+found|delete>\n"
+		       "\tclone=<dup|zero>\n"
  		       "\tea_ver=<ea_version (1 or 2)>\n\n"), stderr);
  		exit(1);
  	}
@@ -614,6 +689,7 @@ static errcode_t PRS(int argc, char *arg
  		config_fn[0] = cp;
  	profile_set_syntax_err_cb(syntax_err_report);
  	profile_init(config_fn, &ctx->profile);
+	initialize_profile_options(ctx);

  	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
  		switch (c) {
Index: e2fsprogs+chaos/e2fsck/pass1b.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass1b.c
+++ e2fsprogs+chaos/e2fsck/pass1b.c
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

  static int process_pass1b_block(ext2_filsys fs, blk_t	*blocknr,
@@ -123,6 +128,7 @@ static void add_dupe(e2fsck_t ctx, ext2_
  	struct dup_inode	*di;
  	struct block_el		*blk_el;
  	struct inode_el 	*ino_el;
+	struct dir_el 		*dir_el;

  	n = dict_lookup(&blk_dict, INT_TO_VOIDPTR(blk));
  	if (n)
@@ -147,11 +153,17 @@ static void add_dupe(e2fsck_t ctx, ext2_
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
@@ -174,12 +186,17 @@ static void inode_dnode_free(dnode_t *no
  {
  	struct dup_inode	*di;
  	struct block_el		*p, *next;
+	struct dir_el		*dp, *dnext;

  	di = (struct dup_inode *) dnode_get(node);
  	for (p = di->block_list; p; p = next) {
  		next = p->next;
  		free(p);
  	}
+	for (dp = di->dir_list; dp; dp = dnext) {
+		dnext = dp->next;
+		free(dp);
+	}
  	free(node);
  }

@@ -351,6 +368,8 @@ struct search_dir_struct {
  	int		count;
  	ext2_ino_t	first_inode;
  	ext2_ino_t	max_inode;
+	e2fsck_t	ctx;
+	int		allflag;
  };

  static int search_dirent_proc(ext2_ino_t dir, int entry,
@@ -362,6 +381,7 @@ static int search_dirent_proc(ext2_ino_t
  {
  	struct search_dir_struct *sd;
  	struct dup_inode	*p;
+	struct dir_el		*dd_el;
  	dnode_t			*n;

  	sd = (struct search_dir_struct *) priv_data;
@@ -378,12 +398,16 @@ static int search_dirent_proc(ext2_ino_t
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


@@ -400,15 +424,30 @@ static void pass1c(e2fsck_t ctx, char *b

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
+		if (err)
+			result = err;
+	}
+	return result;
+}
+
  static void pass1d(e2fsck_t ctx, char *block_buf)
  {
  	ext2_filsys fs = ctx->fs;
@@ -456,6 +495,9 @@ static void pass1d(e2fsck_t ctx, char *b
  			q = (struct dup_block *) dnode_get(m);
  			if (q->num_bad > 1)
  				file_ok = 0;
+			if (q->num_bad == 1 && (ctx->clone == E2F_CLONE_ZERO ||
+			    ctx->shared != E2F_SHARED_PRESERVE))
+				file_ok = 0;
  			if (check_if_fs_block(ctx, s->block)) {
  				file_ok = 0;
  				meta_data = 1;
@@ -484,7 +526,7 @@ static void pass1d(e2fsck_t ctx, char *b
  		 */
  		pctx.inode = &p->inode;
  		pctx.ino = ino;
-		pctx.dir = p->dir;
+		pctx.dir = p->dir_list ? p->dir_list->dir : 0;
  		pctx.blkcount = p->num_dupblocks;
  		pctx.num = meta_data ? shared_len+1 : shared_len;
  		fix_problem(ctx, PR_1D_DUP_FILE, &pctx);
@@ -504,20 +546,32 @@ static void pass1d(e2fsck_t ctx, char *b
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
+			    fix_problem(ctx, PR_1D_DISCONNECT_QUESTION, &pctx)){
+				pctx.errcode = unlink_all(ctx, p, ino);
+				if (pctx.errcode) {
+					fix_problem(ctx, PR_1D_DISCONNECT_ERROR,
+							&pctx);
+					goto delete;
+				}
+			}
+			continue;
  		}
+delete:
  		if (fix_problem(ctx, PR_1D_DELETE_QUESTION, &pctx))
  			delete_file(ctx, ino, p, block_buf);
  		else
@@ -534,7 +588,8 @@ static void decrement_badcount(e2fsck_t
  {
  	p->num_bad--;
  	if (p->num_bad <= 0 ||
-	    (p->num_bad == 1 && !check_if_fs_block(ctx, block)))
+	    (p->num_bad == 1 && !check_if_fs_block(ctx, block) && 
+	    ctx->clone == E2F_CLONE_DUP))
  		ext2fs_unmark_block_bitmap(ctx->block_dup_map, block);
  }

@@ -572,7 +627,7 @@ static int delete_file_block(ext2_filsys

  	return 0;
  }
- 
+
  static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
  			struct dup_inode *dp, char* block_buf)
  {
@@ -680,11 +735,15 @@ static int clone_file_block(ext2_filsys
  			printf("Cloning block %u to %u\n", *block_nr,
  			       new_block);
  #endif
-			retval = io_channel_read_blk(fs->io, *block_nr, 1,
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
  			retval = io_channel_write_blk(fs->io, new_block, 1,
  						      cs->buf);
@@ -693,6 +752,11 @@ static int clone_file_block(ext2_filsys
  				return BLOCK_ABORT;
  			}
  			decrement_badcount(ctx, *block_nr, p);
+			if (ctx->clone == E2F_CLONE_ZERO && p->num_bad == 0) {
+				ext2fs_unmark_block_bitmap(ctx->block_found_map,
+							   *block_nr);
+				ext2fs_block_alloc_stats(fs, *block_nr, -1);
+			}
  			*block_nr = new_block;
  			ext2fs_mark_block_bitmap(ctx->block_found_map,
  						 new_block);
Index: e2fsprogs+chaos/e2fsck/problem.h
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/problem.h
+++ e2fsprogs+chaos/e2fsck/problem.h
@@ -539,7 +539,13 @@ struct problem_context {

  /* Couldn't clone file (error) */
  #define PR_1D_CLONE_ERROR	0x013008
- 
+
+/* File with shared blocks found */
+#define PR_1D_DISCONNECT_QUESTION 0x013009
+
+/* Couldn't unlink file (error) */
+#define PR_1D_DISCONNECT_ERROR	0x01300A
+
  /*
   * Pass 2 errors
   */
Index: e2fsprogs+chaos/e2fsck/problem.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/problem.c
+++ e2fsprogs+chaos/e2fsck/problem.c
@@ -912,6 +912,14 @@ static struct e2fsck_problem problem_tab
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
Index: e2fsprogs+chaos/e2fsck/e2fsck.8.in
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/e2fsck.8.in
+++ e2fsprogs+chaos/e2fsck/e2fsck.8.in
@@ -165,6 +165,19 @@ following options are supported:
  Assume the format of the extended attribute blocks in the filesystem is
  the specified version number.  The version number may be 1 or 2.  The
  default extended attribute version format is 2.
+.TP
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
  .RE
  .TP
  .B \-f
Index: e2fsprogs+chaos/e2fsck/e2fsck.conf.5.in
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/e2fsck.conf.5.in
+++ e2fsprogs+chaos/e2fsck/e2fsck.conf.5.in
@@ -68,6 +68,7 @@ document.
  This stanza contains general configuration parameters for
  .BR e2fsck 's
  behavior.
+.TP
  .I [problems]
  This stanza allows the administrator to reconfigure how e2fsck handles
  various filesystem inconsistencies.
@@ -87,6 +88,20 @@ This boolean relation controls whether o
  filesystem checks (either based on time or number of mounts) should
  be doubled if the system is running on battery.  It defaults to
  true.
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
+
  .SH THE [problems] STANZA
  Each tag in the
  .I [problems] 
Index: e2fsprogs+chaos/e2fsck/ChangeLog
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/ChangeLog
+++ e2fsprogs+chaos/e2fsck/ChangeLog
@@ -1,5 +1,12 @@
  2007-01-30  Jim Garlick  <garlick@llnl.gov>

+	* unix.c, pass1b.c, e2fsck.h : Add command line and config file
+		options to alter shared block handling method in pass 1D.
+
+	* problem.c, problem.h (PR_1D_DISCONNECT_*): Add new problem code.
+
+2007-01-30  Jim Garlick  <garlick@llnl.gov>
+
  	* unix.c: Parse config file before command line so command line
  		has precedence.  Make -E option parsing cumulative.
