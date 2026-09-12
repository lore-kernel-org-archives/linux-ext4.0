Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3DB368D5A
	for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2026 08:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201742; cv=none; b=ZrjYgjlj0jRe+MTLYMz9ryGD1imBxX9+RGYYd4uhC9Lx++E1+8tEsHQzWHt89EbiDduaisi//mD1WKLfERwEU3ycYTEp4mz51F8A3U1xIDW/9bZt3n45KEvNT4ALPdtnDGIZ1BjjZDCn1oiIuAEYoYZ+R2/AXoc57sSKZ3h+qcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201742; c=relaxed/simple;
	bh=Jr3Z5hnHY/gSm4sXIwIJ4qOe2MDnzFwkN9JANbpBKb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mvcqo95MpyMOH6Gfq3hXkzBvz9R2j4phy56lRt1bAHIEbxt607bQwpTdDv1eXZ6UGdaeG7N8C9XS8RWGSzDhtbpKELCn2ESDIO+U9yM6QBapcFC4oEQ9gg1G7ojpSMBbAogX3D1REV9j32nM+wvPmkMIE410D4o8Ya7+nYrMZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lN2JCykG; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lN2JCykG"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccb65437so213723a91.3
        for <linux-ext4@vger.kernel.org>; Sat, 12 Sep 2026 01:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789201740; x=1789806540; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8WyrkMGCFnrJHZlBLRQ3nbLnQoILyTDTc6d/TcvwDpo=;
        b=lN2JCykGFtPU0EiCBU3/ynkGZYCkG1KsxQbDGFoMAKGOzO80T1Xs3lVuRdljgr+VDl
         E61eWXVFVKLkDNxRJ9eEcusa5ah/gqAC2scjHElZ9R+HwDvqKSbO8nyrnWf9AwEXHWjF
         B3lgNm5kTaiYlZ5ba2j1RBg2jey0ydNxeMxO54/7XKDU6pdi4JZ7x0T+EVIus8RUxopg
         Va0P93ya0shOB2FzEIPMfCiGPrRKcy+kJj2htsvKTnHsOq3RBQpqa6XxxE8cNToFra5N
         tFqh3V7qnKr1pAwzYmxfLXynS2CdrOQF2wPxilnKlomRR/SJhdjmrJVjRPgNFi/grv/i
         9uQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789201740; x=1789806540;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8WyrkMGCFnrJHZlBLRQ3nbLnQoILyTDTc6d/TcvwDpo=;
        b=cw+9POLq6NKeAsFIuGO8apMa3OnZxYXg++Az86dYeEIcx2/Va7+LQMPbd4OtImHv0q
         GDnsjBN8y7cpbG5a//Mc9V4pDIIKT5aGZb44gneq4kBAzHBCEBUq8efjTmAmNda3MZFw
         TkJdE+z7MqFL41ISLAILu7OZsoe9FWUm2O32ySIvKLfdasIIRyBwosAsO2N3LTypequk
         hPkPVNsetuGiWLKvlMY2GBWilpWk0Qn65s/cTjFbkrbenV6wdF3K+zp0UkICqiAlmKTn
         ji0q8884xwxzbXZpr53i2bpfjIQwCCpyyaY3kYOuVv5x2kDfzdwHsDEHYwvWexmo8QgH
         uFiw==
X-Gm-Message-State: AFuF++nmG+BZRjJTk4lTL07n5QX/b5qwdbYFmcaKI4CU8md2+LQhbSMu
	4q4j9TQoLqqPG4j6ur/YPbw7C9aOAV8RlzjirSh195iYTcyjhBpOUycV
X-Gm-Gg: AYBFou2cjrWx7nm8z0KObFY4DE+3HfkzoBZHoUj73XGEY8M990Tul8K5vJqpV1NQklt
	iMbD8kJHWaiD83C3h7gfgVVWGynUjRdFkj/+o5PrQ+Kq7OZWMXFn9wB7QCBvRSqZ8WTYTOM/Tcw
	Qji7219rWS4xapbrUnq0zx7sNKknxL6dUMIKlUiygSChoFDYkGKF5NSK8HZIwUnqa7NFsC2p7Ea
	+3OjQ5/EN7k/xZVNGyDIBK4Ll0lSrrmY66Oe+cDzb0zK/TJVhphjWGeKuIGNPF1l3Zz6zLDO9yz
	ZPejJWwKK1kIEA3B21no4dc1CGVub4JWf7JsBZ4DqHW1lZ8Ix4lzlXRZKafyckobkr/o8hOC07J
	rq27pGIpaZmA90e+3JdkLNjaT1gE4SG3XAeLRpIFfF1i9aawQ1yvLWltwIeWuQrCsQU2zLlWvpK
	nhvUldMPGh1ui5VcdNiurMhoigGieNwZjNwuGUvMhEf5SdkBuJC96ZuFo0wvp9MmCvbqzbLC4t8
	6xjNZt6DaHVziOZIEs=
X-Received: by 2002:a17:90a:c2c6:b0:396:5fce:8e24 with SMTP id 98e67ed59e1d1-39dbbe85d7bmr3204586a91.4.1789201740359;
        Sat, 12 Sep 2026 01:29:00 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm9840725a91.14.2026.09.12.01.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2026 01:28:59 -0700 (PDT)
Message-ID: <bda020e4-2145-4c30-9330-ff8f9a6ff517@gmail.com>
Date: Sat, 12 Sep 2026 16:28:52 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/31] ext4: implement writeback path using iomap
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-16-yi.zhang@huaweicloud.com>
 <20260903133650.EDC101F00A3D@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260903133650.EDC101F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/2026 9:36 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] Journal Credits Exhaustion / Panic in `ext4_iomap_finish_ioend()` due to arbitrarily large merged ioends.
> - [High] Infinite loop in `ext4_iomap_map_writeback_range` due to open-coded ENOSPC retry logic without limits.
> --
> 
> commit e7cc5164579a940550c93afb2dfec1f186e079ed
> Author: Zhang Yi <yi.zhang@huawei.com>
> ext4: implement writeback path using iomap
> 
> This commit adds the iomap writeback path for ext4 buffered I/O, introducing
> new writeback operations and end I/O handlers. It maps and allocates blocks
> as unwritten extents during writeback to prevent stale data exposure.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 1f18854b9cdd3..f7d7610197a1c 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> 
> [ ... ]
> 
>> +static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
>> +					  loff_t offset, unsigned int dirty_len)
>> +{
> 
> [ ... ]
> 
>> +retry:
>> +	map.m_lblk = index;
>> +	map.m_len = min_t(unsigned int, MAX_WRITEPAGES_EXTENT_LEN, blk_len);
>> +	ret = ext4_map_blocks(NULL, inode, &map,
>> +			      EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
>> +			      EXT4_GET_BLOCKS_METADATA_NOFAIL |
>> +			      EXT4_GET_BLOCKS_IO_SUBMIT |
>> +			      EXT4_EX_NOCACHE);
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
> 
> [Severity: High]
> Could this open-coded retry loop result in an infinite hang under certain
> conditions?
> 
> If a non-root user fills the disk up to the threshold of root-reserved
> blocks, ext4_map_blocks() will return -ENOSPC because the block allocator
> denies access to reserved blocks for non-root users.
> 
> However, ext4_count_free_clusters() returns the total free space including
> those root-reserved blocks. Because the count evaluates as non-zero, the code
> will force a journal commit and goto retry indefinitely, without any loop
> limits.
> 
> Should this retry logic use a limit like ext4_should_retry_alloc(), or
> specifically account for root-reserved blocks to prevent a soft lockup in
> the writeback worker thread?
> 

This logic is inherited from the existing buffer_head writeback path
(the -ENOSPC handling in ext4_do_writepages()), which also retries after
a forced commit without any limit, so it does not introduce a new class
of problem.  That said, I agree that bounding the number of retries is
better, and I will add a limit in the next version.


>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>> index 0236b6b9785a2..9b0e12b5463cf 100644
>> --- a/fs/ext4/page-io.c
>> +++ b/fs/ext4/page-io.c
> 
> [ ... ]
> 
>> +static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>> +{
> 
> [ ... ]
> 
>> +	/*
>> +	 * We may need to convert one extent, update the i_disksize and
>> +	 * dirty the inode.
>> +	 */
>> +	credits = ext4_chunk_trans_blocks(inode,
>> +			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
>> +	handle = ext4_journal_start(inode, EXT4_HT_EXT_CONVERT, credits);
>> +	if (IS_ERR(handle)) {
>> +		ret = PTR_ERR(handle);
>> +		goto out_err;
>> +	}
> 
> [ ... ]
> 
>> +void ext4_iomap_end_io(struct work_struct *work)
>> +{
>> +	struct ext4_inode_info *ei = container_of(work, struct ext4_inode_info,
>> +						  i_rsv_conversion_work);
>> +	struct iomap_ioend *ioend;
>> +	struct list_head ioend_list;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>> +	list_replace_init(&ei->i_rsv_conversion_list, &ioend_list);
>> +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>> +
>> +	iomap_sort_ioends(&ioend_list);
>> +	while (!list_empty(&ioend_list)) {
>> +		ioend = list_entry(ioend_list.next, struct iomap_ioend, io_list);
>> +		list_del_init(&ioend->io_list);
>> +		iomap_ioend_try_merge(ioend, &ioend_list);
>> +		ext4_iomap_finish_ioend(ioend);
>> +	}
>> +}
> 
> [Severity: Critical]
> Is there a risk of exhausting journal credits and panicking JBD2 when ioends
> are merged?
> 
> In ext4_iomap_end_io(), iomap_ioend_try_merge() merges contiguous completions
> into an arbitrarily large ioend. When this merged ioend is later passed to
> ext4_iomap_finish_ioend(), it requests credits using ext4_chunk_trans_blocks().
> 
> However, ext4_chunk_trans_blocks() internally hardcodes the extent count to 1,
> allocating credits sufficient for modifying only a single extent on disk.
> 
> If a user writes a very large contiguous file (e.g., larger than 128MB), the
> merged ioend will exceed the maximum size of a single unwritten extent in ext4
> (which is 32,768 blocks). This will cause ext4_convert_unwritten_extents() to
> loop over multiple extents using the same transaction handle.
> 
> Could this exhaust the single-extent credits provided by the transaction
> handle, resulting in a JBD2 panic during writeback?
> 

This is right.  ext4_convert_unwritten_extents() converts every extent
covered by the ioend using a single transaction handle, but that handle
was sized by ext4_chunk_trans_blocks() for one extent only, so a large
enough merged ioend can run out of credits.  This is hard to hit in
practice, since the end I/O worker normally runs promptly and not many
completed ioends accumulate before the merge, but to be safe I will
still fix it: call ext4_journal_ensure_credits() before each extent in
the conversion loop, so that the transaction is extended, or restarted
once it is full, as needed, and correct the estimation to
ext4_meta_trans_blocks(inode, max_blocks, 1, 0) at the same time, as no
data blocks are allocated there.

Thanks,
Yi.



