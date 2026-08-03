Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A632EEE78;
	Mon,  3 Aug 2026 01:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785720729; cv=none; b=rFeDmD11V9el3NwgaLsf9pqATdShUwL7PCwM6+Z9GGuVF7clXm6neheY/7MSyUei5rv3WSktDEKAbpJS9ahipX4vSrAxWDrhO2+odrSrwe7zxpfjdXuqMu56aSc15sdjjRbHBI3WKViaKMw8hcOdpIde7WQbrx9HEp6dKubf1KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785720729; c=relaxed/simple;
	bh=ieuPbdHG5VbubJf+xHGOWfxAeD2pp79wpuVrVSMMMUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXNb5T9cfo6IO5BG63AXOJWnqC752RommocMrtR3TCfFxBG0obYHbXxz9SJgc0O69d72bhyhrfkYQfFUdW7V1zeud/xERdUazcjo4YdxQvEjKZ1OUaTvEonwmtNBLo1ND178vWsEQjyCX5WoyUUz6dOdHb2Wi3nxnsCxdX4Tw38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hCzfx4ZltzKHMRX;
	Mon,  3 Aug 2026 09:31:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D5FE14056D;
	Mon,  3 Aug 2026 09:31:55 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgCX1EOJ729qUK2oAw--.7830S3;
	Mon, 03 Aug 2026 09:31:55 +0800 (CST)
Message-ID: <c02696f0-308f-4bee-b7b3-95d702fa441a@huaweicloud.com>
Date: Mon, 3 Aug 2026 09:31:53 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ext4: protect WRITE_ZEROES written extents with
 orphan list
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
 <20260729085918.3336221-3-yi.zhang@huaweicloud.com>
 <amyP2KXXgLUC0_aC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <amyP2KXXgLUC0_aC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgCX1EOJ729qUK2oAw--.7830S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKw17JF17Zw4UZr17Gry7GFg_yoW7uw15pF
	Z8AF1rGFZ5Was29Fs2qF4Dur1Fka4xGrWUurySgrWjvas8Zrn7Kry5K3yY9a4qqr48ZF4Y
	vr4Utr9rGan8AFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02
	F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4I
	kC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/31/2026 8:06 PM, Ojaswin Mujoo wrote:
> On Wed, Jul 29, 2026 at 04:59:18PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
>> extents to written in one transaction, while i_disksize is updated to
>> cover them only in a later transaction. A crash in between leaves
>> written extents beyond i_disksize on disk, which fsck will complain
>> about.
>>
>> To fix this, add the inode to the orphan list in the same handle that
>> does the conversion, and remove it once i_disksize has caught up.
>> Also add a sanity check to ensure conversion does not extend beyond EOF.
>>
>> Since ext4_alloc_file_blocks() is called from the fallocate() path,
>> partial allocation is safe. On partial conversion failure, advance
>> i_disksize only up to the boundary of successfully converted blocks, so
>> that orphan cleanup sees a consistent state. Document this behavior in
>> the function comment.
> 
> Hi Yi,
> 
> Look good,
> 
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Hi, Ojaswin,

Thank you for the review!

> 
> Just a small question below:
>>
>> Reported-by: Jan Kara <jack@suse.cz>
>> Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
>> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  fs/ext4/extents.c | 78 ++++++++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 70 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 1ab1a6e2ed83..a3dde7ba0d23 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -4571,6 +4571,22 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
>>  	return err;
>>  }
>>  
>> +/*
>> + * Pre-allocate blocks for the range [@offset, @offset + @len). Allocated
>> + * blocks are marked as unwritten by default. If EXT4_GET_BLOCKS_ZERO is
>> + * set, the allocated blocks are zeroed on disk and their extents are
>> + * converted to written state.
>> + *
>> + * When @new_size is nonzero, the caller intends to extend the file, and
>> + * the file size should be updated to the end of the allocated blocks.
>> + *
>> + * Allocation may partially succeed due to some non-fatal issues. In that
>> + * case, i_disksize (and i_size) is advanced up to the successfully
>> + * processed portion of the range.
>> + *
>> + * Return 0 on success, or a negative error code on failure or partial
>> + * failure.
>> + */
>>  static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>>  				  loff_t new_size, int flags)
>>  {
>> @@ -4585,6 +4601,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>>  	loff_t epos = 0, old_size = i_size_read(inode);
>>  	unsigned int blkbits = inode->i_blkbits;
>>  	bool alloc_zero = false;
>> +	bool orphan = false;
>>  
>>  	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
>>  	map.m_lblk = offset >> blkbits;
>> @@ -4659,19 +4676,49 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>>  
>>  		if (alloc_zero &&
>>  		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
>> +			ext4_lblk_t converted;
>> +
>> +			WARN_ON_ONCE(map.m_lblk + map.m_len >
>> +				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
>> +
>>  			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
>>  						 map.m_len);
>> -			if (likely(!ret))
>> -				ret = ext4_convert_unwritten_extents(NULL,
>> -					inode, (loff_t)map.m_lblk << blkbits,
>> -					(loff_t)map.m_len << blkbits, NULL);
>> -			if (ret)
>> +			if (unlikely(ret))
>>  				break;
>> +
>> +			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
>> +						    credits);
>> +			if (IS_ERR(handle)) {
>> +				ret = PTR_ERR(handle);
>> +				break;
>> +			}
>> +
>> +			ret = ext4_convert_unwritten_extents(handle,
>> +					inode, (loff_t)map.m_lblk << blkbits,
>> +					(loff_t)map.m_len << blkbits,
>> +					&converted);
>> +			if (ret)
>> +				map.m_len = converted;
>> +
>> +			/*
>> +			 * If blocks beyond i_disksize are converted, add
>> +			 * the inode to the orphan list and advance the epos.
>> +			 */
>> +			if (new_size && converted) {
>> +				ret2 = ext4_orphan_add(handle, inode);
>> +				ret = ret ? ret : ret2;
>> +				orphan = true;
>> +			}
>> +
>> +			ret3 = ext4_journal_stop(handle);
>> +			ret = ret ? ret : ret3;
>>  		}
>>  
>>  		map.m_lblk += map.m_len;
>>  		map.m_len = len_lblk = len_lblk - map.m_len;
>>  		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
>> +		if (ret)
>> +			break;
>>  	}
>>  
>>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>> @@ -4687,11 +4734,23 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>>  	if (epos > new_size)
>>  		epos = new_size;
>>  
>> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>> -	if (IS_ERR(handle))
>> -		return ret ? ret : PTR_ERR(handle);
>> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
>> +	if (IS_ERR(handle)) {
>> +		/*
>> +		 * The conversion has successfully completed. Not much to
>> +		 * do with the error here so just cleanup the orphan list
>> +		 * and hope for the best.
>> +		 */
>> +		if (orphan && inode->i_nlink)
>> +			ext4_orphan_del(NULL, inode);
>> +		ret2 = PTR_ERR(handle);
>> +		goto out;
>> +	}
>>  
>>  	ext4_update_inode_size(inode, epos);
>> +	if (orphan && inode->i_nlink)
>> +		ext4_orphan_del(handle, inode);
>> +
> 
> So I believe the i_nlink check is incase the inode is already at i_nlink
> = 0 before the fallocate() was called and hence mostly already on the
> orphan list. We need to skip deletion from the list as inode eviction
> will handle cleaning it up, right?

Yes, after ext4_evict_inode() has reclaimed all the file blocks, the
inode will be cleared from the orphan list.

Thanks,
Yi.


