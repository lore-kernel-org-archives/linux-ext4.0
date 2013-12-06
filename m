From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 13/30] debugfs: make stat command support inline data
Date: Fri,  6 Dec 2013 17:58:00 +0800
Message-ID: <1386323897-2354-14-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55752 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab3LFJzy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:54 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so753501pdj.11
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:54 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

If there is an inode with inline data, we just print the size of inline
data in stat command.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c        |   12 ++++++++++++
 lib/ext2fs/ext2fsP.h     |    2 ++
 lib/ext2fs/inline_data.c |   23 +++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index e600d58..ef5f201 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -729,6 +729,16 @@ static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino,
 		fprintf(f, "\n");
 }
 
+static void dump_inline_data(FILE *out, const char *prefix, ext2_ino_t inode_num)
+{
+	errcode_t retval;
+	size_t size;
+
+	retval = ext2fs_inline_data_size(current_fs, inode_num, &size);
+	if (!retval)
+		fprintf(out, "%sSize of inline data: %d", prefix, size);
+}
+
 void internal_dump_inode(FILE *out, const char *prefix,
 			 ext2_ino_t inode_num, struct ext2_inode *inode,
 			 int do_dump_blocks)
@@ -863,6 +873,8 @@ void internal_dump_inode(FILE *out, const char *prefix,
 		if (inode->i_flags & EXT4_EXTENTS_FL)
 			dump_extents(out, prefix, inode_num,
 				     DUMP_LEAF_EXTENTS|DUMP_NODE_EXTENTS, 0, 0);
+		else if (inode->i_flags & EXT4_INLINE_DATA_FL)
+			dump_inline_data(out, prefix, inode_num);
 		else
 			dump_blocks(out, prefix, inode_num);
 	}
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 5ab6084..aae55b9 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -88,6 +88,8 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
 				    int			ref_offset,
 				    void		*priv_data);
 
+extern errcode_t ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino,
+					 size_t *size);
 extern errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
 				      ext2_ino_t ino,
 				      int (*func)(ext2_filsys fs,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index b768b9a..151a9df 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -78,6 +78,29 @@ err:
 }
 
 
+errcode_t ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino, size_t *size)
+{
+	struct ext2_inode inode;
+	struct ext2_inline_data data;
+	errcode_t retval;
+
+	retval = ext2fs_read_inode(fs, ino, &inode);
+	if (retval)
+		return retval;
+
+	if (!(inode.i_flags & EXT4_INLINE_DATA_FL))
+		return EXT2_ET_NO_INLINE_DATA;
+
+	data.fs = fs;
+	data.ino = ino;
+	retval = ext2fs_inline_data_ea_get(&data);
+	if (retval)
+		return retval;
+
+	*size = EXT4_MIN_INLINE_DATA_SIZE + data.ea_size;
+	return ext2fs_free_mem(&data.ea_data);
+}
+
 errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
 			       ext2_ino_t ino,
 			       int (*func)(ext2_filsys fs,
-- 
1.7.9.7

