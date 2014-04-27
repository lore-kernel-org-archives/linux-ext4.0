From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/7] mke2fs, tune2fs: call proceed_question() from check_plausibility()'s caller
Date: Sat, 26 Apr 2014 20:00:29 -0400
Message-ID: <1398556834-31913-2-git-send-email-tytso@mit.edu>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34713 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbaD0AAv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Apr 2014 20:00:51 -0400
In-Reply-To: <1398556834-31913-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move the call to proceed_question() from check_plausibility() to its
caller.  This allows more fine grained control by mke2fs about when it
might want to call check_plausibility().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c  | 11 ++++++-----
 misc/tune2fs.c |  4 +++-
 misc/util.c    | 11 +++++++----
 misc/util.h    |  4 ++--
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 637ace2..3c62ede 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1749,8 +1749,9 @@ profile_error:
 	if (optind < argc)
 		usage();
 
-	if (!force)
-		check_plausibility(device_name, 0, NULL);
+	if (!check_plausibility(device_name, 0, NULL) && !force)
+		proceed_question();
+
 	check_mount(device_name, force, _("filesystem"));
 
 	/* Determine the size of the device (if possible) */
@@ -2781,9 +2782,9 @@ int main (int argc, char *argv[])
 	if (journal_device) {
 		ext2_filsys	jfs;
 
-		if (!force)
-			check_plausibility(journal_device, CHECK_BLOCK_DEV,
-					   NULL);
+		if (!check_plausibility(journal_device, CHECK_BLOCK_DEV,
+					NULL) && !force)
+			proceed_question();
 		check_mount(journal_device, force, _("journal"));
 
 		retval = ext2fs_open(journal_device, EXT2_FLAG_RW|
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index d61dbfb..fbf5f52 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -673,7 +673,9 @@ static int add_journal(ext2_filsys fs)
 		goto err;
 	}
 	if (journal_device) {
-		check_plausibility(journal_device, CHECK_BLOCK_DEV, NULL);
+		if (!check_plausibility(journal_device, CHECK_BLOCK_DEV,
+					NULL))
+			proceed_question();
 		check_mount(journal_device, 0, _("journal"));
 #ifdef CONFIG_TESTIO_DEBUG
 		if (getenv("TEST_IO_FLAGS") || getenv("TEST_IO_BLOCK")) {
diff --git a/misc/util.c b/misc/util.c
index 0c3787c..08ec761 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -80,7 +80,10 @@ void proceed_question(void)
 		exit(1);
 }
 
-void check_plausibility(const char *device, int flags, int *ret_is_dev)
+/*
+ * return 1 if the device looks plausible
+ */
+int check_plausibility(const char *device, int flags, int *ret_is_dev)
 {
 	int val, is_dev = 0;
 	ext2fs_struct_stat s;
@@ -107,8 +110,7 @@ void check_plausibility(const char *device, int flags, int *ret_is_dev)
 
 	if ((flags & CHECK_BLOCK_DEV) && !is_dev) {
 		printf(_("%s is not a block special device.\n"), device);
-		proceed_question();
-		return;
+		return 0;
 	}
 
 #ifdef HAVE_LINUX_MAJOR_H
@@ -137,9 +139,10 @@ void check_plausibility(const char *device, int flags, int *ret_is_dev)
 	      MINOR(s.st_rdev)%16 == 0))) {
 		printf(_("%s is entire device, not just one partition!\n"),
 		       device);
-		proceed_question();
+		return 0;
 	}
 #endif
+	return 1;
 }
 
 void check_mount(const char *device, int force, const char *type)
diff --git a/misc/util.h b/misc/util.h
index 470556a..867f4b0 100644
--- a/misc/util.h
+++ b/misc/util.h
@@ -25,8 +25,8 @@ extern int strcasecmp (char *s1, char *s2);
 #endif
 extern char *get_progname(char *argv_zero);
 extern void proceed_question(void);
-extern void check_plausibility(const char *device, int flags,
-			       int *ret_is_dev);
+extern int check_plausibility(const char *device, int flags,
+			      int *ret_is_dev);
 extern void parse_journal_opts(const char *opts);
 extern void check_mount(const char *device, int force, const char *type);
 extern unsigned int figure_journal_size(int size, ext2_filsys fs);
-- 
1.9.0

