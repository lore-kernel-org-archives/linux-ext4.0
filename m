Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793783442;
	b=cfNE0+69uCX9KtAmfGk49K5nvHHtj7O6SejtFcbkQDPGVyEKs68l5AYZ64w1vasI2sQO
	 9xrS73DkVq4VpN6ww36QAigcqK+JF17ThfcSj3vs5W0C00IjgDeeLDPKeF3w5SYGMG4T7
	 D76MthYLacKpiWU4+dmg0jcBySHkeC6lzcNi/o9KQcZJVsMjAkjVc0x2S4wo/Og76Mk9c
	 HN7BCEcMXnkJeCWW2sbfBmd9Nisq1FXhC+zW1M0gSKm0JMNxgQiNDwRuHa8UOveOr/AeY
	 i0uxUrXgy43JwAsppAJgQFCxYpLDk1KsF9JLCv471+oFq5DUcS1lwDwkBbdGRIrpF5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783442;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=E6zHx94Wlybbepzvc2GPSYL49puXzlaUQPO16CzEtiY=;
	b=Qvnr6iJg5eH1Bybo02P2dmE1YHG/HrKzk9Ny+9efKj64Y0TY1rxlEOAI+jh3zXMybgTF
	 StYWDdwsq++wo38DmF6AglJgPUwZmZVkNmym7FBroQKfkK5DM25L0oP6xFyZk2tHOOTto
	 p4eMc0gC2fmdcBi2vpEaoIdv+g1724M0THuwGGC1p9cUZ4K2Ooo9ZpmF96rqfS6l3xW3c
	 X9DKexMYOw5X2ZWVdjE28wm2/yINKWpcRy3sBGwme8YVn5I6p0eJrny8CMiA+oNkg+6Q1
	 ZN3O3KPnfW+B5exvCiYgRLXm2b+ltFQBajNoNIUIENyiM/oeZA1nHLbTRupgs240rNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4BA606A326
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 09:10:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED4BA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jKKQf05j9z1c1rn
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 17:10:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5D82B40574
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 17:10:29 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAXTu2D9upqk4IlDA--.63901S3;
	Wed, 04 Nov 2026 17:10:29 +0800 (CST)
Message-ID: <e87fc578-26cb-4f38-a310-09856a1ba072@huaweicloud.com>
Date: Wed, 4 Nov 2026 17:10:27 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] ext4: prevent stale data exposure after fatal
 mapping errors
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, riteshh@linux.ibm.com
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
 <20261023061851.45579-4-sunjunchao@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261023061851.45579-4-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAXTu2D9upqk4IlDA--.63901S3
X-Coremail-Antispam: 1UD129KBjvAXoWfGw4xGrykZw1DWFy8WryUKFg_yoW8Gw47Wo
	WfZw4vva1xKrZ7Z3yjkr1ktFyUGan8uryrJr4fArs3Aa42qw43u3y7Jw1DXa4fXw1rKF13
	C34xXa15JrW7Cr1rn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUU5N7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/23/2026 2:18 PM, Julian Sun wrote:
> When the block size is smaller than the folio size, a folio can contain
> several extents that need mapping. Mapping an earlier extent can succeed
> before mapping a later extent fails with a fatal error such as -EIO.
> 
> mpage_map_and_submit_extent() submits the mapped part of the folio only
> for retryable errors. On a fatal error it discards the whole folio,
> including dirty buffers whose mapping has already succeeded. This loses
> data that could still be submitted.
> 
> With dioread_nolock, the mapped ranges can also remain in io_end's
> unwritten conversion list. Conversion can then mark those extents
> written without their data ever being submitted, exposing stale data.
> 
> Also submit the mapped buffers after a fatal mapping error when the
> filesystem is not in an emergency state. Discard buffers still marked
> BH_Delay or BH_Unwritten so that writeback does not keep retrying them.
> Clearing their dirty bits alone would leave stale buffer mappings and
> delayed allocation reservations. Remove their extent status entries and
> invalidate the buffers. Do this after folio_clear_dirty_for_io(), since
> cleaning mmap writes can mark all buffers dirty again.
> 
> Update i_disksize using the mapped boundary before moving start_pos past
> the folio. Advancing it earlier could include discarded data in the size
> update. Advancing it afterwards makes mpage_release_unused_pages() skip
> the handled folio and its extent status entries, including any entries
> created by new writes after the folio was unlocked. Count the handled
> folio against the writeback budget on fatal errors. Keep the existing
> retry behavior for transient errors.
> 
> Record fatal mapping errors before discarding dirty buffers so that
> fsync() can report the lost writes.
> 
> Fixes: c8cc88163f40 ("ext4: Add support for blocksize < pagesize in dioread_nolock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Hi Julian Sun,

Thank you for the fix. I agree with the issue that you fixed in patches
2 and 3. However, personally, I think the solution is too complicated
for me, this makes the already quite complex writeback logic even more
complicated. Especially for this patch, the semantics of
mpage_submit_folio() are no longer straightforward..

I agree with calling mpage_submit_partial_folio() when a partial folio
is processed, even for the fatal case, but I'd prefer to leave the
partial folio over instead of invalidating it (It would also be good to
wait for Jan's and Ted's thoughts). This is because this folio can be
invalidated in the next iteration if we encounter the same error again
since 'progress' won't be set in the next iteration and the
mpd->start_pos will stay point to the beginning of that folio, so it will
not lead to infinite loops. Besides, the original invalidate handling
also only cleared the dirty folios collected in this round, not all dirty
folios. So far, I haven't been able to think of any side effects that
leaving it behind could cause, or am I missing something?

Therefore, I think the fix can be simplified to something like the below
(note that this has not been tested). What do you think?



diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a77a9d9c44ba..5f8740f33740 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1836,7 +1836,7 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
 				       bool invalidate)
 {
 	unsigned nr, i;
-	pgoff_t index, end;
+	pgoff_t start_index, index, end;
 	struct folio_batch fbatch;
 	struct inode *inode = mpd->inode;
 	struct address_space *mapping = inode->i_mapping;
@@ -1846,29 +1846,48 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
 		return;

 	mpd->scanned_until_end = 0;
-	if (invalidate) {
-		ext4_lblk_t start, last;
-		start = EXT4_B_TO_LBLK(inode, mpd->start_pos);
-		last = mpd->next_pos >> inode->i_blkbits;
-
-		/*
-		 * avoid racing with extent status tree scans made by
-		 * ext4_insert_delayed_block()
-		 */
-		down_write(&EXT4_I(inode)->i_data_sem);
-		ext4_es_remove_extent(inode, start, last - start);
-		up_write(&EXT4_I(inode)->i_data_sem);
-	}

 	folio_batch_init(&fbatch);
-	index = mpd->start_pos >> PAGE_SHIFT;
+	start_index = mpd->start_pos >> PAGE_SHIFT;
+	index = start_index;
 	end = mpd->next_pos >> PAGE_SHIFT;
 	while (index < end) {
+		bool first_batch = (index == start_index);
+		struct folio *folio;
+
 		nr = filemap_get_folios(mapping, &index, end - 1, &fbatch);
 		if (nr == 0)
 			break;
+
+		if (invalidate && first_batch) {
+			ext4_lblk_t start, last;
+			loff_t start_pos = mpd->start_pos;
+
+			/*
+			 * A folio starting before start_pos was partially
+			 * submitted and is kept dirty for the next round,
+			 * so keep its extent status and reservations.
+			 */
+			folio = fbatch.folios[0];
+			if (folio_pos(folio) < start_pos)
+				start_pos = folio_next_pos(folio);
+
+			if (start_pos < mpd->next_pos) {
+				start = EXT4_B_TO_LBLK(inode, start_pos);
+				last = mpd->next_pos >> inode->i_blkbits;
+
+				/*
+				 * avoid racing with extent status tree scans
+				 * made by ext4_insert_delayed_block()
+				 */
+				down_write(&EXT4_I(inode)->i_data_sem);
+				ext4_es_remove_extent(inode, start,
+						      last - start);
+				up_write(&EXT4_I(inode)->i_data_sem);
+			}
+		}
 		for (i = 0; i < nr; i++) {
-			struct folio *folio = fbatch.folios[i];
+			folio = fbatch.folios[i];

 			if (folio_pos(folio) < mpd->start_pos)
 				continue;
@@ -2596,6 +2615,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 	int progress = 0;
 	ext4_io_end_t *io_end = mpd->io_submit.io_end;
 	struct ext4_io_end_vec *io_end_vec;
+	bool fatal = false;

 	io_end_vec = ext4_alloc_io_end_vec(io_end);
 	if (IS_ERR(io_end_vec))
@@ -2606,8 +2626,10 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 		if (err < 0) {
 			struct super_block *sb = inode->i_sb;

-			if (ext4_emergency_state(sb))
-				goto invalidate_dirty_pages;
+			if (ext4_emergency_state(sb)) {
+				*give_up_on_write = true;
+				return err;
+			}
 			/*
 			 * Let the uper layers retry transient errors.
 			 * In the case of ENOSPC, if ext4_count_free_blocks()
@@ -2615,17 +2637,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 			 */
 			if ((err == -ENOMEM) || (err == -EAGAIN) ||
 			    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
-				/*
-				 * We may have already allocated extents for
-				 * some bhs inside the folio, issue the
-				 * corresponding data to prevent stale data.
-				 */
-				if (progress) {
-					if (mpage_submit_partial_folio(mpd))
-						goto invalidate_dirty_pages;
-					goto update_disksize;
-				}
-				return err;
+				break;
 			}
 			ext4_msg(sb, KERN_CRIT,
 				 "Delayed block allocation failed for "
@@ -2639,9 +2651,8 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 				 "be lost\n");
 			if (err == -ENOSPC)
 				ext4_print_free_blocks(inode);
-		invalidate_dirty_pages:
-			*give_up_on_write = true;
-			return err;
+			fatal = true;
+			break;
 		}
 		progress = 1;
 		/*
@@ -2650,10 +2661,24 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 		 */
 		err = mpage_map_and_submit_buffers(mpd);
 		if (err < 0)
-			goto update_disksize;
+			break;
 	} while (map->m_len);

-update_disksize:
+	if (err < 0) {
+		/*
+		 * We may have already allocated extents for some bhs inside
+		 * the folio, issue the corresponding data to prevent stale
+		 * data.
+		 */
+		if (progress && mpage_submit_partial_folio(mpd))
+			fatal = true;
+
+		if (fatal)
+			*give_up_on_write = true;
+		if (!progress)
+			return err;
+	}
+
 	/*
 	 * Update on-disk size after IO is submitted.  Races with
 	 * truncate are avoided by checking i_size under i_data_sem.





> ---
>  fs/ext4/inode.c | 109 +++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 84 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 74437fe6aa24..81aac8744f3d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2192,13 +2192,46 @@ static void mpage_folio_done(struct mpage_da_data *mpd, struct folio *folio)
>  	folio_unlock(folio);
>  }
>  
> -static void mpage_submit_folio(struct mpage_da_data *mpd, struct folio *folio)
> +static void mpage_submit_folio(struct mpage_da_data *mpd, struct folio *folio,
> +			       bool fatal)
>  {
>  	size_t len;
>  	loff_t size;
>  
>  	WARN_ON_ONCE(folio_pos(folio) != mpd->start_pos);
>  	folio_clear_dirty_for_io(folio);
> +
> +	/*
> +	 * If a later mapping fails with a fatal error, write the buffers
> +	 * ALREADY mapped and discard the data in buffers still needing
> +	 * mapping. Do this after folio_clear_dirty_for_io(), which may
> +	 * mark all buffers dirty again for mmap writes.
> +	 */
> +	if (fatal) {
> +		struct buffer_head *bh, *head;
> +		ext4_lblk_t start, length;
> +		struct inode *inode = mpd->inode;
> +
> +		/*
> +		 * Remove the ES entries, free the reserved space and clear the
> +		 * buffer mappings before new writes can use this folio. Hold
> +		 * i_data_sem to prevent races with delayed allocation lookups.
> +		 */
> +		down_write(&EXT4_I(inode)->i_data_sem);
> +
> +		bh = head = folio_buffers(folio);
> +		do {
> +			if (buffer_delay(bh) || buffer_unwritten(bh)) {
> +				start = EXT4_B_TO_LBLK(inode, folio_pos(folio) + bh_offset(bh));
> +				length = bh->b_size >> inode->i_blkbits;
> +				ext4_es_remove_extent(inode, start, length);
> +				block_invalidate_folio(folio, bh_offset(bh), bh->b_size);
> +			}
> +		} while ((bh = bh->b_this_page) != head);
> +
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +	}
> +
>  	/*
>  	 * We have to be very careful here!  Nothing protects writeback path
>  	 * against i_size changes and the page can be writeably mapped into
> @@ -2324,7 +2357,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
>  	} while (lblk++, (bh = bh->b_this_page) != head);
>  	/* So far everything mapped? Submit the page for IO. */
>  	if (mpd->map.m_len == 0) {
> -		mpage_submit_folio(mpd, head->b_folio);
> +		mpage_submit_folio(mpd, head->b_folio, false);
>  		mpage_folio_done(mpd, head->b_folio);
>  	}
>  	if (lblk >= blocks) {
> @@ -2455,7 +2488,7 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd, int *progress
>  			if (err < 0 || map_bh)
>  				goto out;
>  			/* Page fully mapped - let IO run! */
> -			mpage_submit_folio(mpd, folio);
> +			mpage_submit_folio(mpd, folio, false);
>  			mpage_folio_done(mpd, folio);
>  		}
>  		folio_batch_release(&fbatch);
> @@ -2526,14 +2559,15 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
>  }
>  
>  /*
> - * This is used to submit mapped buffers in a single folio that is not fully
> - * mapped for various reasons, such as insufficient space or journal credits.
> + * Write the buffers that are ready in a partly mapped folio. On a fatal
> + * error, drop the buffers that still need mapping instead of retrying them.
> + * Return the byte offset just past the folio on success, or a negative error.
>   */
> -static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
> +static loff_t mpage_submit_partial_folio(struct mpage_da_data *mpd, bool fatal)
>  {
>  	struct inode *inode = mpd->inode;
>  	struct folio *folio;
> -	loff_t pos;
> +	loff_t pos, end;
>  
>  	folio = filemap_get_folio(inode->i_mapping,
>  				  mpd->start_pos >> PAGE_SHIFT);
> @@ -2548,18 +2582,21 @@ static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
>  			 !folio_contains(folio, pos >> PAGE_SHIFT)))
>  		return -EINVAL;
>  
> -	mpage_submit_folio(mpd, folio);
> +	end = folio_next_pos(folio);
> +	mpage_submit_folio(mpd, folio, fatal);
>  	/*
>  	 * Update start_pos to prevent this folio from being released in
> -	 * mpage_release_unused_pages(), it will be reset to the aligned folio
> -	 * pos when this folio is written again in the next round. Additionally,
> -	 * do not update wbc->nr_to_write here, as it will be updated once the
> -	 * entire folio has finished processing.
> +	 * mpage_release_unused_pages(). For retryable errors, it will be reset
> +	 * to the aligned folio pos when this folio is written again in the next
> +	 * round. Count the folio now only for fatal errors; otherwise the
> +	 * retry will count it once the entire folio has finished processing.
>  	 */
>  	mpd->start_pos = pos;
> +	if (fatal)
> +		mpd->wbc->nr_to_write -= folio_nr_pages(folio);
>  	folio_unlock(folio);
>  	folio_put(folio);
> -	return 0;
> +	return end;
>  }
>  
>  /*
> @@ -2593,6 +2630,8 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  	int progress = 0;
>  	ext4_io_end_t *io_end = mpd->io_submit.io_end;
>  	struct ext4_io_end_vec *io_end_vec;
> +	bool fatal = false;
> +	loff_t next_folio_pos = 0;
>  
>  	io_end_vec = ext4_alloc_io_end_vec(io_end);
>  	if (IS_ERR(io_end_vec))
> @@ -2626,18 +2665,29 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  		 */
>  		if ((err == -ENOMEM) || (err == -EAGAIN) ||
>  		    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
> -			/*
> -			 * We may have already allocated extents for
> -			 * some bhs inside the folio, issue the
> -			 * corresponding data to prevent stale data.
> -			 */
> -			if (progress) {
> -				if (mpage_submit_partial_folio(mpd))
> -					goto invalidate_dirty_pages;
> -				goto update_disksize;
> -			}
> -			return err;
> +			/* Already false, but set it here to make the choice clear. */
> +			fatal = false;
> +		} else {
> +			fatal = true;
> +			mapping_set_error(inode->i_mapping, err);
> +		}
> +
> +		/*
> +		 * We may have already allocated extents for
> +		 * some bhs inside the folio, issue the
> +		 * corresponding data to prevent stale data.
> +		 */
> +		if (progress) {
> +			next_folio_pos = mpage_submit_partial_folio(mpd, fatal);
> +			if (next_folio_pos < 0)
> +				goto invalidate_dirty_pages;
> +
> +			goto update_disksize;
>  		}
> +
> +		if (!fatal)
> +			return err;
> +
>  		ext4_msg(sb, KERN_CRIT,
>  			 "Delayed block allocation failed for "
>  			 "inode %llu at logical offset %llu with"
> @@ -2681,6 +2731,15 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  		if (!err)
>  			err = err2;
>  	}
> +	if (fatal) {
> +		/*
> +		 * We have submitted the mapped buffers and dropped the rest.
> +		 * After updating i_disksize, move start_pos past this folio so
> +		 * mpage_release_unused_pages() skips its buffers and ES entries.
> +		 */
> +		mpd->start_pos = next_folio_pos;
> +		*give_up_on_write = true;
> +	}
>  	return err;
>  }
>  
> @@ -2863,7 +2922,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			 * through a pin.
>  			 */
>  			if (!mpd->can_map) {
> -				mpage_submit_folio(mpd, folio);
> +				mpage_submit_folio(mpd, folio, false);
>  				err = 0;
>  				/* Pending dirtying of journalled data? */
>  				if (folio_test_checked(folio)) {

