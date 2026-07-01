Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ED6364950
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 03:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876858; cv=none; b=aUAh+39AsNY/rDwKboeteXoZajgmOT68NZlWp5+4rLFj3OfQpmTIVnd450uzQg0+D67GM08Wp+Y49BlI+n2gE2MqTF39t9b5Q74sUoI2TBs2jxXRA2pp3EKeMbqIj5E+VX7beVBHujNqviG2kcPM6Gv2f34UTdYiamYn8Z1m8R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876858; c=relaxed/simple;
	bh=iXgVJMPnapOzM3bpLn10aPshvVK0vQDX+UWb4L3qB64=;
	h=From:Subject:Message-Id:References:Content-Type:Cc:Date:
	 Mime-Version:To:In-Reply-To; b=spjuMDSYfn6G8iKektZqKWPPPGeItsy7YRV7jHjizBrPXkmc6wcWYYPtf2duTLa8Cl3KuZDrF9F+9G/X94UY0llihUTIVSVQupeijhDER++YySzNkuiYqsA21DLsW/6g4e3U8Cpe54bTAHd/lFfTYh8WhECqeEZm7dckOyqNXO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=kFuNiIuG; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="kFuNiIuG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782876851; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+hXO33n5v6px2vSofVvdXcRgxg5IGY24Uz9ZYRcxnME=;
 b=kFuNiIuGSIwDPZ4TAy2h53NRE5qK9d9/7efqGXTuF8NS+RPAIriePl1N+5KM+b9qHhLLtr
 i3zi2FDs/zCYN8al714c95TAp7yhapleED5+B/Fpub0GYiq+G3H2HnZob2qXqMpo4b0ITP
 GlOlosdodMdKM0ztRzq+3NuO8sQlv8b81XHoKGPotzY4etxVaMQHYUQlBamoDeWjmKZmxK
 g+jGVu6JLKP6zJ59S5YGrQSenLRCM18SL6C5FwBjHXBl3CZy2DsbhVxtdn3GFYzMTalQtj
 qq0Jvt2sEcIBw8KPC7wc7s2WCd7e6L2gZ/C9/gxwPjOSR3z12ajeEFWEJjxU5Q==
From: "Fengnan Chang" <changfengnan@bytedance.com>
Subject: [PATCH v6 1/3] iomap: factor out iomap_dio_alignment helper
Message-Id: <20260701033253.46420-2-changfengnan@bytedance.com>
References: <20260701033253.46420-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: "Fengnan Chang" <changfengnan@bytedance.com>, 
	"Christoph Hellwig" <hch@lst.de>
Date: Wed,  1 Jul 2026 11:32:51 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<pankaj.raghav@linux.dev>
X-Lms-Return-Path: <lba+26a448ab1+bf7c49+vger.kernel.org+changfengnan@bytedance.com>
In-Reply-To: <20260701033253.46420-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)

Extract the alignment computation from iomap_dio_bio_iter() into a
standalone helper so the upcoming simple direct I/O path can reuse it
without requiring a struct iomap_dio.

No functional change.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/direct-io.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b485e3b191daf..487c4763f3fde 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -398,6 +398,14 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	return ret;
 }
 
+static inline unsigned int iomap_dio_alignment(struct inode *inode,
+		struct block_device *bdev, unsigned int dio_flags)
+{
+	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
+		return i_blocksize(inode);
+	return bdev_logical_block_size(bdev);
+}
+
 static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	const struct iomap *iomap = &iter->iomap;
@@ -416,10 +424,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	 * File systems that write out of place and always allocate new blocks
 	 * need each bio to be block aligned as that's the unit of allocation.
 	 */
-	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED)
-		alignment = fs_block_size;
-	else
-		alignment = bdev_logical_block_size(iomap->bdev);
+	alignment = iomap_dio_alignment(inode, iomap->bdev, dio->flags);
 
 	if ((pos | length) & (alignment - 1))
 		return -EINVAL;
-- 
2.39.5 (Apple Git-154)
