Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACCF364926
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 12:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782131775; cv=none; b=OV4gQi4RoxhpgwEib6xBIMGaJD37D0pMHDEvNpSKOQ36YcasY79jkX1o2rb9HwK4O0D/cFm3sMZEO04/GgohYUviWIZhqYvI/A+OjSrEil2jFmZosd33N9y1PQ5ncDQurgAUrewVM7sPD+JTBWqM2UFlcZ2a/Lx5sUcCXuaQwT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782131775; c=relaxed/simple;
	bh=qpFfNufTltMsfP2kvz/WUrjlJnHsjFzZYPBymw0wZ6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EN+r6l5skBHEC0Or82acs/IgDkW08oRqpAZGASbnZiVLxZy0Dv5U2ykz9wRUz3krzBDayTz+uAKRPyOq4d2/3s3wusLtj1ebjfn5p97JihUaf/pwWk/0N6hnPd0zUeU8Sh3kDy6Rw4GgHO9nW+aWg5PMs4IyGPwYufj3CawXURA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X3IsLo01; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X3IsLo01"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84536ecfc5bso3853829b3a.2
        for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 05:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782131773; x=1782736573; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dAicUiWmcxtWfFrz7xHY4q4KbcHywjjPpdLMeuIT8f8=;
        b=X3IsLo01KXH2tXrEsbmpA1dXxpcEXIskiLzYNlKw0gaPk/s1M5otkLpH18Xp5lH2ah
         lHzg+5U0lhRLFWSE1tA0N9ffZtTLQPiMxfrIngLTJ9e94lAhOGpjEdZyXf50tqOD9Smq
         lgo+1z6NBSX0nO0Mr+sUvnGj6ShTgzwGX17C4WKDME3PtY8fy95S3h5Lk3SUt3MzCGL9
         oEue+woO/oAIvruByNwGMFnSGOmOPVdnqT022TSK2zCnLzQQ/xIl59bbkHEU/wXO2obN
         RWx+yOor8WTPdZUrYeGg/8GoRpcT6gyp868wLoRwwXmUWvp6rkzEAcsyOu5EaToRJDn9
         CzDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782131773; x=1782736573;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dAicUiWmcxtWfFrz7xHY4q4KbcHywjjPpdLMeuIT8f8=;
        b=q3pSkUFMblQrByAN+MkLOFTROAPsx/Bw0LX3znk11+z0ZWSU3qkWyUc3pveSq2tX05
         ukOlci01YEvTMFXhlh8N9EAQDIQQ9bdkbIa2tdFX3uphCJonAGoGPk2KowTSjEA6FPQK
         uNbPTIfPAGFuo4bVha5ieg1VVdsYaPX3UbnWWqKuFM8bfx+Jwl8xpFi4iwn7pnZecVzs
         JsAZgsAThKZRfExnOwUUqXkAm4zLrwyuH8qkrjoATydXJhQafQNu+fk8haDfHhgxRSeE
         SEvg7Ludh0pw5uBImAjQC2L7VvR+ODS1uvQbqGcuyArLV9FI8RlvsfjhUUJLheVviXNZ
         QTcg==
X-Gm-Message-State: AOJu0YxmGhUHEVDYkYtcsOkvD0l+/8eNvd+NJnIgx3J+WQMoTotrPQ93
	NsFccZYTmB6YFI5e5EflMYdI1E55sGWpIC0fdqIGtN3wwBfZHkLg/Gsr
X-Gm-Gg: AfdE7cliR/fR+Qgxg4pUjDZCEZfco+wI22m3Y5n2DlMfHkOL2h/iNf54kMW/BGmVFf7
	qdFH4OABYGSFmcq8kxZr4rQr4Fjk8bDpYKxX7823j4d8VzidBQIUILh7/cMShwgBjJ/ZLUe95tm
	g84tFEdJISreoZpXm7IBgkSqHrNJjvrvio8JEtBNOVbU6Viwqey1dsZN+vxbeT0lNJuH3/I0DzW
	zAjroOSSIae1xJ/u8PZq8+SgTtc871V2qnhVHeMLtZNCnJLajDp4fMjofmcZzRpWadSwMmx1bKS
	mbwFtPPEz0JYIOiszIlDzJwEZC7mrRMhAxW56mksyNTcJrBCWXPZztb9ePkoa3xUDxcaKUDsq9Y
	i/zk1AL2Rz4JZNd9mYk9WRR14mxSvqRRw8BzHB94PZBu76bMQUTRUpAjnXbpgGZ0VOojDhYjZSR
	/PG7rxGFs3w+DvURUH9AAm5MjwmgWBGBvT
X-Received: by 2002:a05:6a00:a204:b0:845:3912:dd4d with SMTP id d2e1a72fcca58-84550887f12mr15243755b3a.31.1782131772804;
        Mon, 22 Jun 2026 05:36:12 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564d8dddbsm7557367b3a.19.2026.06.22.05.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2026 05:36:11 -0700 (PDT)
Message-ID: <b0781809-4759-4e12-be17-71555b764f48@gmail.com>
Date: Mon, 22 Jun 2026 20:36:02 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/23] ext4: implement writeback path using iomap
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-10-yi.zhang@huaweicloud.com>
 <jxlc26s4ez5mug27innhntsubeddyishy7wlz6nv6dfugvz7c3@ztgmhhe2333m>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <jxlc26s4ez5mug27innhntsubeddyishy7wlz6nv6dfugvz7c3@ztgmhhe2333m>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/16/2026 7:47 PM, Jan Kara wrote:
> On Mon 11-05-26 15:23:29, Zhang Yi wrote:
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
>>
>> Key changes and considerations:
>>
>> - Append write and unwritten extents
>>    Since data=ordered mode is not used to prevent stale data exposure
>>    during append writebacks, new blocks are always allocated as unwritten
>>    extents (i.e. always enable dioread_nolock), and i_disksize update is
>>    postponed until I/O completion. Additionally, the deadlock that the
>>    reserve handle was expected to resolve does not occur anymore.
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
> 
> Ugh, this adds 48 bytes to ext4 inode. That's pretty heavy. Cannot we reuse
> i_rsv_conversion_list / work for this? For each inode only one of them
> should be used AFAICS.

Thanks for your suggestion. I think we should be able to reuse
i_rsv_conversion_list / work. We can choose the corresponding
initialization function for i_rsv_conversion_work based on the buffered
write path at initialization time, and then reinitialize the work
handler when changing the path via the ioctl that sets the journal
flag. That should be sufficient.

> 
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
>> +	if (blk_end > index + blk_len)
>> +		blk_len = blk_end - index + 1;
>> +
>> +retry:
>> +	map.m_lblk = index;
>> +	map.m_len = min_t(unsigned int, MAX_WRITEPAGES_EXTENT_LEN, blk_len);
>> +	ret = ext4_map_blocks(NULL, inode, &map,
>> +			      EXT4_GET_BLOCKS_IO_SUBMIT | EXT4_EX_NOCACHE);
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
> 
> So it looks somewhat strange that here we call ext4_map_blocks() (which
> consults extent status tree and then possibly on-disk extent tree) and then
> we call ext4_iomap_map_one_extent() which manipulates with the extent
> status tree and possibly extent tree as well. Is all this complexity to
> avoid starting a jbd2 handle unless really needed? If yes, is that really
> worth it? Given iomap code caches the extent we'd start the transaction
> only once per mapped extent which shouldn't be that bad?
> 
> If you have some benchmark showing this is really worth it,

Thanks for your suggestion. I think we should be able to reuse
i_rsv_conversion_list / work. We can choose the corresponding
initialization function for i_rsv_conversion_work based on the buffered
write path at initialization time, and then reinitialize the work
handler when changing the path via the ioctl that sets the journal
flag. That should be sufficient.


There are actually two reasons for this. First, we want to avoid
starting a journal handle in overwrite scenarios. Second, we want to
be able to query the extent locklessly without holding i_data_sem in
overwrite cases as well (note that ext4_es_lookup_extent() in
ext4_iomap_map_one_extent() is called with i_data_sem held).

I ran a set of benchmark tests in my VM, performing the following FIO
overwrite test on a 500GB ramdisk:

$fio -filename=/test_dir/foo -direct=0 -iodepth=8 -fsync=0 -rw=write \
            -numjobs=1 -bs=4k -ioengine=io_uring -size=20G -uncached=1 \
            -runtime=30 --ramp_time=5s -time_based -norandommap=0 \
            -fallocate=none -overwrite=1 \
            -group_reportin -name=test --output=/tmp/log

The results are as follows:

a: on a non-fragmented file
A: on a fragmented file [1]
b: no background metadata pressure
B: with background metadata pressure [2]

      buffer_head | iomap pre-map w/o journal | iomap directly map
a+b:    680                 691                   690
a+B:    560                 568                   567
A+b:    637                 633                   579
A+B:    540                 571                   495

[1] The file is pre-fragmented such that each block occupies a separate
     extent.
[2] A background fsstress process is running (only contains metadata
     ops):
     taskset -c 2 fsstress -c -d /test_dir -l 0 -n 1000 -f clonerange=0 \
             -f copyrange=0 -f awrite=0 -f aread=0 -f dread=0 \
             -f dwrite=0 -f mread=0 -f mwrite=0 -f readv=0 -f write=0 \
             -f writev=0 -f read=0 -f sync=0 -f afsync=0 -f fsync=0

As can be seen, for large contiguous files, the performance impact is
minimal. However, in heavily fragmented scenarios or under other
metadata pressure, pre-querying the mapping brings noticeable gains.
However, this is testing the most extreme case — I'm not sure about
the real-world impact, so I don't have a strong preference either way.
But I suppose faster is better, at least not slower than the old
buffer_head path. :)

> then I'd
> probably prefer coming up with an ext4_get_blocks flag which tells it to
> start a transaction on its own if we need to allocate blocks... That would
> be much simpler than opencoding all this.

Additionally, there is a key point here. The reason I open-coded
ext4_iomap_map_writeback_range() is that we must ensure extent query
and allocation are performed atomically under i_data_sem. Otherwise,
concurrent truncate could lead to quota leaks.

Specifically, consider the following scenario: we call
ext4_map_blocks() to allocate blocks. Suppose there is a delalloc
extent covering blocks [0,3). While writeback is submitting block 0, a
concurrent truncate(block 1) occurs:

wb                         truncate
ext4_es_lookup_extent()    ext4_truncate_down()
   //get [0,3)
                             truncate_inode_pages_range()
                                //clear page 1&2
                             ext4_truncate()
                              down_write(i_data_sem)
                               ext4_es_remove_extent()
                                //drop extent [1,3)
                                //i_reserved_data_blocks: 3->1
                               up_write(i_data_sem)
down_write(i_data_sem)
ext4_map_create_blocks()
   //alloc 3 blocks
  ext4_es_insert_extent()
   //only reclaim 1 block，stale 2 blocks
up_write(i_data_sem)

Therefore, If we don't open-coding this part, we would need to
significantly rework ext4_map_blocks(), which might have a larger
impact at this point. What do you think?

> 
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
> ...
> 
>> +void ext4_iomap_end_bio(struct bio *bio)
>> +{
>> +	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
>> +	struct inode *inode = ioend->io_inode;
>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>> +	unsigned long flags;
>> +
>> +	/* Needs to convert unwritten extents or update the i_disksize. */
>> +	if ((ioend->io_flags & IOMAP_IOEND_UNWRITTEN) ||
>> +	    ioend->io_offset + ioend->io_size > READ_ONCE(ei->i_disksize))
>> +		goto defer;
>> +
>> +	/* Needs to abort the journal on data_err=abort.  */
>> +	if (unlikely(ioend->io_bio.bi_status))
>> +		goto defer;
>> +
>> +	iomap_finish_ioend(ioend, 0);
>> +	return;
>> +defer:
>> +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>> +	if (list_empty(&ei->i_iomap_ioend_list))
>> +		queue_work(sbi->rsv_conversion_wq, &ei->i_iomap_ioend_work);
>> +	list_add_tail(&ioend->io_list, &ei->i_iomap_ioend_list);
>> +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>> +}
> 
> For now, I'd prefer to do what XFS does and offload everything. Then you
> don't have to export iomap_finish_ioend() (which would need to be in a
> separate patch and acked by iomap maintainers) and the code is more
> standard. There's a patchset in the works which adds general ioend offloading
> infrastructure into iomap [1] and when that lands we should get all these
                       ^^^^^ block layer?

> bells and whistles (even better ones with percpu work queues, batching,
> etc.) for free.
> 
> [1] https://lore.kernel.org/all/20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu/
> 
> 								Honza

Ha, I've noticed this patchset, so I haven't implemented
uncached I/O handling for now. As a side note, I have a question:
if we convert all endio processing to worker threads, IIRC, my
recollection from previous performance tests is that pure overwrite
scenarios would see at least a 20% degradation. Is that acceptable?

I understand why uncached I/O might need the entire completion path
in a worker, but can we complete the I/O in interrupt context for
pure overwrite and then release the page cache in a worker? Must
page cache invalidation and I/O completion be synchronous?

The reason I kept ext4_iomap_end_bio() handling I/O completion in
interrupt context is for overwrite performance. XFS also handles
overwrites in interrupt context (via ioend_writeback_end_bio()).
However, ext4 has the data_error=abort mount option — when this mode
is set and an I/O error occurs, we must abort the journal in a
worker. Since we cannot predict I/O errors at submission time, we
can't directly use ioend_writeback_end_bio() and must instead bind
our own ext4_iomap_end_bio(). At the same time, I want to avoid
spawning a worker for pure overwrites when no I/O error occurs, so I
exported iomap_finish_ioend(). What do you think?

Thanks,
Yi.

