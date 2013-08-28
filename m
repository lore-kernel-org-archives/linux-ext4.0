From: Robert Yang <liezhi.yang@windriver.com>
Subject: [RFC 08/10] misc/util.c: handle hardlinks
Date: Wed, 28 Aug 2013 13:25:58 +0800
Message-ID: <1377667560-20089-9-git-send-email-liezhi.yang@windriver.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <dvhart@linux.intel.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:56022 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab3H1Faw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 01:30:52 -0400
In-Reply-To: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create the file and save the source inode number when we meet the hard
link at the first time, use ext2fs_link() to link the name to the target
inode number when we meet the same source inode number again.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
---
 misc/util.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/misc/util.c b/misc/util.c
index 1a0a58c..11134db 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -314,6 +314,42 @@ void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
 	}
 }
 
+/* Link an inode number to a directory */
+static errcode_t add_link(ext2_ino_t parent_ino, ext2_ino_t ino, const char *name)
+{
+	struct ext2_inode	inode;
+	errcode_t		retval;
+	char			*func_name = "add_to_dir";
+
+	retval = ext2fs_read_inode(current_fs, ino, &inode);
+        if (retval) {
+		com_err(func_name, retval, "while reading inode %u", ino);
+		return retval;
+	}
+
+	retval = ext2fs_link(current_fs, parent_ino, name, ino, inode.i_flags);
+	if (retval == EXT2_ET_DIR_NO_SPACE) {
+		retval = ext2fs_expand_dir(current_fs, parent_ino);
+		if (retval) {
+			com_err(func_name, retval, "while expanding directory");
+			return retval;
+		}
+		retval = ext2fs_link(current_fs, parent_ino, name, ino, inode.i_flags);
+	}
+	if (retval) {
+		com_err(func_name, retval, "while linking %s", name);
+		return retval;
+	}
+
+	inode.i_links_count++;
+
+	retval = ext2fs_write_inode(current_fs, ino, &inode);
+	if (retval)
+		com_err(func_name, retval, "while writing inode %u", ino);
+
+	return retval;
+}
+
 /* Fill the uid, gid, mode and time for the inode */
 static void fill_inode(struct ext2_inode *inode, struct stat *st)
 {
@@ -542,6 +578,17 @@ try_again:
 	}
 }
 
+int is_hardlink(ext2_ino_t ino)
+{
+	int i;
+
+	for(i = 0; i < hdlinks.count; i++) {
+		if(hdlinks.hdl[i].src_ino == ino)
+			return i;
+	}
+	return -1;
+}
+
 /* Copy the native file to the fs */
 errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 {
@@ -640,10 +687,12 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 	struct dirent	*dent;
 	struct stat	st;
 	char		ln_target[PATH_MAX];
+	unsigned int	save_inode = 0;
 	char		*func_name = "populate_fs";
 	ext2_ino_t	ino;
 	errcode_t	retval;
 	int		read_cnt;
+	int		hdlink;
 
 	root = EXT2_ROOT_INO;
 
@@ -665,6 +714,21 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 		lstat(dent->d_name, &st);
 		name = dent->d_name;
 
+		/* Check for hardlinks */
+		if (!S_ISDIR(st.st_mode) && !S_ISLNK(st.st_mode) && st.st_nlink > 1) {
+			hdlink = is_hardlink(st.st_ino);
+			if (hdlink >= 0) {
+				retval = add_link(parent_ino,
+						hdlinks.hdl[hdlink].dst_ino, name);
+				if (retval) {
+					com_err(func_name, retval, "while linking %s", name);
+					return retval;
+				}
+				continue;
+			} else
+				save_inode = 1;
+		}
+
 		switch(st.st_mode & S_IFMT) {
 			case S_IFCHR:
 			case S_IFBLK:
@@ -733,6 +797,27 @@ errcode_t populate_fs(ext2_ino_t parent_ino, const char *source_dir)
 				_("while setting inode for \"%s\""), name);
 			return retval;
 		}
+
+		/* Save the hardlink ino */
+		if (save_inode) {
+			/*
+			 * Check whether need more memory, and we don't need
+			 * free() since the lifespan will be over after the fs
+			 * populated.
+			 */
+			if (hdlinks.count == hdlink_cnt) {
+				if ((hdlinks.hdl = realloc (hdlinks.hdl,
+						(hdlink_cnt + HDLINK_CNT) *
+						sizeof (struct hdlink_s))) == NULL) {
+					com_err(name, errno, "Not enough memory");
+					return errno;
+				}
+				hdlink_cnt += HDLINK_CNT;
+			}
+			hdlinks.hdl[hdlinks.count].src_ino = st.st_ino;
+			hdlinks.hdl[hdlinks.count].dst_ino = ino;
+			hdlinks.count++;
+		}
 	}
 	closedir(dh);
 	return retval;
-- 
1.8.1.2

