From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/54] tune2fs: disable csum verification before resizing
 inode
Date: Mon, 26 Jan 2015 23:36:31 -0800
Message-ID: <20150127073631.13308.86550.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33309 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbA0Hgf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:36:35 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're turning on metadata checksumming /and/ resizing the inode
at the same time, disable checksum verification during the
resize_inode() call because the subroutines it calls will try to
verify the checksums (which have not yet been set), causing the
operation to fail unnecessarily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c               |    7 +++-
 tests/t_iexpand_full/script  |    2 +
 tests/t_iexpand_mcsum/expect |   54 ++++++++++++++++++++++++++++
 tests/t_iexpand_mcsum/name   |    1 +
 tests/t_iexpand_mcsum/script |   80 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 142 insertions(+), 2 deletions(-)
 create mode 100644 tests/t_iexpand_mcsum/expect
 create mode 100644 tests/t_iexpand_mcsum/name
 create mode 100644 tests/t_iexpand_mcsum/script


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index b510c49..f01b05b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2961,8 +2961,13 @@ retry_open:
 		 * We want to update group descriptor also
 		 * with the new free inode count
 		 */
+		if (rewrite_checksums)
+			fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
-		if (resize_inode(fs, new_inode_size) == 0) {
+		retval = resize_inode(fs, new_inode_size);
+		if (rewrite_checksums)
+			fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+		if (retval == 0) {
 			printf(_("Setting inode size %lu\n"),
 							new_inode_size);
 			rewrite_checksums = 1;
diff --git a/tests/t_iexpand_full/script b/tests/t_iexpand_full/script
index 9e34090..779c66d 100644
--- a/tests/t_iexpand_full/script
+++ b/tests/t_iexpand_full/script
@@ -44,7 +44,7 @@ echo Exit status is $status >> $OUT
 # dump and check
 ($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2>&1 | sed -f $cmd_dir/filter.sed -e '/^Checksum:.*/d' >> $OUT.after 2> /dev/null
 echo "Change in FS metadata:" >> $OUT
-diff -u0 $OUT.before $OUT.after | sed -e '/^---.*/d' -e '/^+++.*/d' >> $OUT
+diff -U 0 $OUT.before $OUT.after | sed -e '/^---.*/d' -e '/^+++.*/d' >> $OUT
 $FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
 status=$?
 echo Exit status is $status >> $OUT
diff --git a/tests/t_iexpand_mcsum/expect b/tests/t_iexpand_mcsum/expect
new file mode 100644
index 0000000..2a6d705
--- /dev/null
+++ b/tests/t_iexpand_mcsum/expect
@@ -0,0 +1,54 @@
+tune2fs test
+Creating filesystem with 786432 1k blocks and 98304 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 6334 huge file(s) with 117 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -I 256 -O metadata_csum test.img
+Setting inode size 256
+
+Please run e2fsck -D on the filesystem.
+
+Exit status is 0
+Backing up journal inode block information.
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+
+
+Change in FS metadata:
+@@ -5 +5 @@
+-Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
++Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
+@@ -21 +21 @@
+-Inode blocks per group:   128
++Inode blocks per group:   256
+@@ -27 +27 @@
+-Inode size:	          128
++Inode size:	          256
+@@ -30,0 +31 @@
++Checksum type:            crc32c
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_iexpand_mcsum/name b/tests/t_iexpand_mcsum/name
new file mode 100644
index 0000000..e767715
--- /dev/null
+++ b/tests/t_iexpand_mcsum/name
@@ -0,0 +1 @@
+expand inodes and turn on metadata_csum
diff --git a/tests/t_iexpand_mcsum/script b/tests/t_iexpand_mcsum/script
new file mode 100644
index 0000000..3057dba
--- /dev/null
+++ b/tests/t_iexpand_mcsum/script
@@ -0,0 +1,80 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+#gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,^resize_inode,^meta_bg,^flex_bg,^metadata_csum,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 16000K
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 117K
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h -I 128 $TMPFILE 786432 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+($DUMPE2FS -h $TMPFILE | grep -v '^Free blocks:'; $DUMPE2FS -g $TMPFILE) 2>&1 | sed -f $cmd_dir/filter.sed -e '/^Checksum:.*/d' >> $OUT.before 2> /dev/null
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# convert it
+echo "tune2fs -I 256 -O metadata_csum test.img" >> $OUT
+dd if=/dev/zero of=$TMPFILE conv=notrunc bs=1 count=1 seek=3221225471 2> /dev/null
+$TUNE2FS -I 256 -O metadata_csum $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+$FSCK -N test_filesys -y -f -D $TMPFILE >> $OUT 2>&1
+
+# dump and check
+($DUMPE2FS -h $TMPFILE | grep -v '^Free blocks:'; $DUMPE2FS -g $TMPFILE) 2>&1 | sed -f $cmd_dir/filter.sed -e '/^Checksum:.*/d' >> $OUT.after 2> /dev/null
+echo "Change in FS metadata:" >> $OUT
+diff -U 0 $OUT.before $OUT.after | sed -e '/^---.*/d' -e '/^+++.*/d' >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+rm $OUT.before $OUT.after
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+

