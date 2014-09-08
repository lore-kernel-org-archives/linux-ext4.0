From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/25] tune2fs: explicitly disallow tuning of journal devices
Date: Mon, 08 Sep 2014 16:12:21 -0700
Message-ID: <20140908231221.25904.95895.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38913 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaIHXM1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:12:27 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Spit out a more specific error if someone tries to modify an
external journal device.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: TR Reardon <thomas_reardon@hotmail.com>
---
 misc/tune2fs.c              |    8 +++++++-
 tests/t_ext_jnl_fail/expect |    6 ++++++
 tests/t_ext_jnl_fail/name   |    1 +
 tests/t_ext_jnl_fail/script |   30 ++++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)
 create mode 100644 tests/t_ext_jnl_fail/expect
 create mode 100644 tests/t_ext_jnl_fail/name
 create mode 100644 tests/t_ext_jnl_fail/script


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ee47c04..c22c8fd 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2539,7 +2539,7 @@ retry_open:
 	if ((open_flag & EXT2_FLAG_RW) == 0 || f_flag)
 		open_flag |= EXT2_FLAG_SKIP_MMP;
 
-	open_flag |= EXT2_FLAG_64BITS;
+	open_flag |= EXT2_FLAG_64BITS | EXT2_FLAG_JOURNAL_DEV_OK;
 
 	/* keep the filesystem struct around to dump MMP data */
 	open_flag |= EXT2_FLAG_NOFREE_ON_ERROR;
@@ -2569,6 +2569,12 @@ retry_open:
 		ext2fs_free(fs);
 		exit(1);
 	}
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
+		fprintf(stderr, "%s", _("Cannot modify a journal device.\n"));
+		ext2fs_free(fs);
+		exit(1);
+	}
 	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
 
 	if (I_flag && !io_ptr_orig) {
diff --git a/tests/t_ext_jnl_fail/expect b/tests/t_ext_jnl_fail/expect
new file mode 100644
index 0000000..db0aecb
--- /dev/null
+++ b/tests/t_ext_jnl_fail/expect
@@ -0,0 +1,6 @@
+Creating filesystem with 4096 1k blocks and 0 inodes
+Superblock backups stored on blocks: 
+
+Zeroing journal device:          
+tune2fs external journal
+Cannot modify a journal device.
diff --git a/tests/t_ext_jnl_fail/name b/tests/t_ext_jnl_fail/name
new file mode 100644
index 0000000..2fe7d04
--- /dev/null
+++ b/tests/t_ext_jnl_fail/name
@@ -0,0 +1 @@
+tune2fs fail external journal
diff --git a/tests/t_ext_jnl_fail/script b/tests/t_ext_jnl_fail/script
new file mode 100644
index 0000000..bb31cc7
--- /dev/null
+++ b/tests/t_ext_jnl_fail/script
@@ -0,0 +1,30 @@
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
+$MKE2FS -F -o Linux -b 1024 -O journal_dev,metadata_csum -T ext4 $TMPFILE 4096 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT 2>&1
+echo "tune2fs external journal" >> $OUT
+$TUNE2FS -i 0 $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
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

