From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v3 4/4] tests: 3 level hash tree test
Date: Wed, 15 Feb 2017 18:45:47 +0300
Message-ID: <1487173547-95990-1-git-send-email-artem.blagodarenko@gmail.com>
References: <40D3354F-7FF3-44E1-A122-0C0D21042BFF@dilger.ca>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33388 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbdBOPpx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Feb 2017 10:45:53 -0500
Received: by mail-it0-f68.google.com with SMTP id e137so10159500itc.0
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 07:45:53 -0800 (PST)
In-Reply-To: <40D3354F-7FF3-44E1-A122-0C0D21042BFF@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Blagodarenko <artem.blagodarenko@seagate.com>

Test is added that recreate directory (-fD fsck option)
with 47.5k of 255-symbol name files. This amount of files
can not be stored only in 2 hevel htree, so 3 levels are used.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 tests/f_large_dir/expect |   12 +++++++++++
 tests/f_large_dir/name   |    1 +
 tests/f_large_dir/script |   47 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/tests/f_large_dir/expect b/tests/f_large_dir/expect
new file mode 100644
index 0000000..b099460
--- /dev/null
+++ b/tests/f_large_dir/expect
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Inode 13 ref count is 1, should be 47245.  Fix? yes
+
+Pass 5: Checking group summary information
+
+test.img: ***** FILE SYSTEM WAS MODIFIED *****
+test.img: 13/115368 files (0.0% non-contiguous), 32817/460800 blocks
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
index 0000000..e68576d
--- /dev/null
+++ b/tests/f_large_dir/script
@@ -0,0 +1,47 @@
+OUT=$test_name.log
+EXP=$test_dir/expect
+E2FSCK=../e2fsck/e2fsck
+
+NAMELEN=255
+DIRENT_SZ=8
+BLOCKSZ=1024
+DIRENT_PER_LEAF=$((BLOCKSZ / (NAMELEN + DIRENT_SZ)))
+HEADER=32
+INDEX_SZ=8
+INDEX_L1=$(((BLOCKSZ - HEADER) / INDEX_SZ))
+INDEX_L2=$(((BLOCKSZ - DIRENT_SZ) / INDEX_SZ))
+ENTRIES=$((INDEX_L1 * INDEX_L2 * DIRENT_PER_LEAF))
+
+cp /dev/null $OUT
+$MKE2FS -b 1024 -O large_dir,uninit_bg,dir_nlink -F $TMPFILE 460800 > /dev/null
+{
+	echo "feature large_dir"
+	echo "mkdir /foo"
+	echo "cd /foo"
+	touch foofile
+	echo "write foofile foofile"
+	for ((i = 0; i < $ENTRIES; i++)); do
+		[[ $(( i % DIRENT_PER_LEAF )) -eq 0 ]] && echo "expand ./" 
+		[[ $(( i % 5000 )) -eq 0 ]] && >&2 echo "$i processed"
+		printf "ln foofile %0255X\n" $i
+	done
+} | $DEBUGFS -w -f /dev/stdin $TMPFILE > /dev/null
+
+$E2FSCK -yfD $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
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
