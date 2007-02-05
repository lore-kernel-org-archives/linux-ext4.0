From: Jim Garlick <garlick@llnl.gov>
Subject: [repost][patch 2/2] e2fsprogs: user selectable dup block handling
 in fsck (fwd)
Date: Sun, 4 Feb 2007 17:31:20 -0800 (PST)
Message-ID: <Pine.LNX.4.61.0702041728410.31030@webb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-1.llnl.gov ([128.115.41.81]:38407 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbXBEBbV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Feb 2007 20:31:21 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Second patch that implements new options for shared block handling
in e2fsck pass 1D.


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
@@ -448,6 +448,9 @@ static void pass1d(e2fsck_t ctx, char *b
  			q = (struct dup_block *) dnode_get(m);
  			if (q->num_bad > 1)
  				file_ok = 0;
+			if (q->num_bad == 1 && (ctx->clone == E2F_CLONE_ZERO ||
+			    ctx->shared != E2F_SHARED_PRESERVE))
+				file_ok = 0;
  			if (check_if_fs_block(ctx, s->block)) {
  				file_ok = 0;
  				meta_data = 1;
@@ -503,13 +506,26 @@ static void pass1d(e2fsck_t ctx, char *b
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
+				pctx.errcode = ext2fs_unlink(fs, p->dir, 
+							     NULL, ino, 0);
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
@@ -526,7 +542,8 @@ static void decrement_badcount(e2fsck_t
  {
  	p->num_bad--;
  	if (p->num_bad <= 0 ||
-	    (p->num_bad == 1 && !check_if_fs_block(ctx, block)))
+	    (p->num_bad == 1 && !check_if_fs_block(ctx, block) && 
+	    ctx->clone == E2F_CLONE_DUP))
  		ext2fs_unmark_block_bitmap(ctx->block_dup_map, block);
  }

@@ -564,7 +581,7 @@ static int delete_file_block(ext2_filsys

  	return 0;
  }
- 
+
  static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
  			struct dup_inode *dp, char* block_buf)
  {
@@ -672,11 +689,15 @@ static int clone_file_block(ext2_filsys
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
@@ -685,6 +706,11 @@ static int clone_file_block(ext2_filsys
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
@@ -536,7 +536,13 @@ struct problem_context {

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
