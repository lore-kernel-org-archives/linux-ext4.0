From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2 1/3] mke2fs: print a message when creating a regular file
Date: Mon,  5 May 2014 21:02:11 -0400
Message-ID: <1399338133-21373-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50984 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933395AbaEFBCV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 21:02:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We've added the ability to automatically recreate a file if it doesn't
exist prior to creating the file system, since this is often used (for
example) when managing file system images for use in virtual machines.
We should at least notify the user that this is going on to avoid
surprises in the case of misspelled device/file names.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.c |  6 ++++--
 misc/util.c   | 11 +++++++----
 misc/util.h   |  1 +
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 2c51999..51532ef 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -103,6 +103,7 @@ static int	quotatype = -1;  /* Initialize both user and group quotas by default
 static __u64	offset;
 static blk64_t journal_location = ~0LL;
 static int	proceed_delay = -1;
+static blk64_t	dev_size;
 
 static struct ext2_super_block fs_param;
 static char *fs_uuid = NULL;
@@ -1402,7 +1403,6 @@ static void PRS(int argc, char *argv[])
 	char *		extended_opts = 0;
 	char *		fs_type = 0;
 	char *		usage_types = 0;
-	blk64_t		dev_size;
 	/*
 	 * NOTE: A few words about fs_blocks_count and blocksize:
 	 *
@@ -1768,6 +1768,8 @@ profile_error:
 	flags = CREATE_FILE;
 	if (isatty(0) && isatty(1))
 		flags |= CHECK_FS_EXIST;
+	if (!quiet)
+		flags |= VERBOSE_CREATE;
 	if (!check_plausibility(device_name, flags, &is_device) && !force)
 		proceed_question(proceed_delay);
 
@@ -2573,7 +2575,7 @@ int main (int argc, char *argv[])
 		journal_blocks = figure_journal_size(journal_size, fs);
 
 	/* Can't undo discard ... */
-	if (!noaction && discard && (io_ptr != undo_io_manager)) {
+	if (!noaction && discard && dev_size && (io_ptr != undo_io_manager)) {
 		retval = mke2fs_discard_device(fs);
 		if (!retval && io_channel_discard_zeroes_data(fs->io)) {
 			if (verbose)
diff --git a/misc/util.c b/misc/util.c
index be16ebe..15b4ce5 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -106,7 +106,7 @@ void proceed_question(int delay)
 }
 
 /*
- * return 1 if the device looks plausible
+ * return 1 if the device looks plausible, creating the file if necessary
  */
 int check_plausibility(const char *device, int flags, int *ret_is_dev)
 {
@@ -117,10 +117,13 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
 	char *fs_type = NULL;
 	char *fs_label = NULL;
 
-	if (flags & CREATE_FILE)
-		fl |= O_CREAT;
-
 	fd = open(device, fl, 0666);
+	if ((fd < 0) && (errno == ENOENT) && (flags & CREATE_FILE)) {
+		fl |= O_CREAT;
+		fd = open(device, fl, 0666);
+		if (fd >= 0 && (flags & VERBOSE_CREATE))
+			printf(_("Creating regular file %s\n"), device);
+	}
 	if (fd < 0) {
 		fprintf(stderr, _("Could not open %s: %s\n"),
 			device, error_message(errno));
diff --git a/misc/util.h b/misc/util.h
index 745568e..476164b 100644
--- a/misc/util.h
+++ b/misc/util.h
@@ -21,6 +21,7 @@ extern char	*journal_location_string;
 #define CHECK_BLOCK_DEV	0x0001
 #define CREATE_FILE	0x0002
 #define CHECK_FS_EXIST	0x0004
+#define VERBOSE_CREATE	0x0008
 
 #ifndef HAVE_STRCASECMP
 extern int strcasecmp (char *s1, char *s2);
-- 
1.9.0

