From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH V2 04/11] misc/create_inode.c: create symlink
Date: Tue, 24 Dec 2013 03:47:20 -0500
Message-ID: <1387874847-4922-5-git-send-email-liezhi.yang@windriver.com>
References: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:40447 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3LXIrj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Dec 2013 03:47:39 -0500
In-Reply-To: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The do_symlink_internal() is used for creating symlinks, most of the
code are from debugfs/debugfs.c, the debugfs/debugfs.c will be modified
to use this function.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
---
 misc/create_inode.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 3cf09e4..293694a 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -80,6 +80,38 @@ errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 /* Make a symlink name -> target */
 errcode_t do_symlink_internal(ext2_ino_t cwd, const char *name, char *target)
 {
+	char			*cp;
+	ext2_ino_t		parent_ino;
+	errcode_t		retval;
+	struct ext2_inode	inode;
+	struct stat		st;
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
+	retval = ext2fs_symlink(current_fs, parent_ino, 0, name, target);
+	if (retval == EXT2_ET_DIR_NO_SPACE) {
+		retval = ext2fs_expand_dir(current_fs, parent_ino);
+		if (retval) {
+			com_err("do_symlink_internal", retval, "while expanding directory");
+			return retval;
+		}
+		goto try_again;
+	}
+	if (retval) {
+		com_err("ext2fs_symlink", retval, 0);
+		return retval;
+	}
+
 }
 
 /* Make a directory in the fs */
-- 
1.7.10.4

