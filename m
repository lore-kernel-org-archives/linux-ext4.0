From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v1 22/22] libext2fs: add a unit test for inline data
Date: Fri,  2 Aug 2013 17:49:49 +0800
Message-ID: <1375436989-18948-23-git-send-email-wenqing.lz@taobao.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60641 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab3HBJvr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Aug 2013 05:51:47 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo5so506401pbc.9
        for <linux-ext4@vger.kernel.org>; Fri, 02 Aug 2013 02:51:46 -0700 (PDT)
In-Reply-To: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In this unit test, we will test manipulation of regular file and dir
for inline data to make sure all tests pass.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/Makefile.in   |    8 +-
 lib/ext2fs/inline_data.c |  294 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 301 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 001c222..6b188b8 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -390,6 +390,11 @@ tst_inline: $(srcdir)/inline.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
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
@@ -407,7 +412,7 @@ mkjournal: mkjournal.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
 
 check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
     tst_super_size tst_types tst_inode_size tst_csum tst_crc32c tst_bitmaps \
-    tst_inline
+    tst_inline tst_inline_data
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_bitops
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_badblocks
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_iscan
@@ -417,6 +422,7 @@ check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_inode_size
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_csum
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_inline
+	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_inline_data
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_crc32c
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) \
 		./tst_bitmaps -f $(srcdir)/tst_bitmaps_cmds > tst_bitmaps_out
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 1c954a3..53bddc7 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -670,3 +670,297 @@ errcode_t ext2fs_inline_data_create(ext2_filsys fs,
 
 	return 0;
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
+#define BUF_LEN (64)
+
+/*
+ * Test manipulation of regular file.
+ *
+ * In this test case, the following operations are tested:
+ *  - regular file creation with inline_data flag
+ *  - try to write data into inode while the size of data is fit for saving in
+ *    inode
+ *  - read data from inode
+ *  - write data without changing the size of inline data
+ *  - get the size of inline data
+ *  - truncate
+ *  - check header
+ */
+static errcode_t test_file(ext2_filsys fs)
+{
+	ext2_ino_t newfile;
+	errcode_t retval;
+	unsigned int written;
+	struct ext2_inode_large inode;
+	char *buf, *cmpbuf;
+	int inline_size;
+
+	retval = ext2fs_new_inode(fs, 2, 010755, 0, &newfile);
+	if (retval) {
+		com_err("test_file", retval,
+			"While creating a new file");
+		return 1;
+	}
+
+	retval = ext2fs_write_new_inode(fs, newfile, (void *)&inode);
+	if (retval) {
+		com_err("test_file", retval,
+			"While writting a new inode");
+		return 1;
+	}
+
+	retval = ext2fs_get_arrayzero(BUF_LEN, sizeof(char), &buf);
+	if (retval) {
+		com_err("test_file", retval, "While creating buffer");
+		return 1;
+	}
+	memset(buf, 'a', BUF_LEN);
+	retval = ext2fs_try_to_write_inline_data(fs, newfile, buf,
+						 BUF_LEN, &written);
+	if (retval) {
+		com_err("test_file", retval,
+			"While trying to write a regular file");
+		return 1;
+	}
+
+	if (written != BUF_LEN) {
+		printf("inline_data: write a regular file error, written %d "
+		       "should be %d.\n", written, BUF_LEN);
+		return 1;
+	}
+
+	inline_size = ext2fs_inline_data_get_size(fs, newfile);
+	if (inline_size != BUF_LEN) {
+		printf("inline_data: the size of inline data is incorrect\n");
+		return 1;
+	}
+
+	retval = ext2fs_get_arrayzero(BUF_LEN, sizeof(char), &cmpbuf);
+	if (retval) {
+		com_err("test_file", retval, "While creating buffer");
+		return 1;
+	}
+	retval = ext2fs_read_inline_data(fs, newfile, cmpbuf);
+	if (retval) {
+		com_err("test_file", retval, "While reading");
+		return 1;
+	}
+
+	if (memcmp(buf, cmpbuf, BUF_LEN)) {
+		printf("inline_data: read a regular file error\n");
+		return 1;
+	}
+
+	retval = ext2fs_write_inline_data(fs, newfile, buf);
+	if (retval) {
+		printf("inline_data: write a regular file error\n");
+		return 1;
+	}
+
+	retval = ext2fs_punch(fs, newfile, 0, 0, 0, ~0U);
+	if (retval) {
+		printf("inline_data: truncate failed\n");
+		return 1;
+	}
+
+	retval = ext2fs_inline_data_check(fs, newfile);
+	if (retval != 1) {
+		printf("inline_data: header check failed\n");
+		return 1;
+	}
+
+	ext2fs_free_mem(&buf);
+	ext2fs_free_mem(&cmpbuf);
+
+	printf("tst_inline_data(REG): OK\n");
+
+	return 0;
+}
+
+static errcode_t test_create_parent_dir(ext2_filsys fs, ext2_ino_t *ino)
+{
+	const char *test_dir = "test";
+	const char *dot = ".";
+	errcode_t retval;
+	ext2_ino_t dir, tmp;
+
+	/* create a stub directory */
+	retval = ext2fs_mkdir(fs, 11, 11, "stub");
+	if (retval) {
+		com_err("test_dir", retval, "while creating stub dir");
+		return 1;
+	}
+
+	/* create a new empty directory with inline data */
+	retval = ext2fs_mkdir(fs, 11, 0, test_dir);
+	if (retval)
+		return 1;
+
+	/* lookup this new directory */
+	retval = ext2fs_lookup(fs, 11, test_dir,
+			       strlen(test_dir), 0, &dir);
+	if (retval) {
+		com_err("test_create_parent_dir", retval,
+			"while looking up test dir");
+		return 1;
+	}
+
+	/* lookup '.' in this new directory */
+	retval = ext2fs_lookup(fs, dir, dot, strlen(dot), 0, &tmp);
+	if (retval) {
+		com_err("test_create_parent_dir", retval,
+			"while looking up dot dir");
+		return 1;
+	}
+
+	if (tmp != dir) {
+		fprintf(stderr, "inline_data: looking up '.' error\n");
+		return 1;
+	}
+
+	*ino = dir;
+	return 0;
+}
+
+static errcode_t test_manipulate_dirs(ext2_filsys fs, ext2_ino_t parent)
+{
+	errcode_t retval;
+	ext2_ino_t dir = 13, tmp;
+	char name[PATH_MAX];
+	int i;
+
+	/*
+	 * Here we only try to create 4 dirs:
+	 *   4 bytes (parent inode) + 56 bytes
+	 * In ext4 a dir at least need to take 12 bytes.  So it only can
+	 * save 4 dirs in inode's i_block.
+	 */
+	for (i = 0; i < 4; i++) {
+		tmp = 0;
+		snprintf(name, PATH_MAX, "%d", i);
+		retval = ext2fs_mkdir(fs, parent, 0, name);
+		if (retval) {
+			com_err("test_manipulate_dirs", retval,
+				"while making dir %s", name);
+			return 1;
+		}
+
+		retval = ext2fs_lookup(fs, parent, name,
+				       strlen(name), 0, &tmp);
+		if (retval) {
+			com_err("test_manipulate_dirs", retval,
+				"while looking up test dir");
+			return 1;
+		}
+
+		if (tmp != dir) {
+			printf("inline_data: create subdirs failed, "
+			       "dir inode is %d, but now is %d\n", dir, tmp);
+			return 1;
+		}
+
+		dir++;
+	}
+
+	/*
+	 * XXX: In e2fsprogs the size of inline data doesn't expand from i_block
+	 * space to extra space while making a new dir.  If extra space has been
+	 * used while creating a new dir, extra space will be used.  So here
+	 * ext2fs_mkdir() will return EXT2_ET_DIR_NO_SPACE.
+	 */
+	snprintf(name, PATH_MAX, "%d", i);
+	retval = ext2fs_mkdir(fs, parent, 0, name);
+	if (retval != EXT2_ET_DIR_NO_SPACE) {
+		com_err("test_manipulate_dirs", retval,
+			"while making dir %s", name);
+		return 1;
+	}
+
+	retval = ext2fs_expand_dir(fs, parent);
+	if (retval) {
+		com_err("test_maniuplate_dirs", retval,
+			"while expanding test dir");
+		return 1;
+	}
+
+	retval = ext2fs_inline_data_check(fs, parent);
+	if (retval != 1) {
+		printf("inline_data: header check failed\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Test manipulation of directory.
+ *
+ * In this test case, we first try to create a test dir.  Then we will try to
+ * create, lookup this dir and make sure all tests pass.
+ */
+static errcode_t test_dir(ext2_filsys fs)
+{
+	errcode_t retval;
+	ext2_ino_t dir;
+
+	retval = test_create_parent_dir(fs, &dir);
+	if (retval)
+		return 1;
+
+	retval = test_manipulate_dirs(fs, dir);
+	if (retval)
+		return 1;
+
+	printf("tst_inline_data(DIR): OK\n");
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct ext2_super_block param;
+	errcode_t		retval;
+	ext2_filsys		fs;
+	int			i;
+
+	memset(&param, 0, sizeof(param));
+	ext2fs_blocks_count_set(&param, 32768);
+
+	retval = ext2fs_initialize("test fs", EXT2_FLAG_64BITS, &param,
+				   test_io_manager, &fs);
+	if (retval) {
+		com_err("setup", retval,
+			"While initializing filesystem");
+		exit(1);
+	}
+
+	fs->super->s_feature_ro_compat |= EXT2_FEATURE_COMPAT_EXT_ATTR;
+	fs->super->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_INLINE_DATA;
+	fs->super->s_rev_level = EXT2_DYNAMIC_REV;
+	fs->super->s_inode_size = 256;
+
+	retval = ext2fs_allocate_tables(fs);
+	if (retval) {
+		com_err("setup", retval,
+			"while allocating tables for test filesysmte");
+		exit(1);
+	}
+
+	retval = test_file(fs);
+	if (retval)
+		return retval;
+
+	retval = test_dir(fs);
+	if (retval)
+		return retval;
+
+	return 0;
+}
+#endif
-- 
1.7.9.7

