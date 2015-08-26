From: Jan Kara <jack@suse.com>
Subject: [PATCH 11/21] tests: Specify number of reserved inodes for tests where it matters
Date: Wed, 26 Aug 2015 18:22:26 +0200
Message-ID: <1440606156-5754-12-git-send-email-jack@suse.com>
References: <1440606156-5754-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952AbbHZQW4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:22:56 -0400
In-Reply-To: <1440606156-5754-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are some tests which rely on number of reserved inodes being 10.
In some cases they expect particular blocks being allocated to
particular files or they specify rather small number of inodes in the
filesystem. Make these tests explicitly set number of reserved inodes to
the expected value since the default is going to change and these tests
would start failing.

Signed-off-by: Jan Kara <jack@suse.com>
---
 tests/d_special_files/expect      | 2 +-
 tests/d_special_files/script      | 4 ++--
 tests/f_desc_size_bad/script      | 2 +-
 tests/f_dup4/script               | 2 +-
 tests/f_uninit_last_uninit/script | 2 +-
 tests/m_bigjournal/script         | 2 +-
 tests/r_move_itable/expect        | 2 +-
 tests/r_move_itable/script        | 4 ++--
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/d_special_files/expect b/tests/d_special_files/expect
index f729b0f1c7be..511cd215fae6 100644
--- a/tests/d_special_files/expect
+++ b/tests/d_special_files/expect
@@ -1,5 +1,5 @@
 debugfs create special files
-mke2fs -Fq -b 1024 test.img 512
+mke2fs -Fq -b 1024 -E reserved_inodes=10 test.img 512
 Exit status is 0
 debugfs -R ''stat foo'' -w test.img
 Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
diff --git a/tests/d_special_files/script b/tests/d_special_files/script
index 9bdff5d005a4..ab0a4120945c 100644
--- a/tests/d_special_files/script
+++ b/tests/d_special_files/script
@@ -11,9 +11,9 @@ echo "debugfs create special files" > $OUT
 
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
-echo "mke2fs -Fq -b 1024 test.img 512" >> $OUT
+echo "mke2fs -Fq -b 1024 -E reserved_inodes=10 test.img 512" >> $OUT
 
-$MKE2FS -Fq $TMPFILE 512 > /dev/null 2>&1
+$MKE2FS -Fq -E reserved_inodes=10 $TMPFILE 512 > /dev/null 2>&1
 status=$?
 echo Exit status is $status >> $OUT
 
diff --git a/tests/f_desc_size_bad/script b/tests/f_desc_size_bad/script
index 544032860641..1c639f2e6ebb 100644
--- a/tests/f_desc_size_bad/script
+++ b/tests/f_desc_size_bad/script
@@ -6,7 +6,7 @@ fi
 DESCRIPTION="bad superblock s_desc_size"
 SKIP_GUNZIP=true
 touch $TMPFILE
-$MKE2FS -F -o Linux -O 64bit,extents -N 32 -b 1024 -g 512 -E desc_size=128 $TMPFILE 2048 > $test_name.log 2>&1
+$MKE2FS -F -o Linux -O 64bit,extents -N 32 -b 1024 -g 512 -E desc_size=128,reserved_inodes=10 $TMPFILE 2048 > $test_name.log 2>&1
 $DEBUGFS -R "ssv desc_size 129" -w $TMPFILE >> $test_name.log 2>&1
 
 E2FSCK_TIME=200704102100
diff --git a/tests/f_dup4/script b/tests/f_dup4/script
index 498f5259c388..2d9946dd4285 100644
--- a/tests/f_dup4/script
+++ b/tests/f_dup4/script
@@ -6,7 +6,7 @@ TEST_DATA="$test_name.tmp"
 echo "/ Murphy Magic.  The SeCrEt of the UnIvErSe is 43, NOT 42" > $TEST_DATA
 
 touch $TMPFILE
-$MKE2FS -N 32 -F -o Linux -b 1024 $TMPFILE 100 > /dev/null 2>&1 
+$MKE2FS -N 32 -E reserved_inodes=10 -F -o Linux -b 1024 $TMPFILE 100 > /dev/null 2>&1
 $DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
 set_current_time 20070410210000
 set_super_value lastcheck 0
diff --git a/tests/f_uninit_last_uninit/script b/tests/f_uninit_last_uninit/script
index 376c97823d59..543b7b2a5f67 100644
--- a/tests/f_uninit_last_uninit/script
+++ b/tests/f_uninit_last_uninit/script
@@ -3,7 +3,7 @@ if test -x $DEBUGFS_EXE; then
 SKIP_GUNZIP="true"
 
 touch $TMPFILE
-$MKE2FS -N 32 -F -o Linux -O uninit_bg -b 1024 $TMPFILE 10000 > /dev/null 2>&1 
+$MKE2FS -N 32 -F -o Linux -O uninit_bg -E reserved_inodes=10 -b 1024 $TMPFILE 10000 > /dev/null 2>&1
 $DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
 set_current_time 20070410210000
 set_super_value lastcheck 0
diff --git a/tests/m_bigjournal/script b/tests/m_bigjournal/script
index 576d99ecb23f..6660244b30a5 100644
--- a/tests/m_bigjournal/script
+++ b/tests/m_bigjournal/script
@@ -2,7 +2,7 @@ DESCRIPTION="journal over 4GB in size"
 FS_SIZE=11000000
 DUMPE2FS_IGNORE_80COL=1
 export DUMPE2FS_IGNORE_80COL
-MKE2FS_OPTS="-t ext4 -G 512 -N 1280 -J size=5000 -q -E lazy_journal_init,lazy_itable_init,nodiscard"
+MKE2FS_OPTS="-t ext4 -G 512 -N 1280 -J size=5000 -q -E lazy_journal_init,lazy_itable_init,nodiscard,reserved_inodes=10"
 if [ $(uname -s) = "Darwin" ]; then
 	echo "$test_name: $DESCRIPTION: skipped for HFS+ (no sparse files)"
 	return 0
diff --git a/tests/r_move_itable/expect b/tests/r_move_itable/expect
index cec0038ae6fe..b798604c7ce0 100644
--- a/tests/r_move_itable/expect
+++ b/tests/r_move_itable/expect
@@ -1,4 +1,4 @@
-mke2fs -q -F -o Linux -b 1024 -g 256 test.img 1024
+mke2fs -q -F -o Linux -b 1024 -g 256 -E reserved_inodes=10 test.img 1024
 resize2fs -p test.img 10000
 Resizing the filesystem on test.img to 10000 (1k) blocks.
 Begin pass 1 (max = 35)
diff --git a/tests/r_move_itable/script b/tests/r_move_itable/script
index 3f02a799f2f5..b2ffb527c7c5 100644
--- a/tests/r_move_itable/script
+++ b/tests/r_move_itable/script
@@ -13,8 +13,8 @@ cp /dev/null $OUT
 
 dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
 
-echo mke2fs -q -F -o Linux -b 1024 -g 256 test.img 1024 > $OUT
-$MKE2FS -q -F -o Linux -b 1024 -g 256 $TMPFILE 1024 2>&1 |
+echo mke2fs -q -F -o Linux -b 1024 -g 256 -E reserved_inodes=10 test.img 1024 > $OUT
+$MKE2FS -q -F -o Linux -b 1024 -g 256 -E reserved_inodes=10 $TMPFILE 1024 2>&1 |
 	sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" >> $OUT
 
 echo resize2fs -p test.img 10000 >> $OUT
-- 
2.1.4

