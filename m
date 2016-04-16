From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] Fix support for configure --enable-jbd-debug
Date: Fri, 15 Apr 2016 21:13:42 -0400
Message-ID: <1460769225-31398-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34974 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbcDPBNu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2016 21:13:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We haven't used this in a while, so it's bitrotted a bit.  Fix it up
so that it works correctly.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 debugfs/debugfs.c       | 22 +++++++++++++++++++++-
 e2fsck/unix.c           |  2 +-
 lib/ext2fs/kernel-jbd.h | 12 ++++++++++++
 misc/fuse2fs.c          |  4 ++++
 misc/tune2fs.c          |  4 ++++
 5 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 0cf0837..ba8be40 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -41,6 +41,10 @@ extern char *optarg;
 #define BUFSIZ 8192
 #endif
 
+#ifdef CONFIG_JBD_DEBUG		/* Enabled by configure --enable-jbd-debug */
+int journal_enable_debug = -1;
+#endif
+
 ss_request_table *extra_cmds;
 const char *debug_prog_name;
 int sci_idx;
@@ -76,7 +80,7 @@ static int debugfs_setup_tdb(const char *device_name, char *undo_file,
 	 * Configuration via a conf file would be
 	 * nice
 	 */
-	tdb_dir = getenv("E2FSPROGS_UNDO_DIR");
+	tdb_dir = ss_safe_getenv("E2FSPROGS_UNDO_DIR");
 	if (!tdb_dir)
 		tdb_dir = "/var/lib/e2fsprogs";
 
@@ -2395,6 +2399,9 @@ int main(int argc, char **argv)
 	const char	*opt_string = "niwcR:f:b:s:Vd:Dz:";
 	char		*undo_file = NULL;
 #endif
+#ifdef CONFIG_JBD_DEBUG
+	char		*jbd_debug;
+#endif
 
 	if (debug_prog_name == 0)
 #ifdef READ_ONLY
@@ -2406,6 +2413,19 @@ int main(int argc, char **argv)
 	fprintf (stderr, "%s %s (%s)\n", debug_prog_name,
 		 E2FSPROGS_VERSION, E2FSPROGS_DATE);
 
+#ifdef CONFIG_JBD_DEBUG
+	jbd_debug = ss_safe_getenv("DEBUGFS_JBD_DEBUG");
+	if (jbd_debug) {
+		int res = sscanf(jbd_debug, "%d", &journal_enable_debug);
+
+		if (res != 1) {
+			fprintf(stderr,
+				"DEBUGFS_JBD_DEBUG \"%s\" not an integer\n\n",
+				jbd_debug);
+			exit(1);
+		}
+	}
+#endif
 	while ((c = getopt (argc, argv, opt_string)) != EOF) {
 		switch (c) {
 		case 'R':
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index e54e2ce..959b4dd 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -66,7 +66,7 @@ static char *bad_blocks_file;
 
 e2fsck_t e2fsck_global_ctx;	/* Try your very best not to use this! */
 
-#ifdef CONFIG_JBD_DEBUG		/* Enabled by configure --enable-jfs-debug */
+#ifdef CONFIG_JBD_DEBUG		/* Enabled by configure --enable-jbd-debug */
 int journal_enable_debug = -1;
 #endif
 
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 842809d..c1fec3f 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -46,8 +46,20 @@ extern int journal_enable_debug;
 	} while (0)
 #else
 #ifdef __GNUC__
+#ifdef __KERNEL__
 #define jbd_debug(f, a...)	/**/
 #else
+extern int journal_enable_debug;
+#define jbd_debug(n, f, a...)						\
+	do {								\
+		if ((n) <= journal_enable_debug) {			\
+			printf("(%s, %d): %s: ",			\
+				__FILE__, __LINE__, __func__);		\
+			printf(f, ## a);				\
+		}							\
+	} while (0)
+#endif /*__KERNEL__ */
+#else
 #define jbd_debug(f, ...)	/**/
 #endif
 #endif
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 4412fe3..c75527e 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -95,6 +95,10 @@ static ext2_filsys global_fs; /* Try not to use this directly */
 
 errcode_t ext2fs_run_ext3_journal(ext2_filsys *fs);
 
+#ifdef CONFIG_JBD_DEBUG		/* Enabled by configure --enable-jbd-debug */
+int journal_enable_debug = -1;
+#endif
+
 /* ACL translation stuff */
 #ifdef TRANSLATE_LINUX_ACLS
 /*
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 10ce58f..a1923f9 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -124,6 +124,10 @@ static const char *please_dir_fsck =
 void do_findfs(int argc, char **argv);
 #endif
 
+#ifdef CONFIG_JBD_DEBUG		/* Enabled by configure --enable-jbd-debug */
+int journal_enable_debug = -1;
+#endif
+
 static void usage(void)
 {
 	fprintf(stderr,
-- 
2.5.0

