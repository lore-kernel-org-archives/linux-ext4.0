Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794811460;
	b=GbgilLjGKQl34KHuTHSyhHaXELGaPS8SfoGvBnHkQahG+YqnxCwpQY+l05UMkQs8P6uI
	 4bIZ0efgKAV3hmfigZ9+yAJ0G18Pdob2o26rY6QPLiehBCFwGe335+XuNwOdRrXW7twCo
	 LE7xx09bvJdC1XgXL2qCTthY6xC4wFWAMMQZuYTLt63wSsO76XaJ5Sqwt8LG0O7P9TJq4
	 IxWzlwv2nBhJo1JTUlhkNZ8DdTsYWHvdQufK0RPmOjfispkffElLQ+1RxNSrejJZDheOf
	 9vbRSoa53kMnKPfLBq04rP71gKgGNzHdBVrAmsQlPAuXKFy3M5w6XK+RXsjl2KKIgHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794811460;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EGwNz6ppLcP5RRVJzdX+lGT9M/xGWs8Ami8GLD0jWdk=;
	b=zWs4LZ9sEC5h5nnsKEudru0N4wRkZ9CrnEfwa1X8+o2R7a0N2hRop0hApIY1o1UUrf+H
	 Jv0x8PPi2E7R+qt5sa4MN6TaXaziH+cmb++orLz1KbfncOiOrYt4XY00qFNTg0EETNo/X
	 0kZyWsQR2HSRXy9GbtlY/7aK+mJP7c6SO3dpVKLpdAI8+gjtbl476ykUU7jFAUY2XGFzA
	 1lh8bNw4Q4UWxXQvp5ztcHn7BTgrF7KE51xr+jI0uP3YWPgu91RufqctzaUoSG7MdFPHj
	 GG+vA+IaPhl3a4J7jVmyVxolrBAEK0WMbOWb22IXVgu3LOCWYUrfZ/GHY2sKEOqmXsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=LjuG5yU8;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4DE606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 06:44:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC4DE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=LjuG5yU8
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a05b210703so1223759b3a.0
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 22:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794811459; x=1795416259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EGwNz6ppLcP5RRVJzdX+lGT9M/xGWs8Ami8GLD0jWdk=;
        b=LjuG5yU8Mu0KCfjvoxXtCUxmmZje3dPsgUa9aFicpAwQ0r4eWo+LggvkfCW5tFFpNe
         ceVkHgSncETFuZ05KL5Xt2usgxYadgpVdrOZJcP/13/upp+VrWyGmWX/Z0bS0sCo+sGE
         dOZUdjsEMCeMhXaj+mv5faJXc25y258ooqLeEN0wLuhRufA6SwUbwBT8DOxNQz2KZC5X
         MbNbtXqZhDK33p0WHAJh2p+8SuMBkaHmlHbtLbWGJK9N3ZcZSbXx8JM3MGlku4xCa71g
         qyhXbyVuVwnejDy56oJTKG0NMDbHF5w9E7FeyUKNzGZuvSOrtnMxGURvgSvEm2PZRhCe
         VwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794811459; x=1795416259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EGwNz6ppLcP5RRVJzdX+lGT9M/xGWs8Ami8GLD0jWdk=;
        b=WFsM4iphvpIIIdFMcVO3wDYTaAoEqN996pvFxLqfY1dQPs3Gb2ijRwjdlxlaNCmmCp
         R2ehwKDwUxXvRpI/j/ugNxpJIJSzGK80imOAakeIqQ/myKvcfVqcu14SnVE8gqGOqFtQ
         riXAtisG3mjBW+/6GpmuUjQWUDmCc94p+qF2NWEMcd35oFA4y4LzWYxuAN53KNNNbdIa
         opoPqZDQFoPYKwCMwVLOjWVRAM4xB+7ZXLQ8ObHeLDYxfzY/xcJucIJzmAKBsmq8HnlM
         s6uQ7LwunJyUj9AFCLYfrz1Pa6Wk+W7Jo5NNmST7bWVpMQeuV0fPWTNUnYm65QvxsgwC
         tNtA==
X-Gm-Message-State: APuU4Z8vhgpvISbS4aDZau5I5/8ziVIsqvTWMmm5AsxPIJhW5zZDnEWv
	0GJ2xVeNXQtZKyiE7O7rYW902+B2QAFZI079LqCPPRp11YxNLXzwn69DU3WqFkGGkYhVh13TjQL
	iKsAtUaU=
X-Gm-Gg: AYBFou00iQQAix8Mps+rMkl7kGCX3X3yV0n4gDjccg+ClMWCJ2VioHX2TbLas/zGDtm
	TraOb/K/U8Jmbqd73gVA7jvYQiSS5mKD7rM3+r4ZOcRMHfTlct5Poh4rtCLAaAIeVmjYNLbl6Md
	oLpoFHVu5S6slOBfS8I9neimcrtI/fvbbFueJ/MhS7F8kqP3zBjUME91lFrXl0/hqraCU/nH0V4
	Cjsf+fjNbwx/eULAuwyndapMQBDXJTAzVpX2/LFq1pn1jYmWv8MoNWvs47UgDovx8B1a91ockPG
	+mfspQzAeHVfXO84jzAkHqJx/rFG85GOhpLbLBuQYJqAkOuDF/O8S57XPfSGZVTljyI0QiAI0n4
	M/cpTWYmaM4LpKbuTOHqmLoALkhEd4IjM9qf7c9G5aMUXSePW4jjzOjdhGUXhenaSUQSY1WJkic
	J5lhAwJFh0kHq3OX/NnRDFK0sWaOfHz5nz7ED7hO011ET1bf9ybhnoicBnRA88LaZel2xWqWAbc
	x6S0+gClLPKKvB+g2FcauNqapefM0EE48ysV/G1x/gO7o5idApl6fcGdL3A/EMlSy+kqus2sfwl
	i2ZjJxtqYd+K7LVEPqgqJgpe5DovJXyXbno9
X-Received: by 2002:a05:6a00:94dc:b0:886:a52a:316f with SMTP id d2e1a72fcca58-8beb2e7e862mr8254778b3a.4.1794811458904;
        Sun, 15 Nov 2026 22:44:18 -0800 (PST)
Received: from localhost ([116.132.239.148])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed2d11ac8sm3144409b3a.55.2026.11.15.22.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 22:44:18 -0800 (PST)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: yi.zhang@huawei.com,
	jack@suse.cz,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	riteshh@linux.ibm.com
Subject: [PATCH v3 1/3] ext4: fix a race between partial writeback and truncation
Date: Mon, 16 Nov 2026 14:44:02 +0800
Message-Id: <20261116064404.189911-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261116064404.189911-1-sunjunchao@bytedance.com>
References: <20261116064404.189911-1-sunjunchao@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After a retryable mapping error, mpage_submit_partial_folio() submits the
mapped buffers, advances start_pos into the folio and unlocks it.
mpage_release_unused_pages() subsequently looks up the remaining range
and skips the partial folio by comparing its position with start_pos.

Once unlocked, the folio can be truncated and replaced by smaller folios.
A replacement at or beyond start_pos passes the position check even
though writeback does not own its lock. Cleanup can then hit the locked
folio assertion or unlock a folio held by another task.

The race was reproduced reliably using local code instrumentation to
widen the race window, triggering BUG_ON(!folio_test_locked(folio)) in
mpage_release_unused_pages().
The issue could no longer be reproduced after applying this patch.

On this retryable error path, cleanup only needs to unlock unused folios.
The partial folio has already been unlocked. Its buffers still needing
mapping remain dirty, and ext4_bio_write_folio() redirties the folio for a
later writeback attempt. The existing code therefore intends to leave
it alone. Any new folios inserted into the same range were not locked by
this writeback operation and must also be excluded. The following unused
folios still need their locks released.

Record the end of the partially submitted folio before unlocking it,
and start cleanup at that offset.

Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents mapping loop")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/inode.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e3129353d4ed..6dad9eea7824 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1825,22 +1825,27 @@
 };
 
 static void mpage_release_unused_pages(struct mpage_da_data *mpd,
-				       bool invalidate)
+				       bool invalidate, loff_t release_start)
 {
 	unsigned nr, i;
 	pgoff_t index, end;
 	struct folio_batch fbatch;
 	struct inode *inode = mpd->inode;
 	struct address_space *mapping = inode->i_mapping;
+	loff_t start_pos = max(mpd->start_pos, release_start);
 
 	/* This is necessary when next_pos == 0. */
 	if (mpd->start_pos >= mpd->next_pos)
 		return;
 
+	/* A partially submitted folio may need another writeback pass. */
 	mpd->scanned_until_end = 0;
+	if (start_pos >= mpd->next_pos)
+		return;
+
 	if (invalidate) {
 		ext4_lblk_t start, last;
-		start = EXT4_B_TO_LBLK(inode, mpd->start_pos);
+		start = EXT4_B_TO_LBLK(inode, start_pos);
 		last = mpd->next_pos >> inode->i_blkbits;
 
 		/*
@@ -1853,7 +1858,7 @@
 	}
 
 	folio_batch_init(&fbatch);
-	index = mpd->start_pos >> PAGE_SHIFT;
+	index = start_pos >> PAGE_SHIFT;
 	end = mpd->next_pos >> PAGE_SHIFT;
 	while (index < end) {
 		nr = filemap_get_folios(mapping, &index, end - 1, &fbatch);
@@ -1862,7 +1867,7 @@
 		for (i = 0; i < nr; i++) {
 			struct folio *folio = fbatch.folios[i];
 
-			if (folio_pos(folio) < mpd->start_pos)
+			if (folio_pos(folio) < start_pos)
 				continue;
 			if (folio_next_index(folio) > end)
 				continue;
@@ -2523,7 +2528,8 @@
  * This is used to submit mapped buffers in a single folio that is not fully
  * mapped for various reasons, such as insufficient space or journal credits.
  */
-static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
+static int mpage_submit_partial_folio(struct mpage_da_data *mpd,
+				      loff_t *release_start)
 {
 	struct inode *inode = mpd->inode;
 	struct folio *folio;
@@ -2544,13 +2550,17 @@
 
 	mpage_submit_folio(mpd, folio);
 	/*
-	 * Update start_pos to prevent this folio from being released in
-	 * mpage_release_unused_pages(), it will be reset to the aligned folio
-	 * pos when this folio is written again in the next round. Additionally,
+	 * Update start_pos to the mapped boundary. It will be reset to the aligned
+	 * folio pos when this folio is written again in the next round. Additionally,
 	 * do not update wbc->nr_to_write here, as it will be updated once the
 	 * entire folio has finished processing.
+	 *
+	 * Once unlocked, the folio can be removed from the page cache and
+	 * replaced. Set release_start past this folio so that
+	 * mpage_release_unused_pages() skips its entire range.
 	 */
 	mpd->start_pos = pos;
+	*release_start = folio_next_pos(folio);
 	folio_unlock(folio);
 	folio_put(folio);
 	return 0;
@@ -2565,6 +2575,8 @@
  * @give_up_on_write - we set this to true iff there is a fatal error and there
  *                     is no hope of writing the data. The caller should discard
  *                     dirty pages to avoid infinite loops.
+ * @release_start - minimum byte offset for releasing unused folios.
+ *                  The caller must initialize it to zero.
  *
  * The function maps extent starting at mpd->lblk of length mpd->len. If it is
  * delayed, blocks are allocated, if it is unwritten, we may need to convert
@@ -2578,7 +2590,8 @@
  */
 static int mpage_map_and_submit_extent(handle_t *handle,
 				       struct mpage_da_data *mpd,
-				       bool *give_up_on_write)
+				       bool *give_up_on_write,
+				       loff_t *release_start)
 {
 	struct inode *inode = mpd->inode;
 	struct ext4_map_blocks *map = &mpd->map;
@@ -2612,7 +2625,8 @@
 				 * corresponding data to prevent stale data.
 				 */
 				if (progress) {
-					if (mpage_submit_partial_folio(mpd))
+					if (mpage_submit_partial_folio(mpd,
+								       release_start))
 						goto invalidate_dirty_pages;
 					goto update_disksize;
 				}
@@ -3017,7 +3031,7 @@
 	}
 	ret = mpage_prepare_extent_to_map(mpd);
 	/* Unlock pages we didn't use */
-	mpage_release_unused_pages(mpd, false);
+	mpage_release_unused_pages(mpd, false, 0);
 	/* Submit prepared bio */
 	ext4_io_submit(&mpd->io_submit);
 	ext4_put_io_end_defer(mpd->io_submit.io_end);
@@ -3026,6 +3040,8 @@
 		goto unplug;
 
 	while (!mpd->scanned_until_end && wbc->nr_to_write > 0) {
+		loff_t release_start = 0;
+
 		/* For each extent of pages we use new io_end */
 		mpd->io_submit.io_end = ext4_init_io_end(inode, GFP_KERNEL);
 		if (!mpd->io_submit.io_end) {
@@ -3070,7 +3086,7 @@
 		ret = mpage_prepare_extent_to_map(mpd);
 		if (!ret && mpd->map.m_len)
 			ret = mpage_map_and_submit_extent(handle, mpd,
-					&give_up_on_write);
+					&give_up_on_write, &release_start);
 		/*
 		 * Caution: If the handle is synchronous,
 		 * ext4_journal_stop() can wait for transaction commit
@@ -3087,7 +3103,7 @@
 			mpd->do_map = 0;
 		}
 		/* Unlock pages we didn't use */
-		mpage_release_unused_pages(mpd, give_up_on_write);
+		mpage_release_unused_pages(mpd, give_up_on_write, release_start);
 		/* Submit prepared bio */
 		ext4_io_submit(&mpd->io_submit);
 
-- 
2.39.5
