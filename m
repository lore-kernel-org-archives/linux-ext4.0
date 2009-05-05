From: Ken Chen <kenchen@google.com>
Subject: [patch] e2fsprogs - add resource track for e2fsck
Date: Mon, 4 May 2009 20:12:30 -0700
Message-ID: <b040c32a0905042012j1483fca1o27db92082605f313@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:8767 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZEEDMo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2009 23:12:44 -0400
Received: from spaceape11.eur.corp.google.com (spaceape11.eur.corp.google.com [172.28.16.145])
	by smtp-out.google.com with ESMTP id n453ChxE012801
	for <linux-ext4@vger.kernel.org>; Tue, 5 May 2009 04:12:43 +0100
Received: from yx-out-1718.google.com (yxh36.prod.google.com [10.190.2.228])
	by spaceape11.eur.corp.google.com with ESMTP id n453CfkA019393
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 20:12:42 -0700
Received: by yx-out-1718.google.com with SMTP id 36so2639371yxh.6
        for <linux-ext4@vger.kernel.org>; Mon, 04 May 2009 20:12:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds individual resource tracking for e2fsck's pass1[b-d] phase.

On ext2, time tracking for pass1 includes both error detection and
specific type of fs fix-up phase (e.g. block referenced by multiple
inodes).  The multi-reference fix-up phase some time take significant
amount of time to complete.  We would like to track time spent in sub
component of pass1 by having a finer granularity during pass1b through
pass1d phase.

Signed-off-by: Ken Chen <kenchen@google.com>


diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 809bd7f..008d079 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -208,6 +208,9 @@ void e2fsck_pass1_dupblocks(
 {
 	ext2_filsys 		fs = ctx->fs;
 	struct problem_context	pctx;
+#ifdef RESOURCE_TRACK
+	struct resource_track	rtrack;
+#endif

 	clear_problem_context(&pctx);

@@ -224,10 +227,39 @@ void e2fsck_pass1_dupblocks(
 	dict_set_allocator(&ino_dict, NULL, inode_dnode_free, NULL);
 	dict_set_allocator(&blk_dict, NULL, block_dnode_free, NULL);

+#ifdef RESOURCE_TRACK
+	init_resource_track(&rtrack, ctx->fs->io);
+#endif
+
 	pass1b(ctx, block_buf);
+
+#ifdef RESOURCE_TRACK
+	if (ctx->options & E2F_OPT_TIME2) {
+		e2fsck_clear_progbar(ctx);
+		print_resource_track("Pass 1b", &rtrack, ctx->fs->io);
+	}
+	init_resource_track(&rtrack, ctx->fs->io);
+#endif
+
 	pass1c(ctx, block_buf);
+
+#ifdef RESOURCE_TRACK
+	if (ctx->options & E2F_OPT_TIME2) {
+		e2fsck_clear_progbar(ctx);
+		print_resource_track("Pass 1c", &rtrack, ctx->fs->io);
+	}
+	init_resource_track(&rtrack, ctx->fs->io);
+#endif
+
 	pass1d(ctx, block_buf);

+#ifdef RESOURCE_TRACK
+	if (ctx->options & E2F_OPT_TIME2) {
+		e2fsck_clear_progbar(ctx);
+		print_resource_track("Pass 1d", &rtrack, ctx->fs->io);
+	}
+#endif
+
 	/*
 	 * Time to free all of the accumulated data structures that we
 	 * don't need anymore.
