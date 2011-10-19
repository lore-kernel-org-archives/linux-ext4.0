From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 8/8] xfstests: add new quota stress test
Date: Wed, 19 Oct 2011 14:29:49 +0400
Message-ID: <1319020189-13584-9-git-send-email-dmonakhov@openvz.org>
References: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org,
	aelder@sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- Same as 264 but with quota enabled.
- IO performed from fsgqa user
- fsstress granted with CAP_CHOWN capability.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 265     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 265.out |    8 +++++
 group   |    1 +
 3 files changed, 116 insertions(+), 0 deletions(-)
 create mode 100755 265
 create mode 100644 265.out

diff --git a/265 b/265
new file mode 100755
index 0000000..c2a5379
--- /dev/null
+++ b/265
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FSQA Test No. 264
+#
+# Run fsstress and ENSPC hitters in parallel, check fs consistency an the end
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
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
+# creator
+owner=dmonakhov@openvz.org
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.quota
+
+# Disable all sync operations to get higher load
+FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0"
+UID_MODULO=10
+_workout()
+{
+	echo ""
+	echo "Run fsstress"
+	echo ""
+	num_iterations=10
+	enospc_time=2
+	out=$SCRATCH_MNT/fsstress.$$
+	args="-p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out"
+	echo "fsstress $args" >> $here/$seq.full
+	# Grant chown capability 
+	cp $FSSTRESS_PROG  $tmp.fsstress.bin
+	setcap cap_chown=epi  $tmp.fsstress.bin
+	sudo -u fsgqa CMD="$tmp.fsstress.bin $args" \
+		sh -c 'exec $CMD > /dev/null 2>&1' & \
+		eval 'pid=$!'
+
+	echo "Run dd writers in parallel"
+	for ((i=0; i < num_iterations; i++))
+	do
+		# File will be opened with O_TRUNC each time
+		sudo -u fsgqa \
+			CMD="dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M " \
+			sh -c 'exec $CMD > /dev/null 2>&1'
+		sleep $enospc_time
+	done
+	kill $pid
+	wait $pid
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_quota
+_require_user
+_need_to_be_root
+
+umount $SCRATCH_DEV 2>/dev/null
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seq.full 2>&1
+_scratch_mount "-o usrquota,grpquota"
+chmod 777 $SCRATCH_MNT
+quotacheck -u -g $SCRATCH_MNT 2>/dev/null
+quotaon -u -g $SCRATCH_MNT 2>/dev/null
+
+if ! _workout; then
+	_scratch_unmount 2>/dev/null
+	exit
+fi
+
+if ! _check_quota_usage; then
+	_scratch_unmount 2>/dev/null
+	status=1
+	exit
+fi
+
+echo Comparing filesystem consistency
+if ! _scratch_unmount; then
+	echo "failed to umount"
+	status=1
+	exit
+fi
+_check_scratch_fs
+status=$?
+exit
diff --git a/265.out b/265.out
new file mode 100644
index 0000000..7637291
--- /dev/null
+++ b/265.out
@@ -0,0 +1,8 @@
+QA output created by 265
+
+Run fsstress
+
+Run dd writers in parallel
+Comparing user usage
+Comparing group usage
+Comparing filesystem consistency
diff --git a/group b/group
index e79c29b..487051a 100644
--- a/group
+++ b/group
@@ -378,3 +378,4 @@ deprecated
 262 auto quick quota
 263 rw auto quick
 264 auto rw prealloc ioctl enospc
+265 auto quota rw prealloc ioctl enospc
-- 
1.7.1

