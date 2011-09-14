From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: add new test: tst_inode_size
Date: Wed, 14 Sep 2011 13:16:33 -0400
Message-ID: <1316020593-19050-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40904 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab1INRQf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 13:16:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This test makes sure the size of the ext2_inode is what we expect

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/Makefile.in      |    8 ++++-
 lib/ext2fs/tst_inode_size.c |   80 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 1 deletions(-)
 create mode 100644 lib/ext2fs/tst_inode_size.c

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index f6338f0..e374c1c 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -262,6 +262,12 @@ tst_super_size: tst_super_size.o
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_super_size tst_super_size.o 
 
+tst_inode_size.o: $(srcdir)/tst_inode_size.c $(srcdir)/ext2_fs.h
+
+tst_inode_size: tst_inode_size.o
+	$(E) "	LD $@"
+	$(Q) $(CC) -o tst_inode_size tst_inode_size.o 
+
 ext2_tdbtool: tdbtool.o
 	$(E) "	LD $@"
 	$(Q) $(CC) -o ext2_tdbtool tdbtool.o tdb.o
@@ -339,7 +345,7 @@ mkjournal: mkjournal.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o mkjournal $(srcdir)/mkjournal.c -DDEBUG $(STATIC_LIBEXT2FS) $(LIBCOM_ERR) $(ALL_CFLAGS)
 
-check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount tst_super_size tst_types tst_csum
+check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount tst_super_size tst_types tst_inode_size tst_csum
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_bitops
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_badblocks
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_iscan
diff --git a/lib/ext2fs/tst_inode_size.c b/lib/ext2fs/tst_inode_size.c
new file mode 100644
index 0000000..962f1cd
--- /dev/null
+++ b/lib/ext2fs/tst_inode_size.c
@@ -0,0 +1,80 @@
+/*
+ * This testing program makes sure the ext2_inode structure is 1024 bytes long
+ *
+ * Copyright (C) 2007 by Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+
+#include "ext2_fs.h"
+
+struct ext2_inode inode;
+
+int verbose = 0;
+
+#define offsetof(type, member)  __builtin_offsetof (type, member)
+#define check_field(x) cur_offset = do_field(#x, sizeof(inode.x),	\
+				offsetof(struct ext2_inode, x), \
+				cur_offset)
+
+static int do_field(const char *field, size_t size, int offset, int cur_offset)
+{
+	if (offset != cur_offset) {
+		printf("Warning!  Unexpected offset at %s\n", field);
+		exit(1);
+	}
+	printf("%8d %-30s %3u\n", offset, field, (unsigned) size);
+	return offset + size;
+}
+
+void check_structure_fields()
+{
+#if (__GNUC__ >= 4)
+	int cur_offset = 0;
+
+	printf("%8s %-30s %3s\n", "offset", "field", "size");
+	check_field(i_mode);
+	check_field(i_uid);
+	check_field(i_size);
+	check_field(i_atime);
+	check_field(i_ctime);
+	check_field(i_mtime);
+	check_field(i_dtime);
+	check_field(i_gid);
+	check_field(i_links_count);
+	check_field(i_blocks);
+	check_field(i_flags);
+	check_field(osd1.linux1.l_i_version);
+	check_field(i_block);
+	check_field(i_generation);
+	check_field(i_file_acl);
+	check_field(i_size_high);
+	check_field(i_faddr);
+	check_field(osd2.linux2.l_i_blocks_hi);
+	check_field(osd2.linux2.l_i_file_acl_high);
+	check_field(osd2.linux2.l_i_uid_high);
+	check_field(osd2.linux2.l_i_gid_high);
+	check_field(osd2.linux2.l_i_reserved2);
+	printf("Ending offset is %d\n\n", cur_offset);
+#endif
+}
+
+
+int main(int argc, char **argv)
+{
+	int l = sizeof(struct ext2_inode);
+
+	check_structure_fields();
+	printf("Size of struct ext2_inode is %d\n", l);
+	if (l != 256) {
+		exit(1);
+	}
+	exit(0);
+}
-- 
1.7.4.1.22.gec8e1.dirty

