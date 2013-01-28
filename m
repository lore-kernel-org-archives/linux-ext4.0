From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/4] xfstests: check llseek(2) SEEK_DATA/HOLE and unwritten extent preallocation in 285
Date: Mon, 28 Jan 2013 15:32:50 +0800
Message-ID: <1359358371-21411-4-git-send-email-wenqing.lz@taobao.com>
References: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:65099 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3A1HUh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 02:20:37 -0500
Received: by mail-pb0-f53.google.com with SMTP id un1so1297255pbc.12
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jan 2013 23:20:37 -0800 (PST)
In-Reply-To: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In 285 it has its own check for seek data/hole support.  This commit
turns into an equivalent _require_seek_data_hole.

Meanwhile in 285 it doesn't check unwritten extent preallocation.  Now
ext4 file system has supported seek data/hole for a file w/o unwritten
extent.  Thus, in 285, it needs to call the _require_xfs_io_falloc to
check unwritten extent prealloction.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>
---
 285                    |  7 +++++--
 common.rc              | 12 ++++++++++++
 src/seek_sanity_test.c | 18 +++++++++++++-----
 3 files changed, 30 insertions(+), 7 deletions(-)
 mode change 100644 => 100755 285

diff --git a/285 b/285
old mode 100644
new mode 100755
index a18fc71..6224673
--- a/285
+++ b/285
@@ -1,7 +1,7 @@
 #! /bin/bash
 # FS QA Test No. 285
 #
-# SEEK_DATA/SEEK_HOLE sanity tests.
+# SEEK_DATA/SEEK_HOLE sanity tests w/ unwritten extent.
 #
 # Improved by Jeff.liu@oracle.com
 # Creater: josef@redhat.com
@@ -41,9 +41,12 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_seek_data_hole
+_require_xfs_io_falloc
+
 BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
-[ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
+[ -x $here/src/seek_sanity_test ] || _notrun "seek_sanity_tester not built"
 
 _cleanup()
 {
diff --git a/common.rc b/common.rc
index 2e8581e..35a5f52 100644
--- a/common.rc
+++ b/common.rc
@@ -1049,6 +1049,18 @@ _require_sparse_files()
     esac
 }
 
+#
+# Check if the filesystem supports seek_data/hole.
+#
+_require_seek_data_hole()
+{
+	testfile=$TEST_DIR/$$.seek
+	testseek=`$here/src/seek_sanity_test -t $testfile 2>&1`
+	rm -f $testfile 2>&1 > /dev/null
+	echo $testseek | grep -q "Kernel does not support" && \
+		_notrun "File system does not support llseek(2) SEEK_DATA/HOLE"
+}
+
 # check that a FS on a device is mounted
 # if so, return mount point
 #
diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index 3897f02..b1ef006 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -660,17 +660,25 @@ int main(int argc, char **argv)
 {
 	int ret = -1;
 	int i = 0;
+	int opt;
+	int check_support = 0;
 	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
 
-	if (argc != 2) {
-		fprintf(stdout, "Usage: %s base_file_path\n", argv[0]);
-		return ret;
+	while ((opt = getopt(argc, argv, "t")) != -1) {
+		switch (opt) {
+		case 't':
+			check_support++;
+			break;
+		default:
+			fprintf(stdout, "Usage: %s [-t] base_file_path\n", argv[0]);
+			return ret;
+		}
 	}
 
-	base_file_path = (char *)strdup(argv[1]);
+	base_file_path = (char *)strdup(argv[optind]);
 
 	ret = test_basic_support();
-	if (ret)
+	if (ret || check_support)
 		goto out;
 
 	for (i = 0; i < numtests; ++i) {
-- 
1.7.12.rc2.18.g61b472e

