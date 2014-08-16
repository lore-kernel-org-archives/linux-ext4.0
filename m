From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/27] tests: test writing and recovering checksum-free
 32/64bit journals
Date: Sat, 16 Aug 2014 16:47:31 -0700
Message-ID: <20140816234731.11171.59257.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24101 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaHPXrg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:47:36 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Simple tests for the journal transaction creation code.   We test
writing (bad) block bitmaps out through the journal and replaying them
via fsck, with a few twists:

(a) All bitmaps are committed (fs errors reported)
(b) All the bitmap blocks are revoked (no errors)
(c) The transaction is never committed (no errors)
(d) Same as (a), but debugfs gets to do the replay.

We also test:

(a) writing and replaying transactions with multiple
    descriptor blocks
(b) same, but with multiple revoke blocks.
(c) adding the 64bit flag to a journal

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/defaults/j_script                 |    1 
 tests/j_long_revoke_trans/expect        |   81 +++++++++++++++++++++++
 tests/j_long_revoke_trans/name          |    1 
 tests/j_long_revoke_trans/script        |   62 ++++++++++++++++++
 tests/j_long_trans/expect               |  107 +++++++++++++++++++++++++++++++
 tests/j_long_trans/name                 |    1 
 tests/j_long_trans/script               |   59 +++++++++++++++++
 tests/j_short_revoke_trans/expect       |   32 +++++++++
 tests/j_short_revoke_trans/name         |    1 
 tests/j_short_revoke_trans/script       |   64 +++++++++++++++++++
 tests/j_short_trans/expect              |   38 +++++++++++
 tests/j_short_trans/name                |    1 
 tests/j_short_trans/script              |   61 ++++++++++++++++++
 tests/j_short_trans_64bit/expect        |   40 ++++++++++++
 tests/j_short_trans_64bit/name          |    1 
 tests/j_short_trans_64bit/script        |   65 +++++++++++++++++++
 tests/j_short_trans_open_recover/expect |   43 ++++++++++++
 tests/j_short_trans_open_recover/name   |    1 
 tests/j_short_trans_open_recover/script |   69 ++++++++++++++++++++
 tests/j_short_trans_recover/expect      |   40 ++++++++++++
 tests/j_short_trans_recover/name        |    1 
 tests/j_short_trans_recover/script      |   70 ++++++++++++++++++++
 tests/j_short_uncommitted_trans/expect  |   26 ++++++++
 tests/j_short_uncommitted_trans/name    |    1 
 tests/j_short_uncommitted_trans/script  |   61 ++++++++++++++++++
 25 files changed, 927 insertions(+)
 create mode 100644 tests/defaults/j_script
 create mode 100644 tests/j_long_revoke_trans/expect
 create mode 100644 tests/j_long_revoke_trans/name
 create mode 100644 tests/j_long_revoke_trans/script
 create mode 100644 tests/j_long_trans/expect
 create mode 100644 tests/j_long_trans/name
 create mode 100644 tests/j_long_trans/script
 create mode 100644 tests/j_short_revoke_trans/expect
 create mode 100644 tests/j_short_revoke_trans/name
 create mode 100644 tests/j_short_revoke_trans/script
 create mode 100644 tests/j_short_trans/expect
 create mode 100644 tests/j_short_trans/name
 create mode 100644 tests/j_short_trans/script
 create mode 100644 tests/j_short_trans_64bit/expect
 create mode 100644 tests/j_short_trans_64bit/name
 create mode 100644 tests/j_short_trans_64bit/script
 create mode 100644 tests/j_short_trans_open_recover/expect
 create mode 100644 tests/j_short_trans_open_recover/name
 create mode 100644 tests/j_short_trans_open_recover/script
 create mode 100644 tests/j_short_trans_recover/expect
 create mode 100644 tests/j_short_trans_recover/name
 create mode 100644 tests/j_short_trans_recover/script
 create mode 100644 tests/j_short_uncommitted_trans/expect
 create mode 100644 tests/j_short_uncommitted_trans/name
 create mode 100644 tests/j_short_uncommitted_trans/script


diff --git a/tests/defaults/j_script b/tests/defaults/j_script
new file mode 100644
index 0000000..7a3b34f
--- /dev/null
+++ b/tests/defaults/j_script
@@ -0,0 +1 @@
+. $cmd_dir/run_e2fsck
diff --git a/tests/j_long_revoke_trans/expect b/tests/j_long_revoke_trans/expect
new file mode 100644
index 0000000..c0730e6
--- /dev/null
+++ b/tests/j_long_revoke_trans/expect
@@ -0,0 +1,81 @@
+Creating filesystem with 262144 1k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (8192 blocks): done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 14431/262144 blocks
+Exit status is 0
+debugfs write journal
+debugfs: logdump -c
+Journal starts at block 1, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 1
+Found expected sequence 1, type 1 (descriptor block) at block 126
+Found expected sequence 1, type 1 (descriptor block) at block 251
+Found expected sequence 1, type 1 (descriptor block) at block 376
+Found expected sequence 1, type 1 (descriptor block) at block 501
+Found expected sequence 1, type 1 (descriptor block) at block 626
+Found expected sequence 1, type 1 (descriptor block) at block 751
+Found expected sequence 1, type 1 (descriptor block) at block 876
+Found expected sequence 1, type 1 (descriptor block) at block 1001
+Found expected sequence 1, type 1 (descriptor block) at block 1126
+Found expected sequence 1, type 1 (descriptor block) at block 1251
+Found expected sequence 1, type 1 (descriptor block) at block 1376
+Found expected sequence 1, type 1 (descriptor block) at block 1501
+Found expected sequence 1, type 1 (descriptor block) at block 1626
+Found expected sequence 1, type 1 (descriptor block) at block 1751
+Found expected sequence 1, type 1 (descriptor block) at block 1876
+Found expected sequence 1, type 1 (descriptor block) at block 2001
+Found expected sequence 1, type 1 (descriptor block) at block 2126
+Found expected sequence 1, type 1 (descriptor block) at block 2251
+Found expected sequence 1, type 1 (descriptor block) at block 2376
+Found expected sequence 1, type 1 (descriptor block) at block 2501
+Found expected sequence 1, type 1 (descriptor block) at block 2626
+Found expected sequence 1, type 1 (descriptor block) at block 2751
+Found expected sequence 1, type 1 (descriptor block) at block 2876
+Found expected sequence 1, type 1 (descriptor block) at block 3001
+Found expected sequence 1, type 1 (descriptor block) at block 3126
+Found expected sequence 1, type 1 (descriptor block) at block 3251
+Found expected sequence 1, type 1 (descriptor block) at block 3376
+Found expected sequence 1, type 1 (descriptor block) at block 3501
+Found expected sequence 1, type 1 (descriptor block) at block 3626
+Found expected sequence 1, type 1 (descriptor block) at block 3751
+Found expected sequence 1, type 1 (descriptor block) at block 3876
+Found expected sequence 1, type 1 (descriptor block) at block 4001
+Found expected sequence 1, type 1 (descriptor block) at block 4126
+Found expected sequence 1, type 2 (commit block) at block 4133
+Found expected sequence 2, type 5 (revoke table) at block 4134
+Found expected sequence 2, type 5 (revoke table) at block 4135
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
+Found expected sequence 2, type 2 (commit block) at block 4151
+No magic number at block 4152: end of journal.
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 14431/262144 blocks
+Exit status is 0
diff --git a/tests/j_long_revoke_trans/name b/tests/j_long_revoke_trans/name
new file mode 100644
index 0000000..3cbb2cd
--- /dev/null
+++ b/tests/j_long_revoke_trans/name
@@ -0,0 +1 @@
+revoked transaction nuking free space
diff --git a/tests/j_long_revoke_trans/script b/tests/j_long_revoke_trans/script
new file mode 100644
index 0000000..4289c2e
--- /dev/null
+++ b/tests/j_long_revoke_trans/script
@@ -0,0 +1,62 @@
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
+$MKE2FS -F -o Linux -b 1024 -O has_journal -T ext4 $TMPFILE 262144 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jw -b 259-4356 /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+echo "jo" >> $TMPFILE.cmd
+echo "jw -r 259-4356" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
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
diff --git a/tests/j_long_trans/expect b/tests/j_long_trans/expect
new file mode 100644
index 0000000..7638ef1
--- /dev/null
+++ b/tests/j_long_trans/expect
@@ -0,0 +1,107 @@
+Creating filesystem with 262144 1k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (8192 blocks): done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 14431/262144 blocks
+Exit status is 0
+debugfs write journal
+debugfs: logdump -c
+Journal starts at block 1, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 1
+Found expected sequence 1, type 1 (descriptor block) at block 126
+Found expected sequence 1, type 1 (descriptor block) at block 251
+Found expected sequence 1, type 1 (descriptor block) at block 376
+Found expected sequence 1, type 1 (descriptor block) at block 501
+Found expected sequence 1, type 1 (descriptor block) at block 626
+Found expected sequence 1, type 1 (descriptor block) at block 751
+Found expected sequence 1, type 1 (descriptor block) at block 876
+Found expected sequence 1, type 1 (descriptor block) at block 1001
+Found expected sequence 1, type 1 (descriptor block) at block 1126
+Found expected sequence 1, type 1 (descriptor block) at block 1251
+Found expected sequence 1, type 1 (descriptor block) at block 1376
+Found expected sequence 1, type 1 (descriptor block) at block 1501
+Found expected sequence 1, type 1 (descriptor block) at block 1626
+Found expected sequence 1, type 1 (descriptor block) at block 1751
+Found expected sequence 1, type 1 (descriptor block) at block 1876
+Found expected sequence 1, type 1 (descriptor block) at block 2001
+Found expected sequence 1, type 1 (descriptor block) at block 2126
+Found expected sequence 1, type 1 (descriptor block) at block 2251
+Found expected sequence 1, type 1 (descriptor block) at block 2376
+Found expected sequence 1, type 1 (descriptor block) at block 2501
+Found expected sequence 1, type 1 (descriptor block) at block 2626
+Found expected sequence 1, type 1 (descriptor block) at block 2751
+Found expected sequence 1, type 1 (descriptor block) at block 2876
+Found expected sequence 1, type 1 (descriptor block) at block 3001
+Found expected sequence 1, type 1 (descriptor block) at block 3126
+Found expected sequence 1, type 1 (descriptor block) at block 3251
+Found expected sequence 1, type 1 (descriptor block) at block 3376
+Found expected sequence 1, type 1 (descriptor block) at block 3501
+Found expected sequence 1, type 1 (descriptor block) at block 3626
+Found expected sequence 1, type 1 (descriptor block) at block 3751
+Found expected sequence 1, type 1 (descriptor block) at block 3876
+Found expected sequence 1, type 1 (descriptor block) at block 4001
+Found expected sequence 1, type 1 (descriptor block) at block 4126
+Found expected sequence 1, type 2 (commit block) at block 4133
+No magic number at block 4134: end of journal.
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
+Block bitmap differences:  +(1--259) +273 +275 +289 +(291--418) +(2083--2210) +2341
+Fix? yes
+
+Free blocks count wrong for group #0 (5838, counted=5851).
+Fix? yes
+
+Free blocks count wrong for group #14 (0, counted=8192).
+Fix? yes
+
+Free blocks count wrong (247711, counted=255916).
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
+Recreate journal? yes
+
+Creating journal (8192 blocks):  Done.
+
+*** journal has been re-created - filesystem is now ext3 again ***
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16384 files (0.0% non-contiguous), 14420/262144 blocks
+Exit status is 1
diff --git a/tests/j_long_trans/name b/tests/j_long_trans/name
new file mode 100644
index 0000000..7a70f8f
--- /dev/null
+++ b/tests/j_long_trans/name
@@ -0,0 +1 @@
+transaction nuking free space
diff --git a/tests/j_long_trans/script b/tests/j_long_trans/script
new file mode 100644
index 0000000..9a4f131
--- /dev/null
+++ b/tests/j_long_trans/script
@@ -0,0 +1,59 @@
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
+$MKE2FS -F -o Linux -b 1024 -O has_journal -T ext4 $TMPFILE 262144 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "debugfs write journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jw -b 259-4356 /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
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
diff --git a/tests/j_short_revoke_trans/expect b/tests/j_short_revoke_trans/expect
new file mode 100644
index 0000000..e83c5ea
--- /dev/null
+++ b/tests/j_short_revoke_trans/expect
@@ -0,0 +1,32 @@
+Creating filesystem with 65536 4k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	32768
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Creating journal (4096 blocks): done
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 0
+debugfs write journal
+debugfs: logdump -c
+Journal starts at block 1, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 1
+Found expected sequence 1, type 2 (commit block) at block 6
+Found expected sequence 2, type 5 (revoke table) at block 7
+Found expected sequence 2, type 2 (commit block) at block 8
+No magic number at block 9: end of journal.
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 0
diff --git a/tests/j_short_revoke_trans/name b/tests/j_short_revoke_trans/name
new file mode 100644
index 0000000..5470018
--- /dev/null
+++ b/tests/j_short_revoke_trans/name
@@ -0,0 +1 @@
+revoke blocks of transaction nuking bitmaps
diff --git a/tests/j_short_revoke_trans/script b/tests/j_short_revoke_trans/script
new file mode 100644
index 0000000..edf28f9
--- /dev/null
+++ b/tests/j_short_revoke_trans/script
@@ -0,0 +1,64 @@
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
+$MKE2FS -F -o Linux -b 4096 -O has_journal -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+
+echo "debugfs write journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+echo "jo" >> $TMPFILE.cmd
+echo "jw -r $bitmaps" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
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
diff --git a/tests/j_short_trans/expect b/tests/j_short_trans/expect
new file mode 100644
index 0000000..bcc8fe8
--- /dev/null
+++ b/tests/j_short_trans/expect
@@ -0,0 +1,38 @@
+Creating filesystem with 65536 4k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	32768
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Creating journal (4096 blocks): done
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 0
+debugfs write journal
+debugfs: logdump -c
+Journal starts at block 1, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 1
+Found expected sequence 1, type 2 (commit block) at block 6
+No magic number at block 7: end of journal.
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(0--1050) +(32768--36880)
+Fix? yes
+
+Inode bitmap differences:  +(1--11)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 1
diff --git a/tests/j_short_trans/name b/tests/j_short_trans/name
new file mode 100644
index 0000000..730fbad
--- /dev/null
+++ b/tests/j_short_trans/name
@@ -0,0 +1 @@
+transaction nuking the bitmaps
diff --git a/tests/j_short_trans/script b/tests/j_short_trans/script
new file mode 100644
index 0000000..00f4d6e
--- /dev/null
+++ b/tests/j_short_trans/script
@@ -0,0 +1,61 @@
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
+$MKE2FS -F -o Linux -b 4096 -O has_journal -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+
+echo "debugfs write journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
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
diff --git a/tests/j_short_trans_64bit/expect b/tests/j_short_trans_64bit/expect
new file mode 100644
index 0000000..f9971eb
--- /dev/null
+++ b/tests/j_short_trans_64bit/expect
@@ -0,0 +1,40 @@
+Creating filesystem with 65536 4k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	32768
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Creating journal (4096 blocks): done
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 5196/65536 blocks
+Exit status is 0
+Journal features:         (none)
+debugfs write journal
+Journal features:         journal_64bit
+debugfs: logdump -c
+Journal starts at block 1, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 1
+Found expected sequence 1, type 2 (commit block) at block 6
+No magic number at block 7: end of journal.
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(0--1066) +(32768--36896)
+Fix? yes
+
+Inode bitmap differences:  +(1--11)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16384 files (0.0% non-contiguous), 5196/65536 blocks
+Exit status is 1
diff --git a/tests/j_short_trans_64bit/name b/tests/j_short_trans_64bit/name
new file mode 100644
index 0000000..17b70d0
--- /dev/null
+++ b/tests/j_short_trans_64bit/name
@@ -0,0 +1 @@
+transaction nuking the bitmaps on 64bit
diff --git a/tests/j_short_trans_64bit/script b/tests/j_short_trans_64bit/script
new file mode 100644
index 0000000..daf0866
--- /dev/null
+++ b/tests/j_short_trans_64bit/script
@@ -0,0 +1,65 @@
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
+$MKE2FS -F -o Linux -b 4096 -O 64bit,has_journal -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+
+$DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
+
+echo "debugfs write journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
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
diff --git a/tests/j_short_trans_open_recover/expect b/tests/j_short_trans_open_recover/expect
new file mode 100644
index 0000000..be6e363
--- /dev/null
+++ b/tests/j_short_trans_open_recover/expect
@@ -0,0 +1,43 @@
+Creating filesystem with 65536 4k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	32768
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Creating journal (4096 blocks): done
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 0
+debugfs write journal
+debugfs: logdump -c
+Journal starts at block 1, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 1
+Found expected sequence 1, type 2 (commit block) at block 6
+No magic number at block 7: end of journal.
+debugfs can't recover open journal
+debugfs: jo
+debugfs: jr
+Please close the journal before recovering it.
+debugfs: jc
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(0--1050) +(32768--36880)
+Fix? yes
+
+Inode bitmap differences:  +(1--11)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 1
diff --git a/tests/j_short_trans_open_recover/name b/tests/j_short_trans_open_recover/name
new file mode 100644
index 0000000..892e95c
--- /dev/null
+++ b/tests/j_short_trans_open_recover/name
@@ -0,0 +1 @@
+ensure we can't recover the journal with journal open
diff --git a/tests/j_short_trans_open_recover/script b/tests/j_short_trans_open_recover/script
new file mode 100644
index 0000000..fbbb714
--- /dev/null
+++ b/tests/j_short_trans_open_recover/script
@@ -0,0 +1,69 @@
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
+$MKE2FS -F -o Linux -b 4096 -O has_journal -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+
+echo "debugfs write journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jw -b $bitmaps /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
+
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
+echo "logdump -c" > $TMPFILE.cmd
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+rm -rf $TMPFILE.cmd
+
+echo "debugfs can't recover open journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jr" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd > $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
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
diff --git a/tests/j_short_trans_recover/expect b/tests/j_short_trans_recover/expect
new file mode 100644
index 0000000..7586733
--- /dev/null
+++ b/tests/j_short_trans_recover/expect
@@ -0,0 +1,40 @@
+Creating filesystem with 65536 4k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	32768
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Creating journal (4096 blocks): done
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 0
+debugfs write journal
+debugfs: logdump -c
+Journal starts at block 1, transaction 1
+Found expected sequence 1, type 1 (descriptor block) at block 1
+Found expected sequence 1, type 2 (commit block) at block 7
+Found expected sequence 2, type 5 (revoke table) at block 8
+Found expected sequence 2, type 2 (commit block) at block 9
+No magic number at block 10: end of journal.
+debugfs recover journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(0--1050) +(32768--36880)
+Fix? yes
+
+Inode bitmap differences:  +(1--11)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 1
diff --git a/tests/j_short_trans_recover/name b/tests/j_short_trans_recover/name
new file mode 100644
index 0000000..54e3553
--- /dev/null
+++ b/tests/j_short_trans_recover/name
@@ -0,0 +1 @@
+transaction nuking the bitmaps (debugfs recovery)
diff --git a/tests/j_short_trans_recover/script b/tests/j_short_trans_recover/script
new file mode 100644
index 0000000..7fa6158
--- /dev/null
+++ b/tests/j_short_trans_recover/script
@@ -0,0 +1,70 @@
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
+$MKE2FS -F -o Linux -b 4096 -O has_journal -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+
+echo "debugfs write journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jw -b 333,$bitmaps /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+echo "jo" >> $TMPFILE.cmd
+echo "jw -r 333" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
+
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp "$TMPFILE" "$JOURNAL_DUMP_DIR/$test_name.img"
+echo "logdump -c" > $TMPFILE.cmd
+$DEBUGFS_EXE $TMPFILE -f $TMPFILE.cmd 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
+rm -rf $TMPFILE.cmd
+
+echo "debugfs recover journal" >> $OUT
+echo "jr" > $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
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
diff --git a/tests/j_short_uncommitted_trans/expect b/tests/j_short_uncommitted_trans/expect
new file mode 100644
index 0000000..dedddb5
--- /dev/null
+++ b/tests/j_short_uncommitted_trans/expect
@@ -0,0 +1,26 @@
+Creating filesystem with 65536 4k blocks and 16384 inodes
+Superblock backups stored on blocks: 
+	32768
+
+Allocating group tables:    done                            
+Writing inode tables:    done                            
+Creating journal (4096 blocks): done
+Writing superblocks and filesystem accounting information:    done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 0
+debugfs write journal
+debugfs: logdump -c
+Journal starts at block 0, transaction 1
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 5164/65536 blocks
+Exit status is 0
diff --git a/tests/j_short_uncommitted_trans/name b/tests/j_short_uncommitted_trans/name
new file mode 100644
index 0000000..b617231
--- /dev/null
+++ b/tests/j_short_uncommitted_trans/name
@@ -0,0 +1 @@
+uncommitted transaction nuking bitmaps
diff --git a/tests/j_short_uncommitted_trans/script b/tests/j_short_uncommitted_trans/script
new file mode 100644
index 0000000..207d746
--- /dev/null
+++ b/tests/j_short_uncommitted_trans/script
@@ -0,0 +1,61 @@
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
+$MKE2FS -F -o Linux -b 4096 -O has_journal -T ext4 $TMPFILE 65536 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+bitmaps="$($DUMPE2FS $TMPFILE 2>&1 | grep 'bitmap at' | sed -e 's/^.*Block bitmap at \([0-9]*\) .*Inode bitmap at \([0-9]*\).*$/\1,\2/g' | tr '\n' ',')"
+
+echo "debugfs write journal" >> $OUT
+echo "jo" > $TMPFILE.cmd
+echo "jw -b $bitmaps -c /dev/zero" >> $TMPFILE.cmd
+echo "jc" >> $TMPFILE.cmd
+$DEBUGFS_EXE -w $TMPFILE -f $TMPFILE.cmd 2>> $OUT.new > /dev/null
+sed -f $cmd_dir/filter.sed < $OUT.new >> $OUT
+rm -rf $OUT.new
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

