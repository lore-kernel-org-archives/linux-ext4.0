From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: [PATCH] ext4: add checksum calculation when clearing UNINIT flag
Date: Fri, 07 Nov 2008 11:22:56 +0100
Message-ID: <1226053376.3542.8.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47734 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYKGKVX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 05:21:23 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 66C2A1A18DB
	for <linux-ext4@vger.kernel.org>; Fri,  7 Nov 2008 11:21:19 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 14658-09 for <linux-ext4@vger.kernel.org>;
 Fri,  7 Nov 2008 11:21:16 +0100 (CET)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 4DE2D1A18B2
	for <linux-ext4@vger.kernel.org>; Fri,  7 Nov 2008 11:21:16 +0100 (CET)
Received: from [129.183.101.223] (dhcp129183101223.frec.bull.fr [129.183.101.223])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id F3AE627289
	for <linux-ext4@vger.kernel.org>; Fri,  7 Nov 2008 11:21:12 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

Block group's checksum need to be re-calculated during the
initialization of an UNINIT'd group. This fix a race when several
threads try to allocate a new inode in an UNINIT'd group.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
---
 ialloc.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/fs/ext4/ialloc.c
===================================================================
--- linux.orig/fs/ext4/ialloc.c	2008-11-06 17:22:14.000000000 +0100
+++ linux/fs/ext4/ialloc.c	2008-11-07 10:43:41.000000000 +0100
@@ -718,6 +718,8 @@ got:
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 			free = ext4_free_blocks_after_init(sb, group, gdp);
 			gdp->bg_free_blocks_count = cpu_to_le16(free);
+			gdp->bg_checksum = ext4_group_desc_csum(sbi, group,
+								gdp);
 		}
 		spin_unlock(sb_bgl_lock(sbi, group));
--
 


