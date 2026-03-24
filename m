Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636D837C90C;
	Tue, 24 Mar 2026 03:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774322062; cv=none; b=DmIR+LjxPyUK7Ch9e7nK370jAGeAl+B/2UosnE5pK0eGwiJFRDW7K/WtFEAWeRY4HmVO03Zl9sDnTxcXhlSK0aUqdvtdkPsKqnAbC4ZaLkkDNabggtQbvCKzSi1mpw/oZXwe/nAf31iOlQt8Y1zkIpDHx30w7vyjpMZXxyveNT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774322062; c=relaxed/simple;
	bh=BL3Bgw/KfS4KMLB5H2TdqDUzEJ63C+Jab+n32tGpQD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ik5p+7E+gKuEoby9ckd41+L1K9Y6U0H70fWuoXF31uHaoZVHaYvcTKEqZYypnpNdrus7wf7TxWxcL4ojPXdCZY/vjxc9CYwStMN4YVToIzZBXIsZXEJP17eui48GOkcpwGj4m4LRt/R9OWXpfHiXUt4fyeBnSse3LPC7MgBjjeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ffw9B3DCXzKHMf4;
	Tue, 24 Mar 2026 11:13:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id E9F344056F;
	Tue, 24 Mar 2026 11:14:10 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgB3edmBAcJpeIsNCA--.22888S3;
	Tue, 24 Mar 2026 11:14:10 +0800 (CST)
Message-ID: <5b9ad701-4dea-4e6a-89c2-5fcb9075205c@huaweicloud.com>
Date: Tue, 24 Mar 2026 11:14:09 +0800
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
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com,
 Zhang Yi <yi.zhang@huaweicloud.com>, Zhang Yi <yi.zhang@huawei.com>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-10-yi.zhang@huaweicloud.com>
 <irkaodowvqmpug3moetmd75vssj6czh67qzuxs4v5vxe56qxz7@opkvl3apdpuk>
 <7fa8415e-199f-4e31-8b07-08f0f73d5b99@huaweicloud.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <7fa8415e-199f-4e31-8b07-08f0f73d5b99@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgB3edmBAcJpeIsNCA--.22888S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuFW3XFykZw1fXw48ArWUArb_yoW7KF18pr
	WDGF1DKF4kWa4v9r4Igan8ZFW0k3Z7tF4UGr9rGryDAas0vw1IkFW7Ka1j9a4jyr47Gr40
	vF1jkry7W3Z8A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUFg4SDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 3/24/2026 11:10 AM, Zhang Yi wrote:
> On 3/24/2026 4:17 AM, Jan Kara wrote:
>> On Tue 10-03-26 09:41:00, Zhang Yi wrote:
>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> Move ext4_block_zero_eof() and ext4_zero_partial_blocks() calls out of
>>> the active handle context, making them independent operations. This is
>>> safe because it still ensures data is updated before metadata for
>>> data=ordered mode and data=journal mode because we still zero data and
>>> ordering data before modifying the metadata.
>>>
>>> This change is required for iomap infrastructure conversion because the
>>> iomap buffered I/O path does not use the same journal infrastructure for
>>> partial block zeroing. The lock ordering of folio lock and starting
>>> transactions is "folio lock -> transaction start", which is opposite of
>>> the current path. Therefore, zeroing partial blocks cannot be performed
>>> under the active handle.
>>>
>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>
>> So in this patch you also move ext4_zero_partial_blocks() before the
>> transaction start in ext4_zero_range() and ext4_punch_hole(). However
>> cannot these operations in theory fail with error such as EDQUOT or ENOSPC
>> when they need to grow the extent tree as a result of the operation? In
>> that case we'd return such error but partial blocks are already zeroed out
>> which is a problem... 
> 
> Thank you for review this patch set!
> 
> Let me see, I believe you are referring to the cases where
> ext4_xxx_remove_space() in ext4_punch_hole() and
> ext4_alloc_file_blocks() in ext4_zero_range() return normal error codes
> such as EDQUOT or ENOSPC.
> 
> In ext4_punch_hole(), we first zero out the partial blocks at the
> beginning and end of the punch range, and then release the aligned
> blocks in the middle. If errors occur during the middle of the
> hole-punching operation, there will left some data in the middle of the
> punch range, this is weird. Conversely, if the zeroization is performed
> in sequence, the result is zeroization at the front and the retention of
> valid data at the rear, which is acceptable. right? Besides, this
> problem seems not occur in ext4_zero_range() because
> ext4_zero_partial_blocks() is still called after
> ext4_alloc_file_blocks() after this patch.
> 
> Regarding this, I found that the result is the same whether
> ext4_alloc_file_blocks() is called inside transaction start or not. The
> partial blocks at the head and tail have already been zeroed out after
> calling ext4_zero_partial_blocks(), am I missing some thing? Or do you
> suggest that we should also move ext4_zero_partial_blocks() to execute
> after ext4_xxx_remove_space() in ext4_punch_hole()?
> 
>> OTOH in these cases we don't need to order the data
>> at all so in principle we shouldn't need to move the zeroing earlier
>> here. Am I missing something?
>>
> 
> Moving the zero partial block before the start handle is not only
> because they do not need to order the data, but rather to avoid
> deadlock. iomap_zero_range() acquires the folio lock, and if it is
> called after ext4_journal_start(), the locking order would be
> transaction start -> folio lock, which is the opposite of the locking
> order used in the writeback process. If these two operations are
> performed concurrently (), it could potentially result in an ABBA
                         ^^ A
> deadlock.
> 
> In the subsequent iomap patch [1], I will add a WARNING and a comment
> in ext4_iomap_block_zero_range(I don't see anything can prevent this)
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Sorry, this sentence should be placed at position A.

> to ensure it is not called under an active handle.
> 
> [1] https://lore.kernel.org/linux-ext4/20260203062523.3869120-18-yi.zhang@huawei.com/
> 
> Thanks,
> Yi.
> 
>> 								Honza
>>
>>> @@ -4722,25 +4724,18 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>>>  	if (IS_ALIGNED(offset | end, blocksize))
>>>  		return ret;
>>>  
>>> -	/*
>>> -	 * In worst case we have to writeout two nonadjacent unwritten
>>> -	 * blocks and update the inode
>>> -	 */
>>> -	credits = (2 * ext4_ext_index_trans_blocks(inode, 2)) + 1;
>>> -	if (ext4_should_journal_data(inode))
>>> -		credits += 2;
>>> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
>>> +	/* Zero out partial block at the edges of the range */
>>> +	ret = ext4_zero_partial_blocks(inode, offset, len);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>>>  	if (IS_ERR(handle)) {
>>>  		ret = PTR_ERR(handle);
>>>  		ext4_std_error(inode->i_sb, ret);
>>>  		return ret;
>>>  	}
>>>  
>>> -	/* Zero out partial block at the edges of the range */
>>> -	ret = ext4_zero_partial_blocks(inode, offset, len);
>>> -	if (ret)
>>> -		goto out_handle;
>>> -
>>>  	if (new_size)
>>>  		ext4_update_inode_size(inode, new_size);
>>>  	ret = ext4_mark_inode_dirty(handle, inode);
>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>> index d5b783a7c814..5288d36b0f09 100644
>>> --- a/fs/ext4/inode.c
>>> +++ b/fs/ext4/inode.c
>>> @@ -4443,8 +4443,12 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>>>  	if (ret)
>>>  		return ret;
>>>  
>>> +	ret = ext4_zero_partial_blocks(inode, offset, length);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>>> -		credits = ext4_chunk_trans_extent(inode, 2);
>>> +		credits = ext4_chunk_trans_extent(inode, 0);
>>>  	else
>>>  		credits = ext4_blocks_for_truncate(inode);
>>>  	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
>>> @@ -4454,10 +4458,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>>>  		return ret;
>>>  	}
>>>  
>>> -	ret = ext4_zero_partial_blocks(inode, offset, length);
>>> -	if (ret)
>>> -		goto out_handle;
>>> -
>>>  	/* If there are blocks to remove, do it */
>>>  	start_lblk = EXT4_B_TO_LBLK(inode, offset);
>>>  	end_lblk = end >> inode->i_blkbits;
> 

