From: Jeff Layton <jlayton@redhat.com>
Subject: [xfstests PATCH v3 3/5] generic: test writeback error handling on dmerror devices
Date: Wed, 31 May 2017 09:08:18 -0400
Message-ID: <20170531130820.17634-4-jlayton@redhat.com>
References: <20170531130820.17634-1-jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net, dhowells@redhat.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531130820.17634-1-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ensure that we get an error back on all fds when a block device is
open by multiple writers and writeback fails.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 tests/generic/998     | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/998.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 67 insertions(+)
 create mode 100755 tests/generic/998
 create mode 100644 tests/generic/998.out

diff --git a/tests/generic/998 b/tests/generic/998
new file mode 100755
index 000000000000..fbadb47507c2
--- /dev/null
+++ b/tests/generic/998
@@ -0,0 +1,64 @@
+#! /bin/bash
+# FS QA Test No. 998
+#
+# Test writeback error handling when writing to block devices via pagecache.
+# See src/fsync-err.c for details of what test actually does.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Jeff Layton <jlayton@redhat.com>
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.* $testdir
+    _dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmerror
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch
+_require_logdev
+_require_dm_target error
+_require_test_program fsync-err
+
+rm -f $seqres.full
+
+$XFS_IO_PROG -d -c "pwrite -S 0x7c -b 1048576 0 $((64 * 1048576))" $SCRATCH_DEV >> $seqres.full
+_dmerror_init
+
+$here/src/fsync-err $DMERROR_DEV
+
+# success, all done
+_dmerror_load_working_table
+_dmerror_cleanup
+_scratch_mkfs > $seqres.full 2>&1
+status=0
+exit
diff --git a/tests/generic/998.out b/tests/generic/998.out
new file mode 100644
index 000000000000..658c438820e2
--- /dev/null
+++ b/tests/generic/998.out
@@ -0,0 +1,2 @@
+QA output created by 998
+Test passed!
diff --git a/tests/generic/group b/tests/generic/group
index 39f7b14657f1..9fc384363ca7 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -440,4 +440,5 @@
 435 auto encrypt
 436 auto quick rw
 437 auto quick
+998 auto quick
 999 auto quick
-- 
2.9.4
