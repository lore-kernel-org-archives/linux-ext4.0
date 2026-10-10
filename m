Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A1D3A7198
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791647712; cv=none; b=s0MDxlVBozJqx/uJF8YzFi2Vvncjk/8nxqfd3mPDTyzh/M94rxupYzdWsjSx12Emq5i3yRpE1ilbyolky73r2zWyIK71p9TRi5qOu8JImYvbWXqopAeHkjrH8GUi3LLq6s+JyvF/YjDpqJNfDzqOVa1y8779w+G9lIZ+Zyz8tr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791647712; c=relaxed/simple;
	bh=550w9HxtBJ70+OSTHJKOYNkuO93b0kmBeIXKsY4Wz7Q=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=I+cGlxpsC53i2IzwiGc3Wend5YnsSlBAjbddQGZs7hzDAwkNiXfW2Bom7ZHysBN53J6Vp7nbVPX6tpBKg5JIA7MZVAa7BUQ7SmE0A3aSguyubXhusyAAbJF6sLGdXjBbDuWTAcs0JZVB/N6TqVlcO/+v7zWBlAjl0yH3+aByybE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mzhh3hL9; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mzhh3hL9"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-868b3248b2cso471615b3a.1
        for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 08:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791647710; x=1792252510; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mhz3wG+iTt4sW6pevejhtNF0mBYASzNz6Ik75+/g+Dg=;
        b=mzhh3hL97Nv9jdFdFZd+eqaIELFXIYZfXog3P/yvrR0jdTaEpRijX+J9chAptKgWon
         6RPT/RFnZtJsaF4J8CkIL2g5FwHD27B1oW7qCds/cL+wffm14oIyeh92Rk8KucNH6M4y
         u65vLjDPmKjmr8P6v87+5j5t4D7K+UB0w0hDACtU5CrbW9kQKBpwt2ps+3U6VGxg5HP8
         brGH6RtTCM5fKch+A2odBB8l9lx2s/3LKJ1WdkjAwYVckQyJWl7lKvuxZxpPE+CZ/ie2
         j2715vqyBF5kzuprgojZiOPnddFtXu51PBrYDzf6O3ExGL9X3V5IzULEKR4TkTADPcQo
         KFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791647710; x=1792252510;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mhz3wG+iTt4sW6pevejhtNF0mBYASzNz6Ik75+/g+Dg=;
        b=vEmU5QXXGSB9T2j8rbxUJoMbzZIX+rwqcsBahA6m6gRdaNEnSWx/evyw1KjTD1OyDl
         iRW6V+6J61cORSHC8kECgzIq+iBo7hCzDp5uWIIdEGLerg33lqQEnXZC5+VRJ1eHoVpA
         LHaYS+WOgBV7RQ1sjJMW+VwyFiJshoGhAsqsqVf3hTLoJPJqw5dAgmHxYamVjhJwGoDP
         YCEJ3nSLX1TaIga0To5CemBKl6yJSziW+/V4rR+00yST3BegTHkklvRNRnGCzQ8oBaPs
         pSXXaxv9m8fG4hKNjjlaQm2KOfWQ283S999QwJhwuot2dxvgSxskTLpb3XIGFWEbE/Hh
         77JA==
X-Forwarded-Encrypted: i=1; AKwUvBysVXNePpeUYW/DSCCO9L9FD7zuCizZyYvZUUNvHbHXYzozf/wIjVftls4kFOUnTymzeUiXCTID2naw@vger.kernel.org
X-Gm-Message-State: AFq9FYLUADHgyecuP3P1qJBm827rwzyq804EE0HW1FcrmUECNK9uFGG+
	yCxDJ4y+sZEIgi7xgWyxlL0lcMhwbm+m+QklpXxt7bGzFcK1LgHHgArQ
X-Gm-Gg: AYBFou0ycsRNjEFHj5E6grbVMtZZ3UwfKpbUCchUvK/KMgygfCaSwjRBMuluByQhr+f
	drKvLPtrbf7DRXamAIygWNemVOW9W0d+dwiDXwxSmssiem0Pyg6t44C81iBM89v2orlg3A66syA
	/Qj8RAkMavHPtXHc5r3TS4zzFFgcI7MyerdzC7LRfxPB4BZazxaGHAcq6X2UTPh6f+9jjlqdBuS
	+HqLaJL8/rCOYYeWiUiAd40UYI/VdNLlKDC7Hrilzl+QEVTi7U2v/eB20GpGY9BPiFia7OrCsWt
	bJVy+wR+j9FH3UUXKWR/LubjwMTEhe1SUxPbH8KfpchkthJHQYlQ1Uwo7YGbwZUc+4/kQzhzPPX
	UIW91YEFi+wM4+5fZ8KGv8AicVZhd5RYkGMGB6iNnI6u2CviqpyGgYRrtpmMhHOj3gAbNsJ1UYz
	t4CZUxyFzflGb8Dt+UGdwNBr9YbxoMV48lBNtQ753XVkgvBz116nw4Wy5mDzRlGPwEou/xifq0v
	lRxvfGWRmgMCOQv975inH0wCuiJ5w==
X-Received: by 2002:a05:6a00:f94:b0:880:74b9:dd07 with SMTP id d2e1a72fcca58-897c8d80f39mr4337494b3a.57.1791647709583;
        Sat, 10 Oct 2026 08:55:09 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89805c75343sm1986671b3a.38.2026.10.10.08.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2026 08:55:09 -0700 (PDT)
Message-ID: <bf9a1b23-0473-4623-952b-b3a407e9b7a3@gmail.com>
Date: Sat, 10 Oct 2026 23:54:57 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Zhang Yi <yizhang089@gmail.com>
Subject: Re: [PATCH v7 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing
 unaligned EOF block
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org,
 yi.zhang@huawei.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
 wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-28-yi.zhang@huaweicloud.com>
 <asn-qfh9uWnabkJb@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <2fb2df2f-090c-4b24-9636-d28454a51d1d@gmail.com>
 <aspCa7EpqXoEhuN6@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
In-Reply-To: <aspCa7EpqXoEhuN6@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/2026 9:49 PM, Ojaswin Mujoo wrote:
> On Sat, Oct 10, 2026 at 05:50:24PM +0800, Zhang Yi wrote:
>> On 10/10/2026 5:00 PM, Ojaswin Mujoo wrote:
>>> On Fri, Oct 09, 2026 at 06:30:28PM +0800, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> In the iomap buffered I/O path, data=ordered mode is not used, so the
>>>> zeroed EOF block has no implicit ordering with later i_disksize updates.
>>>> Without the pending state being set, i_disksize can be advanced past the
>>>> zeroed block before writeback completes, exposing stale data after a
>>>> crash.
>>>>
>>>> Previous patches added the consumer side of the
>>>> disksize-grow-pending mechanism: the state bit, clear and wait helpers,
>>>> and ioend tagging. Now add ext4_iomap_mark_disksize_pending() and call
>>>> it from ext4_block_zero_eof() after zeroing the tail of the block that
>>>> straddles i_disksize.
>>>>
>>>> The helper locks the folio, waits for any in-flight writeback on it to
>>>> complete, then sets EXT4_STATE_DISKSIZE_GROW_PENDING only if the folio
>>>> is still dirty. Waiting for writeback prevents folio_test_dirty() from
>>>> returning false mid-writeback, which would cause us to skip the pending
>>>> state while zeroed data is still in flight. The dirty check then avoids
>>>> setting the bit when the data has already been written back.
>>>>
>>>> Suggested-by: Jan Kara <jack@suse.cz>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> ---
>>>>    fs/ext4/inode.c | 106 ++++++++++++++++++++++++++++++++++++++++++------
>>>>    1 file changed, 94 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index 9b6916609000c..3bdb5f3b119ab 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -4847,6 +4847,89 @@ static int ext4_block_zero_range(struct inode *inode,
>>>>    					zero_written);
>>>>    }
>>>> +/*
>>>> + * Inodes using the iomap buffered I/O path do not use data=ordered mode.
>>>> + * Therefore, we mark the inode as disksize-grow-pending after zeroing the
>>>> + * EOF block. The zeroed block will be submitted before any subsequent
>>>> + * data.
>>>> + *
>>>> + * In the I/O completion path, ext4_iomap_wb_disksize_pending_wait() will
>>>> + * wait for I/O completion before advancing i_disksize if the write
>>>> + * extends beyond the zeroed boundary.
>>>> + *
>>>> + * When zeroed I/O is in progress, operations that extend i_disksize are
>>>> + * handled as follows:
>>>> + *
>>>> + *  - Truncate up, append fallocate and zero_range:
>>>> + *    Defer the update. The file size will be updated to i_size by the
>>>> + *    end_io handler once the ongoing pending I/O completes.
>>>> + *
>>>> + *  - Insert range and collapse range operations:
>>>> + *    Wait synchronously for the relevant I/O to complete before updating
>>>> + *    i_disksize.
>>>> + */
>>>> +static int ext4_iomap_mark_disksize_pending(struct inode *inode, loff_t from)
>>>> +{
>>>> +	struct folio *folio;
>>>> +
>>>> +	folio = filemap_lock_folio(inode->i_mapping, from >> PAGE_SHIFT);
>>>> +	if (IS_ERR(folio))
>>>> +		/* Already in writeback and cleared? */
>>>> +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
>>>> +
>>>> +	/*
>>>> +	 * Ensure that in-flight writeback, possibly started after
>>>> +	 * iomap_zero_range() unlocked the folio, has completed. Without
>>>> +	 * this wait folio_test_dirty() below may miss the zeroed data
>>>> +	 * (writeback clears PG_dirty), causing us to skip the
>>>> +	 * disksize-grow-pending tracking and potentially expose stale
>>>> +	 * on-disk data.
>>>> +	 */
>>>> +	folio_wait_writeback(folio);
>>>> +	WARN_ON_ONCE(folio_test_writeback(folio));
>>>> +
>>>> +	/*
>>>> +	 * If the zeroed range does not overlap the existing on-disk tail
>>>> +	 * block, the zeroed data lies beyond the currently on-disk data
>>>> +	 * and will be written back before i_disksize is advanced past it,
>>>> +	 * so no stale data can be exposed.
>>>> +	 *
>>>> +	 * Checking i_disksize here (after folio_wait_writeback()) is
>>>> +	 * necessary and safe. If a delalloc writeback of this folio was
>>>> +	 * in-flight, it could be raced by a concurrent mmap write which
>>>> +	 * corrupts the tail block beyond i_size but the i_disksize is not
>>>> +	 * advanced. folio_wait_writeback() has waited for its completion
>>>> +	 * and the ioend has advanced i_disksize accordingly. If writeback
>>>> +	 * had not started, we don't need to mark any pending state because
>>>> +	 * any future writeback will carry the pagecache content that now
>>>> +	 * includes the zeroed data, so no stale data can appear on disk
>>>> +	 * even without the pending tracking.
>>>> +	 */
>>>
>>> Hey Zhang,
>>>
>>> So in continuation for our discussion at [1], thanks for the info and
>>> yes I think the race mentioned there cannot happen. But I was still
>>> trying to look at this path for my own understanding and there's another
>>> sequence of events I'd like to discuss with you. Mostly the same from
>>> last but what if the writeback moves after
>>> ext4_iomap_makr_zero_pending():
>>>
>>>       Initial state: i_size = i_disksize = 2k
>>>
>>>       1. pwrite(4k,6k)
>>>         - ext4_block_zero_eof(2k,4k)
>>>             set inode state DISK_SIZE_GROW_PENDING
>>>         - i_size=6k, i_disksize=2k
>>>       2. writeback(2k,4k)
>>>         - submits a GROW_IO ioend for 0,4k
>>>         - i_size=6k, i_disksize=2k (unchanged)
>>>       3. pwrite(8k,10k) - part 1
>>>         - ext4_block_zero_eof(6k,8k)
>>>         - zeroes 6k,8k
>>>         - ext4_iomap_mark_zero_pending(from=6k)
>>>           - folio is unlocked and not under writeback yet
>>>           - keeps DISK_SIZE_GROW_PENDING set
>>>         - iomap_write_iter not called yet...
>>>       4. mmap write at (6k,8k)
>>>         - I dont see anything stopping this?
>>>         - i_size is still 6k so this is eof write.
>>>       5. writeback(4k,6k)
>>>         - submits IO for 4k,8k
>>>         - i_size=6k, i_disksize=2k (unchanged)
>>>       6. ioend for 2. (2k,4k)
>>>         - clears DISKSIZE_GROW_PENDING
>>>         - GROW_IO so i_disksize updated
>>>         - i_size=6k, i_disksize=6k
>>>       7. ioend for 5. (4k,8k)
>>>         - DISKSIZE_GROW_PENDING is cleared
>>>         - i_disksize=6k,i_size=6k - no updates
>>>         - 4k,8k converted written - data beyond EOF from 4.
>>>       8. 3. continues
>>>         - enter iomap_write_iter
>>>         - pagecache_i_size_extended()
>>>           - page_mkwrite(6k folio) and mark dirty
>>>           - zero 6k,8k
>>>         - i_size=10k, i_disksize=6k
>>>       9. writeback(8k,10k)
>>>         - DISKSIZE_GROW_PENDING cleared so just submit (8k,10k)
>>>       10. ioend for 8.
>>>         - DISKSIZE_GROW_PENDING cleared so no waiting
>>>         - i_size=10k, i_disksize=10k - updated
>>>         - if we crash now, 6k,8k non-zero data exposed
>>>
>>> I looked at the code surrounding ext4_iomap_mkwrite() and
>>> ext4_buffered_write_iter() and I don't think there's any sort of
>>> serialization against this sequence right? Or am I missing something
>>> again :)
>>>
>>
>> Hi Ojaswin,
>>
>> If I understand correctly, your scenario is essentially a concurrent
>> mmap write and append write, that is, a post-EOF mmap write is performed
>> after the append write does the EOF zeroing but before i_size is
>> advanced, right?
>>
>> The scenario can be simplified as follows:
>>
>>    Initial state: i_size = i_disksize = 2k
>>
>>    1. pwrite (4k,6k)
>>      - ext4_block_zero_eof(2k,4k), zero 2k,4k and dirty folio
>>      - iomap_write_iter not called yet... so i_size is still 2k
>>    2. mmap write at (2k,4k)
>>      - i_size is still 2k (so this is still an EOF write?)
>>    3. writeback (0,4k) since it's dirty
>>      - submits I/O for (0,4k), data is written to disk
>>    4. 1 continue and then writeback
>>      - i_size=6k
>>      - submits I/O for (4,8k)
>>      - i_disksize=6k, 2k,4k non-zero data exposed
> 
> Yep, looks right.
>>
>> Actually, I think we don't need to consider this kind of concurrent
>> scenario, since it is undefined behavior in itself. Even if we
>> don't write this part of the mmap data back to disk, we can still
> 
> It will be zeroed again when i_size grows in iomap_write_iter()
> -> pagecache_isize_extended() but yeah a mapped reader might be able to
> read it before that happens.

In fact, for our current scenario, pagecache_isize_extended() is a
no-op, since blocksize equals PAGE_SIZE, so it will no longer zero out
the post-EOF data written by mmap. What pagecache_isize_extended()
zeroes is the data in the folio that doesn't belong to the block
containing the current EOF when blocksize is smaller than folio size,
whereas ext4_block_zero_eof() zeroes the post-EOF part inside the tail
block. Their responsibilities are not the same.

So in the scenario you describe, the data written by mmap will remain in
memory for a long time, and this is not a small window. Since we don't
care about this concurrent scenario, puting ext4_block_zero_eof() before
the write is safe.

Cheers,
Yi.

> 
>> read it from memory, right? What ext4_block_zero_eof() needs to do
>> is zero out the post-EOF stale data written by the mmap before the
>> append write.
> 
> Okay got it so we care more about not exposing data that was
> previously on disk rather than a race with mmap. We do have some
> xfstests that seem to care about the later as well (like generic/363)
> but I get that the race is a very small window here and needs us to
> crash at a specific time. Plus its a parallel mmap written data rather
> than stale data so hopefully it's harmless even if a bit of it is
> exposed after crash.
> 
> Thanks,
> ojaswin
> 
>>
>> Thanks,
>> Yi
>>
>>
>>> Regards,
>>> ojaswin
>>>
>>> [1] https://lore.kernel.org/linux-ext4/179153611724.860602.5266334742364847927.b4-ty@b4/T/#m72e1710d172cf7699b6f05e29a270e45951800b0
>>>> +	if (from >= round_up(READ_ONCE(EXT4_I(inode)->i_disksize),
>>>> +			     i_blocksize(inode)))
>>>> +		goto out;
>>>> +
>>>> +	/*
>>>> +	 * Mark the inode as disksize-grow-pending. The zeroed block will
>>>> +	 * be written out by the generic writepages cycle or any other
>>>> +	 * syncing operation.
>>>> +	 *
>>>> +	 * Multiple overlapping unaligned EOF writes should not happen,
>>>> +	 * because we only mark the pending state after zeroing the on-disk
>>>> +	 * EOF block, and i_disksize can only be updated after the previous
>>>> +	 * zeroed pending block has been written back or the dirty folio
>>>> +	 * has been discarded.
>>>> +	 */
>>>> +	if (likely(folio_test_dirty(folio) &&
>>>> +		   !ext4_test_inode_state(inode,
>>>> +					  EXT4_STATE_DISKSIZE_GROW_PENDING)))
>>>> +		ext4_set_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
>>>> +out:
>>>> +	folio_unlock(folio);
>>>> +	folio_put(folio);
>>>> +	return 0;
>>>> +}
>>>> +
>>>>    /*
>>>>     * Submit and wait for the pending zeroed EOF block range to complete
>>>>     * if the given range [@offset, @end) fully covers it.  Must be called
>>>> @@ -4923,21 +5006,20 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>>>    	 * truncating up or performing an append write, because there might be
>>>>    	 * exposing stale on-disk data which may caused by concurrent post-EOF
>>>>    	 * mmap write during folio writeback.
>>>> -	 *
>>>> -	 * TODO: In the iomap path, handle this by tracking the ordered range
>>>> -	 * and updating i_disksize to i_size after the zeroed data has been
>>>> -	 * written back.
>>>>    	 */
>>>> -	if (ext4_should_order_data(inode) &&
>>>> -	    did_zero && zero_written && !IS_DAX(inode)) {
>>>> -		handle_t *handle;
>>>> +	if (did_zero && zero_written && !IS_DAX(inode)) {
>>>> +		if (ext4_should_order_data(inode)) {
>>>> +			handle_t *handle;
>>>> -		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>>>> -		if (IS_ERR(handle))
>>>> -			return PTR_ERR(handle);
>>>> +			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>>>> +			if (IS_ERR(handle))
>>>> +				return PTR_ERR(handle);
>>>> -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
>>>> -		ext4_journal_stop(handle);
>>>> +			err = ext4_jbd2_inode_add_write(handle, inode, from,
>>>> +							length);
>>>> +			ext4_journal_stop(handle);
>>>> +		} else if (ext4_inode_buffered_iomap(inode))
>>>> +			err = ext4_iomap_mark_disksize_pending(inode, from);
>>>>    		if (err)
>>>>    			return err;
>>>>    	}
>>>> -- 
>>>> 2.52.0
>>>>
>>

