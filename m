From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: [xfstests PATCH] generic: add test of file mode when setfacl fails
Date: Thu, 13 Jul 2017 06:40:04 -0300
Message-ID: <20170713094003.GA4959@debian.home>
References: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
 <20170712114719.GA14398@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org, fstests@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170712114719.GA14398@infradead.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Check that the group permission bits of a file are not altered when setfacl
fails. At the time of this patch the test fails for at least ext2, ext4 and
jfs. It is not run against reiserfs, since xfstests claims that "attrs are
not supported by this filesystem type".

The failure to set acls is induced by filling the device, so to save time
this should probably be run with a small TEST_DEV.

Note that this test is not meaningful for all filesystems, because some
will still succeed in setting the acls. This does not mean they don't have
a bug in how they would handle an error.

Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
---
 tests/generic/447     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/447.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 91 insertions(+)
 create mode 100755 tests/generic/447
 create mode 100644 tests/generic/447.out

diff --git a/tests/generic/447 b/tests/generic/447
new file mode 100755
index 0000000..b5fabd3
--- /dev/null
+++ b/tests/generic/447
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test 447
+#
+# Fill the device and set as many extended attributes to a file as
+# possible. Then call setfacl on it and, if this fails for lack of
+# space, test that the permissions remain the same.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Ernesto A. Fernandez.  All Rights Reserved.
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
+	cd $TEST_DIR
+	rm -f $TFILE
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_acls
+_require_attrs
+
+cd $TEST_DIR
+TFILE=testfile.$seq
+
+# Create the test file and choose its permissions
+rm -f $TFILE
+touch $TFILE
+chmod u+rwx $TFILE
+chmod go-rwx $TFILE
+
+# Try to run out of space so setfacl will fail
+yes xxxxxxxxxx &> $TFILE
+i=1
+while setfattr -n user.$i $TFILE &> /dev/null; do
+	((++i))
+done
+
+if setfacl -m m:r $TFILE &> /dev/null; then
+	# setfacl succeeded, so the test was meaningless
+	# The filesystem might still have an issue
+	status=0
+	echo "-rwx------"
+	exit
+fi
+
+# Since setfacl failed, the permissions should not have changed
+stat -c %A $TFILE
+
+status=0
+exit
diff --git a/tests/generic/447.out b/tests/generic/447.out
new file mode 100644
index 0000000..adec877
--- /dev/null
+++ b/tests/generic/447.out
@@ -0,0 +1,2 @@
+QA output created by 447
+-rwx------
diff --git a/tests/generic/group b/tests/generic/group
index 8c1e21a..f11d798 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -449,3 +449,4 @@
 444 auto quick acl
 445 auto quick rw
 446 auto quick rw dangerous
+447 acl
-- 
2.1.4


