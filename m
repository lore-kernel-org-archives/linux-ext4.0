From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH] ext4: Fix filesystem corruption on FS mounted with delalloc
Date: Wed, 02 Apr 2008 18:09:01 +0200
Message-ID: <1207152541.5677.4.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51099 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbYDBQDW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Apr 2008 12:03:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 4E6F71A01C5
	for <linux-ext4@vger.kernel.org>; Wed,  2 Apr 2008 18:03:43 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12367-04 for <linux-ext4@vger.kernel.org>;
 Wed,  2 Apr 2008 18:03:39 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 98EB21A018E
	for <linux-ext4@vger.kernel.org>; Wed,  2 Apr 2008 18:02:19 +0200 (CEST)
Received: from [127.0.0.1] (frecb000755.frec.bull.fr [129.183.101.79])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 8D27727289
	for <linux-ext4@vger.kernel.org>; Wed,  2 Apr 2008 18:02:16 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Fix filesystem corruption on FS mounted with delalloc

From: "Valerie Clement" <valerie.clement@bull.net>

This patch fixes a filesystem corruption issue when the filesystem is
mounted with the delalloc option and blocksize < pagesize.

In the  mpage_put_bnr_to_bhs() function, when skipping the first blocks
at the beginning of the first page, pblock should not be incremented,
otherwise the last blocks are corrupted. When writing into blocks at the
end of a group, the first blocks of the following group can be corrupted.
In that case, we've got the error message below:
EXT4-fs error (device sdc1): ext4_valid_block_bitmap: Invalid block bitmap -
block_group = 6233, block = 51060737 

(Issue found when using fsstress tool on ext4 FS with 1K blocksize)

Signed-off-by: Valerie Clement <valerie.clement@bull.net>

---
 mpage.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.25-rc6/fs/mpage.c
===================================================================
--- linux-2.6.25-rc6.orig/fs/mpage.c	2008-04-02 17:12:03.000000000 +0200
+++ linux-2.6.25-rc6/fs/mpage.c	2008-04-02 17:12:11.000000000 +0200
@@ -844,7 +844,6 @@ static void mpage_put_bnr_to_bhs(struct 
 				if (cur_logical >= logical)
 					break;
 				cur_logical++;
-				pblock++;
 			} while ((bh = bh->b_this_page) != head);
 
 			do {


