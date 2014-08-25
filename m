From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] mke2fs: improve the error message when a non-existent file is specified
Date: Sun, 24 Aug 2014 23:59:52 -0400
Message-ID: <1408939192-22656-5-git-send-email-tytso@mit.edu>
References: <1408939192-22656-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47278 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaHYD76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 23:59:58 -0400
In-Reply-To: <1408939192-22656-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the user does not specify the file system size, and the file does
not exist, give an error message like this:

   The file /tmp/foo.img does not exist and no size was specified.

instead of this:

    Creating regular file /tmp/foo.img
    mke2fs: Device size reported to be zero.  Invalid partition specified, or
	    partition table wasn't reread after running fdisk, due to
	    a modified partition being busy and in use.  You may need to reboot
	    to re-read your partition table.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/mke2fs.c | 2 ++
 misc/util.c   | 5 +++++
 misc/util.h   | 1 +
 3 files changed, 8 insertions(+)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index da77e3a..550e886 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1796,6 +1796,8 @@ profile_error:
 		flags |= CHECK_FS_EXIST;
 	if (!quiet)
 		flags |= VERBOSE_CREATE;
+	if (fs_blocks_count == 0)
+		flags |= NO_SIZE;
 	if (!check_plausibility(device_name, flags, &is_device) && !force)
 		proceed_question(proceed_delay);
 
diff --git a/misc/util.c b/misc/util.c
index 1fcae1d..2898830 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -198,6 +198,11 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
 	char *fs_label = NULL;
 
 	fd = ext2fs_open_file(device, fl, 0666);
+	if ((fd < 0) && (errno == ENOENT) && (flags & NO_SIZE)) {
+		fprintf(stderr, _("The file %s does not exist and no "
+				  "size was specified.\n"), device);
+		exit(1);
+	}
 	if ((fd < 0) && (errno == ENOENT) && (flags & CREATE_FILE)) {
 		fl |= O_CREAT;
 		fd = ext2fs_open_file(device, fl, 0666);
diff --git a/misc/util.h b/misc/util.h
index 476164b..f3827dd 100644
--- a/misc/util.h
+++ b/misc/util.h
@@ -22,6 +22,7 @@ extern char	*journal_location_string;
 #define CREATE_FILE	0x0002
 #define CHECK_FS_EXIST	0x0004
 #define VERBOSE_CREATE	0x0008
+#define NO_SIZE		0x0010
 
 #ifndef HAVE_STRCASECMP
 extern int strcasecmp (char *s1, char *s2);
-- 
2.1.0

