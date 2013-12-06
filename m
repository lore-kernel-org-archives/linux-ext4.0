From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 30/30] libext2fs: add a unit test for inline data
Date: Fri,  6 Dec 2013 17:58:17 +0800
Message-ID: <1386323897-2354-31-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44876 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab3LFJ4h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:37 -0500
Received: by mail-pd0-f181.google.com with SMTP id p10so741494pdj.40
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:37 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In this unit test, we will test the interface of inline data and make
sure it is fine.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/Makefile.in   |    8 +-
 lib/ext2fs/inline_data.c |  260 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 267 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 4d011c9..3419778 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -391,6 +391,11 @@ tst_inline: $(srcdir)/inline.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(Q) $(CC) -o tst_inline $(srcdir)/inline.c $(ALL_CFLAGS) -DDEBUG \
 		$(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR)
 
+tst_inline_data: inline_data.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
+	$(E) "	LD $@"
+	$(Q) $(CC) -o tst_inline_data $(srcdir)/inline_data.c $(ALL_CFLAGS) \
+	-DDEBUG $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR)
+
 tst_csum: csum.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR) $(STATIC_LIBE2P) \
 		$(top_srcdir)/lib/e2p/e2p.h
 	$(E) "	LD $@"
@@ -408,7 +413,7 @@ mkjournal: mkjournal.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
 
 check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
     tst_super_size tst_types tst_inode_size tst_csum tst_crc32c tst_bitmaps \
-    tst_inline
+    tst_inline tst_inline_data
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_bitops
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_badblocks
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_iscan
@@ -418,6 +423,7 @@ check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_inode_size
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_csum
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_inline
+	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_inline_data
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_crc32c
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) \
 		./tst_bitmaps -f $(srcdir)/tst_bitmaps_cmds > tst_bitmaps_out
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 1905121..57093cf 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -549,3 +549,263 @@ errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 	data.ea_data = buf + EXT4_MIN_INLINE_DATA_SIZE;
 	return ext2fs_inline_data_ea_set(&data);
 }
+
+#ifdef DEBUG
+#include "e2p/e2p.h"
+
+/*
+ * The length of buffer is set to 64 because in inode's i_block member it only
+ * can save 60 bytes.  Thus this value can let the data being saved in extra
+ * space.
+ */
+#define BUFF_SIZE (64)
+
+static errcode_t file_test(ext2_filsys fs)
+{
+	struct ext2_inode inode;
+	ext2_ino_t newfile;
+	errcode_t retval;
+	size_t size;
+	char *buf = 0, *cmpbuf = 0;
+	int i;
+
+	/* create a new file */
+	retval = ext2fs_new_inode(fs, 2, 010755, 0, &newfile);
+	if (retval) {
+		com_err("file_test", retval, "while allocaing a new inode");
+		return 1;
+	}
+
+	memset(&inode, 0, sizeof(inode));
+	inode.i_flags |= EXT4_INLINE_DATA_FL;
+	inode.i_size = EXT4_MIN_INLINE_DATA_SIZE;
+	inode.i_mode = LINUX_S_IFREG;
+	retval = ext2fs_write_new_inode(fs, newfile, &inode);
+	if (retval) {
+		com_err("file_test", retval, "while writting a new inode");
+		return 1;
+	}
+
+	retval = ext2fs_inline_data_init(fs, newfile);
+	if (retval) {
+		com_err("file_test", retval, "while init 'system.data'");
+		return 1;
+	}
+
+	retval = ext2fs_inline_data_size(fs, newfile, &size);
+	if (retval) {
+		com_err("file_test", retval, "while getting size");
+		return 1;
+	}
+
+	if (size != EXT4_MIN_INLINE_DATA_SIZE) {
+		fprintf(stderr,
+			"tst_inline_data: size of inline data is wrong\n");
+		return 1;
+	}
+
+	ext2fs_get_mem(BUFF_SIZE, &buf);
+	memset(buf, 'a', BUFF_SIZE);
+	retval = ext2fs_inline_data_set(fs, newfile, 0, buf, BUFF_SIZE);
+	if (retval) {
+		com_err("file_test", retval,
+			"while setting inline data %s", buf);
+		goto err;
+	}
+
+	ext2fs_get_mem(BUFF_SIZE, &cmpbuf);
+	retval = ext2fs_inline_data_get(fs, newfile, 0, cmpbuf, &size);
+	if (retval) {
+		com_err("file_test", retval, "while getting inline data");
+		goto err;
+	}
+
+	if (size != BUFF_SIZE) {
+		fprintf(stderr,
+			"tst_inline_data: size %lu != buflen %lu\n",
+			size, BUFF_SIZE);
+		retval = 1;
+		goto err;
+	}
+
+	if (memcmp(buf, cmpbuf, BUFF_SIZE)) {
+		fprintf(stderr, "tst_inline_data: buf != cmpbuf\n");
+		retval = 1;
+		goto err;
+	}
+
+	retval = ext2fs_punch(fs, newfile, 0, 0, 0, ~0ULL);
+	if (retval) {
+		com_err("file_test", retval, "while truncating inode");
+		goto err;
+	}
+
+	/* reload inode and check isize */
+	ext2fs_read_inode(fs, newfile, &inode);
+	if (inode.i_size != 0) {
+		fprintf(stderr, "tst_inline_data: i_size should be 0\n");
+		retval = 1;
+	}
+
+err:
+	if (cmpbuf)
+		ext2fs_free_mem(&cmpbuf);
+	if (buf)
+		ext2fs_free_mem(&buf);
+	return retval;
+}
+
+static errcode_t dir_test(ext2_filsys fs)
+{
+	const char *dot_name = ".";
+	const char *stub_name = "stub";
+	const char *parent_name = "test";
+	ext2_ino_t parent, dir, tmp;
+	errcode_t retval;
+	char dirname[PATH_MAX];
+	int i;
+
+	retval = ext2fs_mkdir(fs, 11, 11, stub_name);
+	if (retval) {
+		com_err("dir_test", retval, "while creating %s dir", stub_name);
+		return retval;
+	}
+
+	retval = ext2fs_mkdir(fs, 11, 0, parent_name);
+	if (retval) {
+		com_err("dir_test", retval,
+			"while creating %s dir", parent_name);
+		return retval;
+	}
+
+	retval = ext2fs_lookup(fs, 11, parent_name, strlen(parent_name),
+			       0, &parent);
+	if (retval) {
+		com_err("dir_test", retval,
+			"while looking up %s dir", parent_name);
+		return retval;
+	}
+
+	retval = ext2fs_lookup(fs, parent, dot_name, strlen(dot_name),
+			       0, &tmp);
+	if (retval) {
+		com_err("dir_test", retval,
+			"while looking up %s dir", parent_name);
+		return retval;
+	}
+
+	if (parent != tmp) {
+		fprintf(stderr, "tst_inline_data: parent (%lu) != tmp (%lu)\n",
+			parent, tmp);
+		return 1;
+	}
+
+	for (i = 0, dir = 13; i < 4; i++, dir++) {
+		tmp = 0;
+		snprintf(dirname, PATH_MAX, "%d", i);
+		retval = ext2fs_mkdir(fs, parent, 0, dirname);
+		if (retval) {
+			com_err("dir_test", retval,
+				"while creating %s dir", dirname);
+			return retval;
+		}
+
+		retval = ext2fs_lookup(fs, parent, dirname, strlen(dirname),
+				       0, &tmp);
+		if (retval) {
+			com_err("dir_test", retval,
+				"while looking up %s dir", parent_name);
+			return retval;
+		}
+
+		if (dir != tmp) {
+			fprintf(stderr, "tst_inline_data: dir (%lu) != tmp (%lu)\n",
+				dir, tmp);
+			return 1;
+		}
+	}
+
+	snprintf(dirname, PATH_MAX, "%d", i);
+	retval = ext2fs_mkdir(fs, parent, 0, dirname);
+	if (retval && retval != EXT2_ET_DIR_NO_SPACE) {
+		com_err("dir_test", retval, "while creating %s dir", dirname);
+		return retval;
+	}
+
+	retval = ext2fs_expand_dir(fs, parent);
+	if (retval) {
+		com_err("dir_test", retval, "while expanding %s dir", parent_name);
+		return retval;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	ext2_filsys		fs;
+	struct ext2_super_block param;
+	errcode_t		retval;
+	int			i;
+
+	/* setup */
+	initialize_ext2_error_table();
+
+	memset(&param, 0, sizeof(param));
+	ext2fs_blocks_count_set(&param, 32768);
+	param.s_inodes_count = 100;
+
+	param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_INLINE_DATA;
+	param.s_rev_level = EXT2_DYNAMIC_REV;
+	param.s_inode_size = 256;
+
+	retval = ext2fs_initialize("test fs", EXT2_FLAG_64BITS, &param,
+				   test_io_manager, &fs);
+	if (retval) {
+		com_err("setup", retval,
+			"while initializing filesystem");
+		exit(1);
+	}
+
+	retval = ext2fs_allocate_tables(fs);
+	if (retval) {
+		com_err("setup", retval,
+			"while allocating tables for test filesysmte");
+		exit(1);
+	}
+
+	/* initialize inode cache */
+	if (!fs->icache) {
+		struct ext2_inode inode;
+		ext2_ino_t first_ino = EXT2_FIRST_INO(fs->super);
+		int i;
+
+		/* we just want to init inode cache.  So ignore error */
+		ext2fs_create_inode_cache(fs, 16);
+		if (!fs->icache) {
+			fprintf(stderr,
+				"tst_inline_data: init inode cache failed\n");
+			exit(1);
+		}
+
+		/* setup inode cache */
+		for (i = 0; i < fs->icache->cache_size; i++)
+			fs->icache->cache[i].ino = first_ino++;
+	}
+
+	/* test */
+	if (file_test(fs)) {
+		fprintf(stderr, "tst_inline_data(FILE): FAILED\n");
+		return 1;
+	}
+	printf("tst_inline_data(FILE): OK\n");
+
+	if (dir_test(fs)) {
+		fprintf(stderr, "tst_inline_data(DIR): FAILED\n");
+		return 1;
+	}
+	printf("tst_inline_data(DIR): OK\n");
+
+	return 0;
+}
+#endif
-- 
1.7.9.7

