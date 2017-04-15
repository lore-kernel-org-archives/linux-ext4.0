From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] e2fsck: allow extent tree optimization to be disabled
Date: Sat, 15 Apr 2017 09:41:18 -0400
Message-ID: <20170415134118.17808-3-tytso@mit.edu>
References: <20170415134118.17808-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39898 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754160AbdDONl0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 15 Apr 2017 09:41:26 -0400
In-Reply-To: <20170415134118.17808-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add an extended option, -E no_optimize_extents, as well as a
e2fsck.conf profile option, to disable extent tree optimization.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/e2fsck.8.in      | 4 ++++
 e2fsck/e2fsck.conf.5.in | 4 ++++
 e2fsck/e2fsck.h         | 1 +
 e2fsck/extents.c        | 3 +++
 e2fsck/unix.c           | 8 ++++++++
 5 files changed, 20 insertions(+)

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 915273d8..4ad575f4 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -226,6 +226,10 @@ option may prevent you from further manual data recovery.
 Do not attempt to discard free blocks and unused inode blocks. This option is
 exactly the opposite of discard option. This is set as default.
 .TP
+.BI no_optimize_extents
+Do not offer to optimize the extent tree by eliminating unnecessary
+width or depth.
+.TP
 .BI readahead_kb
 Use this many KiB of memory to pre-fetch metadata in the hopes of reducing
 e2fsck runtime.  By default, this is set to the size of two block groups' inode
diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index 0bfc76ab..94525baf 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -205,6 +205,10 @@ of that type are squelched.  This can be useful if the console is slow
 (i.e., connected to a serial port) and so a large amount of output could
 end up delaying the boot process for a long time (potentially hours).
 .TP
+.I no_optimize_extents
+Do not offer to optimize the extent tree by eliminating unnecessary
+width or depth.
+.TP
 .I readahead_mem_pct
 Use this percentage of memory to try to read in metadata blocks ahead of the
 main e2fsck thread.  This should reduce run times, depending on the speed of
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index ecd3b1e1..a4b5fb24 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -169,6 +169,7 @@ struct resource_track {
 #define E2F_OPT_DISCARD		0x2000
 #define E2F_OPT_CONVERT_BMAP	0x4000 /* convert blockmap to extent */
 #define E2F_OPT_FIXES_ONLY	0x8000 /* skip all optimizations */
+#define E2F_OPT_NOOPT_EXTENTS	0x10000 /* don't optimize extents */
 
 /*
  * E2fsck flags
diff --git a/e2fsck/extents.c b/e2fsck/extents.c
index 1df31d71..d9410028 100644
--- a/e2fsck/extents.c
+++ b/e2fsck/extents.c
@@ -518,6 +518,9 @@ errcode_t e2fsck_should_rebuild_extents(e2fsck_t ctx,
 	if (eti->force_rebuild)
 		goto rebuild;
 
+	if (ctx->options & E2F_OPT_NOOPT_EXTENTS)
+		return 0;
+
 	extents_per_block = (ctx->fs->blocksize -
 			     sizeof(struct ext3_extent_header)) /
 			    sizeof(struct ext3_extent);
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index b7322bc6..b6025535 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -709,6 +709,9 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		} else if (strcmp(token, "nodiscard") == 0) {
 			ctx->options &= ~E2F_OPT_DISCARD;
 			continue;
+		} else if (strcmp(token, "no_optimize_extents") == 0) {
+			ctx->options |= E2F_OPT_NOOPT_EXTENTS;
+			continue;
 		} else if (strcmp(token, "log_filename") == 0) {
 			if (!arg)
 				extended_usage++;
@@ -1007,6 +1010,11 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	if (c)
 		verbose = 1;
 
+	profile_get_boolean(ctx->profile, "options", "no_optimize_extents",
+			    0, 0, &c);
+	if (c)
+		ctx->options |= E2F_OPT_NOOPT_EXTENTS;
+
 	if (ctx->readahead_kb == ~0ULL) {
 		profile_get_integer(ctx->profile, "options",
 				    "readahead_mem_pct", 0, -1, &c);
-- 
2.11.0.rc0.7.gbe5a750
