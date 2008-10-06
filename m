From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH][3/15] e2fsprogs-new-opt-shrdblks.patch
Date: Mon, 06 Oct 2008 16:01:03 +0530
Message-ID: <1223289063.4007.82.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_lKs+paEMVk9uxae8mTfDyQ)"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:59563 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYJFKbI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 06:31:08 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m96AV6Zq027189
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 10:31:06 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8B00M01BS36U00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 06 Oct 2008 18:31:06 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_lKs+paEMVk9uxae8mTfDyQ)
Content-type: text/plain
Content-transfer-encoding: 7BIT

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

    Select the block cloning method.  "dup" is old behavior which
remains
    the default.  "zero" is a new method that substitutes zero-filled
    blocks for the shared blocks in all the files that claim them.

-E shared=preserve|lost+found|delete

    Select the disposition of files containing shared blocks.
"preserve"
    is the old behavior which remains the default.  "lost+found" causes
    files to be unlinked after cloning so they will be reconnected to
    /lost+found in pass 3.   "delete" skips cloning entirely and simply
    deletes the files.

In the config file:
  [options]
      clone=dup|zero
      shared=preserve|lost+found|delete

Signed-off-by: Jim Garlick <garlick@llnl.gov>
Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

--Boundary_(ID_lKs+paEMVk9uxae8mTfDyQ)
Content-type: text/x-patch; charset=UTF-8; name=e2fsprogs-new-opt-shrdblks.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-new-opt-shrdblks.patch

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

Index: e2fsprogs-1.41.1/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.41.1/e2fsck/e2fsck.h
@@ -185,6 +185,17 @@ struct resource_track {
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
@@ -337,6 +348,8 @@ struct e2fsck_struct {
 	time_t now;
 	time_t time_fudge;	/* For working around buggy init scripts */
 	int ext_attr_ver;
+	shared_opt_t shared;
+	clone_opt_t clone;
 	profile_t	profile;
 	int blocks_per_page;
 
Index: e2fsprogs-1.41.1/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/unix.c
+++ e2fsprogs-1.41.1/e2fsck/unix.c
@@ -536,6 +536,49 @@ static void signal_cancel(int sig EXT2FS
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
@@ -571,6 +614,36 @@ static void parse_extended_opts(e2fsck_t
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
 		} else {
 			fprintf(stderr, _("Unknown extended option: %s\n"),
 				token);
@@ -586,6 +659,8 @@ static void parse_extended_opts(e2fsck_t
 		       "Valid extended options are:\n"), stderr);
 		fputs(("\tea_ver=<ea_version (1 or 2)>\n"), stderr);
 		fputs(("\tfragcheck\n"), stderr);
+		fputs(("\tshared=<preserve|lost+found|delete>\n"), stderr);
+		fputs(("\tclone=<dup|zero>\n"), stderr);
 		fputc('\n', stderr);
 		exit(1);
 	}
@@ -648,6 +723,7 @@ static errcode_t PRS(int argc, char *arg
 		config_fn[0] = cp;
 	profile_set_syntax_err_cb(syntax_err_report);
 	profile_init(config_fn, &ctx->profile);
+	initialize_profile_options(ctx);
 
 	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
 		switch (c) {
Index: e2fsprogs-1.41.1/e2fsck/pass1b.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/pass1b.c
+++ e2fsprogs-1.41.1/e2fsck/pass1b.c
@@ -457,6 +457,9 @@ static void pass1d(e2fsck_t ctx, char *b
 			q = (struct dup_block *) dnode_get(m);
 			if (q->num_bad > 1)
 				file_ok = 0;
+			if (q->num_bad == 1 && (ctx->clone == E2F_CLONE_ZERO ||
+			    ctx->shared != E2F_SHARED_PRESERVE))
+				file_ok = 0;
 			if (check_if_fs_block(ctx, s->block)) {
 				file_ok = 0;
 				meta_data = 1;
@@ -512,13 +515,26 @@ static void pass1d(e2fsck_t ctx, char *b
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
@@ -535,7 +551,8 @@ static void decrement_badcount(e2fsck_t 
 {
 	p->num_bad--;
 	if (p->num_bad <= 0 ||
-	    (p->num_bad == 1 && !check_if_fs_block(ctx, block)))
+	    (p->num_bad == 1 && !check_if_fs_block(ctx, block) &&
+	    ctx->clone == E2F_CLONE_DUP))
 		ext2fs_unmark_block_bitmap(ctx->block_dup_map, block);
 }
 
@@ -677,11 +694,15 @@ static int clone_file_block(ext2_filsys 
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
@@ -690,6 +711,11 @@ static int clone_file_block(ext2_filsys 
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
Index: e2fsprogs-1.41.1/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/problem.h
+++ e2fsprogs-1.41.1/e2fsck/problem.h
@@ -576,6 +576,13 @@ struct problem_context {
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
Index: e2fsprogs-1.41.1/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/problem.c
+++ e2fsprogs-1.41.1/e2fsck/problem.c
@@ -976,6 +976,14 @@ static struct e2fsck_problem problem_tab
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
Index: e2fsprogs-1.41.1/e2fsck/e2fsck.8.in
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/e2fsck.8.in
+++ e2fsprogs-1.41.1/e2fsck/e2fsck.8.in
@@ -184,6 +184,19 @@ separated, and may take an argument usin
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
Index: e2fsprogs-1.41.1/e2fsck/e2fsck.conf.5.in
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/e2fsck.conf.5.in
+++ e2fsprogs-1.41.1/e2fsck/e2fsck.conf.5.in
@@ -106,6 +106,20 @@ This boolean relation controls whether o
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

--Boundary_(ID_lKs+paEMVk9uxae8mTfDyQ)--
