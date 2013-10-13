From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/31] tune2fs: Don't convert block # to cluster # when
 clearing uninit_bg
Date: Sat, 12 Oct 2013 23:09:50 -0400
Message-ID: <20131013030950.GA28064@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012649.28415.17225.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45318 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab3JMDJy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Oct 2013 23:09:54 -0400
Content-Disposition: inline
In-Reply-To: <20131001012649.28415.17225.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:26:49PM -0700, Darrick J. Wong wrote:
> When we're constructing the initial block bitmap as part of removing the
> gdt_csum (i.e. uninit_bg) feature, we mustn't convert the block numbers to
> cluster numbers because ext2fs_mark_block_bitmap2() does this for us.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied to the next branch.

I also added the following test which checks for the bug fixed by this
commit.

						- Ted

>From e7619b71c095637e2947d2efea4fdaec60bad1f1 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sat, 12 Oct 2013 23:08:02 -0400
Subject: [PATCH] tests: add new test t_uninit_bg_rm

This test checks tune2fs's support for removing the uninit_bg feature
flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/filter.sed            |  7 ++++++-
 tests/t_uninit_bg_rm/expect | 21 +++++++++++++++++++
 tests/t_uninit_bg_rm/script | 50 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 1 deletion(-)
 create mode 100644 tests/t_uninit_bg_rm/expect
 create mode 100644 tests/t_uninit_bg_rm/script

diff --git a/tests/filter.sed b/tests/filter.sed
index 91b956b..59fad4e 100644
--- a/tests/filter.sed
+++ b/tests/filter.sed
@@ -1,4 +1,9 @@
-/^[dbgumpe2fsckrsiz]* [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
+/^debugfs [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
+/^dumpe2fs [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
+/^e2fsck [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
+/^mke2fs [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
+/^resize2fs [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
+/^tune2fs [1-9]\.[0-9]*[.-][^ ]* ([0-9]*-[A-Za-z]*-[0-9]*)/d
 s/\\015//g
 /automatically checked/d
 /^Directory Hash Seed:/d
diff --git a/tests/t_uninit_bg_rm/expect b/tests/t_uninit_bg_rm/expect
new file mode 100644
index 0000000..61e9eaa
--- /dev/null
+++ b/tests/t_uninit_bg_rm/expect
@@ -0,0 +1,21 @@
+mke2fs -q -t ext4 -F -o Linux -b 1024 test.img 1G
+tune2fs -f -O ^uninit_bg test.img
+ 
+fsck -yf -N test_filesys test.img
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/65536 files (0.0% non-contiguous), 52294/1048576 blocks
+ 
+mke2fs -q -t ext4 -O bigalloc -F -o Linux -b 1024 -C 8192 test.img 10G
+tune2fs -f -O ^uninit_bg test.img
+ 
+fsck -yf -N test_filesys test.img
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/655360 files (0.0% non-contiguous), 199864/10485760 blocks
diff --git a/tests/t_uninit_bg_rm/script b/tests/t_uninit_bg_rm/script
new file mode 100644
index 0000000..cd397c5
--- /dev/null
+++ b/tests/t_uninit_bg_rm/script
@@ -0,0 +1,50 @@
+test_description="remove uninit_bg"
+OUT=$test_name.log
+FSCK_OPT=-yf
+EXP=$test_dir/expect
+
+cp /dev/null $TMPFILE
+rm -f $OUT.new
+
+echo mke2fs -q -t ext4 -F -o Linux -b 1024 $TMPFILE 1G >> $OUT.new
+$MKE2FS -q -t ext4 -F -o Linux -b 1024 $TMPFILE 1G >> $OUT.new 2>&1
+
+echo "tune2fs -f -O ^uninit_bg $TMPFILE" >> $OUT.new
+$TUNE2FS -f -O ^uninit_bg $TMPFILE >> $OUT.new 2>&1
+
+echo " " >> $OUT.new
+echo fsck $FSCK_OPT -N test_filesys test.img >> $OUT.new
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
+
+echo " " >> $OUT.new
+cp /dev/null $TMPFILE
+echo mke2fs -q -t ext4 -O bigalloc -F -o Linux -b 1024 -C 8192 $TMPFILE 10G >> $OUT.new
+$MKE2FS -q -t ext4 -O bigalloc -F -o Linux -b 1024 -C 8192 $TMPFILE 10G >> $OUT.new 2>&1
+
+echo "tune2fs -f -O ^uninit_bg $TMPFILE" >> $OUT.new
+$TUNE2FS -f -O ^uninit_bg $TMPFILE >> $OUT.new 2>&1
+
+echo " " >> $OUT.new
+echo fsck $FSCK_OPT -N test_filesys test.img >> $OUT.new
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new > $OUT
+
+rm -f $OUT.new $TMPFILE
+
+#
+# Do the verification
+#
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
+unset IMAGE FSCK_OPT OUT EXP
-- 
1.7.12.rc0.22.gcdd159b

