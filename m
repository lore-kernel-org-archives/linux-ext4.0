From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH 07/10] misc/create_inode.c: set owner/mode/time for the inode
Date: Mon, 23 Dec 2013 07:09:57 -0500
Message-ID: <1387800600-13718-8-git-send-email-liezhi.yang@windriver.com>
References: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:52665 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab3LWMKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Dec 2013 07:10:17 -0500
In-Reply-To: <1387800600-13718-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set the uid, gid, mode and time for inode.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/create_inode.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 95acffe..afe8567 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -10,6 +10,41 @@
 #define S_BLKSIZE 512
 #endif
 
+/* Fill the uid, gid, mode and time for the inode */
+static void fill_inode(struct ext2_inode *inode, struct stat *st)
+{
+	if (st != NULL) {
+		inode->i_uid = st->st_uid;
+		inode->i_gid = st->st_gid;
+		inode->i_mode |= st->st_mode;
+		inode->i_atime = st->st_atime;
+		inode->i_mtime = st->st_mtime;
+		inode->i_ctime = st->st_ctime;
+	}
+}
+
+/* Set the uid, gid, mode and time for the inode */
+errcode_t set_inode_extra(ext2_ino_t cwd, ext2_ino_t ino, struct stat *st)
+{
+	errcode_t		retval;
+	struct ext2_inode	inode;
+	char			*func_name = "set_inode_extra";
+
+	retval = ext2fs_read_inode(current_fs, ino, &inode);
+        if (retval) {
+		com_err(func_name, retval, "while reading inode %u", ino);
+		return retval;
+	}
+
+	fill_inode(&inode, st);
+
+	retval = ext2fs_write_inode(current_fs, ino, &inode);
+	if (retval) {
+		com_err(func_name, retval, "while writing inode %u", ino);
+		return retval;
+	}
+}
+
 /* Make a special file which is block, character and fifo */
 errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 {
@@ -435,6 +470,17 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 				com_err(func_name, 0,
 					_("ignoring entry \"%s\""), name);
 		}
+
+		if ((retval =  ext2fs_namei(current_fs, root, parent_ino, name, &ino))){
+			com_err(name, retval, 0);
+			return retval;
+		}
+
+		if ((retval = set_inode_extra(parent_ino, ino, &st))) {
+			com_err(func_name, retval,
+				_("while setting inode for \"%s\""), name);
+			return retval;
+		}
 	}
 	closedir(dh);
 	return retval;
-- 
1.7.10.4

