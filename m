From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH V2 07/11] misc/create_inode.c: set owner/mode/time for the inode
Date: Tue, 24 Dec 2013 03:47:23 -0500
Message-ID: <1387874847-4922-8-git-send-email-liezhi.yang@windriver.com>
References: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:51144 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3LXIro (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Dec 2013 03:47:44 -0500
In-Reply-To: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set the uid, gid, mode and time for inode.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
---
 misc/create_inode.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index be967bd..f1af6a9 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -10,6 +10,40 @@
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
+
+	retval = ext2fs_read_inode(current_fs, ino, &inode);
+        if (retval) {
+		com_err(__FUNCTION__, retval, "while reading inode %u", ino);
+		return retval;
+	}
+
+	fill_inode(&inode, st);
+
+	retval = ext2fs_write_inode(current_fs, ino, &inode);
+	if (retval) {
+		com_err(__FUNCTION__, retval, "while writing inode %u", ino);
+		return retval;
+	}
+}
+
 /* Make a special file which is block, character and fifo */
 errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
 {
@@ -427,6 +461,17 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 				com_err(__FUNCTION__, 0,
 					_("ignoring entry \"%s\""), name);
 		}
+
+		if ((retval =  ext2fs_namei(current_fs, root, parent_ino, name, &ino))){
+			com_err(name, retval, 0);
+			return retval;
+		}
+
+		if ((retval = set_inode_extra(parent_ino, ino, &st))) {
+			com_err(__FUNCTION__, retval,
+				_("while setting inode for \"%s\""), name);
+			return retval;
+		}
 	}
 	closedir(dh);
 	return retval;
-- 
1.7.10.4

