From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 26/35] mke2fs: add simple tests and re-alphabetize mke2fs
 manpage options
Date: Wed, 01 Apr 2015 19:36:53 -0700
Message-ID: <20150402023653.25243.95931.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48812 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbbDBCg6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:36:58 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add some simple tests for mke2fs -d (create image from dir) and make
the manpage options appear in alphabetic order.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.8.in              |   15 ++-
 tests/m_devdir/script         |   33 ++++++
 tests/m_minrootdir/expect     |  216 +++++++++++++++++++++++++++++++++++++++++
 tests/m_minrootdir/output.sed |    5 +
 tests/m_minrootdir/script     |   81 +++++++++++++++
 tests/m_rootdir/expect        |  117 ++++++++++++++++++++++
 tests/m_rootdir/output.sed    |    5 +
 tests/m_rootdir/script        |   71 +++++++++++++
 8 files changed, 536 insertions(+), 7 deletions(-)
 create mode 100644 tests/m_devdir/script
 create mode 100644 tests/m_minrootdir/expect
 create mode 100644 tests/m_minrootdir/output.sed
 create mode 100644 tests/m_minrootdir/script
 create mode 100644 tests/m_rootdir/expect
 create mode 100644 tests/m_rootdir/output.sed
 create mode 100644 tests/m_rootdir/script


diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 3230f65..40c40d3 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -18,6 +18,10 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 .I block-size
 ]
 [
+.B \-d
+.I root-directory
+]
+[
 .B \-D
 ]
 [
@@ -52,10 +56,6 @@ mke2fs \- create an ext2/ext3/ext4 filesystem
 .I number-of-inodes
 ]
 [
-.B \-d
-.I root-directory
-]
-[
 .B \-n
 ]
 [
@@ -237,6 +237,10 @@ enabled.  (See the
 man page for more details about bigalloc.)   The default cluster size if
 bigalloc is enabled is 16 times the block size.
 .TP
+.BI \-d " root-directory"
+Copy the contents of the given directory into the root directory of the
+filesystem.
+.TP
 .B \-D
 Use direct I/O when writing to the disk.  This avoids mke2fs dirtying a
 lot of buffer cache memory, which may impact other applications running
@@ -589,9 +593,6 @@ the
 ratio).  This allows the user to specify the number
 of desired inodes directly.
 .TP
-.BI \-d " root-directory"
-Add the files from the root-directory to the filesystem.
-.TP
 .BI \-o " creator-os"
 Overrides the default value of the "creator operating system" field of the
 filesystem.  The creator field is set by default to the name of the OS the
diff --git a/tests/m_devdir/script b/tests/m_devdir/script
new file mode 100644
index 0000000..5f26699
--- /dev/null
+++ b/tests/m_devdir/script
@@ -0,0 +1,33 @@
+if test -x $DEBUGFS_EXE; then
+
+test_description="create fs image from /dev"
+MKFS_DIR=/dev
+OUT=$test_name.log
+
+$MKE2FS -q -F -o Linux -T ext4 -O metadata_csum,64bit -E lazy_itable_init=1 -b 1024 -d $MKFS_DIR $TMPFILE 16384 > $OUT 2>&1
+mkfs_status=$?
+
+$DUMPE2FS $TMPFILE >> $OUT 2>&1
+$DEBUGFS -R 'ls /' $TMPFILE >> $OUT 2>&1
+
+$FSCK -f -n $TMPFILE >> $OUT 2>&1
+fsck_status=$?
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" < $OUT > $OUT.tmp
+mv $OUT.tmp $OUT
+
+if [ $mkfs_status -ne 0 ]; then
+	echo "$test_name: $test_description: skipped"
+elif [ $mkfs_status -eq 0 ] && [ $fsck_status -eq 0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+        echo "$test_name: $test_description: failed"
+fi
+
+rm -rf $TMPFILE.cmd $OUT.sed
+unset MKFS_DIR OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/m_minrootdir/expect b/tests/m_minrootdir/expect
new file mode 100644
index 0000000..41a713f
--- /dev/null
+++ b/tests/m_minrootdir/expect
@@ -0,0 +1,216 @@
+create fs
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr dir_index filetype extent 64bit flex_bg sparse_super huge_file dir_nlink extra_isize metadata_csum
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              1024
+Block count:              16384
+Reserved block count:     819
+Free blocks:              16065
+Free inodes:              1006
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Group descriptor size:    64
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         512
+Inode blocks per group:   128
+Flex block group size:    16
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          256
+Required extra isize:     28
+Desired extra isize:      28
+Default directory hash:   half_md4
+Checksum type:            crc32c
+
+
+Group 0: (Blocks 1-8192)
+  Primary superblock at 1, Group descriptors at 2-2
+  Block bitmap at 3 (+2)
+  Inode bitmap at 5 (+4)
+  Inode table at 7-134 (+6)
+  7876 free blocks, 494 free inodes, 4 directories, 494 unused inodes
+  Free blocks: 317-8192
+  Free inodes: 19-512
+Group 1: (Blocks 8193-16383) [INODE_UNINIT]
+  Backup superblock at 8193, Group descriptors at 8194-8194
+  Block bitmap at 4 (bg #0 + 3)
+  Inode bitmap at 6 (bg #0 + 5)
+  Inode table at 135-262 (bg #0 + 134)
+  8189 free blocks, 512 free inodes, 0 directories, 512 unused inodes
+  Free blocks: 8195-16383
+  Free inodes: 513-1024
+debugfs: stat /emptyfile
+Inode: III   Type: regular    
+Size: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /bigfile
+Inode: III   Type: regular    
+Size: 32768
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /sparsefile
+Inode: III   Type: regular    
+Size: 1073741825
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /bigzerofile
+Inode: III   Type: regular    
+Size: 1073741825
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /fifo
+debugfs: stat /emptydir
+Inode: III   Type: directory    
+Size: 1024
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /dir
+Inode: III   Type: directory    
+Size: 1024
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /dir/file
+Inode: III   Type: regular    
+Size: 8
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: ex /emptyfile
+Level Entries       Logical      Physical Length Flags
+debugfs: ex /bigfile
+Level Entries       Logical      Physical Length Flags
+X 0/0 1/1 0-31 AAA-BBB 32 
+debugfs: ex /sparsefile
+Level Entries           Logical      Physical Length Flags
+Y 0/1 1/1 1-1048576 AAA 1048576
+X 1/1 1/5 1-1 AAA-BBB 1 
+X 1/1 2/5 512-512 AAA-BBB 1 
+X 1/1 3/5 1024-1024 AAA-BBB 1 
+X 1/1 4/5 524288-524288 AAA-BBB 1 
+X 1/1 5/5 1048576-1048576 AAA-BBB 1 
+debugfs: ex /bigzerofile
+Level Entries           Logical      Physical Length Flags
+debugfs: ex /dir
+Level Entries       Logical      Physical Length Flags
+X 0/0 1/1 0-0 AAA-BBB 1 
+debugfs: ex /dir/file
+Level Entries       Logical      Physical Length Flags
+X 0/0 1/1 0-0 AAA-BBB 1 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test.img: 18/1024 files (0.0% non-contiguous), 319/16384 blocks
+minify fs
+Setting reserved blocks percentage to 0% (0 blocks)
+Resizing the filesystem on test.img to 338 (1k) blocks.
+The filesystem on test.img is now 338 (1k) blocks long.
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr dir_index filetype extent 64bit flex_bg sparse_super huge_file dir_nlink extra_isize metadata_csum
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              512
+Block count:              338
+Reserved block count:     0
+Free blocks:              151
+Free inodes:              494
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Group descriptor size:    64
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         512
+Inode blocks per group:   128
+Flex block group size:    16
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          256
+Required extra isize:     28
+Desired extra isize:      28
+Default directory hash:   half_md4
+Checksum type:            crc32c
+
+
+Group 0: (Blocks 1-337)
+  Primary superblock at 1, Group descriptors at 2-2
+  Block bitmap at 3 (+2)
+  Inode bitmap at 5 (+4)
+  Inode table at 7-134 (+6)
+  151 free blocks, 494 free inodes, 4 directories, 494 unused inodes
+  Free blocks: 4, 6, 135-262, 317-337
+  Free inodes: 19-512
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test.img: 18/512 files (0.0% non-contiguous), 187/338 blocks
+minify fs (2)
+Setting reserved blocks percentage to 0% (0 blocks)
+Resizing the filesystem on test.img to 188 (1k) blocks.
+The filesystem on test.img is now 188 (1k) blocks long.
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr dir_index filetype extent 64bit flex_bg sparse_super huge_file dir_nlink extra_isize metadata_csum
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              512
+Block count:              188
+Reserved block count:     0
+Free blocks:              1
+Free inodes:              494
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Group descriptor size:    64
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         512
+Inode blocks per group:   128
+Flex block group size:    16
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          256
+Required extra isize:     28
+Desired extra isize:      28
+Default directory hash:   half_md4
+Checksum type:            crc32c
+
+
+Group 0: (Blocks 1-187)
+  Primary superblock at 1, Group descriptors at 2-2
+  Block bitmap at 3 (+2)
+  Inode bitmap at 5 (+4)
+  Inode table at 7-134 (+6)
+  1 free blocks, 494 free inodes, 4 directories, 494 unused inodes
+  Free blocks: 187
+  Free inodes: 19-512
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test.img: 18/512 files (5.6% non-contiguous), 187/188 blocks
diff --git a/tests/m_minrootdir/output.sed b/tests/m_minrootdir/output.sed
new file mode 100644
index 0000000..2e76967
--- /dev/null
+++ b/tests/m_minrootdir/output.sed
@@ -0,0 +1,5 @@
+s/^[[:space:]]*\([0-9]*\)\/[[:space:]]*\([0-9]*\)[[:space:]]*\([0-9]*\)\/[[:space:]]*\([0-9]*\)[[:space:]]*\([0-9]*\)[[:space:]]*-[[:space:]]*\([0-9]*\)[[:space:]]*[0-9]*[[:space:]]*-[[:space:]]*[0-9]*[[:space:]]*\([0-9]*\)/X \1\/\2 \3\/\4 \5-\6 AAA-BBB \7/g
+s/^[[:space:]]*\([0-9]*\)\/[[:space:]]*\([0-9]*\)[[:space:]]*\([0-9]*\)\/[[:space:]]*\([0-9]*\)[[:space:]]*\([0-9]*\)[[:space:]]*-[[:space:]]*\([0-9]*\)[[:space:]]*[0-9]*[[:space:]]*\([0-9]*\)/Y \1\/\2 \3\/\4 \5-\6 AAA \7/g
+s/Mode:.*$//g
+s/User:.*Size:/Size:/g
+s/^Inode: [0-9]*/Inode: III/g
diff --git a/tests/m_minrootdir/script b/tests/m_minrootdir/script
new file mode 100644
index 0000000..662e76f
--- /dev/null
+++ b/tests/m_minrootdir/script
@@ -0,0 +1,81 @@
+if test -x $DEBUGFS_EXE -a -x $RESIZE2FS_EXE; then
+
+test_description="create fs image from dir, then minimize it"
+MKFS_DIR=$TMPFILE.dir
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+rm -rf $MKFS_DIR
+mkdir -p $MKFS_DIR
+mkdir $MKFS_DIR/dir
+mkdir $MKFS_DIR/emptydir
+dd if=/dev/zero of=$MKFS_DIR/bigzerofile bs=1 count=1 seek=1073741824 2> /dev/null
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=1024 2> /dev/null
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=524288 conv=notrunc 2> /dev/null
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=1048576 conv=notrunc 2> /dev/null
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=536870912 conv=notrunc 2> /dev/null
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=1073741824 conv=notrunc 2> /dev/null
+dd if=/dev/zero bs=1024 count=32 2> /dev/null | tr '\0' 'a' > $MKFS_DIR/bigfile
+touch $MKFS_DIR/emptyfile
+echo "Test me" > $MKFS_DIR/dir/file
+
+echo "create fs" > $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^has_journal,metadata_csum,64bit,^resize_inode -E lazy_itable_init=1 -b 1024 -d $MKFS_DIR $TMPFILE 16384 >> $OUT 2>&1
+
+$DUMPE2FS $TMPFILE >> $OUT 2>&1
+cat > $TMPFILE.cmd << ENDL
+stat /emptyfile
+stat /bigfile
+stat /sparsefile
+stat /bigzerofile
+stat /fifo
+stat /emptydir
+stat /dir
+stat /dir/file
+ENDL
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE 2>&1 | egrep "(stat|Size:|Type:)" | sed -f $test_dir/output.sed >> $OUT
+
+cat > $TMPFILE.cmd << ENDL
+ex /emptyfile
+ex /bigfile
+ex /sparsefile
+ex /bigzerofile
+ex /dir
+ex /dir/file
+ENDL
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $test_dir/output.sed >> $OUT
+$FSCK -f -n $TMPFILE >> $OUT 2>&1
+
+echo "minify fs" >> $OUT
+$TUNE2FS -m 0 $TMPFILE >> $OUT 2>&1
+$RESIZE2FS -M $TMPFILE >> $OUT 2>&1
+$DUMPE2FS $TMPFILE >> $OUT 2>&1
+$FSCK -f -n $TMPFILE >> $OUT 2>&1
+
+echo "minify fs (2)" >> $OUT
+$TUNE2FS -m 0 $TMPFILE >> $OUT 2>&1
+$RESIZE2FS -M $TMPFILE >> $OUT 2>&1
+$DUMPE2FS $TMPFILE >> $OUT 2>&1
+$FSCK -f -n $TMPFILE >> $OUT 2>&1
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" < $OUT > $OUT.tmp
+mv $OUT.tmp $OUT
+
+# Do the verification
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+        echo "$test_name: $test_description: failed"
+        diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+rm -rf $TMPFILE.cmd $MKFS_DIR $OUT.sed
+unset MKFS_DIR OUT EXP
+
+else #if test -x $DEBUGFS_EXE -a -x RESIZE2FS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/m_rootdir/expect b/tests/m_rootdir/expect
new file mode 100644
index 0000000..a5314f1
--- /dev/null
+++ b/tests/m_rootdir/expect
@@ -0,0 +1,117 @@
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super huge_file dir_nlink extra_isize metadata_csum
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              1024
+Block count:              16384
+Reserved block count:     819
+Free blocks:              14786
+Free inodes:              1005
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Group descriptor size:    64
+Reserved GDT blocks:      127
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         512
+Inode blocks per group:   128
+Flex block group size:    16
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          256
+Required extra isize:     28
+Desired extra isize:      28
+Journal inode:            8
+Default directory hash:   half_md4
+Journal backup:           inode blocks
+Checksum type:            crc32c
+Journal features:         (none)
+Journal size:             1024k
+Journal length:           1024
+Journal sequence:         0x00000001
+Journal start:            0
+
+
+Group 0: (Blocks 1-8192)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-129
+  Block bitmap at 130 (+129)
+  Inode bitmap at 132 (+131)
+  Inode table at 134-261 (+133)
+  7748 free blocks, 493 free inodes, 4 directories, 493 unused inodes
+  Free blocks: 445-8192
+  Free inodes: 20-512
+Group 1: (Blocks 8193-16383) [INODE_UNINIT]
+  Backup superblock at 8193, Group descriptors at 8194-8194
+  Reserved GDT blocks at 8195-8321
+  Block bitmap at 131 (bg #0 + 130)
+  Inode bitmap at 133 (bg #0 + 132)
+  Inode table at 262-389 (bg #0 + 261)
+  7038 free blocks, 512 free inodes, 0 directories, 512 unused inodes
+  Free blocks: 9346-16383
+  Free inodes: 513-1024
+debugfs: stat /emptyfile
+Inode: III   Type: regular    
+Size: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /bigfile
+Inode: III   Type: regular    
+Size: 32768
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /sparsefile
+Inode: III   Type: regular    
+Size: 1073741825
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /bigzerofile
+Inode: III   Type: regular    
+Size: 1073741825
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /fifo
+debugfs: stat /emptydir
+Inode: III   Type: directory    
+Size: 1024
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /dir
+Inode: III   Type: directory    
+Size: 1024
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: stat /dir/file
+Inode: III   Type: regular    
+Size: 8
+Fragment:  Address: 0    Number: 0    Size: 0
+debugfs: ex /emptyfile
+Level Entries       Logical      Physical Length Flags
+debugfs: ex /bigfile
+Level Entries       Logical      Physical Length Flags
+X 0/0 1/1 0-31 AAA-BBB 32 
+debugfs: ex /sparsefile
+Level Entries           Logical      Physical Length Flags
+Y 0/1 1/1 1-1048576 AAA 1048576
+X 1/1 1/5 1-1 AAA-BBB 1 
+X 1/1 2/5 512-512 AAA-BBB 1 
+X 1/1 3/5 1024-1024 AAA-BBB 1 
+X 1/1 4/5 524288-524288 AAA-BBB 1 
+X 1/1 5/5 1048576-1048576 AAA-BBB 1 
+debugfs: ex /bigzerofile
+Level Entries           Logical      Physical Length Flags
+debugfs: ex /dir
+Level Entries       Logical      Physical Length Flags
+X 0/0 1/1 0-0 AAA-BBB 1 
+debugfs: ex /dir/file
+Level Entries       Logical      Physical Length Flags
+X 0/0 1/1 0-0 AAA-BBB 1 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test.img: 19/1024 files (0.0% non-contiguous), 1598/16384 blocks
diff --git a/tests/m_rootdir/output.sed b/tests/m_rootdir/output.sed
new file mode 100644
index 0000000..2e76967
--- /dev/null
+++ b/tests/m_rootdir/output.sed
@@ -0,0 +1,5 @@
+s/^[[:space:]]*\([0-9]*\)\/[[:space:]]*\([0-9]*\)[[:space:]]*\([0-9]*\)\/[[:space:]]*\([0-9]*\)[[:space:]]*\([0-9]*\)[[:space:]]*-[[:space:]]*\([0-9]*\)[[:space:]]*[0-9]*[[:space:]]*-[[:space:]]*[0-9]*[[:space:]]*\([0-9]*\)/X \1\/\2 \3\/\4 \5-\6 AAA-BBB \7/g
+s/^[[:space:]]*\([0-9]*\)\/[[:space:]]*\([0-9]*\)[[:space:]]*\([0-9]*\)\/[[:space:]]*\([0-9]*\)[[:space:]]*\([0-9]*\)[[:space:]]*-[[:space:]]*\([0-9]*\)[[:space:]]*[0-9]*[[:space:]]*\([0-9]*\)/Y \1\/\2 \3\/\4 \5-\6 AAA \7/g
+s/Mode:.*$//g
+s/User:.*Size:/Size:/g
+s/^Inode: [0-9]*/Inode: III/g
diff --git a/tests/m_rootdir/script b/tests/m_rootdir/script
new file mode 100644
index 0000000..fbe1b31
--- /dev/null
+++ b/tests/m_rootdir/script
@@ -0,0 +1,71 @@
+if test -x $DEBUGFS_EXE; then
+
+test_description="create fs image from dir"
+MKFS_DIR=$TMPFILE.dir
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+rm -rf $MKFS_DIR
+mkdir -p $MKFS_DIR
+touch $MKFS_DIR/emptyfile
+dd if=/dev/zero bs=1024 count=32 2> /dev/null | tr '\0' 'a' > $MKFS_DIR/bigfile
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=1024 2> /dev/null
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=524288 conv=notrunc 2> /dev/null
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=1048576 conv=notrunc 2> /dev/null
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=536870912 conv=notrunc 2> /dev/null
+echo "M" | dd of=$MKFS_DIR/sparsefile bs=1 count=1 seek=1073741824 conv=notrunc 2> /dev/null
+dd if=/dev/zero of=$MKFS_DIR/bigzerofile bs=1 count=1 seek=1073741824 2> /dev/null
+ln $MKFS_DIR/bigzerofile $MKFS_DIR/bigzerofile_hardlink
+ln -s /silly_bs_link $MKFS_DIR/silly_bs_link
+mkdir $MKFS_DIR/emptydir
+mkdir $MKFS_DIR/dir
+echo "Test me" > $MKFS_DIR/dir/file
+
+$MKE2FS -q -F -o Linux -T ext4 -O metadata_csum,64bit -E lazy_itable_init=1 -b 1024 -d $MKFS_DIR $TMPFILE 16384 > $OUT 2>&1
+
+$DUMPE2FS $TMPFILE >> $OUT 2>&1
+cat > $TMPFILE.cmd << ENDL
+stat /emptyfile
+stat /bigfile
+stat /sparsefile
+stat /bigzerofile
+stat /fifo
+stat /emptydir
+stat /dir
+stat /dir/file
+ENDL
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE 2>&1 | egrep "(stat|Size:|Type:)" | sed -f $test_dir/output.sed >> $OUT
+
+cat > $TMPFILE.cmd << ENDL
+ex /emptyfile
+ex /bigfile
+ex /sparsefile
+ex /bigzerofile
+ex /dir
+ex /dir/file
+ENDL
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $test_dir/output.sed >> $OUT 2>&1
+
+$FSCK -f -n $TMPFILE >> $OUT 2>&1
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" < $OUT > $OUT.tmp
+mv $OUT.tmp $OUT
+
+# Do the verification
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+        echo "$test_name: $test_description: failed"
+        diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+rm -rf $TMPFILE.cmd $MKFS_DIR $OUT.sed
+unset MKFS_DIR OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

