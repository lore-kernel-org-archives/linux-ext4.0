Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736347;
	b=u6BWb/Uv07pQ3AaUZsqvhhwQirJuJSEDeeD8MkvNk0CXQHVfyT0gWiXBSrFJX3lz3wgn
	 ORLbJtRchSePrZVrPmoLj3nAB+O6M4p9X5uwx/Oosyid09y5Vrfy840m42JcUyK1Y/mHu
	 Zsu745HJDXexG/xPZhqaoLsD7T/G9inK3ZvI/oWGUST8a/dazPeZ1mzhzAX9fLxg2blCJ
	 tded4MsnDyJT+tP/DUq8doBLA40ZVwCSpbizOGoGNATEZxvYv765eWzDFbBouOloQP3ZH
	 C3dV3pjekhbivbjyCLQCkECq2D/ptHYZrhEmEdH/PcszrrmAKC2/ceBV6DvpLqj4Bbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736347;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=L+L6AsPUlwsiIF5W4dMYCA0ADDIjA24ayZKbd8yt+2w=;
	b=lfOL/KQOpP9zyXk+GIaoOvJv2AZG7OdcnEjEsDYKMn3c51DVuSHRJpgkkQOLG3V9foAG
	 3KZpnkWhvtL0jzo4erx2w7Tnyz25EbYAFpOdaeUEhYRBP+6WWdpvmfenjqoela91SLow/
	 9ZE2pWh3xw9QKlbjFCdbj49CzbfWbeDMZEz75C47ahPHhzuaRYTvP69mhJhbpeGjOWt1z
	 i48P9U97AOnvYGQwK+HBGqKYE1Nc+rLx782Y4Vmz1MUBX6SS2xta3k/qVSXpWc9sL0ct2
	 OB+HrMxr97Ori1EQpiAwNSUW6ZIGJyXXPjBDQFKaDpS/p0xtoyhMaqNhUek9ei/Oz+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=BnUE3Z7J;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DCD606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:19:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19DCD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=BnUE3Z7J
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ea138a3497so2635585ad.2
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 23:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792736346; x=1793341146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L+L6AsPUlwsiIF5W4dMYCA0ADDIjA24ayZKbd8yt+2w=;
        b=BnUE3Z7JST3wPuJef2BkDKGfjTPPDgeAeOOavzb6lg9l7h+F4VfmtlLEcYW8cObWhf
         29iVQyKO9nCfNSNDqgJeBd1NkSu5ZkyhR28L38+hI9eRsCGLmiTvQBqDWwI1jLAm8NW5
         kEJRx3EYYeWhIFWJz8SVs3Dk2wn2QaG17PGzSGTNEroyKLkvpIxsl3D55lKjyv2wyIER
         YxnNhkPKw51JblLut2W6w9TV4eCjwZU2hArhYBc9Di/8l+Xv2WxcZxbcC2zNriLVOAWn
         TOEH47NpC8L1/fi0+AUW+P20mfRPgwl/Tz9ucDmkpTpAvpL3qLONfTKHm3YVJcgGwz6i
         uwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792736346; x=1793341146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L+L6AsPUlwsiIF5W4dMYCA0ADDIjA24ayZKbd8yt+2w=;
        b=18824tz4OSKkct77iSBrF5x/LJmgHXu9ot3JS4AWv6UZ9OcjXF6tyLExc7/9hp6bV9
         g7Nv7NF/qNeBZFvEe0xEb2MI2VcKh7FqL52pcX6QU3dvniJULyagGECn+xCn3Z9+LX0f
         +8a2/G/yUh76yaDyPk2x6ma6HEOk3QhA/PYRo/Xg+cjk+0r8m+CW2IVGj52AA1BWjeGS
         Q8do5yzO9KM2djgE+I3RKwEqzGd5HBiAe3a23E+VlEI78vcqNfh/e963pPWR/4pyt6J1
         KYGszRT9dm+wIIXGdjTSaFk40w0LyDkx1xe6OUOaEihJItV+d48Cp+8JwueNNKpRPmja
         PpuA==
X-Gm-Message-State: AFq9FYKNAxpH95X9GXlkewU34VkjSgqqRzDsLscOsGIeoI6YuM+P6pC6
	fTOq7GBvVJaU7tcTLzu8/G+jA+0sQOZo8+wjtnn0zTOcYjIpSv9QMUiLJ3BjNLeAbGIn42kxZy9
	PyBj4NWs=
X-Gm-Gg: AYBFou1HNHHX+mHnD+cxQKWBM9U0R2GnU+SOxen+Gkz9KV+oZ19xCiE0z2vclAfY6d5
	Jr3kok44jFQy+N+itK0kwQii24nH+ZjFvHcOEALfBDL9b3rwDrCVlTB5E1u1vPOJMILpzSHPukL
	29E75cK/W/DUmxYVG53/GVBtt7Q8CUfJxgXUz+4p84ekOsdEjRJG0YepCZcMIgV8xGCcX2FyAFt
	wOchmFJW6EpjFPnqaB1URpojAPDjbBnM+Z/foLXJH180HYijksWrvHGHRt9bX6p8TAgxsxsv7P+
	YnzXpB9Or4e6EFbU31mZP2WKra7qJZTOsgOANYhNI+rTeCEeZAkpM3DV3l2worKEdsLifwjDZgd
	QS1ws0F9x0xJDnW7YxQ0GicQvprsx8fZkntQyzGQXfYsypxtaaJjiuDql6tkyLmR55efiC7kPGJ
	djU5g8a1WajdZqxcClfXFA/JEKND1e3d0aRTcNcvA0cOTBrLQlbgNNMTYT5sBb13Zum2DdyEqQi
	VteVR0uNwPk8YBbkVtPO8MW55PckYX8HD+zdG2NlkI4wpYlMh/xQb/jMpw=
X-Received: by 2002:a17:902:dace:b0:2e9:2a1a:8b69 with SMTP id d9443c01a7336-2ea7d152df7mr12716955ad.55.1792736346394;
        Thu, 22 Oct 2026 23:19:06 -0700 (PDT)
Received: from localhost ([106.38.226.73])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b4fe14fsm5678705ad.70.2026.10.22.23.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:19:06 -0700 (PDT)
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
Subject: [PATCH v2 3/6] ext4: prevent stale data exposure after fatal mapping errors
Date: Fri, 23 Oct 2026 14:18:48 +0800
Message-Id: <20261023061851.45579-4-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261023061851.45579-1-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
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

Record fatal mapping errors before discarding dirty buffers so that
fsync() can report the lost writes.

Fixes: c8cc88163f40 ("ext4: Add support for blocksize < pagesize in dioread_nolock")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/inode.c | 109 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 84 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 74437fe6aa24..81aac8744f3d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2192,13 +2192,46 @@ static void mpage_folio_done(struct mpage_da_data *mpd, struct folio *folio)
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
@@ -2324,7 +2357,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
 	} while (lblk++, (bh = bh->b_this_page) != head);
 	/* So far everything mapped? Submit the page for IO. */
 	if (mpd->map.m_len == 0) {
-		mpage_submit_folio(mpd, head->b_folio);
+		mpage_submit_folio(mpd, head->b_folio, false);
 		mpage_folio_done(mpd, head->b_folio);
 	}
 	if (lblk >= blocks) {
@@ -2455,7 +2488,7 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd, int *progress
 			if (err < 0 || map_bh)
 				goto out;
 			/* Page fully mapped - let IO run! */
-			mpage_submit_folio(mpd, folio);
+			mpage_submit_folio(mpd, folio, false);
 			mpage_folio_done(mpd, folio);
 		}
 		folio_batch_release(&fbatch);
@@ -2526,14 +2559,15 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
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
@@ -2548,18 +2582,21 @@ static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
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
@@ -2593,6 +2630,8 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 	int progress = 0;
 	ext4_io_end_t *io_end = mpd->io_submit.io_end;
 	struct ext4_io_end_vec *io_end_vec;
+	bool fatal = false;
+	loff_t next_folio_pos = 0;
 
 	io_end_vec = ext4_alloc_io_end_vec(io_end);
 	if (IS_ERR(io_end_vec))
@@ -2626,18 +2665,29 @@ static int mpage_map_and_submit_extent(handle_t *handle,
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
+			mapping_set_error(inode->i_mapping, err);
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
@@ -2681,6 +2731,15 @@ static int mpage_map_and_submit_extent(handle_t *handle,
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
 
@@ -2863,7 +2922,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
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

