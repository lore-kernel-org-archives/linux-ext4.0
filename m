From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] generic: add fallocate() checks to generic/300
Date: Fri, 11 Apr 2014 17:43:07 -0400
Message-ID: <20140411214307.GC10174@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:64617 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaDKVnM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Apr 2014 17:43:12 -0400
Received: by mail-qa0-f54.google.com with SMTP id w8so5783489qac.41
        for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 14:43:11 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Generic/300 fails when run on a test filesystem that does not support
fallocate(). It uses fio's falloc ioengine to generate part of its I/O
load and both allocates blocks and punches holes.  This causes EOPNOTSUPP
failures when the test is run on indirect block-mapped ext4 filesystems
or pre-3.14 ext4 filesystems created with bigalloc.

Verify that the test filesystem supports fallocate() before proceeding
with the test, checking for both block allocation and hole punching
capabilities.  Also, delete any pre-existing test output.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/300 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tests/generic/300 b/tests/generic/300
index 7c60728..4e07f8a 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -44,6 +44,13 @@ _supported_os Linux
 _need_to_be_root
 _require_scratch
 
+# xfs_io is not required for this test, but it's the best way to verify
+# the test system supports fallocate() for allocation and hole punching
+_require_xfs_io_falloc
+_require_xfs_io_falloc_punch
+
+rm -f $seqres.full
+
 NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 if [ $((BLK_DEV_SIZE)) -gt 1048576 ]
-- 
1.8.3.2
