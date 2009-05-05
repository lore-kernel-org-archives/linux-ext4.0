From: Ken Chen <kenchen@google.com>
Subject: [patch] e2fsprogs - clean up #ifdef RESOURCE_TRACK
Date: Mon, 4 May 2009 20:13:40 -0700
Message-ID: <b040c32a0905042013y2ff78187kd6b8a0090b2d4d7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:8807 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZEEDNm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2009 23:13:42 -0400
Received: from wpaz37.hot.corp.google.com (wpaz37.hot.corp.google.com [172.24.198.101])
	by smtp-out.google.com with ESMTP id n453Df6Y013155
	for <linux-ext4@vger.kernel.org>; Tue, 5 May 2009 04:13:41 +0100
Received: from gxk2 (gxk2.prod.google.com [10.202.11.2])
	by wpaz37.hot.corp.google.com with ESMTP id n453Dec3001527
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 20:13:40 -0700
Received: by gxk2 with SMTP id 2so8847612gxk.8
        for <linux-ext4@vger.kernel.org>; Mon, 04 May 2009 20:13:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add empty function for init_resource_track() and print_resource_track()
in the case of ! defined RESOURCE_TRACK, so that we can clean up #ifdef
throughout e2fsck source.

Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 553a8c4..c2652da 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -489,9 +489,12 @@ extern int check_for_modules(const char *fs_name);
 #ifdef RESOURCE_TRACK
 extern void print_resource_track(const char *desc,
 				 struct resource_track *track,
-				 io_channel channel);
+				 io_channel channel, e2fsck_t ctx);
 extern void init_resource_track(struct resource_track *track,
 				io_channel channel);
+#else
+#define print_resource_track(desc, track, channel, ctx) do { } while (0)
+#define init_resource_track(track, channel) do { } while (0)
 #endif
 extern int inode_has_valid_blocks(struct ext2_inode *inode);
 extern void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3b05cf2..b548433 100644
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
+	print_resource_track(_("Pass 1"), &rtrack, ctx->fs->io, ctx);
 }

 /*
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 008d079..5667a7b 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -227,38 +227,17 @@ void e2fsck_pass1_dupblocks(
 	dict_set_allocator(&ino_dict, NULL, inode_dnode_free, NULL);
 	dict_set_allocator(&blk_dict, NULL, block_dnode_free, NULL);

-#ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
 	pass1b(ctx, block_buf);
+	print_resource_track("Pass 1b", &rtrack, ctx->fs->io, ctx);

-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track("Pass 1b", &rtrack, ctx->fs->io);
-	}
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif
-
 	pass1c(ctx, block_buf);
+	print_resource_track("Pass 1c", &rtrack, ctx->fs->io, ctx);

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
+	print_resource_track("Pass 1d", &rtrack, ctx->fs->io, ctx);

 	/*
 	 * Time to free all of the accumulated data structures that we
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index b33f596..06f34f4 100644
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
@@ -278,12 +275,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 		}
 	}

-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 2"), &rtrack, fs->io);
-	}
-#endif
+	print_resource_track(_("Pass 2"), &rtrack, fs->io, ctx);
 }

 #define MAX_DEPTH 32000
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index a14bc5d..cd0a020 100644
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
+	print_resource_track(_("Peak memory"), &ctx->global_rtrack, NULL, ctx);

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
+	print_resource_track(_("Pass 3"), &rtrack, ctx->fs->io, ctx);
 }

 /*
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 7248483..a2777a7 100644
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
+	print_resource_track(_("Pass 4"), &rtrack, ctx->fs->io, ctx);
 }

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 65822d9..3bbc54d 100644
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
+	print_resource_track(_("Pass 5"), &rtrack, ctx->fs->io, ctx);
 }

 #define NO_BLK ((blk_t) -1)
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 84c12ba..df9a419 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -800,9 +800,7 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 	errcode_t		retval;
 	int			cur, max, all_dirs, dir_index, first = 1;

-#ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack, ctx->fs->io);
-#endif

 	all_dirs = ctx->options & E2F_OPT_COMPRESS_DIRS;

@@ -867,10 +865,5 @@ void e2fsck_rehash_directories(e2fsck_t ctx)
 		ext2fs_u32_list_free(ctx->dirs_to_hash);
 	ctx->dirs_to_hash = 0;

-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME2) {
-		e2fsck_clear_progbar(ctx);
-		print_resource_track("Pass 3A", &rtrack, ctx->fs->io);
-	}
-#endif
+	print_resource_track("Pass 3A", &rtrack, ctx->fs->io, ctx);
 }
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index f452c9c..e0b2332 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -939,9 +939,7 @@ int main (int argc, char *argv[])
 	}
 	reserve_stdio_fds();

-#ifdef RESOURCE_TRACK
 	init_resource_track(&ctx->global_rtrack, NULL);
-#endif

 	if (!(ctx->options & E2F_OPT_PREEN) || show_version_only)
 		fprintf(stderr, "e2fsck %s (%s)\n", my_ver_string,
@@ -1409,11 +1407,9 @@ no_journal:
 	}

 	e2fsck_write_bitmaps(ctx);
-#ifdef RESOURCE_TRACK
 	io_channel_flush(ctx->fs->io);
-	if (ctx->options & E2F_OPT_TIME)
-		print_resource_track(NULL, &ctx->global_rtrack, ctx->fs->io);
-#endif
+	print_resource_track(NULL, &ctx->global_rtrack, ctx->fs->io, ctx);
+
 	ext2fs_close(fs);
 	ctx->fs = NULL;
 	free(ctx->journal_name);
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 78c053c..15d378f 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -314,7 +314,7 @@ static _INLINE_ float timeval_subtract(
 }

 void print_resource_track(const char *desc, struct resource_track *track,
-			  io_channel channel)
+			  io_channel channel, e2fsck_t ctx)
 {
 #ifdef HAVE_GETRUSAGE
 	struct rusage r;
@@ -324,6 +324,11 @@ void print_resource_track(
 #endif
 	struct timeval time_end;

+	if (!(ctx->options & E2F_OPT_TIME))
+		return;
+
+	e2fsck_clear_progbar(ctx);
+
 	gettimeofday(&time_end, 0);

 	if (desc)
