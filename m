From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix trivial build warnings
Date: Tue, 14 Jul 2009 20:07:57 -0500
Message-ID: <4A5D2BED.30009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35257 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbZGOBH7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jul 2009 21:07:59 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6F17xib032679
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2009 21:07:59 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6F17xiW001494
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2009 21:07:59 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6F17vlF018782
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2009 21:07:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quite a lot of warnings have crept into the build; this fixes
many of the trivial ones.  Mostly unused variables, a
couple of header file inclusions, and one missing return
value.

There are a few other warnings that I'll send patches for
in a bit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 94ffc6f..1710aa2 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1871,7 +1871,7 @@ static int find_supp_feature(__u32 *supp, int feature_type, char *name)
 
 void do_supported_features(int argc, char *argv[])
 {
-        int	i, j, ret;
+        int	ret;
 	__u32	supp[3] = { EXT2_LIB_FEATURE_COMPAT_SUPP,
 			    EXT2_LIB_FEATURE_INCOMPAT_SUPP,
 			    EXT2_LIB_FEATURE_RO_COMPAT_SUPP };
diff --git a/debugfs/htree.c b/debugfs/htree.c
index 01e4ca5..718478f 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -22,6 +22,8 @@ extern int optind;
 extern char *optarg;
 #endif
 
+#include "e2p/e2p.h"
+#include "uuid/uuid.h"
 #include "debugfs.h"
 
 static FILE *pager;
@@ -413,7 +415,7 @@ static int search_dir_block(ext2_filsys fs, blk_t *blocknr,
 			com_err("htree_dump_leaf_inode", errcode,
 				"while getting rec_len for block %lu",
 				(unsigned long) *blocknr);
-			return;
+			return BLOCK_ABORT;
 		}
 		if (dirent->inode &&
 		    p->len == (dirent->name_len & 0xFF) &&
diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 166be6b..a366281 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -34,8 +34,6 @@ static int ncheck_proc(struct ext2_dir_entry *dirent,
 {
 	struct inode_walk_struct *iw = (struct inode_walk_struct *) private;
 	int	i;
-	char	*pathname;
-	errcode_t	retval;
 
 	iw->position++;
 	if (iw->position <= 2)
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index c3b7c58..7fcc2cf 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1354,7 +1354,6 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
 	char 				*cp;
 	struct ext3_extent_header	*eh;
 	errcode_t			retval = 0;
-	struct ext2fs_extent		extent;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EXTENT_HANDLE);
 
diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index 19caf23..bb314db 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -425,8 +425,6 @@ static int ext2fs_test_clear_generic_bitmap_range(ext2fs_generic_bitmap bitmap,
 int ext2fs_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
 				   blk_t block, int num)
 {
-	int	i;
-
 	EXT2_CHECK_MAGIC(bitmap, EXT2_ET_MAGIC_BLOCK_BITMAP);
 	if ((block < bitmap->start) || (block+num-1 > bitmap->real_end)) {
 		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_TEST,
@@ -440,8 +438,6 @@ int ext2fs_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
 int ext2fs_test_inode_bitmap_range(ext2fs_inode_bitmap bitmap,
 				   ino_t inode, int num)
 {
-	int	i;
-
 	EXT2_CHECK_MAGIC(bitmap, EXT2_ET_MAGIC_INODE_BITMAP);
 	if ((inode < bitmap->start) || (inode+num-1 > bitmap->real_end)) {
 		ext2fs_warn_bitmap(EXT2_ET_BAD_INODE_TEST,
diff --git a/misc/filefrag.c b/misc/filefrag.c
index 702cb8d..bd39230 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -171,11 +171,11 @@ int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
 	int count = (sizeof(buf) - sizeof(*fiemap)) /
 			sizeof(struct fiemap_extent);
-	unsigned long long logical_blk = 0, last_blk = 0;
+	unsigned long long last_blk = 0;
 	unsigned long flags = 0;
 	static int fiemap_incompat_printed;
 	int tot_extents = 1, n = 0;
-	int last = 0, eof = 0;
+	int last = 0;
 	int i, rc;
 
 	fiemap->fm_length = ~0ULL;
@@ -220,7 +220,7 @@ int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 			break;
 
 		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
-			__u64 phy_blk, phy_start, logical_blk;
+			__u64 phy_blk, logical_blk;
 			unsigned long ext_len;
 
 			phy_blk = fm_ext[i].fe_physical >> blk_shift;
@@ -267,7 +267,6 @@ static void frag_report(const char *filename)
 	int		is_ext2 = 0;
 	static int	once = 1;
 	unsigned int	flags;
-	unsigned long	first_blk, last_blk;
 	int rc;
 
 #ifdef HAVE_OPEN64
@@ -378,7 +377,6 @@ int main(int argc, char**argv)
 {
 	char **cpp;
 	int c;
-	int ret;
 
 	while ((c = getopt(argc, argv, "bsvx")) != EOF)
 		switch (c) {
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a9b01cb..e10fd35 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -20,6 +20,7 @@
 
 #include <stdio.h>
 #include <string.h>
+#include <strings.h>
 #include <fcntl.h>
 #include <ctype.h>
 #include <time.h>
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 2ad3436..60b50fd 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -975,7 +975,7 @@ static int get_move_bitmaps(ext2_filsys fs, int new_ino_blks_per_grp,
 	blk_t j, needed_blocks = 0;
 	blk_t i_bmap, b_bmap;
 	blk_t start_blk, end_blk;
-	int num, k;
+	int num;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
 		b_bmap = fs->group_desc[i].bg_block_bitmap;

