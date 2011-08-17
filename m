From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v2 09/12] e4defrag: Use blk64_t instead of ext4_fsblk_t
Date: Wed, 17 Aug 2011 16:47:53 +0900
Message-ID: <4E4B7229.4030205@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35679 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1HQIEO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 04:04:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsprogs has blk64_t defined for the physical block number. e4defrag uses it
instead of ext4_fsblk_t.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 45e6d82..b5958d9 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -41,6 +41,7 @@
 
 #include "e2p/e2p.h"
 #include "ext2fs/ext2_types.h"
+#include "ext2fs/ext2fs.h"
 #include "ext2fs/fiemap.h"
 
 /* A relatively new ioctl interface ... */
@@ -117,13 +118,10 @@
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
@@ -473,7 +471,7 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
  * In this case, they can catch ENOSPC when donor file is created by fallocate
  * in file_defrag(). So, it's no problem.
  */
-static int check_free_size(int fd, const char *file, ext4_fsblk_t blk_count)
+static int check_free_size(int fd, const char *file, blk64_t blk_count)
 {
 	struct statfs64	fsbuf;
 
@@ -522,8 +520,7 @@ static int file_frag_count(int fd)
  * @extents:		file extents.
  * @blk_count:		file blocks.
  */
-static int file_check(int fd, const char *file, int extents,
-					ext4_fsblk_t blk_count)
+static int file_check(int fd, const char *file, int extents, blk64_t blk_count)
 {
 	int	ret;
 	struct flock	lock;
@@ -938,7 +935,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 	int	file_frags_start, file_frags_end;
 	char	tmp_inode_name[PATH_MAX + 8];
 	unsigned int			orig_score = 0, donor_score = 0;
-	ext4_fsblk_t			blk_count = 0;
+	blk64_t				blk_count = 0;
 	struct fiemap_extent_list	*orig_list = NULL;
 	struct fiemap_extent_list	*donor_list = NULL;
 	struct fiemap_extent_group	*orig_group_head = NULL;
