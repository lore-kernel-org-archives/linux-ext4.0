From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/27] contrib: add script to help resync journal code with
 kernel
Date: Sat, 16 Aug 2014 16:46:35 -0700
Message-ID: <20140816234635.11171.50609.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23864 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaHPXqj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:46:39 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a script that handles (most) of the code massaging necessary to resync
{recovery,revoke}.c from the Linux kernel into e2fsprogs.

Usage: jbd2-resync.sh linux/fs/jbd2/revoke.c e2fsprogs/e2fsck/revoke.c

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 contrib/jbd2-resync.sh |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100755 contrib/jbd2-resync.sh


diff --git a/contrib/jbd2-resync.sh b/contrib/jbd2-resync.sh
new file mode 100755
index 0000000..4133b63
--- /dev/null
+++ b/contrib/jbd2-resync.sh
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+if [ -z "$1" -o -z "$2" ]; then
+	echo "Usage: $0 kernel-file e2fsprogs-file"
+	exit 0
+fi
+
+# Transform a few things to fit the compatibility things defined in jfs_user.h.
+# Use the ext2fs_ endian conversion functions because they truncate oversized
+# inputs (e.g. passing a u32 to cpu_to_be16()) like the kernel versions and
+# unlike the libc6 versions.
+exec sed -e 's/JBD_/JFS_/g' \
+	 -e 's/JBD2_/JFS_/g' \
+	 -e 's/jbd2_journal_/journal_/g' \
+	 -e 's/__be/__u/g' \
+	 -e 's/struct kmem_cache/lkmem_cache_t/g' \
+	 -e 's/cpu_to_be/ext2fs_cpu_to_be/g' \
+	 -e 's/be\([0-9][0-9]\)_to_cpu/ext2fs_be\1_to_cpu/g' \
+	 < "$1" > "$2"

