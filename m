From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfstests: add another fallocate test to 214
Date: Mon, 04 Jan 2010 17:18:09 -0600
Message-ID: <4B427731.9080801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>
To: xfs mailing list <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab0ADXSN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jan 2010 18:18:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 had a regression where it double-accounted used blocks
if you fallocated on top of delalloc blocks.  Ted sent a
c program to exploit it (see "fsstress-induced corruption reproduced"
on linux-ext4 on 12/31/2009) and it's trivial to do the same thing
within the xfstests framework using xfs_io.

This also changes the handcrafted xfs_io tests to use the
_require_xfs_io_falloc helper, not sure how that got missed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/214 b/214
index 98cfc3a..35ec2cb 100755
--- a/214
+++ b/214
@@ -52,14 +52,7 @@ _supported_os Linux
 
 rm -f $seq.full
 
-testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $TEST_DIR/$tmp.io 2>&1`
-
-# Old xfs_io doesn't have fallocate support
-echo $testio | grep -q "not found" && \
-	_notrun "xfs_io fallocate support is missing"
-# Old glibc, old kernels, and some filesystems don't have fallocate support
-echo $testio | grep -q "Operation not supported" && \
-	_notrun "xfs_io fallocate command failed (old kernel? wrong fs?)"
+_require_xfs_io_falloc
 
 # Ok, off we go.
 
@@ -126,6 +119,20 @@ $XFS_IO_PROG -F -f -d				\
 
 rm -f $TEST_DIR/ouch
 
+# Reported by Ted Ts'o on linux-ext4, 12/31/2009
+# double-allocation on ext4 when fallocating over delalloc blocks
+# Regression due to d21cd8f163ac44b15c465aab7306db931c606908
+
+echo "=== delalloc write 16k; fallocate same range ==="
+# delalloc write 16k, fallocate same range.
+# Should get caught on fsck when we're done.
+
+$XFS_IO_PROG -F -f				\
+	-c "pwrite 0 16k"			\
+	-c "falloc 0 16k"			\
+	-c "fsync"				\
+	$TEST_DIR/ouch2 | _filter_xfs_io_unique
+
 # success, all done
 status=0
 exit

