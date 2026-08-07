Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36B512B94
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 02:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786071571; cv=none; b=nTH+H48Nq7i8wFgdz2cEwSmj0xUfgp+wZ2oceaguncmaF7v9YX4i3XChJ2zB/h1Lu4vcmYi4g6cJnYxZ9Jkui6H+0IN9m9f7+d5dHSIl8AKCCl80KSjMHlhga2jlusu9D/0Eh15a6cPoez5obCewy2VsED2jo4qurXjOF3Z0b+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786071571; c=relaxed/simple;
	bh=T+LF/DiNBo+vMtZ+xBI5O5pWoUF6D8T/bdpdX2Eb/9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JgM/V7AADfjPlWncvkbs16oR/2FO5YLVWP9KO5sogiFcRw1CgQJ+9rbTn64Nn19cd0jNZ8I6hHi6U0vzYvSZ7TX9TP1pJV8zCTNFgfxjeYSlYYLHEHwbGU58mI1E6uw0mcTJbYc28u+gZYEsILu2pSIaQs/5YSFFZ0SV9PSzoOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hGTPp52QDzKHMQJ
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 10:59:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 812764057D
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 10:59:19 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgCnlUQFSnVqhBuaBQ--.41763S3;
	Fri, 07 Aug 2026 10:59:19 +0800 (CST)
Message-ID: <47ad8e97-ded5-43ed-90b6-227513a125c9@huaweicloud.com>
Date: Fri, 7 Aug 2026 10:59:17 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ext4: Teach ext4_meta_trans_blocks() about number of
 allocated extents
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <20260805153605.166545-4-jack@suse.cz>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260805153605.166545-4-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCnlUQFSnVqhBuaBQ--.41763S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr4xtrWxZw48Xr18AryDAwb_yoW7ZF48pF
	9xAF1rGr1rW34DuF4xKw4jvr4Fga1kJa1UWryaqrn5XF98GryxKF1Dt3WFyFyrKrWfXwnF
	vF45C34UCw45A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/5/2026 11:35 PM, Jan Kara wrote:
> So far ext4_meta_trans_blocks() expects that each extent counted in
> @pextents will be allocated in the transaction we estimate credits for.
> This is correct for the use in ext4_chunk_trans_blocks() and
> ext4_chunk_trans_extent() however the use in atomic write path
> (ext4_convert_unwritten_extents_atomic() and ext4_iomap_alloc() for
> IOMAP_ATOMIC) unnecessarily overestimates the number of necessary
> credits as neither of them allocates any data. Add argument to
> ext4_meta_trans_blocks() for number of extents that are going to be
> allocated in the transaction.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Hi Jan,

I have some questions below.

> ---
>  fs/ext4/ext4.h    |  2 +-
>  fs/ext4/extents.c |  2 +-
>  fs/ext4/inode.c   | 32 +++++++++++++++++---------------
>  3 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..6e0cc9b845ae 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3184,7 +3184,7 @@ extern int ext4_normal_submit_inode_data_buffers(struct jbd2_inode *jinode);
>  extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
>  extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
>  extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
> -				  int pextents);
> +				  int pextents, int alloc_extents);
>  extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
>  extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
>  				    loff_t length, bool *did_zero);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91c97af64b31..44ab246a3176 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4976,7 +4976,7 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
>  		 * it can tell if the extent in the cache is a split extent.
>  		 * But for now let's assume pextents as 2 always.
>  		 */
> -		credits = ext4_meta_trans_blocks(inode, max_blocks, 2);
> +		credits = ext4_meta_trans_blocks(inode, max_blocks, 2, 0);
>  	}
>  
>  	if (credits) {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..f324a54f1dae 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3693,9 +3693,11 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
>  		if (ret < 0)
>  			return ret;
>  		if (map->m_len < orig_mlen) {
> +			int bpg = EXT4_BLOCKS_PER_GROUP(inode->i_sb);
> +
>  			map->m_len = orig_mlen;
> -			dio_credits = ext4_meta_trans_blocks(inode, orig_mlen,
> -							     map->m_len);
> +			dio_credits = ext4_meta_trans_blocks(inode, map->m_len,
> +							     map->m_len, 0);

This pertains to the mixed map case, where holes may exist in between.
My understanding is that we cannot assume all blocks are already
allocated. Is this right?

>  		} else {
>  			dio_credits = ext4_chunk_trans_blocks(inode,
>  							      map->m_len);
> @@ -6307,17 +6309,17 @@ static int ext4_index_trans_blocks(struct inode *inode, int lblocks,
>  }
>  
>  /*
> - * Account for index blocks, block groups bitmaps and block group
> - * descriptor blocks if modify datablocks and index blocks
> - * worse case, the indexs blocks spread over different block groups
> - *
> - * If datablocks are discontiguous, they are possible to spread over
> - * different block groups too. If they are contiguous, with flexbg,
> - * they could still across block group boundary.
> - *
> - * Also account for superblock, inode, quota and xattr blocks
> + * Calculate number of credits needed in a transaction to:
> + *   * Allocate data blocks from @alloc_extents different groups - note that
> + *     with flexbg a single physical extent can span multiple groups but
> + *     single mballoc request only returns extent within one group.
> + *   * Allocate metatadata (extent tree blocks, indirect blocks) to store
> + *     pointers to @pextents data extents having @lblocks in total.
> + *   * Modify extent tree / indirect block tree, inode, superblock, quota
> + *     tracking, xattr blocks
>   */
> -int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
> +int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents,
> +			   int alloc_extents)

From what I can see, alloc_extents currently can only be 0 or equal to
pextents — 0 means a pure conversion, and equal to pextents means a new
allocation. pextents is supposed to cover the total count of
alloc_extents. Should we add some sanity checks to guard against invalid
inputs, like alloc_extents > pextents?

Thanks,
Yi.

>  {
>  	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
>  	int gdpblocks;
> @@ -6334,7 +6336,7 @@ int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
>  	 * Now let's see how many group bitmaps and group descriptors need
>  	 * to account
>  	 */
> -	groups = idxblocks + pextents;
> +	groups = idxblocks + alloc_extents;
>  	gdpblocks = groups;
>  	if (groups > ngroups)
>  		groups = ngroups;
> @@ -6360,7 +6362,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
>  {
>  	int ret;
>  
> -	ret = ext4_meta_trans_blocks(inode, nrblocks, 1);
> +	ret = ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
>  	/* Account for data blocks for journalled mode */
>  	if (ext4_should_journal_data(inode))
>  		ret += nrblocks;
> @@ -6378,7 +6380,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
>   */
>  int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
>  {
> -	return ext4_meta_trans_blocks(inode, nrblocks, 1);
> +	return ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
>  }
>  
>  /*

