From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 10/21 v5] debugfs: handle inline_data feature in dirsearch command
Date: Sat, 22 Sep 2012 12:00:58 +0800
Message-ID: <1348286469-31690-11-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45536 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2IVDvR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:17 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873803pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:17 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Inode with inline_data hasn't any blocks.  So we need to handle it in a new
function.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/htree.c          |    7 ++++
 lib/ext2fs/ext2fs.h      |    2 +
 lib/ext2fs/inline_data.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 1932962..eb71a40 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -374,9 +374,16 @@ void do_dirsearch(int argc, char *argv[])
 	pb.search_name = argv[2];
 	pb.len = strlen(pb.search_name);
 
+	if (ext2fs_inode_has_inline_data(current_fs, inode)) {
+		ext2fs_inline_data_dirsearch(current_fs, inode,
+					     argv[2], strlen(argv[2]));
+		goto out;
+	}
+
 	ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, 0,
 			      search_dir_block, &pb);
 
+out:
 	free(pb.buf);
 }
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 801e2dd..9b7d608 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1354,6 +1354,8 @@ extern errcode_t ext2fs_write_inline_data(ext2_filsys fs, ext2_ino_t ino,
 extern errcode_t ext2fs_try_to_write_inline_data(ext2_filsys fs, ext2_ino_t ino,
 						 const void *buf, unsigned int nbytes,
 						 unsigned int *written);
+extern errcode_t ext2fs_inline_data_dirsearch(ext2_filsys fs, ext2_ino_t ino,
+					      const char *name, size_t namelen);
 
 /* inode.c */
 extern errcode_t ext2fs_flush_icache(ext2_filsys fs);
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index a847b68..402bc10 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -36,6 +36,8 @@ static int ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
 static errcode_t ext2fs_create_inline_data(ext2_filsys fs,
 					   struct ext2_inode_large *inode,
 					   int len);
+static int do_search_dir(ext2_filsys fs, void *start, int size,
+			 const char *name, size_t len);
 
 static int ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode_large *inode,
 				    struct inline_data *data)
@@ -117,6 +119,93 @@ static int ext2fs_inline_data_destory_data(ext2_filsys fs, ext2_ino_t ino,
 	return 0;
 }
 
+static int do_search_dir(ext2_filsys fs, void *start, int size,
+			 const char *name, size_t len)
+{
+	struct ext2_dir_entry *de;
+	unsigned offset = 0;
+	unsigned rec_len;
+	errcode_t errcode;
+
+	while (offset < len) {
+		de = (struct ext2_dir_entry *)(start + offset);
+		errcode = ext2fs_get_rec_len(fs, de, &rec_len);
+		if (errcode) {
+			com_err("search_dir_inline_data", errcode,
+				"while getting rec_len for inline data");
+			return errcode;
+		}
+		if (de->inode &&
+		    len == (de->name_len & 0xFF) &&
+		    strncmp(name, de->name, len) == 0) {
+			printf("Entry found at inline data\n");
+			return 1;
+		}
+		offset += rec_len;
+	}
+	return 0;
+}
+
+errcode_t ext2fs_inline_data_dirsearch(ext2_filsys fs, ext2_ino_t ino,
+				       const char *name, size_t namelen)
+{
+	struct ext2_inode_large *inode;
+	struct ext2_dir_entry dirent;
+	struct inline_data data;
+	unsigned int offset = 0;
+	unsigned int rec_len;
+	void *inline_start;
+	int inline_size;
+	errcode_t retval = 0;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto out;
+
+	/* check '.' and '..' firstly */
+	dirent.inode = ino;
+	dirent.name_len = 1;
+	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(2), &dirent);
+	dirent.name[0] = '.';
+	retval = do_search_dir(fs, (void *)&dirent, dirent.rec_len, name, namelen);
+	if (retval)
+		goto out;
+
+	dirent.inode = ((struct ext2_dir_entry *)inode->i_block)->inode;
+	dirent.name_len = 2;
+	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(3), &dirent);
+	dirent.name[0] = '.';
+	dirent.name[1] = '.';
+	retval = do_search_dir(fs, (void *)&dirent, dirent.rec_len, name, namelen);
+	if (retval)
+		goto out;
+
+	inline_start = (void *)inode->i_block + EXT4_INLINE_DATA_DOTDOT_SIZE;
+	inline_size = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DATA_DOTDOT_SIZE;
+	retval = do_search_dir(fs, inline_start, inline_size, name, namelen);
+	if (retval)
+		goto out;
+
+	retval = ext2fs_iget_extra_inode(fs, inode, &data);
+	if (retval)
+		goto out;
+	if (data.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
+		goto out;
+
+	inline_start = ext2fs_get_inline_xattr_pos(inode, &data);
+	inline_size = data.inline_size - EXT4_MIN_INLINE_DATA_SIZE;
+	retval = do_search_dir(fs, inline_start, inline_size, name, namelen);
+
+out:
+	ext2fs_free_mem(&inode);
+	return retval;
+}
+
 int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
-- 
1.7.4.1

