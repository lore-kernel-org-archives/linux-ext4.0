From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: [PATCH v2] ext4: fix initialization of UNINIT bitmap blocks
Date: Mon, 15 Sep 2008 14:16:47 +0200
Message-ID: <1221481007.6733.32.camel@frecb007923.frec.bull.fr>
References: <1221478895.6733.26.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34570 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYIOMQF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Sep 2008 08:16:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id E4A1A1A1D14
	for <linux-ext4@vger.kernel.org>; Mon, 15 Sep 2008 14:15:57 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 08736-10 for <linux-ext4@vger.kernel.org>;
 Mon, 15 Sep 2008 14:15:54 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id EF7201A18BF
	for <linux-ext4@vger.kernel.org>; Mon, 15 Sep 2008 14:15:21 +0200 (CEST)
Received: from [129.183.101.223] (dhcp129183101223.frec.bull.fr [129.183.101.223])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 7A72C2728D
	for <linux-ext4@vger.kernel.org>; Mon, 15 Sep 2008 14:15:19 +0200 (CEST)
In-Reply-To: <1221478895.6733.26.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

Do not rely on buffer head's uptodate flag to initialize
uninitialized bitmap blocks.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
---
Sorry there was a copy/paste error in the previous mail !

This patch makes sure to initialize uninited bitmap blocks.
These are two test cases where bugs appear because of uninited blocks :

1- This test case lead to uninited block bitmap and an error message
from the mballocator during the second dd.

dd if=/dev/urandom of=/dev/md0 bs=1M count=300
mkfs.ext4 -t ext4dev /dev/md0 1G
mount -t ext4dev /dev/md0 /mnt/test
resize2fs /dev/md0 2G
dd if=/dev/zero of=/mnt/test/dummy bs=1M count=1500

Note that the first dd is to make sure we have random garbage in the
uninited blocks. If not, you could miss the issue depending what was in
those blocks before running mkfs.

2- This test case lead to uninited inode bitmap blocks, making it
impossible to use all the inodes of the fs.

dd if=/dev/urandom of=/dev/md0 bs=1M count=20
mkfs.ext4 -t ext4dev /dev/md0 10M
mount -t ext4dev /dev/md0 /mnt/test
resize2fs /dev/md0 20M
for i in $(seq 1 3800); do touch /mnt/test/file${i} 2>&1; done

 balloc.c  |    4 +++-
 ialloc.c  |    4 +++-
 mballoc.c |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.27-rc5+patch_queue/fs/ext4/balloc.c
===================================================================
--- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/balloc.c	2008-09-15 10:59:27.000000000 +0200
+++ linux-2.6.27-rc5+patch_queue/fs/ext4/balloc.c	2008-09-15 14:03:04.000000000 +0200
@@ -318,9 +318,11 @@ ext4_read_block_bitmap(struct super_bloc
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+	if (buffer_uptodate(bh) &&
+	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
 		return bh;
 
+	lock_buffer(bh);
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		ext4_init_block_bitmap(sb, bh, block_group, desc);
Index: linux-2.6.27-rc5+patch_queue/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/ialloc.c	2008-09-15 10:59:27.000000000 +0200
+++ linux-2.6.27-rc5+patch_queue/fs/ext4/ialloc.c	2008-09-15 11:12:16.000000000 +0200
@@ -115,9 +115,11 @@ ext4_read_inode_bitmap(struct super_bloc
 			    block_group, bitmap_blk);
 		return NULL;
 	}
-	if (bh_uptodate_or_lock(bh))
+	if (buffer_uptodate(bh) &&
+	    !(desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)))
 		return bh;
 
+	lock_buffer(bh);
 	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
Index: linux-2.6.27-rc5+patch_queue/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.27-rc5+patch_queue.orig/fs/ext4/mballoc.c	2008-09-15 10:59:27.000000000 +0200
+++ linux-2.6.27-rc5+patch_queue/fs/ext4/mballoc.c	2008-09-15 14:02:44.000000000 +0200
@@ -785,9 +785,11 @@ static int ext4_mb_init_cache(struct pag
 		if (bh[i] == NULL)
 			goto out;
 
-		if (bh_uptodate_or_lock(bh[i]))
+		if (buffer_uptodate(bh[i]) &&
+		    !(desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)))
 			continue;
 
+		lock_buffer(bh[i]);
 		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			ext4_init_block_bitmap(sb, bh[i],

--

