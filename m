From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH V2] xfstests: only run generic/300 on filesystems supporting
 fallocate()
Date: Sat, 21 Sep 2013 18:02:47 -0400
Message-ID: <20130921220247.GE7855@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:62902 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3IUWCv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Sep 2013 18:02:51 -0400
Received: by mail-qc0-f180.google.com with SMTP id p19so1148568qcv.11
        for <linux-ext4@vger.kernel.org>; Sat, 21 Sep 2013 15:02:50 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Generic/300 fails when run on a test filesystem that does not support
fallocate(), as in the case of an ext4 filesystem created without the
extent feature or with the bigalloc feature.  It uses fio's falloc
ioengine to generate part of its I/O load, and both fallocates blocks
and punches holes.

Verify that the test filesystem supports fallocate() before proceeding
with the test, checking for both block allocation and hole punching
capabilities.  We need to use both _require_xfs_io_falloc and
_require_xfs_io_falloc_punch because the latter does not currently
test for block allocation support.  Also, delete any pre-existing test
output to avoid confusion with old results.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/300 | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tests/generic/300 b/tests/generic/300
index 7c60728..1bb2837 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -44,6 +44,17 @@ _supported_os Linux
 _need_to_be_root
 _require_scratch
 
+# For this test, the test system's glibc and kernel and the test file system
+# must support both fallocating and hole punching.  We don't need xfs_io to
+# perform the test, but we can use it to verify these preconditions.  For now,
+# this allows us to avoid duplicating the following functions for fio or other
+# applications that might be used to generate I/O at the cost of picking up a
+# minor dependency on xfsprogs.
+_require_xfs_io_falloc
+_require_xfs_io_falloc_punch
+
+rm -f $seqres.full
+
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 if [ $((BLK_DEV_SIZE)) -gt 1048576 ]
-- 
1.8.1.2

