From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: [PATCH] ext4: fix online resize group descriptors corruption
Date: Thu, 12 Jun 2008 11:42:34 +0200
Message-ID: <1213263754.6549.45.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42208 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYFLJmQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 05:42:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

This is the patch for the group descriptor table corruption during
online resize pointed out by Theodore Tso.
The issue was due to the ext4 group descriptor which can be either
32 or 64 bytes long.
Only the 64 bytes structure was taken into account.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
---
URL for the discussion about this issue: http://article.gmane.org/gmane.comp.file-systems.ext4/7226

The patch has been tested with linux-2.6.26-rc4-ext4-1 and
e2fsprogs-git-master-2008-06-07-365857912e27914afa8857af5adf74ee19ca9e03
under kvm and loopback device and without mballoc.

It has also been tested with linux-2.6.26-rc5, 
ext4-patch-queue-f245e945ae491e7931076706217b63d4bf0b5a1b
and e2fsprogs-365857912e27914afa8857af5adf74ee19ca9e03
with a physical hard disk and without mballoc

The patch does not correct the mballoc case (Oops in ext4_mb_release).
There is still an issue when resizing a flex_bg filesystem.

 resize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -rup a/fs/ext4/resize.c b/fs/ext4/resize.c
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -855,7 +855,8 @@ int ext4_group_add(struct super_block *s
 	 */
 
 	/* Update group descriptor block for new group */
-	gdp = (struct ext4_group_desc *)primary->b_data + gdb_off;
+	gdp = (struct ext4_group_desc *)(
+	       (__u8 *)primary->b_data + gdb_off * EXT4_DESC_SIZE(sb));
 
 	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
 	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */




