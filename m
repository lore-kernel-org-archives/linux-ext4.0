Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794050978;
	b=O0XZX/uyfOQilcq8yz7cV5b9pNEG3agdzfdPVmXFRol0OxrOVTh5Nrvuffw+Ff++Mi9Q
	 U9HxnYkdq67IuLJLk5rr95v2eLgYCN9sYJk9jlORiWB3CHFYC+S/WrAEon1ay4rT+mm7o
	 4rwghQQy0zqOY8IWiobhP5uiQkBkLAMiwEfrByFh8bYZdPNz6iy8muCD86PlA+y+WSimb
	 1jv5hsmI4rvpUALTuoDNYBIAhMi66el/xN8rtkg0NTlN222y9uRkfXcjLL1eo8r6LBGuq
	 UaQr2jd87HoFJla0uYZnDV0ljj/Cju9ipRVAV4VYpvakQaHLyBjJtrJvrmk/vuVZnXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794050978;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=XTQJ3blKB/gya82dQlcokNu43+cQ65AG4yAW7immTSA=;
	b=ao8RUbL+oNXUJFs7SMRyT0+ciTkGWKUqZpL3mQ4qcXZIrt6TY8run/7Qm2J9R+r8wiQJ
	 I6+djMYs3ZuwaBLQY67Ldt5cLPwiks7N4zQ3XfeO6XCqCZ0tNTRdPR8ztGKCbPuaPqLzO
	 ndi4XVIGV/QzNk3ffo7ZNOXImPefpZBzrDvIdF06zb7JdM3PFNsB1MnPOPmmBHFtjnOpn
	 TI8j4rZKdlb1SlvmICfBHXn3kjhAaugsoL1fDkH8NtrqdOfJFE2orFJvnfSeea+w44Yry
	 9gW6nwBlsjwoNdYT80YvICjKNBJZ2URO1E6LCE/hhVUf1TLJ5ADrVpBm6R0azb71G0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=khjNhppE;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CFE606A32C
	for <linux-ext4@vger.kernel.org>; Sat,  7 Nov 2026 11:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07CFE606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=khjNhppE
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3282db206d3so3322734eec.0
        for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 03:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794050976; x=1794655776; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XTQJ3blKB/gya82dQlcokNu43+cQ65AG4yAW7immTSA=;
        b=khjNhppEPPzq360ABFvdsR071SoVa4+4sghWg5olB0nGsWjHuZjmbNS+whNX6YVCtf
         +jqYMmHLoecS+Z9LVVTVQKkYL4IMlKsotMDZU/4HWUVqHRYUL9yuxJeh7lvGdCyTvWRI
         1KNuo8V1JVjPEqpulAUpKDo/JpRlgjhzd78keFkeNkFuBHRltic+1lEB/O5NVFULVDav
         06aAjSfxIgZYAlX8O5FW/0uD4w4SMIAoFS1eRAMqUc4tGdw5dhaTXgKymfHPDOYPRNsz
         XaIeU0kL1bEbi/q9qVD5WuNyAIwOsMp8g3XlP1D69+Oo1Zn4iOrtlrK+DoqLETDNLA07
         xVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794050976; x=1794655776;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTQJ3blKB/gya82dQlcokNu43+cQ65AG4yAW7immTSA=;
        b=wujIGldaQ7uO01D78v4kvztR9OqkNhbYcpR70y+uSkm4i7fX1EdtbZAESDY3q3YBLL
         PNHswbjzcdUYExCYqitPnX1uQZMp9JvMOJvMC9Y6XwVZOdhkG5wq7ej8sL8b/HuXzNA8
         rLkqLww7WsosHVitIwYPSUqBOa6kHWdVvgEtnzuZ2sSZ2QeJgKlKjwVX+hxvm4BBIJJj
         MJCDtxlE4CtQ16XqXnPaTzzUcu1gdCOaHrmtksJnBRvsiAxXG2fN/wR/Wwg+1FYbKFw3
         vFKu2Y2Qb8q3fao2pQVNUAXw7DKl0YOy2WQZp21HdH/caOwiEzgx+LQUdPteYinxdY/y
         OU0g==
X-Gm-Message-State: APuU4Z+OAZAPFAi6ywirr+1q4C8H7VVaNswveW1H8Hprbl91XcLH5o0Z
	hrCNHIQw9tOJk1GrhoI+n8ERDAjzDVBJsKyFmVEU3ffqgtlQ9MIpE8otpsg2Ay2d0LWj/3s3W9I
	tuPyN
X-Gm-Gg: AYBFou3/bCSPHMS+oZq19HOsVwZOyyocEZLr6e+PlKm7AyhbBU3qzRcSbsvqw8zVOh3
	ZcchTMEMnj71jGT1vtEQVGIuSmz1alX2VsD1lLfvT/eXOAngm2twFJl0N1j+mwfZPurXzOjLH6J
	HbZ1d9KEoJTA3wWB5zNl8hYGCPCR2khbNHOc586koawx8mTI5LE4SlrE8GfUKoY2SL6V7I/Bg5m
	cyHlyVtd+SGN/RHKrOXGEQ0Yc2GblaI8Ff2syqMYmcLSzvu14VC+vWkNqO+qnUXJKwq/YdiyaoT
	nZNTS8TZFmN4ZeDcmdFyQ+OzBIyHUP778y2BAg7wnPqAYBrrYHJuneBh+WgyaNhyhr/vJijous6
	5J6LUTBh0fz5zAOm7Dts7aiT6huamFWzVC+VhPZ6hZsoY5oPtgaiEQA7z5c6UI/sZKh2rCzF8C6
	H4tFt9hEB50UZkSieRAsHmu15R06pvTh2g3UK+i+DjdU+lIVhK0Q3cjU4McJevulpqb8S1ixXVO
	/zx/tBrWclXuA/B6GHwU3WmxaPX9uKAPjIvf9vL30XVE2xBmu9N8nNdEn8sahnoLFCEFjwmxAiA
	sXoPaj8c7fzQyPofR2bbRzRnU6t/kBvld3tjoNVayAgpn6VMT7cAasEyTCJt2lejS7O2EQ8M
X-Received: by 2002:a05:7301:fc02:b0:36c:3b8a:8089 with SMTP id 5a478bee46e88-36f76d0ed49mr8187242eec.36.1794050975713;
        Sat, 07 Nov 2026 03:29:35 -0800 (PST)
Received: from [100.81.10.186] ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa8e3a47esm20596746eec.6.2026.11.07.03.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2026 03:29:35 -0800 (PST)
Message-ID: <11f169f1-8d0a-4994-b800-1835b8df3ba5@bytedance.com>
Date: Sat, 7 Nov 2026 19:29:30 +0800
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
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, riteshh@linux.ibm.com
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
 <20261023061851.45579-4-sunjunchao@bytedance.com>
 <e87fc578-26cb-4f38-a310-09856a1ba072@huaweicloud.com>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <e87fc578-26cb-4f38-a310-09856a1ba072@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/26 5:10 PM, Zhang Yi wrote:
> On 10/23/2026 2:18 PM, Julian Sun wrote:
>> When the block size is smaller than the folio size, a folio can contain
>> several extents that need mapping. Mapping an earlier extent can succeed
>> before mapping a later extent fails with a fatal error such as -EIO.
>>
>> mpage_map_and_submit_extent() submits the mapped part of the folio only
>> for retryable errors. On a fatal error it discards the whole folio,
>> including dirty buffers whose mapping has already succeeded. This loses
>> data that could still be submitted.
>>
>> With dioread_nolock, the mapped ranges can also remain in io_end's
>> unwritten conversion list. Conversion can then mark those extents
>> written without their data ever being submitted, exposing stale data.
>>
>> Also submit the mapped buffers after a fatal mapping error when the
>> filesystem is not in an emergency state. Discard buffers still marked
>> BH_Delay or BH_Unwritten so that writeback does not keep retrying them.
>> Clearing their dirty bits alone would leave stale buffer mappings and
>> delayed allocation reservations. Remove their extent status entries and
>> invalidate the buffers. Do this after folio_clear_dirty_for_io(), since
>> cleaning mmap writes can mark all buffers dirty again.
>>
>> Update i_disksize using the mapped boundary before moving start_pos past
>> the folio. Advancing it earlier could include discarded data in the size
>> update. Advancing it afterwards makes mpage_release_unused_pages() skip
>> the handled folio and its extent status entries, including any entries
>> created by new writes after the folio was unlocked. Count the handled
>> folio against the writeback budget on fatal errors. Keep the existing
>> retry behavior for transient errors.
>>
>> Record fatal mapping errors before discarding dirty buffers so that
>> fsync() can report the lost writes.
>>
>> Fixes: c8cc88163f40 ("ext4: Add support for blocksize < pagesize in dioread_nolock")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> 
> Hi Julian Sun,
> 
> Thank you for the fix. I agree with the issue that you fixed in patches
> 2 and 3. However, personally, I think the solution is too complicated
> for me, this makes the already quite complex writeback logic even more
> complicated. Especially for this patch, the semantics of
> mpage_submit_folio() are no longer straightforward..

Hi Yi,

Thanks for the review and the suggested simplification. I agree that
your approach is simpler and looks like it can address the same issues.

I'll send v3 after further testing.
> 
> I agree with calling mpage_submit_partial_folio() when a partial folio
> is processed, even for the fatal case, but I'd prefer to leave the
> partial folio over instead of invalidating it (It would also be good to
> wait for Jan's and Ted's thoughts). This is because this folio can be
> invalidated in the next iteration if we encounter the same error again
> since 'progress' won't be set in the next iteration and the
> mpd->start_pos will stay point to the beginning of that folio, so it will
> not lead to infinite loops. Besides, the original invalidate handling
> also only cleared the dirty folios collected in this round, not all dirty
> folios. So far, I haven't been able to think of any side effects that
> leaving it behind could cause, or am I missing something?
> 
> Therefore, I think the fix can be simplified to something like the below
> (note that this has not been tested). What do you think?
> 
> 
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a77a9d9c44ba..5f8740f33740 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1836,7 +1836,7 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
>  				       bool invalidate)
>  {
>  	unsigned nr, i;
> -	pgoff_t index, end;
> +	pgoff_t start_index, index, end;
>  	struct folio_batch fbatch;
>  	struct inode *inode = mpd->inode;
>  	struct address_space *mapping = inode->i_mapping;
> @@ -1846,29 +1846,48 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
>  		return;
> 
>  	mpd->scanned_until_end = 0;
> -	if (invalidate) {
> -		ext4_lblk_t start, last;
> -		start = EXT4_B_TO_LBLK(inode, mpd->start_pos);
> -		last = mpd->next_pos >> inode->i_blkbits;
> -
> -		/*
> -		 * avoid racing with extent status tree scans made by
> -		 * ext4_insert_delayed_block()
> -		 */
> -		down_write(&EXT4_I(inode)->i_data_sem);
> -		ext4_es_remove_extent(inode, start, last - start);
> -		up_write(&EXT4_I(inode)->i_data_sem);
> -	}
> 
>  	folio_batch_init(&fbatch);
> -	index = mpd->start_pos >> PAGE_SHIFT;
> +	start_index = mpd->start_pos >> PAGE_SHIFT;
> +	index = start_index;
>  	end = mpd->next_pos >> PAGE_SHIFT;
>  	while (index < end) {
> +		bool first_batch = (index == start_index);
> +		struct folio *folio;
> +
>  		nr = filemap_get_folios(mapping, &index, end - 1, &fbatch);
>  		if (nr == 0)
>  			break;
> +
> +		if (invalidate && first_batch) {
> +			ext4_lblk_t start, last;
> +			loff_t start_pos = mpd->start_pos;
> +
> +			/*
> +			 * A folio starting before start_pos was partially
> +			 * submitted and is kept dirty for the next round,
> +			 * so keep its extent status and reservations.
> +			 */
> +			folio = fbatch.folios[0];
> +			if (folio_pos(folio) < start_pos)
> +				start_pos = folio_next_pos(folio);
> +
> +			if (start_pos < mpd->next_pos) {
> +				start = EXT4_B_TO_LBLK(inode, start_pos);
> +				last = mpd->next_pos >> inode->i_blkbits;
> +
> +				/*
> +				 * avoid racing with extent status tree scans
> +				 * made by ext4_insert_delayed_block()
> +				 */
> +				down_write(&EXT4_I(inode)->i_data_sem);
> +				ext4_es_remove_extent(inode, start,
> +						      last - start);
> +				up_write(&EXT4_I(inode)->i_data_sem);
> +			}
> +		}
>  		for (i = 0; i < nr; i++) {
> -			struct folio *folio = fbatch.folios[i];
> +			folio = fbatch.folios[i];
> 
>  			if (folio_pos(folio) < mpd->start_pos)
>  				continue;
> @@ -2596,6 +2615,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  	int progress = 0;
>  	ext4_io_end_t *io_end = mpd->io_submit.io_end;
>  	struct ext4_io_end_vec *io_end_vec;
> +	bool fatal = false;
> 
>  	io_end_vec = ext4_alloc_io_end_vec(io_end);
>  	if (IS_ERR(io_end_vec))
> @@ -2606,8 +2626,10 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  		if (err < 0) {
>  			struct super_block *sb = inode->i_sb;
> 
> -			if (ext4_emergency_state(sb))
> -				goto invalidate_dirty_pages;
> +			if (ext4_emergency_state(sb)) {
> +				*give_up_on_write = true;
> +				return err;
> +			}
>  			/*
>  			 * Let the uper layers retry transient errors.
>  			 * In the case of ENOSPC, if ext4_count_free_blocks()
> @@ -2615,17 +2637,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  			 */
>  			if ((err == -ENOMEM) || (err == -EAGAIN) ||
>  			    (err == -ENOSPC && ext4_count_free_clusters(sb))) {
> -				/*
> -				 * We may have already allocated extents for
> -				 * some bhs inside the folio, issue the
> -				 * corresponding data to prevent stale data.
> -				 */
> -				if (progress) {
> -					if (mpage_submit_partial_folio(mpd))
> -						goto invalidate_dirty_pages;
> -					goto update_disksize;
> -				}
> -				return err;
> +				break;
>  			}
>  			ext4_msg(sb, KERN_CRIT,
>  				 "Delayed block allocation failed for "
> @@ -2639,9 +2651,8 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  				 "be lost\n");
>  			if (err == -ENOSPC)
>  				ext4_print_free_blocks(inode);
> -		invalidate_dirty_pages:
> -			*give_up_on_write = true;
> -			return err;
> +			fatal = true;
> +			break;
>  		}
>  		progress = 1;
>  		/*
> @@ -2650,10 +2661,24 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  		 */
>  		err = mpage_map_and_submit_buffers(mpd);
>  		if (err < 0)
> -			goto update_disksize;
> +			break;
>  	} while (map->m_len);
> 
> -update_disksize:
> +	if (err < 0) {
> +		/*
> +		 * We may have already allocated extents for some bhs inside
> +		 * the folio, issue the corresponding data to prevent stale
> +		 * data.
> +		 */
> +		if (progress && mpage_submit_partial_folio(mpd))
> +			fatal = true;
> +
> +		if (fatal)
> +			*give_up_on_write = true;
> +		if (!progress)
> +			return err;
> +	}
> +
>  	/*
>  	 * Update on-disk size after IO is submitted.  Races with
>  	 * truncate are avoided by checking i_size under i_data_sem.
> 
> 
> 
> 
> 

> 

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
