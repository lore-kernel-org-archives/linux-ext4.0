Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EBE3D813A;
	Thu, 15 Oct 2026 02:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030723; cv=none; b=eabCl1+4Dk2iIRD/cHwn/smYZbmTBLHpTgktlhy1ueWyF5xnPRp9zaiT10sf1DQ7Enjeap+RbYnojjU0T87Px9Xht/eIgDj3UXWlSTLyR/kOIiXA5DHF3KPPYDV3eHxDYoJ/V/Zpvs+SQ2X7uqYc7zNpDb++r7T893RUBro432o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030723; c=relaxed/simple;
	bh=M/hfzFRfXZT5gtMPfkmHt1JKyF/bg+pj/In18m1zA24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BQCSUaItaPbtjyVo9On//k4qZVx2y9u8chDR3CSejAii1Pq/2zzxTCMftQ2JUEkjc4ddrTqUKcQMf7NM3YdP3o2k03MMvyUgmTa5oFDFEcMpbtk36mbljotvQJyyWcktf1SwmFLbBRECuf/ePE6hO7ABhfFmBScBsGk1UJVLuqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j4sCt6yJ8zYQtmx;
	Thu, 15 Oct 2026 10:17:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DE07F405AD;
	Thu, 15 Oct 2026 10:18:24 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAXTu3uN9BquGHxAQ--.50203S3;
	Thu, 15 Oct 2026 10:18:24 +0800 (CST)
Message-ID: <ab472a6d-0435-447e-82de-cf1ac2566797@huaweicloud.com>
Date: Thu, 15 Oct 2026 10:18:22 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix extent status cache clearing when truncating
 inline data
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 enwlinux@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
 chengzhihao1@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20261014021714.2382353-1-yi.zhang@huaweicloud.com>
 <sohkizuoexeuwreaxw463pyktxbrafyvtscklv5qyanhaehn4d@sx2bgp2s6e4u>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <sohkizuoexeuwreaxw463pyktxbrafyvtscklv5qyanhaehn4d@sx2bgp2s6e4u>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAXTu3uN9BquGHxAQ--.50203S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXry5uw47WFyxJF1rAr4xJFb_yoW7JrWDpF
	ZIkF4UKr4kW34UGa97Z3WjqF1Fga1rCr47GryagrnrWF15CF1IgF90krWFvasrKrWvyayj
	qFWFq3Z7Gan8trJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
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

On 10/15/2026 12:27 AM, Jan Kara wrote:
> On Wed 14-10-26 10:17:14, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> ext4_inline_data_truncate() clears the whole extent status tree of the
>> inode when it truncates the inline data, with
>>
>> 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
>>
>> It does that when the inode still carries inline data while the
>> EXT4_STATE_MAY_INLINE_DATA state bit is already cleared, which is the
>> case once an inline to extent conversion has been initiated, for
>> example a delalloc buffered write larger than the inline space.
>>
>> The clear is meant to drop stale extent status entries of such an inode
>> to prevent stale extents and stale reserved space after the conversion,
>> but the range is too wide.  It also drops the entries of the blocks
>> below the new end of file, that is the blocks that stay in the file.
>>
>> When writeback of these blocks starts later, the lookup of such a block
>> misses the extent status tree, falls back to the extent tree and caches
>> a hole entry for it.  Those blocks then have dirty, mapped and delayed
>> buffers together with a hole extent status entry.  This is an
>> unexpected inconsistency.
>>
>> This problem has been hidden so far because we allocate blocks and new
>> extents for them during writeback.  But once [1] is merged during the
>> iomap conversion, the writeback behavior will be normalized, and it will
>> no longer allocate blocks for holes, thus exposing this problem.
> 
> Hum, I don't understand. So we have inode with inline data. We truncate it
> (i.e. further reduce i_size). At this point we hold i_rwsem,
> invalidate_lock, i_data_sem. So how can race with inline data
> conversion?
> 

Hi Jan,

It is not a race, the state is left behind by an ordinary delalloc
buffered write that ran before the truncate started.  Please take a look
at ext4_da_convert_inline_data_to_extent().

A buffered write into an inline file that does not fit the inline space
goes there.  It copies the inline data into the page cache, creates
delayed allocation mappings for it, marks the folio dirty and clears
EXT4_STATE_MAY_INLINE_DATA.  The non-delalloc variant
ext4_convert_inline_data_to_extent() destroys the inline data with
ext4_destroy_inline_data_nolock() right there, but it can do that
because it allocates the blocks in the same transaction.  The delalloc
path deliberately keeps the inline data, it is the only copy of the data
until the blocks are created.  It is destroyed later by
ext4_do_writepages() during writeback, which calls
ext4_destroy_inline_data() when the inode still has inline data and it
is about to create the blocks, see the "we will soon create the block
for the 1st page, so we'd better clear the inline data here" comment.

So until that writeback runs, the inode has inline data, the
EXT4_STATE_MAY_INLINE_DATA bit cleared, and a dirty page whose blocks
are mapped as delayed allocations in the extent status tree.  A truncate
that comes later is fully serialized and still sees
ext4_has_inline_data() true, which is why it enters
ext4_inline_data_truncate().

Those delayed allocation entries below the new end of file are what the
unconditional ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS) drops,
even though their dirty buffers are still in the page cache.

Cheers,
Yi.

> 
>>
>> Therefore, restrict the range to the blocks that are actually truncated
>> away, and pass EXT_MAX_BLOCKS minus lblk as the length.
>>
>> [1] https://lore.kernel.org/linux-ext4/20261009103033.2920530-9-yi.zhang@huaweicloud.com/
>>
>> Reported-by: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>
>> Closes: https://lore.kernel.org/linux-ext4/6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com/
>> Fixes: 0add491df4e5 ("ext4: remove extent cache entries when truncating inline data")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  fs/ext4/inline.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
>> index ceee69a66482b..b630e56815bb5 100644
>> --- a/fs/ext4/inline.c
>> +++ b/fs/ext4/inline.c
>> @@ -1905,8 +1905,12 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>>  		 * the extent status cache must be cleared to avoid leaving
>>  		 * behind stale delayed allocated extent entries
>>  		 */
>> -		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
>> -			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
>> +		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
>> +			ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, i_size);
>> +
>> +			ext4_es_remove_extent(inode, lblk,
>> +					      EXT_MAX_BLOCKS - lblk);
>> +		}
>>  
>>  		/* Clear the content in the xattr space. */
>>  		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
>> -- 
>> 2.52.0
>>

