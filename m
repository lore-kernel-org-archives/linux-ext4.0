Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E1A233920;
	Sat, 30 May 2026 01:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780104101; cv=none; b=eFHK3UwQlcB9ZO0C1iw5Eu445+v+B0yD43nLTLEIVTXFQZzlG5MumMt6tiCF8JFIrr1Fvbfx4RJBvC+giN8ymMaooLWptxERGLxx38YW+J8aiwySv3TTudH6jUBnCMwDrsoPbO5MYibNGemoAUEs+rhUpOJHK1XWgcD+/+RkXpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780104101; c=relaxed/simple;
	bh=I9h44NgYixv8hPi4r+t+3lTg+AVFRMIZ1pEJ0OvdHbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JaRUNzqJnDx0/wrq6hVQMXmzqXJiBL6WXRZz26FMvfwyjVsLJJeUOOs6QXXqx4jeqb9dmMZAsSfmPKYOdhItzw00/R3R9FcwwTHF9co2ONEsCEdEflh/xOtLV4lxZdmkIOX6E0AlYRavb3AwuWHYfI3kuvg2LkNMVtRETcCQL3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gS2Vf6Wl7zKHMKL;
	Sat, 30 May 2026 09:21:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 968AF4056D;
	Sat, 30 May 2026 09:21:33 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgAHz1qbOxpqCqKEEA--.54113S3;
	Sat, 30 May 2026 09:21:33 +0800 (CST)
Message-ID: <29370885-bd50-4032-939f-2c377330872d@huaweicloud.com>
Date: Sat, 30 May 2026 09:21:31 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/23] ext4: implement writeback path using iomap
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yizhang089@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-10-yi.zhang@huaweicloud.com>
 <ahboWtDYXagrgTR4@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <458bda7a-c3c6-4cb3-9c05-0718cf2ef95f@gmail.com>
 <ahmxmrWzIWRR9PUm@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ahmxmrWzIWRR9PUm@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAHz1qbOxpqCqKEEA--.54113S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKrWUCF4DWrykGF4rAr1DJrb_yoWfuFW5pr
	WkCF1UGr4UXry2grsavw12qrnakw48Kr47Wry3Ga4Yvr90yF1fKFWjkF1j9Fy0yr47CF1U
	ZF4jkry7urWYyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

On 5/29/2026 11:32 PM, Ojaswin Mujoo wrote:
> On Fri, May 29, 2026 at 10:12:12PM +0800, Zhang Yi wrote:
>> Hi, Ojaswin!
>>
>> On 5/27/2026 8:49 PM, Ojaswin Mujoo wrote:
>>> On Mon, May 11, 2026 at 03:23:29PM +0800, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> Add the iomap writeback path for ext4 buffered I/O. This introduces:
>>>>
>>>>   - ext4_iomap_writepages(): the main writeback entry point.
>>>>   - ext4_writeback_ops: a new iomap_writeback_ops instance to handle
>>>>     block mapping and I/O submission.
>>>>   - A new end I/O worker for converting unwritten extents, updating file
>>>>     size, and handling DATA_ERR_ABORT after I/O completion.
>>>>
>>>> Core implementation details:
>>>>
>>>>   - ->writeback_range() callback
>>>>     Calls ext4_iomap_map_writeback_range() to query the longest range of
>>>>     existing mapped extents. For performance, when a block range is not
>>>>     yet allocated, it allocates based on the writeback length and delalloc
>>>>     extent length, rather than allocating for a single folio at a time.
>>>>     The folio is then added to an iomap_ioend instance.
>>>>
>>>>   - ->writeback_submit() callback
>>>>     Registers ext4_iomap_end_bio() as the end bio callback. This callback
>>>>     schedules a worker to handle:
>>>>     - Unwritten extent conversion.
>>>>     - i_disksize update after data is written back.
>>>>     - Journal abort on writeback I/O failure.
>>>
>>> Hi Zhang, the changes look good. I have a few comments below:
>>>>
>>>> Key changes and considerations:
>>>>
>>>> - Append write and unwritten extents
>>>>    Since data=ordered mode is not used to prevent stale data exposure
>>>>    during append writebacks, new blocks are always allocated as unwritten
>>>>    extents (i.e. always enable dioread_nolock), and i_disksize update is
>>>>    postponed until I/O completion.
>>>
>>> Makes sense.
>>>
>>>>    Additionally, the deadlock that the
>>>>    reserve handle was expected to resolve does not occur anymore.
>>>
>>> I guess this is since we don't use ordered data so we can't block on
>>> starting a txn in end io.
>>
>> Yep.
>>
>>>
>>>>    Therefore, the end I/O worker can start a normal journal handle
>>>>    instead of a reserve handle when converting unwritten extents.
>>>>
>>>> - Lock ordering
>>>>    The ->writeback_range() callback runs under the folio lock, requiring
>>>>    the journal handle to be started under that same lock. This reverses
>>>>    the order compared to the buffer_head writeback path. The lock ordering
>>>>    documentation in super.c has been updated accordingly.
>>>>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> ---
>>>>   fs/ext4/ext4.h        |   4 +
>>>>   fs/ext4/inode.c       | 208 +++++++++++++++++++++++++++++++++++++++++-
>>>>   fs/ext4/page-io.c     | 126 +++++++++++++++++++++++++
>>>>   fs/ext4/super.c       |   7 +-
>>>>   fs/iomap/ioend.c      |   3 +-
>>>>   include/linux/iomap.h |   1 +
>>>>   6 files changed, 346 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>> index 4832e7f7db82..078feda47e36 100644
>>>> --- a/fs/ext4/ext4.h
>>>> +++ b/fs/ext4/ext4.h
>>>> @@ -1173,6 +1173,8 @@ struct ext4_inode_info {
>>>>   	 */
>>>>   	struct list_head i_rsv_conversion_list;
>>>>   	struct work_struct i_rsv_conversion_work;
>>>> +	struct list_head i_iomap_ioend_list;
>>>> +	struct work_struct i_iomap_ioend_work;
>>>>   	/*
>>>>   	 * Transactions that contain inode's metadata needed to complete
>>>> @@ -3870,6 +3872,8 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *page,
>>>>   		size_t len);
>>>>   extern struct ext4_io_end_vec *ext4_alloc_io_end_vec(ext4_io_end_t *io_end);
>>>>   extern struct ext4_io_end_vec *ext4_last_io_end_vec(ext4_io_end_t *io_end);
>>>> +extern void ext4_iomap_end_io(struct work_struct *work);
>>>> +extern void ext4_iomap_end_bio(struct bio *bio);
>>>>   /* mmp.c */
>>>>   extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index 1ae7d3f4a1c8..a80195bd6f20 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -44,6 +44,7 @@
>>>>   #include <linux/iversion.h>
>>>>   #include "ext4_jbd2.h"
>>>> +#include "ext4_extents.h"
>>>>   #include "xattr.h"
>>>>   #include "acl.h"
>>>>   #include "truncate.h"
>>>> @@ -4120,10 +4121,215 @@ static void ext4_iomap_readahead(struct readahead_control *rac)
>>>>   	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
>>>>   }
>>>> +static int ext4_iomap_map_one_extent(struct inode *inode,
>>>> +				     struct ext4_map_blocks *map)
>>>> +{
>>>> +	struct extent_status es;
>>>> +	handle_t *handle = NULL;
>>>> +	int credits, map_flags;
>>>> +	int retval;
>>>> +
>>>> +	credits = ext4_chunk_trans_blocks(inode, map->m_len);
>>>> +	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, credits);
>>>> +	if (IS_ERR(handle))
>>>> +		return PTR_ERR(handle);
>>>> +
>>>> +	map->m_flags = 0;
>>>> +	/*
>>>> +	 * It is necessary to look up extent and map blocks under i_data_sem
>>>> +	 * in write mode, otherwise, the delalloc extent may become stale
>>>> +	 * during concurrent truncate operations.
>>>> +	 */
>>>> +	ext4_fc_track_inode(handle, inode);
>>>> +	down_write(&EXT4_I(inode)->i_data_sem);
>>>> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>>>> +		retval = es.es_len - (map->m_lblk - es.es_lblk);
>>>> +		map->m_len = min_t(unsigned int, retval, map->m_len);
>>>> +
>>>> +		if (ext4_es_is_delayed(&es)) {
>>>
>>> I understand that it is okay for us to rely on extent status ==
>>> delayed here because we never reclaim delayed es entries and hence we
>>> are sure to not skip any delayed block allocations here.
>>
>> Yeah, right.
>>
>>>
>>>> +			map->m_flags |= EXT4_MAP_DELAYED;
>>>> +			trace_ext4_da_write_pages_extent(inode, map);
>>>> +			/*
>>>> +			 * Call ext4_map_create_blocks() to allocate any
>>>> +			 * delayed allocation blocks. It is possible that
>>>> +			 * we're going to need more metadata blocks, however
>>>> +			 * we must not fail because we're in writeback and
>>>> +			 * there is nothing we can do so it might result in
>>>> +			 * data loss. So use reserved blocks to allocate
>>>> +			 * metadata if possible.
>>>> +			 */
>>>> +			map_flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
>>>> +				    EXT4_GET_BLOCKS_METADATA_NOFAIL |
>>>> +				    EXT4_EX_NOCACHE;
>>>> +
>>>> +			retval = ext4_map_create_blocks(handle, inode, map,
>>>> +							map_flags);
>>>> +			if (retval > 0)
>>>> +				ext4_fc_track_range(handle, inode, map->m_lblk,
>>>> +						map->m_lblk + map->m_len - 1);
>>>> +			goto out;
>>>> +		} else if (unlikely(ext4_es_is_hole(&es)))
>>>
>>> Now that you've fixed the partial invalidate in iomap (patch 12/23)
>>> can we still hit this hole case?
>>
>> Theoretically, no hole should be encountered; this is just defensive
>> programming.
>>
>>>
>>>> +			goto out;
>>>> +
>>>> +		/* Found written or unwritten extent. */
>>>> +		map->m_pblk = ext4_es_pblock(&es) + map->m_lblk - es.es_lblk;
>>>> +		map->m_flags = ext4_es_is_written(&es) ?
>>>> +			       EXT4_MAP_MAPPED : EXT4_MAP_UNWRITTEN;
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	retval = ext4_map_query_blocks(handle, inode, map, EXT4_EX_NOCACHE);
>>>> +out:
>>>> +	up_write(&EXT4_I(inode)->i_data_sem);
>>>> +	ext4_journal_stop(handle);
>>>> +	return retval < 0 ? retval : 0;
>>>> +}
>>>> +
>>>> +static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
>>>> +					  loff_t offset, unsigned int dirty_len)
>>>> +{
>>>> +	struct inode *inode = wpc->inode;
>>>> +	struct super_block *sb = inode->i_sb;
>>>> +	struct journal_s *journal = EXT4_SB(sb)->s_journal;
>>>> +	struct ext4_map_blocks map;
>>>> +	unsigned int blkbits = inode->i_blkbits;
>>>> +	unsigned int index = offset >> blkbits;
>>>> +	unsigned int blk_end, blk_len;
>>>> +	int ret;
>>>> +
>>>> +	ret = ext4_emergency_state(sb);
>>>> +	if (unlikely(ret))
>>>> +		return ret;
>>>> +
>>>> +	/* Check validity of the cached writeback mapping. */
>>>> +	if (offset >= wpc->iomap.offset &&
>>>> +	    offset < wpc->iomap.offset + wpc->iomap.length &&
>>>> +	    ext4_iomap_valid(inode, &wpc->iomap))
>>>> +		return 0;
>>>> +
>>>> +	blk_len = dirty_len >> blkbits;
>>>> +	blk_end = min_t(unsigned int, (wpc->wbc->range_end >> blkbits),
>>>> +				      (UINT_MAX - 1));
>>>
>>> This is an interesting idea. I'm just a bit worried when we have
>>> range_end == LLONG_MAX (bg flush) and we will always be trying to allocate
>>> MAX_WRITEPAGES, incase of a slightly fragmented FS, we might keep
>>> falling into slower mballoc criterias and might waste a lot of time
>>> scanning the groups.
>>
>> Actually, MAX_WRITEPAGES is not allocated every time; the allocated
>> length also depends on the length of data that has already been delayed
>> for writing, and the smaller value is taken. If the user has indeed
> 
> Hmm so we take the blk_end based on range_end (which is LLONG_MAX for bg
> flusher) and then our blk_len will be set accordingly and would become a
> large number as well. Then we will set map.m_len based on this blk_len
> and MAX_WRITEPAGES. Am I missing something that clamps our m_len?
> 
Please take a look at ext4_iomap_map_one_extent():

+		retval = es.es_len - (map->m_lblk - es.es_lblk);
+		map->m_len = min_t(unsigned int, retval, map->m_len);

In this case, m_len is truncated to the length of the delalloc extent.

Thanks,
Yi.

