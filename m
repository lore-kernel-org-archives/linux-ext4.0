Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B50346A14
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 02:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784774072; cv=none; b=hfQFPhANc3Uv9lkxF/9PdVq0P6ee/JlpJSl7jeAP7yL8wagKlk5dE2+Jh3QsyH44T9/Ku1PtnF6MFN3qPLpFHKiAzAZfp23wUD5vLBIljpSvUp26N+Cb7F4lNeS0kz2C/sshJBoCIMpeHIYv2qkzTkrQD+fIcfe/m2Oc17uXlzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784774072; c=relaxed/simple;
	bh=UYE59VTnzVBcm9IDRrBDECxQZav5Db/Eoog8yTS/spo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WgXmZUz6t1qZn/Whro7oK90/T03iiNjjvK/EaG7ZfRVDPbMIPBxo+AgOKP4wK4Ta0mN6sxa/MUfizkGSnmJqDxHLJVzwNC/+WsA+pX3FVWcMtA0TySa25sYrLknBCQj4GFYsf0lk0UTjIIKpoP1JQZ6LblAqS5YOv2W9cJzxpW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h5FY72pBkzKHMYn
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 10:33:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 06D254056B
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 10:34:16 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCnt3OmfWFqKDvgCA--.5286S3;
	Thu, 23 Jul 2026 10:34:15 +0800 (CST)
Message-ID: <58a61b7d-50f3-4d49-a5f5-8afe62d9311f@huaweicloud.com>
Date: Thu, 23 Jul 2026 10:34:13 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4: cache full extents during mapping lookup
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com
References: <20260722133655.70112-1-changfengnan@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260722133655.70112-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCnt3OmfWFqKDvgCA--.5286S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw4UAF4Dtw17tryDGrW8tFb_yoW3ZF1xp3
	9Fyr15GrW5W34v9ayxJF4Uur1ru3WxKrW7J3yfKr1rCFy5Xr1SkF10kFy7ZFy0qrW0qa1Y
	vF4Fkw1DGa13KFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/22/2026 9:36 PM, Fengnan Chang wrote:
> The extent status (ES) tree and extent tree leaf buffers are reclaimed
> independently. An ES entry can be reclaimed while the leaf buffer remains
> cached with BH_Verified set.
> 
> When this happens, ext4_es_lookup_extent() misses.  Since the leaf buffer
> is already verified, __read_extent_tree_block() returns it without calling
> ext4_cache_extents(). ext4_ext_map_blocks() returns the part of the extent
> covered by the request, and ext4_map_query_blocks() caches only that range.
> Reads to other blocks in the same extent then keep missing the ES tree and
> walking the extent tree.
> 
> Cache the full extent in ext4_ext_map_blocks() before the returned mapping
> is limited to the requested range. Add an optional read-side lookup to
> ext4_es_cache_extent().
> 
> Do not do this when ext4_ext_map_blocks() is called with
> EXT4_GET_BLOCKS_CREATE or EXT4_EX_NOCACHE. NOCACHE paths can change extent
> mappings, so caching ranges outside the request can leave stale ES entries.
> Cache both written and unwritten extents, as ext4_cache_extents() does.
> 
> Tested with fio 4K random direct reads using libaio at iodepth 128 on a
> 128 GiB file with 208 on-disk extents. The results are averages of three
> 10-second runs:
> 
>                  before reclaim    after reclaim
>   unpatched        419.6k IOPS       274.6k IOPS
>   patched          426.1k IOPS       423.7k IOPS
> 
> Average completion latency went from 303.02 to 462.78 us without the patch,
> and from 298.36 to 300.07 us with the patch.
> 
> No latency regression was seen in A/B test.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Zhang Yi <yi.zhang@huawei.com>
> Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@bytedance.com
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
>  fs/ext4/extents.c        | 17 +++++++++++++----
>  fs/ext4/extents_status.c | 17 ++++++++++++++++-
>  fs/ext4/extents_status.h |  2 +-
>  fs/ext4/inode.c          | 10 ++++++----
>  4 files changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91c97af64b317..85e213761a18d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -537,12 +537,12 @@ static void ext4_cache_extents(struct inode *inode,
>  
>  		if (prev && (prev != lblk))
>  			ext4_es_cache_extent(inode, prev, lblk - prev, ~0,
> -					     EXTENT_STATUS_HOLE);
> +					     EXTENT_STATUS_HOLE, false);
>  
>  		if (ext4_ext_is_unwritten(ex))
>  			status = EXTENT_STATUS_UNWRITTEN;
>  		ext4_es_cache_extent(inode, lblk, len,
> -				     ext4_ext_pblock(ex), status);
> +				     ext4_ext_pblock(ex), status, false);
>  		prev = lblk + len;
>  	}
>  }
> @@ -4239,7 +4239,8 @@ static ext4_lblk_t ext4_ext_determine_insert_hole(struct inode *inode,
>  insert_hole:
>  	/* Put just found gap into cache to speed up subsequent requests */
>  	ext_debug(inode, " -> %u:%u\n", hole_start, len);
> -	ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE);
> +	ext4_es_cache_extent(inode, hole_start, len, ~0, EXTENT_STATUS_HOLE,
> +			     false);
>  
>  	/* Update hole_len to reflect hole size after lblk */
>  	if (hole_start != lblk)
> @@ -4310,13 +4311,15 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
>  		ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
>  		unsigned short ee_len;
> -
> +		unsigned int status;
>  
>  		/*
>  		 * unwritten extents are treated as holes, except that
>  		 * we split out initialized portions during a write.
>  		 */
>  		ee_len = ext4_ext_get_actual_len(ex);
> +		status = ext4_ext_is_unwritten(ex) ?
> +			 EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>  
>  		trace_ext4_ext_show_extent(inode, ee_block, ee_start, ee_len);
>  
> @@ -4328,6 +4331,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  			ext_debug(inode, "%u fit into %u:%d -> %llu\n",
>  				  map->m_lblk, ee_block, ee_len, newblock);
>  
> +			if (!(flags & (EXT4_GET_BLOCKS_CREATE |
> +				       EXT4_EX_NOCACHE)))
> +				ext4_es_cache_extent(inode, ee_block, ee_len,
> +						     ee_start, status,
> +						     true);
> +
>  			/*
>  			 * If the extent is initialized check whether the
>  			 * caller wants to convert it to unwritten.
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..5a03878b06160 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -1023,7 +1023,7 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>   */
>  void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  			  ext4_lblk_t len, ext4_fsblk_t pblk,
> -			  unsigned int status)
> +			  unsigned int status, bool pre_search)
>  {
>  	struct extent_status *es;
>  	struct extent_status chkes, newes;
> @@ -1043,6 +1043,21 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  
>  	BUG_ON(end < lblk);
>  
> +	/*
> +	 * Avoid taking i_es_lock for writing if the entire extent is already
> +	 * cached. The write-locked search below rechecks after a miss.
> +	 */
> +	if (pre_search) {
> +		read_lock(&EXT4_I(inode)->i_es_lock);
> +		es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
> +		if (es && es->es_lblk <= lblk && ext4_es_end(es) >= end &&
> +		    !__es_check_extent_status(es, status, NULL)) {
> +			read_unlock(&EXT4_I(inode)->i_es_lock);
> +			return;
> +		}
> +		read_unlock(&EXT4_I(inode)->i_es_lock);
> +	}
> +
>  	write_lock(&EXT4_I(inode)->i_es_lock);
>  	es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
>  	if (es && es->es_lblk <= end) {
> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> index f3396cf32b446..c2da72e3c82ba 100644
> --- a/fs/ext4/extents_status.h
> +++ b/fs/ext4/extents_status.h
> @@ -139,7 +139,7 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  				  bool delalloc_reserve_used);
>  extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  				 ext4_lblk_t len, ext4_fsblk_t pblk,
> -				 unsigned int status);
> +				 unsigned int status, bool pre_search);
>  extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  				  ext4_lblk_t len);
>  extern void ext4_es_find_extent_range(struct inode *inode,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b2..341b7c649e133 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -523,7 +523,7 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
>  
>  	if (retval <= 0) {
>  		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
> -				     map->m_pblk, status);
> +				     map->m_pblk, status, true);
>  		return map->m_len;
>  	}
>  
> @@ -546,11 +546,11 @@ static int ext4_map_query_blocks_next_in_leaf(handle_t *handle,
>  			status == status2) {
>  		ext4_es_cache_extent(inode, map->m_lblk,
>  				     map->m_len + map2.m_len, map->m_pblk,
> -				     status);
> +				     status, true);
>  		map->m_len += map2.m_len;
>  	} else {
>  		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
> -				     map->m_pblk, status);
> +				     map->m_pblk, status, true);
>  	}
>  
>  	return map->m_len;
> @@ -562,6 +562,8 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
>  	unsigned int status;
>  	int retval;
>  	unsigned int orig_mlen = map->m_len;
> +	bool pre_search = ext4_test_inode_flag(inode,
> +					      EXT4_INODE_EXTENTS);

As previously noted, it would be advisable to add a comment here to
clarify the reason for the difference between extent and indirect.
With this, then feel free to add:

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

>  
>  	flags &= EXT4_EX_QUERY_FILTER;
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> @@ -593,7 +595,7 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
>  		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
>  				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
>  		ext4_es_cache_extent(inode, map->m_lblk, map->m_len,
> -				     map->m_pblk, status);
> +				     map->m_pblk, status, pre_search);
>  	} else {
>  		retval = ext4_map_query_blocks_next_in_leaf(handle, inode, map,
>  							    orig_mlen);

