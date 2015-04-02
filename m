From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/35] tests: test undo file creation in
 e2fsck/resize2fs/tune2fs/mke2fs
Date: Wed, 01 Apr 2015 19:36:17 -0700
Message-ID: <20150402023617.25243.96247.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35829 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbbDBCgV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:36:21 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Regression tests to ensure that we can create undo files and roll
things back if need be.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/test_config                           |    1 
 tests/u_compound_rollback/script            |   62 ++++++++++++
 tests/u_debugfs_opt/script                  |   32 ++++++
 tests/u_e2fsck_opt/script                   |   32 ++++++
 tests/u_mke2fs/script                       |    4 -
 tests/u_mke2fs_opt/script                   |   32 ++++++
 tests/u_mke2fs_opt_oddsize/script           |   31 ++++++
 tests/u_resize2fs_opt/script                |   32 ++++++
 tests/u_revert_upgrade_to_64bitmcsum/script |  136 +++++++++++++++++++++++++++
 tests/u_tune2fs/script                      |    4 -
 tests/u_tune2fs_opt/script                  |   32 ++++++
 11 files changed, 394 insertions(+), 4 deletions(-)
 create mode 100644 tests/u_compound_rollback/script
 create mode 100644 tests/u_debugfs_opt/script
 create mode 100644 tests/u_e2fsck_opt/script
 create mode 100644 tests/u_mke2fs_opt/script
 create mode 100644 tests/u_mke2fs_opt_oddsize/script
 create mode 100644 tests/u_resize2fs_opt/script
 create mode 100644 tests/u_revert_upgrade_to_64bitmcsum/script
 create mode 100644 tests/u_tune2fs_opt/script


diff --git a/tests/test_config b/tests/test_config
index 2e3af6b..7f39157 100644
--- a/tests/test_config
+++ b/tests/test_config
@@ -17,6 +17,7 @@ TEST_BITS="../debugfs/debugfs"
 RESIZE2FS_EXE="../resize/resize2fs"
 RESIZE2FS="$USE_VALGRIND $RESIZE2FS_EXE"
 E2UNDO_EXE="../misc/e2undo"
+E2UNDO="$USE_VALGRIND $E2UNDO_EXE"
 TEST_REL=../tests/progs/test_rel
 TEST_ICOUNT=../tests/progs/test_icount
 CRCSUM=../tests/progs/crcsum
diff --git a/tests/u_compound_rollback/script b/tests/u_compound_rollback/script
new file mode 100644
index 0000000..0c1fbcc
--- /dev/null
+++ b/tests/u_compound_rollback/script
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
+echo roll back e2fsck >> $OUT
+$E2UNDO $TDB_FILE.3 $TMPFILE  >> $OUT 2>&1
+crc3_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo e2fsck $crc3_2 >> $OUT
+
+echo roll back resize2fs >> $OUT
+$E2UNDO $TDB_FILE.2 $TMPFILE  >> $OUT 2>&1
+crc2_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo resize2fs $crc2_2 >> $OUT
+
+echo roll back tune2fs >> $OUT
+$E2UNDO $TDB_FILE.1 $TMPFILE  >> $OUT 2>&1
+crc1_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo tune2fs $crc1_2 >> $OUT
+
+echo roll back mke2fs >> $OUT
+$E2UNDO $TDB_FILE.0 $TMPFILE  >> $OUT 2>&1
+crc0_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo mke2fs $crc0_2 >> $OUT
+
+if [ $crc0 = $crc0_2 ] && [ $crc1 = $crc1_2 ] && [ $crc2 = $crc2_2 ] && [ $crc3 = $crc3_2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE.0 $TDB_FILE.1 $TDB_FILE.2 $TDB_FILE.3 $TMPFILE
+fi
diff --git a/tests/u_debugfs_opt/script b/tests/u_debugfs_opt/script
new file mode 100644
index 0000000..bb93917
--- /dev/null
+++ b/tests/u_debugfs_opt/script
@@ -0,0 +1,32 @@
+test_description="e2undo with debugfs -z"
+if test -x $E2UNDO_EXE -a -x $DEBUGFS_EXE; then
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
+echo $CRCSUM before debugfs $crc0 >> $OUT
+
+echo using debugfs to test e2undo >> $OUT
+$DEBUGFS -w -z $TDB_FILE -R 'zap -p 0x55 0' $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after debugfs $crc1 >> $OUT
+
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc0 = $crc2 ] && [ $crc1 != $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_e2fsck_opt/script b/tests/u_e2fsck_opt/script
new file mode 100644
index 0000000..d61cd2b
--- /dev/null
+++ b/tests/u_e2fsck_opt/script
@@ -0,0 +1,32 @@
+test_description="e2undo with e2fsck -z"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/e2fsck-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  > $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before e2fsck $crc0 >> $OUT
+
+echo using e2fsck to test e2undo >> $OUT
+$FSCK -f -y -z $TDB_FILE $TMPFILE >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2fsck $crc1 >> $OUT
+
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc0 = $crc2 ] && [ $crc1 != $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_mke2fs/script b/tests/u_mke2fs/script
index d249ddd..f1041a9 100644
--- a/tests/u_mke2fs/script
+++ b/tests/u_mke2fs/script
@@ -1,7 +1,7 @@
 test_description="e2undo with mke2fs"
 if test -x $E2UNDO_EXE; then
 
-E2FSPROGS_UNDO_DIR=/tmp
+E2FSPROGS_UNDO_DIR=${TMPDIR:-/tmp}
 export E2FSPROGS_UNDO_DIR
 TDB_FILE=$E2FSPROGS_UNDO_DIR/mke2fs-$(basename $TMPFILE).e2undo
 OUT=$test_name.log
@@ -19,7 +19,7 @@ $MKE2FS -q -F -o Linux -I 256 -O uninit_bg -E lazy_itable_init=1 -b 1024 $TMPFIL
 new_crc=`$CRCSUM $TMPFILE`
 echo $CRCSUM after mke2fs $new_crc >> $OUT
 
-$E2UNDO_EXE  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
 new_crc=`$CRCSUM $TMPFILE`
 echo $CRCSUM after e2undo $new_crc >> $OUT
 
diff --git a/tests/u_mke2fs_opt/script b/tests/u_mke2fs_opt/script
new file mode 100644
index 0000000..db62ab2
--- /dev/null
+++ b/tests/u_mke2fs_opt/script
@@ -0,0 +1,32 @@
+test_description="e2undo with mke2fs -z"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/mke2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -F -o Linux -I 128 -b 1024 test.img  > $OUT
+$MKE2FS -F -o Linux -I 128 -b 1024 $TMPFILE  >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before mke2fs $crc0 >> $OUT
+
+echo using mke2fs to test e2undo >> $OUT
+$MKE2FS -q -F -o Linux -T ext4 -E lazy_itable_init=1 -b 1024 -z $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after mke2fs $crc1 >> $OUT
+
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc0 = $crc2 ] && [ $crc1 != $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_mke2fs_opt_oddsize/script b/tests/u_mke2fs_opt_oddsize/script
new file mode 100644
index 0000000..23e0b9e
--- /dev/null
+++ b/tests/u_mke2fs_opt_oddsize/script
@@ -0,0 +1,31 @@
+test_description="e2undo with mke2fs -z and non-32k-aligned bdev size"
+if test -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/mke2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+yes "abc123abc123abc" | dd bs=1k count=8 >> $TMPFILE 2> /dev/null
+
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before mke2fs $crc0 > $OUT
+
+echo using mke2fs to test e2undo >> $OUT
+$MKE2FS -q -F -o Linux -T ext4 -E lazy_itable_init=1 -b 1024 -z $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after mke2fs $crc1 >> $OUT
+
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc0 = $crc2 ] && [ $crc1 != $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_resize2fs_opt/script b/tests/u_resize2fs_opt/script
new file mode 100644
index 0000000..fe1e04d
--- /dev/null
+++ b/tests/u_resize2fs_opt/script
@@ -0,0 +1,32 @@
+test_description="e2undo with resize2fs -z"
+if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE 256 > $OUT
+$MKE2FS -q -F -o Linux -T ext4 -O ^metadata_csum,64bit -E lazy_itable_init=1 -b 1024 $TMPFILE 256 >> $OUT 2>&1
+crc0=`$CRCSUM $TMPFILE`
+echo $CRCSUM before resize2fs $crc0 >> $OUT
+
+echo using resize2fs to test e2undo >> $OUT
+$RESIZE2FS -z $TDB_FILE $TMPFILE 512 >> $OUT 2>&1
+crc1=`$CRCSUM $TMPFILE`
+echo $CRCSUM after resize2fs $crc1 >> $OUT
+
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc0 = $crc2 ] && [ $crc1 != $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi
diff --git a/tests/u_revert_upgrade_to_64bitmcsum/script b/tests/u_revert_upgrade_to_64bitmcsum/script
new file mode 100644
index 0000000..6120d00
--- /dev/null
+++ b/tests/u_revert_upgrade_to_64bitmcsum/script
@@ -0,0 +1,136 @@
+test_description="convert fs to 64bit,metadata_csum and revert both changes"
+if test -x $RESIZE2FS_EXE -a -x $E2UNDO_EXE; then
+
+TDB_FILE=${TMPDIR:-/tmp}/resize2fs-$(basename $TMPFILE).e2undo
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+fail=0
+
+echo convert fs to 64bit,metadata_csum and revert both changes > $OUT
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
+$TUNE2FS -O metadata_csum -z $TDB_FILE.2 $TMPFILE >> $OUT 2>&1
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
+$FSCK -f -y -D -z $TDB_FILE.3 $TMPFILE >> $OUT 2>&1
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
+echo roll back e2fsck >> $OUT
+$E2UNDO $TDB_FILE.3 $TMPFILE  >> $OUT 2>&1
+crc3_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo e2fsck $crc3_2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -lt 1 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit and metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo roll back tune2fs >> $OUT
+$E2UNDO $TDB_FILE.2 $TMPFILE  >> $OUT 2>&1
+crc2_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo tune2fs $crc2_2 >> $OUT
+features="$($DUMPE2FS -h $TMPFILE 2> /dev/null | grep 'Filesystem features:')"
+if [ "$(echo "${features}" | grep "metadata_csum" -c)" -gt 0 ] || [ "$(echo "${features}" | grep 64bit -c)" -lt 1 ]; then
+	echo "FS features: ${features}" >> $OUT
+	echo "Should have 64bit but not metadata_csum set" >> $OUT
+	fail=1
+fi
+$FSCK -f -n $TMPFILE >> $OUT 2>&1 || fail=1
+
+echo roll back resize2fs >> $OUT
+$E2UNDO $TDB_FILE.1 $TMPFILE  >> $OUT 2>&1
+crc1_2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo resize2fs $crc1_2 >> $OUT
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
+if [ $fail -eq 0 ] && [ $crc0 = $crc0_2 ] && [ $crc1 = $crc1_2 ] && [ $crc2 = $crc2_2 ] && [ $crc3 = $crc3_2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE.0 $TDB_FILE.1 $TDB_FILE.2 $TDB_FILE.3 $TMPFILE $CONF
+fi
diff --git a/tests/u_tune2fs/script b/tests/u_tune2fs/script
index a443f5a..aa5f379 100644
--- a/tests/u_tune2fs/script
+++ b/tests/u_tune2fs/script
@@ -1,7 +1,7 @@
 test_description="e2undo with tune2fs"
 if test -x $E2UNDO_EXE; then
 
-E2FSPROGS_UNDO_DIR=/tmp
+E2FSPROGS_UNDO_DIR=${TMPDIR:-/tmp}
 export E2FSPROGS_UNDO_DIR
 TDB_FILE=$E2FSPROGS_UNDO_DIR/tune2fs-$(basename $TMPFILE).e2undo
 OUT=$test_name.log
@@ -19,7 +19,7 @@ $TUNE2FS -I 256 $TMPFILE  >> $OUT 2>&1
 new_crc=`$CRCSUM $TMPFILE`
 echo $CRCSUM after tune2fs $new_crc >> $OUT
 
-$E2UNDO_EXE  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
 new_crc=`$CRCSUM $TMPFILE`
 echo $CRCSUM after e2undo $new_crc >> $OUT
 
diff --git a/tests/u_tune2fs_opt/script b/tests/u_tune2fs_opt/script
new file mode 100644
index 0000000..c4810b9
--- /dev/null
+++ b/tests/u_tune2fs_opt/script
@@ -0,0 +1,32 @@
+test_description="e2undo with tune2fs -z"
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
+$E2UNDO  $TDB_FILE $TMPFILE  >> $OUT 2>&1
+crc2=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $crc2 >> $OUT
+
+if [ $crc0 = $crc2 ] && [ $crc1 != $crc2 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	ln -f $test_name.log $test_name.failed
+	echo "$test_name: $test_description: failed"
+fi
+rm -f $TDB_FILE $TMPFILE
+fi

