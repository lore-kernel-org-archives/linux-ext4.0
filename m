From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 08/11] e4defrag: Use blk64_t instead of ext4_fsblk_t
Date: Fri, 08 Apr 2011 16:52:58 +0900
Message-ID: <4D9EBEDA.7030801@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39182 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1DHII2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 04:08:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsprogs has blk64_t defined for the physical block number. e4defrag uses it
instead of ext4_fsblk_t.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index ba0d424..6365103 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -41,6 +41,7 @@
 
 #include "e2p/e2p.h"
 #include "ext2fs/ext2_types.h"
+#include "ext2fs/ext2fs.h"
 #include "ext2fs/fiemap.h"
 
 /* A relatively new ioctl interface ... */
@@ -111,13 +112,10 @@
 #define NGMSG_LOST_FOUND	"Can not process \"lost+found\""
 #define NGMSG_EXT_FORMAT	"File is not extent format"
 
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
@@ -461,9 +459,9 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
  * @file:		file name.
  * @blk_count:		file blocks.
  */
-static int check_free_size(int fd, const char *file, ext4_fsblk_t blk_count)
+static int check_free_size(int fd, const char *file, blk64_t blk_count)
 {
-	ext4_fsblk_t	free_blk_count;
+	blk64_t		free_blk_count;
 	struct statfs64	fsbuf;
 	uid_t		current_uid = getuid();
 
@@ -521,8 +519,7 @@ static int file_frag_count(int fd)
  * @extents:		file extents.
  * @blk_count:		file blocks.
  */
-static int file_check(int fd, const char *file, int extents,
-					ext4_fsblk_t blk_count)
+static int file_check(int fd, const char *file, int extents, blk64_t blk_count)
 {
 	int	ret;
 	struct flock	lock;
@@ -761,9 +758,9 @@ static int get_exts_count(struct fiemap_extent_list *ext_list_head)
  *
  * @ext_list_head:	the extent list head of the target file
  */
-static ext4_fsblk_t get_file_blocks(struct fiemap_extent_list *ext_list_head)
+static blk64_t get_file_blocks(struct fiemap_extent_list *ext_list_head)
 {
-	ext4_fsblk_t blk_count = 0;
+	blk64_t blk_count = 0;
 	struct fiemap_extent_list *ext_list_tmp = ext_list_head;
 
 	do {
@@ -954,7 +951,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	int	file_frags_start, file_frags_end;
 	char	tmp_inode_name[PATH_MAX + 8];
 	size_t	threshold;
-	ext4_fsblk_t			blk_count = 0;
+	blk64_t				blk_count = 0;
 	struct fiemap_extent_list	*orig_list = NULL;
 	struct fiemap_extent_list	*donor_list = NULL;
 	struct fiemap_extent_group	*orig_group_head = NULL;
