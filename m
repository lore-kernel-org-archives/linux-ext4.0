From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH V2 06/11] misc/create_inode.c: create directory
Date: Tue, 24 Dec 2013 03:47:22 -0500
Message-ID: <1387874847-4922-7-git-send-email-liezhi.yang@windriver.com>
References: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:40453 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3LXIrm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Dec 2013 03:47:42 -0500
In-Reply-To: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The do_mkdir_internal() is used for making dir on the target fs, most of
the code are from debugfs/debugfs.c, the debugfs/debugfs.c will be
modified to use this function.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
---
 misc/create_inode.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index d199bf4..be967bd 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -127,6 +127,37 @@ try_again:
 /* Make a directory in the fs */
 errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 {
+	char			*cp;
+	ext2_ino_t		parent_ino, ino;
+	errcode_t		retval;
+	struct ext2_inode	inode;
+
+
+	cp = strrchr(name, '/');
+	if (cp) {
+		*cp = 0;
+		if ((retval =  ext2fs_namei(current_fs, root, cwd, name, &parent_ino))){
+			com_err(name, retval, 0);
+			return retval;
+		}
+		name = cp+1;
+	} else
+		parent_ino = cwd;
+
+try_again:
+	retval = ext2fs_mkdir(current_fs, parent_ino, 0, name);
+	if (retval == EXT2_ET_DIR_NO_SPACE) {
+		retval = ext2fs_expand_dir(current_fs, parent_ino);
+		if (retval) {
+			com_err(__FUNCTION__, retval, "while expanding directory");
+			return retval;
+		}
+		goto try_again;
+	}
+	if (retval) {
+		com_err("ext2fs_mkdir", retval, 0);
+		return retval;
+	}
 }
 
 static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_holes)
-- 
1.7.10.4

