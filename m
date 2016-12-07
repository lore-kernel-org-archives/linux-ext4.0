From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] test: add f_mke2fs_baddisk v2
Date: Wed,  7 Dec 2016 18:55:17 +0400
Message-ID: <1481122518-19021-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:44029 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752795AbcLGOzb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Dec 2016 09:55:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check what mke2fs will return non zero error on broken device.

changes since: v1
 - skip test if dm-error is not available.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/f_mke2fs_baddisk/script | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 tests/f_mke2fs_baddisk/script

diff --git a/tests/f_mke2fs_baddisk/script b/tests/f_mke2fs_baddisk/script
new file mode 100644
index 0000000..0e6d3cd
--- /dev/null
+++ b/tests/f_mke2fs_baddisk/script
@@ -0,0 +1,26 @@
+test_description="mke2fs /dev/mapper/bad_disk should fail"
+
+OUT=$test_name.log
+
+dmsetup create -v bad_disk --table '0 1148681097 error' > $OUT 2>&1
+status=$?
+if [ "$status" != 0 ]; then
+    echo "$test_name: $test_description: skip"
+    touch $test_name.ok
+    exit 0
+fi   
+
+echo mke2fs /dev/mapper/bad_disk  >> $OUT
+$MKE2FS  /dev/mapper/bad_disk  >> $OUT 2>&1
+status=$?
+sleep 1
+dmsetup remove --retry bad_disk >> $OUT 2>&1
+
+if [ "$status" = 0 ] ; then
+    ln -f $test_name.log $test_name.failed
+    echo "$test_name: $test_description: failed"
+else
+    echo "$test_name: $test_description: ok"
+    touch $test_name.ok
+
+fi
-- 
2.7.4

