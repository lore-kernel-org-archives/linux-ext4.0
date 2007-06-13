From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: [patch] new aop loop fix
Date: Wed, 13 Jun 2007 17:46:31 +0400
Message-ID: <20070613134631.GB13815@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: npiggin@suse.de, mark.fasheh@oracle.com, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:26769 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484AbXFMKp6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2007 06:45:58 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

	loop.c code itself is not perfect. In fact before Nick's patch
	partial write was't possible. Assumption what write chunks are
	always page aligned is realy weird ( see "index++" line).

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 4bab9b1..8726da5 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -215,7 +215,6 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
 	int len, ret;
 
 	mutex_lock(&mapping->host->i_mutex);
-	index = pos >> PAGE_CACHE_SHIFT;
 	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
 	bv_offs = bvec->bv_offset;
 	len = bvec->bv_len;
@@ -226,6 +225,7 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
 		struct page *page;
 		void *fsdata;
 
+		index = pos >> PAGE_CACHE_SHIFT;
 		IV = ((sector_t)index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
 		size = PAGE_CACHE_SIZE - offset;
 		if (size > len)
@@ -255,7 +255,6 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
 		bv_offs += copied;
 		len -= copied;
 		offset = 0;
-		index++;
 		pos += copied;
 	}
 	ret = 0;

> 
> 
