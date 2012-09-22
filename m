From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 06/21 v5] debugfs: make stat command support inline data
Date: Sat, 22 Sep 2012 12:00:54 +0800
Message-ID: <1348286469-31690-7-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2IVDvJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:09 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873873pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:09 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c        |   13 ++++++++++++-
 lib/ext2fs/ext2fs.h      |    1 +
 lib/ext2fs/inline_data.c |   30 ++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index aec61ab..2099478 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -706,6 +706,15 @@ static void dump_extents(FILE *f, const char *prefix, ext2_ino_t ino,
 		fprintf(f, "\n");
 }
 
+void dump_inline_data(FILE *out, const char *prefix, ext2_ino_t inode_num)
+{
+	int size;
+
+	fprintf(out, "%sINLINE DATA:\n%s", prefix, prefix);
+	size = ext2fs_get_inline_data_size(current_fs, inode_num);
+	fprintf(out, "  The size of inline data: %d", size);
+}
+
 void internal_dump_inode(FILE *out, const char *prefix,
 			 ext2_ino_t inode_num, struct ext2_inode *inode,
 			 int do_dump_blocks)
@@ -836,7 +845,9 @@ void internal_dump_inode(FILE *out, const char *prefix,
 		fprintf(out, "%sDevice major/minor number: %02d:%02d (hex %02x:%02x)\n",
 			devnote, major, minor, major, minor);
 	} else if (do_dump_blocks) {
-		if (inode->i_flags & EXT4_EXTENTS_FL)
+		if (inode->i_flags & EXT4_INLINE_DATA_FL)
+			dump_inline_data(out, prefix, inode_num);
+		else if (inode->i_flags & EXT4_EXTENTS_FL)
 			dump_extents(out, prefix, inode_num,
 				     DUMP_LEAF_EXTENTS|DUMP_NODE_EXTENTS, 0, 0);
 		else
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 51dbad4..25a8e98 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1331,6 +1331,7 @@ errcode_t ext2fs_icount_validate(ext2_icount_t icount, FILE *);
 
 /* inline_data.c */
 extern int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino);
+extern int ext2fs_get_inline_data_size(ext2_filsys fs, ext2_ino_t ino);
 extern int ext2fs_inline_data_iterate(ext2_filsys fs,
 				      ext2_ino_t ino,
 				      int flags,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 0652079..5570aa0 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -79,6 +79,36 @@ int ext2fs_inode_has_inline_data(ext2_filsys fs, ext2_ino_t ino)
 	return (inode.i_flags & EXT4_INLINE_DATA_FL);
 }
 
+int ext2fs_get_inline_data_size(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct inline_data data;
+	struct ext2_inode_large *inode;
+	errcode_t retval = 0;
+	int inline_size = 0;
+
+	if (!ext2fs_inode_has_inline_data(fs, ino))
+		return 0;
+
+	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	if (retval)
+		return 0;
+
+	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
+					EXT2_INODE_SIZE(fs->super));
+	if (retval)
+		goto out;
+
+	retval = ext2fs_iget_extra_inode(fs, inode, &data);
+	if (retval)
+		goto out;
+
+	inline_size = data.inline_size;
+
+out:
+	ext2fs_free_mem(&inode);
+	return inline_size;
+}
+
 int ext2fs_inline_data_iterate(ext2_filsys fs,
 			       ext2_ino_t ino,
 			       int flags,
-- 
1.7.4.1

