From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2] xfstests: add a new test case for ext4 indirect-based file
Date: Tue, 19 Mar 2013 16:53:03 +0800
Message-ID: <1363683183-7392-1-git-send-email-wenqing.lz@taobao.com>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42569 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933803Ab3CSIhp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 04:37:45 -0400
Received: by mail-pb0-f52.google.com with SMTP id ma3so238817pbc.39
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 01:37:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After applied this commit (864688d3), xfstests #255 will not test a
file system that cannot support fallocate(2), such as a indirect-based
file in ext4.  So we need to add a new generic test case to test it.

The difference between #255 and this test case is only to use pwrite to
allocate blocks.  Other filesystems should survive in this test case.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
v2 <- v1:
 * rebase against the latest master branch of xfstests

Here [1] is the original patch set.  It has been splitted into two parts.
In ohter parts, it will tries to improve seek data/hole test case.

1. http://www.spinics.net/lists/xfs/msg16234.html

 314     |  68 ++++++++++++++
 314.out | 307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 group   |   1 +
 3 files changed, 376 insertions(+)
 create mode 100755 314
 create mode 100644 314.out

diff --git a/314 b/314
new file mode 100755
index 0000000..9a75857
--- /dev/null
+++ b/314
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test No. 314
+#
+# Test Generic fallocate hole punching w/o unwritten extent
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Alibaba Group.  All Rights Reserved.
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
+#-----------------------------------------------------------------------
+#
+# creator
+owner=wenqing.lz@taobao.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.punch
+
+# real QA test starts here
+_supported_fs generic
+_supported_os IRIX Linux
+
+_require_xfs_io_falloc_punch
+_require_xfs_io_fiemap
+
+testfile=$TEST_DIR/314.$$
+
+# Standard punch hole tests
+_test_generic_punch pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# Delayed allocation punch hole tests
+_test_generic_punch -d pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# Multi hole punch tests
+_test_generic_punch -k pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# Delayed allocation multi punch hole tests
+_test_generic_punch -d -k pwrite fpunch fpunch fiemap _filter_hole_fiemap $testfile -F
+
+# success, all done
+status=0
+exit
diff --git a/314.out b/314.out
new file mode 100644
index 0000000..2eb1f27
--- /dev/null
+++ b/314.out
@@ -0,0 +1,307 @@
+QA output created by 314
+	1. into a hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	6. data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+5309cc2f1fc5a7f94cf52915caef35bd
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+5309cc2f1fc5a7f94cf52915caef35bd
+	10. hole -> data -> hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
+	1. into a hole
+daa100df6e6711906b61c9ab5aa16032
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	5. hole -> unwritten
+0: [0..23]: hole
+1: [24..31]: extent
+2: [32..39]: hole
+cc63069677939f69a6e8f68cae6a6dac
+	6. data -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+5309cc2f1fc5a7f94cf52915caef35bd
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..39]: hole
+1b3779878366498b28c702ef88c4a773
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..31]: extent
+3: [32..39]: hole
+5309cc2f1fc5a7f94cf52915caef35bd
+	10. hole -> data -> hole
+daa100df6e6711906b61c9ab5aa16032
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
+	1. into a hole
+0: [0..7]: extent
+1: [8..39]: hole
+5a58e46082be047d0f13bee7974015b9
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
+	1. into a hole
+0: [0..7]: extent
+1: [8..39]: hole
+5a58e46082be047d0f13bee7974015b9
+	2. into allocated space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	3. into unwritten space
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	4. hole -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	5. hole -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	6. data -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	7. data -> unwritten
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	8. unwritten -> hole
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	9. unwritten -> data
+0: [0..7]: extent
+1: [8..23]: hole
+2: [24..39]: extent
+cc58a7417c2d7763adc45b6fcd3fa024
+	10. hole -> data -> hole
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	11. data -> hole -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	12. unwritten -> data -> unwritten
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	13. data -> unwritten -> data
+0: [0..7]: extent
+1: [8..31]: hole
+2: [32..39]: extent
+f6aeca13ec49e5b266cd1c913cd726e3
+	14. data -> hole @ EOF
+0: [0..23]: extent
+1: [24..39]: hole
+e1f024eedd27ea6b1c3e9b841c850404
+	15. data -> hole @ 0
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	16. data -> cache cold ->hole
+0: [0..15]: hole
+1: [16..39]: extent
+eecb7aa303d121835de05028751d301c
+	17. data -> hole in single block file
+0: [0..7]: extent
+13535fd4d496bf0b74bb2335aa4d1b31
diff --git a/group b/group
index a11e832..36f63ab 100644
--- a/group
+++ b/group
@@ -431,3 +431,4 @@ stress
 305 aio dangerous enospc rw stress
 306 auto quick rw
 313 auto quick
+314 auto quick prealloc
-- 
1.7.12.rc2.18.g61b472e

