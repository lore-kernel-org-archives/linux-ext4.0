Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A0E1940B0
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780063940; cv=none; b=A+HrTVq4oiWXrsmlxFdlYyByyO2OyRPTE0SiCk732V4a8y5u492U8B1H/A7lIKOp/wEUnPdd1sbBq5no9w1Z0WLTvAZDx0d3CKN6aaczQKWwNaxcAX+fLsIdav0BVZt4ao4CHRWcy9k/Ben2SBuWJrlWZETMZGplxA+1yuESJ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780063940; c=relaxed/simple;
	bh=NRtgKlLwC2XEPo/n9hVMr6Bp1BPKeoqH+gCzzU1cOKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uquLH3I1G/nK2FzeyvLA6LFIB1VdWU0SZBkrhVCoPcguqoTdcdp/SF43rc64QslVEvw+djAxaWz5bK8M3jHxYPbE0UPetEv1ZMQKxWXmiGB/kZnpCuSzqK8+Tm+pQ76G6YaWI2yMUu182lV9BBGh+C/7CyZ+Ch2J467UmnkyYJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=efu7M7RF; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="efu7M7RF"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36bba9a1089so564196a91.3
        for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 07:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780063938; x=1780668738; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RRnTfBH9bYTxNsieG48Nyv91JQy6+LpC3fmsGgDXrrU=;
        b=efu7M7RFjjKxbzK1WOu+XInuUKEMMvPeEV0JB5Im/1E7R23OVZRCScmnZR99tygDH9
         tItbSKm0TtsSzai7v1UecT7UOsQDtlgU4Fo0179Z2G4uckzYvEll/h7Eyb3q/cGOs1DN
         AlVO+mhf0mwJ64qGmsKtpBX6gEKNUiHbF+nKwThdYZwq0kbnBRzV7EWqM/8nFJjXcTk4
         clGuj4dBusNIcOEeZ16HKFJTE+6C0okkp7HP2Mt1wftWr86J/jG3DB7P+SaofCiemwH/
         /WpnlERrg/UarTST/TyS8t4RZh8e8Hh1JbvbMnHyK9/DUX1gP149TdnSRHlbHwxLQrFJ
         njQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780063938; x=1780668738;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RRnTfBH9bYTxNsieG48Nyv91JQy6+LpC3fmsGgDXrrU=;
        b=hhts1yf5g3/UOL9VGYWuR8FPEeuOVR834HVfnw4aX+1TSwSbQJ6j5kd+TbaFj/wsHa
         rkowE+tlm3NnObEBW7tm7ebLIzp4XB6FTbU2Y7BTCpu3ACTfDkjHduejiGmWT3uvo0lK
         dfoCFAJPOL3JdeFHb5NV7grkbFqJ7gstM7iq9YpafUHOI3kwrGIwWyrWkbmkKbOsvsex
         rVa7dCtuoK49FF/5Xu/UsMGHMRUqqeLDJXLUrCtOuTkDgPG17Bmm4ehNAnndrtZdpIJO
         qDGDcDjPId2iBMI4hUWwRFaL0Uj0oWUALVYOvc+9YjcosIr9nkXTglYcnmYQ8m9DpPhl
         g8uQ==
X-Gm-Message-State: AOJu0YwVbW6mmZGXfyHUCwknJAqk+h77derDAKDVy+hQmjLEXBbxnKR0
	YUx/V2gMgRAUcIEFfip6qCkkdVCrI1cHYDLIb9snukiyrQFyqObn6/LYV5iBMe86zmE=
X-Gm-Gg: Acq92OE1ayRtkGk4FPgrqtMDvyiIrekVZ0X2Pt4Br/0Uk2DdctknzuAo0+LkxA8S32q
	ClgMpbJQNgrZqICmi51kVdarD7JQtka8M9lD6SFjVYsUy1B1L3j27aCTLLfwwBKzaUzhzh2YOQi
	NulkGTXdlwi8dhQuiqQyD8hepx5Go9ej/sKj8HEVJk3THnhpU5ulKp0wG3PWwWhbpo0MqC98eiC
	dduW5p/8/c3q/4gYI/RnNuNdFwLQzsH+jKi7UVmZmRbdUB1PNhYQ0jvAu80p43DrV7dK2PFnqNI
	uHJ21Z5RyLokwFPacWEdrhB/h0j5g9RtBtrcf/FsAsSCsKeObFo/uXlFjJzFpipBn2biava3dju
	N/6VRa+lIO2OY1RWbDYBsZOMIZJAjTgf5+u0Kt1gG+D1K7vSCgCzY5WFkYA95hHiLPgTD8b3eIW
	SaSAoUvVW06YkJ9K0o2Bj/q407y7BU8eaMiDwWiszku4O4U2turpswPyCzAUUFcrO88leqDNYu+
	Kt2rfM=
X-Received: by 2002:a17:90b:3dc4:b0:36b:9faf:8396 with SMTP id 98e67ed59e1d1-36bbcd407demr3603647a91.11.1780063937900;
        Fri, 29 May 2026 07:12:17 -0700 (PDT)
Received: from ?IPV6:240e:390:a90:671:f49e:f306:1054:8e7? ([240e:390:a90:671:f49e:f306:1054:8e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc6b7c178sm2048091a91.15.2026.05.29.07.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 07:12:17 -0700 (PDT)
Message-ID: <458bda7a-c3c6-4cb3-9c05-0718cf2ef95f@gmail.com>
Date: Fri, 29 May 2026 22:12:12 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/23] ext4: implement writeback path using iomap
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-10-yi.zhang@huaweicloud.com>
 <ahboWtDYXagrgTR4@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <ahboWtDYXagrgTR4@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Ojaswin!

On 5/27/2026 8:49 PM, Ojaswin Mujoo wrote:
> On Mon, May 11, 2026 at 03:23:29PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Add the iomap writeback path for ext4 buffered I/O. This introduces:
>>
>>   - ext4_iomap_writepages(): the main writeback entry point.
>>   - ext4_writeback_ops: a new iomap_writeback_ops instance to handle
>>     block mapping and I/O submission.
>>   - A new end I/O worker for converting unwritten extents, updating file
>>     size, and handling DATA_ERR_ABORT after I/O completion.
>>
>> Core implementation details:
>>
>>   - ->writeback_range() callback
>>     Calls ext4_iomap_map_writeback_range() to query the longest range of
>>     existing mapped extents. For performance, when a block range is not
>>     yet allocated, it allocates based on the writeback length and delalloc
>>     extent length, rather than allocating for a single folio at a time.
>>     The folio is then added to an iomap_ioend instance.
>>
>>   - ->writeback_submit() callback
>>     Registers ext4_iomap_end_bio() as the end bio callback. This callback
>>     schedules a worker to handle:
>>     - Unwritten extent conversion.
>>     - i_disksize update after data is written back.
>>     - Journal abort on writeback I/O failure.
> 
> Hi Zhang, the changes look good. I have a few comments below:
>>
>> Key changes and considerations:
>>
>> - Append write and unwritten extents
>>    Since data=ordered mode is not used to prevent stale data exposure
>>    during append writebacks, new blocks are always allocated as unwritten
>>    extents (i.e. always enable dioread_nolock), and i_disksize update is
>>    postponed until I/O completion.
> 
> Makes sense.
> 
>>    Additionally, the deadlock that the
>>    reserve handle was expected to resolve does not occur anymore.
> 
> I guess this is since we don't use ordered data so we can't block on
> starting a txn in end io.

Yep.

> 
>>    Therefore, the end I/O worker can start a normal journal handle
>>    instead of a reserve handle when converting unwritten extents.
>>
>> - Lock ordering
>>    The ->writeback_range() callback runs under the folio lock, requiring
>>    the journal handle to be started under that same lock. This reverses
>>    the order compared to the buffer_head writeback path. The lock ordering
>>    documentation in super.c has been updated accordingly.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>   fs/ext4/ext4.h        |   4 +
>>   fs/ext4/inode.c       | 208 +++++++++++++++++++++++++++++++++++++++++-
>>   fs/ext4/page-io.c     | 126 +++++++++++++++++++++++++
>>   fs/ext4/super.c       |   7 +-
>>   fs/iomap/ioend.c      |   3 +-
>>   include/linux/iomap.h |   1 +
>>   6 files changed, 346 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 4832e7f7db82..078feda47e36 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1173,6 +1173,8 @@ struct ext4_inode_info {
>>   	 */
>>   	struct list_head i_rsv_conversion_list;
>>   	struct work_struct i_rsv_conversion_work;
>> +	struct list_head i_iomap_ioend_list;
>> +	struct work_struct i_iomap_ioend_work;
>>   
>>   	/*
>>   	 * Transactions that contain inode's metadata needed to complete
>> @@ -3870,6 +3872,8 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *page,
>>   		size_t len);
>>   extern struct ext4_io_end_vec *ext4_alloc_io_end_vec(ext4_io_end_t *io_end);
>>   extern struct ext4_io_end_vec *ext4_last_io_end_vec(ext4_io_end_t *io_end);
>> +extern void ext4_iomap_end_io(struct work_struct *work);
>> +extern void ext4_iomap_end_bio(struct bio *bio);
>>   
>>   /* mmp.c */
>>   extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 1ae7d3f4a1c8..a80195bd6f20 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -44,6 +44,7 @@
>>   #include <linux/iversion.h>
>>   
>>   #include "ext4_jbd2.h"
>> +#include "ext4_extents.h"
>>   #include "xattr.h"
>>   #include "acl.h"
>>   #include "truncate.h"
>> @@ -4120,10 +4121,215 @@ static void ext4_iomap_readahead(struct readahead_control *rac)
>>   	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
>>   }
>>   
>> +static int ext4_iomap_map_one_extent(struct inode *inode,
>> +				     struct ext4_map_blocks *map)
>> +{
>> +	struct extent_status es;
>> +	handle_t *handle = NULL;
>> +	int credits, map_flags;
>> +	int retval;
>> +
>> +	credits = ext4_chunk_trans_blocks(inode, map->m_len);
>> +	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, credits);
>> +	if (IS_ERR(handle))
>> +		return PTR_ERR(handle);
>> +
>> +	map->m_flags = 0;
>> +	/*
>> +	 * It is necessary to look up extent and map blocks under i_data_sem
>> +	 * in write mode, otherwise, the delalloc extent may become stale
>> +	 * during concurrent truncate operations.
>> +	 */
>> +	ext4_fc_track_inode(handle, inode);
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>> +		retval = es.es_len - (map->m_lblk - es.es_lblk);
>> +		map->m_len = min_t(unsigned int, retval, map->m_len);
>> +
>> +		if (ext4_es_is_delayed(&es)) {
> 
> I understand that it is okay for us to rely on extent status ==
> delayed here because we never reclaim delayed es entries and hence we
> are sure to not skip any delayed block allocations here.

Yeah, right.

> 
>> +			map->m_flags |= EXT4_MAP_DELAYED;
>> +			trace_ext4_da_write_pages_extent(inode, map);
>> +			/*
>> +			 * Call ext4_map_create_blocks() to allocate any
>> +			 * delayed allocation blocks. It is possible that
>> +			 * we're going to need more metadata blocks, however
>> +			 * we must not fail because we're in writeback and
>> +			 * there is nothing we can do so it might result in
>> +			 * data loss. So use reserved blocks to allocate
>> +			 * metadata if possible.
>> +			 */
>> +			map_flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
>> +				    EXT4_GET_BLOCKS_METADATA_NOFAIL |
>> +				    EXT4_EX_NOCACHE;
>> +
>> +			retval = ext4_map_create_blocks(handle, inode, map,
>> +							map_flags);
>> +			if (retval > 0)
>> +				ext4_fc_track_range(handle, inode, map->m_lblk,
>> +						map->m_lblk + map->m_len - 1);
>> +			goto out;
>> +		} else if (unlikely(ext4_es_is_hole(&es)))
> 
> Now that you've fixed the partial invalidate in iomap (patch 12/23)
> can we still hit this hole case?

Theoretically, no hole should be encountered; this is just defensive
programming.

> 
>> +			goto out;
>> +
>> +		/* Found written or unwritten extent. */
>> +		map->m_pblk = ext4_es_pblock(&es) + map->m_lblk - es.es_lblk;
>> +		map->m_flags = ext4_es_is_written(&es) ?
>> +			       EXT4_MAP_MAPPED : EXT4_MAP_UNWRITTEN;
>> +		goto out;
>> +	}
>> +
>> +	retval = ext4_map_query_blocks(handle, inode, map, EXT4_EX_NOCACHE);
>> +out:
>> +	up_write(&EXT4_I(inode)->i_data_sem);
>> +	ext4_journal_stop(handle);
>> +	return retval < 0 ? retval : 0;
>> +}
>> +
>> +static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
>> +					  loff_t offset, unsigned int dirty_len)
>> +{
>> +	struct inode *inode = wpc->inode;
>> +	struct super_block *sb = inode->i_sb;
>> +	struct journal_s *journal = EXT4_SB(sb)->s_journal;
>> +	struct ext4_map_blocks map;
>> +	unsigned int blkbits = inode->i_blkbits;
>> +	unsigned int index = offset >> blkbits;
>> +	unsigned int blk_end, blk_len;
>> +	int ret;
>> +
>> +	ret = ext4_emergency_state(sb);
>> +	if (unlikely(ret))
>> +		return ret;
>> +
>> +	/* Check validity of the cached writeback mapping. */
>> +	if (offset >= wpc->iomap.offset &&
>> +	    offset < wpc->iomap.offset + wpc->iomap.length &&
>> +	    ext4_iomap_valid(inode, &wpc->iomap))
>> +		return 0;
>> +
>> +	blk_len = dirty_len >> blkbits;
>> +	blk_end = min_t(unsigned int, (wpc->wbc->range_end >> blkbits),
>> +				      (UINT_MAX - 1));
> 
> This is an interesting idea. I'm just a bit worried when we have
> range_end == LLONG_MAX (bg flush) and we will always be trying to allocate
> MAX_WRITEPAGES, incase of a slightly fragmented FS, we might keep
> falling into slower mballoc criterias and might waste a lot of time
> scanning the groups.

Actually, MAX_WRITEPAGES is not allocated every time; the allocated
length also depends on the length of data that has already been delayed
for writing, and the smaller value is taken. If the user has indeed
performed delalloc writes on data of up to MAX_WRITEPAGES in length,
then regardless of how fragmented the file system is, I will need to
allocate blocks of that length. Reducing the number of calls is always
beneficial.

> 
>> +	if (blk_end > index + blk_len)
>> +		blk_len = blk_end - index + 1;
>> +
>> +retry:
>> +	map.m_lblk = index;
>> +	map.m_len = min_t(unsigned int, MAX_WRITEPAGES_EXTENT_LEN, blk_len);
>> +	ret = ext4_map_blocks(NULL, inode, &map,
>> +			      EXT4_GET_BLOCKS_IO_SUBMIT | EXT4_EX_NOCACHE);
> 
> Do we really need the IO_SUBMIT flag here now that we are:
> 1. Not using ordered data
> 2. We anyways don't use it in ext4_iomap_map_one_extent().
> 
> I think we can drop it.

We can't drop it, because IO_SUBMIT is also used to avoid the check of
ext4_check_map_extents_env() in ext4_map_blocks() under the writeback
path.

Cheers,
Yi.

> 
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/*
>> +	 * The map is not a delalloc extent, it must either be a hole
>> +	 * or an extent which have already been allocated.
>> +	 */
>> +	if (!(map.m_flags & EXT4_MAP_DELAYED))
>> +		goto out;
>> +
>> +	/* Map one delalloc extent. */
>> +	ret = ext4_iomap_map_one_extent(inode, &map);
>> +	if (ret < 0) {
>> +		if (ext4_emergency_state(sb))
>> +			return ret;
>> +
>> +		/*
>> +		 * Retry transient ENOSPC errors, if
>> +		 * ext4_count_free_blocks() is non-zero, a commit
>> +		 * should free up blocks.
>> +		 */
>> +		if (ret == -ENOSPC && journal && ext4_count_free_clusters(sb)) {
>> +			jbd2_journal_force_commit_nested(journal);
>> +			goto retry;
>> +		}
>> +
>> +		ext4_msg(sb, KERN_CRIT,
>> +			 "Delayed block allocation failed for inode %llu at logical offset %llu with max blocks %u with error %d",
>> +			 inode->i_ino, (unsigned long long)map.m_lblk,
>> +			 (unsigned int)map.m_len, -ret);
>> +		ext4_msg(sb, KERN_CRIT,
>> +			 "This should not happen!! Data will be lost\n");
>> +		if (ret == -ENOSPC)
>> +			ext4_print_free_blocks(inode);
>> +		return ret;
>> +	}
>> +out:
>> +	ext4_set_iomap(inode, &wpc->iomap, &map, offset, dirty_len, 0);
>> +	return 0;
>> +}
>> +
> 
> <snip>
>>

