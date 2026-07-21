Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD6C433BC8;
	Tue, 21 Jul 2026 07:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784619788; cv=none; b=Fopnca14v9+1zOb3o8TFDZByHx2PuJYC+GnCGTpePN4h6k2Kk4BF2LKRO2Esd4e4HmRjprgNdtkCWgCn6SI57N8GZ3L9kdA/1XIFD4ATynM97Yu/XTI/E9lYjLrt37qL/7XWaII6klPjnJw+xKAmrSRPfspDxzKjEVwNl7KKd8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784619788; c=relaxed/simple;
	bh=XvKEUKXS9hUFEI/4pPtiKYcMCoivNHcUM6dndapa+KU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=EzwiiAmnDflUNk90OHBGqinSMAFmuwc80ocmGXmt3hbMNuyuLCN0ZSmuKoIpqhAWvzkc+D8OwG+g0J4tiJP/N9z9FR/2xlaz93yUI9h0TS3JYasQhE15UYk77TBOBiSDPpJK5a4S+RtSMC0KngYXM4YUZP7L2x1WBjfYAyfBJj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h48VY0FlFzYQtqH;
	Tue, 21 Jul 2026 15:42:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id F414140C88;
	Tue, 21 Jul 2026 15:42:55 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCX8W3+Il9qmxkICA--.27173S3;
	Tue, 21 Jul 2026 15:42:55 +0800 (CST)
Message-ID: <8c443e8f-178f-4411-9027-320a14a40c80@huaweicloud.com>
Date: Tue, 21 Jul 2026 15:42:53 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: cache full extents during mapping lookup
To: Fengnan Chang <changfengnan@bytedance.com>
References: <20260720075133.50539-1-changfengnan@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com
In-Reply-To: <20260720075133.50539-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCX8W3+Il9qmxkICA--.27173S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw4UAF4Dtw17tFWkuF18AFb_yoW7KF4xp3
	9Iyr15GrsxW34vgayxJF4UXr1rWa48GFW7Ar93Kr1rCFy5XryftF10kFyUuFy0grWxXF13
	ZFWFkw1DGa17XFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/20/2026 3:51 PM, Fengnan Chang wrote:
> The extent status (ES) tree and extent tree leaf buffers are reclaimed
> independently.  An ES entry can be reclaimed while the leaf buffer remains
> cached with BH_Verified set.
> 
> When this happens, ext4_es_lookup_extent() misses.  Since the leaf buffer
> is already verified, __read_extent_tree_block() returns it without calling
> ext4_cache_extents().  ext4_ext_map_blocks() returns the part of the extent
> covered by the request, and ext4_map_query_blocks() caches only that range.
> Reads to other blocks in the same extent then keep missing the ES tree and
> walking the extent tree.
> 
> Cache the full extent in ext4_ext_map_blocks() before the returned mapping
> is limited to the requested range.  Check the ES tree under the read lock
> first.  If the full extent is not there, ext4_es_cache_extent() checks
> again under the write lock before inserting it.
> 
> Do not do this when ext4_ext_map_blocks() is called with
> EXT4_GET_BLOCKS_CREATE or EXT4_EX_NOCACHE.  NOCACHE paths can change extent
> mappings, so caching ranges outside the request can leave stale ES entries.
> Cache both written and unwritten extents, as ext4_cache_extents() does.
> 
> Tested with fio 4K random direct reads using libaio at iodepth 128 on a
> 128 GiB file with 208 on-disk extents.  The results are averages of three
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
> Link: https://lore.kernel.org/r/20260714114358.93335-1-changfengnan@bytedance.com
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>

Thank you for the patch! This overall looks good to me, just some minor
suggestions below.

> ---
>  fs/ext4/extents.c        |  9 +++++++++
>  fs/ext4/extents_status.c | 33 +++++++++++++++++++++++++++++++++
>  fs/ext4/extents_status.h |  3 +++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91c97af64b317..f43dd9c3bc44e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4310,6 +4310,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  		ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
>  		ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
>  		unsigned short ee_len;
> +		unsigned int status;
>  
>  
>  		/*
> @@ -4317,6 +4318,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
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
> +				ext4_es_cache_extent_if_missing(inode, ee_block,
> +								ee_len, ee_start,
> +								status);

After this patch, I think the calls to ext4_es_cache_extent() in
ext4_map_query_blocks_next_in_leaf() and ext4_map_query_blocks() can
also be replaced with this helper.

> +
>  			/*
>  			 * If the extent is initialized check whether the
>  			 * caller wants to convert it to unwritten.
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..83fe2068ab656 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -1082,6 +1082,39 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  			   ext4_es_pblock(&chkes), ext4_es_status(&chkes));
>  }
>  
> +/*
> + * Avoid taking i_es_lock for writing if the entire extent is already cached.
> + * ext4_es_cache_extent() rechecks under the write lock if the cache changes
> + * after this read-side check.
> + */
> +void ext4_es_cache_extent_if_missing(struct inode *inode, ext4_lblk_t lblk,

I'd prefer to move this logic into ext4_es_cache_extent() and add a
parameter(e.g., read_search) to control whether to do pre-search unbder
the read lock. If the extent is likely to already exist on the status
tree, we can pass 1. Sounds good?

Thanks,
Yi.

> +				     ext4_lblk_t len, ext4_fsblk_t pblk,
> +				     unsigned int status)
> +{
> +	struct extent_status *es;
> +	ext4_lblk_t end;
> +	bool cached;
> +
> +	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
> +		return;
> +
> +	if (!len)
> +		return;
> +
> +	end = lblk + len - 1;
> +	if (WARN_ON_ONCE(end < lblk))
> +		return;
> +
> +	read_lock(&EXT4_I(inode)->i_es_lock);
> +	es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
> +	cached = es && es->es_lblk <= lblk && ext4_es_end(es) >= end &&
> +		 !__es_check_extent_status(es, status, NULL);
> +	read_unlock(&EXT4_I(inode)->i_es_lock);
> +
> +	if (!cached)
> +		ext4_es_cache_extent(inode, lblk, len, pblk, status);
> +}
> +
>  /*
>   * ext4_es_lookup_extent() looks up an extent in extent status tree.
>   *
> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> index f3396cf32b446..d8fab84911352 100644
> --- a/fs/ext4/extents_status.h
> +++ b/fs/ext4/extents_status.h
> @@ -140,6 +140,9 @@ extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
>  				 ext4_lblk_t len, ext4_fsblk_t pblk,
>  				 unsigned int status);
> +void ext4_es_cache_extent_if_missing(struct inode *inode, ext4_lblk_t lblk,
> +				     ext4_lblk_t len, ext4_fsblk_t pblk,
> +				     unsigned int status);
>  extern void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  				  ext4_lblk_t len);
>  extern void ext4_es_find_extent_range(struct inode *inode,

