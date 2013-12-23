From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 04/10] misc/create_inode.c: create symlink
Date: Mon, 23 Dec 2013 07:09:54 -0500
Message-ID: <1387800600-13718-5-git-send-email-liezhi.yang@windriver.com>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:54347 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab3LWMKL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Dec 2013 07:10:11 -0500
In-Reply-To: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The do_symlink_internal() is used for creating symlinks, most of the
code are from debugfs/debugfs.c, the debugfs/debugfs.c will be modified
to use this function.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/create_inode.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 62a40de..45c8a87 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -81,6 +81,40 @@ errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
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
+	} else {
+		parent_ino = cwd;
+		name = name;
+	}
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

