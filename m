From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 41/54] tests: test various features of the new e2undo format
Date: Mon, 26 Jan 2015 23:40:02 -0800
Message-ID: <20150127074002.13308.58427.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47422 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275AbbA0HkJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:40:09 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify that the header, checksum, and wrong-order rollback detection
features of the new e2undo actually work.

v2: Collect more tests for the v2 of the e2undo flat file patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2fuzz.sh                           |    0 
 tests/u_compound_bad_rollback/script     |   62 ++++++++++++++++
 tests/u_corrupt_blk_csum/script          |   38 ++++++++++
 tests/u_corrupt_blk_csum_force/script    |   38 ++++++++++
 tests/u_corrupt_hdr_csum/script          |   37 ++++++++++
 tests/u_corrupt_key_csum/script          |   37 ++++++++++
 tests/u_dryrun/script                    |   32 ++++++++
 tests/u_errorout/script                  |   49 +++++++++++++
 tests/u_force/script                     |   40 ++++++++++
 tests/u_force_dryrun/script              |   38 ++++++++++
 tests/u_incomplete/script                |   38 ++++++++++
 tests/u_not_undo/script                  |   28 +++++++
 tests/u_onefile_bad/script               |  115 ++++++++++++++++++++++++++++++
 tests/u_revert_64bitmcsum_onefile/script |  112 +++++++++++++++++++++++++++++
 tests/u_revert_all_onefile/script        |  100 ++++++++++++++++++++++++++
 tests/u_undo_undo/script                 |   54 ++++++++++++++
 tests/u_wrong_fs/script                  |   36 +++++++++
 17 files changed, 854 insertions(+)
 mode change 100755 => 100644 misc/e2fuzz.sh
 create mode 100644 tests/u_compound_bad_rollback/script
 create mode 100644 tests/u_corrupt_blk_csum/script
 create mode 100644 tests/u_corrupt_blk_csum_force/script
 create mode 100644 tests/u_corrupt_hdr_csum/script
 create mode 100644 tests/u_corrupt_key_csum/script
 create mode 100644 tests/u_dryrun/script
 create mode 100644 tests/u_errorout/script
 create mode 100644 tests/u_force/script
 create mode 100644 tests/u_force_dryrun/script
 create mode 100644 tests/u_incomplete/script
 create mode 100644 tests/u_not_undo/script
 create mode 100644 tests/u_onefile_bad/script
 create mode 100644 tests/u_revert_64bitmcsum_onefile/script
 create mode 100644 tests/u_revert_all_onefile/script
 create mode 100644 tests/u_undo_undo/script
 create mode 100644 tests/u_wrong_fs/script


diff --git a/misc/e2fuzz.sh b/misc/e2fuzz.sh
old mode 100755
new mode 100644
diff --git a/tests/u_compound_bad_rollback/script b/tests/u_compound_bad_rollback/script
new file mode 100644
index 0000000..f54da7f
--- /dev/null
+++ b/tests/u_compound_bad_rollback/script
@@ -0,0 +1,62 @@
+test_description="e2undo with mke2fs/tune2fs/resize2fs/e2fsck -z"
+if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+echo compound e2undo rollback test > $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before mke2fs $crc0 >> $OUT
+
+echo mke2fs -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 -z $TDB_FILE.0 $TMPFILE 256 >> $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 -z $TDB_FILE.0 $TMPFILE 256 >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after mke2fs $crc1 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -O metadata_csum -z $TDB_FILE.1 $TMPFILE >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc2 >> $OUT
+
+echo using resize2fs to test e2undo >> $OUT
+$RESIZE2FS -z $TDB_FILE.2 $TMPFILE 512 >> $OUT 2>&1
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after resize2fs $crc3 >> $OUT
+
+echo using e2fsck to test e2undo >> $OUT
+$FSCK -f -y -D -z $TDB_FILE.3 $TMPFILE >> $OUT 2>&1
+crc4=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2fsck $crc4 >> $OUT
+
+echo roll back mke2fs >> $OUT
+$E2UNDO $TDB_FILE.0 $TMPFILE  >> $OUT 2>&1
+crc0_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo mke2fs $crc0_2 >> $OUT
+
+echo roll back tune2fs >> $OUT
+$E2UNDO $TDB_FILE.1 $TMPFILE  >> $OUT 2>&1
+crc1_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo tune2fs $crc1_2 >> $OUT
+
+echo roll back resize2fs >> $OUT
+$E2UNDO $TDB_FILE.2 $TMPFILE  >> $OUT 2>&1
+crc2_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo resize2fs $crc2_2 >> $OUT
+
+echo roll back e2fsck >> $OUT
+$E2UNDO $TDB_FILE.3 $TMPFILE  >> $OUT 2>&1
+crc3_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo e2fsck $crc3_2 >> $OUT
+
+if [ $crc4 = $crc0_2 ] && [ $crc4 = $crc1_2 ] && [ $crc4 = $crc2_2 ] && [ $crc3 = $crc3_2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE.0 $TDB_FILE.1 $TDB_FILE.2 $TDB_FILE.3 $TMPFILE
+fi
diff --git a/tests/u_corrupt_blk_csum/script b/tests/u_corrupt_blk_csum/script
new file mode 100644
index 0000000..ee16552
--- /dev/null
+++ b/tests/u_corrupt_blk_csum/script
@@ -0,0 +1,38 @@
+test_description="corrupt e2undo block data"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=${TMPDIR:-/tmp}
+export E2FSPROGS_UNDO_DIR
+TDB_FILE=$E2FSPROGS_UNDO_DIR/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -I 128 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc0 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -I 256 $TMPFILE  >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc1 >> $OUT
+
+undo_blks=$(( $(stat -c '%s' $TDB_FILE 2>/dev/null || stat -f '%z' $TDB_FILE 2>/dev/null) / 1024 ))
+dd if=/dev/zero of=$TDB_FILE bs=1024 count=1 seek=$((undo_blks - 2)) conv=notrunc > /dev/null 2>&1
+
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+res=$?
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $res -ne 0 ] && [ $crc2 = $crc1 ] && [ $crc2 != $crc0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_corrupt_blk_csum_force/script b/tests/u_corrupt_blk_csum_force/script
new file mode 100644
index 0000000..ba82726
--- /dev/null
+++ b/tests/u_corrupt_blk_csum_force/script
@@ -0,0 +1,38 @@
+test_description="force replay of corrupt e2undo block data"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=${TMPDIR:-/tmp}
+export E2FSPROGS_UNDO_DIR
+TDB_FILE=$E2FSPROGS_UNDO_DIR/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -I 128 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc0 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -I 256 $TMPFILE  >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc1 >> $OUT
+
+undo_blks=$(( $(stat -c '%s' $TDB_FILE 2>/dev/null || stat -f '%z' $TDB_FILE 2>/dev/null) / 1024 ))
+dd if=/dev/zero of=$TDB_FILE bs=1024 count=1 seek=$((undo_blks - 2)) conv=notrunc > /dev/null 2>&1
+
+$E2UNDO -f $TDB_FILE $TMPFILE  >> $OUT 2>&1
+res=$?
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc2 != $crc1 ] && [ $crc2 != $crc0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_corrupt_hdr_csum/script b/tests/u_corrupt_hdr_csum/script
new file mode 100644
index 0000000..32c38c8
--- /dev/null
+++ b/tests/u_corrupt_hdr_csum/script
@@ -0,0 +1,37 @@
+test_description="corrupt e2undo header"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=${TMPDIR:-/tmp}
+export E2FSPROGS_UNDO_DIR
+TDB_FILE=$E2FSPROGS_UNDO_DIR/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -I 128 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc0 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -I 256 $TMPFILE  >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc1 >> $OUT
+
+dd if=/dev/zero of=$TDB_FILE bs=256 count=1 seek=1 conv=notrunc > /dev/null 2>&1
+
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+res=$?
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $res -ne 0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_corrupt_key_csum/script b/tests/u_corrupt_key_csum/script
new file mode 100644
index 0000000..d07556b
--- /dev/null
+++ b/tests/u_corrupt_key_csum/script
@@ -0,0 +1,37 @@
+test_description="corrupt e2undo key data"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=${TMPDIR:-/tmp}
+export E2FSPROGS_UNDO_DIR
+TDB_FILE=$E2FSPROGS_UNDO_DIR/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -I 128 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc0 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -I 256 $TMPFILE  >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc1 >> $OUT
+
+undo_blks=$(( $(stat -c '%s' $TDB_FILE 2>/dev/null || stat -f '%z' $TDB_FILE 2>/dev/null) / 1024 ))
+dd if=/dev/zero of=$TDB_FILE bs=1024 count=1 seek=$((undo_blks - 1)) conv=notrunc > /dev/null 2>&1
+
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc0 != $crc1 ] && [ $crc1 = $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_dryrun/script b/tests/u_dryrun/script
new file mode 100644
index 0000000..b90ef47
--- /dev/null
+++ b/tests/u_dryrun/script
@@ -0,0 +1,32 @@
+test_description="e2undo dry run"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc0 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -O metadata_csum -z $TDB_FILE $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc1 >> $OUT
+
+$E2UNDO -n $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc1 = $crc2 ] && [ $crc1 != $crc0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_errorout/script b/tests/u_errorout/script
new file mode 100644
index 0000000..20c53de
--- /dev/null
+++ b/tests/u_errorout/script
@@ -0,0 +1,49 @@
+test_description="e2undo a failed command"
+if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+echo check that we cant append a bad undo file > $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before mke2fs $crc0 >> $OUT
+
+CONF=$TMPFILE.conf
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = ^has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode
+		blocksize = 4096
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1K
+		zero_hugefiles = false
+	}
+ENDL
+
+echo mke2fs -q -F -o Linux -T ext4h -O ^metadata_csum,^64bit -E lazy_itable_init=1 -b 1024 -z $TDB_FILE.0 $TMPFILE 524288 >> $OUT
+MKE2FS_CONFIG=$CONF $MKE2FS -q -F -o Linux -T ext4h -O ^metadata_csum,^64bit -E lazy_itable_init=1 -b 1024 -z $TDB_FILE.0 -d /etc/ $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after mke2fs $crc1 >> $OUT
+
+echo roll back mke2fs >> $OUT
+$E2UNDO $TDB_FILE.0 $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo mke2fs $crc2 >> $OUT
+
+if [ $crc0 != $crc1 ] && [ $crc1 != $crc2 ] && [ $crc0 = $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE.0 $TMPFILE $CONF
+fi
diff --git a/tests/u_force/script b/tests/u_force/script
new file mode 100644
index 0000000..ef39e24
--- /dev/null
+++ b/tests/u_force/script
@@ -0,0 +1,40 @@
+test_description="e2undo force"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc0 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -O metadata_csum -z $TDB_FILE $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc1 >> $OUT
+
+dd if=/dev/zero of=$TDB_FILE bs=4 count=1 seek=127 conv=notrunc 2> /dev/null
+
+$E2UNDO $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+$E2UNDO -f $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo -f $crc3 >> $OUT
+
+MUST_FSCK=$($DUMPE2FS $TMPFILE 2> /dev/null | grep 'Filesystem state:.*not clean' -c )
+
+if [ $MUST_FSCK -eq 1 ] && [ $crc0 != $crc3 ] && [ $crc1 = $crc2 ] && [ $crc2 != $crc0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_force_dryrun/script b/tests/u_force_dryrun/script
new file mode 100644
index 0000000..92d7624
--- /dev/null
+++ b/tests/u_force_dryrun/script
@@ -0,0 +1,38 @@
+test_description="force dry-run replay of corrupt e2undo block data"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=${TMPDIR:-/tmp}
+export E2FSPROGS_UNDO_DIR
+TDB_FILE=$E2FSPROGS_UNDO_DIR/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -I 128 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc0 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -I 256 $TMPFILE  >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc1 >> $OUT
+
+undo_blks=$(( $(stat -c '%s' $TDB_FILE 2>/dev/null || stat -f '%z' $TDB_FILE 2>/dev/null) / 1024 ))
+dd if=/dev/zero of=$TDB_FILE bs=1024 count=1 seek=$((undo_blks - 2)) conv=notrunc > /dev/null 2>&1
+
+$E2UNDO -f -n $TDB_FILE $TMPFILE  >> $OUT 2>&1
+res=$?
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc2 = $crc1 ] && [ $crc2 != $crc0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_incomplete/script b/tests/u_incomplete/script
new file mode 100644
index 0000000..7bc7858
--- /dev/null
+++ b/tests/u_incomplete/script
@@ -0,0 +1,38 @@
+test_description="e2undo with incomplete undo file"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc0 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+UNDO_IO_SIMULATE_UNFINISHED=1 $TUNE2FS -O metadata_csum -z $TDB_FILE $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc1 >> $OUT
+
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+$FSCK -y $TMPFILE >> $OUT 2>&1
+fsck_res=$?
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after fsck $crc3 >> $OUT
+echo fsck result $fsck_res >> $OUT
+
+if [ $crc0 != $crc2 ] && [ $crc1 != $crc2 ] && [ $crc0 != $crc1 ] && [ $fsck_res -eq 1 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_not_undo/script b/tests/u_not_undo/script
new file mode 100644
index 0000000..2f07d1b
--- /dev/null
+++ b/tests/u_not_undo/script
@@ -0,0 +1,28 @@
+test_description="e2undo a non-undo file"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+dd if=/dev/zero of=$TDB_FILE bs=1k count=512 > /dev/null 2>&1
+
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before e2undo $crc0 > $OUT
+
+od -tx1 -Ad -c < $TDB_FILE >> $OUT
+
+$E2UNDO $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc3 >> $OUT
+
+if [ $crc3 = $crc0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_onefile_bad/script b/tests/u_onefile_bad/script
new file mode 100644
index 0000000..60c9a2e
--- /dev/null
+++ b/tests/u_onefile_bad/script
@@ -0,0 +1,115 @@
+test_description="check that we cant append a bad undo file"
+if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+fail=0
+
+echo check that we cant append a bad undo file > $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before mke2fs $crc0 >> $OUT
+
+CONF=$TMPFILE.conf
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode
+		blocksize = 4096
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo mke2fs -q -F -o Linux -T ext4h -O ^metadata_csum,^64bit -E lazy_itable_init=1 -b 4096 -z $TDB_FILE.0 $TMPFILE 524288 >> $OUT
+MKE2FS_CONFIG=$CONF $MKE2FS -q -F -o Linux -T ext4h -O ^metadata_csum,^64bit -E lazy_itable_init=1 -b 4096 -z $TDB_FILE.0 $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after mke2fs $crc1 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -gt 0 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should not have 64bit or metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo using resize2fs to test e2undo >> $OUT
+$RESIZE2FS -z $TDB_FILE.1 -b $TMPFILE >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after resize2fs $crc2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit but not metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo corrupt $TDB_FILE.1 >> $OUT
+dd if=/dev/zero of=$TDB_FILE.1 bs=4096 count=1 skip=1 2> /dev/null
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -O metadata_csum -z $TDB_FILE.1 $TMPFILE >> $OUT 2>&1
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc3 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit but not metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo using e2fsck to test e2undo >> $OUT
+$FSCK -f -y -D -z $TDB_FILE.1 $TMPFILE >> $OUT 2>&1
+crc4=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2fsck $crc4 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit but not metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo roll back e2fsck/tune2fs/resize2fs >> $OUT
+$E2UNDO $TDB_FILE.1 $TMPFILE  >> $OUT 2>&1
+crc1_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo e2fsck/tune2fs/resize2fs $crc1_2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit but not metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo roll back mke2fs >> $OUT
+$E2UNDO $TDB_FILE.0 $TMPFILE  >> $OUT 2>&1
+crc0_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo mke2fs $crc0_2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit but not metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+if [ $fail -eq 0 ] && [ $crc0 != $crc1 ] && [ $crc1 != $crc2 ] && [ $crc2 = $crc3 ] && [ $crc3 = $crc4 ] && [ $crc1_2 = $crc2 ] && [ $crc0_2 = $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE.0 $TDB_FILE.1 $TMPFILE $CONF
+fi
diff --git a/tests/u_revert_64bitmcsum_onefile/script b/tests/u_revert_64bitmcsum_onefile/script
new file mode 100644
index 0000000..f1d7c2b
--- /dev/null
+++ b/tests/u_revert_64bitmcsum_onefile/script
@@ -0,0 +1,112 @@
+test_description="convert fs to 64bit,metadata_csum and revert as one undo file"
+if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+fail=0
+
+echo convert fs to 64bit,metadata_csum and revert both changes as one undo file > $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before mke2fs $crc0 >> $OUT
+
+CONF=$TMPFILE.conf
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode
+		blocksize = 4096
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo mke2fs -q -F -o Linux -T ext4h -O ^metadata_csum,^64bit -E lazy_itable_init=1 -b 4096 -z $TDB_FILE.0 $TMPFILE 524288 >> $OUT
+MKE2FS_CONFIG=$CONF $MKE2FS -q -F -o Linux -T ext4h -O ^metadata_csum,^64bit -E lazy_itable_init=1 -b 4096 -z $TDB_FILE.0 $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after mke2fs $crc1 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -gt 0 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should not have 64bit or metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo using resize2fs to test e2undo >> $OUT
+$RESIZE2FS -z $TDB_FILE.1 -b $TMPFILE >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after resize2fs $crc2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit but not metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -O metadata_csum -z $TDB_FILE.1 $TMPFILE >> $OUT 2>&1
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc3 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -lt 1 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit and metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo using e2fsck to test e2undo >> $OUT
+$FSCK -f -y -D -z $TDB_FILE.1 $TMPFILE >> $OUT 2>&1
+crc4=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2fsck $crc4 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -lt 1 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit and metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo roll back e2fsck/tune2fs/resize2fs >> $OUT
+$E2UNDO $TDB_FILE.1 $TMPFILE  >> $OUT 2>&1
+crc1_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo e2fsck/tune2fs/resize2fs $crc1_2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -gt 0 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should not have 64bit or metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo roll back mke2fs >> $OUT
+$E2UNDO $TDB_FILE.0 $TMPFILE  >> $OUT 2>&1
+crc0_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo mke2fs $crc0_2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ -n "${features}" ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should not have any features set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 && fail=1
+
+if [ $fail -eq 0 ] && [ $crc0 = $crc0_2 ] && [ $crc1 = $crc1_2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE.0 $TDB_FILE.1 $TMPFILE $CONF
+fi
diff --git a/tests/u_revert_all_onefile/script b/tests/u_revert_all_onefile/script
new file mode 100644
index 0000000..27b3b23
--- /dev/null
+++ b/tests/u_revert_all_onefile/script
@@ -0,0 +1,100 @@
+test_description="convert fs to 64bit,metadata_csum and revert as one undo file"
+if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+fail=0
+
+echo convert fs to 64bit,metadata_csum and revert both changes as one undo file > $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before mke2fs $crc0 >> $OUT
+
+CONF=$TMPFILE.conf
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode
+		blocksize = 4096
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo mke2fs -q -F -o Linux -T ext4h -O ^metadata_csum,^64bit -E lazy_itable_init=1 -b 4096 -z $TDB_FILE.0 $TMPFILE 524288 >> $OUT
+MKE2FS_CONFIG=$CONF $MKE2FS -q -F -o Linux -T ext4h -O ^metadata_csum,^64bit -E lazy_itable_init=1 -b 4096 -z $TDB_FILE.0 $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after mke2fs $crc1 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -gt 0 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should not have 64bit or metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo using resize2fs to test e2undo >> $OUT
+$RESIZE2FS -z $TDB_FILE.0 -b $TMPFILE >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after resize2fs $crc2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit but not metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -O metadata_csum -z $TDB_FILE.0 $TMPFILE >> $OUT 2>&1
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc3 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -lt 1 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit and metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo using e2fsck to test e2undo >> $OUT
+$FSCK -f -y -D -z $TDB_FILE.0 $TMPFILE >> $OUT 2>&1
+crc4=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2fsck $crc4 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -lt 1 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit and metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo roll back e2fsck/tune2fs/resize2fs/mke2fs >> $OUT
+$E2UNDO $TDB_FILE.0 $TMPFILE  >> $OUT 2>&1
+crc0_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo e2fsck/tune2fs/resize2fs/mke2fs $crc1_2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ -n "${features}" ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should not have any features set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 && fail=1
+
+if [ $fail -eq 0 ] && [ $crc0 = $crc0_2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE.0 $TDB_FILE.1 $TMPFILE $CONF
+fi
diff --git a/tests/u_undo_undo/script b/tests/u_undo_undo/script
new file mode 100644
index 0000000..726a453
--- /dev/null
+++ b/tests/u_undo_undo/script
@@ -0,0 +1,54 @@
+test_description="undo e2undo"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/e2fsck-$(basename $TMPFILE).e2undo
+TDB_FILE2=${TMPDIR:-/tmp}/e2undo-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE $TDB_FILE2 >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before e2fsck $crc0 >> $OUT
+
+echo using e2fsck to test e2undo >> $OUT
+$FSCK -f -y -D -z $TDB_FILE $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2fsck $crc1 >> $OUT
+
+echo e2undo the e2fsck >> $OUT
+$E2UNDO -z $TDB_FILE2 $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+echo e2undo the e2undo >> $OUT
+$E2UNDO $TDB_FILE2 $TMPFILE  >> $OUT 2>&1
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc3 >> $OUT
+
+echo e2undo the e2undo the e2undo >> $OUT
+$E2UNDO $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc4=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc4 >> $OUT
+
+$E2UNDO -h $TDB_FILE $TMPFILE >> $OUT 2>&1
+$E2UNDO -h $TDB_FILE2 $TMPFILE >> $OUT 2>&1
+
+$E2UNDO -z $TDB_FILE2 $TDB_FILE2 $TMPFILE >> $OUT 2>&1
+
+crc5=`$CRCSUM $TMPFILE`
+echo $CRCSUM after failed e2undo $crc5 >> $OUT
+
+echo $crc0 $crc1 $crc2 $crc3 $crc4 $crc5 >> $OUT
+
+if [ $crc0 = $crc2 ] && [ $crc2 = $crc4 ] && [ $crc5 = $crc4 ] && [ $crc1 = $crc3 ] && [ $crc1 != $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TDB_FILE2 $TMPFILE
+fi
diff --git a/tests/u_wrong_fs/script b/tests/u_wrong_fs/script
new file mode 100644
index 0000000..dbf0d6b
--- /dev/null
+++ b/tests/u_wrong_fs/script
@@ -0,0 +1,36 @@
+test_description="e2undo on the wrong fs"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/tune2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc0 >> $OUT
+
+echo using tune2fs to test e2undo >> $OUT
+$TUNE2FS -O metadata_csum -z $TDB_FILE $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $crc1 >> $OUT
+
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after re-mke2fs $crc2 >> $OUT
+
+$E2UNDO $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc3=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc3 >> $OUT
+
+if [ $crc3 = $crc2 ] && [ $crc2 != $crc1 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi

