From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] tests: clean up sed filtering of test output
Date: Mon, 29 Apr 2013 18:27:25 -0600
Message-ID: <1367281645-10595-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-01.shaw.ca ([64.59.136.137]:49480 "EHLO
	smtp-out-01.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab3D3A13 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Apr 2013 20:27:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The sed filters for test outputs that are used to remove build and
test specific information (such as version strings, dates, times,
UUIDs) were unconditionally deleting the first line of output.  This
would normally contain the tool version string, but in some cases
contained other information that was being lost.  This can lead to
difficulty debugging test failures.

The sed filtering has been changed to only remove the actual version
strings.  As well, similar filter strings were duplicated throughout
many scripts, and "sed" and "tr" were often called multiple times in
a pipeline.  These have been consolidated into a single filter.sed
file to avoid having to maintain these filters in multiple places.

In a few cases, accidentally deleted messages have been restored to
the expect output for the tests.  In other cases, trivial whitespace
has been changed in the expect files.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 tests/d_loaddump/script                |    6 ++--
 tests/d_special_files/script           |   14 ++++++------
 tests/f_jnl_32bit/expect.0             |    1 -
 tests/f_jnl_32bit/script               |    2 +-
 tests/f_jnl_64bit/expect.0             |    1 -
 tests/f_jnl_64bit/script               |    2 +-
 tests/f_jnl_errno/expect.0             |    1 -
 tests/f_jnl_errno/script               |    2 +-
 tests/f_orphan_indirect_inode/expect.1 |    1 +
 tests/f_preen/expect.1                 |    1 +
 tests/f_resize_inode/script            |   36 ++++++++++++++----------------
 tests/filter.sed                       |   19 ++++++++++++++++
 tests/filter_dumpe2fs                  |   14 ------------
 tests/m_bigjournal/expect.1            |    2 -
 tests/m_dasd_bs/expect.1               |    2 -
 tests/m_extent_journal/expect.1        |    2 -
 tests/m_large_file/expect.1            |    2 -
 tests/m_meta_bg/expect.1               |    2 -
 tests/m_mkfs_overhead/script           |    4 +-
 tests/m_mmp/expect.1                   |    2 -
 tests/m_no_opt/expect.1                |    2 -
 tests/m_raid_opt/expect.1              |    2 -
 tests/m_std/expect.1                   |    2 -
 tests/m_uninit/expect.1                |    2 -
 tests/r_inline_xattr/script            |    2 +-
 tests/r_move_itable/expect             |    4 ---
 tests/r_move_itable/script             |   37 +++++++++++++++----------------
 tests/r_resize_inode/expect            |    3 --
 tests/r_resize_inode/script            |   34 +++++++++++++---------------
 tests/run_e2fsck                       |    6 +---
 tests/run_mke2fs                       |    7 ++++-
 31 files changed, 95 insertions(+), 122 deletions(-)
 create mode 100644 tests/filter.sed
 delete mode 100644 tests/filter_dumpe2fs

diff --git a/tests/d_loaddump/script b/tests/d_loaddump/script
index 9b687eb..39727ba 100644
--- a/tests/d_loaddump/script
+++ b/tests/d_loaddump/script
@@ -24,19 +24,19 @@ echo "debugfs -R ''write $TEST_DATA test_data'' -w test.img" > $OUT.new
 $DEBUGFS -R "write $TEST_DATA test_data" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo e2fsck $VERIFY_FSCK_OPT -N test_filesys > $OUT.new
 $FSCK $VERIFY_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "debugfs -R ''dump test_data $VERIFY_DATA'' test.img" > $OUT.new
 $DEBUGFS -R "dump test_data $VERIFY_DATA" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "cmp $TEST_DATA $VERIFY_DATA" >> $OUT
 cmp $TEST_DATA $VERIFY_DATA >>$OUT
diff --git a/tests/d_special_files/script b/tests/d_special_files/script
index 85cbb4d..1a1999a 100644
--- a/tests/d_special_files/script
+++ b/tests/d_special_files/script
@@ -33,43 +33,43 @@ echo "debugfs -R ''stat foo'' -w test.img" > $OUT.new
 $DEBUGFS -R "stat foo" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "debugfs -R ''stat foo2'' -w test.img" > $OUT.new
 $DEBUGFS -R "stat foo2" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "debugfs -R ''block_dump 28'' -w test.img" > $OUT.new
 $DEBUGFS -R "block_dump 28" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "debugfs -R ''stat pipe'' -w test.img" > $OUT.new
 $DEBUGFS -R "stat pipe" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "debugfs -R ''stat sda'' -w test.img" > $OUT.new
 $DEBUGFS -R "stat sda" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "debugfs -R ''stat null'' -w test.img" > $OUT.new
 $DEBUGFS -R "stat null" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo e2fsck $VERIFY_FSCK_OPT -N test_filesys > $OUT.new
 $FSCK $VERIFY_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 #
 # Do the verification
diff --git a/tests/f_jnl_32bit/expect.0 b/tests/f_jnl_32bit/expect.0
index 29b180f..b7de48e 100644
--- a/tests/f_jnl_32bit/expect.0
+++ b/tests/f_jnl_32bit/expect.0
@@ -1,4 +1,3 @@
-
 Journal starts at block 1, transaction 2
 Found expected sequence 2, type 1 (descriptor block) at block 1
 Dumping descriptor block, sequence 2, at block 1:
diff --git a/tests/f_jnl_32bit/script b/tests/f_jnl_32bit/script
index 4056f0d..9fb4366 100644
--- a/tests/f_jnl_32bit/script
+++ b/tests/f_jnl_32bit/script
@@ -1,4 +1,4 @@
-PREP_CMD='$DEBUGFS -R "logdump -a" $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs > $test_name.0.log'
+PREP_CMD='$DEBUGFS -R "logdump -a" $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $test_name.0.log'
 PASS_ZERO=true
 
 . $cmd_dir/run_e2fsck
diff --git a/tests/f_jnl_64bit/expect.0 b/tests/f_jnl_64bit/expect.0
index 1b21057..2007f03 100644
--- a/tests/f_jnl_64bit/expect.0
+++ b/tests/f_jnl_64bit/expect.0
@@ -1,4 +1,3 @@
-
 Journal starts at block 67, transaction 32
 Found expected sequence 32, type 5 (revoke table) at block 67
 Dumping revoke block, sequence 32, at block 67:
diff --git a/tests/f_jnl_64bit/script b/tests/f_jnl_64bit/script
index 4056f0d..9fb4366 100644
--- a/tests/f_jnl_64bit/script
+++ b/tests/f_jnl_64bit/script
@@ -1,4 +1,4 @@
-PREP_CMD='$DEBUGFS -R "logdump -a" $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs > $test_name.0.log'
+PREP_CMD='$DEBUGFS -R "logdump -a" $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $test_name.0.log'
 PASS_ZERO=true
 
 . $cmd_dir/run_e2fsck
diff --git a/tests/f_jnl_errno/expect.0 b/tests/f_jnl_errno/expect.0
index 7dae17d..6dad72a 100644
--- a/tests/f_jnl_errno/expect.0
+++ b/tests/f_jnl_errno/expect.0
@@ -1,4 +1,3 @@
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/f_jnl_errno/script b/tests/f_jnl_errno/script
index dd1ffd6..ef5006a 100644
--- a/tests/f_jnl_errno/script
+++ b/tests/f_jnl_errno/script
@@ -1,4 +1,4 @@
-AFTER_CMD='$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs > $test_name.0.log'
+AFTER_CMD='$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $test_name.0.log'
 PASS_ZERO=true
 
 . $cmd_dir/run_e2fsck
diff --git a/tests/f_orphan_indirect_inode/expect.1 b/tests/f_orphan_indirect_inode/expect.1
index 33cdd65..814a688 100644
--- a/tests/f_orphan_indirect_inode/expect.1
+++ b/tests/f_orphan_indirect_inode/expect.1
@@ -1,2 +1,3 @@
+test_filesys: Truncating orphaned inode 12 (uid=0, gid=0, mode=0100644, size=0)
 test_filesys: clean, 12/16 files, 21/100 blocks
 Exit status is 0
diff --git a/tests/f_preen/expect.1 b/tests/f_preen/expect.1
index c65209d..dd20572 100644
--- a/tests/f_preen/expect.1
+++ b/tests/f_preen/expect.1
@@ -1,3 +1,4 @@
+test_filesys: Note: if several inode or block bitmap blocks or part
 of the inode table require relocation, you may wish to try
 running e2fsck with the '-b 8193' option first.  The problem
 may lie only with the primary block group descriptors, and
diff --git a/tests/f_resize_inode/script b/tests/f_resize_inode/script
index 840432d..190871b 100644
--- a/tests/f_resize_inode/script
+++ b/tests/f_resize_inode/script
@@ -15,15 +15,13 @@ cp /dev/null $OUT
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
 echo mke2fs -F -O resize_inode -o Linux -b 1024 -g 1024 test.img 16384 > $OUT
-$MKE2FS -F -O resize_inode -o Linux -b 1024 -g 1024 $TMPFILE 16384 2>&1 \
-	| sed -e '1d' | grep -v "automatically checked" | 
-	grep -v 'Discarding device blocks' |
-	grep -v "whichever comes first" >> $OUT 
+$MKE2FS -F -O resize_inode -o Linux -b 1024 -g 1024 $TMPFILE 16384 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo ----------------------------------------------- >> $OUT
@@ -33,18 +31,18 @@ echo "debugfs -R ''set_inode_field <7> block[2] 42'' -w test.img" > $OUT.new
 $DEBUGFS -R "set_inode_field <7> block[2] 42" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 rm -f $OUT.new
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo ----------------------------------------------- >> $OUT
@@ -54,18 +52,18 @@ echo "debugfs -R ''clri <7>'' -w test.img" > $OUT.new
 $DEBUGFS -R "clri <7>" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 rm -f $OUT.new
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo ----------------------------------------------- >> $OUT
@@ -75,18 +73,18 @@ echo "debugfs -R ''set_inode_field <7> bmap[524] 57'' -w test.img" > $OUT.new
 $DEBUGFS -R "set_inode_field <7> bmap[524] 57" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 rm -f $OUT.new
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo ----------------------------------------------- >> $OUT
@@ -96,12 +94,12 @@ echo "debugfs -R ''set_super_value reserved_gdt_blocks 15679'' -w test.img" > $O
 $DEBUGFS -R "set_super_value reserved_gdt_blocks 15679" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo ----------------------------------------------- >> $OUT
@@ -111,18 +109,18 @@ echo "debugfs -R ''set_super_value reserved_gdt_blocks 32'' -w test.img" > $OUT.
 $DEBUGFS -R "set_super_value reserved_gdt_blocks 32" -w $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '2d' $OUT.new >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 rm -f $OUT.new
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 rm -f $OUT.new
 
 
diff --git a/tests/filter.sed b/tests/filter.sed
new file mode 100644
index 0000000..91b956b
--- /dev/null
+++ b/tests/filter.sed
@@ -0,0 +1,19 @@
+/^[dbgumpe2fsckrsiz]* [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
+s/\\015//g
+/automatically checked/d
+/^Directory Hash Seed:/d
+/Discarding device blocks/d
+/^Filesystem created:/d
+/^Filesystem flags:/d
+/^Filesystem UUID:/d
+/^JFS DEBUG:/d
+/^Last write time:/d
+/^Last mount time:/d
+/^Last checked:/d
+/^Lifetime writes:/d
+/^Maximum mount count:/d
+/^Next check after:/d
+/Reserved blocks uid:/s/ (user .*)//
+/Reserved blocks gid:/s/ (group .*)//
+/whichever comes first/d
+/^  Checksum /d
diff --git a/tests/filter_dumpe2fs b/tests/filter_dumpe2fs
deleted file mode 100644
index 7544217..0000000
--- a/tests/filter_dumpe2fs
+++ /dev/null
@@ -1,14 +0,0 @@
-1s/^.*$//
-/^Filesystem UUID:/d
-/^Filesystem created:/d
-/^Filesystem flags:/d
-/^Last write time:/d
-/^Last mount time:/d
-/^Last checked:/d
-/^Directory Hash Seed:/d
-/^Next check after:/d
-/^Maximum mount count:/d
-/^Lifetime writes:/d
-/Reserved blocks uid:/s/ (user .*)//
-/Reserved blocks gid:/s/ (group .*)//
-/^  Checksum /d
diff --git a/tests/m_bigjournal/expect.1 b/tests/m_bigjournal/expect.1
index ad4a035..312c276 100644
--- a/tests/m_bigjournal/expect.1
+++ b/tests/m_bigjournal/expect.1
@@ -1,5 +1,4 @@
 Filesystem features: has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -7,7 +6,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/1344 files (0.0% non-contiguous), 1286989/2750000 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/m_dasd_bs/expect.1 b/tests/m_dasd_bs/expect.1
index 61f6894..0cbe339 100644
--- a/tests/m_dasd_bs/expect.1
+++ b/tests/m_dasd_bs/expect.1
@@ -18,7 +18,6 @@ Writing inode tables:    done
 Writing superblocks and filesystem accounting information:    done
 
 Filesystem features: ext_attr resize_inode dir_index filetype sparse_super
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -26,7 +25,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/16384 files (0.0% non-contiguous), 1104/32768 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/m_extent_journal/expect.1 b/tests/m_extent_journal/expect.1
index aaedf72..d5d7a24 100644
--- a/tests/m_extent_journal/expect.1
+++ b/tests/m_extent_journal/expect.1
@@ -19,7 +19,6 @@ Creating journal (4096 blocks): done
 Writing superblocks and filesystem accounting information:    done
 
 Filesystem features: has_journal ext_attr resize_inode dir_index filetype extent sparse_super
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -27,7 +26,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/16384 files (0.0% non-contiguous), 7460/65536 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/m_large_file/expect.1 b/tests/m_large_file/expect.1
index 59a9b7f..ced9431 100644
--- a/tests/m_large_file/expect.1
+++ b/tests/m_large_file/expect.1
@@ -16,7 +16,6 @@ Writing inode tables:    done
 Writing superblocks and filesystem accounting information:    done
 
 Filesystem features: ext_attr resize_inode dir_index filetype sparse_super large_file
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -24,7 +23,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/64 files (0.0% non-contiguous), 17/16384 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/m_meta_bg/expect.1 b/tests/m_meta_bg/expect.1
index e7c2b2c..ec10d6e 100644
--- a/tests/m_meta_bg/expect.1
+++ b/tests/m_meta_bg/expect.1
@@ -17,7 +17,6 @@ Writing inode tables:        done
 Writing superblocks and filesystem accounting information:        done
 
 Filesystem features: ext_attr dir_index filetype meta_bg sparse_super
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -25,7 +24,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/32768 files (0.0% non-contiguous), 4389/131072 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/m_mkfs_overhead/script b/tests/m_mkfs_overhead/script
index 63612a8..c21da0c 100644
--- a/tests/m_mkfs_overhead/script
+++ b/tests/m_mkfs_overhead/script
@@ -12,8 +12,8 @@ export MKE2FS_SKIP_PROGRESS MKE2FS_SKIP_CHECK_MSG
 
 cp /dev/null $OUT
 
-$MKE2FS -F -o Linux $MKE2FS_OPTS $TMPFILE $FS_SIZE 2>&1 | sed -e 1d | \
-	sed -e "s;$TMPFILE;test.img;" | tr -d \\015 > $OUT
+$MKE2FS -F -o Linux $MKE2FS_OPTS $TMPFILE $FS_SIZE 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" > $OUT
 
 rm -f $TMPFILE
 
diff --git a/tests/m_mmp/expect.1 b/tests/m_mmp/expect.1
index 1f7737d..e18aa77 100644
--- a/tests/m_mmp/expect.1
+++ b/tests/m_mmp/expect.1
@@ -19,7 +19,6 @@ Multiple mount protection is enabled with update interval 5 seconds.
 Writing superblocks and filesystem accounting information:    done
 
 Filesystem features: ext_attr resize_inode dir_index filetype mmp sparse_super large_file
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -27,7 +26,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/65536 files (0.0% non-contiguous), 2093/65536 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/m_no_opt/expect.1 b/tests/m_no_opt/expect.1
index 8fa605b..e7bf2db 100644
--- a/tests/m_no_opt/expect.1
+++ b/tests/m_no_opt/expect.1
@@ -17,7 +17,6 @@ Writing inode tables:    done
 Writing superblocks and filesystem accounting information:    done
 
 Filesystem features:(none)
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -25,7 +24,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/16384 files (0.0% non-contiguous), 2094/65536 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/m_raid_opt/expect.1 b/tests/m_raid_opt/expect.1
index 0c35700..9548665 100644
--- a/tests/m_raid_opt/expect.1
+++ b/tests/m_raid_opt/expect.1
@@ -18,7 +18,6 @@ Writing inode tables:        done
 Writing superblocks and filesystem accounting information:        done
 
 Filesystem features: ext_attr resize_inode dir_index filetype sparse_super
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -26,7 +25,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/32768 files (0.0% non-contiguous), 7238/131072 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/m_std/expect.1 b/tests/m_std/expect.1
index 23876ec..f356531 100644
--- a/tests/m_std/expect.1
+++ b/tests/m_std/expect.1
@@ -18,7 +18,6 @@ Writing inode tables:    done
 Writing superblocks and filesystem accounting information:    done
 
 Filesystem features: ext_attr resize_inode dir_index filetype sparse_super
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -26,7 +25,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/16384 files (0.0% non-contiguous), 3364/65536 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/m_uninit/expect.1 b/tests/m_uninit/expect.1
index f285214..3212e10 100644
--- a/tests/m_uninit/expect.1
+++ b/tests/m_uninit/expect.1
@@ -18,7 +18,6 @@ Writing inode tables:      done
 Writing superblocks and filesystem accounting information:      done
 
 Filesystem features: ext_attr resize_inode dir_index filetype sparse_super uninit_bg
- 
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
@@ -26,7 +25,6 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 test_filesys: 11/32768 files (0.0% non-contiguous), 5691/131072 blocks
 Exit status is 0
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/r_inline_xattr/script b/tests/r_inline_xattr/script
index 021088e..d882587 100644
--- a/tests/r_inline_xattr/script
+++ b/tests/r_inline_xattr/script
@@ -20,7 +20,7 @@ echo "resize2fs test.img 5M" >> $OUT
 $RESIZE2FS $TMPFILE 5M 2>&1 >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e "s;$TMPFILE;test.img;" >> $OUT
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 
 # Look at inline extended attribute in resized fs
 echo "debugfs -R ''stat file'' test.img 2>&1 | grep ''^Inode\|in inode body\|name = ''" >> $OUT
diff --git a/tests/r_move_itable/expect b/tests/r_move_itable/expect
index 195bb11..b4b089b 100644
--- a/tests/r_move_itable/expect
+++ b/tests/r_move_itable/expect
@@ -13,7 +13,6 @@ Pass 5: Checking group summary information
 test_filesys: 11/1248 files (0.0% non-contiguous), 1281/9985 blocks
 Exit status is 0
 dumpe2fs test.img
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
@@ -312,7 +311,6 @@ Pass 5: Checking group summary information
 test_filesys: 11/2496 files (0.0% non-contiguous), 1644/19969 blocks
 Exit status is 0
 dumpe2fs test.img
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
@@ -847,7 +845,6 @@ Pass 5: Checking group summary information
 test_filesys: 11/3744 files (0.0% non-contiguous), 2007/29953 blocks
 Exit status is 0
 dumpe2fs test.img
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
@@ -1618,7 +1615,6 @@ Pass 5: Checking group summary information
 test_filesys: 11/5024 files (0.0% non-contiguous), 2376/40000 blocks
 Exit status is 0
 dumpe2fs test.img
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/r_move_itable/script b/tests/r_move_itable/script
index fc8286f..e567888 100644
--- a/tests/r_move_itable/script
+++ b/tests/r_move_itable/script
@@ -14,18 +14,17 @@ cp /dev/null $OUT
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
 echo mke2fs -q -F -o Linux -b 1024 -g 256 test.img 1024 > $OUT
-$MKE2FS -q -F -o Linux -b 1024 -g 256 $TMPFILE 1024 2>&1 \
-	| sed -e '1d' | grep -v "automatically checked" | 
-	grep -v "whichever comes first" >> $OUT 
+$MKE2FS -q -F -o Linux -b 1024 -g 256 $TMPFILE 1024 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 echo resize2fs -p test.img 10000 >> $OUT
-$RESIZE2FS -p $TMPFILE 10000 2>&1 | sed -e '1d' | \
-	   sed -e "s;$TMPFILE;test.img;" >> $OUT
+$RESIZE2FS -p $TMPFILE 10000 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 $DEBUGFS -R "set_super_value lastcheck 0" -w $TMPFILE >/dev/null 2>&1
@@ -34,18 +33,18 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 
 echo "--------------------------------" >> $OUT
 
 echo resize2fs -p test.img 20000 >> $OUT
-$RESIZE2FS -p $TMPFILE 20000 2>&1 | sed -e '1d' | \
-	   sed -e "s;$TMPFILE;test.img;" >> $OUT
+$RESIZE2FS -p $TMPFILE 20000 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 $DEBUGFS -R "set_super_value lastcheck 0" -w $TMPFILE >/dev/null 2>&1
@@ -54,18 +53,18 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 
 echo "--------------------------------" >> $OUT
 
 echo resize2fs -p test.img 30000 >> $OUT
-$RESIZE2FS -p $TMPFILE 30000 2>&1 | sed -e '1d' | \
-	   sed -e "s;$TMPFILE;test.img;" >> $OUT
+$RESIZE2FS -p $TMPFILE 30000 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 $DEBUGFS -R "set_super_value lastcheck 0" -w $TMPFILE >/dev/null 2>&1
@@ -74,18 +73,18 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 
 echo "--------------------------------" >> $OUT
 
 echo resize2fs -p test.img 40000 >> $OUT
-$RESIZE2FS -p $TMPFILE 40000 2>&1 | sed -e '1d' | \
-	   sed -e "s;$TMPFILE;test.img;" >> $OUT
+$RESIZE2FS -p $TMPFILE 40000 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 $DEBUGFS -R "set_super_value lastcheck 0" -w $TMPFILE >/dev/null 2>&1
@@ -94,7 +93,7 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 
 rm -f $TMPFILE
 
diff --git a/tests/r_resize_inode/expect b/tests/r_resize_inode/expect
index f9f79c4..786fe13 100644
--- a/tests/r_resize_inode/expect
+++ b/tests/r_resize_inode/expect
@@ -11,7 +11,6 @@ Pass 5: Checking group summary information
 test_filesys: 11/16384 files (0.0% non-contiguous), 4513/65536 blocks
 Exit status is 0
 dumpe2fs test.img
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
@@ -459,7 +458,6 @@ Pass 5: Checking group summary information
 test_filesys: 11/4096 files (0.0% non-contiguous), 2107/16384 blocks
 Exit status is 0
 dumpe2fs test.img
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
@@ -614,7 +612,6 @@ Pass 5: Checking group summary information
 test_filesys: 11/41472 files (0.0% non-contiguous), 8361/165536 blocks
 Exit status is 0
 dumpe2fs test.img
-
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
diff --git a/tests/r_resize_inode/script b/tests/r_resize_inode/script
index da3c2ed..0f12138 100644
--- a/tests/r_resize_inode/script
+++ b/tests/r_resize_inode/script
@@ -14,18 +14,17 @@ cp /dev/null $OUT
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
 echo mke2fs -q -F -O resize_inode -o Linux -b 1024 -g 1024 test.img 16384 > $OUT
-$MKE2FS -q -F -O resize_inode -o Linux -b 1024 -g 1024 $TMPFILE 16384 2>&1 \
-	| sed -e '1d' | grep -v "automatically checked" | 
-	grep -v "whichever comes first" >> $OUT 
+$MKE2FS -q -F -O resize_inode -o Linux -b 1024 -g 1024 $TMPFILE 16384 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 echo resize2fs test.img 65536 >> $OUT
-$RESIZE2FS $TMPFILE 65536 2>&1 | sed -e '1d' | \
-	   sed -e "s;$TMPFILE;test.img;" >> $OUT
+$RESIZE2FS $TMPFILE 65536 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 $DEBUGFS -R "set_super_value lastcheck 0" -w $TMPFILE >/dev/null 2>&1
@@ -34,25 +33,24 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 
 echo "--------------------------------" >> $OUT
 
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
 echo mke2fs -q -F -O resize_inode -o Linux -b 1024 -g 1024 test.img 65536 >> $OUT
-$MKE2FS -q -F -O resize_inode -o Linux -b 1024 -g 1024 $TMPFILE 65536 2>&1 \
-	| sed -e '1d' | grep -v "automatically checked" | 
-	grep -v "whichever comes first" >> $OUT 
+$MKE2FS -q -F -O resize_inode -o Linux -b 1024 -g 1024 $TMPFILE 65536 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 echo resize2fs test.img 16384 >> $OUT
-$RESIZE2FS $TMPFILE 16384 2>&1 | sed -e '1d' | \
-	   sed -e "s;$TMPFILE;test.img;" >> $OUT
+$RESIZE2FS $TMPFILE 16384 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 $DEBUGFS -R "set_super_value lastcheck 0" -w $TMPFILE >/dev/null 2>&1
@@ -61,18 +59,18 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 
 echo "--------------------------------" >> $OUT
 
 echo resize2fs test.img 165536 >> $OUT
-$RESIZE2FS $TMPFILE 165536 2>&1 | sed -e '1d' | \
-	   sed -e "s;$TMPFILE;test.img;" >> $OUT
+$RESIZE2FS $TMPFILE 165536 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
-sed -e '1d' $OUT.new | sed -e '/^JFS DEBUG:/d'  | tr -d \\015 >> $OUT
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 $DEBUGFS -R "set_super_value lastcheck 0" -w $TMPFILE >/dev/null 2>&1
@@ -81,7 +79,7 @@ $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE >/dev/null 2>&1
 $TUNE2FS -c 20 -U clear $TMPFILE  >/dev/null 2>&1
 
 echo dumpe2fs test.img >> $OUT
-$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs >> $OUT
+$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 
 rm -f $TMPFILE
 cmp -s $OUT $EXP
diff --git a/tests/run_e2fsck b/tests/run_e2fsck
index ab623e8..5f28d92 100644
--- a/tests/run_e2fsck
+++ b/tests/run_e2fsck
@@ -50,16 +50,14 @@ eval $PREP_CMD
 $FSCK $FSCK_OPT  -N test_filesys $TMPFILE > $OUT1.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT1.new
-sed -e '1d' $OUT1.new | sed -e '/^JFS DEBUG:/d' | \
-	    sed -e "s;$TMPFILE;test.img;" | tr -d \\015 >> $OUT1
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT1.new >> $OUT1
 rm -f $OUT1.new
 
 if [ "$ONE_PASS_ONLY" != "true" ]; then
 	$FSCK $SECOND_FSCK_OPT -N test_filesys $TMPFILE > $OUT2.new 2>&1 
 	status=$?
 	echo Exit status is $status >> $OUT2.new
-	sed -e '1d' $OUT2.new | sed -e '/^JFS DEBUG:/d' | \
-	    sed -e "s;$TMPFILE;test.img;" > $OUT2
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT2.new > $OUT2
 	rm -f $OUT2.new
 fi
 
diff --git a/tests/run_mke2fs b/tests/run_mke2fs
index f524996..82eca41 100644
--- a/tests/run_mke2fs
+++ b/tests/run_mke2fs
@@ -11,8 +11,11 @@ MKE2FS_SKIP_PROGRESS=true
 MKE2FS_SKIP_CHECK_MSG=true
 export MKE2FS_SKIP_PROGRESS MKE2FS_SKIP_CHECK_MSG
 > $TMPFILE
-PREP_CMD='$MKE2FS -F -o Linux $MKE2FS_OPTS $TMPFILE $FS_SIZE 2>&1 | sed -e 1d | grep -v "Discarding device blocks" | tr -d \\015 > $OUT1 ; $DEBUGFS -R features $TMPFILE 2>&1 | sed -e 1d | tr -d \\015 >> $OUT1 ; echo " " >> $OUT1'
-AFTER_CMD='$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs | tr -d \\015 >> $OUT1'
+PREP_CMD='$MKE2FS -F -o Linux $MKE2FS_OPTS $TMPFILE $FS_SIZE 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" > $OUT1;
+	$DEBUGFS -R features $TMPFILE 2>&1 |
+	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT1'
+AFTER_CMD='$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT1'
 . $cmd_dir/run_e2fsck
 
 else #if test -x $DEBUGFS_EXE; then
-- 
1.7.3.4

