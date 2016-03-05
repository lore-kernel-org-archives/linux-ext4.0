From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/12] xfs: remove NOCOW_FL testing from test
Date: Fri, 04 Mar 2016 16:38:30 -0800
Message-ID: <20160305003830.28738.38711.stgit@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org, xfs@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39861 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760188AbcCEAij (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Mar 2016 19:38:39 -0500
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since XFS dropped support for the NOCOW_FL flag, cut it out of the tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/132     |    5 -----
 tests/xfs/132.out |   20 --------------------
 2 files changed, 25 deletions(-)


diff --git a/tests/xfs/132 b/tests/xfs/132
index f174b3f..b09ccb6 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -88,32 +88,27 @@ for i in `seq 2 $nr`; do
 done
 _test_cycle_mount
 free_blocks1=$(stat -f $testdir -c '%f')
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare part of a file"
 $XFS_IO_PROG -f -c "falloc 0 $((sz / 2))" $testdir/file2
 _test_cycle_mount
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare some of the copies"
 $XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file2
 $XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file3
 _test_cycle_mount
 free_blocks2=$(stat -f $testdir -c '%f')
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "funshare the rest of the files"
 $XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file4
 $XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1
 _test_cycle_mount
 free_blocks3=$(stat -f $testdir -c '%f')
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 
 echo "Rewrite the original file"
 _pwrite_byte 0x65 0 $sz $testdir/file1 >> $seqres.full
 _test_cycle_mount
 free_blocks4=$(stat -f $testdir -c '%f')
-lsattr -l $testdir/ | _filter_test_dir | _filter_spaces
 #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
 _within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
diff --git a/tests/xfs/132.out b/tests/xfs/132.out
index f32db7d..3d1281c 100644
--- a/tests/xfs/132.out
+++ b/tests/xfs/132.out
@@ -1,30 +1,10 @@
 QA output created by 132
 Create the original file blocks
 Create the reflink copies
-TEST_DIR/test-132/file1 ---
-TEST_DIR/test-132/file2 ---
-TEST_DIR/test-132/file3 ---
-TEST_DIR/test-132/file4 ---
 funshare part of a file
-TEST_DIR/test-132/file1 ---
-TEST_DIR/test-132/file2 ---
-TEST_DIR/test-132/file3 ---
-TEST_DIR/test-132/file4 ---
 funshare some of the copies
-TEST_DIR/test-132/file1 ---
-TEST_DIR/test-132/file2 No_COW
-TEST_DIR/test-132/file3 No_COW
-TEST_DIR/test-132/file4 ---
 funshare the rest of the files
-TEST_DIR/test-132/file1 No_COW
-TEST_DIR/test-132/file2 No_COW
-TEST_DIR/test-132/file3 No_COW
-TEST_DIR/test-132/file4 No_COW
 Rewrite the original file
-TEST_DIR/test-132/file1 No_COW
-TEST_DIR/test-132/file2 No_COW
-TEST_DIR/test-132/file3 No_COW
-TEST_DIR/test-132/file4 No_COW
 free blocks after reflinking is in range
 free blocks after nocow'ing some copies is in range
 free blocks after nocow'ing all copies is in range

