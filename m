From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] generic/015: improve error logging
Date: Tue, 30 Sep 2014 13:06:36 -0400
Message-ID: <20140930170636.GA5803@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:33404 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI3RGs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2014 13:06:48 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

015 currently discards useful diagnostic information should making or
mounting the scratch file system fail.  This can be captured with minimal
additional disk space consumption in a manner similar to other xfstests.
Noted during an ext4 debugging session involving a mkfs failure; small
ext4 file systems (as used in this test) by default use small inodes that
are not compatible with the inline data feature.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/generic/015 | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/generic/015 b/tests/generic/015
index 8d3fd5f..4d96b4e 100755
--- a/tests/generic/015
+++ b/tests/generic/015
@@ -53,11 +53,12 @@ _supported_os IRIX Linux
 _require_scratch
 _require_no_large_scratch_dev
 
-_scratch_mkfs_sized `expr 50 \* 1024 \* 1024` >/dev/null 2>&1 \
+rm -f $seqres.full
+
+_scratch_mkfs_sized `expr 50 \* 1024 \* 1024` >>$seqres.full 2>&1 \
     || _fail "mkfs failed"
-_scratch_mount || _fail "mount failed"
+_scratch_mount >>$seqres.full 2>&1 || _fail "mount failed"
 out=$SCRATCH_MNT/fillup.$$
-rm -f $seqres.full
 
 free0=`_free`
 if [ -z "$free0" ]
-- 
1.9.1

