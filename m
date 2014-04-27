From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/7] mke2fs: don't ask the proceed question using a regular file
Date: Sat, 26 Apr 2014 20:00:28 -0400
Message-ID: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34698 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbaD0AAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Apr 2014 20:00:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Very often people are creating file systems using regular files, so we
shouldn't ask the user to confirm using the proceed question.
Otherwise it encourages users to use the -F flag, which is a bad
thing.

We do need to continue to check if the external journal device is a
block device.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c  |  5 +++--
 misc/tune2fs.c |  2 +-
 misc/util.c    | 16 ++++++++++------
 misc/util.h    |  8 +++++++-
 4 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 176dc40..637ace2 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1750,7 +1750,7 @@ profile_error:
 		usage();
 
 	if (!force)
-		check_plausibility(device_name);
+		check_plausibility(device_name, 0, NULL);
 	check_mount(device_name, force, _("filesystem"));
 
 	/* Determine the size of the device (if possible) */
@@ -2782,7 +2782,8 @@ int main (int argc, char *argv[])
 		ext2_filsys	jfs;
 
 		if (!force)
-			check_plausibility(journal_device);
+			check_plausibility(journal_device, CHECK_BLOCK_DEV,
+					   NULL);
 		check_mount(journal_device, force, _("journal"));
 
 		retval = ext2fs_open(journal_device, EXT2_FLAG_RW|
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 3359c4a..d61dbfb 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -673,7 +673,7 @@ static int add_journal(ext2_filsys fs)
 		goto err;
 	}
 	if (journal_device) {
-		check_plausibility(journal_device);
+		check_plausibility(journal_device, CHECK_BLOCK_DEV, NULL);
 		check_mount(journal_device, 0, _("journal"));
 #ifdef CONFIG_TESTIO_DEBUG
 		if (getenv("TEST_IO_FLAGS") || getenv("TEST_IO_BLOCK")) {
diff --git a/misc/util.c b/misc/util.c
index 92ab79f..0c3787c 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -80,9 +80,9 @@ void proceed_question(void)
 		exit(1);
 }
 
-void check_plausibility(const char *device)
+void check_plausibility(const char *device, int flags, int *ret_is_dev)
 {
-	int val;
+	int val, is_dev = 0;
 	ext2fs_struct_stat s;
 
 	val = ext2fs_stat(device, &s);
@@ -95,13 +95,17 @@ void check_plausibility(const char *device)
 				"did you specify it correctly?\n"), stderr);
 		exit(1);
 	}
+	if (S_ISBLK(s.st_mode))
+		is_dev = 1;
 #if defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
 	/* On FreeBSD, all disk devices are character specials */
-	if (!S_ISBLK(s.st_mode) && !S_ISCHR(s.st_mode))
-#else
-	if (!S_ISBLK(s.st_mode))
+	if (S_ISCHR(s.st_mode))
+		is_dev = 1;
 #endif
-	{
+	if (ret_is_dev)
+		*ret_is_dev = is_dev;
+
+	if ((flags & CHECK_BLOCK_DEV) && !is_dev) {
 		printf(_("%s is not a block special device.\n"), device);
 		proceed_question();
 		return;
diff --git a/misc/util.h b/misc/util.h
index 11604d0..470556a 100644
--- a/misc/util.h
+++ b/misc/util.h
@@ -15,12 +15,18 @@ extern int	 journal_flags;
 extern char	*journal_device;
 extern char	*journal_location_string;
 
+/*
+ * Flags for check_plausibility()
+ */
+#define CHECK_BLOCK_DEV	0x0001
+
 #ifndef HAVE_STRCASECMP
 extern int strcasecmp (char *s1, char *s2);
 #endif
 extern char *get_progname(char *argv_zero);
 extern void proceed_question(void);
-extern void check_plausibility(const char *device);
+extern void check_plausibility(const char *device, int flags,
+			       int *ret_is_dev);
 extern void parse_journal_opts(const char *opts);
 extern void check_mount(const char *device, int force, const char *type);
 extern unsigned int figure_journal_size(int size, ext2_filsys fs);
-- 
1.9.0

