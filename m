From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4/271: improve mkfs and mount error handling
Date: Thu, 2 Oct 2014 16:32:48 -0400
Message-ID: <20141002203248.GB2364@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49009 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaJBUcz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2014 16:32:55 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If 271's attempt to make a scratch device fails, it can inadvertently
mount and run on a pre-existing scratch file system.  This can lead to
invalid test results unless the mkfs failure is separately noted in
271.full.

Noted while debugging an ext4 inline data test failure.  Small ext4 file
systems, as used by this test, use small inodes that are incompatible
with inline data.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/ext4/271 | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/ext4/271 b/tests/ext4/271
index e77ae57..44d9147 100755
--- a/tests/ext4/271
+++ b/tests/ext4/271
@@ -41,11 +41,14 @@ _supported_os Linux
 _need_to_be_root
 _require_scratch
 
-_scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seqres.full 2>&1
+rm -f $seqres.full
+
+_scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 
 # -onoload and EXT4_SYNC_FL on file is important becase result in
 # metadata sync writes inside ext4_handle_dirty_metadata()
-_scratch_mount -onoload
+_scratch_mount -onoload >> $seqres.full 2>&1 || _fail "mount failed"
 touch $SCRATCH_MNT/file
 chattr +S $SCRATCH_MNT/file
 # Create sparse file 
-- 
1.9.1

