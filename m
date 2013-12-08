From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v4 6/10] xfstest: shared/002: Delayed allocation collapse range
Date: Sun,  8 Dec 2013 23:12:06 +0900
Message-ID: <1386511926-3862-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
	tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This testcase(002) tries to test various corner cases with delayed extents
for fcollapse range functionality over different type of extents.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/shared/002     |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/002.out |   53 ++++++++++++++++++++++++++++++++++++++++
 tests/shared/group   |    1 +
 3 files changed, 119 insertions(+)
 create mode 100755 tests/shared/002
 create mode 100644 tests/shared/002.out

diff --git a/tests/shared/002 b/tests/shared/002
new file mode 100755
index 0000000..54b957d
--- /dev/null
+++ b/tests/shared/002
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 2
+#
+# Delayed allocation collapse range tests
+# This testcase is one of the 4 testcases (shared 001 - 004) which tries to
+# test various corner cases for fcollapse range functionality over different
+# type of extents. These tests are based on generic/255 test case.
+# For the type of tests, check the description of _test_generic_punch
+# in common/rc.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+# we need to include common/punch to get defination fo filter functions
+. ./common/rc
+. ./common/filter
+. ./common/punch
+
+# real QA test starts here
+_supported_fs xfs ext4
+_supported_os Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_falloc
+_require_xfs_io_fiemap
+_require_xfs_io_falloc_collapse
+
+testfile=$TEST_DIR/$seq.$$
+
+_test_generic_punch -d falloc fpunch fcollapse fiemap _filter_hole_fiemap $testfile
+_check_test_fs
+
+status=0
+exit
diff --git a/tests/shared/002.out b/tests/shared/002.out
new file mode 100644
index 0000000..14c239c
--- /dev/null
+++ b/tests/shared/002.out
@@ -0,0 +1,53 @@
+QA output created by 002
+	1. into a hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	2. into allocated space
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
+	3. into unwritten space
+0: [0..95]: extent
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	4. hole -> data
+0: [0..31]: hole
+1: [32..63]: extent
+2: [64..95]: hole
+d8f51c20223dbce5c7c90db87bc221b0
+	5. hole -> unwritten
+0: [0..31]: hole
+1: [32..63]: extent
+2: [64..95]: hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	6. data -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	7. data -> unwritten
+0: [0..63]: extent
+1: [64..95]: hole
+f07217d5ac7ffa15dd8910c4aa912674
+	8. unwritten -> hole
+0: [0..31]: extent
+1: [32..95]: hole
+f4f35d60b3cc18aaa6d8d92f0cd3708a
+	9. unwritten -> data
+0: [0..63]: extent
+1: [64..95]: hole
+d8f51c20223dbce5c7c90db87bc221b0
+	10. hole -> data -> hole
+bb7df04e1b0a2570657527a7e108ae23
+	11. data -> hole -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	12. unwritten -> data -> unwritten
+0: [0..63]: extent
+bb7df04e1b0a2570657527a7e108ae23
+	13. data -> unwritten -> data
+0: [0..63]: extent
+0f0151cbed83e4bf6e5bde26e82ab115
+	14. data -> hole @ EOF
+fallocate: Invalid argument
+0: [0..159]: extent
+7670f4830c6724a25e7c22d9eb9a6f4f
+	15. data -> hole @ 0
+0: [0..95]: extent
+f1894a71ac539f6f90426d98a4990a47
diff --git a/tests/shared/group b/tests/shared/group
index 5562f92..7230b28 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -4,6 +4,7 @@
 # - comment line before each group is "new" description
 #
 001 auto prealloc
+002 auto prealloc
 032 mkfs auto quick
 051 acl udf auto quick
 218 auto fsr quick
-- 
1.7.9.5
