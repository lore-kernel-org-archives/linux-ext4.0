From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] generic/064: allow room for unexpected allocation behavior
Date: Mon, 10 Aug 2015 13:38:38 -0400
Message-ID: <20150810173838.GA1845@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: namjae.jeon@samsung.com, linux-ext4@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Per Dave Chinner's suggestion, modify generic/064 so that it won't fail
if it finds a few more extents than it expects in its test file after
inserting ranges.  When 064's test file is first created, some file
systems may use more than the ideal minimum single extent to represent
it, and this can lead to a mismatch between the actual and expected
extent count after the ranges have been inserted.  Ext4 file systems
mounted with delayed allocation disabled can exhibit this behavior
if a test file's blocks happen to be allocated across regions of file
system metadata.

Also, replace the open coded counting of extents and holes with a
simpler call to _count_extents(), and clarify some comments.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 tests/generic/064     | 16 +++++++++-------
 tests/generic/064.out |  2 +-
 2 files changed, 10 insertions(+), 8 deletions(-)
 mode change 100644 => 100755 tests/generic/064

diff --git a/tests/generic/064 b/tests/generic/064
old mode 100644
new mode 100755
index 760539a..d384a9a
--- a/tests/generic/064
+++ b/tests/generic/064
@@ -2,9 +2,9 @@
 # FS QA Test No. generic/064
 #
 # Test multiple fallocate insert/collapse range calls on same file.
-# Call insert range a single alternate block multiple times until the file
-# is left with 100 extents and as much number of extents. And Call collapse
-# range about the previously inserted ranges to test merge code of collapse
+# Call insert range on alternate blocks multiple times until the file
+# is left with 50 extents and as many holes. Then call collapse range
+# on the previously inserted ranges to test merge code of collapse
 # range. Also check for data integrity and file system consistency.
 #-----------------------------------------------------------------------
 # Copyright (c) 2015 Samsung Electronics.  All Rights Reserved.
@@ -59,7 +59,7 @@ length=$(($BLOCKS * $BSIZE))
 # Write file
 _do "$XFS_IO_PROG -f -c \"pwrite 0 $length\" -c fsync $src"
 cp $src $dest
-extent_before=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
+extent_before=`_count_extents $dest`
 
 # Insert alternate blocks
 for (( j=0; j < $(($BLOCKS/2)); j++ )); do
@@ -67,8 +67,10 @@ for (( j=0; j < $(($BLOCKS/2)); j++ )); do
 	_do "$XFS_IO_PROG -c \"finsert $offset $BSIZE\" $dest"
 done
 
-# Check if 100 extents are present
-$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
+# Check if 50 extents are present, allowing some slop for file systems
+# that don't have ideal allocation behavior
+num_extents=`_count_extents $dest`
+_within_tolerance "Extent count after inserts" $num_extents 50 0 6% -v
 
 _check_scratch_fs
 if [ $? -ne 0 ]; then
@@ -82,7 +84,7 @@ for (( j=0; j < $(($BLOCKS/2)); j++ )); do
 	_do "$XFS_IO_PROG -c \"fcollapse $offset $BSIZE\" $dest"
 done
 
-extent_after=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
+extent_after=`_count_extents $dest`
 if [ $extent_before -ne $extent_after ]; then
 	echo "extents mismatched before = $extent_before after = $extent_after"
 fi
diff --git a/tests/generic/064.out b/tests/generic/064.out
index b217df5..329e447 100644
--- a/tests/generic/064.out
+++ b/tests/generic/064.out
@@ -1,2 +1,2 @@
 QA output created by 064
-100
+Extent count after inserts is in range
-- 
2.1.4
