From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests: avoid ext4/306 failures caused by incompatible
 mount options
Date: Wed, 29 Jan 2014 15:45:02 -0500
Message-ID: <20140129204502.GC2165@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:49119 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaA2UpI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jan 2014 15:45:08 -0500
Received: by mail-qc0-f173.google.com with SMTP id i8so3591353qcq.18
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jan 2014 12:45:08 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4/306 will fail when mounting the ext3 file system it creates if an
ext3-incompatible mount option is applied by _scratch_mount.  This can
happen if EXT_MOUNT_OPTIONS is defined appropriately in the test
environment.  For example, the block_validity option is commonly used
to enhance ext4 testing, and it is not supported by ext3.  Fix this by
not including any mount options defined by the test environment.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/ext4/306 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/ext4/306 b/tests/ext4/306
index 398c4c0..e59c8ed 100755
--- a/tests/ext4/306
+++ b/tests/ext4/306
@@ -52,9 +52,10 @@ grep -q ext3 /proc/filesystems || _notrun "This test requires ext3 support"
 
 rm -f $seqres.full
 
-# Make a small ext3 fs, (extents disabled) & mount it
+# Make a small ext3 fs, (extents disabled)
 yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
-_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
+# Mount it without _scratch_mount to avoid any ext3-incompatible mount options
+_mount -t ext3 $SCRATCH_DEV $SCRATCH_MNT || _fail "couldn't mount fs as ext3"
 # Create a small non-extent-based file
 echo "Create 1m testfile1"
 $XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
-- 
1.8.3.2

