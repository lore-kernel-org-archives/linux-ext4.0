From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] xfstests, ext4: add project quota attribute tests
Date: Tue,  5 Jul 2016 15:56:31 +0900
Message-ID: <1467701791-14626-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sihara@ddn.com,
	lixi@ddn.com, wshilong@ddn.com
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

Some basic project quota inferface tests.

1. ioctl with/without project.
2. project inherit attribute.
3. Link accross project should fail
4. change project ignores quota

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 tests/ext4/030     | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/030.out |  11 ++++++
 tests/ext4/group   |   1 +
 3 files changed, 124 insertions(+)
 create mode 100755 tests/ext4/030
 create mode 100644 tests/ext4/030.out

diff --git a/tests/ext4/030 b/tests/ext4/030
new file mode 100755
index 0000000..06b3de8
--- /dev/null
+++ b/tests/ext4/030
@@ -0,0 +1,112 @@
+#! /bin/bash
+# FS QA Test No. 030
+#
+# Test Project quota attr function
+#
+#-----------------------------------------------------------------------
+# Copyright 2016 (C) Wang Shilong<wshilong@ddn.com>
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
+seqfull=$0
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
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+_require_chattr
+_require_attrs
+
+rm -f $seqres.full
+
+echo "+ create scratch fs"
+_scratch_mkfs_ext4 > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+
+function attr_test()
+{
+	#basic test with/without project
+	touch $SCRATCH_MNT/foo
+	lsattr -p $SCRATCH_MNT/foo | _filter_scratch | _filter_spaces
+	chattr -p 1 $SCRATCH_MNT/foo 2>&1 \
+				| _filter_scratch | _filter_spaces
+	mkdir $SCRATCH_MNT/dir
+	chattr +P $SCRATCH_MNT/dir | _filter_scratch | _filter_spaces
+	chattr -P $SCRATCH_MNT/dir | _filter_scratch | _filter_spaces
+
+	[ $1 -eq 0 ] && return
+
+	#default project without inherit
+	chattr -p 123456 $SCRATCH_MNT/dir | _filter_scratch | _filter_spaces
+	lsattr -p $SCRATCH_MNT/dir | _filter_scratch | _filter_spaces
+	touch $SCRATCH_MNT/dir/foo
+	lsattr -p $SCRATCH_MNT/dir/foo | _filter_scratch | _filter_spaces
+
+	#test project inherit with inherit attribute
+	chattr +P $SCRATCH_MNT/dir
+	touch $SCRATCH_MNT/dir/foo1
+	lsattr -p $SCRATCH_MNT/dir/foo1 | _filter_scratch | _filter_spaces
+
+	#Link accross project should fail
+	mkdir $SCRATCH_MNT/dir1
+	chattr +P $SCRATCH_MNT/dir1
+	chattr -p 654321 $SCRATCH_MNT/dir1 | _filter_scratch | _filter_spaces
+	ln $SCRATCH_MNT/dir/foo1 $SCRATCH_MNT/dir1/foo1 2>&1 \
+		| _filter_scratch | _filter_spaces
+
+	#mv accross different projects should work
+	mv $SCRATCH_MNT/dir/foo1 $SCRATCH_MNT/dir1/foo1
+	lsattr -p $SCRATCH_MNT/dir1/foo1 | _filter_scratch | _filter_spaces
+
+	#change project ignores quota
+	quotaon $SCRATCH_MNT
+	setquota -P 654321 0 0 0 1 $SCRATCH_MNT/
+	chattr -p 123456 $SCRATCH_MNT/dir1/foo1 | _filter_scratch | _filter_spaces
+	lsattr -p $SCRATCH_MNT/dir1/foo1 | _filter_scratch | _filter_spaces
+}
+#init without project quota enabled
+attr_test 0
+
+#enable project quota feature
+_scratch_unmount >/dev/null 2>&1
+tune2fs -O quota,project $SCRATCH_DEV >/dev/null 2>&1
+_scratch_mount
+
+rm -rf $SCRATCH_MNT/dir
+attr_test 1
diff --git a/tests/ext4/030.out b/tests/ext4/030.out
new file mode 100644
index 0000000..035d3c1
--- /dev/null
+++ b/tests/ext4/030.out
@@ -0,0 +1,11 @@
+QA output created by 030
++ create scratch fs
++ mount fs image
+ 0 --------------e---- SCRATCH_MNT/foo
+chattr: Operation not supported while setting project on SCRATCH_MNT/foo
+ 0 --------------e---- SCRATCH_MNT/foo
+ 0 --------------e---- SCRATCH_MNT/dir/foo
+123456 --------------e---P SCRATCH_MNT/dir/foo1
+ln: failed to create hard link 'SCRATCH_MNT/dir1/foo1' => 'SCRATCH_MNT/dir/foo1': Invalid cross-device link
+654321 --------------e---P SCRATCH_MNT/dir1/foo1
+123456 --------------e---P SCRATCH_MNT/dir1/foo1
diff --git a/tests/ext4/group b/tests/ext4/group
index bbdbe1d..f9c9ec3 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -24,6 +24,7 @@
 019 fuzzers
 020 auto quick ioctl rw
 021 auto quick
+030 auto quick
 271 auto rw quick
 301 aio auto ioctl rw stress
 302 aio auto ioctl rw stress
-- 
2.7.4
