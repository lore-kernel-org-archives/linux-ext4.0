From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: [PATCH 3/3] tests: 3 level hash tree test
Date: Wed, 25 Jan 2017 11:56:40 +0300
Message-ID: <CAO3qy=H0cC7pkZXqAd_yVxOYS4Bv_Ubqb-FtJU3xocCpp35c+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:41406 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751182AbdAYI5N (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 25 Jan 2017 03:57:13 -0500
Received: from pps.filterd (m0075554.ppops.net [127.0.0.1])
        by mx0a-000cda01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0P8ruUS047726
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 03:57:12 -0500
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com [209.85.220.197])
        by mx0a-000cda01.pphosted.com with ESMTP id 286qfy8dxr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 03:57:12 -0500
Received: by mail-qk0-f197.google.com with SMTP id x64so67962533qkb.5
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 00:56:41 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test is added that recreate directory (-fD fsck option)
with 47.5k of 255-symbol name files. This amount of files
can not be stored only in 2 hevel htree, so 3 levels are used.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 tests/f_large_dir/debugfs_script |   13 +++++++++++++
 tests/f_large_dir/expect         |   10 ++++++++++
 tests/f_large_dir/name           |    1 +
 tests/f_large_dir/script         |   28 ++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 0 deletions(-)
 create mode 100755 tests/f_large_dir/debugfs_script
 create mode 100644 tests/f_large_dir/expect
 create mode 100644 tests/f_large_dir/name
 create mode 100644 tests/f_large_dir/script

diff --git a/tests/f_large_dir/debugfs_script b/tests/f_large_dir/debugfs_script
new file mode 100755
index 0000000..43307ab
--- /dev/null
+++ b/tests/f_large_dir/debugfs_script
@@ -0,0 +1,13 @@
+#!/bin/bash
+echo "feature large_dir"
+echo "mkdir /foo"
+echo "cd /foo"
+touch foofile
+echo "write foofile foofile"
+for i in $(seq 47300); do
+    [[ $(( $i % 5000 )) -eq 0 ]] && \
+    >&2 echo "$i processed"
+    new_uuid=`printf %0255X $i`
+    echo "ln foofile $new_uuid"
+done
+
diff --git a/tests/f_large_dir/expect b/tests/f_large_dir/expect
new file mode 100644
index 0000000..6faf2f5
--- /dev/null
+++ b/tests/f_large_dir/expect
@@ -0,0 +1,10 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
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
+$MKE2FS -b 1024 -O large_dir,uninit_bg,dir_nlink -F $TMPFILE2 460800
> /dev/null
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
+    echo "$test_name: $test_description: ok"
+    touch $test_name.ok
+else
+    echo "$test_name: $test_description: failed"
+    diff -u $EXP $OUT > $test_name.failed
+fi
+
+
+
--
