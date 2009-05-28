From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] e2fsprogs - clean up #ifdef RESOURCE_TRACK
Date: Thu, 28 May 2009 10:01:41 -0400
Message-ID: <20090528140141.GQ26625@mit.edu>
References: <b040c32a0905042013y2ff78187kd6b8a0090b2d4d7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ken Chen <kenchen@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52955 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbZE1OBu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 10:01:50 -0400
Content-Disposition: inline
In-Reply-To: <b040c32a0905042013y2ff78187kd6b8a0090b2d4d7a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2009 at 08:13:40PM -0700, Ken Chen wrote:
> Add empty function for init_resource_track() and print_resource_track()
> in the case of ! defined RESOURCE_TRACK, so that we can clean up #ifdef
> throughout e2fsck source.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>

This is the version of the patch I actually checked in; your patch
didn't preserve the difference between e2fsck -t and e2fsck -tt, and
the convention if we pass in the e2fsck context variable, it should be
passed in first.

						- Ted

commit 9facd076ae8af6e908e228392cea866ce0faf1bc
Author: Ken Chen <kenchen@google.com>
Date:   Thu May 28 09:55:10 2009 -0400

    Add empty function for init_resource_track() and print_resource_track()
    in the case of ! defined RESOURCE_TRACK, so that we can clean up #ifdef
    throughout e2fsck source.
    
    Signed-off-by: Ken Chen <kenchen@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 4722dcc..ff73444 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -488,11 +488,15 @@ extern errcode_t e2fsck_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 extern int fs_proc_check(const char *fs_name);
 extern int check_for_modules(const char *fs_name);
 #ifdef RESOURCE_TRACK
-extern void print_resource_track(const char *desc,
+extern void print_resource_track(e2fsck_t ctx,
+				 const char *desc,
 				 struct resource_track *track,
 				 io_channel channel);
 extern void init_resource_track(struct resource_track *track,
 				io_channel channel);
+#else
+#define print_resource_track(ctx, desc, track, channel) do { } while (0)
+#define init_resource_track(track, channel) do { } while (0)
 #endif
 extern int inode_has_valid_blocks(struct ext2_inode *inode);
 extern void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ea7c6a2..01fce4f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -514,9 +514,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	int		busted_fs_time = 0;
 	int		inode_size;
 
-#ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
 	clear_problem_context(&pctx);
 
 	if (!(ctx->options & E2F_OPT_PREEN))
@@ -1120,12 +1118,7 @@ endit:
 	ext2fs_free_mem(&block_buf);
 	ext2fs_free_mem(&inode);
 
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 1"), &rtrack, ctx->fs->io);
-	}
-#endif
+	print_resource_track(ctx, _("Pass 1"), &rtrack, ctx->fs->io);
 }
 
 /*
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 008d079..d08ece4 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -227,38 +227,17 @@ void e2fsck_pass1_dupblocks(e2fsck_t ctx, char *block_buf)
 	dict_set_allocator(&ino_dict, NULL, inode_dnode_free, NULL);
 	dict_set_allocator(&blk_dict, NULL, block_dnode_free, NULL);
 
-#ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
 	pass1b(ctx, block_buf);
+	print_resource_track(ctx, "Pass 1b", &rtrack, ctx->fs->io);
 
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track("Pass 1b", &rtrack, ctx->fs->io);
-	}
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
 	pass1c(ctx, block_buf);
+	print_resource_track(ctx, "Pass 1c", &rtrack, ctx->fs->io);
 
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track("Pass 1c", &rtrack, ctx->fs->io);
-	}
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
 	pass1d(ctx, block_buf);
-
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track("Pass 1d", &rtrack, ctx->fs->io);
-	}
-#endif
+	print_resource_track(ctx, "Pass 1d", &rtrack, ctx->fs->io);
 
 	/*
 	 * Time to free all of the accumulated data structures that we
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7b79f4b..c8a3ddb 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -101,10 +101,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 	problem_t		code;
 	int			bad_dir;
 
-#ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
 	clear_problem_context(&cd.pctx);
 
 #ifdef MTRACE
@@ -284,12 +281,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 		}
 	}
 
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 2"), &rtrack, fs->io);
-	}
-#endif
+	print_resource_track(ctx, _("Pass 2"), &rtrack, fs->io);
 }
 
 #define MAX_DEPTH 32000
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index a14bc5d..5a5fd3e 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -60,10 +60,7 @@ void e2fsck_pass3(e2fsck_t ctx)
 	struct dir_info	*dir;
 	unsigned long maxdirs, count;
 
-#ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
 	clear_problem_context(&pctx);
 
 #ifdef MTRACE
@@ -84,13 +81,7 @@ void e2fsck_pass3(e2fsck_t ctx)
 		ctx->flags |= E2F_FLAG_ABORT;
 		goto abort_exit;
 	}
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Peak memory"), &ctx->global_rtrack,
-				     NULL);
-	}
-#endif
+	print_resource_track(ctx, _("Peak memory"), &ctx->global_rtrack, NULL);
 
 	check_root(ctx);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
@@ -140,12 +131,7 @@ abort_exit:
 		inode_done_map = 0;
 	}
 
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 3"), &rtrack, ctx->fs->io);
-	}
-#endif
+	print_resource_track(ctx, _("Pass 3"), &rtrack, ctx->fs->io);
 }
 
 /*
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 7248483..d9706ce 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -99,9 +99,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 	char	*buf = 0;
 	int	group, maxgroup;
 
-#ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
 
 #ifdef MTRACE
 	mtrace_print("Pass 4");
@@ -190,11 +188,6 @@ errout:
 		ext2fs_free_mem(&buf);
 
 	ext2fs_free_mem(&inode);
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 4"), &rtrack, ctx->fs->io);
-	}
-#endif
+	print_resource_track(ctx, _("Pass 4"), &rtrack, ctx->fs->io);
 }
 
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 65822d9..e660386 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -29,10 +29,7 @@ void e2fsck_pass5(e2fsck_t ctx)
 	mtrace_print("Pass 5");
 #endif
 
-#ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
 	clear_problem_context(&pctx);
 
 	if (!(ctx->options & E2F_OPT_PREEN))
@@ -64,12 +61,7 @@ void e2fsck_pass5(e2fsck_t ctx)
 	ext2fs_free_block_bitmap(ctx->block_found_map);
 	ctx->block_found_map = 0;
 
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 5"), &rtrack, ctx->fs->io);
-	}
-#endif
+	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
 }
 
 #define NO_BLK ((blk_t) -1)
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 84c12ba..d2dbcce 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -800,10 +800,7 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 	errcode_t		retval;
 	int			cur, max, all_dirs, dir_index, first = 1;
 
-#ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
 	all_dirs = ctx->options & E2F_OPT_COMPRESS_DIRS;
 
 	if (!ctx->dirs_to_hash && !all_dirs)
@@ -867,10 +864,5 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 		ext2fs_u32_list_free(ctx->dirs_to_hash);
 	ctx->dirs_to_hash = 0;
 
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track("Pass 3A", &rtrack, ctx->fs->io);
-	}
-#endif
+	print_resource_track(ctx, "Pass 3A", &rtrack, ctx->fs->io);
 }
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index fdc46d8..3e684ae 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -939,10 +939,7 @@ int main (int argc, char *argv[])
 	}
 	reserve_stdio_fds();
 
-#ifdef RESOURCE_TRACK
 	init_resource_track(&ctx->global_rtrack, NULL);
-#endif
-
 	if (!(ctx->options & E2F_OPT_PREEN) || show_version_only)
 		fprintf(stderr, "e2fsck %s (%s)\n", my_ver_string,
 			 my_ver_date);
@@ -1409,11 +1406,9 @@ no_journal:
 	}
 
 	e2fsck_write_bitmaps(ctx);
-#ifdef RESOURCE_TRACK
 	io_channel_flush(ctx->fs->io);
-	if (ctx->options & E2F_OPT_TIME)
-		print_resource_track(NULL, &ctx->global_rtrack, ctx->fs->io);
-#endif
+	print_resource_track(ctx, NULL, &ctx->global_rtrack, ctx->fs->io);
+
 	ext2fs_close(fs);
 	ctx->fs = NULL;
 	free(ctx->journal_name);
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 89f7908..56c6b35 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -313,8 +313,8 @@ static _INLINE_ float timeval_subtract(struct timeval *tv1,
 		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
 }
 
-void print_resource_track(const char *desc, struct resource_track *track,
-			  io_channel channel)
+void print_resource_track(e2fsck_t ctx, const char *desc,
+			  struct resource_track *track, io_channel channel)
 {
 #ifdef HAVE_GETRUSAGE
 	struct rusage r;
@@ -324,6 +324,11 @@ void print_resource_track(const char *desc, struct resource_track *track,
 #endif
 	struct timeval time_end;
 
+	if ((desc && !(ctx->options & E2F_OPT_TIME2)) ||
+	    (!desc && !(ctx->options & E2F_OPT_TIME)))
+		return;
+
+	e2fsck_clear_progbar(ctx);
 	gettimeofday(&time_end, 0);
 
 	if (desc)
