From: Robert Yang <liezhi.yang@windriver.com>
Subject: [RFC 07/10] misc/util.c: set more information for inode
Date: Wed, 28 Aug 2013 13:25:57 +0800
Message-ID: <1377667560-20089-8-git-send-email-liezhi.yang@windriver.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:63334 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3H1Fap (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 01:30:45 -0400
In-Reply-To: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set the uid, gid, mode and time for inode.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/util.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/misc/util.c b/misc/util.c
index 7a45120..1a0a58c 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -314,6 +314,41 @@ void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
 	}
 }
 
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
@@ -687,6 +722,17 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
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
1.8.1.2

