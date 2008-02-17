From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/3] ext2: improve ext2_readdir() return value
Date: Sun, 17 Feb 2008 14:56:13 +0900
Message-ID: <20080217055612.GA3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:63866 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYBQGCd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:02:33 -0500
Received: by rv-out-0910.google.com with SMTP id k20so921233rvb.1
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:02:32 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch improves ext2_readdir() return value for ext2_get_page() failure
by using the actual result of ext2_get_page().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ext2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-rc/fs/ext2/dir.c
===================================================================
--- 2.6-rc.orig/fs/ext2/dir.c
+++ 2.6-rc/fs/ext2/dir.c
@@ -299,7 +299,7 @@ ext2_readdir (struct file * filp, void *
 				   "bad page in #%lu",
 				   inode->i_ino);
 			filp->f_pos += PAGE_CACHE_SIZE - offset;
-			return -EIO;
+			return PTR_ERR(page);
 		}
 		kaddr = page_address(page);
 		if (unlikely(need_revalidate)) {
