From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] Fix compile error in ext4_fallocate()
Date: Wed, 08 Sep 2010 14:54:14 +0900
Message-ID: <4C872506.6040505@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:38542 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0IHF4u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Sep 2010 01:56:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When I compiled 2.6.36-rc3 kernel with EXT4FS_DEBUG definition, I got the
following compile error.

  CC [M]  fs/ext4/extents.o
fs/ext4/extents.c: In function 'ext4_fallocate':
fs/ext4/extents.c:3772: error: 'block' undeclared (first use in this function)
fs/ext4/extents.c:3772: error: (Each undeclared identifier is reported only once
fs/ext4/extents.c:3772: error: for each function it appears in.)
make[2]: *** [fs/ext4/extents.o] Error 1

The patch fixes this problem.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8202784..590caa3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3769,7 +3769,7 @@ retry:
 			printk(KERN_ERR "%s: ext4_ext_map_blocks "
 				    "returned error inode#%lu, block=%u, "
 				    "max_blocks=%u", __func__,
-				    inode->i_ino, block, max_blocks);
+				    inode->i_ino, map.m_lblk, max_blocks);
 #endif
 			ext4_mark_inode_dirty(handle, inode);
 			ret2 = ext4_journal_stop(handle);
