Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3810E38398F;
	Wed, 17 Jun 2026 08:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781684100; cv=none; b=JM3FpMzvpLsxk0brXO6vbrh6/XuicLaYZpgkha2B3EPz1Wiwoeh+Ms0BHfcHDbZBaNJBw+iwpye7iOkGUbHCREb0/0zUrLcChGRlUJaQ6h/5yZJNuOaiypcmGNtFaYQFQfwkyyaVNvRhyjN6oTLjHe2qZu6BBF3R5DTvuSIA4LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781684100; c=relaxed/simple;
	bh=gHLr0yUQWXCjc6ij5t2yGMlyJqcpS5UENXMyyRYlIQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cH7LNl3BFXiWbdAEvtrnu19pbtaRb8IPWwKoM+QG+/uSoXvZ4L42DcbZZrUQM+FGDCBQMHtIJJfoDS8bSf6qN4hdtSyPNHvHF41bMVU/Sb8lwi0nKzyZxbR0e6nRDpd5EpDcf/NfaWKtjkUSyV9v0Pf4CmZE/S/3KF4NPrmeCY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ggGpt5dYvzYQttf;
	Wed, 17 Jun 2026 16:14:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 0291E406D0;
	Wed, 17 Jun 2026 16:14:45 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgAHCj9wVzJqaCFnCA--.15010S3;
	Wed, 17 Jun 2026 16:14:42 +0800 (CST)
Message-ID: <16cccb83-cdad-4113-8182-e8ea9e3049a2@huaweicloud.com>
Date: Wed, 17 Jun 2026 16:14:40 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/23] ext4: implement partial block zero range path
 using iomap
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com,
 Brian Foster <bfoster@redhat.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-15-yi.zhang@huaweicloud.com>
 <c2q54d6u724xctkzwm6x7sbmg5cpvcackfz3toc47qts6iaj77@ci2czn4fqjik>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <c2q54d6u724xctkzwm6x7sbmg5cpvcackfz3toc47qts6iaj77@ci2czn4fqjik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAHCj9wVzJqaCFnCA--.15010S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GFWDZFykuw4fJw18tFWrKrg_yoWxJFWUpF
	WkKF15Kr4kXryxuw4fJrZ2qr1Yy3s3tr47WryfGr1Yv3s09FyxKFW7KayF9F1UJw4xGr12
	vF4jvry7GF1DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	aFAJUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/16/2026 8:28 PM, Jan Kara wrote:
> On Mon 11-05-26 15:23:34, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
>> ext4_iomap_block_zero_range() to implement block zeroing via the iomap
>> infrastructure for ext4.
>>
>> ext4_iomap_block_zero_range() calls iomap_zero_range() with
>> ext4_iomap_zero_begin() as the callback. The callback locates and zeros
>> out either a mapped partial block or a dirty, unwritten partial block.
>>
>> Important constraints:
>>
>> Zeroing out under an active journal handle can cause deadlock, because
>> the order of acquiring the folio lock and starting a handle is
>> inconsistent with the iomap writeback path.
>>
>> Therefore, ext4_iomap_block_zero_range():
>> - Must NOT be called under an active handle.
>> - Cannot rely on data=ordered mode to ensure zeroed data persistence
>>   before updating i_disksize (for the cases of post-EOF append write,
>>   post-EOF fallocate, and truncate up). In subsequent patches, we will
>>   address this by synchronizing commit I/O but doesn't waiting for
>>   completion, and updating i_disksize to i_size only after the zeroed
>>   data has been written back.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  fs/ext4/inode.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 92 insertions(+)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index c6fe42d012fc..e0dae2501292 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4101,6 +4101,51 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
>>  	return 0;
>>  }
>>  
>> +static int ext4_iomap_zero_begin(struct inode *inode,
>> +		loff_t offset, loff_t length, unsigned int flags,
>> +		struct iomap *iomap, struct iomap *srcmap)
>> +{
>> +	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
> 
> This looks like a layering violation to me. I don't think you can safely
> assume the iomap you're passed is a part of iomap_iter...
> 
>> +	struct ext4_map_blocks map;
>> +	u8 blkbits = inode->i_blkbits;
>> +	unsigned int iomap_flags = 0;
>> +	int ret;
>> +
>> +	ret = ext4_emergency_state(inode->i_sb);
>> +	if (unlikely(ret))
>> +		return ret;
>> +
>> +	if (WARN_ON_ONCE(!(flags & IOMAP_ZERO)))
>> +		return -EINVAL;
>> +
>> +	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/*
>> +	 * Look up dirty folios for unwritten mappings within EOF. Providing
>> +	 * this bypasses the flush iomap uses to trigger extent conversion
>> +	 * when unwritten mappings have dirty pagecache in need of zeroing.
>> +	 */
>> +	if (map.m_flags & EXT4_MAP_UNWRITTEN) {
>> +		loff_t start = ((loff_t)map.m_lblk) << blkbits;
>> +		loff_t end = ((loff_t)map.m_lblk + map.m_len) << blkbits;
>> +
>> +		iomap_fill_dirty_folios(iter, &start, end, &iomap_flags);
>> +		if ((start >> blkbits) < map.m_lblk + map.m_len)
>> +			map.m_len = (start >> blkbits) - map.m_lblk;
>> +	}
> 
> ... and you need access to iter only for this which seems to be really a
> hack that's trying to outsmart the iomap code. I have to admit I don't
> fully understand what you are trying to achieve here. Are you trying to
> avoid flushing of the range that will be zeroed out?

This logic is copied from the XFS and iomap infrastructure. Its primary
purpose is to optimize the zeroing operations on dirty written extents.
It was introduced by Brian in [1].

The history as I understand it: originally, the iomap infrastructure
could not zero dirty unwritten extents during zero range processing,
which led to stale data exposure. XFS had to flush dirty ranges itself
before zeroing — a workaround that was not generic.

In c5c810b94cf ("iomap: fix handling of dirty folios over unwritten
extents"), Brian added an unconditional flush in the iomap
infrastructure, ensuring that by the time zeroing runs the extent has
already been converted to written so the zero can proceed correctly.
However, this flush was too heavy and introduced noticeable performance
overhead.

This was then optimized in 7d9b474ee4cc3 ("iomap: make zero range flush
conditional on unwritten mappings"), which restricts flushing to only
dirty pagecache over unwritten or hole mappings.

Brian later proposed a different approach: rather than relying on flush
to convert the extent type, find dirty folios ahead of the zero range
and zero the dirty unwritten extents directly. In [1] he added this
lookup logic. The filesystem now supplies a folio batch (a collection of
dirty folios) via the iomap begin callback, and zero range iterates over
these dirty folios to perform zeroing. Clean regions not covered by the
batch are simply skipped. This entirely eliminates the need to flush.

[1] https://lore.kernel.org/linux-xfs/20251003134642.604736-1-bfoster@redhat.com/

If I understand correctly, the current approach is a compromise, and
Brian is still working on this. Perhaps ext4 and XFS could work together
on improvements in the future?

> 
>> +	ret = iomap_zero_range(inode, from, length, did_zero,
>> +			       &ext4_iomap_zero_ops, &ext4_iomap_write_ops,
>> +			       NULL);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/*
>> +	 * TODO: The iomap does not distinguish between different types of
>> +	 * zeroing and always sets zero_written if a zeroing operation is
>> +	 * performed, which may result in unnecessary order operations.
>> +	 */
> 
> Is this still true after your fix to did_zero handling?

Yeah. Currently, iomap_zero_range() can only report whether a zeroing
operation has occurred through did_zero parameter, but it cannot
distinguish whether the zeroed range is a written extent that already
exists on disk. That is, even if the zeroing is performed on a delalloc
extent, did_zero will still return true.

Thanks,
Yi.

> 
>> +	if (did_zero && zero_written)
>> +		*zero_written = *did_zero;
>> +
>> +	return 0;
>> +}
>> +
>>  /*
>>   * Zeros out a mapping of length 'length' starting from file offset
>>   * 'from'.  The range to be zero'd must be contained with in one block.
> 
> 								Honza

