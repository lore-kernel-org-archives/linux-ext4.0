From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] generic/226: improve mkfs and mount error handling
Date: Thu, 2 Oct 2014 16:34:55 -0400
Message-ID: <20141002203455.GC2364@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:50356 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaJBUe7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2014 16:34:59 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If 226's attempt to make a scratch device fails, it can inadvertently
mount and run on a pre-existing scratch file system.  This can lead to
invalid test results unless the mkfs failure is separately noted in
226.full.

Noted while debugging an ext4 inline data test failure.  Small ext4 file
systems, as used by this test, use small inodes that are incompatible
with inline data.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/226 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/generic/226 b/tests/generic/226
index b98e889..44b60ff 100755
--- a/tests/generic/226
+++ b/tests/generic/226
@@ -43,8 +43,9 @@ rm -f $seqres.full
 
 umount $SCRATCH_DEV 2>/dev/null
 echo "--> mkfs 256m filesystem"
-_scratch_mkfs_sized `expr 256 \* 1024 \* 1024` >> $seqres.full 2>&1
-_scratch_mount
+_scratch_mkfs_sized `expr 256 \* 1024 \* 1024` >> $seqres.full 2>&1 \
+	|| _fail "mkfs failed"
+_scratch_mount >> $seqres.full 2>&1 || _fail "mount failed"
 
 loops=16
 
-- 
1.9.1

