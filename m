From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Wed,  6 Jul 2016 15:22:51 +0900
Message-ID: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sihara@ddn.com,
	lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

lsattr/chattr support both of ext4 and xfs, add
a test to cover both of them.

 1. ioctl with project quota.
 2. project inherit attribute.
 3. Link accross project should fail
 4. change project ignores quota

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 tests/generic/362     | 130 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/362.out |   8 ++++
 tests/generic/group   |   1 +
 3 files changed, 139 insertions(+)
 create mode 100755 tests/generic/362
 create mode 100644 tests/generic/362.out

diff --git a/tests/generic/362 b/tests/generic/362
new file mode 100755
index 0000000..f763bc5
--- /dev/null
+++ b/tests/generic/362
@@ -0,0 +1,130 @@
+#! /bin/bash
+# FS QA Test No. 030
+#
+# Test Project quota attr function
+#
+#-----------------------------------------------------------------------
+# Copyright 2016 (C) Wang Shilong <wshilong@ddn.com>
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
+. ./common/quota
+
+# real QA test starts here
+_supported_fs ext4 xfs
+_supported_os Linux
+
+_require_scratch
+_require_chattr
+_require_test_lsattr
+_require_quota
+
+rm -f $seqres.full
+MKFSOPTIONS=""
+MOUNTOPTIONS=""
+
+function setup_quota_options()
+{
+    case $FSTYP in
+    xfs)
+	#quotaon rely on this.
+	MOUNTOPTIONS="-o pquota"
+	;;
+    ext4)
+	#project quota is disabled in default.
+	MKFSOPTIONS="-O quota,project"
+	;;
+    *)
+        ;;
+    esac
+
+}
+
+function set_inherit_attribute()
+{
+    case $FSTYP in
+    xfs)
+	$XFS_IO_PROG -r -c 'chattr +P' $*
+	;;
+    ext4)
+	chattr +P $*
+	;;
+    *)
+        ;;
+    esac
+}
+
+setup_quota_options
+
+echo "+ create scratch fs"
+_scratch_mkfs $MKFSOPTIONS > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount $MOUNTOPTIONS
+
+function attr_test()
+{
+	#default project without inherit
+	mkdir $SCRATCH_MNT/dir
+	chattr -p 123456 $SCRATCH_MNT/dir | _filter_scratch | _filter_spaces
+	lsattr -p $SCRATCH_MNT/dir | _filter_scratch | $AWK_PROG '{print $1" "$3}'
+	touch $SCRATCH_MNT/dir/foo
+	lsattr -p $SCRATCH_MNT/dir/foo | _filter_scratch | $AWK_PROG '{print $1" "$3}'
+
+	#test project inherit with inherit attribute
+	set_inherit_attribute $SCRATCH_MNT/dir
+	touch $SCRATCH_MNT/dir/foo1
+	lsattr -p $SCRATCH_MNT/dir/foo1 | _filter_scratch | $AWK_PROG '{print $1" "$3}'
+
+	#Link accross project should fail
+	mkdir $SCRATCH_MNT/dir1
+	set_inherit_attribute $SCRATCH_MNT/dir1
+	chattr -p 654321 $SCRATCH_MNT/dir1 | _filter_scratch | _filter_spaces
+	ln $SCRATCH_MNT/dir/foo1 $SCRATCH_MNT/dir1/foo1 2>&1 \
+		| _filter_scratch | _filter_spaces
+
+	#mv accross different projects should work
+	mv $SCRATCH_MNT/dir/foo1 $SCRATCH_MNT/dir1/foo1
+	lsattr -p $SCRATCH_MNT/dir1/foo1 | _filter_scratch | $AWK_PROG '{print $1" "$3}'
+
+	#change project ignores quota
+	quotaon $SCRATCH_MNT >/dev/null 2>&1
+	setquota -P 654321 0 0 0 1 $SCRATCH_MNT/
+	chattr -p 123456 $SCRATCH_MNT/dir1/foo1 | _filter_scratch | _filter_spaces
+	lsattr -p $SCRATCH_MNT/dir1/foo1 | _filter_scratch | $AWK_PROG '{print $1" "$3}'
+}
+attr_test
diff --git a/tests/generic/362.out b/tests/generic/362.out
new file mode 100644
index 0000000..31db991
--- /dev/null
+++ b/tests/generic/362.out
@@ -0,0 +1,8 @@
+QA output created by 362
++ create scratch fs
++ mount fs image
+0 SCRATCH_MNT/dir/foo
+123456 SCRATCH_MNT/dir/foo1
+ln: failed to create hard link 'SCRATCH_MNT/dir1/foo1' => 'SCRATCH_MNT/dir/foo1': Invalid cross-device link
+654321 SCRATCH_MNT/dir1/foo1
+123456 SCRATCH_MNT/dir1/foo1
diff --git a/tests/generic/group b/tests/generic/group
index 7491282..e834762 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -364,3 +364,4 @@
 359 auto quick clone
 360 auto quick metadata
 361 auto quick
+362 auto quick
-- 
2.7.4
