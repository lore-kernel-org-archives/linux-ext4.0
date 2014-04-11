From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] generic: add fallocate() check to generic/311
Date: Fri, 11 Apr 2014 17:46:23 -0400
Message-ID: <20140411214623.GD10174@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:42026 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbaDKVq2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Apr 2014 17:46:28 -0400
Received: by mail-qg0-f41.google.com with SMTP id z60so1249901qgd.14
        for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 14:46:27 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Generic/311 fails when run on a test filesystem that does not support
fallocate().  Its I/O load is produced by fsync-tester, which uses
fallocate() system calls to allocate blocks for some of its test cases.
This causes EOPNOTSUPP failures when the test is run on indirect
block-mapped ext4 filesystems.

Verify that the test filesystem supports fallocate() before proceeding
with the test, checking for block allocation capabilities.  Also, fix a
minor error message typo.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/311 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 tests/generic/311

diff --git a/tests/generic/311 b/tests/generic/311
old mode 100644
new mode 100755
index 6802a96..284b59d
--- a/tests/generic/311
+++ b/tests/generic/311
@@ -57,7 +57,11 @@ _need_to_be_root
 _require_scratch
 _require_dm_flakey
 
-[ -x $here/src/fsync-tester ] || _notrun "fsync-tester not build"
+# xfs_io is not required for this test, but it's the best way to verify
+# the test system supports fallocate() for allocation
+_require_xfs_io_falloc
+
+[ -x $here/src/fsync-tester ] || _notrun "fsync-tester not built"
 
 rm -f $seqres.full
 SEED=1
-- 
1.8.3.2
