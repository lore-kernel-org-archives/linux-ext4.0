From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] ext4: page_cache pages not released in ext4_mb_load_buddy()
Date: Wed, 24 Mar 2010 22:21:01 +0800
Message-ID: <ac8f92701003240721l7a7079dnd9cbd55526cd1788@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57428 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab0CXO1J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 10:27:09 -0400
Received: by gyg8 with SMTP id 8so3717005gyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 07:27:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Wed Mar 24 20:38:48     2010

If ext4_mb_init_cache() returns error, there is no page_cache_release() issued.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc-9.c	2010-03-24 22:24:56.000000000 +0800
@@ -1132,8 +1132,6 @@ repeat_load_buddy:
 	e4b->bd_buddy = page_address(page) + (poff * sb->s_blocksize);
 	mark_page_accessed(page);

-	BUG_ON(e4b->bd_bitmap_page == NULL);
-	BUG_ON(e4b->bd_buddy_page == NULL);

 	return 0;

@@ -1142,6 +1140,8 @@ err:
 		page_cache_release(e4b->bd_bitmap_page);
 	if (e4b->bd_buddy_page)
 		page_cache_release(e4b->bd_buddy_page);
+	if (page)
+		page_cache_release(page);
 	e4b->bd_buddy = NULL;
 	e4b->bd_bitmap = NULL;
