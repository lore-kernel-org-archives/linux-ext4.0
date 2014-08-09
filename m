From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/6] tests: add the r_meta_bg_shrink test
Date: Sat,  9 Aug 2014 13:10:20 -0400
Message-ID: <1407604220-2620-6-git-send-email-tytso@mit.edu>
References: <1407604220-2620-1-git-send-email-tytso@mit.edu>
Cc: antymat+debian@chelmska.waw.pl, 756922@bugs.debian.org,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52421 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaHIRK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Aug 2014 13:10:27 -0400
In-Reply-To: <1407604220-2620-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This test checks to make sure resize2fs can properly handle a file
system which started life as a normal ext4 file system and then was
grown to a size where meta_bg was enabled, and then shrunk back below
the point where the meta_bg format is still needed.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/r_meta_bg_shrink/script | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 tests/r_meta_bg_shrink/script

diff --git a/tests/r_meta_bg_shrink/script b/tests/r_meta_bg_shrink/script
new file mode 100644
index 0000000..a29c28a
--- /dev/null
+++ b/tests/r_meta_bg_shrink/script
@@ -0,0 +1,34 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+test_description="meta_bg shrink"
+FEATURES="-t ext4 -O 64bit,meta_bg,^resize_inode -b 1024"
+SIZE_1=1G
+SIZE_2=48M
+LOG=$test_name.log
+E2FSCK=../e2fsck/e2fsck
+RESIZE2FS_OPTS=-f
+
+. $cmd_dir/scripts/resize_test
+
+export MKE2FS_FIRST_META_BG=2
+resize_test
+unset MKE2FS_FIRST_META_BG
+
+RC=$?
+if [ $RC -eq 0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+elif [ $RC -eq 111 ]; then
+	echo "$test_name: $test_description: skipped"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	ln $LOG $test_name.failed
+fi
+
+unset FEATURES SIZE_1 SIZE_2 LOG E2FSCK
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi 
+
-- 
2.0.0

