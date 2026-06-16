Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CEB38D3F7
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 14:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781620981; cv=none; b=CWg58dOMoLYsP5ZkG5rXBuQ3Bo1vrFkFeWzEctK/AASSwEG5ZSvPiqCGTXRUwWVFDgz8Zh/HWXjAQLeJNkpQVLL/IX1kIocJkURDufRTfgKL4P8rba4a9rhlZyZZk+rldC8b0/jmE5j+xO5f3unzPlw/Mn/kcN3VAHrKKgj2/EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781620981; c=relaxed/simple;
	bh=UO2cf/vcRfd6f3/zPA63x7kOglgITkEcAb83yWx9GGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QLtOQvgViLv8FoxRw5J1oO/fKBps2+16XSOl8w6s6+VnIa2QDzI+77fLhDKgbSua6CnTUIvOHvoAUUX6XLCQ0MZ3X5iEipzyDe33U2bmMOXBGS1oTtphrd/Eaoz8KqVzrzy1FrLMxLTU/6atndroaq+O6Yx8SJVz6SSl8isbYps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=omMTVlJw; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="omMTVlJw"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c69921bd15so6680255ad.1
        for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 07:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781620980; x=1782225780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KjBawOyebB81mT4/Hcbtr1B4pfgxRoA78QHt88CUN9E=;
        b=omMTVlJwITvk4ut9eStzWH2zrtLFaLnxy7O1Im9c0wiypW4Tf0viJiOYJr2x+yTPZW
         8llyd3/lYR/weLDQnpikJ5zGgW7LFpj5KC/w2m57+RJdfomKJaPB9dvE34mu9/YpJDzN
         z+Wd1/RXoqvs//QWwndIv4uXWp880R85V1AOCrk39/NHj/qA97pAoonngHyjhd6uQ4x6
         1TT4t4nrxxhZcWtqRvr7Z8Z+mn3j46VpRfyNbYHhJ5IxACdImNL9K6DcjtmXq08fubYv
         Nb5+gRBrPU+4fHUd+VRnCes3dbdlScsD4dRxu0u4Ig6LmdSiWvdWqpLg7TQxG2jcAtTj
         4WMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781620980; x=1782225780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KjBawOyebB81mT4/Hcbtr1B4pfgxRoA78QHt88CUN9E=;
        b=SQtKrvLnFsB0O8/sQ4eZH2asWvbbZmJYo9A+IzSO0MZ7K5K1fYxkxmoZiYom3DBzrg
         W9GKyTZ7C3B40G7+4DBjP6UWUcehcqQDwV4dVQX7G6fj4U93/0R7QTVwyq8jwi0veDf2
         29A89OUcmTPlfdNYmA/AruHQTzUQILo+KIgmrhebfFmSc6Vc7Ahdm4+Wr+5D8+Mh6nDN
         VUxtmN2X6Synbfq1Yq1LKK0U9eISjTkAjTrmvoCRR/FrsoFxrPL6hH4hSaQbRcGICcKe
         HjgU75tSEvb4zKQitedeSR4UMyaQv1KMUaam2vXu9OgPaP+jN21cxz1NzpA5JTNC8G4K
         mRUA==
X-Gm-Message-State: AOJu0YxCum+5UOYZUEf/coZerK85nWI2b6krIqiU+uAYMUwNBYDoOX2w
	dnBH9ZxGQCn9rPA2KUtbMmo/JBoHJGBs7oM6aA1Sflt4oMBmMU/hl2w0
X-Gm-Gg: Acq92OHo0l+EHevw4dR9wPChJGVajgB3j2xb5JV8/IVt0CsZQQi019IgMqmQp+aiWyN
	psmLcWJ66Wjd48GgZM0d6cOjQGsaOQUxqAOV3jflyIYU6rrzHtwdha2lHccpdKPBr+nB7x6nQy3
	iYVFGikikodwJJ2v+q+xK0wF2z5j0uRRBqk0lnK5wTNNjIgw2UFwe8ANHOZ3+oSCnCZ8Lvn0Dt+
	mlEXgt0zLcVGexZx9TerN4bsM/u1vvhsYawPieBT+LHwLzNy6/SAPTcl8HfrI2lawloBg7IUCef
	l6cJ4NQlN9oLkCM105MFwgHgVn6IL1x9NG10TPYWxdbOl5nqJVWv1tdXWM6FfvP3I56y+ZqTjxt
	OELBBXMRtbmcdwt8uOz6o2XK2vp6exk3nRPUzp2W6lsJbyARk9e4qSA6Djed5wa1XX4OEXaUHPo
	B+OjGFLUm9Hnlf5feUDQ1kabLnrNE3U4Az6HT8EWq6j3tJJJBTG/92MxJOBcGZ4ATZa1Ig9IGvM
	A==
X-Received: by 2002:a17:903:2351:b0:2c0:c3ac:4af3 with SMTP id d9443c01a7336-2c66416ac4amr172199005ad.15.1781620979415;
        Tue, 16 Jun 2026 07:42:59 -0700 (PDT)
Received: from ?IPV6:240e:390:a92:e6d1:ed78:8bd4:5db9:c767? ([240e:390:a92:e6d1:ed78:8bd4:5db9:c767])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c432c8becesm141095445ad.56.2026.06.16.07.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 07:42:59 -0700 (PDT)
Message-ID: <6b0ddd3b-0b9e-4c18-aac7-2de278b26d10@gmail.com>
Date: Tue, 16 Jun 2026 22:42:51 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/23] ext4: implement buffered write path using iomap
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-9-yi.zhang@huaweicloud.com>
 <xuxrr3ls4gttesznypeplbawvnxwa4mqcbt7fkpdtdn3cfcfrv@paiigv322v3n>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <xuxrr3ls4gttesznypeplbawvnxwa4mqcbt7fkpdtdn3cfcfrv@paiigv322v3n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/2026 6:45 PM, Jan Kara wrote:
> On Mon 11-05-26 15:23:28, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Introduce two new iomap_ops instances for ext4 buffered writes:
>>
>>   - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
>>     ext4_da_map_blocks() to map delalloc extents.
>>   - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
>>     ext4_iomap_get_blocks() to directly allocate blocks.
>>
>> Also add ext4_iomap_valid() for the iomap infrastructure to check extent
>> validity.
>>
>> Key changes and considerations:
>>
>>   - Unwritten extents for new blocks (dioread_nolock always on)
>>     Since data=ordered mode is not used to prevent stale data exposure in
>>     the non-delayed allocation path, new blocks are always allocated as
>>     unwritten extents.
>>
>>   - Short write and write failure handling
>>     a. Delalloc path: On short write or failure, the stale delalloc range
>>        must be dropped and its space reservation released. Otherwise, a
>>        clean folio may cover leftover delalloc extents, causing
>>        inaccurate space reservation accounting.
>>     b. Non-delalloc path: No cleanup of allocated blocks is needed on
>>        short write.
>>
>>   - Lock ordering reversal
>>     The folio lock and transaction start ordering is reversed compared to
>>     the buffer_head buffered write path. To handle this, the journal
>>     handle must be stopped in iomap_begin() callbacks. The lock ordering
>>     documentation in super.c has been updated accordingly.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Looks good to me - besides the IOMAP_F_NEW bugs Ojaswin found. One
> observation I have here is that since the old indirect block based on-disk
> format doesn't support unwritten extents we can never transition it to the
> iomap scheme used here. So we'll have to figure out some way to avoid
> maintaining two (actually three if we count data=journal) buffered write /
> writeback paths in the long term. But let's address that once things settle
> for the common paths.
> 
> 								Honza

Yes, I agree. In the future, we need to convert the buffered I/O path
to iomap as much as possible to reduce maintenance costs. For the ext3
filesystem, which does not support unwritten extents, I haven't given
much thought to a conversion plan at the moment. Perhaps we could
implement it through the "delay map" we discussed earlier in v2. After
this patch set is finished, we can take a closer look at the solution.
:-)

Best Regards,
Yi.

> 
>> ---
>>   fs/ext4/ext4.h  |   4 ++
>>   fs/ext4/file.c  |  20 +++++-
>>   fs/ext4/inode.c | 165 +++++++++++++++++++++++++++++++++++++++++++++++-
>>   fs/ext4/super.c |  10 ++-
>>   4 files changed, 192 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 1e27d73d7427..4832e7f7db82 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -3057,6 +3057,7 @@ int ext4_walk_page_buffers(handle_t *handle,
>>   int do_journal_get_write_access(handle_t *handle, struct inode *inode,
>>   				struct buffer_head *bh);
>>   void ext4_set_inode_mapping_order(struct inode *inode);
>> +int ext4_nonda_switch(struct super_block *sb);
>>   #define FALL_BACK_TO_NONDELALLOC 1
>>   #define CONVERT_INLINE_DATA	 2
>>   
>> @@ -3926,6 +3927,9 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
>>   
>>   extern const struct iomap_ops ext4_iomap_ops;
>>   extern const struct iomap_ops ext4_iomap_report_ops;
>> +extern const struct iomap_ops ext4_iomap_buffered_write_ops;
>> +extern const struct iomap_ops ext4_iomap_buffered_da_write_ops;
>> +extern const struct iomap_write_ops ext4_iomap_write_ops;
>>   
>>   static inline int ext4_buffer_uptodate(struct buffer_head *bh)
>>   {
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index eb1a323962b1..7f9bfbbc4a4e 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
>> @@ -299,6 +299,21 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>>   	return count;
>>   }
>>   
>> +static ssize_t ext4_iomap_buffered_write(struct kiocb *iocb,
>> +					 struct iov_iter *from)
>> +{
>> +	struct inode *inode = file_inode(iocb->ki_filp);
>> +	const struct iomap_ops *iomap_ops;
>> +
>> +	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
>> +		iomap_ops = &ext4_iomap_buffered_da_write_ops;
>> +	else
>> +		iomap_ops = &ext4_iomap_buffered_write_ops;
>> +
>> +	return iomap_file_buffered_write(iocb, from, iomap_ops,
>> +					 &ext4_iomap_write_ops, NULL);
>> +}
>> +
>>   static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>>   					struct iov_iter *from)
>>   {
>> @@ -313,7 +328,10 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>>   	if (ret <= 0)
>>   		goto out;
>>   
>> -	ret = generic_perform_write(iocb, from);
>> +	if (ext4_inode_buffered_iomap(inode))
>> +		ret = ext4_iomap_buffered_write(iocb, from);
>> +	else
>> +		ret = generic_perform_write(iocb, from);
>>   
>>   out:
>>   	inode_unlock(inode);
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 39577a6b65b9..1ae7d3f4a1c8 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3097,7 +3097,7 @@ static int ext4_dax_writepages(struct address_space *mapping,
>>   	return ret;
>>   }
>>   
>> -static int ext4_nonda_switch(struct super_block *sb)
>> +int ext4_nonda_switch(struct super_block *sb)
>>   {
>>   	s64 free_clusters, dirty_clusters;
>>   	struct ext4_sb_info *sbi = EXT4_SB(sb);
>> @@ -3467,6 +3467,15 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
>>   	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
>>   }
>>   
>> +static bool ext4_iomap_valid(struct inode *inode, const struct iomap *iomap)
>> +{
>> +	return iomap->validity_cookie == READ_ONCE(EXT4_I(inode)->i_es_seq);
>> +}
>> +
>> +const struct iomap_write_ops ext4_iomap_write_ops = {
>> +	.iomap_valid = ext4_iomap_valid,
>> +};
>> +
>>   static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>>   			   struct ext4_map_blocks *map, loff_t offset,
>>   			   loff_t length, unsigned int flags)
>> @@ -3501,6 +3510,8 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>>   	    !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>>   		iomap->flags |= IOMAP_F_MERGED;
>>   
>> +	iomap->validity_cookie = map->m_seq;
>> +
>>   	/*
>>   	 * Flags passed to ext4_map_blocks() for direct I/O writes can result
>>   	 * in m_flags having both EXT4_MAP_MAPPED and EXT4_MAP_UNWRITTEN bits
>> @@ -3908,8 +3919,12 @@ const struct iomap_ops ext4_iomap_report_ops = {
>>   	.iomap_begin = ext4_iomap_begin_report,
>>   };
>>   
>> +/* Map blocks */
>> +typedef int (ext4_get_blocks_t)(struct inode *, struct ext4_map_blocks *);
>> +
>>   static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
>> -		loff_t length, struct ext4_map_blocks *map)
>> +		loff_t length, ext4_get_blocks_t get_blocks,
>> +		struct ext4_map_blocks *map)
>>   {
>>   	u8 blkbits = inode->i_blkbits;
>>   
>> @@ -3921,6 +3936,9 @@ static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
>>   	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
>>   			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
>>   
>> +	if (get_blocks)
>> +		return get_blocks(inode, map);
>> +
>>   	return ext4_map_blocks(NULL, inode, map, 0);
>>   }
>>   
>> @@ -3938,7 +3956,7 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
>>   	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
>>   		return -ERANGE;
>>   
>> -	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
>> +	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
>>   	if (ret < 0)
>>   		return ret;
>>   
>> @@ -3946,6 +3964,147 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
>>   	return 0;
>>   }
>>   
>> +static int ext4_iomap_get_blocks(struct inode *inode,
>> +				 struct ext4_map_blocks *map)
>> +{
>> +	loff_t i_size = i_size_read(inode);
>> +	handle_t *handle;
>> +	int ret;
>> +
>> +	/*
>> +	 * Check if the blocks have already been allocated, this could
>> +	 * avoid initiating a new journal transaction and return the
>> +	 * mapping information directly.
>> +	 */
>> +	if ((map->m_lblk + map->m_len) <=
>> +	    round_up(i_size, i_blocksize(inode)) >> inode->i_blkbits) {
>> +		ret = ext4_map_blocks(NULL, inode, map, 0);
>> +		if (ret < 0)
>> +			return ret;
>> +		if (map->m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN |
>> +				    EXT4_MAP_DELAYED))
>> +			return 0;
>> +	}
>> +
>> +	handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
>> +			ext4_chunk_trans_blocks(inode, map->m_len));
>> +	if (IS_ERR(handle))
>> +		return PTR_ERR(handle);
>> +
>> +	ret = ext4_map_blocks(handle, inode, map,
>> +			      EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
>> +	/*
>> +	 * Stop handle here following the lock ordering of the folio lock
>> +	 * and the transaction start.
>> +	 */
>> +	ext4_journal_stop(handle);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
>> +		loff_t offset, loff_t length, unsigned int flags,
>> +		struct iomap *iomap, struct iomap *srcmap, bool delalloc)
>> +{
>> +	int ret, retries = 0;
>> +	struct ext4_map_blocks map;
>> +	ext4_get_blocks_t *get_blocks;
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
>> +	if (delalloc)
>> +		get_blocks = ext4_da_map_blocks;
>> +	else
>> +		get_blocks = ext4_iomap_get_blocks;
>> +retry:
>> +	ret = ext4_iomap_map_blocks(inode, offset, length, get_blocks, &map);
>> +	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>> +		goto retry;
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>> +	return 0;
>> +}
>> +
>> +static int ext4_iomap_buffered_write_begin(struct inode *inode,
>> +		loff_t offset, loff_t length, unsigned int flags,
>> +		struct iomap *iomap, struct iomap *srcmap)
>> +{
>> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
>> +						  iomap, srcmap, false);
>> +}
>> +
>> +static int ext4_iomap_buffered_da_write_begin(struct inode *inode,
>> +		loff_t offset, loff_t length, unsigned int flags,
>> +		struct iomap *iomap, struct iomap *srcmap)
>> +{
>> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
>> +						  iomap, srcmap, true);
>> +}
>> +
>> +/*
>> + * On write failure, drop the stale delayed allocation range and release
>> + * its reserved space for both start and end blocks. Otherwise, we may
>> + * leave a range of delayed extents covered by a clean folio, which can
>> + * result in inaccurate space reservation accounting.
>> + */
>> +static void ext4_iomap_punch_delalloc(struct inode *inode, loff_t offset,
>> +				     loff_t length, struct iomap *iomap)
>> +{
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>> +	ext4_es_remove_extent(inode, offset >> inode->i_blkbits,
>> +			DIV_ROUND_UP_ULL(length, EXT4_BLOCK_SIZE(inode->i_sb)));
>> +	up_write(&EXT4_I(inode)->i_data_sem);
>> +}
>> +
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
>> +const struct iomap_ops ext4_iomap_buffered_write_ops = {
>> +	.iomap_begin = ext4_iomap_buffered_write_begin,
>> +};
>> +
>> +const struct iomap_ops ext4_iomap_buffered_da_write_ops = {
>> +	.iomap_begin = ext4_iomap_buffered_da_write_begin,
>> +	.iomap_end = ext4_iomap_buffered_da_write_end,
>> +};
>> +
>>   const struct iomap_ops ext4_iomap_buffered_read_ops = {
>>   	.iomap_begin = ext4_iomap_buffered_read_begin,
>>   };
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 6a77db4d3124..9bc294b769db 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -104,9 +104,13 @@ static const struct fs_parameter_spec ext4_param_specs[];
>>    *   -> page lock -> i_data_sem (rw)
>>    *
>>    * buffered write path:
>> - * sb_start_write -> i_mutex -> mmap_lock
>> - * sb_start_write -> i_mutex -> transaction start -> page lock ->
>> - *   i_data_sem (rw)
>> + * sb_start_write -> i_rwsem (w) -> mmap_lock
>> + * - buffer_head path:
>> + *   sb_start_write -> i_rwsem (w) -> transaction start -> folio lock ->
>> + *     i_data_sem (rw)
>> + * - iomap path:
>> + *   sb_start_write -> i_rwsem (w) -> transaction start -> i_data_sem (rw)
>> + *   sb_start_write -> i_rwsem (w) -> folio lock (not under an active handle)
>>    *
>>    * truncate:
>>    * sb_start_write -> i_mutex -> invalidate_lock (w) -> i_mmap_rwsem (w) ->
>> -- 
>> 2.52.0
>>

