From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: speed up _require_ext4_bigalloc and _require_ext4_mkfs_bigalloc
Date: Sun,  7 Sep 2014 22:06:08 -0400
Message-ID: <1410141968-17551-2-git-send-email-tytso@mit.edu>
References: <20140907192110.GC1066@thunk.org>
 <1410141968-17551-1-git-send-email-tytso@mit.edu>
Cc: hch@infradead.org, linux-ext4@vger.kernel.org,
	wangxg.fnst@cn.fujitsu.com, eguan@redhat.com,
	Theodore Ts'o <tytso@mit.edu>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42837 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaIHCGV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Sep 2014 22:06:21 -0400
In-Reply-To: <1410141968-17551-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't need to make a full-sized file system in order to test
whether "mkfs.ext4 -O bigalloc" works.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 common/rc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 285bd7c..56e1847 100644
--- a/common/rc
+++ b/common/rc
@@ -1189,7 +1189,7 @@ _require_xfs_crc()
 #
 _require_ext4_mkfs_bigalloc()
 {
-	_scratch_mkfs_ext4 -O bigalloc >/dev/null 2>&1 \
+	$MKFS_EXT4_PROG -F -O bigalloc $SCRATCH_DEV 200k >/dev/null 2>&1 \
 	   || _notrun "mkfs.ext4 doesn't have bigalloc feature"
 }
 
@@ -1197,7 +1197,7 @@ _require_ext4_mkfs_bigalloc()
 #
 _require_ext4_bigalloc()
 {
-	_scratch_mkfs_ext4 -O bigalloc >/dev/null 2>&1
+	$MKFS_EXT4_PROG -F -O bigalloc $SCRATCH_DEV 200k >/dev/null 2>&1
 	_scratch_mount >/dev/null 2>&1 \
 	   || _notrun "Ext4 kernel doesn't support bigalloc feature"
 	umount $SCRATCH_MNT
-- 
2.1.0

