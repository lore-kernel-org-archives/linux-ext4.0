From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsprogs: remove leftover retval check
Date: Tue, 15 Mar 2011 12:58:38 +0100
Message-ID: <1300190318-23164-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200Ab1COL65 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2011 07:58:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Remove leftover retval check from the read_bitmaps(). It is not
necessary as it is not previously set by any function, moreover the
retval value is not initialized in definition which may cause errors
when garbage data appears in it.

Also initialize retval to zero in definition.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/rw_bitmaps.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index d6f35fd..086d4b7 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -33,7 +33,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	unsigned int	j;
 	int		block_nbytes, inode_nbytes;
 	unsigned int	nbits;
-	errcode_t	retval;
+	errcode_t	retval = 0;
 	char 		*block_buf, *inode_buf;
 	int		csum_flag = 0;
 	blk64_t		blk;
@@ -159,8 +159,6 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		csum_flag = 1;
 
-	if (retval)
-		return retval;
 	if (do_block) {
 		if (fs->block_map)
 			ext2fs_free_block_bitmap(fs->block_map);
-- 
1.7.4

