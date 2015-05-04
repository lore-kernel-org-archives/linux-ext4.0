From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext4: check for zero length extent explicitly
Date: Mon,  4 May 2015 18:14:28 +0800
Message-ID: <1430734468-31785-1-git-send-email-guaneryu@gmail.com>
Cc: tytso@mit.edu, Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34728 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbEDKPl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2015 06:15:41 -0400
Received: by pdbqa5 with SMTP id qa5so159102782pdb.1
        for <linux-ext4@vger.kernel.org>; Mon, 04 May 2015 03:15:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following commit introduced a bug when checking for zero length extent

5946d08 ext4: check for overlapping extents in ext4_valid_extent_entries()

Zero length extent could pass the check if lblock is zero.

Adding the explicit check for zero length back.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

This is uncovered by recent updates for encryption, catting a file with zero
length extent results in infinite loop ext4_mpage_readpages(), and process
cannot be killed either.

Tested with corrupted ext4 image in e2fsprogs sources, cat returned EIO
correctly

tests/f_ext_zero_len/image.gz

 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d74e0802..451b92a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -377,7 +377,7 @@ static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
 	ext4_lblk_t lblock = le32_to_cpu(ext->ee_block);
 	ext4_lblk_t last = lblock + len - 1;
 
-	if (lblock > last)
+	if (len == 0 || lblock > last)
 		return 0;
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
-- 
1.8.3.1

