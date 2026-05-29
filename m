Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C39364942;
	Fri, 29 May 2026 09:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780046048; cv=none; b=BZEVrv8dvYXL2XrImLVkPI8PK+UuNPxpVhaZpdhpJMe2bhHVxE4RyKWj13Zw///wlxQ3S4UMN3NMR8F2maXcHd3Gn0nVIIAnn3ZUe4SlyNl1hLRcQaYH1G+QmZ0KV3/bhNFW8UyPioL7k9Ks3DOFKYC89fVZYENLk4AKxVxV4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780046048; c=relaxed/simple;
	bh=ANhNrvXcDMF4vCV202euB2Ggezb5zfktbSD1nVHuMIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bOf+uTN0IliT/nGxxd+rNa72TvsjNv19mk+meS6nQ/HhOOC1UGzU/LJh/QItRhGDqFsUN9jAyD6YDygpzCn22yKyNljzZyLbL9rF9gxkZB+voNw91HaqFe5Awbi5+zxtPz+NXd3h9cquOetc4PjBq3pihWPxkUh+EuYrDpQNmxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gRd1R0jWqzYQv6m;
	Fri, 29 May 2026 17:12:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 920714056B;
	Fri, 29 May 2026 17:13:58 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1vUWBlqX0cyEA--.36427S3;
	Fri, 29 May 2026 17:13:58 +0800 (CST)
Message-ID: <83e36f9c-aeb1-40d4-9265-fd22120a7fa9@huaweicloud.com>
Date: Fri, 29 May 2026 17:13:55 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/23] ext4: implement buffered write path using iomap
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-9-yi.zhang@huaweicloud.com>
 <ahXUBgoivo5CFl39@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ahXUBgoivo5CFl39@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgD3v1vUWBlqX0cyEA--.36427S3
X-Coremail-Antispam: 1UD129KBjvAXoWfGFyftrW7Ar1kJr17WF45Jrb_yoW8GFW5uo
	Waqw47Xr4xAryYkFW8u34xJFyUua9rCw18AF4rZrZIqryaq3W5Cw47Jw43Zay7Xw1FkF48
	Ga4xJa45CrWkJa15n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUY27kC6x804xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
	GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	UAwIDUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Hi, Ojaswin!

On 5/27/2026 1:10 AM, Ojaswin Mujoo wrote:
> On Mon, May 11, 2026 at 03:23:28PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Introduce two new iomap_ops instances for ext4 buffered writes:
>>
>>  - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
>>    ext4_da_map_blocks() to map delalloc extents.
>>  - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
>>    ext4_iomap_get_blocks() to directly allocate blocks.
>>
>> Also add ext4_iomap_valid() for the iomap infrastructure to check extent
>> validity.
>>
>> Key changes and considerations:
>>
>>  - Unwritten extents for new blocks (dioread_nolock always on)
>>    Since data=ordered mode is not used to prevent stale data exposure in
>>    the non-delayed allocation path, new blocks are always allocated as
>>    unwritten extents.
> 
> Okay makes sense.
> 
>>
>>  - Short write and write failure handling
>>    a. Delalloc path: On short write or failure, the stale delalloc range
>>       must be dropped and its space reservation released. Otherwise, a
>>       clean folio may cover leftover delalloc extents, causing
>>       inaccurate space reservation accounting.
> 
> Hmm, okay so in the usual buffer head path, seems like during a short
> write we still zero the new buffers we couldn't write and keep it dirty
> (folio_zero_new_buffers()). This way they are still written back and
> the delalloc reservations are used up.
> 

In fact, in the normal buffer head path, writeback does not consume
delalloc reservations. Instead, the reservations are retained until the
inode is released or the area is written again using delalloc. This is
because i_size is not updated during short writes. Therefore, when a
zeroed dirty folio is written back, no block mapping is created for it.
For details, please see the lblk >= blocks judgment in
mpage_process_page_bufs().

This will not lead to duplicate space statistics, because
ext4_da_map_blocks() only reserves space when inserting a new delalloc
extent. Therefore, this does not pose a serious issue. However, It may
cause some temporary and minor space leaks. Nevertheless, I think it
would be better if delalloc extents could be released for the buffer
head path when short writes occur.

> However in iomap we don't mark the range that we couldnt write as dirty
> so we need to make sure we clear up the stale delalloc mappings. Is this
> correct?
> 
Yeah.

Thanks,
Yi.

> Regards,
> Ojaswin
> 
>>    b. Non-delalloc path: No cleanup of allocated blocks is needed on
>>       short write.
>>
>>  - Lock ordering reversal
>>    The folio lock and transaction start ordering is reversed compared to
>>    the buffer_head buffered write path. To handle this, the journal
>>    handle must be stopped in iomap_begin() callbacks. The lock ordering
>>    documentation in super.c has been updated accordingly.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  fs/ext4/ext4.h  |   4 ++
>>  fs/ext4/file.c  |  20 +++++-
>>  fs/ext4/inode.c | 165 +++++++++++++++++++++++++++++++++++++++++++++++-
>>  fs/ext4/super.c |  10 ++-
>>  4 files changed, 192 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 1e27d73d7427..4832e7f7db82 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -3057,6 +3057,7 @@ int ext4_walk_page_buffers(handle_t *handle,
>>  int do_journal_get_write_access(handle_t *handle, struct inode *inode,
>>  				struct buffer_head *bh);
>>  void ext4_set_inode_mapping_order(struct inode *inode);
>> +int ext4_nonda_switch(struct super_block *sb);
>>  #define FALL_BACK_TO_NONDELALLOC 1
>>  #define CONVERT_INLINE_DATA	 2
>>  
>> @@ -3926,6 +3927,9 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
>>  
>>  extern const struct iomap_ops ext4_iomap_ops;
>>  extern const struct iomap_ops ext4_iomap_report_ops;
>> +extern const struct iomap_ops ext4_iomap_buffered_write_ops;
>> +extern const struct iomap_ops ext4_iomap_buffered_da_write_ops;
>> +extern const struct iomap_write_ops ext4_iomap_write_ops;
>>  
>>  static inline int ext4_buffer_uptodate(struct buffer_head *bh)
>>  {
>> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
>> index eb1a323962b1..7f9bfbbc4a4e 100644
>> --- a/fs/ext4/file.c
>> +++ b/fs/ext4/file.c
>> @@ -299,6 +299,21 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>>  	return count;
>>  }
>>  
>> +static ssize_t ext4_iomap_buffered_write(struct kiocb *iocb,
>> +					 struct iov_iter *from)
>> +{
>> +	struct inode *inode = file_inode(iocb->ki_filp);
>> +	const struct iomap_ops *iomap_ops;
>> +
>> +	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
>> +		iomap_ops = &ext4_iomap_buffered_da_write_ops;
>> +	else
>> +		iomap_ops = &ext4_iomap_buffered_write_ops;
>> +
>> +	return iomap_file_buffered_write(iocb, from, iomap_ops,
>> +					 &ext4_iomap_write_ops, NULL);
>> +}
>> +
>>  static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>>  					struct iov_iter *from)
>>  {
>> @@ -313,7 +328,10 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>>  	if (ret <= 0)
>>  		goto out;
>>  
>> -	ret = generic_perform_write(iocb, from);
>> +	if (ext4_inode_buffered_iomap(inode))
>> +		ret = ext4_iomap_buffered_write(iocb, from);
>> +	else
>> +		ret = generic_perform_write(iocb, from);
>>  
>>  out:
>>  	inode_unlock(inode);
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 39577a6b65b9..1ae7d3f4a1c8 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3097,7 +3097,7 @@ static int ext4_dax_writepages(struct address_space *mapping,
>>  	return ret;
>>  }
>>  
>> -static int ext4_nonda_switch(struct super_block *sb)
>> +int ext4_nonda_switch(struct super_block *sb)
>>  {
>>  	s64 free_clusters, dirty_clusters;
>>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>> @@ -3467,6 +3467,15 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
>>  	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
>>  }
>>  
>> +static bool ext4_iomap_valid(struct inode *inode, const struct iomap *iomap)
>> +{
>> +	return iomap->validity_cookie == READ_ONCE(EXT4_I(inode)->i_es_seq);
>> +}
>> +
>> +const struct iomap_write_ops ext4_iomap_write_ops = {
>> +	.iomap_valid = ext4_iomap_valid,
>> +};
>> +
>>  static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>>  			   struct ext4_map_blocks *map, loff_t offset,
>>  			   loff_t length, unsigned int flags)
>> @@ -3501,6 +3510,8 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>>  	    !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>>  		iomap->flags |= IOMAP_F_MERGED;
>>  
>> +	iomap->validity_cookie = map->m_seq;
>> +
>>  	/*
>>  	 * Flags passed to ext4_map_blocks() for direct I/O writes can result
>>  	 * in m_flags having both EXT4_MAP_MAPPED and EXT4_MAP_UNWRITTEN bits
>> @@ -3908,8 +3919,12 @@ const struct iomap_ops ext4_iomap_report_ops = {
>>  	.iomap_begin = ext4_iomap_begin_report,
>>  };
>>  
>> +/* Map blocks */
>> +typedef int (ext4_get_blocks_t)(struct inode *, struct ext4_map_blocks *);
>> +
>>  static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
>> -		loff_t length, struct ext4_map_blocks *map)
>> +		loff_t length, ext4_get_blocks_t get_blocks,
>> +		struct ext4_map_blocks *map)
>>  {
>>  	u8 blkbits = inode->i_blkbits;
>>  
>> @@ -3921,6 +3936,9 @@ static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
>>  	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
>>  			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
>>  
>> +	if (get_blocks)
>> +		return get_blocks(inode, map);
>> +
>>  	return ext4_map_blocks(NULL, inode, map, 0);
>>  }
>>  
>> @@ -3938,7 +3956,7 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
>>  	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
>>  		return -ERANGE;
>>  
>> -	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
>> +	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
>>  	if (ret < 0)
>>  		return ret;
>>  
>> @@ -3946,6 +3964,147 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
>>  	return 0;
>>  }
>>  
>> +static int ext4_iomap_get_blocks(struct inode *inode,
>> +				 struct ext4_map_blocks *map)
>> +{
>> +	loff_t i_size = i_size_read(inode);
>> +	handle_t *handle;
>> +	int ret;
>> +
>> +	/*
>> +	 * Check if the blocks have already been allocated, this could
>> +	 * avoid initiating a new journal transaction and return the
>> +	 * mapping information directly.
>> +	 */
>> +	if ((map->m_lblk + map->m_len) <=
>> +	    round_up(i_size, i_blocksize(inode)) >> inode->i_blkbits) {
>> +		ret = ext4_map_blocks(NULL, inode, map, 0);
>> +		if (ret < 0)
>> +			return ret;
>> +		if (map->m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN |
>> +				    EXT4_MAP_DELAYED))
>> +			return 0;
>> +	}
>> +
>> +	handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
>> +			ext4_chunk_trans_blocks(inode, map->m_len));
>> +	if (IS_ERR(handle))
>> +		return PTR_ERR(handle);
>> +
>> +	ret = ext4_map_blocks(handle, inode, map,
>> +			      EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
>> +	/*
>> +	 * Stop handle here following the lock ordering of the folio lock
>> +	 * and the transaction start.
>> +	 */
>> +	ext4_journal_stop(handle);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
>> +		loff_t offset, loff_t length, unsigned int flags,
>> +		struct iomap *iomap, struct iomap *srcmap, bool delalloc)
>> +{
>> +	int ret, retries = 0;
>> +	struct ext4_map_blocks map;
>> +	ext4_get_blocks_t *get_blocks;
>> +
>> +	ret = ext4_emergency_state(inode->i_sb);
>> +	if (unlikely(ret))
>> +		return ret;
>> +
>> +	/* Inline data and non-extent are not supported. */
>> +	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
>> +		return -ERANGE;
>> +	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>> +		return -EINVAL;
>> +	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
>> +		return -EINVAL;
>> +
>> +	if (delalloc)
>> +		get_blocks = ext4_da_map_blocks;
>> +	else
>> +		get_blocks = ext4_iomap_get_blocks;
>> +retry:
>> +	ret = ext4_iomap_map_blocks(inode, offset, length, get_blocks, &map);
>> +	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>> +		goto retry;
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>> +	return 0;
>> +}
>> +
>> +static int ext4_iomap_buffered_write_begin(struct inode *inode,
>> +		loff_t offset, loff_t length, unsigned int flags,
>> +		struct iomap *iomap, struct iomap *srcmap)
>> +{
>> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
>> +						  iomap, srcmap, false);
>> +}
>> +
>> +static int ext4_iomap_buffered_da_write_begin(struct inode *inode,
>> +		loff_t offset, loff_t length, unsigned int flags,
>> +		struct iomap *iomap, struct iomap *srcmap)
>> +{
>> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
>> +						  iomap, srcmap, true);
>> +}
>> +
>> +/*
>> + * On write failure, drop the stale delayed allocation range and release
>> + * its reserved space for both start and end blocks. Otherwise, we may
>> + * leave a range of delayed extents covered by a clean folio, which can
>> + * result in inaccurate space reservation accounting.
>> + */
>> +static void ext4_iomap_punch_delalloc(struct inode *inode, loff_t offset,
>> +				     loff_t length, struct iomap *iomap)
>> +{
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>> +	ext4_es_remove_extent(inode, offset >> inode->i_blkbits,
>> +			DIV_ROUND_UP_ULL(length, EXT4_BLOCK_SIZE(inode->i_sb)));
>> +	up_write(&EXT4_I(inode)->i_data_sem);
>> +}
>> +
>> +static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
>> +					    loff_t length, ssize_t written,
>> +					    unsigned int flags,
>> +					    struct iomap *iomap)
>> +{
>> +	loff_t start_byte, end_byte;
>> +
>> +	/* If we didn't reserve the blocks, we're not allowed to punch them. */
>> +	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
>> +		return 0;
>> +
>> +	/* Nothing to do if we've written the entire delalloc extent */
>> +	start_byte = iomap_last_written_block(inode, offset, written);
>> +	end_byte = round_up(offset + length, i_blocksize(inode));
>> +	if (start_byte >= end_byte)
>> +		return 0;
>> +
>> +	filemap_invalidate_lock(inode->i_mapping);
>> +	iomap_write_delalloc_release(inode, start_byte, end_byte, flags,
>> +				     iomap, ext4_iomap_punch_delalloc);
>> +	filemap_invalidate_unlock(inode->i_mapping);
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Since we always allocate unwritten extents, there is no need for
>> + * iomap_end to clean up allocated blocks on a short write.
>> + */
>> +const struct iomap_ops ext4_iomap_buffered_write_ops = {
>> +	.iomap_begin = ext4_iomap_buffered_write_begin,
>> +};
>> +
>> +const struct iomap_ops ext4_iomap_buffered_da_write_ops = {
>> +	.iomap_begin = ext4_iomap_buffered_da_write_begin,
>> +	.iomap_end = ext4_iomap_buffered_da_write_end,
>> +};
>> +
>>  const struct iomap_ops ext4_iomap_buffered_read_ops = {
>>  	.iomap_begin = ext4_iomap_buffered_read_begin,
>>  };
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 6a77db4d3124..9bc294b769db 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -104,9 +104,13 @@ static const struct fs_parameter_spec ext4_param_specs[];
>>   *   -> page lock -> i_data_sem (rw)
>>   *
>>   * buffered write path:
>> - * sb_start_write -> i_mutex -> mmap_lock
>> - * sb_start_write -> i_mutex -> transaction start -> page lock ->
>> - *   i_data_sem (rw)
>> + * sb_start_write -> i_rwsem (w) -> mmap_lock
>> + * - buffer_head path:
>> + *   sb_start_write -> i_rwsem (w) -> transaction start -> folio lock ->
>> + *     i_data_sem (rw)
>> + * - iomap path:
>> + *   sb_start_write -> i_rwsem (w) -> transaction start -> i_data_sem (rw)
>> + *   sb_start_write -> i_rwsem (w) -> folio lock (not under an active handle)
>>   *
>>   * truncate:
>>   * sb_start_write -> i_mutex -> invalidate_lock (w) -> i_mmap_rwsem (w) ->
>> -- 
>> 2.52.0
>>

