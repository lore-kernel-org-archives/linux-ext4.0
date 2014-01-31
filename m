From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH v2] xfstests: avoid ext4/306 failures caused by incompatible
 mount options
Date: Fri, 31 Jan 2014 10:53:32 -0500
Message-ID: <20140131155332.GB2385@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:64620 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbaAaPxf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Jan 2014 10:53:35 -0500
Received: by mail-qc0-f171.google.com with SMTP id n7so7395084qcx.30
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jan 2014 07:53:35 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4/306 will fail when mounting the ext3 file system it creates if an
ext3-incompatible mount option is applied by _scratch_mount.  This can
happen if EXT_MOUNT_OPTIONS is defined appropriately in the test
environment.  For example, the block_validity option is commonly used
to enhance ext4 testing, and it is not supported by ext3.

Fix this by instead creating an ext4 file system without extents as a
functionally equivalent substitute.  This will also eliminate a
dependency for ext3 support on the test system.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/ext4/306 | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/tests/ext4/306 b/tests/ext4/306
index 398c4c0..9559cf2 100755
--- a/tests/ext4/306
+++ b/tests/ext4/306
@@ -45,29 +45,22 @@ _supported_os Linux
 
 _require_scratch
 
-# This needs to mount ext3; might require ext3 driver, or ext4
-# might handle it itself.  Find out if we have it one way or another.
-modprobe ext3 > /dev/null 2>&1
-grep -q ext3 /proc/filesystems || _notrun "This test requires ext3 support"
-
 rm -f $seqres.full
 
-# Make a small ext3 fs, (extents disabled) & mount it
-yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
-_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
+# Make a small ext4 fs with extents disabled & mount it
+yes | mkfs.ext4 -O ^extents $SCRATCH_DEV 512m >> $seqres.full 2>&1
+_scratch_mount || _fail "couldn't mount fs"
+
 # Create a small non-extent-based file
 echo "Create 1m testfile1"
 $XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
+
+# Create a large non-extent-based file filling the fs; this will run out & fail
 echo "Create testfile2 to fill the fs"
-# A large non-extent-based file filling the fs; this will run out & fail
 $XFS_IO_PROG -f $SCRATCH_MNT/testfile2 -c "pwrite 0 512m" | _filter_xfs_io
