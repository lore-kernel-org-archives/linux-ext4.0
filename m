Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C3114F9FB;
	Tue, 24 Mar 2026 03:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774323259; cv=none; b=mqwTiANGaIELzmyxhg7V9TvPqRBfOWm+vza2l+mlcExFX8i/pWbqHd2BmIyhO7QvJXUbXf1ZbgoLv/CSpQEkErqm1jJ2qqhXOrRu36hcGK39Zdx1zkA10gJlKo0acaqFKBIP3e6qDXOF1vEgVEtBkr3airIoxnZxZrOQehXJ8Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774323259; c=relaxed/simple;
	bh=G+tLhU17itLhOwKAuxt2hN3EcYX3tp9MDPI7gc42IMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DFKW1J92g0usMg8wtRV7foIzqewtbICNTmrgP374tZwYZVFEe4Y7tFQF3Apol3MdKuGPdi38q/xlDCw9gdVKtgzQxgA/II7+Ovuo13CPx5ml7yEdu366vsxHnfHISiA+qN6Xc4faRdD6M1FLmlTyARjclW++8QTsh8QxDAw+gA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ffwDz0Zy6zKHLy7;
	Tue, 24 Mar 2026 11:16:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 91C4440592;
	Tue, 24 Mar 2026 11:17:27 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhGAsJp9NENCA--.17374S3;
	Tue, 24 Mar 2026 11:17:27 +0800 (CST)
Message-ID: <8363cbb0-d48e-48e0-964e-5965ecb3e4de@huaweicloud.com>
Date: Tue, 24 Mar 2026 11:17:25 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] ext4: move ordered data handling out of
 ext4_block_do_zero_range()
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-7-yi.zhang@huaweicloud.com>
 <cfniq2uvcf5al6ltvbw5s46nacv5a2j6vh57npu64rlqbftkrd@hel5yrb6f22s>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <cfniq2uvcf5al6ltvbw5s46nacv5a2j6vh57npu64rlqbftkrd@hel5yrb6f22s>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgD3+NhGAsJp9NENCA--.17374S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuw4UKr17Aw1kWw1UJr48Crg_yoWxWF4Upr
	y5KF45Cr47WF9F9F1IqF12qF1a9w1fKFW8WrW3GryFv34IvFn3KF1UKr1F9F1jvr47W3W0
	vF4Ut342gw1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UG-eOUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 3/24/2026 12:59 AM, Jan Kara wrote:
> On Tue 10-03-26 09:40:57, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Remove the handle parameter from ext4_block_do_zero_range() and move the
>> ordered data handling to ext4_block_zero_eof().
>>
>> This is necessary for truncate up and append writes across a range
>> extending beyond EOF. The ordered data must be committed before updating
>> i_disksize to prevent exposing stale on-disk data from concurrent
>> post-EOF mmap writes during previous folio writeback or in case of
>> system crash during append writes.
>>
>> This is unnecessary for partial block hole punching because the entire
>> punch operation does not provide atomicity guarantees and can already
>> expose intermediate results in case of crash.
> 
> Also because hole punching can only ever expose data that was there before
> the punch but missed zeroing during append / truncate could expose data
> that was not visible in the file before the operation.

Yeah, right, will add.

Thanks,
Yi.

> 
>> Since ordered data handling is no longer performed inside
>> ext4_zero_partial_blocks(), ext4_punch_hole() no longer needs to attach
>> jinode.
>>
>> This is prepared for the conversion to the iomap infrastructure, which
>> does not use ordered data mode while zeroing post-EOF partial blocks.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> The patch looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 
>> ---
>>  fs/ext4/inode.c | 58 ++++++++++++++++++++++++-------------------------
>>  1 file changed, 29 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 86f169df226a..8fea044b3bff 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4076,12 +4076,12 @@ static struct buffer_head *ext4_block_get_zero_range(struct inode *inode,
>>  	return err ? ERR_PTR(err) : NULL;
>>  }
>>  
>> -static int ext4_block_do_zero_range(handle_t *handle, struct inode *inode,
>> -				    loff_t from, loff_t length, bool *did_zero)
>> +static int ext4_block_do_zero_range(struct inode *inode, loff_t from,
>> +				    loff_t length, bool *did_zero,
>> +				    bool *zero_written)
>>  {
>>  	struct buffer_head *bh;
>>  	struct folio *folio;
>> -	int err = 0;
>>  
>>  	bh = ext4_block_get_zero_range(inode, from, length);
>>  	if (IS_ERR_OR_NULL(bh))
>> @@ -4092,19 +4092,14 @@ static int ext4_block_do_zero_range(handle_t *handle, struct inode *inode,
>>  	BUFFER_TRACE(bh, "zeroed end of block");
>>  
>>  	mark_buffer_dirty(bh);
>> -	/*
>> -	 * Only the written block requires ordered data to prevent exposing
>> -	 * stale data.
>> -	 */
>> -	if (ext4_should_order_data(inode) &&
>> -	    !buffer_unwritten(bh) && !buffer_delay(bh))
>> -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
>> -	if (!err && did_zero)
>> +	if (did_zero)
>>  		*did_zero = true;
>> +	if (zero_written && !buffer_unwritten(bh) && !buffer_delay(bh))
>> +		*zero_written = true;
>>  
>>  	folio_unlock(folio);
>>  	folio_put(folio);
>> -	return err;
>> +	return 0;
>>  }
>>  
>>  static int ext4_block_journalled_zero_range(handle_t *handle,
>> @@ -4148,7 +4143,8 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
>>   * that corresponds to 'from'
>>   */
>>  static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
>> -				 loff_t from, loff_t length, bool *did_zero)
>> +				 loff_t from, loff_t length, bool *did_zero,
>> +				 bool *zero_written)
>>  {
>>  	unsigned blocksize = inode->i_sb->s_blocksize;
>>  	unsigned int max = blocksize - (from & (blocksize - 1));
>> @@ -4167,7 +4163,8 @@ static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
>>  		return ext4_block_journalled_zero_range(handle, inode, from,
>>  							length, did_zero);
>>  	}
>> -	return ext4_block_do_zero_range(handle, inode, from, length, did_zero);
>> +	return ext4_block_do_zero_range(inode, from, length, did_zero,
>> +					zero_written);
>>  }
>>  
>>  /*
>> @@ -4184,6 +4181,7 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
>>  	unsigned int offset;
>>  	loff_t length = end - from;
>>  	bool did_zero = false;
>> +	bool zero_written = false;
>>  	int err;
>>  
>>  	offset = from & (blocksize - 1);
>> @@ -4196,9 +4194,22 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
>>  	if (length > blocksize - offset)
>>  		length = blocksize - offset;
>>  
>> -	err = ext4_block_zero_range(handle, inode, from, length, &did_zero);
>> +	err = ext4_block_zero_range(handle, inode, from, length,
>> +				    &did_zero, &zero_written);
>>  	if (err)
>>  		return err;
>> +	/*
>> +	 * It's necessary to order zeroed data before update i_disksize when
>> +	 * truncating up or performing an append write, because there might be
>> +	 * exposing stale on-disk data which may caused by concurrent post-EOF
>> +	 * mmap write during folio writeback.
>> +	 */
>> +	if (ext4_should_order_data(inode) &&
>> +	    did_zero && zero_written && !IS_DAX(inode)) {
>> +		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
>> +		if (err)
>> +			return err;
>> +	}
>>  
>>  	return did_zero ? length : 0;
>>  }
>> @@ -4222,13 +4233,13 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>>  	if (start == end &&
>>  	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
>>  		err = ext4_block_zero_range(handle, inode, lstart,
>> -					    length, NULL);
>> +					    length, NULL, NULL);
>>  		return err;
>>  	}
>>  	/* Handle partial zero out on the start of the range */
>>  	if (partial_start) {
>>  		err = ext4_block_zero_range(handle, inode, lstart,
>> -					    sb->s_blocksize, NULL);
>> +					    sb->s_blocksize, NULL, NULL);
>>  		if (err)
>>  			return err;
>>  	}
>> @@ -4236,7 +4247,7 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>>  	if (partial_end != sb->s_blocksize - 1)
>>  		err = ext4_block_zero_range(handle, inode,
>>  					    byte_end - partial_end,
>> -					    partial_end + 1, NULL);
>> +					    partial_end + 1, NULL, NULL);
>>  	return err;
>>  }
>>  
>> @@ -4411,17 +4422,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>>  		end = max_end;
>>  	length = end - offset;
>>  
>> -	/*
>> -	 * Attach jinode to inode for jbd2 if we do any zeroing of partial
>> -	 * block.
>> -	 */
>> -	if (!IS_ALIGNED(offset | end, sb->s_blocksize)) {
>> -		ret = ext4_inode_attach_jinode(inode);
>> -		if (ret < 0)
>> -			return ret;
>> -	}
>> -
>> -
>>  	ret = ext4_update_disksize_before_punch(inode, offset, length);
>>  	if (ret)
>>  		return ret;
>> -- 
>> 2.52.0
>>

