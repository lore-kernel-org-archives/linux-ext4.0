From: <Solofo.Ramangalahy@bull.net>
Subject: [RFC 1/2] ext4 resize: Mark the added group with
 EXT4_BG_INODE_ZEROED flag
Date: Fri, 21 Nov 2008 11:23:10 +0100
Message-ID: <20081121102309.507553245@bull.net>
References: <20081121102309.182113793@bull.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57690 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbYKUKja (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 05:39:30 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 24A0C1A1C2D
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 11:39:29 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 05278-10 for <linux-ext4@vger.kernel.org>;
 Fri, 21 Nov 2008 11:39:25 +0100 (CET)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id DA18D1A1C2A
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 11:39:25 +0100 (CET)
Content-Disposition: inline;
 filename=SR-ext4-resize-mark-new-group-EXT_BG_INODE_ZEROED.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The inode table has been zeroed in setup_new_group_blocks().
Mark it as such in ext4_group_add().

As a side note, online resize and inode zeroing are "dual".

In order to obtain a filesystem with faster formating times one can
do:
. either format a smaller fs and then resize it,
. or format the fs with lazy_itable_init

---
 fs/ext4/resize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.28-rc4-itable_init/fs/ext4/resize.c
===================================================================
--- linux-2.6.28-rc4-itable_init.orig/fs/ext4/resize.c
+++ linux-2.6.28-rc4-itable_init/fs/ext4/resize.c
@@ -865,7 +865,7 @@ int ext4_group_add(struct super_block *s
 	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
 	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
