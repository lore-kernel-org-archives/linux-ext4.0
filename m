From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/25] tests: test recovery from an external journal
Date: Mon, 08 Sep 2014 16:14:01 -0700
Message-ID: <20140908231401.25904.74802.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39563 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbaIHXOG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:14:06 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a couple of tests to verify that writing to and recovering from
an external journal work properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/j_ext_long_revoke_trans/expect |   91 ++++++++++++++++++++++++++++++
 tests/j_ext_long_revoke_trans/name   |    1 
 tests/j_ext_long_revoke_trans/script |   77 +++++++++++++++++++++++++
 tests/j_ext_long_trans/expect        |  104 ++++++++++++++++++++++++++++++++++
 tests/j_ext_long_trans/name          |    1 
 tests/j_ext_long_trans/script        |   74 ++++++++++++++++++++++++
 6 files changed, 348 insertions(+)
 create mode 100644 tests/j_ext_long_revoke_trans/expect
 create mode 100644 tests/j_ext_long_revoke_trans/name
 create mode 100644 tests/j_ext_long_revoke_trans/script
 create mode 100644 tests/j_ext_long_trans/expect
 create mode 100644 tests/j_ext_long_trans/name
 create mode 100644 tests/j_ext_long_trans/script


diff --git a/tests/j_ext_long_revoke_trans/expect b/tests/j_ext_long_revoke_trans/expect
new file mode 100644
index 0000000..ed19872
--- /dev/null
+++ b/tests/j_ext_long_revoke_trans/expect
@@ -0,0 +1,91 @@
+Creating filesystem with 262144 1k blocks and 0 inodes
+Superblock backups stored on blocks: 
+
+Zeroing journal device:              
+Creating filesystem with 262144 1k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Writing superblocks and filesystem accounting information:      done
+
+debugfs add journal device/UUID
+debugfs: feature has_journal
+Filesystem features: has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super huge_file uninit_bg dir_nlink extra_isize
+debugfs: ssv journal_dev 0x9999
+debugfs: ssv journal_uuid 1db3f677-6832-4adb-bafc-8e4059c30a34
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 6239/262144 blocks
+Exit status is 0
+debugfs write journal
+debugfs: logdump -c
+Ext2 superblock header found.
+Journal starts at block 3, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 3
+Found expected sequence 1, type 1 (descriptor block) at block 128
+Found expected sequence 1, type 1 (descriptor block) at block 253
+Found expected sequence 1, type 1 (descriptor block) at block 378
+Found expected sequence 1, type 1 (descriptor block) at block 503
+Found expected sequence 1, type 1 (descriptor block) at block 628
+Found expected sequence 1, type 1 (descriptor block) at block 753
+Found expected sequence 1, type 1 (descriptor block) at block 878
+Found expected sequence 1, type 1 (descriptor block) at block 1003
+Found expected sequence 1, type 1 (descriptor block) at block 1128
+Found expected sequence 1, type 1 (descriptor block) at block 1253
+Found expected sequence 1, type 1 (descriptor block) at block 1378
+Found expected sequence 1, type 1 (descriptor block) at block 1503
+Found expected sequence 1, type 1 (descriptor block) at block 1628
+Found expected sequence 1, type 1 (descriptor block) at block 1753
+Found expected sequence 1, type 1 (descriptor block) at block 1878
+Found expected sequence 1, type 1 (descriptor block) at block 2003
+Found expected sequence 1, type 1 (descriptor block) at block 2128
+Found expected sequence 1, type 1 (descriptor block) at block 2253
+Found expected sequence 1, type 1 (descriptor block) at block 2378
+Found expected sequence 1, type 1 (descriptor block) at block 2503
+Found expected sequence 1, type 1 (descriptor block) at block 2628
+Found expected sequence 1, type 1 (descriptor block) at block 2753
+Found expected sequence 1, type 1 (descriptor block) at block 2878
+Found expected sequence 1, type 1 (descriptor block) at block 3003
+Found expected sequence 1, type 1 (descriptor block) at block 3128
+Found expected sequence 1, type 1 (descriptor block) at block 3253
+Found expected sequence 1, type 1 (descriptor block) at block 3378
+Found expected sequence 1, type 1 (descriptor block) at block 3503
+Found expected sequence 1, type 1 (descriptor block) at block 3628
+Found expected sequence 1, type 1 (descriptor block) at block 3753
+Found expected sequence 1, type 1 (descriptor block) at block 3878
+Found expected sequence 1, type 1 (descriptor block) at block 4003
+Found expected sequence 1, type 1 (descriptor block) at block 4128
+Found expected sequence 1, type 2 (commit block) at block 4135
+Found expected sequence 2, type 5 (revoke table) at block 4136
+Found expected sequence 2, type 5 (revoke table) at block 4137
+Found expected sequence 2, type 5 (revoke table) at block 4138
+Found expected sequence 2, type 5 (revoke table) at block 4139
+Found expected sequence 2, type 5 (revoke table) at block 4140
+Found expected sequence 2, type 5 (revoke table) at block 4141
+Found expected sequence 2, type 5 (revoke table) at block 4142
+Found expected sequence 2, type 5 (revoke table) at block 4143
+Found expected sequence 2, type 5 (revoke table) at block 4144
+Found expected sequence 2, type 5 (revoke table) at block 4145
+Found expected sequence 2, type 5 (revoke table) at block 4146
+Found expected sequence 2, type 5 (revoke table) at block 4147
+Found expected sequence 2, type 5 (revoke table) at block 4148
+Found expected sequence 2, type 5 (revoke table) at block 4149
+Found expected sequence 2, type 5 (revoke table) at block 4150
+Found expected sequence 2, type 5 (revoke table) at block 4151
+Found expected sequence 2, type 5 (revoke table) at block 4152
+Found expected sequence 2, type 2 (commit block) at block 4153
+No magic number at block 4154: end of journal.
+debugfs fsck
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 6239/262144 blocks
+Exit status is 0
diff --git a/tests/j_ext_long_revoke_trans/name b/tests/j_ext_long_revoke_trans/name
new file mode 100644
index 0000000..777010d
--- /dev/null
+++ b/tests/j_ext_long_revoke_trans/name
@@ -0,0 +1 @@
+revoked transaction nuking free space w/ ext. journal
diff --git a/tests/j_ext_long_revoke_trans/script b/tests/j_ext_long_revoke_trans/script
new file mode 100644
index 0000000..4a60850
--- /dev/null
+++ b/tests/j_ext_long_revoke_trans/script
@@ -0,0 +1,77 @@
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
+JNLFILE=$TMPFILE.jnl
+
+touch $JNLFILE
+$MKE2FS -F -o Linux -b 1024 -O journal_dev -T ext4 -U 1db3f677-6832-4adb-bafc-8e4059c30a34 $JNLFILE 262144 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+$MKE2FS -F -o Linux -b 1024 -O ^has_journal -T ext4 $TMPFILE 262144 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+echo "debugfs add journal device/UUID" >> $OUT
+$DEBUGFS -w -f - $TMPFILE <<- EOF >> $OUT.new 2>&1
+	feature has_journal
+	ssv journal_dev 0x9999
+	ssv journal_uuid 1db3f677-6832-4adb-bafc-8e4059c30a34
+EOF
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+$FSCK -fy -N test_filesys -j $JNLFILE $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write journal" >> $OUT
+echo "jo -f $JNLFILE" > $TMPFILE.cmd
+echo "jw -b 259-4356 /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+echo "jo -f $JNLFILE" >> $TMPFILE.cmd
+echo "jw -r 259-4356 /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
+
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$JNLFILE" "$JOURNAL_DUMP_DIR/$test_name.img.jnl"
+echo "logdump -c -f $JNLFILE" > $TMPFILE.cmd
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed -e 's/logdump -c -f.*/logdump -c/g' >> $OUT
+rm -rf $TMPFILE.cmd
+
+echo "debugfs fsck" >> $OUT
+$FSCK -fy -N test_filesys -j $JNLFILE $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE $JNLFILE
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
+unset IMAGE FSCK_OPT OUT EXP JNLFILE
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
diff --git a/tests/j_ext_long_trans/expect b/tests/j_ext_long_trans/expect
new file mode 100644
index 0000000..d379610
--- /dev/null
+++ b/tests/j_ext_long_trans/expect
@@ -0,0 +1,104 @@
+Creating filesystem with 262144 1k blocks and 0 inodes
+Superblock backups stored on blocks: 
+
+Zeroing journal device:              
+Creating filesystem with 262144 1k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Writing superblocks and filesystem accounting information:      done
+
+debugfs add journal device/UUID
+debugfs: feature has_journal
+Filesystem features: has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super huge_file uninit_bg dir_nlink extra_isize
+debugfs: ssv journal_dev 0x9999
+debugfs: ssv journal_uuid 1db3f677-6832-4adb-bafc-8e4059c30a34
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 6239/262144 blocks
+Exit status is 0
+debugfs write journal
+debugfs: logdump -c
+Ext2 superblock header found.
+Journal starts at block 3, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 3
+Found expected sequence 1, type 1 (descriptor block) at block 128
+Found expected sequence 1, type 1 (descriptor block) at block 253
+Found expected sequence 1, type 1 (descriptor block) at block 378
+Found expected sequence 1, type 1 (descriptor block) at block 503
+Found expected sequence 1, type 1 (descriptor block) at block 628
+Found expected sequence 1, type 1 (descriptor block) at block 753
+Found expected sequence 1, type 1 (descriptor block) at block 878
+Found expected sequence 1, type 1 (descriptor block) at block 1003
+Found expected sequence 1, type 1 (descriptor block) at block 1128
+Found expected sequence 1, type 1 (descriptor block) at block 1253
+Found expected sequence 1, type 1 (descriptor block) at block 1378
+Found expected sequence 1, type 1 (descriptor block) at block 1503
+Found expected sequence 1, type 1 (descriptor block) at block 1628
+Found expected sequence 1, type 1 (descriptor block) at block 1753
+Found expected sequence 1, type 1 (descriptor block) at block 1878
+Found expected sequence 1, type 1 (descriptor block) at block 2003
+Found expected sequence 1, type 1 (descriptor block) at block 2128
+Found expected sequence 1, type 1 (descriptor block) at block 2253
+Found expected sequence 1, type 1 (descriptor block) at block 2378
+Found expected sequence 1, type 1 (descriptor block) at block 2503
+Found expected sequence 1, type 1 (descriptor block) at block 2628
+Found expected sequence 1, type 1 (descriptor block) at block 2753
+Found expected sequence 1, type 1 (descriptor block) at block 2878
+Found expected sequence 1, type 1 (descriptor block) at block 3003
+Found expected sequence 1, type 1 (descriptor block) at block 3128
+Found expected sequence 1, type 1 (descriptor block) at block 3253
+Found expected sequence 1, type 1 (descriptor block) at block 3378
+Found expected sequence 1, type 1 (descriptor block) at block 3503
+Found expected sequence 1, type 1 (descriptor block) at block 3628
+Found expected sequence 1, type 1 (descriptor block) at block 3753
+Found expected sequence 1, type 1 (descriptor block) at block 3878
+Found expected sequence 1, type 1 (descriptor block) at block 4003
+Found expected sequence 1, type 1 (descriptor block) at block 4128
+Found expected sequence 1, type 2 (commit block) at block 4135
+No magic number at block 4136: end of journal.
+debugfs fsck
+test_filesys: recovering journal
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
+Block bitmap differences:  +(1--259) +275 +(291--418) +2341
+Fix? yes
+
+Free blocks count wrong for group #0 (5838, counted=5851).
+Fix? yes
+
+Free blocks count wrong (255903, counted=255916).
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
+Free inodes count wrong (16372, counted=16373).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16384 files (0.0% non-contiguous), 6228/262144 blocks
+Exit status is 1
diff --git a/tests/j_ext_long_trans/name b/tests/j_ext_long_trans/name
new file mode 100644
index 0000000..8ae5722
--- /dev/null
+++ b/tests/j_ext_long_trans/name
@@ -0,0 +1 @@
+transaction nuking free space w/ ext. journal
diff --git a/tests/j_ext_long_trans/script b/tests/j_ext_long_trans/script
new file mode 100644
index 0000000..c02f791
--- /dev/null
+++ b/tests/j_ext_long_trans/script
@@ -0,0 +1,74 @@
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
+JNLFILE=$TMPFILE.jnl
+
+touch $JNLFILE
+$MKE2FS -F -o Linux -b 1024 -O journal_dev -T ext4 -U 1db3f677-6832-4adb-bafc-8e4059c30a34 $JNLFILE 262144 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+$MKE2FS -F -o Linux -b 1024 -O ^has_journal -T ext4 $TMPFILE 262144 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+echo "debugfs add journal device/UUID" >> $OUT
+$DEBUGFS -w -f - $TMPFILE <<- EOF >> $OUT.new 2>&1
+	feature has_journal
+	ssv journal_dev 0x9999
+	ssv journal_uuid 1db3f677-6832-4adb-bafc-8e4059c30a34
+EOF
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+$FSCK -fy -N test_filesys -j $JNLFILE $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write journal" >> $OUT
+echo "jo -f $JNLFILE" > $TMPFILE.cmd
+echo "jw -b 259-4356 /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
+
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$JNLFILE" "$JOURNAL_DUMP_DIR/$test_name.img.jnl"
+echo "logdump -c -f $JNLFILE" > $TMPFILE.cmd
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed -e 's/logdump -c -f.*/logdump -c/g' >> $OUT
+rm -rf $TMPFILE.cmd
+
+echo "debugfs fsck" >> $OUT
+$FSCK -fy -N test_filesys -j $JNLFILE $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE $JNLFILE
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
+unset IMAGE FSCK_OPT OUT EXP JNLFILE
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi

