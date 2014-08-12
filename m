From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] tests: convert use of md5sum to crcsum
Date: Tue, 12 Aug 2014 14:44:44 -0400
Message-ID: <1407869084-6791-1-git-send-email-tytso@mit.edu>
References: <20140812183949.GH12871@thunk.org>
Cc: darrick.wong@oracle.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56782 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbaHLSou (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2014 14:44:50 -0400
In-Reply-To: <20140812183949.GH12871@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following tests were using md5sum: i_e2image, u_mke2fs, and
u_tune2fs.  Convert them to use crcsum for better portability (not all
environments have md5sum; some might have sha1sum instead :-)

For our purposes crcsum is quite sufficient.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/i_e2image/i_e2image.crc | 15 +++++++++++++++
 tests/i_e2image/i_e2image.md5 | 15 ---------------
 tests/i_e2image/script        | 24 ++++++++++++------------
 tests/u_mke2fs/script         | 14 +++++++-------
 tests/u_tune2fs/script        | 14 +++++++-------
 5 files changed, 41 insertions(+), 41 deletions(-)
 create mode 100644 tests/i_e2image/i_e2image.crc
 delete mode 100644 tests/i_e2image/i_e2image.md5

diff --git a/tests/i_e2image/i_e2image.crc b/tests/i_e2image/i_e2image.crc
new file mode 100644
index 0000000..02a8464
--- /dev/null
+++ b/tests/i_e2image/i_e2image.crc
@@ -0,0 +1,15 @@
+i_e2image/image1024.orig
+2161078647	image1024.orig
+467277198	_image.raw
+2164212449	_image.qcow2
+467277198	_image.qcow2.raw
+i_e2image/image2048.orig
+672740642	image2048.orig
+3688408350	_image.raw
+3821412753	_image.qcow2
+3688408350	_image.qcow2.raw
+i_e2image/image4096.orig
+4077552412	image4096.orig
+4159471388	_image.raw
+636354894	_image.qcow2
+4159471388	_image.qcow2.raw
diff --git a/tests/i_e2image/i_e2image.md5 b/tests/i_e2image/i_e2image.md5
deleted file mode 100644
index f96e721..0000000
--- a/tests/i_e2image/i_e2image.md5
+++ /dev/null
@@ -1,15 +0,0 @@
-i_e2image/image1024.orig
-d34914e0da07bdae80ab02288118fae2  image1024.orig
-bbef4e50d7237546c7d9c521d3df5b68  _image.raw
-1d4eb39452bed097dcd2c5bcd57180e6  _image.qcow2
-bbef4e50d7237546c7d9c521d3df5b68  _image.qcow2.raw
-i_e2image/image2048.orig
-aa9f702de181188f2a6d2c5158686c09  image2048.orig
-e6f8410d0690ef551bee0c2c0c642d8c  _image.raw
-dbbd9aa97c6c946b9122586bbd2a325a  _image.qcow2
-e6f8410d0690ef551bee0c2c0c642d8c  _image.qcow2.raw
-i_e2image/image4096.orig
-1d3e7f15b2ce9ca07aa23c32951c5176  image4096.orig
-734119dd8f240a33704139f8cdd8127c  _image.raw
-85fdbf5a8451b24b36ab82a02196deb9  _image.qcow2
-734119dd8f240a33704139f8cdd8127c  _image.qcow2.raw
diff --git a/tests/i_e2image/script b/tests/i_e2image/script
index adf59a4..c5b0666 100644
--- a/tests/i_e2image/script
+++ b/tests/i_e2image/script
@@ -7,42 +7,42 @@ RAW_IMG=_image.raw
 QCOW2_IMG=_image.qcow2
 QCOW2_TO_RAW=_image.qcow2.raw
 OUT=$test_name.log
-MD5=$SRCDIR/$test_name/$test_name.md5
-MD5_TMP=$test_name.md5.tmp
+CRC=$SRCDIR/$test_name/$test_name.crc
+CRC_TMP=$test_name.crc.tmp
 
-rm -f $test_name/_image.* $MD5_TMP $OUT >/dev/null 2>&1
+rm -f $test_name/_image.* $CRC_TMP $OUT >/dev/null 2>&1
 
 (
 for i in $ORIG_IMAGES; do
 	ORIG_IMG=$test_name/$i
-	echo $ORIG_IMG >> $MD5_TMP
+	echo $ORIG_IMG >> $CRC_TMP
 
 	bunzip2 < $SRCDIR/$ORIG_IMG.bz2 > $i
-	md5sum $i >> $MD5_TMP
+	echo "$($CRCSUM $i)	$i" >> $CRC_TMP
 
 	rm -f $RAW_IMG
 	echo "e2image -r $ORIG_IMG $RAW_IMG"
 	$E2IMAGE      -r $i $RAW_IMG
-	md5sum $RAW_IMG >> $MD5_TMP
+	echo "$($CRCSUM $RAW_IMG)	$RAW_IMG"  >> $CRC_TMP
 
 	echo "e2image -Q $ORIG_IMG $QCOW2_IMG"
 	$E2IMAGE      -Q $i $QCOW2_IMG
-	md5sum $QCOW2_IMG >> $MD5_TMP
+	echo "$($CRCSUM $QCOW2_IMG)	$QCOW2_IMG"  >> $CRC_TMP
 
 	rm -f $QCOW2_TO_RAW
 	echo "e2image -r $QCOW2_IMG $QCOW2_TO_RAW"
 	$E2IMAGE      -r $i $QCOW2_TO_RAW
-	md5sum $QCOW2_TO_RAW >> $MD5_TMP
+	echo "$($CRCSUM $QCOW2_TO_RAW)	$QCOW2_TO_RAW" >> $CRC_TMP
 
 	rm -f $i
 done
 ) >> $OUT 2>&1
 
-echo "md5sums:" >> $OUT
-cat $MD5_TMP >> $OUT
+echo "checksum:" >> $OUT
+cat $CRC_TMP >> $OUT
 echo "" >> $OUT
 
-diff $MD5 $MD5_TMP >> $OUT 2>&1
+diff $CRC $CRC_TMP >> $OUT 2>&1
 
 if [ $? -eq 0 ]; then
 	echo "$test_name: $test_description: ok"
@@ -52,7 +52,7 @@ else
 	echo "$test_name: $test_description: failed"
 fi
 
-rm -f _image.* $MD5_TMP >/dev/null 2>&1
+rm -f _image.* $CRC_TMP >/dev/null 2>&1
 
 else #if test -x $E2IMAGE_EXE; then
 	echo "$test_name: $test_description: skipped"
diff --git a/tests/u_mke2fs/script b/tests/u_mke2fs/script
index fcf5eae..d249ddd 100644
--- a/tests/u_mke2fs/script
+++ b/tests/u_mke2fs/script
@@ -11,19 +11,19 @@ dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
 echo mke2fs -q -F -o Linux -b 1024 test.img  > $OUT
 $MKE2FS -F -o Linux -I 128 -b 1024 $TMPFILE  >> $OUT 2>&1
-md5=`md5sum $TMPFILE | cut -d " " -f 1`
-echo md5sum before mke2fs $md5 >> $OUT
+crc=`$CRCSUM $TMPFILE`
+echo $CRCSUM before mke2fs $crc >> $OUT
 
 echo using mke2fs to test e2undo >> $OUT
 $MKE2FS -q -F -o Linux -I 256 -O uninit_bg -E lazy_itable_init=1 -b 1024 $TMPFILE  >> $OUT 2>&1
-new_md5=`md5sum $TMPFILE | cut -d " " -f 1`
-echo md5sum after mke2fs $new_md5 >> $OUT
+new_crc=`$CRCSUM $TMPFILE`
+echo $CRCSUM after mke2fs $new_crc >> $OUT
 
 $E2UNDO_EXE  $TDB_FILE $TMPFILE  >> $OUT 2>&1
-new_md5=`md5sum $TMPFILE | cut -d " " -f 1`
-echo md5sum after e2undo $new_md5 >> $OUT
+new_crc=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $new_crc >> $OUT
 
-if [ $md5 = $new_md5 ]; then
+if [ $crc = $new_crc ]; then
 	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
diff --git a/tests/u_tune2fs/script b/tests/u_tune2fs/script
index 4cc1e0c..a443f5a 100644
--- a/tests/u_tune2fs/script
+++ b/tests/u_tune2fs/script
@@ -11,19 +11,19 @@ dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
 echo mke2fs -q -F -o Linux -b 1024 $TMPFILE  > $OUT
 $MKE2FS -q -F -o Linux -I 128 -b 1024 $TMPFILE  >> $OUT 2>&1
-md5=`md5sum $TMPFILE | cut -d " " -f 1`
-echo md5sum before tune2fs $md5 >> $OUT
+crc=`$CRCSUM $TMPFILE`
+echo $CRCSUM before tune2fs $crc >> $OUT
 
 echo using tune2fs to test e2undo >> $OUT
 $TUNE2FS -I 256 $TMPFILE  >> $OUT 2>&1
-new_md5=`md5sum $TMPFILE | cut -d " " -f 1`
-echo md5sum after tune2fs $new_md5 >> $OUT
+new_crc=`$CRCSUM $TMPFILE`
+echo $CRCSUM after tune2fs $new_crc >> $OUT
 
 $E2UNDO_EXE  $TDB_FILE $TMPFILE  >> $OUT 2>&1
-new_md5=`md5sum $TMPFILE | cut -d " " -f 1`
-echo md5sum after e2undo $new_md5 >> $OUT
+new_crc=`$CRCSUM $TMPFILE`
+echo $CRCSUM after e2undo $new_crc >> $OUT
 
-if [ $md5 = $new_md5 ]; then
+if [ $crc = $new_crc ]; then
 	echo "$test_name: $test_description: ok"
 	touch $test_name.ok
 else
-- 
2.0.0

