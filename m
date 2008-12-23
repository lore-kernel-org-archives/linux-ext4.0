From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ext4: annotate unhandled kmem_cache_alloc() error
Date: Tue, 23 Dec 2008 19:40:18 +0900
Message-ID: <20081223104016.GC7217@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: akpm@linux-foundation.org, Theodore Tso <tytso@mit.edu>,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:32030 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYLWKki (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2008 05:40:38 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

kmem_cache_alloc() error in ext4_mb_free_metadata is not handled.
I don't know how to fix it. But I can put BUG_ON to let others
know the problem.

Cc: Theodore Tso <tytso@mit.edu>
Cc: adilger@sun.com
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 fs/ext4/mballoc.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6-rc/fs/ext4/mballoc.c
===================================================================
--- 2.6-rc.orig/fs/ext4/mballoc.c
+++ 2.6-rc/fs/ext4/mballoc.c
@@ -4417,6 +4417,7 @@ ext4_mb_free_metadata(handle_t *handle, 
 	BUG_ON(e4b->bd_buddy_page == NULL);
 
 	new_entry  = kmem_cache_alloc(ext4_free_ext_cachep, GFP_NOFS);
+	BUG_ON(!new_entry);
 	new_entry->start_blk = block;
 	new_entry->group  = group;
 	new_entry->count = count;
