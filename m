Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795851829;
	b=5YjceK1GHQVEDvcwcIce81OsH/XxmTPSQRlW35ylEMw8k/MAm0+IlFqFq/+XxRmAOqjf
	 bj1nXqO5CGgBpIH530HRbzDMU25VVdTKL6iekuHcfO3mjq0yfWr3SpjcHErwnCPJX4BNp
	 AmPCGB8kSRzKXd3Qx6X7xr570UIX/8KHwigSuce7gnDwZ8dSZpA3eSy2CTOe+WCLvmqyf
	 7r/+bWZ8hHc2yF4L0+6V8X1EQ7XElmyUMaOJpA3DwnuD1rq8HyCgFoze0PKyMElvnf+0q
	 YP7FVIbK4OcEXdyC5x1qwqItHxSSY5lTibtaM9nFoiKsHz33bz+yIiCg/M3dzynaV/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795851829;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=NckPJGDh2JpvzahLWqZpCXIJ/5CeBGdVRc1xWXZ06Yk=;
	b=anlOGxoCxHX0PYgs89bDpLiv65b1Jt5r2/yskRjXmy3wxhPqCr1LqMbVmtZJ3aI9pz9W
	 HyF2kGh5DRqBP/kBGdBkanCfJ77kZN3teA5mRtzguwHvXBEgSWi/tAR7LWezspiDurmnN
	 qrd8fM/Wa6xny0VdQRHSaEBBWA/Ow3f+Wb/mRhyd8lefa86MB/tTsG4EcNqcXkfqpDndc
	 ZS2tQ8sw66e36x8ZE8wMRH+0+SIDX58qk5A8/naPBjKSSWfxctZvXwsR9CAkl36+2eGwv
	 Xz1hrciTDfZC+FsAVEzfuG1+ae6XdPowI1f8ONwb6F1ZZf5tE2Yu/99rc/c0hhb8HFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DCB606A31C
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 07:43:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1DCB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jc2Mj3kcsz1rrk4
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 15:43:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D20E840573
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 15:43:37 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAXTu0ohgprk+x1GA--.60011S3;
	Sat, 28 Nov 2026 15:43:37 +0800 (CST)
Message-ID: <82f9dc74-ded9-482d-bfbd-5d0d11246fd0@huaweicloud.com>
Date: Sat, 28 Nov 2026 15:43:35 +0800
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
Subject: Re: [PATCH v3 1/3] ext4: fix a race between partial writeback and
 truncation
To: Julian Sun <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, riteshh@linux.ibm.com
References: <20261116064404.189911-1-sunjunchao@bytedance.com>
 <20261116064404.189911-2-sunjunchao@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261116064404.189911-2-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAXTu0ohgprk+x1GA--.60011S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gry7WFW5Ww4fCw47XFWxtFb_yoW3JF48pF
	WxK39IkF4DJw4a9rn3Ca1Durn2v3s5Jr4UGF17GasIyFn8KF10k3Wjg3WqvF45Jr97Aay8
	Zw4jyryDGa1xZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 11/16/2026 2:44 PM, Julian Sun wrote:
> After a retryable mapping error, mpage_submit_partial_folio() submits the
> mapped buffers, advances start_pos into the folio and unlocks it.
> mpage_release_unused_pages() subsequently looks up the remaining range
> and skips the partial folio by comparing its position with start_pos.
> 
> Once unlocked, the folio can be truncated and replaced by smaller folios.
> A replacement at or beyond start_pos passes the position check even
> though writeback does not own its lock. Cleanup can then hit the locked
> folio assertion or unlock a folio held by another task.
> 
> The race was reproduced reliably using local code instrumentation to
> widen the race window, triggering BUG_ON(!folio_test_locked(folio)) in
> mpage_release_unused_pages().
> The issue could no longer be reproduced after applying this patch.
> 
> On this retryable error path, cleanup only needs to unlock unused folios.
> The partial folio has already been unlocked. Its buffers still needing
> mapping remain dirty, and ext4_bio_write_folio() redirties the folio for a
> later writeback attempt. The existing code therefore intends to leave
> it alone. Any new folios inserted into the same range were not locked by
> this writeback operation and must also be excluded. The following unused
> folios still need their locks released.
> 
> Record the end of the partially submitted folio before unlocking it,
> and start cleanup at that offset.
> 
> Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents mapping loop")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Hi Julian!

This is a nice catch and overall makes sense to me. I just have one
minor suggestion below.

> ---
>  fs/ext4/inode.c |   42 +++++++++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e3129353d4ed..6dad9eea7824 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1825,22 +1825,27 @@
>  };
>  
>  static void mpage_release_unused_pages(struct mpage_da_data *mpd,
> -				       bool invalidate)
> +				       bool invalidate, loff_t release_start)


The variable name release_start is not very clear to me. Currently its
semantics are that it is only assigned a valid value during partial
folio submission, and is 0 in all other cases. So I suggest renaming it,
for example to 'partial_folio_end'? Besides, adding a comment to explain
it, which would be better.


>  {
>  	unsigned nr, i;
>  	pgoff_t index, end;
>  	struct folio_batch fbatch;
>  	struct inode *inode = mpd->inode;
>  	struct address_space *mapping = inode->i_mapping;
> +	loff_t start_pos = max(mpd->start_pos, release_start);


Then would it be better to rename start_pos here to release_start?

Thanks,
Yi.


>  
>  	/* This is necessary when next_pos == 0. */
>  	if (mpd->start_pos >= mpd->next_pos)
>  		return;
>  
> +	/* A partially submitted folio may need another writeback pass. */
>  	mpd->scanned_until_end = 0;
> +	if (start_pos >= mpd->next_pos)
> +		return;
> +
>  	if (invalidate) {
>  		ext4_lblk_t start, last;
> -		start = EXT4_B_TO_LBLK(inode, mpd->start_pos);
> +		start = EXT4_B_TO_LBLK(inode, start_pos);
>  		last = mpd->next_pos >> inode->i_blkbits;
>  
>  		/*
> @@ -1853,7 +1858,7 @@
>  	}
>  
>  	folio_batch_init(&fbatch);
> -	index = mpd->start_pos >> PAGE_SHIFT;
> +	index = start_pos >> PAGE_SHIFT;
>  	end = mpd->next_pos >> PAGE_SHIFT;
>  	while (index < end) {
>  		nr = filemap_get_folios(mapping, &index, end - 1, &fbatch);
> @@ -1862,7 +1867,7 @@
>  		for (i = 0; i < nr; i++) {
>  			struct folio *folio = fbatch.folios[i];
>  
> -			if (folio_pos(folio) < mpd->start_pos)
> +			if (folio_pos(folio) < start_pos)
>  				continue;
>  			if (folio_next_index(folio) > end)
>  				continue;
> @@ -2523,7 +2528,8 @@
>   * This is used to submit mapped buffers in a single folio that is not fully
>   * mapped for various reasons, such as insufficient space or journal credits.
>   */
> -static int mpage_submit_partial_folio(struct mpage_da_data *mpd)
> +static int mpage_submit_partial_folio(struct mpage_da_data *mpd,
> +				      loff_t *release_start)
>  {
>  	struct inode *inode = mpd->inode;
>  	struct folio *folio;
> @@ -2544,13 +2550,17 @@
>  
>  	mpage_submit_folio(mpd, folio);
>  	/*
> -	 * Update start_pos to prevent this folio from being released in
> -	 * mpage_release_unused_pages(), it will be reset to the aligned folio
> -	 * pos when this folio is written again in the next round. Additionally,
> +	 * Update start_pos to the mapped boundary. It will be reset to the aligned
> +	 * folio pos when this folio is written again in the next round. Additionally,
>  	 * do not update wbc->nr_to_write here, as it will be updated once the
>  	 * entire folio has finished processing.
> +	 *
> +	 * Once unlocked, the folio can be removed from the page cache and
> +	 * replaced. Set release_start past this folio so that
> +	 * mpage_release_unused_pages() skips its entire range.
>  	 */
>  	mpd->start_pos = pos;
> +	*release_start = folio_next_pos(folio);
>  	folio_unlock(folio);
>  	folio_put(folio);
>  	return 0;
> @@ -2565,6 +2575,8 @@
>   * @give_up_on_write - we set this to true iff there is a fatal error and there
>   *                     is no hope of writing the data. The caller should discard
>   *                     dirty pages to avoid infinite loops.
> + * @release_start - minimum byte offset for releasing unused folios.
> + *                  The caller must initialize it to zero.
>   *
>   * The function maps extent starting at mpd->lblk of length mpd->len. If it is
>   * delayed, blocks are allocated, if it is unwritten, we may need to convert
> @@ -2578,7 +2590,8 @@
>   */
>  static int mpage_map_and_submit_extent(handle_t *handle,
>  				       struct mpage_da_data *mpd,
> -				       bool *give_up_on_write)
> +				       bool *give_up_on_write,
> +				       loff_t *release_start)
>  {
>  	struct inode *inode = mpd->inode;
>  	struct ext4_map_blocks *map = &mpd->map;
> @@ -2612,7 +2625,8 @@
>  				 * corresponding data to prevent stale data.
>  				 */
>  				if (progress) {
> -					if (mpage_submit_partial_folio(mpd))
> +					if (mpage_submit_partial_folio(mpd,
> +								       release_start))
>  						goto invalidate_dirty_pages;
>  					goto update_disksize;
>  				}
> @@ -3017,7 +3031,7 @@
>  	}
>  	ret = mpage_prepare_extent_to_map(mpd);
>  	/* Unlock pages we didn't use */
> -	mpage_release_unused_pages(mpd, false);
> +	mpage_release_unused_pages(mpd, false, 0);
>  	/* Submit prepared bio */
>  	ext4_io_submit(&mpd->io_submit);
>  	ext4_put_io_end_defer(mpd->io_submit.io_end);
> @@ -3026,6 +3040,8 @@
>  		goto unplug;
>  
>  	while (!mpd->scanned_until_end && wbc->nr_to_write > 0) {
> +		loff_t release_start = 0;
> +
>  		/* For each extent of pages we use new io_end */
>  		mpd->io_submit.io_end = ext4_init_io_end(inode, GFP_KERNEL);
>  		if (!mpd->io_submit.io_end) {
> @@ -3070,7 +3086,7 @@
>  		ret = mpage_prepare_extent_to_map(mpd);
>  		if (!ret && mpd->map.m_len)
>  			ret = mpage_map_and_submit_extent(handle, mpd,
> -					&give_up_on_write);
> +					&give_up_on_write, &release_start);
>  		/*
>  		 * Caution: If the handle is synchronous,
>  		 * ext4_journal_stop() can wait for transaction commit
> @@ -3087,7 +3103,7 @@
>  			mpd->do_map = 0;
>  		}
>  		/* Unlock pages we didn't use */
> -		mpage_release_unused_pages(mpd, give_up_on_write);
> +		mpage_release_unused_pages(mpd, give_up_on_write, release_start);
>  		/* Submit prepared bio */
>  		ext4_io_submit(&mpd->io_submit);
>  

