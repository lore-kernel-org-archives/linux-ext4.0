From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/27] tests: write and replay blocks with the old journal
 checksum
Date: Sat, 16 Aug 2014 16:47:51 -0700
Message-ID: <20140816234751.11171.28949.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24138 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaHPXrz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:47:55 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test that we can write and replay transactions with the old journal
checksum algorithm.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/j_short_trans_old_csum/expect |   40 ++++++++++++++++++++++
 tests/j_short_trans_old_csum/name   |    1 +
 tests/j_short_trans_old_csum/script |   65 +++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)
 create mode 100644 tests/j_short_trans_old_csum/expect
 create mode 100644 tests/j_short_trans_old_csum/name
 create mode 100644 tests/j_short_trans_old_csum/script


diff --git a/tests/j_short_trans_old_csum/expect b/tests/j_short_trans_old_csum/expect
new file mode 100644
index 0000000..29ac27f
--- /dev/null
+++ b/tests/j_short_trans_old_csum/expect
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
+Journal features:         (none)
+debugfs write journal
+Journal features:         journal_checksum
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
diff --git a/tests/j_short_trans_old_csum/name b/tests/j_short_trans_old_csum/name
new file mode 100644
index 0000000..2e81f94
--- /dev/null
+++ b/tests/j_short_trans_old_csum/name
@@ -0,0 +1 @@
+transaction nuking the bitmaps with old journal checksum (v1)
diff --git a/tests/j_short_trans_old_csum/script b/tests/j_short_trans_old_csum/script
new file mode 100644
index 0000000..b968bc1
--- /dev/null
+++ b/tests/j_short_trans_old_csum/script
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
+$DUMPE2FS $TMPFILE 2>&1 | grep '^Journal features:' >> $OUT
+
+echo "debugfs write journal" >> $OUT
+echo "jo -c" > $TMPFILE.cmd
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

