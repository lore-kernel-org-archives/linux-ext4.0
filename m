From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] mke2fs: print extra information about existing ext2/3/4 file systems
Date: Mon,  5 May 2014 09:04:03 -0400
Message-ID: <1399295044-24489-2-git-send-email-tytso@mit.edu>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49660 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaEENES (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 09:04:18 -0400
In-Reply-To: <1399295044-24489-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/util.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/misc/util.c b/misc/util.c
index 15b4ce5..d63e21b 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -105,6 +105,41 @@ void proceed_question(int delay)
 	signal(SIGALRM, SIG_IGN);
 }
 
+static void print_ext2_info(const char *device)
+
+{
+	struct ext2_super_block	*sb;
+	ext2_filsys		fs;
+	errcode_t		retval;
+	time_t 			tm;
+	char			buf[80];
+
+	retval = ext2fs_open2(device, 0, 0, 0, 0, unix_io_manager, &fs);
+	if (retval)
+		return;
+	sb = fs->super;
+
+	if (sb->s_mtime) {
+		tm = sb->s_mtime;
+		if (sb->s_last_mounted[0]) {
+			memset(buf, 0, sizeof(buf));
+			strncpy(buf, sb->s_last_mounted,
+				sizeof(sb->s_last_mounted));
+			printf(_("\tlast mounted on %s on %s"), buf,
+			       ctime(&tm));
+		} else
+			printf(_("\tlast mounted on %s"), ctime(&tm));
+	} else if (sb->s_mkfs_time) {
+		tm = sb->s_mkfs_time;
+		printf(_("\tcreated on %s"), ctime(&tm));
+	} else if (sb->s_mkfs_time) {
+		tm = sb->s_mtime;
+		printf(_("\tlast modified on %s"), ctime(&tm));
+	}
+	ext2fs_close(fs);
+}
+
+
 /*
  * return 1 if the device looks plausible, creating the file if necessary
  */
@@ -168,6 +203,8 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
 		else
 			printf(_("%s contains a %s file system\n"), device,
 			       fs_type);
+		if (strncmp(fs_type, "ext", 3) == 0)
+			print_ext2_info(device);
 		free(fs_type);
 		free(fs_label);
 		return 0;
-- 
1.9.0

