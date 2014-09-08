From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/25] mke2fs: allow creation of journal device with
 superblock checksum
Date: Mon, 08 Sep 2014 16:12:08 -0700
Message-ID: <20140908231208.25904.32508.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48990 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaIHXMN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:12:13 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enable mke2fs to create an external journal device with a superblock
checksum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: TR Reardon <thomas_reardon@hotmail.com>
---
 misc/mke2fs.c                   |    6 +++++-
 tests/m_mcsum_extjournal/expect |    5 +++++
 tests/m_mcsum_extjournal/name   |    1 +
 tests/m_mcsum_extjournal/script |   29 +++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)
 create mode 100644 tests/m_mcsum_extjournal/expect
 create mode 100644 tests/m_mcsum_extjournal/name
 create mode 100644 tests/m_mcsum_extjournal/script


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index fc03766..2bc435b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2124,7 +2124,8 @@ profile_error:
 		reserved_ratio = 0;
 		fs_param.s_feature_incompat = EXT3_FEATURE_INCOMPAT_JOURNAL_DEV;
 		fs_param.s_feature_compat = 0;
-		fs_param.s_feature_ro_compat = 0;
+		fs_param.s_feature_ro_compat &=
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM;
  	}
 
 	/* Check the user's mkfs options for 64bit */
@@ -2743,6 +2744,8 @@ int main (int argc, char *argv[])
 
 	/* Check the user's mkfs options for metadata checksumming */
 	if (!quiet &&
+	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				       EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) &&
 	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
@@ -2909,6 +2912,7 @@ int main (int argc, char *argv[])
 	if (fs->super->s_feature_incompat &
 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
 		create_journal_dev(fs);
+		printf("\n");
 		exit(ext2fs_close_free(&fs) ? 1 : 0);
 	}
 
diff --git a/tests/m_mcsum_extjournal/expect b/tests/m_mcsum_extjournal/expect
new file mode 100644
index 0000000..ef895f8
--- /dev/null
+++ b/tests/m_mcsum_extjournal/expect
@@ -0,0 +1,5 @@
+Creating filesystem with 4096 1k blocks and 0 inodes
+Superblock backups stored on blocks: 
+
+Zeroing journal device:          
+Filesystem features:      journal_dev metadata_csum
diff --git a/tests/m_mcsum_extjournal/name b/tests/m_mcsum_extjournal/name
new file mode 100644
index 0000000..7df8389
--- /dev/null
+++ b/tests/m_mcsum_extjournal/name
@@ -0,0 +1 @@
+create external journal with sb checksum (metadata_csum)
diff --git a/tests/m_mcsum_extjournal/script b/tests/m_mcsum_extjournal/script
new file mode 100644
index 0000000..624bf02
--- /dev/null
+++ b/tests/m_mcsum_extjournal/script
@@ -0,0 +1,29 @@
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
+$DUMPE2FS -h $TMPFILE 2>&1 | grep 'Filesystem features:' >> $OUT
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

