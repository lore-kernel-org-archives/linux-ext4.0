From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: invalidate gap cache when writing extents last block
Date: Fri, 13 May 2011 08:36:56 +0200
Message-ID: <1305268616-5167-1-git-send-email-lczerner@redhat.com>
References: <alpine.LFD.2.00.1105130829160.3768@dhcp-27-109.brq.redhat.com>
Cc: tytso@mit.edu, k-mio@sx.jp.nec.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab1EMGhE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 May 2011 02:37:04 -0400
In-Reply-To: <alpine.LFD.2.00.1105130829160.3768@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kazuya Mio reported that he was able to hit BUG_ON(next == lblock)
in ext4_ext_put_gap_in_cache() while creating a sparse file in extent
format and fill the tail of file up to its end. We will hit the BUG_ON
when we write the last block (2^32-1) into the sparse file.

That is because due to defensive programming we planted a lot of
BUG_ON's to prevent the length of the gap cache to be zero, but in this
case it actually will be zero, because there will be no gap at the end
of the file.

We could fix that as Kazuya Mio suggested by lowering the max file size
of extent format file by one block. But I do not think this is necessary
and we should rather fix the BUG_ON's to allow invalidating the gap
cache by setting its lenght to zero and this is what this commit is
doing.

The bug which this commit fixes can be reproduced as follows:

 dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-2))
 sync
 dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-1))

Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4890d6f..779ca49 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1944,7 +1944,6 @@ ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
 			__u32 len, ext4_fsblk_t start)
 {
 	struct ext4_ext_cache *cex;
-	BUG_ON(len == 0);
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	cex = &EXT4_I(inode)->i_cached_extent;
 	cex->ec_block = block;
@@ -1991,7 +1990,7 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 				le32_to_cpu(ex->ee_block),
 				ext4_ext_get_actual_len(ex),
 				block);
-		BUG_ON(next == lblock);
+		BUG_ON((next == lblock) && (next != EXT_MAX_BLOCK));
 		len = next - lblock;
 	} else {
 		lblock = len = 0;
-- 
1.7.4.4

