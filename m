Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5A720F08C;
	Tue, 24 Mar 2026 03:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774321823; cv=none; b=MLyPxmbT17uK5laXJertXpK9gb4AlV3t6HUVL449BGubErSKl9YoDh/VcTr2fH7+RlJTHesYNgr6V94OvWDIxc4KYklQ61F8QGmU0mBQhUV7pjqIQXI9o60Zz7MKzP8S0NjLpP9e/E3MJBG4Z6GMUUPtQ80PnKs/4wAPFXBBOP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774321823; c=relaxed/simple;
	bh=XPd31gqAVamZHVCsQ3YIXFmnixAN2lyqsYPUyeeBfQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oj0n3i+2l9nUOQjwJRLZ5SLvcFYl0haNLVeA25jT3rNlcn/WzYhuCORHOfxOyO4MFPf9/hno6sB0BvY+i7hLvGNABaXsp+DtE+ur4a2d0jdYpxI1Ju7fMX9vlsMSQ2nCH1xM8a4rnqxRZxnJ84RDUoeS1H42UaM6L6od0ifvuaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ffw5F5LvJzYQtmL;
	Tue, 24 Mar 2026 11:10:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B3C8940562;
	Tue, 24 Mar 2026 11:10:17 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgC3BteVAMJpBjcNCA--.56131S3;
	Tue, 24 Mar 2026 11:10:15 +0800 (CST)
Message-ID: <7fa8415e-199f-4e31-8b07-08f0f73d5b99@huaweicloud.com>
Date: Tue, 24 Mar 2026 11:10:13 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] ext4: move zero partial block range functions out
 of active handle
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-10-yi.zhang@huaweicloud.com>
 <irkaodowvqmpug3moetmd75vssj6czh67qzuxs4v5vxe56qxz7@opkvl3apdpuk>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <irkaodowvqmpug3moetmd75vssj6czh67qzuxs4v5vxe56qxz7@opkvl3apdpuk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgC3BteVAMJpBjcNCA--.56131S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtrWftrW3CFWUKr1xGF13twb_yoW7Zw13pF
	Z8KFyUKF4kWa4v9r4IgF4DZF40k3Z7KF4UGry7Gr1UZa98Zw1IkF47K3W09a4jyrW7C340
	vF1Ykr9ru3WDAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

On 3/24/2026 4:17 AM, Jan Kara wrote:
> On Tue 10-03-26 09:41:00, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Move ext4_block_zero_eof() and ext4_zero_partial_blocks() calls out of
>> the active handle context, making them independent operations. This is
>> safe because it still ensures data is updated before metadata for
>> data=ordered mode and data=journal mode because we still zero data and
>> ordering data before modifying the metadata.
>>
>> This change is required for iomap infrastructure conversion because the
>> iomap buffered I/O path does not use the same journal infrastructure for
>> partial block zeroing. The lock ordering of folio lock and starting
>> transactions is "folio lock -> transaction start", which is opposite of
>> the current path. Therefore, zeroing partial blocks cannot be performed
>> under the active handle.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> So in this patch you also move ext4_zero_partial_blocks() before the
> transaction start in ext4_zero_range() and ext4_punch_hole(). However
> cannot these operations in theory fail with error such as EDQUOT or ENOSPC
> when they need to grow the extent tree as a result of the operation? In
> that case we'd return such error but partial blocks are already zeroed out
> which is a problem... 

Thank you for review this patch set!

Let me see, I believe you are referring to the cases where
ext4_xxx_remove_space() in ext4_punch_hole() and
ext4_alloc_file_blocks() in ext4_zero_range() return normal error codes
such as EDQUOT or ENOSPC.

In ext4_punch_hole(), we first zero out the partial blocks at the
beginning and end of the punch range, and then release the aligned
blocks in the middle. If errors occur during the middle of the
hole-punching operation, there will left some data in the middle of the
punch range, this is weird. Conversely, if the zeroization is performed
in sequence, the result is zeroization at the front and the retention of
valid data at the rear, which is acceptable. right? Besides, this
problem seems not occur in ext4_zero_range() because
ext4_zero_partial_blocks() is still called after
ext4_alloc_file_blocks() after this patch.

Regarding this, I found that the result is the same whether
ext4_alloc_file_blocks() is called inside transaction start or not. The
partial blocks at the head and tail have already been zeroed out after
calling ext4_zero_partial_blocks(), am I missing some thing? Or do you
suggest that we should also move ext4_zero_partial_blocks() to execute
after ext4_xxx_remove_space() in ext4_punch_hole()?

> OTOH in these cases we don't need to order the data
> at all so in principle we shouldn't need to move the zeroing earlier
> here. Am I missing something?
> 

Moving the zero partial block before the start handle is not only
because they do not need to order the data, but rather to avoid
deadlock. iomap_zero_range() acquires the folio lock, and if it is
called after ext4_journal_start(), the locking order would be
transaction start -> folio lock, which is the opposite of the locking
order used in the writeback process. If these two operations are
performed concurrently (), it could potentially result in an ABBA
deadlock.

In the subsequent iomap patch [1], I will add a WARNING and a comment
in ext4_iomap_block_zero_range(I don't see anything can prevent this)
to ensure it is not called under an active handle.

[1] https://lore.kernel.org/linux-ext4/20260203062523.3869120-18-yi.zhang@huawei.com/

Thanks,
Yi.

> 								Honza
> 
>> @@ -4722,25 +4724,18 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>>  	if (IS_ALIGNED(offset | end, blocksize))
>>  		return ret;
>>  
>> -	/*
>> -	 * In worst case we have to writeout two nonadjacent unwritten
>> -	 * blocks and update the inode
>> -	 */
>> -	credits = (2 * ext4_ext_index_trans_blocks(inode, 2)) + 1;
>> -	if (ext4_should_journal_data(inode))
>> -		credits += 2;
>> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
>> +	/* Zero out partial block at the edges of the range */
>> +	ret = ext4_zero_partial_blocks(inode, offset, len);
>> +	if (ret)
>> +		return ret;
>> +
>> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>>  	if (IS_ERR(handle)) {
>>  		ret = PTR_ERR(handle);
>>  		ext4_std_error(inode->i_sb, ret);
>>  		return ret;
>>  	}
>>  
>> -	/* Zero out partial block at the edges of the range */
>> -	ret = ext4_zero_partial_blocks(inode, offset, len);
>> -	if (ret)
>> -		goto out_handle;
>> -
>>  	if (new_size)
>>  		ext4_update_inode_size(inode, new_size);
>>  	ret = ext4_mark_inode_dirty(handle, inode);
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index d5b783a7c814..5288d36b0f09 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4443,8 +4443,12 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>>  	if (ret)
>>  		return ret;
>>  
>> +	ret = ext4_zero_partial_blocks(inode, offset, length);
>> +	if (ret)
>> +		return ret;
>> +
>>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>> -		credits = ext4_chunk_trans_extent(inode, 2);
>> +		credits = ext4_chunk_trans_extent(inode, 0);
>>  	else
>>  		credits = ext4_blocks_for_truncate(inode);
>>  	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
>> @@ -4454,10 +4458,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>>  		return ret;
>>  	}
>>  
>> -	ret = ext4_zero_partial_blocks(inode, offset, length);
>> -	if (ret)
>> -		goto out_handle;
>> -
>>  	/* If there are blocks to remove, do it */
>>  	start_lblk = EXT4_B_TO_LBLK(inode, offset);
>>  	end_lblk = end >> inode->i_blkbits;

