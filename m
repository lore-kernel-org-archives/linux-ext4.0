From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v2 04/12] e4defrag: Use e2p_get_fragscore() for decision of
 whether to defrag
Date: Wed, 17 Aug 2011 16:47:16 +0900
Message-ID: <4E4B7204.8020000@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35575 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1HQIDg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 04:03:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This makes e4defrag use e2p_get_fragscore() to calculate fragmentation score.
If the fragmentation score of the original file is non-zero and
the fragmentation score of donor file is zero, e4defrag calls
EXT4_IOC_MOVE_EXT ioctl. Because the fragmentation will get better in this case.

e4defrag uses 4096 as the threshold of fragmentation because the bigger
threshold(<4096) has little effect on the performance from the following
results of my experiment.

METHOD
---

1) Created 4GB fragmented file in 16GB ext4 filesystem. The length of
   all extents in the created file was the same, and the physical block of
   each extents was allocated at random.

   For examples, when the length of all extents is 512 blocks, filefrag shows
   the following extent information:

   #filefrag -v /mnt/mp1/fragment
   Filesystem type is: ef53
   File size of /mnt/mp1/fragment is 4294967296 (1048576 blocks, blocksize 4096)
    ext logical physical expected length flags
      0       0  1852416             512 
      1     512  1584672  1852927    512 
      2    1024   644608  1585183    512 
      3    1536  3760128   645119    511 
      4    2048  3389952  3760638    512 
   <snip>
   2057 1046016  1066016  3930111    512 
   2058 1046528   559104  1066527    512 
   2059 1047040   680960   559615    512 
   2060 1047552  1175552   681471    512 
   2061 1048064  2780672  1176063    512 eof
   /mnt/mp1/fragment: 2062 extents found

2) Read the file by cat command three times, and calculated the average of
   the read time.

RESULT
---

The following table is its result. It shows that read time is about the same
when the length of the extents is bigger than 4096.

  ext length | ext num | time (s)
 ---------------------------------
       32768 |      37 |    85.94
       16384 |      67 |    85.61
        8192 |     131 |    86.60
        4096 |     260 |    88.87
        2048 |     519 |    95.31
        1024 |    1031 |   105.96
         512 |    2052 |   124.32
         256 |    4120 |   160.44
         128 |    8242 |   226.28

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/Makefile.in |    4 +--
 misc/e4defrag.c  |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 7 deletions(-)
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 5f62323..d5dfdf8 100644
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
index 58fd9be..44d54f3 100644
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
@@ -97,6 +99,12 @@
  */
 #define EXTENT_MAX_COUNT	512
 
+/* Preferred number of blocks in one extent */
+#define DEFAULT_THRESHOLD	4096
+
+/* Maximum number of blocks in one extent */
+#define EXTENT_MAX_BLKS		32768
+
 /* The following macros are error message */
 #define MSG_USAGE		\
 "Usage	: e4defrag [-v] file...| directory...| device...\n"
@@ -145,6 +153,7 @@ int	block_size;
 int	extents_before_defrag;
 int	extents_after_defrag;
 int	mode_flag;
+unsigned int	threshold;
 unsigned int	current_uid;
 unsigned int	defraged_file_count;
 unsigned int	frag_files_before_defrag;
@@ -962,8 +971,10 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	int	fd;
 	int	donor_fd = -1;
 	int	ret;
+	int	err = 0;
 	int	file_frags_start, file_frags_end;
 	char	tmp_inode_name[PATH_MAX + 8];
+	unsigned int			orig_score = 0, donor_score = 0;
 	ext4_fsblk_t			blk_count = 0;
 	struct fiemap_extent_list	*orig_list = NULL;
 	struct fiemap_extent_list	*donor_list = NULL;
@@ -1046,9 +1057,9 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
-	/* Combine extents to group */
-	ret = join_extents(orig_list, &orig_group_head);
-	if (ret < 0) {
+	orig_score = e2p_get_fragscore(fd, threshold, EXTENT_MAX_BLKS, &err);
+	if (err) {
+		errno = err;
 		if (mode_flag & DETAIL) {
 			PRINT_FILE_NAME(file);
 			PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_EXTENT);
@@ -1056,6 +1067,9 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
+	if (!orig_score)
+		goto check_improvement;
+
 	/* Create donor inode */
 	memset(tmp_inode_name, 0, PATH_MAX + 8);
 	sprintf(tmp_inode_name, "%.*s.defrag",
@@ -1083,6 +1097,16 @@ static int file_defrag(const char *file, const struct stat64 *buf,
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
@@ -1110,6 +1134,18 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
+	donor_score = e2p_get_fragscore(donor_fd, threshold,
+						EXTENT_MAX_BLKS, &err);
+	if (err) {
+		errno = err;
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
@@ -1117,6 +1153,23 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		extents_before_defrag += file_frags_start;
 	}
 
+	if (!orig_score || donor_score) {
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
 
@@ -1192,6 +1245,7 @@ int main(int argc, char *argv[])
 		goto out;
 
 	current_uid = getuid();
+	threshold = DEFAULT_THRESHOLD;
 
 	/* Main process */
 	for (i = optind; i < argc; i++) {

