From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 05/11] e4defrag: Use get_fragment_score() for decision of
 whether to defrag
Date: Fri, 08 Apr 2011 16:52:22 +0900
Message-ID: <4D9EBEB6.3050803@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:56439 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1DHIHc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 04:07:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This makes e4defrag use get_fragment_score() to calculate fragmentation
score. If fragmentation score of the target file is zero or less than the
destination file's one, e4defrag stops defragmentation.

The threshold that shows whether a fragment is good or not comes from
"blocksize * 8 - 2048". It's the same value as filefrag.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/Makefile.in |    4 +--
 misc/e4defrag.c  |   64 +++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 60 insertions(+), 8 deletions(-)
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 19eaa43..681475b 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -196,9 +196,9 @@ e2undo.profiled: $(PROFILED_E2UNDO_OBJS) $(PROFILED_DEPLIBS)
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2undo.profiled \
 		$(PROFILED_E2UNDO_OBJS) $(PROFILED_LIBS) $(LIBINTL)
 
-e4defrag: $(E4DEFRAG_OBJS) $(DEPLIBS)
+e4defrag: $(E4DEFRAG_OBJS) $(DEPLIBS) $(DEPLIBS_E2P)
 	$(E) "	LD $@"
-	$(Q) $(CC) $(ALL_LDFLAGS) -o e4defrag $(E4DEFRAG_OBJS) $(LIBS)
+	$(Q) $(CC) $(ALL_LDFLAGS) -o e4defrag $(E4DEFRAG_OBJS) $(LIBS) $(LIBE2P)
 
 e4defrag.profiled: $(PROFILED_E4DEFRAG_OBJS) $(PROFILED_DEPLIBS)
 	$(E) "	LD $@"
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index b168700..891bad4 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -31,16 +31,18 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <ext2fs/ext2_types.h>
 #include <linux/fs.h>
 #include <sys/ioctl.h>
-#include <ext2fs/fiemap.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/statfs.h>
 #include <sys/syscall.h>
 #include <sys/vfs.h>
 
+#include "e2p/e2p.h"
+#include "ext2fs/ext2_types.h"
+#include "ext2fs/fiemap.h"
+
 /* A relatively new ioctl interface ... */
 #ifndef EXT4_IOC_MOVE_EXT
 #define EXT4_IOC_MOVE_EXT      _IOWR('f', 15, struct move_extent)
@@ -107,6 +109,7 @@
 #define NGMSG_FILE_OPEN		"Failed to open"
 #define NGMSG_FILE_UNREG	"File is not regular file"
 #define NGMSG_LOST_FOUND	"Can not process \"lost+found\""
+#define NGMSG_EXT_FORMAT	"File is not extent format"
 
 /* Data type for filesystem-wide blocks number */
 typedef unsigned long long ext4_fsblk_t;
@@ -961,9 +964,11 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 {
 	int	fd;
 	int	donor_fd = -1;
+	int	orig_score = 0, donor_score = 0;
 	int	ret;
 	int	file_frags_start, file_frags_end;
 	char	tmp_inode_name[PATH_MAX + 8];
+	size_t	threshold;
 	ext4_fsblk_t			blk_count = 0;
 	struct fiemap_extent_list	*orig_list = NULL;
 	struct fiemap_extent_list	*donor_list = NULL;
@@ -1046,16 +1051,26 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
-	/* Combine extents to group */
-	ret = join_extents(orig_list, &orig_group_head);
-	if (ret < 0) {
+	/*
+	 * Calculate the threshold of perfection.
+	 * NOTE: 2048 means the maximum block region of mballoc.
+	 */
+	threshold = (block_size * 8 - 2048) * block_size;
+	orig_score = get_fragment_score(fd, threshold);
+	if (orig_score < 0) {
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
-			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
+			if (errno == EOPNOTSUPP)
+				PRINT_ERR_MSG_WITH_ERRNO(NGMSG_EXT_FORMAT);
+			else
+				PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
 		}
 		goto out;
 	}
 
+	if (!orig_score)
+		goto check_improvement;
+
 	/* Create donor inode */
 	memset(tmp_inode_name, 0, PATH_MAX + 8);
 	sprintf(tmp_inode_name, "%.*s.defrag",
@@ -1083,6 +1098,16 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
+	/* Combine extents to group */
+	ret = join_extents(orig_list, &orig_group_head);
+	if (ret < 0) {
+		if (mode_flag & DETAIL) {
+			PRINT_FILE_NAME(file);
+			PRINT_ERR_MSG_WITH_ERRNO("Failed to allocate memory");
+		}
+		goto out;
+	}
+
 	/* Allocate space for donor inode */
 	orig_group_tmp = orig_group_head;
 	do {
@@ -1110,6 +1135,16 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
+	donor_score = get_fragment_score(donor_fd, threshold);
+	if (donor_score < 0) {
+		if (mode_flag & DETAIL) {
+			PRINT_FILE_NAME(file);
+			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
+		}
+		goto out;
+	}
+
+check_improvement:
 	if (mode_flag & DETAIL) {
 		if (file_frags_start != 1)
 			frag_files_before_defrag++;
@@ -1117,6 +1152,23 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		extents_before_defrag += file_frags_start;
 	}
 
+	if (!orig_score || orig_score <= donor_score) {
+		printf("\033[79;0H\033[K[%u/%u]%s:\t%3d%%",
+			defraged_file_count, total_count, file, 100);
+		if (mode_flag & DETAIL)
+			printf("  extents: %d -> %d",
+				file_frags_start, file_frags_start);
+
+		printf("\t[ OK ]\n");
+		succeed_cnt++;
+
+		if (file_frags_start != 1)
+			frag_files_after_defrag++;
+
+		extents_after_defrag += file_frags_start;
+		goto out;
+	}
+
 	/* Defrag the file */
 	ret = call_defrag(fd, donor_fd, file, buf, donor_list);
 
