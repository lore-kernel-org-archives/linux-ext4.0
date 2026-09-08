Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727904A8FC7
	for <linux-ext4@vger.kernel.org>; Tue,  8 Sep 2026 11:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788867132; cv=none; b=lRdQ5mKRjtpNMVVoGVqp6EaxNO7Z2xEpuyzuTjFzWjztBSWSIXfNyWjOEKperstvzY9xVDKhTqMDsMxfWVW60jQi+f0eNIK/1VLCVs9q6oQ462I6Rxvxk3vH/XlOjz4zSOYiQDU4e8X3uWxhJt/oPUhOy+DPnQ2d69GvVIAWQrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788867132; c=relaxed/simple;
	bh=BXh1jfGOwSSYqVSb/qoSkujtFkL+BLzfJuZyEeMqsnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ePJxLHYjGKhEwwwu2x3JyRXlMfP3SF4idt3So5AZoi3q6+HlLKR4FEluZpxaxb0H7zxrjIiK77qegVmVHtQx6wpsQp27TXJu3FujjBa3vXIu2w24PzhOysT6ORBn9wIHXYXzAAP3qYlNm6HvyMZAolKbPmRvQkLVgemTEE7K7mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hfMFb4qpFzYQwC4
	for <linux-ext4@vger.kernel.org>; Tue,  8 Sep 2026 19:30:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 167C140576
	for <linux-ext4@vger.kernel.org>; Tue,  8 Sep 2026 19:31:51 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDnzwol8p9qcvfQBA--.59919S3;
	Tue, 08 Sep 2026 19:31:50 +0800 (CST)
Message-ID: <0ba6970a-6203-45db-8837-17bb54b2fb8b@huaweicloud.com>
Date: Tue, 8 Sep 2026 19:31:49 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/31] ext4: skip ordered I/O wait when zeroing beyond
 i_disksize block
To: sashiko-reviews@lists.linux.dev
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-4-yi.zhang@huaweicloud.com>
 <20260903131452.4F8131F00ACA@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260903131452.4F8131F00ACA@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgDnzwol8p9qcvfQBA--.59919S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurykuFy8ZFW7tw45Kr45ZFb_yoWrJFW7p3
	yUGFyDAF4kJ34F9rn2g340qF1j9ws5Ga13Ga4qgr4qvrW5u3W0kFn7tFyavFWjkrs5J3Wj
	qF4qvrZ7Aa4qk3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kfnx
	nUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/3/2026 9:14 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Skipping ordered I/O wait based on an unstabilized `i_disksize` allows stale data exposure due to a race with concurrent writeback and mmap.
> --
> 
> commit 9f1f97ff9aa74fccfe7305cebcde6a641f847ab5
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: skip ordered I/O wait when zeroing beyond i_disksize block
> 
> ext4_block_zero_eof() zeros the tail of a partial block beyond EOF.
> After zeroing, it waits for ordered I/O completion to prevent stale
> data exposure from concurrent post-EOF mmap writes during folio
> writeback.
> 
> However, if the zeroed range lies entirely beyond the block containing
> i_disksize, no stale data can be exposed because the zeroed region is
> beyond existing on-disk data. The zeroed pages will be written out
> before i_disksize is later extended past i_size, so the ordered I/O
> wait is unnecessary. Add a condition to skip it.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index d0ccafa554f8d..339ebd553959b 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4241,9 +4241,22 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
> 
> [ ... ]
> 
>> +	 * Note that it's safe to read i_disksize without holding i_data_sem
>> +	 * here. Since we already hold i_rwsem, the only possible race is with
>> +	 * concurrent writeback that updates i_disksize. And if such a race
>> +	 * occurs, it means the previous unaligned EOF block has already been
>> +	 * zeroed (if needed) and persisted to disk.
>>  	 */
>>  	if (ext4_should_order_data(inode) &&
>> -	    did_zero && zero_written && !IS_DAX(inode)) {
>> +	    did_zero && zero_written && !IS_DAX(inode) &&
>> +	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {
> 
> [Severity: High]
> Does this condition rely on an unstabilized i_disksize to skip the ordered
> I/O wait, creating a window where in-flight writeback IO can leak stale data
> upon a crash?
> 
> If a file has a delayed allocated block at the end, its on-disk size
> (i_disksize) could be lagging (e.g., 0). If the user mmaps the file and
> writes data past EOF into the page cache, delayed allocation writeback can
> begin, allocating the block and formatting a BIO with the user's stale
> post-EOF data.
> 
> Concurrently, if a truncate operation extends the file (truncate up), it
> calls ext4_block_zero_eof(), which zeroes the page cache tail and marks it
> dirty. However, because READ_ONCE(EXT4_I(inode)->i_disksize) is 0, the
> check evaluates to false.
> 
> This incorrectly skips ext4_jbd2_inode_add_write(), failing to add the
> newly zeroed data to the ordered data list. The truncate operation then
> sets i_disksize to the new size and commits the transaction, waiting only
> for the first BIO (containing the stale data), not the zeroes.
> 
> If a crash occurs, upon recovery, the on-disk block would contain the stale
> data because the transaction committed the new i_disksize without waiting
> for the zeroed page cache to be written.
> 
> Note that this issue does not appear to be resolved by follow-up patches in
> the series. While commit "ext4: set DISKSIZE_GROW_PENDING after zeroing
> unaligned EOF block" introduces ext4_iomap_mark_disksize_pending() which
> safely waits for writeback, it is placed inside the exact same flawed
> condition branch, meaning the wait is still bypassed.

I think the concurrency scenario that Sashiko mentioned does exist, so it
looks like we'll have to abandon this optimization.

Thanks,
Yi.

> 
>>  		handle_t *handle;
>>  
>>  		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> 

