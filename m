Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680961;
	b=Sos9IRvWN4nJUciw7DbNAC5V0CtvpegCU/sfQi1BsqaP4dM0Vzjr4BOSIQd45HSIfVmv
	 4R8+pX+NyYUfhbZHe5N/yRfSDgJrwEXGvLIfh4qdfOu2wzfqW4jHOlxT8qdEPKIyC/yxX
	 I52VYl8i4VP78ms8fxQbCuGiMy7+80BpcKwUmJvlbC7M7LUf+8W5ppvMxl0SOc33t/58R
	 QfR+YrUMt942o93NH3WKmG26O9f0NPkFtWte2jFwXrUY1F6UxLP3QsGpraLPJup+5QlK0
	 LBdebyovmCHluprlOrj8EAEd4IUU0eiiQralhKvRxj34Rz0cC0ro+4v+M5oel2zBO7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=87uFNg++DtA0iE+FXkHpy5QPIHPTz7pcgggVNARt7xs=;
	b=qFR7XbYVlF/uW9zTFDsdYJxyfuZ9sgO139BySAnGKRcVqZTgRhHQuYoa0K+Drcceam3x
	 yT30XqJUalTY3VYr7Ha6cM4g/K12yl+/PDAJVQE5oWHGRguNgECwbQv6olvtG8P2EqmHg
	 t/0Mb9Shrt5TOqApXdvbonoAzEchWGXCWziej8CQOriajrzvCWNoP8y+EsiKvFU86kPRX
	 gY+Two3GsmAmVLrnNLCR5LmrwmeR4MXKbuyk2uPyzfeHFogT0C0GZAYwfCOLfFCw5Gg39
	 jUNvYLAIof4nfhmBMQEBa9rXHFaZxKJ62BxWfFEFVcgKf1+YPbfmlKXRCqD3atM3e7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=XqPQoP0X;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B11606A319
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 14:56:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14B11606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=XqPQoP0X
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd6acc50b8dso809135a12.3
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 07:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792680960; x=1793285760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=87uFNg++DtA0iE+FXkHpy5QPIHPTz7pcgggVNARt7xs=;
        b=XqPQoP0Xk20Qc4Q9zVkfNJJmBht2hWCSMk46IhZGyTSWOqQVB3cj5TOIak1OjGQ2Hj
         IAkJYh7QGzi9dZyQgxiSgq/0bVhQZupvztH5iPBufi2ogXFB0aEYO/+YbBq91E9ZAnCw
         4i+df886aRPwgK7yJfX2dr+jo/cSXNxlDJa2s37KmRvFeqpAI7ldupcUiu0dkeGr2l7G
         iAhLnMhMmPUZ+ayJ+sWgwexP46hFSLWPyha04svg0tZBG721NjdJpcKDrvx0zZLDBESF
         fV6Z3ZdmNvaFtVSEBQjwGaXEiJHMrDBFo7XutJrE0FnyxeGio2aSM4KBt9xw9AaXhE9/
         weiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680960; x=1793285760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=87uFNg++DtA0iE+FXkHpy5QPIHPTz7pcgggVNARt7xs=;
        b=a3BWmbVxrqHCiDEUANppg9FY7YltVEK9CD+gA/MgAtV7hqxTtGJhWphQ7VqGlKbdZo
         frtsLeksEYDgBtTgSVhOKrUcE4rxTJIdSB3uL5hRUyiup+eNfNy5kLrld/UiXEzEvKoX
         /7R4zFGZqqXzsgnBc/BmadEpzNwPy3ja6LhHBstptkWgwS9ZEUz6a7BRTx3qXUFa7HkG
         lsTSMMczmwbbJ3AbHKlprP32MwNytckUBcVK4wic+HcdFdAMq+8Egxmdm2OaTWe0v466
         9CSoSb3QC9b3ank3ew+Y4VY5Ka7Obu/b8AvNLXFpvh1vGyGuZ3VDfBmrWxkkkrEoDUXf
         UWvg==
X-Gm-Message-State: AFq9FYKWjFJs7PxpOia5pYQgsooY5atBuF6sfx2zTKw4PCQTWd1BQIAS
	TBXrOZuyv8X1CfOflhO1FZ88AWQCu53vEHMDcdz01XjnhX3zxi16Aiai0wPWRuBwhUlshazotTN
	0UrVO
X-Gm-Gg: AYBFou1bq8wxFHCEqiDIbCb5FF3Y1pIQto2hcMIUJl9E3J0jv0eKTHD7bcmbj3QHxFU
	14JM4HM15UqE4RQYtg1bNcMqKJmYxU0DsNf3AST8qqquy7cuWO+628N/SrdMq0R6LzXt8Z238Xx
	TT55SDLqHP3btlPlQpT6RhJXy/sEjbpQKv7MLh1b+YN0QX5RJi0DabQ2nbJypNJYSgkQ4rnJHU1
	AHu+d2Z1Tl760ilwZL0wHYq01/B1abwGXKLdDuUYXE6D3zIrjB1PSktqfkNMjKubgSgKfsUmPWw
	XwxdNr9bHu9N+KU7TXIJbY0GwpxfQ3L6iu+FYbXCnO854Qlk2njbXpCEKRxZL3f1tu8Z2nxw/hC
	6ymM6C7fTzWehTLR9NJK09FRHdi2Qp1IldV4P2UmXZkF0GAicWde1WxG6fBxAe+WBlzgU9aZmc0
	6TXlKbeEUsVkX67ZMmdo1GJ+ID/UveVvU3BJOVx0dTUjFpBh2XN+FqW+ykY2VZYp7qmkfuJarm+
	AxGyc6p8i/YjAxgLFTBZNFuQ7A17+WH2/DqncjnWAvpMyP1jCClQTjHPwg=
X-Received: by 2002:a17:90b:2b4f:b0:3ab:17b6:9a93 with SMTP id 98e67ed59e1d1-3ad86d3b9bcmr4744582a91.52.1792680960122;
        Thu, 22 Oct 2026 07:56:00 -0700 (PDT)
Received: from localhost ([106.38.226.31])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada48a63e7sm4625082a91.11.2026.10.22.07.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:55:59 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	riteshh@linux.ibm.com
Subject: [PATCH 3/6] ext4: prevent stale data exposure after fatal mapping errors
Date: Thu, 22 Oct 2026 22:52:38 +0800
Message-Id: <20261022145241.2950379-4-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261022145241.2950379-1-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
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

When the block size is smaller than the folio size, a folio can contain
several extents that need mapping. Mapping an earlier extent can succeed
before mapping a later extent fails with a fatal error such as -EIO.

mpage_map_and_submit_extent() submits the mapped part of the folio only
for retryable errors. On a fatal error it discards the whole folio,
including dirty buffers whose mapping has already succeeded. This loses
data that could still be submitted.

With dioread_nolock, the mapped ranges can also remain in io_end's
unwritten conversion list. Conversion can then mark those extents
written without their data ever being submitted, exposing stale data.

Also submit the mapped buffers after a fatal mapping error when the
filesystem is not in an emergency state. Discard buffers still marked
BH_Delay or BH_Unwritten so that writeback does not keep retrying them.
Clearing their dirty bits alone would leave stale buffer mappings and
delayed allocation reservations. Remove their extent status entries and
invalidate the buffers. Do this after folio_clear_dirty_for_io(), since
cleaning mmap writes can mark all buffers dirty again.

Update i_disksize using the mapped boundary before moving start_pos past
the folio. Advancing it earlier could include discarded data in the size
update. Advancing it afterwards makes mpage_release_unused_pages() skip
the handled folio and its extent status entries, including any entries
created by new writes after the folio was unlocked. Count the handled
folio against the writeback budget on fatal errors. Keep the existing
retry behavior for transient errors.

Fixes: c8cc88163f40 ("ext4: Add support for blocksize < pagesize in dioread_nolock")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/inode.c | 108 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 83 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cefc4b97ac41..534833b13098 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2066,13 +2066,46 @@ static void mpage_folio_done(struct mpage_da_data *mpd, struct folio *folio)
 	folio_unlock(folio);
 }
 
-static void mpage_submit_folio(struct mpage_da_data *mpd, struct folio *folio)
+static void mpage_submit_folio(struct mpage_da_data *mpd, struct folio *folio,
+			       bool fatal)
 {
 	size_t len;
 	loff_t size;
 
 	WARN_ON_ONCE(folio_pos(folio) != mpd->start_pos);
 	folio_clear_dirty_for_io(folio);
+
+	/*
+	 * If a later mapping fails with a fatal error, write the buffers
+	 * ALREADY mapped and discard the data in buffers still needing
+	 * mapping. Do this after folio_clear_dirty_for_io(), which may
+	 * mark all buffers dirty again for mmap writes.
+	 */
+	if (fatal) {
+		struct buffer_head *bh, *head;
+		ext4_lblk_t start, length;
+		struct inode *inode = mpd->inode;
+
+		/*
+		 * Remove the ES entries, free the reserved space and clear the
+		 * buffer mappings before new writes can use this folio. Hold
+		 * i_data_sem to prevent races with delayed allocation lookups.
+		 */
+		down_write(&EXT4_I(inode)->i_data_sem);
+
+		bh = head = folio_buffers(folio);
+		do {
+			if (buffer_delay(bh) || buffer_unwritten(bh)) {
+				start = EXT4_B_TO_LBLK(inode, folio_pos(folio) + bh_offset(bh));
+				length = bh->b_size >> inode->i_blkbits;
+				ext4_es_remove_extent(inode, start, length);
+				block_invalidate_folio(folio, bh_offset(bh), bh->b_size);
+			}
+		} while ((bh = bh->b_this_page) != head);
+
+		up_write(&EXT4_I(inode)->i_data_sem);
+	}
+
 	/*
 	 * We have to be very careful here!  Nothing protects writeback path
 	 * against i_size changes and the page can be writeably mapped into
@@ -2198,7 +2231,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 	} while (lblk++, (bh = bh->b_this_page) != head);
 	/* So far everything mapped? Submit the page for IO. */
 	if (mpd->map.m_len == 0) {
-		mpage_submit_folio(mpd, head->b_folio);
+		mpage_submit_folio(mpd, head->b_folio, false);
 		mpage_folio_done(mpd, head->b_folio);
 	}
 	if (lblk >= blocks) {
@@ -2329,7 +2362,7 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd, int *progress
 			if (err < 0 || map_bh)
 				goto out;
 			/* Page fully mapped - let IO run! */
-			mpage_submit_folio(mpd, folio);
+			mpage_submit_folio(mpd, folio, false);
 			mpage_folio_done(mpd, folio);
 		}
 		folio_batch_release(&fbatch);
@@ -2394,14 +2427,15 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 }
 
 /*
- * This is used to submit mapped buffers in a single folio that is not fully
- * mapped for various reasons, such as insufficient space or journal credits.
+ * Write the buffers that are ready in a partly mapped folio. On a fatal
+ * error, drop the buffers that still need mapping instead of retrying them.
+ * Return the byte offset just past the folio on success, or a negative error.
  */
-static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
+static loff_t mpage_submit_partial_folio(struct mpage_da_data *mpd, bool fatal)
 {
 	struct inode *inode = mpd->inode;
 	struct folio *folio;
-	loff_t pos;
+	loff_t pos, end;
 
 	folio = filemap_get_folio(inode->i_mapping,
 				  mpd->start_pos >> PAGE_SHIFT);
@@ -2416,18 +2450,21 @@ static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
 			 !folio_contains(folio, pos >> PAGE_SHIFT)))
 		return -EINVAL;
 
-	mpage_submit_folio(mpd, folio);
+	end = folio_next_pos(folio);
+	mpage_submit_folio(mpd, folio, fatal);
 	/*
 	 * Update start_pos to prevent this folio from being released in
-	 * mpage_release_unused_pages(), it will be reset to the aligned folio
-	 * pos when this folio is written again in the next round. Additionally,
-	 * do not update wbc->nr_to_write here, as it will be updated once the
-	 * entire folio has finished processing.
+	 * mpage_release_unused_pages(). For retryable errors, it will be reset
+	 * to the aligned folio pos when this folio is written again in the next
+	 * round. Count the folio now only for fatal errors; otherwise the
+	 * retry will count it once the entire folio has finished processing.
 	 */
 	mpd->start_pos = pos;
+	if (fatal)
+		mpd->wbc->nr_to_write -= folio_nr_pages(folio);
 	folio_unlock(folio);
 	folio_put(folio);
-	return 0;
+	return end;
 }
 
 /*
@@ -2461,6 +2498,8 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 	int progress = 0;
 	ext4_io_end_t *io_end = mpd->io_submit.io_end;
 	struct ext4_io_end_vec *io_end_vec;
+	bool fatal = false;
+	loff_t next_folio_pos = 0;
 
 	io_end_vec = ext4_alloc_io_end_vec(io_end);
 	if (IS_ERR(io_end_vec))
@@ -2494,18 +2533,28 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 		 */
 		if ((err == -ENOMEM) || (err == -EAGAIN) ||
 		    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
-			/*
-			 * We may have already allocated extents for
-			 * some bhs inside the folio, issue the
-			 * corresponding data to prevent stale data.
-			 */
-			if (progress) {
-				if (mpage_submit_partial_folio(mpd))
-					goto invalidate_dirty_pages;
-				goto update_disksize;
-			}
-			return err;
+			/* Already false, but set it here to make the choice clear. */
+			fatal = false;
+		} else {
+			fatal = true;
+		}
+
+		/*
+		 * We may have already allocated extents for
+		 * some bhs inside the folio, issue the
+		 * corresponding data to prevent stale data.
+		 */
+		if (progress) {
+			next_folio_pos = mpage_submit_partial_folio(mpd, fatal);
+			if (next_folio_pos < 0)
+				goto invalidate_dirty_pages;
+
+			goto update_disksize;
 		}
+
+		if (!fatal)
+			return err;
+
 		ext4_msg(sb, KERN_CRIT,
 			 "Delayed block allocation failed for "
 			 "inode %llu at logical offset %llu with"
@@ -2549,6 +2598,15 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 		if (!err)
 			err = err2;
 	}
+	if (fatal) {
+		/*
+		 * We have submitted the mapped buffers and dropped the rest.
+		 * After updating i_disksize, move start_pos past this folio so
+		 * mpage_release_unused_pages() skips its buffers and ES entries.
+		 */
+		mpd->start_pos = next_folio_pos;
+		*give_up_on_write = true;
+	}
 	return err;
 }
 
@@ -2731,7 +2789,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			 * through a pin.
 			 */
 			if (!mpd->can_map) {
-				mpage_submit_folio(mpd, folio);
+				mpage_submit_folio(mpd, folio, false);
 				err = 0;
 				/* Pending dirtying of journalled data? */
 				if (folio_test_checked(folio)) {
-- 
2.39.5

