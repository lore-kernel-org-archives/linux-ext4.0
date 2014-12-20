From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 23/31] tests: test various features of the new e2undo format
Date: Sat, 20 Dec 2014 13:19:23 -0800
Message-ID: <20141220211923.25563.52784.stgit@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45362 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaLTVT2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2014 16:19:28 -0500
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify that the header, checksum, and wrong-order rollback detection
features of the new e2undo actually work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/u_compound_bad_rollback/script  |   62 +++++++++++++++++++++++++++++++++
 tests/u_corrupt_blk_csum/script       |   38 ++++++++++++++++++++
 tests/u_corrupt_blk_csum_force/script |   38 ++++++++++++++++++++
 tests/u_corrupt_hdr_csum/script       |   37 ++++++++++++++++++++
 tests/u_corrupt_key_csum/script       |   37 ++++++++++++++++++++
 tests/u_dryrun/script                 |   32 +++++++++++++++++
 tests/u_force/script                  |   38 ++++++++++++++++++++
 tests/u_force_dryrun/script           |   38 ++++++++++++++++++++
 tests/u_not_undo/script               |   28 +++++++++++++++
 tests/u_wrong_fs/script               |   36 +++++++++++++++++++
 10 files changed, 384 insertions(+)
 create mode 100644 tests/u_compound_bad_rollback/script
 create mode 100644 tests/u_corrupt_blk_csum/script
 create mode 100644 tests/u_corrupt_blk_csum_force/script
 create mode 100644 tests/u_corrupt_hdr_csum/script
 create mode 100644 tests/u_corrupt_key_csum/script
 create mode 100644 tests/u_dryrun/script
 create mode 100644 tests/u_force/script
 create mode 100644 tests/u_force_dryrun/script
 create mode 100644 tests/u_not_undo/script
 create mode 100644 tests/u_wrong_fs/script


diff --git a/tests/u_compound_bad_rollback/script b/tests/u_compound_bad_rollback/script
new file mode 100644
index 0000000..adb6e4a
--- /dev/null
+++ b/tests/u_compound_bad_rollback/script
@@ -0,0 +1,62 @@
+test_description="e2undo with mke2fs/tune2fs/resize2fs/e2fsck -z"
+if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+
+TDB_FILE=/tmp/resize2fs-$(basename $TMPFILE).e2undo
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
index 0000000..40146fc
--- /dev/null
+++ b/tests/u_corrupt_blk_csum/script
@@ -0,0 +1,38 @@
+test_description="corrupt e2undo block data"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=/tmp
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
+undo_blks=$(( $(stat -c '%s' $TDB_FILE) / 1024 ))
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
index 0000000..f0b28d5
--- /dev/null
+++ b/tests/u_corrupt_blk_csum_force/script
@@ -0,0 +1,38 @@
+test_description="force replay of corrupt e2undo block data"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=/tmp
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
+undo_blks=$(( $(stat -c '%s' $TDB_FILE) / 1024 ))
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
index 0000000..41c0cbe
--- /dev/null
+++ b/tests/u_corrupt_hdr_csum/script
@@ -0,0 +1,37 @@
+test_description="corrupt e2undo header"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=/tmp
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
index 0000000..0664e17
--- /dev/null
+++ b/tests/u_corrupt_key_csum/script
@@ -0,0 +1,37 @@
+test_description="corrupt e2undo key data"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=/tmp
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
+undo_blks=$(( $(stat -c '%s' $TDB_FILE) / 1024 ))
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
index 0000000..d6de362
--- /dev/null
+++ b/tests/u_dryrun/script
@@ -0,0 +1,32 @@
+test_description="e2undo dry run"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=/tmp/tune2fs-$(basename $TMPFILE).e2undo
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
diff --git a/tests/u_force/script b/tests/u_force/script
new file mode 100644
index 0000000..7402294
--- /dev/null
+++ b/tests/u_force/script
@@ -0,0 +1,38 @@
+test_description="e2undo force"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=/tmp/tune2fs-$(basename $TMPFILE).e2undo
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
+if [ $crc0 = $crc3 ] && [ $crc1 = $crc2 ] && [ $crc2 != $crc0 ]; then
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
index 0000000..9fd847e
--- /dev/null
+++ b/tests/u_force_dryrun/script
@@ -0,0 +1,38 @@
+test_description="force dry-run replay of corrupt e2undo block data"
+if test -x $E2UNDO_EXE; then
+
+E2FSPROGS_UNDO_DIR=/tmp
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
+undo_blks=$(( $(stat -c '%s' $TDB_FILE) / 1024 ))
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
diff --git a/tests/u_not_undo/script b/tests/u_not_undo/script
new file mode 100644
index 0000000..2331c55
--- /dev/null
+++ b/tests/u_not_undo/script
@@ -0,0 +1,28 @@
+test_description="e2undo a non-undo file"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=/tmp/tune2fs-$(basename $TMPFILE).e2undo
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
diff --git a/tests/u_wrong_fs/script b/tests/u_wrong_fs/script
new file mode 100644
index 0000000..6a96b20
--- /dev/null
+++ b/tests/u_wrong_fs/script
@@ -0,0 +1,36 @@
+test_description="e2undo on the wrong fs"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=/tmp/tune2fs-$(basename $TMPFILE).e2undo
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

