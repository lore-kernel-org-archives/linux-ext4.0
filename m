From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH V2] ext4: FIBMAP ioctl causes BUG_ON due to handle
 EXT_MAX_BLOCKS
Date: Fri, 4 Apr 2014 08:02:58 +0000
Message-ID: <C26C67884C4B7A48980D574635594864E1B62A@BPXM20GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:51210 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDDIE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2014 04:04:26 -0400
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we try to get 2^32-1 block of the file which has the extent
(ee_block=2^32-2, ee_len=1) with FIBMAP ioctl, it causes BUG_ON
in ext4_ext_put_gap_in_cache().

To avoid the problem, ext4_map_blocks() needs to check the file logical block
number. ext4_ext_put_gap_in_cache() called via ext4_map_blocks() cannot
handle 2^32-1 because the maximum file logical block number is 2^32-2.

Note that ext4_ind_map_blocks() returns -EIO when the block number is invalid.
So ext4_map_blocks() should also return the same errno.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/inode.c |    4 ++++
 1 file changed, 4 insertions(+)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 24bfd7f..b0d5860 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -515,6 +515,10 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
 		  (unsigned long) map->m_lblk);
 
+	/* We can handle the block number less than EXT_MAX_BLOCKS */
+	if (unlikely(map->m_lblk >= EXT_MAX_BLOCKS))
+		return -EIO;
+
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
 		ext4_es_lru_add(inode);
