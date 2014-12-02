From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] ext4: prevent fsreentrance deadlock for inline_data
Date: Tue,  2 Dec 2014 15:00:52 +0400
Message-ID: <1417518054-21733-2-git-send-email-dmonakhov@openvz.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:2865 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaLBLBM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 06:01:12 -0500
In-Reply-To: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_da_convert_inline_data_to_extent() invokes grab_cache_page_write_begin().
grab_cache_page_write_begin performs memory allocation, so fs-reentrance
should be prohibited because we are inside journal transaction.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inline.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 3ea6269..efdcede 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -870,6 +870,12 @@ retry_journal:
 			goto out_journal;
 	}
 
+	/*
+	 * We cannot recurse into the filesystem as the transaction
+	 * is already started.
+	 */
+	flags |= AOP_FLAG_NOFS;
+
 	if (ret == -ENOSPC) {
 		ret = ext4_da_convert_inline_data_to_extent(mapping,
 							    inode,
@@ -882,11 +888,6 @@ retry_journal:
 		goto out;
 	}
 
-	/*
-	 * We cannot recurse into the filesystem as the transaction
-	 * is already started.
-	 */
-	flags |= AOP_FLAG_NOFS;
 
 	page = grab_cache_page_write_begin(mapping, 0, flags);
 	if (!page) {
-- 
1.7.1

