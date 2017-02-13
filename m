From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2 4/4] tests: 3 level hash tree test
Date: Mon, 13 Feb 2017 12:20:17 +0300
Message-ID: <1486977617-17216-5-git-send-email-artem.blagodarenko@gmail.com>
References: <1486977617-17216-1-git-send-email-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36448 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753207AbdBMRbG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2017 12:31:06 -0500
Received: by mail-it0-f68.google.com with SMTP id f200so14693869itf.3
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2017 09:31:06 -0800 (PST)
In-Reply-To: <1486977617-17216-1-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Blagodarenko <artem.blagodarenko@seagate.com>

Test is added that recreate directory (-fD fsck option)
with 47.5k of 255-symbol name files. This amount of files
can not be stored only in 2 hevel htree, so 3 levels are used.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 tests/f_large_dir/debugfs_script |   15 +++++++++++++++
 tests/f_large_dir/expect         |   12 ++++++++++++
 tests/f_large_dir/name           |    1 +
 tests/f_large_dir/script         |   28 ++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/tests/f_large_dir/debugfs_script b/tests/f_large_dir/debugfs_script
new file mode 100755
index 0000000..b869db5
--- /dev/null
+++ b/tests/f_large_dir/debugfs_script
@@ -0,0 +1,15 @@
+#!/bin/bash
+echo "feature large_dir"
+echo "mkdir /foo"
+echo "cd /foo"
+touch foofile
+echo "write foofile foofile"
+for i in $(seq 47300); do
+	[[ $(( $i % 3 )) -eq 0 ]] && \
+	echo "expand ./" 
+	[[ $(( $i % 5000 )) -eq 0 ]] && \
+	>&2 echo "$i processed"
+	new_uuid=`printf %0255X $i`
+	echo "ln foofile $new_uuid"
+done
+
diff --git a/tests/f_large_dir/expect b/tests/f_large_dir/expect
new file mode 100644
index 0000000..9c94675
--- /dev/null
+++ b/tests/f_large_dir/expect
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Inode 13 ref count is 1, should be 47301.  Fix? yes
+
+Pass 5: Checking group summary information
+
+test.img: ***** FILE SYSTEM WAS MODIFIED *****
+test.img: 13/115368 files (0.0% non-contiguous), 32839/460800 blocks
+Exit status is 1
diff --git a/tests/f_large_dir/name b/tests/f_large_dir/name
new file mode 100644
index 0000000..4b96890
--- /dev/null
+++ b/tests/f_large_dir/name
@@ -0,0 +1 @@
+optimize 3 level htree directories
diff --git a/tests/f_large_dir/script b/tests/f_large_dir/script
new file mode 100644
index 0000000..25983c2
--- /dev/null
+++ b/tests/f_large_dir/script
@@ -0,0 +1,28 @@
+OUT=$test_name.log
+EXP=$test_dir/expect
+DFSCRIPT=$test_dir/debugfs_script
+E2FSCK=../e2fsck/e2fsck
+
+TMPFILE2=/tmp/image
+cp /dev/null $OUT
+$MKE2FS -b 1024 -O large_dir,uninit_bg,dir_nlink -F $TMPFILE2 460800 > /dev/null
+$DFSCRIPT | $DEBUGFS -w -f /dev/stdin $TMPFILE2 > /dev/null
+
+$E2FSCK -yfD $TMPFILE2 > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE2;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+cmp -s $OUT $EXP
+RC=$?
+if [ $RC -eq 0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff -u $EXP $OUT > $test_name.failed
+fi
+
+
+
-- 
1.7.1
