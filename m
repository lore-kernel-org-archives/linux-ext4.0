From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] mke2fs: fix hugefile creation so the hugefile(s) are contiguous
Date: Thu, 22 Jun 2017 20:00:09 -0400
Message-ID: <20170623000009.27984-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34224 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753877AbdFWAAQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Jun 2017 20:00:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 4f868703f6f2: "libext2fs: use fallocate for creating journals
and hugefiles" introduced a regression for the mke2fs hugefile
feature.  The problem is that the fallocate library function
intersperses the extent tree metadata blocks with the data blocks, and
this violates the hugefile guarantee that the created files should be
physically contiguous on disk.

Unfortuantely the m_hugefile regression test was flawed, and didn't
pick up the regression.

This commit fixes the regression test so that it detects the problem
before fixing mke2fs, and also fixes the mke2fs hugefile by reverting
the mke2fs hugefile portion of commit 4f868703f6f2.

Google-Bug-Id: 62791459

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/mk_hugefiles.c     | 107 ++++++++++++++++++++++++++++++++++++++++++------
 misc/mke2fs.conf.5.in   |   6 ++-
 tests/m_hugefile/expect |  23 ++---------
 tests/m_hugefile/script |  52 ++++++++++++++++++++++-
 4 files changed, 152 insertions(+), 36 deletions(-)

diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index 5882394d..f34fa411 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -262,8 +262,12 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
 
 {
 	errcode_t		retval;
+	blk64_t			lblk, bend = 0;
+	__u64			size;
+	blk64_t			left;
+	blk64_t			count = 0;
 	struct ext2_inode	inode;
-	int			falloc_flags;
+	ext2_extent_handle_t	handle;
 
 	retval = ext2fs_new_inode(fs, 0, LINUX_S_IFREG, NULL, ino);
 	if (retval)
@@ -283,20 +287,93 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
 
 	ext2fs_inode_alloc_stats2(fs, *ino, +1, 0);
 
-	if (ext2fs_has_feature_extents(fs->super))
-		inode.i_flags |= EXT4_EXTENTS_FL;
-
-	falloc_flags = EXT2_FALLOCATE_FORCE_INIT;
-	if (zero_hugefile)
-		falloc_flags |= EXT2_FALLOCATE_ZERO_BLOCKS;
-	retval = ext2fs_fallocate(fs, falloc_flags, *ino, &inode, goal, 0, num);
+	retval = ext2fs_extent_open2(fs, *ino, &inode, &handle);
 	if (retval)
 		return retval;
-	retval = ext2fs_inode_size_set(fs, &inode, num * fs->blocksize);
+
+	/*
+	 * We don't use ext2fs_fallocate() here because hugefiles are
+	 * designed to be physically contiguous (if the block group
+	 * descriptors are configured to be in a single block at the
+	 * beginning of the file system, by using the
+	 * packed_meta_blocks layout), with the extent tree blocks
+	 * allocated near the beginning of the file system.
+	 */
+	lblk = 0;
+	left = num ? num : 1;
+	while (left) {
+		blk64_t pblk, end;
+		blk64_t n = left;
+
+		retval =  ext2fs_find_first_zero_block_bitmap2(fs->block_map,
+			goal, ext2fs_blocks_count(fs->super) - 1, &end);
+		if (retval)
+			goto errout;
+		goal = end;
+
+		retval =  ext2fs_find_first_set_block_bitmap2(fs->block_map, goal,
+			       ext2fs_blocks_count(fs->super) - 1, &bend);
+		if (retval == ENOENT) {
+			bend = ext2fs_blocks_count(fs->super);
+			if (num == 0)
+				left = 0;
+		}
+		if (!num || bend - goal < left)
+			n = bend - goal;
+		pblk = goal;
+		if (num)
+			left -= n;
+		goal += n;
+		count += n;
+		ext2fs_block_alloc_stats_range(fs, pblk, n, +1);
+
+		if (zero_hugefile) {
+			blk64_t ret_blk;
+			retval = ext2fs_zero_blocks2(fs, pblk, n,
+						     &ret_blk, NULL);
+
+			if (retval)
+				com_err(program_name, retval,
+					_("while zeroing block %llu "
+					  "for hugefile"), ret_blk);
+		}
+
+		while (n) {
+			blk64_t l = n;
+			struct ext2fs_extent newextent;
+
+			if (l > EXT_INIT_MAX_LEN)
+				l = EXT_INIT_MAX_LEN;
+
+			newextent.e_len = l;
+			newextent.e_pblk = pblk;
+			newextent.e_lblk = lblk;
+			newextent.e_flags = 0;
+
+			retval = ext2fs_extent_insert(handle,
+					EXT2_EXTENT_INSERT_AFTER, &newextent);
+			if (retval)
+				return retval;
+			pblk += l;
+			lblk += l;
+			n -= l;
+		}
+	}
+
+	retval = ext2fs_read_inode(fs, *ino, &inode);
 	if (retval)
-		return retval;
+		goto errout;
 
-	retval = ext2fs_write_inode(fs, *ino, &inode);
+	retval = ext2fs_iblk_add_blocks(fs, &inode,
+					count / EXT2FS_CLUSTER_RATIO(fs));
+	if (retval)
+		goto errout;
+	size = (__u64) count * fs->blocksize;
+	retval = ext2fs_inode_size_set(fs, &inode, size);
+	if (retval)
+		goto errout;
+
+	retval = ext2fs_write_new_inode(fs, *ino, &inode);
 	if (retval)
 		goto errout;
 
@@ -314,7 +391,13 @@ retry:
 		goto retry;
 	}
 
+	if (retval)
+		goto errout;
+
 errout:
+	if (handle)
+		ext2fs_extent_free(handle);
+
 	return retval;
 }
 
@@ -499,8 +582,6 @@ errcode_t mk_hugefiles(ext2_filsys fs, const char *device_name)
 			printf(_("with %llu blocks each"), num_blocks);
 		fputs(": ", stdout);
 	}
-	if (num_blocks == 0)
-		num_blocks = ext2fs_blocks_count(fs->super) - goal;
 	for (i=0; i < num_files; i++) {
 		ext2_ino_t ino;
 
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index 1ce0f5eb..da105d6b 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -441,7 +441,11 @@ command line option to
 .TP
 .I make_hugefiles
 This boolean relation enables the creation of pre-allocated files as
-part of formatting the file system.
+part of formatting the file system.  If the file system is configured so
+that the block group descriptors are located at beginning file system
+space (by using the packed_meta_blocks option), the data blocks of the
+huge files will be contiguous, with the extent tree blocks allocated
+near the beginning of the file system space.
 .TP
 .I hugefiles_uid
 This relation controls the user ownership for all of the files and
diff --git a/tests/m_hugefile/expect b/tests/m_hugefile/expect
index 82a60319..831d31ad 100644
--- a/tests/m_hugefile/expect
+++ b/tests/m_hugefile/expect
@@ -14,23 +14,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 
 Exit status is 0
-debugfs -R "extents /store/big-data" test.img | head
-Level Entries                 Logical                Physical Length Flags
- 0/ 2   1/  1          0 - 1073610751     131070              1073610752
- 1/ 2   1/ 97          0 -   11108351     131071              11108352
- 2/ 2   1/339          0 -      32767     131072 -     163839  32768 
- 2/ 2   2/339      32768 -      65535     163840 -     196607  32768 
- 2/ 2   3/339      65536 -      98303     196608 -     229375  32768 
- 2/ 2   4/339      98304 -     131071     229376 -     262143  32768 
- 2/ 2   5/339     131072 -     163839     262144 -     294911  32768 
- 2/ 2   6/339     163840 -     196607     294912 -     327679  32768 
- 2/ 2   7/339     196608 -     229375     327680 -     360447  32768 
- 2/ 2   8/339     229376 -     262143     360448 -     393215  32768 
- 2/ 2   9/339     262144 -     294911     393216 -     425983  32768 
- 2/ 2  10/339     294912 -     327679     425984 -     458751  32768 
- 2/ 2  11/339     327680 -     360447     458752 -     491519  32768 
- 2/ 2  12/339     360448 -     393215     491520 -     524287  32768 
- 2/ 2  13/339     393216 -     425983     524288 -     557055  32768 
- 2/ 2  14/339     425984 -     458751     557056 -     589823  32768 
- 2/ 2  15/339     458752 -     491519     589824 -     622591  32768 
- 2/ 2  16/339     491520 -     524287     622592 -     655359  32768 
+debugfs -R "extents /store/big-data" test.img
+Last logical block: 1073610751
+Last physical block: 1073741823
diff --git a/tests/m_hugefile/script b/tests/m_hugefile/script
index 2750d538..d2b92e2f 100644
--- a/tests/m_hugefile/script
+++ b/tests/m_hugefile/script
@@ -44,9 +44,57 @@ $FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
 status=$?
 echo Exit status is $status >> $OUT
 
-echo 'debugfs -R "extents /store/big-data" test.img | head' >> $OUT
+echo 'debugfs -R "extents /store/big-data" test.img' >> $OUT
 
-$DEBUGFS -R "extents /store/big-data" $TMPFILE 2>&1 | head -n 20 >> $OUT 2>&1
+$DEBUGFS -R "extents /store/big-data" $TMPFILE 2>&1 | tr / " " | tr -d - | awk '
+BEGIN {
+	expected_logical_start = 0;
+	expected_physical_start = 0;
+}
+{
+	if (NR != 1) {
+		level = $1;
+		total_levels = $2;
+
+		if (level == total_levels) {
+			logical_start=$5;
+			logical_end=$6;
+			physical_start=$7;
+			physical_end=$8;
+			len = $9;
+
+			if (logical_end + 1 - logical_start != len) {
+			  print logical_end + 1 - logical_start, len;
+				print "UNEXPECTED LENGTH for extent", $0;
+			}
+			if (physical_end + 1 - physical_start != len) {
+			  print physical_end + 1 - physical_start, len;
+				print "UNEXPECTED LENGTH for extent", $0;
+			}
+
+			if (logical_start != expected_logical_start) {
+				print "UNEXPECTED LOGICAL DISCONTINUITY between extents:";
+				print "\t", prev;
+				print "\t", $0;
+			}
+			if (physical_start != expected_physical_start &&
+				expected_logical_start != 0) {
+				print "PHYSICAL DISCONTINUITY between extents:";
+				print "\t", prev;
+				print "\t", $0;
+			}
+
+			expected_logical_start = logical_end + 1;
+			expected_physical_start = physical_end + 1;
+		}
+	}
+	prev=$0;
+}
+END {
+    print "Last logical block:", expected_logical_start-1;
+    print "Last physical block:", expected_physical_start-1;
+}
+' >> $OUT 2>&1
 
 rm $TMPFILE
 
-- 
2.11.0.rc0.7.gbe5a750
