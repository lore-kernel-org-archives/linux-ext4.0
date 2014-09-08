From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] ext4: speed up _require_ext4_bigalloc and _require_ext4_mkfs_bigalloc
Date: Mon,  8 Sep 2014 08:15:41 -0400
Message-ID: <1410178541-15192-1-git-send-email-tytso@mit.edu>
References: <20140908120213.GF1066@thunk.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	david@fromorbit.com, Theodore Ts'o <tytso@mit.edu>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43456 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbaIHMPz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Sep 2014 08:15:55 -0400
In-Reply-To: <20140908120213.GF1066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't need to make a full-sized file system in order to test
whether "mkfs.ext4 -O bigalloc" works.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 common/rc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 285bd7c..0baac86 100644
--- a/common/rc
+++ b/common/rc
@@ -1189,7 +1189,7 @@ _require_xfs_crc()
 #
 _require_ext4_mkfs_bigalloc()
 {
-	_scratch_mkfs_ext4 -O bigalloc >/dev/null 2>&1 \
+	$MKFS_EXT4_PROG -F -O bigalloc -n $SCRATCH_DEV 200k >/dev/null 2>&1 \
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

