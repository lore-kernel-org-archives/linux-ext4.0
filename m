From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] tests: create crcsum progam to support resizing tests
Date: Sun, 31 Mar 2013 20:44:02 -0400
Message-ID: <1364777043-20610-4-git-send-email-tytso@mit.edu>
References: <CAN=xW0bhw41-NNqWnDfqk0SbM6xymrhuL9WONQKefC=PsHg5GQ@mail.gmail.com>
 <1364777043-20610-1-git-send-email-tytso@mit.edu>
Cc: john.jolly@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57586 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab3DAAoL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Mar 2013 20:44:11 -0400
In-Reply-To: <1364777043-20610-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The only checksum program which we can reliably count upon being
installed on all systems is "sum", which is not a particular robust
checksum.  The problem with using md5sum or sha1sum is it hat it may
not be installed on all systems.  So create a crcsum program which is
used so we can validate that a data file on a resized file system has
not been corrupted.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/progs/Makefile.in |  6 ++++-
 tests/progs/crcsum.c    | 70 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/test_config       |  1 +
 3 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 tests/progs/crcsum.c

diff --git a/tests/progs/Makefile.in b/tests/progs/Makefile.in
index 0e28192..e3c1ef4 100644
--- a/tests/progs/Makefile.in
+++ b/tests/progs/Makefile.in
@@ -13,7 +13,7 @@ INSTALL = @INSTALL@
 
 MK_CMDS=	_SS_DIR_OVERRIDE=../../lib/ss ../../lib/ss/mk_cmds
 
-PROGS=		test_icount
+PROGS=		test_icount crcsum
 
 TEST_REL_OBJS=	test_rel.o test_rel_cmds.o
 
@@ -34,6 +34,10 @@ test_rel: $(TEST_REL_OBJS) $(DEPLIBS)
 	$(E) "	LD $@"
 	$(Q) $(LD) $(ALL_LDFLAGS) -o test_rel $(TEST_REL_OBJS) $(LIBS)
 
+crcsum: crcsum.o $(DEPLIBS)
+	$(E) "	LD $@"
+	$(Q) $(LD) $(ALL_LDFLAGS) -o crcsum crcsum.o $(LIBS)
+
 test_rel_cmds.c: test_rel_cmds.ct
 	$(E) "	MK_CMDS $@"
 	$(Q) $(MK_CMDS) $(srcdir)/test_rel_cmds.ct
diff --git a/tests/progs/crcsum.c b/tests/progs/crcsum.c
new file mode 100644
index 0000000..bee979b
--- /dev/null
+++ b/tests/progs/crcsum.c
@@ -0,0 +1,70 @@
+/*
+ * crcsum.c
+ *
+ * Copyright (C) 2013 Theodore Ts'o.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "config.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <unistd.h>
+#ifdef HAVE_GETOPT_H
+#include <getopt.h>
+#endif
+#include <fcntl.h>
+
+#include "et/com_err.h"
+#include "ss/ss.h"
+#include "ext2fs/ext2fs.h"
+
+
+int main(int argc, char **argv)
+{
+	int		c;
+	uint32_t	crc = ~0;
+	uint32_t	(*csum_func)(uint32_t crc, unsigned char const *p,
+				     size_t len);
+	FILE		*f;
+
+	csum_func = ext2fs_crc32c_le;
+
+	while ((c = getopt (argc, argv, "B")) != EOF) {
+		switch (c) {
+		case 'B':
+			csum_func = ext2fs_crc32c_be;
+			break;
+		default:
+			com_err(argv[0], 0, "Usage: crcsum [-b] [file]\n");
+			return 1;
+		}
+	}
+
+	if (optind == argc)
+		f = stdin;
+	else {
+		f = fopen(argv[optind], "r");
+		if (!f) {
+			com_err(argv[0], errno, "while trying to open %s\n",
+				argv[optind]);
+			exit(1);
+		}
+	}
+
+	while (!feof(f)) {
+		unsigned char buf[4096];
+
+		int c = fread(buf, 1, sizeof(buf), f);
+
+		if (c)
+			crc = csum_func(crc, buf, c);
+	}
+	printf("%u\n", crc);
+	return 0;
+}
diff --git a/tests/test_config b/tests/test_config
index 0ba8b5e..36b53b7 100644
--- a/tests/test_config
+++ b/tests/test_config
@@ -19,6 +19,7 @@ RESIZE2FS="$USE_VALGRIND $RESIZE2FS_EXE"
 E2UNDO_EXE="../misc/e2undo"
 TEST_REL=../tests/progs/test_rel
 TEST_ICOUNT=../tests/progs/test_icount
+CRCSUM=../tests/progs/crcsum
 LD_LIBRARY_PATH=../lib:../lib/ext2fs:../lib/e2p:../lib/et:../lib/ss
 DYLD_LIBRARY_PATH=../lib:../lib/ext2fs:../lib/e2p:../lib/et:../lib/ss
 export LD_LIBRARY_PATH
-- 
1.7.12.rc0.22.gcdd159b

