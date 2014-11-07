From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/47] resize2fs: set bg flags and unused inode count when
 resizing
Date: Fri, 07 Nov 2014 13:53:48 -0800
Message-ID: <20141107215348.883.19810.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46056 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaKGVxx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:53:53 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Recalculate the unused inode count and the block/inode uninit flags
when resizing a filesystem.  This can speed up future e2fsck runs
considerably and will reduce mount times.

v2: Use a library function to take care of this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c              |    4 ++++
 tests/r_fixup_lastbg/expect     |   39 +++++++++++++++++++++++++++++++++++
 tests/r_fixup_lastbg/script     |   37 ++++++++++++++++++++++++++++++++++
 tests/r_fixup_lastbg_big/expect |   43 +++++++++++++++++++++++++++++++++++++++
 tests/r_fixup_lastbg_big/script |   37 ++++++++++++++++++++++++++++++++++
 5 files changed, 160 insertions(+)
 create mode 100644 tests/r_fixup_lastbg/expect
 create mode 100755 tests/r_fixup_lastbg/script
 create mode 100644 tests/r_fixup_lastbg_big/expect
 create mode 100755 tests/r_fixup_lastbg_big/script


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index da1ec9c..94c0643 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -198,6 +198,10 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	if (retval)
 		goto errout;
 
+	retval = ext2fs_set_gdt_csum(rfs->new_fs);
+	if (retval)
+		goto errout;
+
 	rfs->new_fs->super->s_state &= ~EXT2_ERROR_FS;
 	rfs->new_fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 
diff --git a/tests/r_fixup_lastbg/expect b/tests/r_fixup_lastbg/expect
new file mode 100644
index 0000000..96b154a
--- /dev/null
+++ b/tests/r_fixup_lastbg/expect
@@ -0,0 +1,39 @@
+Creating filesystem with 20000 1k blocks and 1248 inodes
+Superblock backups stored on blocks: 
+	8193
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Creating journal (1024 blocks): done
+Writing superblocks and filesystem accounting information:    done
+
+Group 2: (Blocks 16385-19999) [INODE_UNINIT, ITABLE_ZEROED]
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
+  Inode table at 295-398 (bg #0 + 294)
+  3615 free blocks, 416 free inodes, 0 directories, 416 unused inodes
+  Free blocks: 16385-19999
+  Free inodes: 833-1248
+Group 2: (Blocks 16385-19999)
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
+  Inode table at 295-398 (bg #0 + 294)
+  3615 free blocks, 416 free inodes, 0 directories
+  Free blocks: 16385-19999
+  Free inodes: 833-1248
+Resizing the filesystem on test.img to 20004 (1k) blocks.
+The filesystem on test.img is now 20004 (1k) blocks long.
+
+Group 2: (Blocks 16385-20003) [INODE_UNINIT]
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
+  Inode table at 295-398 (bg #0 + 294)
+  3619 free blocks, 416 free inodes, 0 directories, 416 unused inodes
+  Free blocks: 16385-20003
+  Free inodes: 833-1248
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test.img: 11/1248 files (0.0% non-contiguous), 1517/20004 blocks
diff --git a/tests/r_fixup_lastbg/script b/tests/r_fixup_lastbg/script
new file mode 100755
index 0000000..6a5c5af
--- /dev/null
+++ b/tests/r_fixup_lastbg/script
@@ -0,0 +1,37 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+test_description="fix up last bg when expanding within the last bg"
+
+EXP=$test_dir/expect
+OUT=$test_name.out
+LOG=$test_name.log
+E2FSCK=../e2fsck/e2fsck
+
+$MKE2FS -T ext4 -b 1024 -F -U 56d3ee50-8532-4f29-8181-d7c6ea4a94a6 $TMPFILE 20000 > $OUT 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | grep -A10 '^Group 2:' >> $OUT
+$DEBUGFS -R "set_bg 2 itable_unused 0" -w $TMPFILE > /dev/null 2>&1
+$DEBUGFS -R "set_bg 2 flags 0" -w $TMPFILE > /dev/null 2>&1
+$DEBUGFS -R "set_bg 2 checksum 0xd318" -w $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | grep -A10 '^Group 2:' >> $OUT
+#dd if=/dev/zero of=$TMPFILE bs=1 count=1 seek=$((1024 * 20004)) conv=notrunc >> $OUT 2> /dev/null
+$RESIZE2FS_EXE -f -p $TMPFILE 20004 >> $OUT 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | grep -A10 '^Group 2:' >> $OUT
+$E2FSCK -fy $TMPFILE >> $OUT 2>&1
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" < $OUT > $LOG
+rm -rf $OUT
+
+cmp -s $LOG $EXP
+RC=$?
+if [ $RC -eq 0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff -u $EXP $LOG > $test_name.failed
+fi
+
+unset EXP LOG OUT E2FSCK
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/r_fixup_lastbg_big/expect b/tests/r_fixup_lastbg_big/expect
new file mode 100644
index 0000000..8f302a3
--- /dev/null
+++ b/tests/r_fixup_lastbg_big/expect
@@ -0,0 +1,43 @@
+Creating filesystem with 20000 1k blocks and 1248 inodes
+Superblock backups stored on blocks: 
+	8193
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Creating journal (1024 blocks): done
+Writing superblocks and filesystem accounting information:    done
+
+Group 2: (Blocks 16385-19999) [INODE_UNINIT, ITABLE_ZEROED]
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
+  Inode table at 295-398 (bg #0 + 294)
+  3615 free blocks, 416 free inodes, 0 directories, 416 unused inodes
+  Free blocks: 16385-19999
+  Free inodes: 833-1248
+Group 2: (Blocks 16385-19999)
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
+  Inode table at 295-398 (bg #0 + 294)
+  3615 free blocks, 416 free inodes, 0 directories
+  Free blocks: 16385-19999
+  Free inodes: 833-1248
+Resizing the filesystem on test.img to 40000 (1k) blocks.
+The filesystem on test.img is now 40000 (1k) blocks long.
+
+Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT]
+  Block bitmap at 83 (bg #0 + 82)
+  Inode bitmap at 86 (bg #0 + 85)
+  Inode table at 295-398 (bg #0 + 294)
+  8192 free blocks, 416 free inodes, 0 directories, 416 unused inodes
+  Free blocks: 16385-24576
+  Free inodes: 833-1248
+Group 3: (Blocks 24577-32768) [INODE_UNINIT]
+  Backup superblock at 24577, Group descriptors at 24578-24578
+  Reserved GDT blocks at 24579-24656
+  Block bitmap at 413 (bg #0 + 412)
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test.img: 11/2080 files (0.0% non-contiguous), 1809/40000 blocks
diff --git a/tests/r_fixup_lastbg_big/script b/tests/r_fixup_lastbg_big/script
new file mode 100755
index 0000000..4c4a351
--- /dev/null
+++ b/tests/r_fixup_lastbg_big/script
@@ -0,0 +1,37 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+test_description="fix up last bg when expanding beyond the last bg"
+
+EXP=$test_dir/expect
+OUT=$test_name.out
+LOG=$test_name.log
+E2FSCK=../e2fsck/e2fsck
+
+$MKE2FS -T ext4 -b 1024 -F -U 56d3ee50-8532-4f29-8181-d7c6ea4a94a6 $TMPFILE 20000 > $OUT 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | grep -A10 '^Group 2:' >> $OUT
+$DEBUGFS -R "set_bg 2 itable_unused 0" -w $TMPFILE > /dev/null 2>&1
+$DEBUGFS -R "set_bg 2 flags 0" -w $TMPFILE > /dev/null 2>&1
+$DEBUGFS -R "set_bg 2 checksum 0xd318" -w $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | grep -A10 '^Group 2:' >> $OUT
+dd if=/dev/zero of=$TMPFILE bs=1 count=1 seek=$((1024 * 40000)) conv=notrunc >> $OUT 2> /dev/null
+$RESIZE2FS_EXE -f -p $TMPFILE >> $OUT 2>&1
+$DUMPE2FS $TMPFILE 2>&1 | grep -A10 '^Group 2:' >> $OUT
+$E2FSCK -fy $TMPFILE >> $OUT 2>&1
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" < $OUT > $LOG
+rm -rf $OUT
+
+cmp -s $LOG $EXP
+RC=$?
+if [ $RC -eq 0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff -u $EXP $LOG > $test_name.failed
+fi
+
+unset EXP LOG OUT E2FSCK
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

