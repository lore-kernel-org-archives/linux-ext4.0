From: Yang Ruirui <ruirui.r.yang@tieto.com>
Subject: [PATCH] ext4: release page cache in ext4_mb_load_buddy error path
Date: Thu, 14 Apr 2011 14:44:41 +0800
Message-ID: <20110414064441.GA3499@darkstar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48096 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab1DNGdu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 02:33:50 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add missing page_cache_release in the error path of ext4_mb_load_buddy

Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
---
 fs/ext4/mballoc.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.orig/fs/ext4/mballoc.c	2011-04-14 14:04:48.000000000 +0800
+++ linux-2.6/fs/ext4/mballoc.c	2011-04-14 14:33:28.702958245 +0800
@@ -1273,6 +1273,8 @@ repeat_load_buddy:
 	return 0;
 
 err:
+	if (page)
+		page_cache_release(page);
 	if (e4b->bd_bitmap_page)
 		page_cache_release(e4b->bd_bitmap_page);
 	if (e4b->bd_buddy_page)
