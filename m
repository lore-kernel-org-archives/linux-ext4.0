Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0472F8EA3;
	Fri,  8 May 2026 08:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230055; cv=none; b=ZVKBFffEDNP6CvGqVuQ8V2RhbBh8nOBagGtvjfb+dnmBDjjN7VX8fRNq8tir3GJgwphoegwbJVVkuCqteECMKIPyyQ+3A8NXCwTBNax3erfcyKEzMBOp/DGQBQAijjPK+p9/TWkkUs5pozwotS0b+TvEVDljZZ1WYXHUCO1n+bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230055; c=relaxed/simple;
	bh=MfDI5WyTZZ8t37be9U7poyPhm7MzHsTY9D1Ckyy4K3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mGO2I1N1FtzThxfQpqPf77U4KYxwCPKa1bH2F1WexOsBIP0gEMRxVtn/iuq98VZJPZ5OLha7A/IgxeCDidgeWYLeUvAhwYo6zTWA7xlpjkt9dRTvZo8T3er5P9HfHHw3+GXp6ywClScWNqlakRX6l7F3n/ZWG3FR/oFX+UpdzsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gBjQh4857zKKL3y;
	Fri,  8 May 2026 16:46:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 67E384056D;
	Fri,  8 May 2026 16:47:22 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgAX31oYo_1p2igkBg--.13444S3;
	Fri, 08 May 2026 16:47:22 +0800 (CST)
Message-ID: <54dae7da-58de-470d-b930-7a3dac1ea389@huaweicloud.com>
Date: Fri, 8 May 2026 16:47:19 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/22] ext4: factor out ext4_truncate_[up|down]()
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260422021042.4157510-1-yi.zhang@huaweicloud.com>
 <20260422021042.4157510-3-yi.zhang@huaweicloud.com>
 <ucwp5hqcp6yghqbvpnmfsznzzuw6g7uerajm5x2zqtcyvsv33f@5ppt5hcffnsf>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ucwp5hqcp6yghqbvpnmfsznzzuw6g7uerajm5x2zqtcyvsv33f@5ppt5hcffnsf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAX31oYo_1p2igkBg--.13444S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw1fur1kZr17Kw1DKF1xKrg_yoW5tr1Dpr
	W7GFWUKw17WryDur1IqF4xXF1Fqa18Kr47ZFyfKr4v9F9Ivrn3tF1Iq3y5uFWUGr48Aw4j
	vF4DJFs7uw4rAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
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

On 4/30/2026 8:55 PM, Jan Kara wrote:
> On Wed 22-04-26 10:10:22, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Refactor ext4_setattr() by introducing two helper functions,
>> ext4_truncate_up() and ext4_truncate_down(), to handle size changes. The
>> current ATTR_SIZE processing consolidates checks for both shrinking and
>> non-shrinking cases, leading to cluttered code. Separating the
>> truncation paths improves readability.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Looks good. Just a few nits below.

Thank you for reviewing this series!

> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 94283a991e5c..9e4353432325 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -3501,6 +3501,23 @@ static inline int ext4_update_inode_size(struct inode *inode, loff_t newsize)
>>  	return changed;
>>  }
>>  
>> +/*
>> + * Set i_size and i_disksize to 'newsize'.
>> + *
>> + * Both i_rwsem and i_data_sem are required here to avoid races between
>> + * generic append writeback and concurrent truncate that also modify
>> + * i_size and i_disksize.
>> + */
>> +static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
>> +{
>> +	WARN_ON_ONCE(S_ISREG(inode->i_mode) && !inode_is_locked(inode));
>> +
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>> +	i_size_write(inode, newsize);
>> +	EXT4_I(inode)->i_disksize = newsize;
>> +	up_write(&EXT4_I(inode)->i_data_sem);
>> +}
>> +
> 
> Do we need this in the header later or can we keep it local to inode.c?

In the current version of the patch 021, this helper is called by
ext4_collapse_range() and ext4_insert_range(). However, after analyzing
sashiko's review comments, I believe this is unnecessary, so I will move
it to inode.c in my next iteration.

> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 0751dc55e94f..5e913aca6499 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -5855,6 +5855,83 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
>>  	}
>>  }
>>  
>> +static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
>> +{
>> +	ext4_lblk_t old_lblk, new_lblk;
>> +	handle_t *handle;
>> +	int ret;
>> +
>> +	if (!IS_ALIGNED(oldsize | newsize, i_blocksize(inode))) {
>> +		ret = ext4_inode_attach_jinode(inode);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>> +	if (oldsize & (i_blocksize(inode) - 1)) {
> 
> When you transitioned to IS_ALIGNED above, use it here as well?

Ha, right, I missed it.

> 
>> +		ret = ext4_block_zero_eof(inode, oldsize, LLONG_MAX);
>> +		if (ret)
>> +			return ret;
>> +	}
> 
> ...
> 
>> +		if (attr->ia_size > oldsize)
>> +			error = ext4_truncate_up(inode, oldsize, attr->ia_size);
>> +		else if (shrink)
>> +			error = ext4_truncate_down(inode, oldsize,
>> +						   attr->ia_size, &orphan);
>> +		if (error)
>> +			goto out_mmap_sem;
>>  
>>  		/*
>>  		 * Truncate pagecache after we've waited for commit
> 
> Hum, why not move the truncate_pagecache() call and ext4_truncate() call
> into ext4_truncate_down()? They are not needed in the truncate up case...

Yeah, agree. These two functions also need to be used in cases where
the file size remains unchanged. We can move them into ext4_truncate_down()
and extend it to handle the file size unchanged scenario.

Thanks,
Yi.

> 
> 								Honza
> 

