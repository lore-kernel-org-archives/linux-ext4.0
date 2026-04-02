Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB76619EED3;
	Thu,  2 Apr 2026 01:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775092892; cv=none; b=EELp1Yl2Ae4HXGcWKtsHiuEiSoxE9XEJFGOQX/EdZoTAfAU1ITLQ07MPlMQuYSK2Bs9VkIFjCpQWP5dBDIsSx/+xe8xmA5tyxb9oBhESMNWh8Adu4q91cF6hl45Dbs+iDfL5RGwpXkNeCrdfoFcAvpkgEFaN6eguLy7Ggu5duts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775092892; c=relaxed/simple;
	bh=gimED5txO2mrx00rMuLVAsr0CRzfADlkvL9r8gTZEmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cUx/r3Xd22ne7fjyYj5Fbzz0GrEsXHasYKdWKEu/MhjKYlzhUf380kHZAN3bXYz8CL6erR1xBAuV3A/ZRHfPagFMCNylld5HFseis4JauERxxg29Zqxtp/PrSMgFZgCZB2EIC6+3QKpyL6C78TTXj6KcnmDzJioeb8tINRevNJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fmPDY0v2szKHMNZ;
	Thu,  2 Apr 2026 09:20:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 965134056E;
	Thu,  2 Apr 2026 09:21:19 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgC3BteMxM1pgtVBDA--.47465S3;
	Thu, 02 Apr 2026 09:21:19 +0800 (CST)
Message-ID: <f2011040-b0ff-407b-acaf-5aa96034fbd6@huaweicloud.com>
Date: Thu, 2 Apr 2026 09:21:16 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/13] ext4: ensure zeroed partial blocks are persisted
 in SYNC mode
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
 <20260327102939.1095257-10-yi.zhang@huaweicloud.com>
 <42toomq4fa64kbice5yl4spjsw4em2qcq7kvkkas6254iij3u2@r6ekulbdog3i>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <42toomq4fa64kbice5yl4spjsw4em2qcq7kvkkas6254iij3u2@r6ekulbdog3i>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgC3BteMxM1pgtVBDA--.47465S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtFW7CF4rJr1xWF1ruw4UJwb_yoW7CryUp3
	srJFy3GF43Wa48ur4IgF1UZr4Fvwn3KF48Wry3Gr1UZa9Fvw1xKFyUKr1F9F1j9r47Cw10
	vF4jy342gw13CFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 4/2/2026 1:06 AM, Jan Kara wrote:
> On Fri 27-03-26 18:29:35, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> In ext4_zero_range() and ext4_punch_hole(), when operating in SYNC mode
>> and zeroing a partial block, only data=journal modes guarantee that the
>> zeroed data is synchronously persisted after the operation completes.
>> For data=ordered/writeback mode and non-journal modes, this guarantee is
>> missing.
>>
>> Introduce a partial_zero parameter to explicitly trigger writeback for
>> all scenarios where a partial block is zeroed, ensuring the zeroed data
>> is durably persisted.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  fs/ext4/ext4.h    |  2 +-
>>  fs/ext4/extents.c |  9 ++++++++-
>>  fs/ext4/inode.c   | 19 ++++++++++++++-----
>>  3 files changed, 23 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 859ae05339ad..bfe86479a83c 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -3101,7 +3101,7 @@ extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
>>  				  int pextents);
>>  extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
>>  extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
>> -				    loff_t length);
>> +				    loff_t length, bool *did_zero);
>>  extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
>>  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
>>  extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 002b1ec8cee2..16386f499138 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -4673,6 +4673,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>>  	loff_t align_start, align_end, new_size = 0;
>>  	loff_t end = offset + len;
>>  	unsigned int blocksize = i_blocksize(inode);
>> +	bool partial_zeroed = false;
>>  	int ret, flags;
>>  
>>  	trace_ext4_zero_range(inode, offset, len, mode);
>> @@ -4728,9 +4729,15 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>>  		return ret;
>>  
>>  	/* Zero out partial block at the edges of the range */
>> -	ret = ext4_zero_partial_blocks(inode, offset, len);
>> +	ret = ext4_zero_partial_blocks(inode, offset, len, &partial_zeroed);
>>  	if (ret)
>>  		return ret;
>> +	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
>> +		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
>> +						   end - 1);
>> +		if (ret)
>> +			return ret;
>> +	}
> 
> Shouldn't we handle this somewhat below, where we do:
> 
>         if (file->f_flags & O_SYNC)
>                 ext4_handle_sync(handle);
> 
> It would be logical to keep these together... Similarly for
> ext4_punch_hole() below. An yes, the check when calling ext4_handle_sync()
> should be extended with an IS_SYNC() check, which is a preexisting bug.
> 
> 								Honza

Yeah, right, I've done this in the next patch. Thank you for your review!

Cheers,
Yi.

> 
>>  
>>  	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>>  	if (IS_ERR(handle)) {
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 8aa4369e3150..b934ad86a96d 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4227,7 +4227,8 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>  	return 0;
>>  }
>>  
>> -int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length)
>> +int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length,
>> +			     bool *did_zero)
>>  {
>>  	struct super_block *sb = inode->i_sb;
>>  	unsigned partial_start, partial_end;
>> @@ -4244,20 +4245,21 @@ int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length)
>>  	/* Handle partial zero within the single block */
>>  	if (start == end &&
>>  	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
>> -		err = ext4_block_zero_range(inode, lstart, length, NULL, NULL);
>> +		err = ext4_block_zero_range(inode, lstart, length, did_zero,
>> +					    NULL);
>>  		return err;
>>  	}
>>  	/* Handle partial zero out on the start of the range */
>>  	if (partial_start) {
>>  		err = ext4_block_zero_range(inode, lstart, sb->s_blocksize,
>> -					    NULL, NULL);
>> +					    did_zero, NULL);
>>  		if (err)
>>  			return err;
>>  	}
>>  	/* Handle partial zero out on the end of the range */
>>  	if (partial_end != sb->s_blocksize - 1)
>>  		err = ext4_block_zero_range(inode, byte_end - partial_end,
>> -					    partial_end + 1, NULL, NULL);
>> +					    partial_end + 1, did_zero, NULL);
>>  	return err;
>>  }
>>  
>> @@ -4406,6 +4408,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>>  	loff_t end = offset + length;
>>  	handle_t *handle;
>>  	unsigned int credits;
>> +	bool partial_zeroed = false;
>>  	int ret;
>>  
>>  	trace_ext4_punch_hole(inode, offset, length, 0);
>> @@ -4441,9 +4444,15 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>>  	if (ret)
>>  		return ret;
>>  
>> -	ret = ext4_zero_partial_blocks(inode, offset, length);
>> +	ret = ext4_zero_partial_blocks(inode, offset, length, &partial_zeroed);
>>  	if (ret)
>>  		return ret;
>> +	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
>> +		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
>> +						   end - 1);
>> +		if (ret)
>> +			return ret;
>> +	}
>>  
>>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>>  		credits = ext4_chunk_trans_extent(inode, 0);
>> -- 
>> 2.52.0
>>

