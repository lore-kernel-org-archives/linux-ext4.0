From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: use mkfs.ext4 -F instead of piping in yes
Date: Sun,  7 Sep 2014 08:29:02 -0400
Message-ID: <1410092942-22201-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42340 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaIGM3V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Sep 2014 08:29:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Using "yes | mkfs.ext4 ..." results in the error message results in
the test failing, at least for some versions of e2fsprogs:

    +yes: standard output: Broken pipe
    +yes: write error

It better to use the -F option, which will eliminate the questions.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Cc: Eryu Guan <eguan@redhat.com>
---
 tests/ext4/003 | 2 +-
 tests/ext4/306 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/ext4/003 b/tests/ext4/003
index 572e685..a2e9d75 100755
--- a/tests/ext4/003
+++ b/tests/ext4/003
@@ -43,7 +43,7 @@ _require_ext4_bigalloc
 
 rm -f $seqres.full
 
-yes | mkfs.ext4 -O bigalloc -C 65536  -g 256 $SCRATCH_DEV 512m \
+mkfs.ext4 -F -O bigalloc -C 65536  -g 256 $SCRATCH_DEV 512m \
 	>> $seqres.full 2>&1
 _scratch_mount || _fail "couldn't mount fs"
 
diff --git a/tests/ext4/306 b/tests/ext4/306
index fd50b0e..fd5c3a2 100755
--- a/tests/ext4/306
+++ b/tests/ext4/306
@@ -48,7 +48,7 @@ _require_scratch
 rm -f $seqres.full
 
 # Make a small ext4 fs with extents disabled & mount it
-yes | mkfs.ext4 -O ^extents,^64bit $SCRATCH_DEV 512m >> $seqres.full 2>&1
+mkfs.ext4 -F -O ^extents,^64bit $SCRATCH_DEV 512m >> $seqres.full 2>&1
 _scratch_mount || _fail "couldn't mount fs"
 
 # Create a small non-extent-based file
-- 
2.1.0

