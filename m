Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A5735898;
	Tue,  7 Jul 2026 05:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783400513; cv=none; b=Dhz/cOrtzWEx8FxAx1rRGooAh6fp0JjDhH8cjCxKAxN+cvpDESkUYd+HkHyCA2Wt2UGa4nH5LX2pAHEJrNRVruusP1dhGqCnTLq+yLntC04tMfs5ElSLHmajz5LWWwuZ2Rv8AjoWhywDsPrrZH9cwhMnC+YdvUWw+eDZLMb79hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783400513; c=relaxed/simple;
	bh=7WX4PHBIySfrsuooDvN9lGBFokgvvnaQnBQpFTjQUVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmV2jA584QxtozlK55JgPSwaV0hkjg+rxdqesa3OHPj5VV5oT6RgwX8DZR7Mav71lWMNGZ6p9SEFeY35TqwfOrc0hJztbuCUlzHB8qSbb2nrNGcCHpdtYzdUOK+hhiKCJ8Fq4EBl+gEauL4rPXTw2HAx7QqBKZHRYOR1Z5NCmlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gvTbT4SX1zYQth6;
	Tue,  7 Jul 2026 13:01:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 627A340584;
	Tue,  7 Jul 2026 13:01:44 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH1nI2iExqgpJeAQ--.63493S3;
	Tue, 07 Jul 2026 13:01:44 +0800 (CST)
Message-ID: <247ecf85-5053-4d36-b34c-318e7096ca33@huaweicloud.com>
Date: Tue, 7 Jul 2026 13:01:41 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] ext4: move partial block zeroing earlier in
 ext4_zero_range()
To: Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260707021338.1182268-1-yi.zhang@huawei.com>
 <20260707021338.1182268-2-yi.zhang@huawei.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260707021338.1182268-2-yi.zhang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgDH1nI2iExqgpJeAQ--.63493S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXry7Jr18uryxur4Dtw4kXrb_yoW5Wryxpr
	W3GF13KF4fWrWq9FWxKF1Yvr1rC3ZrGF48CryfKryjvF95XryxKF98KF1FgF4jqrZ7AF48
	ZF4Yyry2gF15ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/7/2026 10:13 AM, Zhang Yi wrote:
> In ext4_zero_range(), move the ext4_zero_partial_blocks() call, which
> handles unaligned edges, into the same branch where the unaligned range
> is preallocated, immediately after ext4_alloc_file_blocks(). This is
> safe because there is no dependency between partial block handling and
> the subsequent full block handling.
> 
> This change will be used by later patches that handle unaligned
> FALLOC_FL_WRITE_ZEROES operations, which will need to check the partial
> zeroed result.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/extents.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 125f628e738a..27ca641e701b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4734,10 +4734,16 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	}
>  
>  	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
> -	/* Preallocate the range including the unaligned edges */
> +	/*
> +	 * Preallocate the range including the unaligned edges, and zero
> +	 * out partial blocks if they already contain data.
> +	 */
>  	if (!IS_ALIGNED(offset | end, blocksize)) {
>  		ret = ext4_alloc_file_blocks(file, offset, len, new_size,
>  					     flags);
> +		if (!ret)
> +			ret = ext4_zero_partial_blocks(inode, offset, len,
> +						       &partial_zeroed);
>  		if (ret)
>  			return ret;

Sashiko pointed out below:

>Is it safe to modify these folios before calling
>ext4_truncate_page_cache_block_range()?

>Previously, ext4_zero_range() called ext4_truncate_page_cache_block_range()
>first, which waits for writeback on the boundary folios via
>truncate_pagecache_range() -> truncate_inode_pages_range() ->
>truncate_inode_partial_folio().

>By zeroing the partial blocks earlier, ext4_block_do_zero_range() might
>acquire the folio lock and mutate the folio data while PG_writeback is still
>set, potentially causing data corruption or checksum mismatches if the block
>layer is actively DMA-ing it to disk.

I think this issue is confined to stable devices. The proposed fix is
to modify the fgf_flags passed to the folio lookup function in
ext4_load_tail_bh() by setting them to FGP_WRITEBEGIN | FGP_ACCESSED.

Thanks,
Yi.

>  	}
> @@ -4770,10 +4776,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	if (IS_ALIGNED(offset | end, blocksize))
>  		return ret;
>  
> -	/* Zero out partial block at the edges of the range */
> -	ret = ext4_zero_partial_blocks(inode, offset, len, &partial_zeroed);
> -	if (ret)
> -		return ret;
>  	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
>  		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
>  						   end - 1);

