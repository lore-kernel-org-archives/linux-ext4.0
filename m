From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 35/37] tests: enable using fuse2fs with metadata checksum
 test
Date: Thu, 01 May 2014 16:16:16 -0700
Message-ID: <20140501231616.31890.76143.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29180 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaEAXQV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:16:21 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create custom mount/umount commands so that we can run the metadata
checksumming tests against fuse2fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/fuse2fs/mount  |   28 ++++++++++++++++++++++++++++
 tests/fuse2fs/umount |   21 +++++++++++++++++++++
 2 files changed, 49 insertions(+)
 create mode 100755 tests/fuse2fs/mount
 create mode 100755 tests/fuse2fs/umount


diff --git a/tests/fuse2fs/mount b/tests/fuse2fs/mount
new file mode 100755
index 0000000..321b1f5
--- /dev/null
+++ b/tests/fuse2fs/mount
@@ -0,0 +1,28 @@
+#!/bin/bash
+
+# Mount ext4 via fuse.  Put tests/fuse2fs/ at the start of PATH if you want
+# to run the metadata checksumming tests with fuse2fs.
+
+for arg in "$@"; do
+	if [ -b "${arg}" ]; then
+		DEV="${arg}"
+	elif [ -d "${arg}" ]; then
+		MNT="${arg}"
+	fi
+done
+
+if [ -z "${DEV}" -o -z "${MNT}" ]; then
+	echo "Please specify a device and a mountpoint."
+fi
+
+DIR="$(readlink -f "$(dirname "$0")")"
+if [ -n "${FUSE2FS_DEBUG}" ]; then
+	"${DIR}/../../misc/fuse2fs" "${DEV}" "${MNT}" -d >> "${FUSE2FS_DEBUG}" 2>&1 &
+	sleep 1
+	exit 0
+else
+	"${DIR}/../../misc/fuse2fs" "${DEV}" "${MNT}"
+	ERR=$?
+	sleep 1
+	exit "${ERR}"
+fi
diff --git a/tests/fuse2fs/umount b/tests/fuse2fs/umount
new file mode 100755
index 0000000..b21ee5a
--- /dev/null
+++ b/tests/fuse2fs/umount
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# unmount a filesystem
+sync
+sync
+sync
+
+sleep 2
+if [ -x /bin/umount ]; then
+	/bin/umount "$@"
+	ERR=$?
+elif [ -x /sbin/umount ]; then
+	/sbin/umount "$@"
+	ERR=$?
+else
+	echo "Where is umount?"
+	exit 5
+fi
+sleep 1
+
+exit "${ERR}"

