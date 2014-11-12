From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 48/47] misc: fix infinite loop when finding the start of the
 hugefile start range
Date: Wed, 12 Nov 2014 14:43:29 -0800
Message-ID: <20141112224329.GI10043@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34806 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaKLWne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2014 17:43:34 -0500
Content-Disposition: inline
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When looking for the start of the hugefile range, the 'next' variable
is incorrectly decremented.  If we happened to find a single free
block, the effect of this decrement is that blk == next, which means
that we never modify the loop control variable, so get_start_block
never returns.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mk_hugefiles.c           |    1 -
 tests/m_hugefile_slack/expect |   18 ++++++++++++
 tests/m_hugefile_slack/name   |    1 +
 tests/m_hugefile_slack/script |   61 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+), 1 deletion(-)
 create mode 100644 tests/m_hugefile_slack/expect
 create mode 100644 tests/m_hugefile_slack/name
 create mode 100644 tests/m_hugefile_slack/script

diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index 3e4274c..230844f 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -437,7 +437,6 @@ static blk64_t get_start_block(ext2_filsys fs, blk64_t slack)
 						blk, last_blk, &next);
 		if (retval)
 			next = last_blk;
-		next--;
 
 		if (next - blk > slack) {
 			blk += slack;
diff --git a/tests/m_hugefile_slack/expect b/tests/m_hugefile_slack/expect
new file mode 100644
index 0000000..96a628a
--- /dev/null
+++ b/tests/m_hugefile_slack/expect
@@ -0,0 +1,18 @@
+tune2fs test
+Creating filesystem with 786432 1k blocks and 98304 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 6368 huge file(s) with 117 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/m_hugefile_slack/name b/tests/m_hugefile_slack/name
new file mode 100644
index 0000000..51cef19
--- /dev/null
+++ b/tests/m_hugefile_slack/name
@@ -0,0 +1 @@
+trigger infinite loop when creating hugefiles with a lot of slack
diff --git a/tests/m_hugefile_slack/script b/tests/m_hugefile_slack/script
new file mode 100644
index 0000000..96f5ec5
--- /dev/null
+++ b/tests/m_hugefile_slack/script
@@ -0,0 +1,61 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+#gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,^resize_inode,^meta_bg,^flex_bg,metadata_csum,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 12000K
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 117K
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h -I 128 $TMPFILE 786432 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check. if we get this far, we succeeded...
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+fi
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
