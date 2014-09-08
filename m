From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/25] tests: test writing and recovering 32bit csum_v3
 journals
Date: Mon, 08 Sep 2014 16:13:14 -0700
Message-ID: <20140908231314.25904.45059.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39329 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaIHXNV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:13:21 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Simple tests for the 32bit journal transaction creation code when
journal and metadata_csum are enabled.  We test the following:

(a) writing and replaying transactions with multiple
    descriptor blocks
(b) same, but with multiple revoke blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/j_long_revoke_trans_mcsum_32bit/expect |  117 +++++++++++++++++++++
 tests/j_long_revoke_trans_mcsum_32bit/name   |    1 
 tests/j_long_revoke_trans_mcsum_32bit/script |   67 ++++++++++++
 tests/j_long_trans_mcsum_32bit/expect        |  146 ++++++++++++++++++++++++++
 tests/j_long_trans_mcsum_32bit/name          |    1 
 tests/j_long_trans_mcsum_32bit/script        |   63 +++++++++++
 6 files changed, 395 insertions(+)
 create mode 100644 tests/j_long_revoke_trans_mcsum_32bit/expect
 create mode 100644 tests/j_long_revoke_trans_mcsum_32bit/name
 create mode 100644 tests/j_long_revoke_trans_mcsum_32bit/script
 create mode 100644 tests/j_long_trans_mcsum_32bit/expect
 create mode 100644 tests/j_long_trans_mcsum_32bit/name
 create mode 100644 tests/j_long_trans_mcsum_32bit/script


diff --git a/tests/j_long_revoke_trans_mcsum_32bit/expect b/tests/j_long_revoke_trans_mcsum_32bit/expect
new file mode 100644
index 0000000..664a301
--- /dev/null
+++ b/tests/j_long_revoke_trans_mcsum_32bit/expect
@@ -0,0 +1,117 @@
+64-bit filesystem support is not enabled.  The larger fields afforded by this feature enable full-strength checksumming.  Pass -O 64bit to rectify.
+Creating filesystem with 524288 1k blocks and 32768 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32768 files (0.0% non-contiguous), 27050/524288 blocks
+Exit status is 0
+Journal features:         (none)
+debugfs write journal
+Journal features:         journal_incompat_revoke journal_checksum_v3
+debugfs: logdump -c
+Journal starts at block 1, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 1
+Found expected sequence 1, type 1 (descriptor block) at block 64
+Found expected sequence 1, type 1 (descriptor block) at block 127
+Found expected sequence 1, type 1 (descriptor block) at block 190
+Found expected sequence 1, type 1 (descriptor block) at block 253
+Found expected sequence 1, type 1 (descriptor block) at block 316
+Found expected sequence 1, type 1 (descriptor block) at block 379
+Found expected sequence 1, type 1 (descriptor block) at block 442
+Found expected sequence 1, type 1 (descriptor block) at block 505
+Found expected sequence 1, type 1 (descriptor block) at block 568
+Found expected sequence 1, type 1 (descriptor block) at block 631
+Found expected sequence 1, type 1 (descriptor block) at block 694
+Found expected sequence 1, type 1 (descriptor block) at block 757
+Found expected sequence 1, type 1 (descriptor block) at block 820
+Found expected sequence 1, type 1 (descriptor block) at block 883
+Found expected sequence 1, type 1 (descriptor block) at block 946
+Found expected sequence 1, type 1 (descriptor block) at block 1009
+Found expected sequence 1, type 1 (descriptor block) at block 1072
+Found expected sequence 1, type 1 (descriptor block) at block 1135
+Found expected sequence 1, type 1 (descriptor block) at block 1198
+Found expected sequence 1, type 1 (descriptor block) at block 1261
+Found expected sequence 1, type 1 (descriptor block) at block 1324
+Found expected sequence 1, type 1 (descriptor block) at block 1387
+Found expected sequence 1, type 1 (descriptor block) at block 1450
+Found expected sequence 1, type 1 (descriptor block) at block 1513
+Found expected sequence 1, type 1 (descriptor block) at block 1576
+Found expected sequence 1, type 1 (descriptor block) at block 1639
+Found expected sequence 1, type 1 (descriptor block) at block 1702
+Found expected sequence 1, type 1 (descriptor block) at block 1765
+Found expected sequence 1, type 1 (descriptor block) at block 1828
+Found expected sequence 1, type 1 (descriptor block) at block 1891
+Found expected sequence 1, type 1 (descriptor block) at block 1954
+Found expected sequence 1, type 1 (descriptor block) at block 2017
+Found expected sequence 1, type 1 (descriptor block) at block 2080
+Found expected sequence 1, type 1 (descriptor block) at block 2143
+Found expected sequence 1, type 1 (descriptor block) at block 2206
+Found expected sequence 1, type 1 (descriptor block) at block 2269
+Found expected sequence 1, type 1 (descriptor block) at block 2332
+Found expected sequence 1, type 1 (descriptor block) at block 2395
+Found expected sequence 1, type 1 (descriptor block) at block 2458
+Found expected sequence 1, type 1 (descriptor block) at block 2521
+Found expected sequence 1, type 1 (descriptor block) at block 2584
+Found expected sequence 1, type 1 (descriptor block) at block 2647
+Found expected sequence 1, type 1 (descriptor block) at block 2710
+Found expected sequence 1, type 1 (descriptor block) at block 2773
+Found expected sequence 1, type 1 (descriptor block) at block 2836
+Found expected sequence 1, type 1 (descriptor block) at block 2899
+Found expected sequence 1, type 1 (descriptor block) at block 2962
+Found expected sequence 1, type 1 (descriptor block) at block 3025
+Found expected sequence 1, type 1 (descriptor block) at block 3088
+Found expected sequence 1, type 1 (descriptor block) at block 3151
+Found expected sequence 1, type 1 (descriptor block) at block 3214
+Found expected sequence 1, type 1 (descriptor block) at block 3277
+Found expected sequence 1, type 1 (descriptor block) at block 3340
+Found expected sequence 1, type 1 (descriptor block) at block 3403
+Found expected sequence 1, type 1 (descriptor block) at block 3466
+Found expected sequence 1, type 1 (descriptor block) at block 3529
+Found expected sequence 1, type 1 (descriptor block) at block 3592
+Found expected sequence 1, type 1 (descriptor block) at block 3655
+Found expected sequence 1, type 1 (descriptor block) at block 3718
+Found expected sequence 1, type 1 (descriptor block) at block 3781
+Found expected sequence 1, type 1 (descriptor block) at block 3844
+Found expected sequence 1, type 1 (descriptor block) at block 3907
+Found expected sequence 1, type 1 (descriptor block) at block 3970
+Found expected sequence 1, type 1 (descriptor block) at block 4033
+Found expected sequence 1, type 1 (descriptor block) at block 4096
+Found expected sequence 1, type 1 (descriptor block) at block 4159
+Found expected sequence 1, type 2 (commit block) at block 4165
+Found expected sequence 2, type 5 (revoke table) at block 4166
+Found expected sequence 2, type 5 (revoke table) at block 4167
+Found expected sequence 2, type 5 (revoke table) at block 4168
+Found expected sequence 2, type 5 (revoke table) at block 4169
+Found expected sequence 2, type 5 (revoke table) at block 4170
+Found expected sequence 2, type 5 (revoke table) at block 4171
+Found expected sequence 2, type 5 (revoke table) at block 4172
+Found expected sequence 2, type 5 (revoke table) at block 4173
+Found expected sequence 2, type 5 (revoke table) at block 4174
+Found expected sequence 2, type 5 (revoke table) at block 4175
+Found expected sequence 2, type 5 (revoke table) at block 4176
+Found expected sequence 2, type 5 (revoke table) at block 4177
+Found expected sequence 2, type 5 (revoke table) at block 4178
+Found expected sequence 2, type 5 (revoke table) at block 4179
+Found expected sequence 2, type 5 (revoke table) at block 4180
+Found expected sequence 2, type 5 (revoke table) at block 4181
+Found expected sequence 2, type 5 (revoke table) at block 4182
+Found expected sequence 2, type 2 (commit block) at block 4183
+No magic number at block 4184: end of journal.
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32768 files (0.0% non-contiguous), 27050/524288 blocks
+Exit status is 0
diff --git a/tests/j_long_revoke_trans_mcsum_32bit/name b/tests/j_long_revoke_trans_mcsum_32bit/name
new file mode 100644
index 0000000..3d78c07
--- /dev/null
+++ b/tests/j_long_revoke_trans_mcsum_32bit/name
@@ -0,0 +1 @@
+revoked transaction nuking free space on 32bit,metadata_csum
diff --git a/tests/j_long_revoke_trans_mcsum_32bit/script b/tests/j_long_revoke_trans_mcsum_32bit/script
new file mode 100644
index 0000000..4354fe5
--- /dev/null
+++ b/tests/j_long_revoke_trans_mcsum_32bit/script
@@ -0,0 +1,67 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+$MKE2FS -F -o Linux -b 1024 -O ^64bit,has_journal,metadata_csum -T ext4 $TMPFILE 524288 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+$DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
+
+echo "debugfs write journal" >> $OUT
+echo "jo -c" > $TMPFILE.cmd
+echo "jw -b 260-4356 /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+echo "jo" >> $TMPFILE.cmd
+echo "jw -r 260-4356" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+#$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd >> $OUT 2>&1
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
+
+$DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
+
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
+echo "logdump -c" > $TMPFILE.cmd
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+rm -rf $TMPFILE.cmd
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
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
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/j_long_trans_mcsum_32bit/expect b/tests/j_long_trans_mcsum_32bit/expect
new file mode 100644
index 0000000..0d141c1
--- /dev/null
+++ b/tests/j_long_trans_mcsum_32bit/expect
@@ -0,0 +1,146 @@
+64-bit filesystem support is not enabled.  The larger fields afforded by this feature enable full-strength checksumming.  Pass -O 64bit to rectify.
+Creating filesystem with 524288 1k blocks and 32768 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32768 files (0.0% non-contiguous), 27050/524288 blocks
+Exit status is 0
+Journal features:         (none)
+debugfs write journal
+Journal features:         journal_checksum_v3
+debugfs: logdump -c
+Journal starts at block 1, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 1
+Found expected sequence 1, type 1 (descriptor block) at block 64
+Found expected sequence 1, type 1 (descriptor block) at block 127
+Found expected sequence 1, type 1 (descriptor block) at block 190
+Found expected sequence 1, type 1 (descriptor block) at block 253
+Found expected sequence 1, type 1 (descriptor block) at block 316
+Found expected sequence 1, type 1 (descriptor block) at block 379
+Found expected sequence 1, type 1 (descriptor block) at block 442
+Found expected sequence 1, type 1 (descriptor block) at block 505
+Found expected sequence 1, type 1 (descriptor block) at block 568
+Found expected sequence 1, type 1 (descriptor block) at block 631
+Found expected sequence 1, type 1 (descriptor block) at block 694
+Found expected sequence 1, type 1 (descriptor block) at block 757
+Found expected sequence 1, type 1 (descriptor block) at block 820
+Found expected sequence 1, type 1 (descriptor block) at block 883
+Found expected sequence 1, type 1 (descriptor block) at block 946
+Found expected sequence 1, type 1 (descriptor block) at block 1009
+Found expected sequence 1, type 1 (descriptor block) at block 1072
+Found expected sequence 1, type 1 (descriptor block) at block 1135
+Found expected sequence 1, type 1 (descriptor block) at block 1198
+Found expected sequence 1, type 1 (descriptor block) at block 1261
+Found expected sequence 1, type 1 (descriptor block) at block 1324
+Found expected sequence 1, type 1 (descriptor block) at block 1387
+Found expected sequence 1, type 1 (descriptor block) at block 1450
+Found expected sequence 1, type 1 (descriptor block) at block 1513
+Found expected sequence 1, type 1 (descriptor block) at block 1576
+Found expected sequence 1, type 1 (descriptor block) at block 1639
+Found expected sequence 1, type 1 (descriptor block) at block 1702
+Found expected sequence 1, type 1 (descriptor block) at block 1765
+Found expected sequence 1, type 1 (descriptor block) at block 1828
+Found expected sequence 1, type 1 (descriptor block) at block 1891
+Found expected sequence 1, type 1 (descriptor block) at block 1954
+Found expected sequence 1, type 1 (descriptor block) at block 2017
+Found expected sequence 1, type 1 (descriptor block) at block 2080
+Found expected sequence 1, type 1 (descriptor block) at block 2143
+Found expected sequence 1, type 1 (descriptor block) at block 2206
+Found expected sequence 1, type 1 (descriptor block) at block 2269
+Found expected sequence 1, type 1 (descriptor block) at block 2332
+Found expected sequence 1, type 1 (descriptor block) at block 2395
+Found expected sequence 1, type 1 (descriptor block) at block 2458
+Found expected sequence 1, type 1 (descriptor block) at block 2521
+Found expected sequence 1, type 1 (descriptor block) at block 2584
+Found expected sequence 1, type 1 (descriptor block) at block 2647
+Found expected sequence 1, type 1 (descriptor block) at block 2710
+Found expected sequence 1, type 1 (descriptor block) at block 2773
+Found expected sequence 1, type 1 (descriptor block) at block 2836
+Found expected sequence 1, type 1 (descriptor block) at block 2899
+Found expected sequence 1, type 1 (descriptor block) at block 2962
+Found expected sequence 1, type 1 (descriptor block) at block 3025
+Found expected sequence 1, type 1 (descriptor block) at block 3088
+Found expected sequence 1, type 1 (descriptor block) at block 3151
+Found expected sequence 1, type 1 (descriptor block) at block 3214
+Found expected sequence 1, type 1 (descriptor block) at block 3277
+Found expected sequence 1, type 1 (descriptor block) at block 3340
+Found expected sequence 1, type 1 (descriptor block) at block 3403
+Found expected sequence 1, type 1 (descriptor block) at block 3466
+Found expected sequence 1, type 1 (descriptor block) at block 3529
+Found expected sequence 1, type 1 (descriptor block) at block 3592
+Found expected sequence 1, type 1 (descriptor block) at block 3655
+Found expected sequence 1, type 1 (descriptor block) at block 3718
+Found expected sequence 1, type 1 (descriptor block) at block 3781
+Found expected sequence 1, type 1 (descriptor block) at block 3844
+Found expected sequence 1, type 1 (descriptor block) at block 3907
+Found expected sequence 1, type 1 (descriptor block) at block 3970
+Found expected sequence 1, type 1 (descriptor block) at block 4033
+Found expected sequence 1, type 1 (descriptor block) at block 4096
+Found expected sequence 1, type 1 (descriptor block) at block 4159
+Found expected sequence 1, type 2 (commit block) at block 4165
+No magic number at block 4166: end of journal.
+test_filesys: recovering journal
+Superblock has an invalid journal (inode 8).
+Clear? yes
+
+*** ext3 journal has been deleted - filesystem is now ext2 only ***
+
+Resize inode not valid.  Recreate? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Root inode is not a directory.  Clear? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Root inode not allocated.  Allocate? yes
+
+/lost+found not found.  Create? yes
+
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(1--260) +276 +(292--419) +2342 -(139265--155648)
+Fix? yes
+
+Free blocks count wrong for group #0 (5837, counted=5850).
+Fix? yes
+
+Free blocks count wrong for group #17 (0, counted=8192).
+Fix? yes
+
+Free blocks count wrong for group #18 (0, counted=8192).
+Fix? yes
+
+Free blocks count wrong (497236, counted=513633).
+Fix? yes
+
+Inode bitmap differences:  +1 +(3--10)
+Fix? yes
+
+Free inodes count wrong for group #0 (500, counted=501).
+Fix? yes
+
+Directories count wrong for group #0 (3, counted=2).
+Fix? yes
+
+Free inodes count wrong (32756, counted=32757).
+Fix? yes
+
+Recreate journal? yes
+
+Creating journal (16384 blocks):  Done.
+
+*** journal has been re-created - filesystem is now ext3 again ***
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/32768 files (0.0% non-contiguous), 27039/524288 blocks
+Exit status is 1
diff --git a/tests/j_long_trans_mcsum_32bit/name b/tests/j_long_trans_mcsum_32bit/name
new file mode 100644
index 0000000..ac43f51
--- /dev/null
+++ b/tests/j_long_trans_mcsum_32bit/name
@@ -0,0 +1 @@
+transaction nuking free space on 32bit,metadata_csum
diff --git a/tests/j_long_trans_mcsum_32bit/script b/tests/j_long_trans_mcsum_32bit/script
new file mode 100644
index 0000000..3255001
--- /dev/null
+++ b/tests/j_long_trans_mcsum_32bit/script
@@ -0,0 +1,63 @@
+if test -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+$MKE2FS -F -o Linux -b 1024 -O ^64bit,has_journal,metadata_csum -T ext4 $TMPFILE 524288 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+$DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
+
+echo "debugfs write journal" >> $OUT
+echo "jo -c" > $TMPFILE.cmd
+echo "jw -b 260-4356 /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
+
+$DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
+
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
+echo "logdump -c" > $TMPFILE.cmd
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+rm -rf $TMPFILE.cmd
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
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
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

