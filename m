From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] e2fsck: set dir_nlink feature if large dir exists
Date: Fri, 18 Aug 2017 12:19:42 -0600
Message-ID: <1503080382-37376-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:54550 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdHRS1v (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Aug 2017 14:27:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there is a directory with more than EXT2_LINK_MAX (65000)
subdirectories, but the DIR_NLINK feature is not set in the
superblock, the feature should be set before continuing on
to change the on-disk directory link count to 1.

While most filesystems should have DIR_NLINK set (it was set
by default for all ext4 filesystems, and the kernel before
4.12 automatically set it if the directory link count grew
too large), it is possible that this flag is lost due to disk
corruption or for an upgraded filesystem.  We no longer want
the kernel to automatically enable this feature.

Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=196405
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/pass4.c           | 12 +++++++++-
 e2fsck/problem.c         |  5 ++++
 e2fsck/problem.h         |  3 +++
 tests/f_large_dir/expect |  7 ++++--
 tests/f_large_dir/script | 60 ++++++++++++++++++++++++++++++------------------
 5 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 663f87a..d0ff8e9 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -170,6 +170,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 #endif
 	struct problem_context	pctx;
 	__u16	link_count, link_counted;
+	int dir_nlink_fs;
 	char	*buf = 0;
 	dgrp_t	group, maxgroup;
 
@@ -193,6 +194,8 @@ void e2fsck_pass4(e2fsck_t ctx)
 	if (!(ctx->options & E2F_OPT_PREEN))
 		fix_problem(ctx, PR_4_PASS_HEADER, &pctx);
 
+	dir_nlink_fs = ext2fs_has_feature_dir_nlink(fs->super);
+
 	group = 0;
 	maxgroup = fs->group_desc_count;
 	if (ctx->progress)
@@ -249,8 +252,15 @@ void e2fsck_pass4(e2fsck_t ctx)
 					    &link_counted);
 		}
 		isdir = ext2fs_test_inode_bitmap2(ctx->inode_dir_map, i);
-		if (isdir && (link_counted > EXT2_LINK_MAX))
+		if (isdir && (link_counted > EXT2_LINK_MAX)) {
+			if (!dir_nlink_fs &&
+			    fix_problem(ctx, PR_4_DIR_NLINK_FEATURE, &pctx)) {
+				ext2fs_set_feature_dir_nlink(fs->super);
+				ext2fs_mark_super_dirty(fs);
+				dir_nlink_fs = 1;
+			}
 			link_counted = 1;
+		}
 		if (link_counted != link_count) {
 			e2fsck_read_inode_full(ctx, i, EXT2_INODE(inode),
 					       inode_size, "pass4");
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 9706933..25c1de9 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1873,6 +1873,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@a @i %i ref count is %N, @s %n. "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* directory exceeds max links, but no DIR_NLINK feature in superblock*/
+	{ PR_4_DIR_NLINK_FEATURE,
+	  N_("@d exceeds max links, but no DIR_NLINK feature in @S.\n"),
+	  PROMPT_FIX, 0 },
+
 	/* Pass 5 errors */
 
 	/* Pass 5: Checking group summary information */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f30f8f0..07ed0a7 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1134,6 +1134,9 @@ struct problem_context {
 /* Extended attribute inode ref count wrong */
 #define PR_4_EA_INODE_REF_COUNT		0x040005
 
+/* directory exceeds max links, but no DIR_NLINK feature in superblock */
+#define PR_4_DIR_NLINK_FEATURE		0x040006
+
 /*
  * Pass 5 errors
  */
diff --git a/tests/f_large_dir/expect b/tests/f_large_dir/expect
index b099460..4b9ca6f 100644
--- a/tests/f_large_dir/expect
+++ b/tests/f_large_dir/expect
@@ -3,10 +3,13 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 3A: Optimizing directories
 Pass 4: Checking reference counts
-Inode 13 ref count is 1, should be 47245.  Fix? yes
+Directory exceeds max links, but no DIR_NLINK feature in superblock.
+Fix? yes
+
+Inode 12 ref count is 65012, should be 1.  Fix? yes
 
 Pass 5: Checking group summary information
 
 test.img: ***** FILE SYSTEM WAS MODIFIED *****
-test.img: 13/115368 files (0.0% non-contiguous), 32817/460800 blocks
+test.img: 65023/65104 files (0.0% non-contiguous), 96668/100937 blocks
 Exit status is 1
diff --git a/tests/f_large_dir/script b/tests/f_large_dir/script
index 0b5fdff..a10fe16 100644
--- a/tests/f_large_dir/script
+++ b/tests/f_large_dir/script
@@ -5,43 +5,59 @@ E2FSCK=../e2fsck/e2fsck
 NAMELEN=255
 DIRENT_SZ=8
 BLOCKSZ=1024
+INODESZ=128
 DIRENT_PER_LEAF=$((BLOCKSZ / (NAMELEN + DIRENT_SZ)))
 HEADER=32
 INDEX_SZ=8
 INDEX_L1=$(((BLOCKSZ - HEADER) / INDEX_SZ))
 INDEX_L2=$(((BLOCKSZ - DIRENT_SZ) / INDEX_SZ))
 ENTRIES=$((INDEX_L1 * INDEX_L2 * DIRENT_PER_LEAF))
+DIRBLK=$((2 + INDEX_L1 * INDEX_L2))
+EXT4_LINK_MAX=65000
+[ $ENTRIES -lt $((EXT4_LINK_MAX + 10)) ] && ENTRIES=$((EXT4_LINK_MAX + 10))
+FSIZE=$(((DIRBLK + EXT4_LINK_MAX * ((BLOCKSZ + INODESZ) / BLOCKSZ)) * 5 / 4))
 
-cp /dev/null $OUT
-$MKE2FS -b 1024 -O large_dir,uninit_bg,dir_nlink -F $TMPFILE 460800 \
-	> /dev/null 2>&1
+> $OUT
+$MKE2FS -b 1024 -O large_dir,uninit_bg -N $((ENTRIES + 50)) \
+	-I $INODESZ -F $TMPFILE $FSIZE > $OUT 2>&1
+RC=$?
+if [ $RC -eq 0 ]; then
 {
-	echo "feature large_dir"
+	START=$SECONDS
 	echo "mkdir /foo"
 	echo "cd /foo"
-	touch foofile
-	echo "write foofile foofile"
+	touch $TMPFILE.tmp
+	echo "write $TMPFILE.tmp foofile"
 	i=0
-	while test $i  -lt $ENTRIES ; do
-	    if test $(( i % DIRENT_PER_LEAF )) -eq 0 ; then
-		echo "expand ./"
+	while test $i -lt $ENTRIES ; do
+	    if test $((i % DIRENT_PER_LEAF)) -eq 0; then
+	    	echo "expand ./"
 	    fi
-	    if test $(( i % 5000 )) -eq 0 -a $i -gt 0 ; then
-		>&2 echo "$test_name: $i processed"
+	    if test $((i % 5000)) -eq 0 -a $i -gt 0; then
+		ELAPSED=$((SECONDS - START))
+		RATE=$((i / ELAPSED))
+		>&2 echo "$test_name: $i processed in ${ELAPSED}s @ $RATE/s"
 	    fi
-	    printf "ln foofile %0255X\n" $i
-	    i=$(($i + 1))
+	    if test $i -lt $((EXT4_LINK_MAX + 10)); then
+		printf "mkdir d%0254u\n" $i
+	    else
+		printf "ln foofile f%0254u\n" $i
+	    fi
+	    i=$((i + 1))
 	done
-} | $DEBUGFS -w -f /dev/stdin $TMPFILE > /dev/null 2>&1
