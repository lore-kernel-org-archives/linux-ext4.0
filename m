From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v3 08/11] e4defrag: Use libext2fs definitions
Date: Mon, 14 Nov 2011 15:25:03 +0900
Message-ID: <4EC0B43F.5020703@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57366 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1KNGcK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 01:32:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsprogs has blk64_t defined for the physical block number, and it also has
EXT2_SUPER_MAGIC defined for the magic number of ext4 filesystem.

e4defrag uses these definitions instead of its own definitions.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 45e9b72..7cf0cf0 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -42,6 +42,7 @@
 
 #include "e2p/e2p.h"
 #include "ext2fs/ext2_types.h"
+#include "ext2fs/ext2fs.h"
 #include "ext2fs/fiemap.h"
 
 /* A relatively new ioctl interface ... */
@@ -92,9 +93,6 @@
 #define FS_EXT4			"ext4"
 #define ROOT_UID		0
 
-/* Magic number for ext4 */
-#define EXT4_SUPER_MAGIC	0xEF53
-
 /* The following macro is used for ioctl FS_IOC_FIEMAP
  * EXTENT_MAX_COUNT:	the maximum number of extents for exchanging between
  *			kernel-space and user-space per ioctl
@@ -118,13 +116,10 @@
 #define NGMSG_FILE_UNREG	"File is not regular file"
 #define NGMSG_LOST_FOUND	"Can not process \"lost+found\""
 
-/* Data type for filesystem-wide blocks number */
-typedef unsigned long long ext4_fsblk_t;
-
 struct fiemap_extent_data {
 	__u64 len;			/* blocks count */
 	__u64 logical;		/* start logical block number */
-	ext4_fsblk_t physical;		/* start physical block number */
+	blk64_t physical;		/* start physical block number */
 };
 
 struct fiemap_extent_list {
@@ -303,7 +298,7 @@ static int is_ext4(const char *file)
 		return -1;
 	}
 
-	if (fsbuf.f_type != EXT4_SUPER_MAGIC) {
+	if (fsbuf.f_type != EXT2_SUPER_MAGIC) {
 		PRINT_ERR_MSG(NGMSG_EXT4);
 		return -1;
 	}
@@ -477,7 +472,7 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
  * In this case, they can catch ENOSPC when donor file is created by fallocate
  * in file_defrag(). So, it's no problem.
  */
-static int check_free_size(int fd, const char *file, ext4_fsblk_t blk_count)
+static int check_free_size(int fd, const char *file, blk64_t blk_count)
 {
 	struct statfs64	fsbuf;
 
@@ -526,8 +521,7 @@ static int file_frag_count(int fd)
  * @extents:		file extents.
  * @blk_count:		file blocks.
  */
-static int file_check(int fd, const char *file, int extents,
-					ext4_fsblk_t blk_count)
+static int file_check(int fd, const char *file, int extents, blk64_t blk_count)
 {
 	int	ret;
 	struct flock	lock;
@@ -942,7 +936,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	int	file_frags_start, file_frags_end;
 	char	tmp_inode_name[PATH_MAX + 8];
 	unsigned int			orig_score = 0, donor_score = 0;
-	ext4_fsblk_t			blk_count = 0;
+	blk64_t				blk_count = 0;
 	struct fiemap_extent_list	*orig_list = NULL;
 	struct fiemap_extent_list	*donor_list = NULL;
 	struct fiemap_extent_group	*orig_group_head = NULL;
