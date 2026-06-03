Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38B13D6498;
	Wed,  3 Jun 2026 02:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780455414; cv=none; b=m74n47arNk9B4mKCFOmKmAbyUAEMq9sKcO0CQaVMIgYMVbpw/o0MByWzZRXxo+cpKIvkz7RfqUjYftwya4opaMYkPjg2jFMxfFwchmiPyW1X6P+VABae7VS4frx+ygpaJP8O5AeBP2iZ9BpAuK0nmaJXDoWqRerS84E2es945RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780455414; c=relaxed/simple;
	bh=rqIfMkcFPy246Mn8oo49a63nTbeGAY01w0xtEL0vPx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mLl/Fz/O+bqIAOIdc+xb69UfwH0JQBS68wK5XGSZtex/4JmV63Od2ofVQjwDgNFBhRCrqWeuGz1w44ct/hPAQMe5q0eQGCXyro5k1sD8/FIrEfJc20CdjBu96JfWCjzURURjz6VeMlSQxjvk0uzgSrmBJuifeWM0xB1NYWOGSgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gVXQp5XkJzYQtjV;
	Wed,  3 Jun 2026 10:56:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id AB5614058D;
	Wed,  3 Jun 2026 10:56:40 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgAnKT7klx9qDcq3AQ--.12916S3;
	Wed, 03 Jun 2026 10:56:40 +0800 (CST)
Message-ID: <cc05c17d-163e-4251-b2c9-aa3a6f9555d7@huaweicloud.com>
Date: Wed, 3 Jun 2026 10:56:34 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/23] ext4: implement buffered write path using iomap
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-9-yi.zhang@huaweicloud.com>
 <ah6vwa_MytxBN-Z8@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ah6vwa_MytxBN-Z8@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAnKT7klx9qDcq3AQ--.12916S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4rZrWkKF1DZr1fCr1rWFg_yoW7Gryxpr
	ykKF15ta13Xrn7WFZaga17XF1Fk3Z7Kr47CrW3Wr98XF90yrnagFy0ga4a9Fy5XrZ7CF10
	vFWjvryxWr4UCFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/2/2026 6:26 PM, Ojaswin Mujoo wrote:
> On Mon, May 11, 2026 at 03:23:28PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Introduce two new iomap_ops instances for ext4 buffered writes:
>>
>>  - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
>>    ext4_da_map_blocks() to map delalloc extents.
>>  - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
>>    ext4_iomap_get_blocks() to directly allocate blocks.
>>
>> Also add ext4_iomap_valid() for the iomap infrastructure to check extent
>> validity.
>>
>> Key changes and considerations:
>>
>>  - Unwritten extents for new blocks (dioread_nolock always on)
>>    Since data=ordered mode is not used to prevent stale data exposure in
>>    the non-delayed allocation path, new blocks are always allocated as
>>    unwritten extents.
>>
>>  - Short write and write failure handling
>>    a. Delalloc path: On short write or failure, the stale delalloc range
>>       must be dropped and its space reservation released. Otherwise, a
>>       clean folio may cover leftover delalloc extents, causing
>>       inaccurate space reservation accounting.
>>    b. Non-delalloc path: No cleanup of allocated blocks is needed on
>>       short write.
>>
>>  - Lock ordering reversal
>>    The folio lock and transaction start ordering is reversed compared to
>>    the buffer_head buffered write path. To handle this, the journal
>>    handle must be stopped in iomap_begin() callbacks. The lock ordering
>>    documentation in super.c has been updated accordingly.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> I went through this again and after our discussion the changes looks
> okay. Just a small quesiton below but otherwise feel free to add:
> 
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Thank you a lot for your careful review!

> 
>> ---
>>  fs/ext4/ext4.h  |   4 ++
>>  fs/ext4/file.c  |  20 +++++-
>>  fs/ext4/inode.c | 165 +++++++++++++++++++++++++++++++++++++++++++++++-
>>  fs/ext4/super.c |  10 ++-
>>  4 files changed, 192 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 1e27d73d7427..4832e7f7db82 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -3057,6 +3057,7 @@ int ext4_walk_page_buffers(handle_t *handle,
>>  int do_journal_get_write_access(handle_t *handle, struct inode *inode,
>>  				struct buffer_head *bh);
>>  void ext4_set_inode_mapping_order(struct inode *inode);
>> +int ext4_nonda_switch(struct super_block *sb);
>>  #define FALL_BACK_TO_NONDELALLOC 1
>>  #define CONVERT_INLINE_DATA	 2
> 
> <snip>
> 
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
> 
> Will we ever get IOMAP_F_NEW here? I think the da_write_begin() call
> either creates a new IOMAP_DELALLOC extent or finds older ones which
> won't have EXT4_MAP_NEW set
> 

Oops. This is a bug！ In ext4_da_map_blocks(), when allocating a new
delalloc extent, the EXT4_MAP_NEW flag should be set. If this flag is
not set, then when a short write occurs, we cannot distinguish whether
an extent is a pre-existing delalloc extent or a newly allocated one.
This prevents the subsequent truncate operation from being executed,
leaving the newly allocated delalloc extent behind. I will fix this in
next iteration.

Thanks,
Yi.

