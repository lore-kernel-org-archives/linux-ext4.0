From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/47] tests: fix test scripts that don't work on non-Linux
 systems.
Date: Fri, 07 Nov 2014 13:50:49 -0800
Message-ID: <20141107215049.883.24332.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35097 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKGVuz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:50:55 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix various tests that break on non-Linux systems; in particular,
sed -i doesn't work the same on all platforms; and try to keep the
GNU getopt-isms out.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/d_xattr_edits/expect                         |    4 +--
 tests/d_xattr_edits/script                         |   32 ++++++++++----------
 tests/f_detect_junk/script                         |    3 +-
 tests/f_detect_xfs/script                          |    3 +-
 tests/f_itable_collision/script                    |    5 +--
 tests/j_corrupt_commit_csum/expect                 |    2 +
 tests/j_corrupt_commit_csum/script                 |    1 +
 tests/j_corrupt_commit_tid/expect                  |    2 +
 tests/j_corrupt_commit_tid/script                  |    1 +
 tests/j_corrupt_descr_csum/expect                  |    2 +
 tests/j_corrupt_descr_csum/script                  |    1 +
 tests/j_corrupt_descr_tid/expect                   |    2 +
 tests/j_corrupt_descr_tid/script                   |    1 +
 tests/j_corrupt_journal_block/expect               |    3 +-
 tests/j_corrupt_journal_block/script               |    1 +
 tests/j_corrupt_revoke_block/expect                |    2 +
 tests/j_corrupt_revoke_block/script                |    1 +
 tests/j_corrupt_revoke_csum/expect                 |    2 +
 tests/j_corrupt_revoke_csum/script                 |    1 +
 tests/j_corrupt_sb_csum/expect                     |    2 +
 tests/j_corrupt_sb_csum/script                     |    1 +
 tests/j_corrupt_sb_magic/expect                    |    2 +
 tests/j_corrupt_sb_magic/script                    |    1 +
 tests/j_ext_long_revoke_trans/script               |    6 ++--
 tests/j_ext_long_trans/script                      |    4 +--
 tests/j_long_revoke_trans/script                   |    4 +--
 tests/j_long_revoke_trans_mcsum_32bit/script       |    4 +--
 tests/j_long_revoke_trans_mcsum_64bit/script       |    4 +--
 tests/j_long_trans/script                          |    4 +--
 tests/j_long_trans_mcsum_32bit/script              |    4 +--
 tests/j_long_trans_mcsum_64bit/script              |    4 +--
 tests/j_short_revoke_trans/script                  |    4 +--
 tests/j_short_revoke_trans_mcsum_64bit/script      |    4 +--
 tests/j_short_trans/script                         |    4 +--
 tests/j_short_trans_64bit/script                   |    4 +--
 tests/j_short_trans_mcsum_64bit/script             |    4 +--
 tests/j_short_trans_old_csum/script                |    4 +--
 tests/j_short_trans_open_recover/script            |    6 ++--
 tests/j_short_trans_recover/script                 |    6 ++--
 tests/j_short_trans_recover_mcsum_64bit/script     |    6 ++--
 tests/j_short_uncommitted_trans/script             |    4 +--
 tests/j_short_uncommitted_trans_mcsum_64bit/script |    4 +--
 tests/m_mmp_bad_csum/script                        |    2 +
 tests/m_mmp_bad_magic/script                       |    2 +
 tests/t_mke2fs_errors/script                       |    8 +++--
 45 files changed, 91 insertions(+), 80 deletions(-)


diff --git a/tests/d_xattr_edits/expect b/tests/d_xattr_edits/expect
index 44ce5e4..4db5414 100644
--- a/tests/d_xattr_edits/expect
+++ b/tests/d_xattr_edits/expect
@@ -31,13 +31,13 @@ ea_rm / user.joe
 Exit status is 0
 ea_list /
 Exit status is 0
-ea_set / user.file_based_xattr -f d_xattr_edits.tmp
+ea_set -f d_xattr_edits.tmp / user.file_based_xattr
 Exit status is 0
 ea_list /
 Extended attributes:
   user.file_based_xattr = "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567\012" (108)
 Exit status is 0
-ea_get / user.file_based_xattr -f d_xattr_edits.ver.tmp
+ea_get -f d_xattr_edits.ver.tmp / user.file_based_xattr
 Exit status is 0
 Compare big attribute
 e2fsck -yf -N test_filesys
diff --git a/tests/d_xattr_edits/script b/tests/d_xattr_edits/script
index 1e33716..2e356e8 100644
--- a/tests/d_xattr_edits/script
+++ b/tests/d_xattr_edits/script
@@ -18,86 +18,86 @@ status=$?
 echo Exit status is $status >> $OUT
 
 echo "ea_set / user.joe smith" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_set / user.joe smith" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_set / user.joe smith" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_set / user.moo FEE_FIE_FOE_FUMMMMMM" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_set / user.moo FEE_FIE_FOE_FUMMMMMM" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_set / user.moo FEE_FIE_FOE_FUMMMMMM" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_list /" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_list /" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_list /" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_get / user.moo" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_get / user.moo" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_get / user.moo" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_get / nosuchea" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_get / nosuchea" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_get / nosuchea" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_rm / user.moo" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_rm / user.moo" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_rm / user.moo" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_rm / nosuchea" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_rm / nosuchea" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_rm / nosuchea" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_list /" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_list /" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_list /" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_get / user.moo" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_get / user.moo" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_get / user.moo" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_rm / user.joe" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_rm / user.joe" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_rm / user.joe" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_list /" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_list /" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_list /" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567" > $TEST_DATA
-echo "ea_set / user.file_based_xattr -f $TEST_DATA" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_set / user.file_based_xattr -f $TEST_DATA" >> $OUT.new 2>&1
+echo "ea_set -f $TEST_DATA / user.file_based_xattr" > $OUT.new
+$DEBUGFS -w -R "ea_set -f $TEST_DATA / user.file_based_xattr" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
 echo "ea_list /" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_list /" >> $OUT.new 2>&1
+$DEBUGFS -w -R "ea_list /" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
 
-echo "ea_get / user.file_based_xattr -f $VERIFY_DATA" > $OUT.new
-$DEBUGFS -w $TMPFILE -R "ea_get / user.file_based_xattr -f $VERIFY_DATA" >> $OUT.new 2>&1
+echo "ea_get -f $VERIFY_DATA / user.file_based_xattr" > $OUT.new
+$DEBUGFS -w -R "ea_get -f $VERIFY_DATA / user.file_based_xattr" $TMPFILE >> $OUT.new 2>&1
 status=$?
 echo Exit status is $status >> $OUT.new
 sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
diff --git a/tests/f_detect_junk/script b/tests/f_detect_junk/script
index 3aebcd0..2721c79 100644
--- a/tests/f_detect_junk/script
+++ b/tests/f_detect_junk/script
@@ -26,7 +26,8 @@ $TUNE2FS -i 0 $TMPFILE >> $OUT 2>&1
 echo "*** mke2fs" >> $OUT
 $MKE2FS -n $TMPFILE >> $OUT 2>&1
 
-sed -f $cmd_dir/filter.sed -e "s|$TMPFILE|test.img|g" -i $OUT
+sed -f $cmd_dir/filter.sed -e "s|$TMPFILE|test.img|g" < $OUT > $OUT.new
+mv $OUT.new $OUT
 
 # Figure out what happened
 if cmp -s $EXP $OUT; then
diff --git a/tests/f_detect_xfs/script b/tests/f_detect_xfs/script
index 2531c5e..b32ba85 100644
--- a/tests/f_detect_xfs/script
+++ b/tests/f_detect_xfs/script
@@ -23,7 +23,8 @@ $TUNE2FS -i 0 $TMPFILE >> $OUT 2>&1
 echo "*** mke2fs" >> $OUT
 $MKE2FS -n $TMPFILE >> $OUT 2>&1
 
-sed -f $cmd_dir/filter.sed -e "s|$TMPFILE|test.img|g" -i $OUT
+sed -f $cmd_dir/filter.sed -e "s|$TMPFILE|test.img|g" < $OUT > $OUT.new
+mv $OUT.new $OUT
 
 # Figure out what happened
 if cmp -s $EXP $OUT; then
diff --git a/tests/f_itable_collision/script b/tests/f_itable_collision/script
index 7eedfd3..52b69a2 100755
--- a/tests/f_itable_collision/script
+++ b/tests/f_itable_collision/script
@@ -10,21 +10,20 @@ E2FSCK_TIME=4294967294
 export E2FSCK_TIME
 
 gzip -d < $IMAGE > $TMPFILE
-e2label $TMPFILE test_filesys
 
 # Run fsck to fix things?
 EXP1=$test_dir/expect.1
 OUT1=$test_name.1.log
 rm -rf $test_name.failed $test_name.ok
 
-$FSCK $FSCK_OPT $TMPFILE 2>&1 | tail -n +2 > $OUT1
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE 2>&1 | tail -n +2 > $OUT1
 echo "Exit status is $?" >> $OUT1
 
 # Run a second time
 EXP2=$test_dir/expect.2
 OUT2=$test_name.2.log
 
-$FSCK $FSCK_OPT $TMPFILE 2>&1 | tail -n +2 > $OUT2
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE 2>&1 | tail -n +2 > $OUT2
 echo "Exit status is $?" >> $OUT2
 
 # Figure out what happened
diff --git a/tests/j_corrupt_commit_csum/expect b/tests/j_corrupt_commit_csum/expect
index 5fc82b8..d799772 100644
--- a/tests/j_corrupt_commit_csum/expect
+++ b/tests/j_corrupt_commit_csum/expect
@@ -15,4 +15,4 @@ Pass 5: Checking group summary information
 test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
 Exit status is 0
 debugfs: cat /a
-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaa
\ No newline at end of file
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaadebugfs: 
diff --git a/tests/j_corrupt_commit_csum/script b/tests/j_corrupt_commit_csum/script
index 102feba..9c16975 100644
--- a/tests/j_corrupt_commit_csum/script
+++ b/tests/j_corrupt_commit_csum/script
@@ -27,6 +27,7 @@ sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo "cat /a" > $TMPFILE.cmd
+echo >> $TMPFILE.cmd
 $DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -f $TMPFILE.cmd
 
diff --git a/tests/j_corrupt_commit_tid/expect b/tests/j_corrupt_commit_tid/expect
index dfbb3f5..0a7df89 100644
--- a/tests/j_corrupt_commit_tid/expect
+++ b/tests/j_corrupt_commit_tid/expect
@@ -14,4 +14,4 @@ Pass 5: Checking group summary information
 test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
 Exit status is 0
 debugfs: cat /a
-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaa
\ No newline at end of file
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaadebugfs: 
diff --git a/tests/j_corrupt_commit_tid/script b/tests/j_corrupt_commit_tid/script
index 102feba..9c16975 100644
--- a/tests/j_corrupt_commit_tid/script
+++ b/tests/j_corrupt_commit_tid/script
@@ -27,6 +27,7 @@ sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo "cat /a" > $TMPFILE.cmd
+echo >> $TMPFILE.cmd
 $DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -f $TMPFILE.cmd
 
diff --git a/tests/j_corrupt_descr_csum/expect b/tests/j_corrupt_descr_csum/expect
index 419e775..4e5ec6a 100644
--- a/tests/j_corrupt_descr_csum/expect
+++ b/tests/j_corrupt_descr_csum/expect
@@ -15,4 +15,4 @@ Pass 5: Checking group summary information
 test_filesys: 12/128 files (8.3% non-contiguous), 1093/2048 blocks
 Exit status is 0
 debugfs: cat /a
-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
\ No newline at end of file
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadebugfs: 
diff --git a/tests/j_corrupt_descr_csum/script b/tests/j_corrupt_descr_csum/script
index 102feba..9c16975 100644
--- a/tests/j_corrupt_descr_csum/script
+++ b/tests/j_corrupt_descr_csum/script
@@ -27,6 +27,7 @@ sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo "cat /a" > $TMPFILE.cmd
+echo >> $TMPFILE.cmd
 $DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -f $TMPFILE.cmd
 
diff --git a/tests/j_corrupt_descr_tid/expect b/tests/j_corrupt_descr_tid/expect
index 0444203..00bd2d5 100644
--- a/tests/j_corrupt_descr_tid/expect
+++ b/tests/j_corrupt_descr_tid/expect
@@ -14,4 +14,4 @@ Pass 5: Checking group summary information
 test_filesys: 12/128 files (8.3% non-contiguous), 1093/2048 blocks
 Exit status is 0
 debugfs: cat /a
-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
\ No newline at end of file
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadebugfs: 
diff --git a/tests/j_corrupt_descr_tid/script b/tests/j_corrupt_descr_tid/script
index 102feba..9c16975 100644
--- a/tests/j_corrupt_descr_tid/script
+++ b/tests/j_corrupt_descr_tid/script
@@ -27,6 +27,7 @@ sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo "cat /a" > $TMPFILE.cmd
+echo >> $TMPFILE.cmd
 $DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -f $TMPFILE.cmd
 
diff --git a/tests/j_corrupt_journal_block/expect b/tests/j_corrupt_journal_block/expect
index 443a2b3..bc75707 100644
--- a/tests/j_corrupt_journal_block/expect
+++ b/tests/j_corrupt_journal_block/expect
@@ -16,4 +16,5 @@ Pass 5: Checking group summary information
 test_filesys: 12/128 files (8.3% non-contiguous), 1093/2048 blocks
 Exit status is 0
 debugfs: cat /a
-bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc!
 cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc!
 ccccccccccddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
 ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd!
 dddddddddddddddddddddddddddddddddddddddddddddd
+bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc!
 cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc!
 ccccccccccddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
 ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd!
 dddddddddddddddddddddddddddddddddddddddddddddddebugfs: 
+
diff --git a/tests/j_corrupt_journal_block/script b/tests/j_corrupt_journal_block/script
index c17c70e..2bce973 100644
--- a/tests/j_corrupt_journal_block/script
+++ b/tests/j_corrupt_journal_block/script
@@ -27,6 +27,7 @@ sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo "cat /a" > $TMPFILE.cmd
+echo >> $TMPFILE.cmd
 $DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 echo >> $OUT
 rm -f $TMPFILE.cmd
diff --git a/tests/j_corrupt_revoke_block/expect b/tests/j_corrupt_revoke_block/expect
index 52cda2c..c357f53 100644
--- a/tests/j_corrupt_revoke_block/expect
+++ b/tests/j_corrupt_revoke_block/expect
@@ -14,4 +14,4 @@ Pass 5: Checking group summary information
 test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
 Exit status is 0
 debugfs: cat /a
-bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbb
\ No newline at end of file
+bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbdebugfs: 
diff --git a/tests/j_corrupt_revoke_block/script b/tests/j_corrupt_revoke_block/script
index 102feba..9c16975 100644
--- a/tests/j_corrupt_revoke_block/script
+++ b/tests/j_corrupt_revoke_block/script
@@ -27,6 +27,7 @@ sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo "cat /a" > $TMPFILE.cmd
+echo >> $TMPFILE.cmd
 $DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -f $TMPFILE.cmd
 
diff --git a/tests/j_corrupt_revoke_csum/expect b/tests/j_corrupt_revoke_csum/expect
index 52cda2c..c357f53 100644
--- a/tests/j_corrupt_revoke_csum/expect
+++ b/tests/j_corrupt_revoke_csum/expect
@@ -14,4 +14,4 @@ Pass 5: Checking group summary information
 test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
 Exit status is 0
 debugfs: cat /a
-bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbb
\ No newline at end of file
+bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
 bbbbbbbbbbdebugfs: 
diff --git a/tests/j_corrupt_revoke_csum/script b/tests/j_corrupt_revoke_csum/script
index 102feba..9c16975 100644
--- a/tests/j_corrupt_revoke_csum/script
+++ b/tests/j_corrupt_revoke_csum/script
@@ -27,6 +27,7 @@ sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo "cat /a" > $TMPFILE.cmd
+echo >> $TMPFILE.cmd
 $DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -f $TMPFILE.cmd
 
diff --git a/tests/j_corrupt_sb_csum/expect b/tests/j_corrupt_sb_csum/expect
index 0493500..5c88a09 100644
--- a/tests/j_corrupt_sb_csum/expect
+++ b/tests/j_corrupt_sb_csum/expect
@@ -18,4 +18,4 @@ Pass 5: Checking group summary information
 test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
 Exit status is 0
 debugfs: cat /a
-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaa
\ No newline at end of file
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaadebugfs: 
diff --git a/tests/j_corrupt_sb_csum/script b/tests/j_corrupt_sb_csum/script
index 102feba..9c16975 100644
--- a/tests/j_corrupt_sb_csum/script
+++ b/tests/j_corrupt_sb_csum/script
@@ -27,6 +27,7 @@ sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo "cat /a" > $TMPFILE.cmd
+echo >> $TMPFILE.cmd
 $DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -f $TMPFILE.cmd
 
diff --git a/tests/j_corrupt_sb_magic/expect b/tests/j_corrupt_sb_magic/expect
index a233033..2169a15 100644
--- a/tests/j_corrupt_sb_magic/expect
+++ b/tests/j_corrupt_sb_magic/expect
@@ -39,4 +39,4 @@ Pass 5: Checking group summary information
 test_filesys: 12/128 files (8.3% non-contiguous), 1092/2048 blocks
 Exit status is 0
 debugfs: cat /a
-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaa
\ No newline at end of file
+aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
 aaaaaaaaaadebugfs: 
diff --git a/tests/j_corrupt_sb_magic/script b/tests/j_corrupt_sb_magic/script
index 102feba..9c16975 100644
--- a/tests/j_corrupt_sb_magic/script
+++ b/tests/j_corrupt_sb_magic/script
@@ -27,6 +27,7 @@ sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
 rm -f $OUT.new
 
 echo "cat /a" > $TMPFILE.cmd
+echo >> $TMPFILE.cmd
 $DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -f $TMPFILE.cmd
 
diff --git a/tests/j_ext_long_revoke_trans/script b/tests/j_ext_long_revoke_trans/script
index 4a60850..fe45c72 100644
--- a/tests/j_ext_long_revoke_trans/script
+++ b/tests/j_ext_long_revoke_trans/script
@@ -18,7 +18,7 @@ $MKE2FS -F -o Linux -b 1024 -O journal_dev -T ext4 -U 1db3f677-6832-4adb-bafc-8e
 $MKE2FS -F -o Linux -b 1024 -O ^has_journal -T ext4 $TMPFILE 262144 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
 
 echo "debugfs add journal device/UUID" >> $OUT
-$DEBUGFS -w -f - $TMPFILE <<- EOF >> $OUT.new 2>&1
+$DEBUGFS -w -f - $TMPFILE <<-EOF >> $OUT.new 2>&1
 	feature has_journal
 	ssv journal_dev 0x9999
 	ssv journal_uuid 1db3f677-6832-4adb-bafc-8e4059c30a34
@@ -39,14 +39,14 @@ echo "jc" >> $TMPFILE.cmd
 echo "jo -f $JNLFILE" >> $TMPFILE.cmd
 echo "jw -r 259-4356 /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$JNLFILE" "$JOURNAL_DUMP_DIR/$test_name.img.jnl"
 echo "logdump -c -f $JNLFILE" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed -e 's/logdump -c -f.*/logdump -c/g' >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e 's/logdump -c -f.*/logdump -c/g' >> $OUT
 rm -rf $TMPFILE.cmd
 
 echo "debugfs fsck" >> $OUT
diff --git a/tests/j_ext_long_trans/script b/tests/j_ext_long_trans/script
index c02f791..f71e5a4 100644
--- a/tests/j_ext_long_trans/script
+++ b/tests/j_ext_long_trans/script
@@ -36,14 +36,14 @@ echo "debugfs write journal" >> $OUT
 echo "jo -f $JNLFILE" > $TMPFILE.cmd
 echo "jw -b 259-4356 /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$JNLFILE" "$JOURNAL_DUMP_DIR/$test_name.img.jnl"
 echo "logdump -c -f $JNLFILE" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed -e 's/logdump -c -f.*/logdump -c/g' >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed -e 's/logdump -c -f.*/logdump -c/g' >> $OUT
 rm -rf $TMPFILE.cmd
 
 echo "debugfs fsck" >> $OUT
diff --git a/tests/j_long_revoke_trans/script b/tests/j_long_revoke_trans/script
index 4289c2e..4a0c5d1 100644
--- a/tests/j_long_revoke_trans/script
+++ b/tests/j_long_revoke_trans/script
@@ -26,13 +26,13 @@ echo "jc" >> $TMPFILE.cmd
 echo "jo" >> $TMPFILE.cmd
 echo "jw -r 259-4356" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_long_revoke_trans_mcsum_32bit/script b/tests/j_long_revoke_trans_mcsum_32bit/script
index 4354fe5..fc0d0ad 100644
--- a/tests/j_long_revoke_trans_mcsum_32bit/script
+++ b/tests/j_long_revoke_trans_mcsum_32bit/script
@@ -29,7 +29,7 @@ echo "jo" >> $TMPFILE.cmd
 echo "jw -r 260-4356" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
 #$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd >> $OUT 2>&1
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -37,7 +37,7 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_long_revoke_trans_mcsum_64bit/script b/tests/j_long_revoke_trans_mcsum_64bit/script
index 8133a66..e206f88 100644
--- a/tests/j_long_revoke_trans_mcsum_64bit/script
+++ b/tests/j_long_revoke_trans_mcsum_64bit/script
@@ -29,7 +29,7 @@ echo "jo" >> $TMPFILE.cmd
 echo "jw -r 262-4358" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
 #$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd >> $OUT 2>&1
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -37,7 +37,7 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_long_trans/script b/tests/j_long_trans/script
index 9a4f131..68172c4 100644
--- a/tests/j_long_trans/script
+++ b/tests/j_long_trans/script
@@ -23,13 +23,13 @@ echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
 echo "jw -b 259-4356 /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_long_trans_mcsum_32bit/script b/tests/j_long_trans_mcsum_32bit/script
index 3255001..4722242 100644
--- a/tests/j_long_trans_mcsum_32bit/script
+++ b/tests/j_long_trans_mcsum_32bit/script
@@ -25,7 +25,7 @@ echo "debugfs write journal" >> $OUT
 echo "jo -c" > $TMPFILE.cmd
 echo "jw -b 260-4356 /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -33,7 +33,7 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_long_trans_mcsum_64bit/script b/tests/j_long_trans_mcsum_64bit/script
index 8ded550..65ca1b7 100644
--- a/tests/j_long_trans_mcsum_64bit/script
+++ b/tests/j_long_trans_mcsum_64bit/script
@@ -25,7 +25,7 @@ echo "debugfs write journal" >> $OUT
 echo "jo -c" > $TMPFILE.cmd
 echo "jw -b 262-4358 /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -33,7 +33,7 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_short_revoke_trans/script b/tests/j_short_revoke_trans/script
index edf28f9..94f20b9 100644
--- a/tests/j_short_revoke_trans/script
+++ b/tests/j_short_revoke_trans/script
@@ -28,13 +28,13 @@ echo "jc" >> $TMPFILE.cmd
 echo "jo" >> $TMPFILE.cmd
 echo "jw -r $bitmaps" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_short_revoke_trans_mcsum_64bit/script b/tests/j_short_revoke_trans_mcsum_64bit/script
index 8bd6e08..8358012 100644
--- a/tests/j_short_revoke_trans_mcsum_64bit/script
+++ b/tests/j_short_revoke_trans_mcsum_64bit/script
@@ -30,7 +30,7 @@ echo "jc" >> $TMPFILE.cmd
 echo "jo" >> $TMPFILE.cmd
 echo "jw -r $bitmaps" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -38,7 +38,7 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_short_trans/script b/tests/j_short_trans/script
index 00f4d6e..c83daba 100644
--- a/tests/j_short_trans/script
+++ b/tests/j_short_trans/script
@@ -25,13 +25,13 @@ echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
 echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_short_trans_64bit/script b/tests/j_short_trans_64bit/script
index daf0866..7a60284 100644
--- a/tests/j_short_trans_64bit/script
+++ b/tests/j_short_trans_64bit/script
@@ -27,7 +27,7 @@ echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
 echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -35,7 +35,7 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_short_trans_mcsum_64bit/script b/tests/j_short_trans_mcsum_64bit/script
index 0534941..bc9f09b 100644
--- a/tests/j_short_trans_mcsum_64bit/script
+++ b/tests/j_short_trans_mcsum_64bit/script
@@ -27,7 +27,7 @@ echo "debugfs write journal" >> $OUT
 echo "jo -c" > $TMPFILE.cmd
 echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -35,7 +35,7 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_short_trans_old_csum/script b/tests/j_short_trans_old_csum/script
index b968bc1..52fc58f 100644
--- a/tests/j_short_trans_old_csum/script
+++ b/tests/j_short_trans_old_csum/script
@@ -27,7 +27,7 @@ echo "debugfs write journal" >> $OUT
 echo "jo -c" > $TMPFILE.cmd
 echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -35,7 +35,7 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_short_trans_open_recover/script b/tests/j_short_trans_open_recover/script
index fbbb714..e5b772d 100644
--- a/tests/j_short_trans_open_recover/script
+++ b/tests/j_short_trans_open_recover/script
@@ -25,20 +25,20 @@ echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
 echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 echo "debugfs can't recover open journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
 echo "jr" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd > $OUT.new 2>&1
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE > $OUT.new 2>&1
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
diff --git a/tests/j_short_trans_recover/script b/tests/j_short_trans_recover/script
index 7fa6158..2494a2e 100644
--- a/tests/j_short_trans_recover/script
+++ b/tests/j_short_trans_recover/script
@@ -28,18 +28,18 @@ echo "jc" >> $TMPFILE.cmd
 echo "jo" >> $TMPFILE.cmd
 echo "jw -r 333" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 echo "debugfs recover journal" >> $OUT
 echo "jr" > $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
diff --git a/tests/j_short_trans_recover_mcsum_64bit/script b/tests/j_short_trans_recover_mcsum_64bit/script
index c283fe2..6076e03 100644
--- a/tests/j_short_trans_recover_mcsum_64bit/script
+++ b/tests/j_short_trans_recover_mcsum_64bit/script
@@ -30,7 +30,7 @@ echo "jc" >> $TMPFILE.cmd
 echo "jo" >> $TMPFILE.cmd
 echo "jw -r 333" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -38,12 +38,12 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 echo "debugfs recover journal" >> $OUT
 echo "jr" > $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
diff --git a/tests/j_short_uncommitted_trans/script b/tests/j_short_uncommitted_trans/script
index 207d746..a988948 100644
--- a/tests/j_short_uncommitted_trans/script
+++ b/tests/j_short_uncommitted_trans/script
@@ -25,13 +25,13 @@ echo "debugfs write journal" >> $OUT
 echo "jo" > $TMPFILE.cmd
 echo "jw -b $bitmaps -c /dev/zero" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/j_short_uncommitted_trans_mcsum_64bit/script b/tests/j_short_uncommitted_trans_mcsum_64bit/script
index de506be..43313bb 100644
--- a/tests/j_short_uncommitted_trans_mcsum_64bit/script
+++ b/tests/j_short_uncommitted_trans_mcsum_64bit/script
@@ -27,7 +27,7 @@ echo "debugfs write journal" >> $OUT
 echo "jo -c" > $TMPFILE.cmd
 echo "jw -b $bitmaps /dev/zero -c" >> $TMPFILE.cmd
 echo "jc" >> $TMPFILE.cmd
-$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+$DEBUGFS_EXE -w -f $TMPFILE.cmd $TMPFILE 2>> $OUT.new > /dev/null
 sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
 rm -rf $OUT.new
 
@@ -35,7 +35,7 @@ $DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
 
 test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
 echo "logdump -c" > $TMPFILE.cmd
-$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
 rm -rf $TMPFILE.cmd
 
 $FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
diff --git a/tests/m_mmp_bad_csum/script b/tests/m_mmp_bad_csum/script
index d101294..09e870c 100644
--- a/tests/m_mmp_bad_csum/script
+++ b/tests/m_mmp_bad_csum/script
@@ -10,7 +10,7 @@ if [ $? = 0 ]; then
 fi
 gzip -dc < $test_dir/image.gz > $TMPFILE
 
-OUT=$test_dir.log
+OUT=$test_name.log
 EXP=$test_dir/expect
 $FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
 echo Exit status is $? >> $OUT
diff --git a/tests/m_mmp_bad_magic/script b/tests/m_mmp_bad_magic/script
index d101294..09e870c 100644
--- a/tests/m_mmp_bad_magic/script
+++ b/tests/m_mmp_bad_magic/script
@@ -10,7 +10,7 @@ if [ $? = 0 ]; then
 fi
 gzip -dc < $test_dir/image.gz > $TMPFILE
 
-OUT=$test_dir.log
+OUT=$test_name.log
 EXP=$test_dir/expect
 $FSCK -fy $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $OUT
 echo Exit status is $? >> $OUT
diff --git a/tests/t_mke2fs_errors/script b/tests/t_mke2fs_errors/script
index d09e926..a5c553b 100755
--- a/tests/t_mke2fs_errors/script
+++ b/tests/t_mke2fs_errors/script
@@ -77,23 +77,23 @@ $DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
 # Test errors= in a fs type
 echo "error fs_types profile continue" >> $OUT
 write_section_conf continue
-MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE -T test_suite > /dev/null 2>&1
+MKE2FS_CONFIG=$conf $MKE2FS -T test_suite -F $TMPFILE > /dev/null 2>&1
 $DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
 
 echo "error fs_types profile panic" >> $OUT
 write_section_conf panic
-MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE -T test_suite > /dev/null 2>&1
+MKE2FS_CONFIG=$conf $MKE2FS -T test_suite -F $TMPFILE > /dev/null 2>&1
 $DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
 
 echo "error fs_types profile remount-ro" >> $OUT
 write_section_conf remount-ro
-MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE -T test_suite > /dev/null 2>&1
+MKE2FS_CONFIG=$conf $MKE2FS -T test_suite -F $TMPFILE > /dev/null 2>&1
 $DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
 
 # Test command line override
 echo "error fs_types profile remount-ro" >> $OUT
 write_section_conf remount-ro
-MKE2FS_CONFIG=$conf $MKE2FS -F $TMPFILE -T test_suite -e panic > /dev/null 2>&1
+MKE2FS_CONFIG=$conf $MKE2FS -T test_suite -e panic -F $TMPFILE > /dev/null 2>&1
 $DUMPE2FS $TMPFILE 2>&1 | grep 'Errors behavior' >> $OUT
 
 cmp -s $OUT $EXP

