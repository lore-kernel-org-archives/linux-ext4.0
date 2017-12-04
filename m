From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v3 3/4] tests: add test for e2image -b option
Date: Mon,  4 Dec 2017 22:35:29 +0300
Message-ID: <20171204193530.54888-4-artem.blagodarenko@gmail.com>
References: <20171204193530.54888-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:40248 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdLDTfo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Dec 2017 14:35:44 -0500
Received: by mail-lf0-f67.google.com with SMTP id t197so20501467lfe.7
        for <linux-ext4@vger.kernel.org>; Mon, 04 Dec 2017 11:35:43 -0800 (PST)
In-Reply-To: <20171204193530.54888-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Blagodarenko <artem.blagodarenko@seagate.com>

The test makes raw image from partition with broken super block
and executes e2fsck.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/i_zero_super/expect.1 |  22 ++++++++++++++++++++++
 tests/i_zero_super/image.gz | Bin 0 -> 13262 bytes
 tests/i_zero_super/script   |  11 +++++++++++
 3 files changed, 33 insertions(+)

diff --git a/tests/i_zero_super/expect.1 b/tests/i_zero_super/expect.1
new file mode 100644
index 00000000..fda32b96
--- /dev/null
+++ b/tests/i_zero_super/expect.1
@@ -0,0 +1,22 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (7987, counted=7982).
+Fix? no
+
+Free blocks count wrong (11602, counted=11597).
+Fix? no
+
+Free inodes count wrong for group #0 (1493, counted=1488).
+Fix? no
+
+Free inodes count wrong (2997, counted=2992).
+Fix? no
+
+
+test_filesys: ********** WARNING: Filesystem still has errors **********
+
+test_filesys: 11/3008 files (0.0% non-contiguous), 398/12000 blocks
+Exit status is 4
diff --git a/tests/i_zero_super/image.gz b/tests/i_zero_super/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..eea9140194f4dd9ec9dc8bb7b9e2215b950587d2
GIT binary patch
literal 13262
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

literal 0
HcmV?d00001

diff --git a/tests/i_zero_super/script b/tests/i_zero_super/script
new file mode 100644
index 00000000..6b02d86d
--- /dev/null
+++ b/tests/i_zero_super/script
@@ -0,0 +1,11 @@
+if test -x $E2IMAGE_EXE; then
+
+ONE_PASS_ONLY=true
+FSCK_OPT="-n -b 8193 -f"
+PREP_CMD="$E2IMAGE_EXE -r -b 8193 -B 1024 $TMPFILE $TMPFILE.raw; \
+	  mv $TMPFILE.raw $TMPFILE"
+. $cmd_dir/run_e2fsck
+
+else
+	echo "$test_name: $test_description: skipped"
+fi
-- 
2.13.6 (Apple Git-96)
