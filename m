From: Robert Yang <liezhi.yang@windriver.com>
Subject: [PATCH V2 08/11] mke2fs.c: add an option: -d root-directory
Date: Tue, 24 Dec 2013 03:47:24 -0500
Message-ID: <1387874847-4922-9-git-send-email-liezhi.yang@windriver.com>
References: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:40464 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3LXIrp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Dec 2013 03:47:45 -0500
In-Reply-To: <1387874847-4922-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This option is used for adding the files from a given directory (the
root-directory) to the filesystem, it is similiar to genext2fs, but
genext2fs doesn't fully support ext4.

Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
---
 misc/Makefile.in |   13 +++++++++----
 misc/mke2fs.c    |   32 +++++++++++++++++++++++---------
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index a798f96..da780fe 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -42,7 +42,7 @@ LPROGS=		@E2INITRD_PROG@
 
 TUNE2FS_OBJS=	tune2fs.o util.o
 MKLPF_OBJS=	mklost+found.o
-MKE2FS_OBJS=	mke2fs.o util.o profile.o prof_err.o default_profile.o
+MKE2FS_OBJS=	mke2fs.o util.o profile.o prof_err.o default_profile.o create_inode.o
 CHATTR_OBJS=	chattr.o
 LSATTR_OBJS=	lsattr.o
 UUIDGEN_OBJS=	uuidgen.o
@@ -60,7 +60,8 @@ E2FREEFRAG_OBJS= e2freefrag.o
 PROFILED_TUNE2FS_OBJS=	profiled/tune2fs.o profiled/util.o
 PROFILED_MKLPF_OBJS=	profiled/mklost+found.o
 PROFILED_MKE2FS_OBJS=	profiled/mke2fs.o profiled/util.o profiled/profile.o \
-			profiled/prof_err.o profiled/default_profile.o
+			profiled/prof_err.o profiled/default_profile.o \
+			profiled/create_inode.o
 PROFILED_CHATTR_OBJS=	profiled/chattr.o
 PROFILED_LSATTR_OBJS=	profiled/lsattr.o
 PROFILED_UUIDGEN_OBJS=	profiled/uuidgen.o
@@ -82,7 +83,7 @@ SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c \
 		$(srcdir)/uuidgen.c $(srcdir)/blkid.c $(srcdir)/logsave.c \
 		$(srcdir)/filefrag.c $(srcdir)/base_device.c \
 		$(srcdir)/ismounted.c $(srcdir)/../e2fsck/profile.c \
-		$(srcdir)/e2undo.c $(srcdir)/e2freefrag.c
+		$(srcdir)/e2undo.c $(srcdir)/e2freefrag.c $(srcdir)/create_inode.c
 
 LIBS= $(LIBEXT2FS) $(LIBCOM_ERR) 
 DEPLIBS= $(LIBEXT2FS) $(DEPLIBCOM_ERR)
@@ -612,7 +613,7 @@ mke2fs.o: $(srcdir)/mke2fs.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
  $(srcdir)/util.h profile.h prof_err.h $(top_srcdir)/version.h \
- $(srcdir)/nls-enable.h $(top_srcdir)/lib/quota/mkquota.h \
+ $(srcdir)/nls-enable.h $(top_srcdir)/lib/quota/mkquota.h $(srcdir)/create_inode.h\
  $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
  $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
 chattr.o: $(srcdir)/chattr.c $(top_builddir)/lib/config.h \
@@ -692,3 +693,7 @@ e2freefrag.o: $(srcdir)/e2freefrag.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/e2freefrag.h
+create_inode.o: $(srcdir)/create_inode.h $(srcdir)/create_inode.c \
+ $(top_builddir)/lib/config.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/e2p/e2p.h \
+ $(srcdir)/nls-enable.h
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4075099..eab5463 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -22,7 +22,6 @@
 #include <stdio.h>
 #include <string.h>
 #include <strings.h>
-#include <fcntl.h>
 #include <ctype.h>
 #include <time.h>
 #ifdef __linux__
@@ -44,24 +43,19 @@ extern int optind;
 #include <errno.h>
 #endif
 #include <sys/ioctl.h>
-#include <sys/types.h>
-#include <sys/stat.h>
 #include <libgen.h>
 #include <limits.h>
 #include <blkid/blkid.h>
 
 #include "ext2fs/ext2_fs.h"
 #include "ext2fs/ext2fsP.h"
-#include "et/com_err.h"
 #include "uuid/uuid.h"
-#include "e2p/e2p.h"
-#include "ext2fs/ext2fs.h"
 #include "util.h"
 #include "profile.h"
 #include "prof_err.h"
 #include "../version.h"
-#include "nls-enable.h"
 #include "quota/mkquota.h"
+#include "create_inode.h"
 
 #define STRIDE_LENGTH 8
 
@@ -105,6 +99,7 @@ char *mount_dir;
 char *journal_device;
 int sync_kludge;	/* Set using the MKE2FS_SYNC env. option */
 char **fs_types;
+const char *root_dir;  /* Copy files from the specified directory */
 
 profile_t	profile;
 
@@ -116,7 +111,8 @@ static void usage(void)
 	fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size] "
 	"[-C cluster-size]\n\t[-i bytes-per-inode] [-I inode-size] "
 	"[-J journal-options]\n"
-	"\t[-G flex-group-size] [-N number-of-inodes]\n"
+	"\t[-G flex-group-size] [-N number-of-inodes] "
+	"[-d root-directory]\n"
 	"\t[-m reserved-blocks-percentage] [-o creator-os]\n"
 	"\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
@@ -1403,7 +1399,7 @@ profile_error:
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cg:i:jl:m:no:qr:s:t:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
+		    "b:cg:i:jl:m:no:qr:s:t:d:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = parse_num_blocks2(optarg, -1);
@@ -1591,6 +1587,9 @@ profile_error:
 		case 'U':
 			fs_uuid = optarg;
 			break;
+		case 'd':
+			root_dir = optarg;
+			break;
 		case 'v':
 			verbose = 1;
 			break;
@@ -2798,6 +2797,21 @@ no_journal:
 				       EXT4_FEATURE_RO_COMPAT_QUOTA))
 		create_quota_inodes(fs);
 
+	/* Copy files from the specified directory */
+	if (root_dir) {
+		if (!quiet)
+			printf("%s", _("Copying files into the device: "));
+
+		current_fs = fs;
+		root = EXT2_ROOT_INO;
+		retval = populate_fs(root, root_dir);
+		if (retval)
+			fprintf(stderr, "%s",
+				_("\nError while populating %s"), root_dir);
+		else if (!quiet)
+			printf("%s", _("done\n"));
+	}
+
 	if (!quiet)
 		printf("%s", _("Writing superblocks and "
 		       "filesystem accounting information: "));
-- 
1.7.10.4

