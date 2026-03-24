Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0841570818;
	Tue, 24 Mar 2026 03:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774322971; cv=none; b=kB2MVih4rT3dNIovbwKeHLJER16UYkARPU9BgUgR7aS97Rg//ZCktIRFijHjFNhcNuxpG322G9M4m1BxfjjA2ieMO8qP5sXYi+Jq7NzVGQ8dGr2cd8eCymrwPuY8Q1uHXMOBw7Fd8hxJYoZD/3V/Ay2tdKMwh58u2RyC7dxhjFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774322971; c=relaxed/simple;
	bh=W+zML29ThLJvgg5xVFwOhFpst4BSV6pLRaUhcTsK+68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gKivB9ykO78Dvc9xL4h167fDAyXRErMkhPU34b7M2L2vmE92FLO072TQhg0ujG3i+/1XtslKU8Hrcu8lKwIm8KB+7BAQ4fq3oLcEtbovLD9f4L/22eaM1ah8Fbe9TRXML9+r6GSfS8DuByhxzCZKXhmQ/uRTrEUZxvY3twncBO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ffwWL3s8YzYQtgV;
	Tue, 24 Mar 2026 11:29:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 882C94056B;
	Tue, 24 Mar 2026 11:29:26 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgC3BtcUBcJputIOCA--.56435S3;
	Tue, 24 Mar 2026 11:29:26 +0800 (CST)
Message-ID: <a256a938-56ae-4a9c-b6d7-b74175f04393@huaweicloud.com>
Date: Tue, 24 Mar 2026 11:29:23 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] ext4: zero post-EOF partial block before appending
 write
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-11-yi.zhang@huaweicloud.com>
 <fcjjsad6v5v6ubtjidrstg3pjeeqn7njjm2qrovufdklnbhhci@ldy4nrlmtoek>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <fcjjsad6v5v6ubtjidrstg3pjeeqn7njjm2qrovufdklnbhhci@ldy4nrlmtoek>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgC3BtcUBcJputIOCA--.56435S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurWfCr48tFy7AF17Zw15XFb_yoWrtry7pF
	ZIk3W7uwnFqF9rur1Ig3WDXry29a48Jr4xGry3Ka4rZ3ZrCr1rKF1Sg348GFW5ArW7Jw4F
	qF4q9F9ru3Wjy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	0PfPUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 3/24/2026 4:31 AM, Jan Kara wrote:
> On Tue 10-03-26 09:41:01, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> In cases of appending write beyond EOF, ext4_zero_partial_blocks() is
>> called within ext4_*_write_end() to zero out the partial block beyond
>> EOF. This prevents exposing stale data that might be written through
>> mmap.
>>
>> However, supporting only the regular buffered write path is
>> insufficient. It is also necessary to support the DAX path as well as
>> the upcoming iomap buffered write path. Therefore, move this operation
>> to ext4_write_checks().
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> I'd note that this allows page fault to race in between the zeroing and
> actual write resulting in new possible result - previously for file size 8,
> pwrite('WWWW...', 8, 16) racing with mmap writes of 'MMMMMM...' at offset 8
> into the page you could see either:
> 
> DDDDDDDD00000000WWWWWWWW
> or
> DDDDDDDDMMMMMMMMMMMMMMMM
> 
> 
> now you can see both of the above an also
> 
> DDDDDDDMMMMMMMMWWWWWWWWW
> 
> But I don't think that's strictly invalid content and userspace that would
> depend on the outcome of such race would be silly. So feel free to add:

Yes exactly.  :-)

Thanks,
Yi.

> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 
>> ---
>>  fs/ext4/file.c  | 14 ++++++++++++++
>>  fs/ext4/inode.c | 21 +++++++--------------
>>  2 files changed, 21 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index f1dc5ce791a7..b2e44601ab6a 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
>> @@ -271,6 +271,8 @@ static ssize_t ext4_generic_write_checks(struct kiocb *iocb,
>>  
>>  static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>>  {
>> +	struct inode *inode = file_inode(iocb->ki_filp);
>> +	loff_t old_size = i_size_read(inode);
>>  	ssize_t ret, count;
>>  
>>  	count = ext4_generic_write_checks(iocb, from);
>> @@ -280,6 +282,18 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>>  	ret = file_modified(iocb->ki_filp);
>>  	if (ret)
>>  		return ret;
>> +
>> +	/*
>> +	 * If the position is beyond the EOF, it is necessary to zero out the
>> +	 * partial block that beyond the existing EOF, as it may contains
>> +	 * stale data written through mmap.
>> +	 */
>> +	if (iocb->ki_pos > old_size && !ext4_verity_in_progress(inode)) {
>> +		ret = ext4_block_zero_eof(inode, old_size, iocb->ki_pos);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>>  	return count;
>>  }
>>  
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 5288d36b0f09..67a4d12fcb4d 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -1456,10 +1456,9 @@ static int ext4_write_end(const struct kiocb *iocb,
>>  	folio_unlock(folio);
>>  	folio_put(folio);
>>  
>> -	if (old_size < pos && !verity) {
>> +	if (old_size < pos && !verity)
>>  		pagecache_isize_extended(inode, old_size, pos);
>> -		ext4_block_zero_eof(inode, old_size, pos);
>> -	}
>> +
>>  	/*
>>  	 * Don't mark the inode dirty under folio lock. First, it unnecessarily
>>  	 * makes the holding time of folio lock longer. Second, it forces lock
>> @@ -1574,10 +1573,8 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>>  	folio_unlock(folio);
>>  	folio_put(folio);
>>  
>> -	if (old_size < pos && !verity) {
>> +	if (old_size < pos && !verity)
>>  		pagecache_isize_extended(inode, old_size, pos);
>> -		ext4_block_zero_eof(inode, old_size, pos);
>> -	}
>>  
>>  	if (size_changed) {
>>  		ret2 = ext4_mark_inode_dirty(handle, inode);
>> @@ -3196,7 +3193,7 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>>  	struct inode *inode = mapping->host;
>>  	loff_t old_size = inode->i_size;
>>  	bool disksize_changed = false;
>> -	loff_t new_i_size, zero_len = 0;
>> +	loff_t new_i_size;
>>  	handle_t *handle;
>>  
>>  	if (unlikely(!folio_buffers(folio))) {
>> @@ -3240,19 +3237,15 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>>  	folio_unlock(folio);
>>  	folio_put(folio);
>>  
>> -	if (pos > old_size) {
>> +	if (pos > old_size)
>>  		pagecache_isize_extended(inode, old_size, pos);
>> -		zero_len = pos - old_size;
>> -	}
>>  
>> -	if (!disksize_changed && !zero_len)
>> +	if (!disksize_changed)
>>  		return copied;
>>  
>> -	handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
>> +	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
>>  	if (IS_ERR(handle))
>>  		return PTR_ERR(handle);
>> -	if (zero_len)
>> -		ext4_block_zero_eof(inode, old_size, pos);
>>  	ext4_mark_inode_dirty(handle, inode);
>>  	ext4_journal_stop(handle);
>>  
>> -- 
>> 2.52.0
>>

