Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D3A279DB1
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 02:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786934047; cv=none; b=HwGkg/qeL0U/fMGTdDp7oQHmgJ/jfK/Jpy7jr4xZbD6TCks1iUu6rDGil6a6JvDtLODAyNfhm3SCwOB8oK3LPb6k6MFBZkpBg3llz4hwsqAPXxYClA85H7wnZqSsV0AsrkusG5LImS9TQ7tb5s7Mua856tnXSwA+d3j9+uy2w9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786934047; c=relaxed/simple;
	bh=eTHtzAFZ85EdeGDqcWkQ/bQReWq5g02vZ3+EYMBU44Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TM7RW5mxRNFgZ1j3sM5qNw8m3sW9JcqUKoLgjzZxhSMkHWKNQxx4IItINuwqivcRf2Va3y4kne2/Ymr+jYW5NYXMqdOfrUy+v6ooaDrpR+TY49Fx5YDE2LnB3/4+OEwn3ywwB1ehYqQA9Ist5b3n69CotwRfethwqn9AKH0uHns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c2XPPwXd; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c2XPPwXd"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso2128057a91.3
        for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2026 19:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786934045; x=1787538845; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6xdmAG7qehxZR5RlI6+a6ahVKS+3T/VGOnRQ8szv9Ys=;
        b=c2XPPwXdECK8jXvh0e1T5wHZbjIPOoyF56x7f7pzBntIwETlh8/cSbDethekHMS3zp
         u+o4cFJLmivHw6u/WfJhPn8HlqNu0iCsIJdsDCI0Vlx7hf5B+kE6vV02YJMY6S9gfbDy
         uby5Jtuq45uxlgiTgcQF0pshRsqPhoC9NICzI8s43Qqa0vrb45t7jS4WkVFwlLs1mE1c
         ZsHuNhaeCn7zk9xjpAxNEl/6trGdqhspf9ZjUh2i921QxRyBiCnbfZc3TwxM0ISQuJre
         G07o5eVB4g8rUgHRJwXPiNWuvJt/gI4g32Mx6ZumNgHe77gCfIMKp+f843yqf1EPQRk4
         GFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786934045; x=1787538845;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6xdmAG7qehxZR5RlI6+a6ahVKS+3T/VGOnRQ8szv9Ys=;
        b=EVPBkJqYNu27aFWYGEcEokH9htEMouG8IVv/ASQBX4dAkBE4/cUssnIgxEifFXB4Bw
         pC00+PKr2fN5/lAdh/p34zeli5iHM75p1cvq5MVd/yPjF1UeRWwoAjBI1unpqTDw/FkY
         7c8t0ZzMY1j64gWKn3GVZhZ2dTxkH9uj1OzyH7dADiQP5Z8/OHciY27z+dFgFuv7mYu7
         A1twlfu+c35F/P8JF8LNdiBi5QOPvP0rd8X4kTw7IseDpQcXaO3L7YugicETTUPIiQwl
         f+o14ki3PnYxcbYkySEgG2NrbduIUutOTSy7EA02YOaJoowev5ne7AZpwaWtQNvIs2oH
         F6nw==
X-Gm-Message-State: AOJu0Yx9xYHHhTcn1Yotbp7MIHzCvkdbzp58hwF5zNATCpRr00tJ/6wG
	ztOewjl8jId2k48oBNh6uT7vg9Ou0hzElFcTohiNVyEFcz34IwXxuKwA
X-Gm-Gg: AR+sD13e72VhrZwY4vtvSXwt93bZu8+WoraaEre/xHcnTr+490GkJ9jHSOzhrehynkU
	3oqobC9JhMXHNeVDIlnTdeBjJqKbLVm4OGjwT3d8XnKcLNC0s/vCfg3xExwQD4YMEdU/xQdcemz
	06dZ1t1HKk8d1+d/gwc6NyJGiU9Zazg0PmVH93peMJFm27oEEmnbwE22bbp1llBVV8MXkLZzg7Z
	cKvdW1KT9FCfWA9TWFtFunlnYh9kooLB3TApBy+hHuW4KRFCI5BOC/3RTMcpx0exYNw0sZl36l1
	jYI7Vb8O3OUBbmGWtqoud1q3zhYK8eIncJIjM8aQ8CDn0nTZTIdQccMkd4rBs+TAAFJKQmfVKnt
	k83DPGLNd9ySrxss4hMG9IHoA6VgM7+7rp2+9uat2WZiWnESbAeFFa10YMIA2hMPT2f+ygSnfqN
	nA7/J8OEBsog3lhRjol7mu7QxHvriNW/GSeO3EFavbvqMkMcIuZ/M1A4uNPZIHECRVbGg4f6/OC
	/RWgx+B
X-Received: by 2002:a17:90b:3c02:b0:380:f389:447b with SMTP id 98e67ed59e1d1-3933b8938f9mr23461491a91.11.1786934044437;
        Sun, 16 Aug 2026 19:34:04 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e84118sm3147766a91.5.2026.08.16.19.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 19:34:03 -0700 (PDT)
Message-ID: <ead3fd2a-5c57-4f78-9ce1-9555b64fb8c0@gmail.com>
Date: Mon, 17 Aug 2026 10:33:58 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 15/32] ext4: implement buffered write path using
 iomap
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-16-yi.zhang@huaweicloud.com>
 <20260814104055.7F2C21F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814104055.7F2C21F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:40 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] Extending a file within an already-allocated block does not update the on-disk `i_disksize` or mark the inode dirty, causing appended data to be lost on a crash or unmount.
> - [High] The iomap non-delalloc buffered write path permanently leaks unwritten extents past `i_size` when a short write or failure occurs.
> --
> 
> --- Patch [15]: [PATCH -next v5 15/32] ext4: implement buffered write path using iomap ---
> commit 7a553e37ec457f0a485aa7c6fc378e68d6d66bfb
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: implement buffered write path using iomap
> 
> This commit introduces two new iomap_ops instances for ext4 buffered writes:
> one for delayed allocation mode and another for non-delayed allocation mode.
> It also updates the folio lock and transaction start ordering for the new
> iomap buffered write path.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 9098d9a5fc05b..d831d1911a6ff 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> 
> [ ... ]
> 
>> @@ -3994,6 +4009,113 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
>>   	return 0;
>>   }
>>   
>> +static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
>> +		loff_t offset, loff_t length, unsigned int flags,
>> +		struct iomap *iomap, struct iomap *srcmap, bool delalloc)
>> +{
>> +	int ret, retries = 0;
>> +	struct ext4_map_blocks map;
>> +	int map_flags;
>> +
>> +	ret = ext4_emergency_state(inode->i_sb);
>> +	if (unlikely(ret))
>> +		return ret;
>> +
>> +	/* Inline data and non-extent are not supported. */
>> +	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
>> +		return -ERANGE;
>> +	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>> +		return -EINVAL;
>> +	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
>> +		return -EINVAL;
>> +
>> +	map_flags = delalloc ? EXT4_GET_BLOCKS_DELALLOC_RESERVE :
>> +			       EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
>> +retry:
>> +	ret = ext4_iomap_map_blocks(inode, offset, length, &map, map_flags);
> 
> [Severity: High]
> Does this code permanently leak unwritten extents past i_size if a short
> write or write failure occurs?
> 
> If the user memory copy subsequently fails (e.g. fault_in_iov_iter_readable()
> returns -EFAULT), it results in a short write.
> 
> In the non-delalloc path, ext4_iomap_buffered_write_ops lacks an iomap_end
> callback to clean up the allocated on-disk blocks, which could exhaust
> disk space or quota.

For short writes, leaving the preallocated blocks behind is not
really a problem. They are visible to users and can be reclaimed
manually, so it's not a permanent leak. I don't think we need to
fix this.

> 
>> +	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>> +		goto retry;
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>> +	return 0;
>> +}
> 
> [ ... ]
> 
>> +static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
>> +					    loff_t length, ssize_t written,
>> +					    unsigned int flags,
>> +					    struct iomap *iomap)
>> +{
>> +	loff_t start_byte, end_byte;
>> +
>> +	/* If we didn't reserve the blocks, we're not allowed to punch them. */
>> +	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
>> +		return 0;
> 
> [Severity: Critical]
> Will this silently lose data for extending writes within already-allocated
> blocks?
> 
> If a buffered write appends data to a file within an extent that was already
> allocated, iomap_write_iter() will update the in-memory i_size and set
> IOMAP_F_SIZE_CHANGED.
> 
> However, this early return skips checking IOMAP_F_SIZE_CHANGED.
> 
> Without updating EXT4_I(inode)->i_disksize and calling ext4_mark_inode_dirty()
> to persist the size change, appended data can be lost on a crash.

This is a false concern. i_disksize is updated during writeback,
not in the iomep_end callback.

Thanks,
Yi.

> 
>> +
>> +	/* Nothing to do if we've written the entire delalloc extent */
>> +	start_byte = iomap_last_written_block(inode, offset, written);
>> +	end_byte = round_up(offset + length, i_blocksize(inode));
>> +	if (start_byte >= end_byte)
>> +		return 0;
>> +
>> +	filemap_invalidate_lock(inode->i_mapping);
>> +	iomap_write_delalloc_release(inode, start_byte, end_byte, flags,
>> +				     iomap, ext4_iomap_punch_delalloc);
>> +	filemap_invalidate_unlock(inode->i_mapping);
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Since we always allocate unwritten extents, there is no need for
>> + * iomap_end to clean up allocated blocks on a short write.
>> + */
>> +static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_write_next,
>> +			      ext4_iomap_buffered_write_begin);
>> +
>> +const struct iomap_ops ext4_iomap_buffered_write_ops = {
>> +	.iomap_next = ext4_iomap_buffered_write_next,
>> +};
> 
> [Severity: High]
> Is it safe to omit an iomap_end callback here?
> 
> Without an iomap_end callback for the non-delalloc path, two issues appear
> to occur:
> 
> 1) Allocated unwritten extents past i_size are leaked if a write fails,
> exhausting disk space or quota.
> 
> 2) Extending writes into an already-allocated extent set IOMAP_F_SIZE_CHANGED
> in the core iomap code, but without an iomap_end callback to update i_disksize
> and mark the inode dirty, this size update is never persisted to disk.
> 
>> +
>> +static DEFINE_IOMAP_ITER_NEXT_END(ext4_iomap_buffered_da_write_next,
>> +				  ext4_iomap_buffered_da_write_begin,
>> +				  ext4_iomap_buffered_da_write_end);
> 

