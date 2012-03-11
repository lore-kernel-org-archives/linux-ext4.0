From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: check for zero length extent
Date: Sun, 11 Mar 2012 16:46:31 -0400
Message-ID: <1331498791-2455-1-git-send-email-tytso@mit.edu>
Cc: merll@web.de, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40991 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab2CKUqe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 16:46:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Explicitly test for an extent whose length is zero, and flag that as a
corrupted extent.

This avoids a kernel BUG_ON assertion failure.

Tested: Without this patch, the file system image found in
tests/f_ext_zero_len/image.gz in the latest e2fsprogs sources causes a
kernel panic.  With this patch, an ext4 file systmem error is noted
instead, and the file system is marked as being corrupted.

https://bugzilla.kernel.org/show_bug.cgi?id=42859

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74f23c2..203885c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -300,6 +300,8 @@ static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
 	ext4_fsblk_t block = ext4_ext_pblock(ext);
 	int len = ext4_ext_get_actual_len(ext);
 
+	if (!len)
+		return 0;
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
 
-- 
1.7.9.107.g97f9a

