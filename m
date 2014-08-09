From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/6] libext2fs: create inlinedata symlinks
Date: Fri, 08 Aug 2014 21:26:17 -0700
Message-ID: <20140809042617.2441.24067.stgit@birch.djwong.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Pu Hou <houpu.hp@alibaba-inc.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18630 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaHIE03 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Aug 2014 00:26:29 -0400
In-Reply-To: <20140809042610.2441.6868.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add to ext2fs_symlink the ability to create inline data symlinks.

Suggested-by: Pu Hou <houpu.hp@alibaba-inc.com>
Cc: Pu Hou <houpu.hp@alibaba-inc.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/symlink.c           |   34 ++++++++++++++++++++---
 tests/f_create_symlinks/expect |   36 ++++++++++++++++++++++++
 tests/f_create_symlinks/name   |    1 +
 tests/f_create_symlinks/script |   59 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 5 deletions(-)
 create mode 100644 tests/f_create_symlinks/expect
 create mode 100644 tests/f_create_symlinks/name
 create mode 100644 tests/f_create_symlinks/script


diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index ba8ed8e..f6eb6b6 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -35,7 +35,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	struct ext2_inode	inode;
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
-	int			fastlink;
+	int			fastlink, inlinelink;
 	unsigned int		target_len;
 	char			*block_buf = 0;
 
@@ -77,15 +77,36 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	memset(&inode, 0, sizeof(struct ext2_inode));
 	inode.i_mode = LINUX_S_IFLNK | 0777;
 	inode.i_uid = inode.i_gid = 0;
-	ext2fs_iblk_set(fs, &inode, fastlink ? 0 : 1);
 	inode.i_links_count = 1;
 	ext2fs_inode_size_set(fs, &inode, target_len);
 	/* The time fields are set by ext2fs_write_new_inode() */
 
+	inlinelink = !fastlink &&
+		     (fs->super->s_feature_incompat &
+					EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+		     (target_len < fs->blocksize);
 	if (fastlink) {
 		/* Fast symlinks, target stored in inode */
 		strcpy((char *)&inode.i_block, target);
+	} else if (inlinelink) {
+		/* Try inserting an inline data symlink */
+		inode.i_flags |= EXT4_INLINE_DATA_FL;
+		retval = ext2fs_write_new_inode(fs, ino, &inode);
+		if (retval)
+			goto cleanup;
+		retval = ext2fs_inline_data_set(fs, ino, &inode, target,
+						target_len);
+		if (retval) {
+			inode.i_flags &= ~EXT4_INLINE_DATA_FL;
+			inlinelink = 0;
+			goto need_block;
+		}
+		retval = ext2fs_read_inode(fs, ino, &inode);
+		if (retval)
+			goto cleanup;
 	} else {
+need_block:
+		ext2fs_iblk_set(fs, &inode, 1);
 		/* Slow symlinks, target stored in the first block */
 		memset(block_buf, 0, fs->blocksize);
 		strcpy(block_buf, target);
@@ -104,11 +125,14 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	 * number is assigned by write_new_inode, which means that the
 	 * operations using ino must come after it.
 	 */
-	retval = ext2fs_write_new_inode(fs, ino, &inode);
+	if (inlinelink)
+		retval = ext2fs_write_inode(fs, ino, &inode);
+	else
+		retval = ext2fs_write_new_inode(fs, ino, &inode);
 	if (retval)
 		goto cleanup;
 
-	if (!fastlink) {
+	if (!fastlink && !inlinelink) {
 		retval = ext2fs_bmap2(fs, ino, &inode, NULL, BMAP_SET, 0, NULL,
 				      &blk);
 		if (retval)
@@ -139,7 +163,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	/*
 	 * Update accounting....
 	 */
-	if (!fastlink)
+	if (!fastlink && !inlinelink)
 		ext2fs_block_alloc_stats2(fs, blk, +1);
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 0);
 
diff --git a/tests/f_create_symlinks/expect b/tests/f_create_symlinks/expect
new file mode 100644
index 0000000..847e092
--- /dev/null
+++ b/tests/f_create_symlinks/expect
@@ -0,0 +1,36 @@
+mke2fs -q -F -o Linux -b 1024 -g 256 -O inline_data,extents -I 256 test.img 1024
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 441/1024 blocks
+Exit status is 0
+stat /l_30
+Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
+User:     0   Group:     0   Size: 31
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+Fast link dest: "/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
+stat /l_70
+Inode: 13   Type: symlink    Mode:  0777   Flags: 0x10000000
+User:     0   Group:     0   Size: 71
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+Extended attributes:
+  system.data (11)
+Fast link dest: "/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
+stat /l_500
+Inode: 14   Type: symlink    Mode:  0777   Flags: 0x80000
+User:     0   Group:     0   Size: 501
+Links: 1   Blockcount: 2
+Fragment:  Address: 0    Number: 0    Size: 0
+stat /l_1500
+/l_1500: File not found by ext2_lookup 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 14/128 files (0.0% non-contiguous), 442/1024 blocks
+Exit status is 0
diff --git a/tests/f_create_symlinks/name b/tests/f_create_symlinks/name
new file mode 100644
index 0000000..0930e79
--- /dev/null
+++ b/tests/f_create_symlinks/name
@@ -0,0 +1 @@
+create fast, inlinedata, and regular symlinks
diff --git a/tests/f_create_symlinks/script b/tests/f_create_symlinks/script
new file mode 100644
index 0000000..c49825a
--- /dev/null
+++ b/tests/f_create_symlinks/script
@@ -0,0 +1,59 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-yf
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -b 1024 -g 256 -O inline_data,extents -I 256 test.img 1024 >> $OUT
+$MKE2FS -q -F -o Linux -b 1024 -g 256 -O inline_data,extents -I 256 $TMPFILE 1024 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
+
+$FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+for i in 30 70 500 1500; do
+	echo "symlink /l_$i /$(perl -e "print 'x' x $i;")"
+done | $DEBUGFS -w $TMPFILE >/dev/null 2>&1
+
+for i in 30 70 500 1500; do
+	echo "stat /l_$i" >> $OUT
+	$DEBUGFS -R "stat /l_$i" $TMPFILE 2>&1 | egrep '(File not found|^Inode|^Fast link dest|Blockcount:|^Extended attributes:|system.data|Size:)' >> $OUT
+done
+
+$FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

