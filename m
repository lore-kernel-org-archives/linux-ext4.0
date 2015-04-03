From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 3/4] shared: test truncate orphan inodes when mounting extN
Date: Fri,  3 Apr 2015 15:18:02 +0800
Message-ID: <1428045482-10722-1-git-send-email-eguan@redhat.com>
References: <1428045351-10446-1-git-send-email-eguan@redhat.com>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1428045351-10446-1-git-send-email-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4 should hold i_mutex when truncating orhpan inodes, or a WARNING
would be triggered. This commit fixed this issue.

721e3eb ext4: lock i_mutex when truncating orphan inodes

Though it's an ext4 specific issue, there's no harm to test on ext2/3
too, as debugfs is used to set orphan inode list.

This test is based on a script from Lukas Czerner.

Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2:
- fix wrong seq number at the beginning of the test

 tests/shared/001     | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/001.out |  2 ++
 tests/shared/group   |  1 +
 3 files changed, 74 insertions(+)
 create mode 100755 tests/shared/001
 create mode 100644 tests/shared/001.out

diff --git a/tests/shared/001 b/tests/shared/001
new file mode 100755
index 0000000..49991fd
--- /dev/null
+++ b/tests/shared/001
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FS QA Test No. 001
+#
+# Test truncate orphan inodes when mounting extN.
+# ext4 used to hit WARNING, this commit fixed the issue
+#
+# 721e3eb ext4: lock i_mutex when truncating orphan inodes
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs ext2 ext3 ext4
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+echo "Silence is golden"
+
+_scratch_mkfs_sized $((16*1024*1024)) >>$seqres.full 2>&1
+_scratch_mount
+
+# create a file and get its inode number, usually it's 12, but to be accurate
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+inode=`ls -i $testfile | awk '{print $1}'`
+
+# add the inode in orphan inode list
+_scratch_unmount
+debugfs -w -R "set_super_value last_orphan $inode" $SCRATCH_DEV \
+	>>$seqres.full 2>&1
+
+# mount again to truncate orphan inode, _check_dmesg will catch the WARNING
+_scratch_mount
+
+status=0
+exit
diff --git a/tests/shared/001.out b/tests/shared/001.out
new file mode 100644
index 0000000..88678b8
--- /dev/null
+++ b/tests/shared/001.out
@@ -0,0 +1,2 @@
+QA output created by 001
+Silence is golden
diff --git a/tests/shared/group b/tests/shared/group
index 429f2b4..0134f81 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -3,6 +3,7 @@
 # - do not start group names with a digit
 # - comment line before each group is "new" description
 #
+001 auto quick
 006 auto enospc
 032 mkfs auto quick
 051 acl udf auto quick
-- 
1.8.3.1

