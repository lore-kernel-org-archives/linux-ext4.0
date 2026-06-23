Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F261F30595C
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 03:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782186045; cv=none; b=kXCvwGkVapCj3Yd4CPZ0nkhtGeIbrbqvL9XVp33AmxuDMqNt7yK6Pi50Gwd7swcwWjVPa0zgki+R7uC/ywj27wFe9Wa17w+qH3HYgI6IXStnOHvgfqJ4+GMCQnR6plVHw6skgrc+9ZS41VKiiVgTQvBskiKmajqjkiShuPP1bu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782186045; c=relaxed/simple;
	bh=oZKAmo/Psnj20favKjx7Edco1E0ai6c2ZtrQKLpsypQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gw9cL/iOLfm/MM5yDGkSrGFUA7Ju2yas5ryb84B1pkx7oGmmb0Jex0bsipPjnlD6EGPIHn5DVJaUQ+0E7X5Z8BqSRvX4kDM8jHKpaWjUCM01C76NfzVl7Rj5S3gLlI74YeIoi9P42yLpcIHRmVe1NxAoFv78Zi/gSmSLzDjaGq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gkrRH2SVmzKHMbc
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 11:39:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C5E774056E
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 11:40:36 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgA3OT4zADpq8OQhCw--.59600S3;
	Tue, 23 Jun 2026 11:40:36 +0800 (CST)
Message-ID: <7954a2a3-2b67-4221-acc1-41dc4694ff3a@huaweicloud.com>
Date: Tue, 23 Jun 2026 11:40:34 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/8] ext4: handle IOMAP_NOWAIT in ext4_iomap_begin()
 with cache-only lookup
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-8-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260618125735.4156639-8-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgA3OT4zADpq8OQhCw--.59600S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar1rJrWkWF1DCr1kKw4xCrg_yoW8Kw17pa
	98KFy5GFyfXryxuwsaqr98ZF1Fg3WDKF4UXa43Gw15Gas8t34fKF48u3Wakw1Yq3yxAw10
	vF45tryxuay8CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/18/2026 8:57 PM, Baokun Li wrote:
> Pass EXT4_GET_BLOCKS_CACHED_NOWAIT flag to ext4_map_blocks() when
> IOMAP_NOWAIT is set, ensuring that extent lookups only use the cached
> extent status tree. If the cache misses, ext4_map_blocks() returns
> -EAGAIN instead of sleeping on down_read(i_data_sem) to read extent
> tree from disk.
> 
> This applies to both write and read paths in ext4_iomap_begin(),
> allowing DIO/DAX operations with RWF_NOWAIT to avoid blocking on
> extent tree lookups.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/inode.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 03adbca3ec78..09f85cd6c118 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3781,6 +3781,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	struct ext4_map_blocks map;
>  	u8 blkbits = inode->i_blkbits;
>  	unsigned int orig_mlen;
> +	int map_flags = 0;
>  
>  	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
>  		return -EINVAL;
> @@ -3795,6 +3796,12 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	map.m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
>  			  EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
>  	orig_mlen = map.m_len;
> +	/*
> +	 * In NOWAIT context, only use cached extent info. If es cache misses,
> +	 * return -EAGAIN to avoid sleeping on down_read(i_data_sem).
> +	 */
> +	if (flags & IOMAP_NOWAIT)
> +		map_flags = EXT4_GET_BLOCKS_CACHED_NOWAIT;
>  
>  	if (flags & IOMAP_WRITE) {
>  		/*
> @@ -3804,7 +3811,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  		 * especially in multi-threaded overwrite requests.
>  		 */
>  		if (offset + length <= i_size_read(inode)) {
> -			ret = ext4_map_blocks(NULL, inode, &map, 0);
> +			ret = ext4_map_blocks(NULL, inode, &map, map_flags);
>  			/*
>  			 * For DAX we convert extents to initialized ones before
>  			 * copying the data, otherwise we do it after I/O so
> @@ -3825,7 +3832,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  		}
>  		ret = ext4_iomap_alloc(inode, &map, flags);
>  	} else {
> -		ret = ext4_map_blocks(NULL, inode, &map, 0);
> +		ret = ext4_map_blocks(NULL, inode, &map, map_flags);
>  	}
>  
>  	if (ret < 0)

