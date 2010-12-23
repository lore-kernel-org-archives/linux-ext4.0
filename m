From: Dan Carpenter <error27@gmail.com>
Subject: [patch] ext4: testing the wrong variable in ext4_init_pageio()
Date: Thu, 23 Dec 2010 22:09:11 +0300
Message-ID: <20101223190911.GM1936@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34033 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0LWTJZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Dec 2010 14:09:25 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a copy and paste error.  The intent was to check
"io_page_cachep".  We tested "io_page_cachep" earlier.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index beacce1..857abc6 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -44,7 +44,7 @@ int __init ext4_init_pageio(void)
 	if (io_page_cachep == NULL)
 		return -ENOMEM;
 	io_end_cachep = KMEM_CACHE(ext4_io_end, SLAB_RECLAIM_ACCOUNT);
-	if (io_page_cachep == NULL) {
+	if (io_end_cachep == NULL) {
 		kmem_cache_destroy(io_page_cachep);
 		return -ENOMEM;
 	}
