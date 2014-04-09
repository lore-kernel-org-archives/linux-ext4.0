From: Younger Liu <younger.liucn@gmail.com>
Subject: [PATCH] ext4: return ENOMEM rather than EIO when find_###_page()
 fails
Date: Wed, 09 Apr 2014 17:46:00 +0800
Message-ID: <534516D8.9010803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52740 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340AbaDIJqH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2014 05:46:07 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so2231162pdi.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Apr 2014 02:46:06 -0700 (PDT)
Received: from [192.168.1.103] ([219.146.73.4])
        by mx.google.com with ESMTPSA id pr4sm1296425pbb.53.2014.04.09.02.46.04
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 09 Apr 2014 02:46:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Return ENOMEM rather than EIO when find_get_page() fails in 
ext4_mb_get_buddy_page_lock() and find_or_create_page() fails in
ext4_mb_load_buddy().

Signed-off-by: Younger Liu <younger.liucn@gmail.com>
---
 fs/ext4/mballoc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a888cac..73ccbb3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -989,7 +989,7 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 	poff = block % blocks_per_page;
 	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
 	if (!page)
-		return -EIO;
+		return -ENOMEM;
 	BUG_ON(page->mapping != inode->i_mapping);
 	e4b->bd_bitmap_page = page;
 	e4b->bd_bitmap = page_address(page) + (poff * sb->s_blocksize);
@@ -1003,7 +1003,7 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 	pnum = block / blocks_per_page;
 	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
 	if (!page)
-		return -EIO;
+		return -ENOMEM;
 	BUG_ON(page->mapping != inode->i_mapping);
 	e4b->bd_buddy_page = page;
 	return 0;
@@ -1168,7 +1168,11 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 			unlock_page(page);
 		}
 	}
-	if (page == NULL || !PageUptodate(page)) {
+	if (page == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	if (!PageUptodate(page)) {
 		ret = -EIO;
 		goto err;
 	}
@@ -1197,7 +1201,11 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 			unlock_page(page);
 		}
 	}
-	if (page == NULL || !PageUptodate(page)) {
+	if (page == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	if (!PageUptodate(page)) {
 		ret = -EIO;
 		goto err;
 	}
-- 
1.7.9.5

