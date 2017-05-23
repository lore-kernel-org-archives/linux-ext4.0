From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] e2fsck: fix sparse bmap to extent conversion
Date: Tue, 23 May 2017 12:00:19 -0700
Message-ID: <20170523190019.GF4510@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Marc Thomas <marc@dragonfly.plus.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39371 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935775AbdEWTA3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 May 2017 15:00:29 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Marc,

If it's not too much trouble, can you build e2fsprogs with this patch
and see if the conversion corruption problem is fixed?  The supplied
regression test has a realmode.bin I made with your script, but it's
always good to re-verify with the bug filer.

--D

---
When e2fsck is trying to convert a sparse block-mapped file to an extent
file, we incorrectly merge block mappings that are physically contiguous
but not logically contiguous because of insufficient checking with the
extent we're constructing.  Therefore, compare the logical offsets for
contiguity as well.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/extents.c                     |    3 +
 tests/f_convert_bmap_sparse/expect.1 |   24 +++++++
 tests/f_convert_bmap_sparse/expect.2 |   12 +++
 tests/f_convert_bmap_sparse/image.gz |  Bin
 tests/f_convert_bmap_sparse/name     |    1 
 tests/f_convert_bmap_sparse/script   |  117 ++++++++++++++++++++++++++++++++++
 6 files changed, 156 insertions(+), 1 deletion(-)
 create mode 100644 tests/f_convert_bmap_sparse/expect.1
 create mode 100644 tests/f_convert_bmap_sparse/expect.2
 create mode 100644 tests/f_convert_bmap_sparse/image.gz
 create mode 100644 tests/f_convert_bmap_sparse/name
 create mode 100644 tests/f_convert_bmap_sparse/script

diff --git a/e2fsck/extents.c b/e2fsck/extents.c
index 98cf7c3..ef3146d 100644
--- a/e2fsck/extents.c
+++ b/e2fsck/extents.c
@@ -171,7 +171,8 @@ static int find_blocks(ext2_filsys fs, blk64_t *blocknr, e2_blkcnt_t blockcnt,
 					     list->count - 1;
 		blk64_t end = last->e_len + 1;
 
-		if (last->e_pblk + last->e_len == *blocknr &&
+		if (last->e_lblk + last->e_len == blockcnt &&
+		    last->e_pblk + last->e_len == *blocknr &&
 		    end < (1ULL << 32)) {
 			last->e_len++;
 #ifdef DEBUG
diff --git a/tests/f_convert_bmap_sparse/expect.1 b/tests/f_convert_bmap_sparse/expect.1
new file mode 100644
index 0000000..095fb2b
--- /dev/null
+++ b/tests/f_convert_bmap_sparse/expect.1
@@ -0,0 +1,24 @@
+debugfs: stat /realmode.bin
+Inode: 12   Type: regular    Mode:  0775   Flags: 0x0
+Generation: 2022334337    Version: 0x00000001
+User:  1000   Group:  1000   Size: 21080
+File ACL: 0
+Links: 1   Blockcount: 16
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x5924849d -- Tue May 23 18:51:09 2017
+atime: 0x59247d36 -- Tue May 23 18:19:34 2017
+mtime: 0x591e1764 -- Thu May 18 21:51:32 2017
+BLOCKS:
+(0):513, (4-8):514-518, (IND):58, (20):2005
+TOTAL: 8
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 1E: Optimizing extent trees
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/256 files (8.3% non-contiguous), 65/2048 blocks
+Exit status is 0
diff --git a/tests/f_convert_bmap_sparse/expect.2 b/tests/f_convert_bmap_sparse/expect.2
new file mode 100644
index 0000000..e5a3d44
--- /dev/null
+++ b/tests/f_convert_bmap_sparse/expect.2
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/256 files (8.3% non-contiguous), 65/2048 blocks
+Exit status is 0
+debugfs: ex /realmode.bin
+Level Entries       Logical      Physical Length Flags
+ 0/ 0   1/  3     0 -     0   513 -   513      1 
+ 0/ 0   2/  3     4 -     8   514 -   518      5 
+ 0/ 0   3/  3    20 -    20  2005 -  2005      1 
diff --git a/tests/f_convert_bmap_sparse/image.gz b/tests/f_convert_bmap_sparse/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..1f594fd4df402b5d50a78962bbebb20e9eae2032
GIT binary patch
literal 5585
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

literal 0
HcmV?d00001

diff --git a/tests/f_convert_bmap_sparse/name b/tests/f_convert_bmap_sparse/name
new file mode 100644
index 0000000..dc3b985
--- /dev/null
+++ b/tests/f_convert_bmap_sparse/name
@@ -0,0 +1 @@
+convert sparse blockmap file to extents file
diff --git a/tests/f_convert_bmap_sparse/script b/tests/f_convert_bmap_sparse/script
new file mode 100644
index 0000000..89b7ed7
--- /dev/null
+++ b/tests/f_convert_bmap_sparse/script
@@ -0,0 +1,117 @@
+if [ "$DESCRIPTION"x != x ]; then
+	test_description="$DESCRIPTION"
+fi
+if [ "$IMAGE"x = x ]; then
+	IMAGE=$test_dir/image.gz
+fi
+
+if [ "$FSCK_OPT"x = x ]; then
+	FSCK_OPT=-yf
+fi
+
+if [ "$SECOND_FSCK_OPT"x = x ]; then
+	SECOND_FSCK_OPT=-yf
+fi
+
+if [ "$OUT1"x = x ]; then
+	OUT1=$test_name.1.log
+fi
+
+if [ "$OUT2"x = x ]; then
+	OUT2=$test_name.2.log
+fi
+
+if [ "$EXP1"x = x ]; then
+	if [ -f $test_dir/expect.1.gz ]; then
+		EXP1=$test_name.1.tmp
+		gunzip < $test_dir/expect.1.gz > $EXP1
+	else
+		EXP1=$test_dir/expect.1
+	fi
+fi
+
+if [ "$EXP2"x = x ]; then
+	if [ -f $test_dir/expect.2.gz ]; then
+		EXP2=$test_name.2.tmp
+		gunzip < $test_dir/expect.2.gz > $EXP2
+	else
+		EXP2=$test_dir/expect.2
+	fi
+fi
+
+if [ "$SKIP_GUNZIP" != "true" ] ; then
+	gunzip < $IMAGE > $TMPFILE
+fi
+
+cp /dev/null $OUT1
+
+eval $PREP_CMD
+
+echo 'stat /realmode.bin' > $TMPFILE.cmd
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE > $OUT1.new 2>&1
+rm -rf $TMPFILE.cmd
+$TUNE2FS -O extent $TMPFILE >> $OUT1.new 2>&1
+$FSCK $FSCK_OPT -E bmap2extent -N test_filesys $TMPFILE >> $OUT1.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT1.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT1.new >> $OUT1
+rm -f $OUT1.new
+
+$FSCK $SECOND_FSCK_OPT -N test_filesys $TMPFILE > $OUT2.new 2>&1 
+status=$?
+echo Exit status is $status >> $OUT2.new
+echo 'ex /realmode.bin' > $TMPFILE.cmd
+$DEBUGFS -f $TMPFILE.cmd $TMPFILE >> $OUT2.new 2>&1
+rm -rf $TMPFILE.cmd
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT2.new > $OUT2
+rm -f $OUT2.new
+
+eval $AFTER_CMD
+
+if [ "$SKIP_VERIFY" != "true" ] ; then
+	rm -f $test_name.ok $test_name.failed
+	cmp -s $OUT1 $EXP1
+	status1=$?
+	if [ "$ONE_PASS_ONLY" != "true" ]; then
+		cmp -s $OUT2 $EXP2
+		status2=$?
+	else
+		status2=0
+	fi
+	if [ "$PASS_ZERO" = "true" ]; then
+		cmp -s $test_name.0.log	$test_dir/expect.0
+		status3=$?
+	else
+		status3=0
+	fi
+
+	if [ -z "$test_description" ] ; then
+		description="$test_name"
+	else
+		description="$test_name: $test_description"
+	fi
+
+	if [ "$status1" -eq 0 -a "$status2" -eq 0 -a "$status3" -eq 0 ] ; then
+		echo "$description: ok"
+		touch $test_name.ok
+	else
+		echo "$description: failed"
+		rm -f $test_name.failed
+		if [ "$PASS_ZERO" = "true" ]; then
+			diff $DIFF_OPTS $test_dir/expect.0 \
+				$test_name.0.log >> $test_name.failed
+		fi
+		diff $DIFF_OPTS $EXP1 $OUT1 >> $test_name.failed
+		if [ "$ONE_PASS_ONLY" != "true" ]; then
+			diff $DIFF_OPTS $EXP2 $OUT2 >> $test_name.failed
+		fi
+	fi
+	rm -f tmp_expect
+fi
+
+if [ "$SKIP_CLEANUP" != "true" ] ; then
+	unset IMAGE FSCK_OPT SECOND_FSCK_OPT OUT1 OUT2 EXP1 EXP2 
+	unset SKIP_VERIFY SKIP_CLEANUP SKIP_GUNZIP ONE_PASS_ONLY PREP_CMD
+	unset DESCRIPTION SKIP_UNLINK AFTER_CMD PASS_ZERO
+fi
+
