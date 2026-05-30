Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC73384CCE;
	Sat, 30 May 2026 08:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780129474; cv=none; b=HTDw8Uh62oQC8B72NpNNFqb2XFVql+7JMT9kX3G75pkUr2WZDoB9XfJk74Li5TKXM7RGdzCTJ3uvwdIv0SH0O1Y3aoD/3XKxMC991rTQdhdSCmPWZd2b8J54si6iv2EP6iopiNPkHMvdvJOFOzf2cbQ3PbkD/f00sCHpdpht97Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780129474; c=relaxed/simple;
	bh=vWO9cOjLke0sZ8t9/659v+UucslLDgb+1vMrUmWxNgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nm49G8YzlZNx0NvXNz3BATXki8TiQuQFgtgXD8H+Qw17re4Nm9pA2aCaHaObdfA6lrP3f2Zfbt0z2KxJJ/mmndTO6YgSZe1vZWHAx+nOXyAwHBpN+fbrcbdLQe3NpIiRv8R6Yb17CGMRi1nSLzVZbclTl+hXzOAv2Ocnv1vqJrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gSCsp09V4zYQtdr;
	Sat, 30 May 2026 16:23:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2BA5040574;
	Sat, 30 May 2026 16:24:27 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgAHz1q5nhpqg3yoEA--.61117S3;
	Sat, 30 May 2026 16:24:26 +0800 (CST)
Message-ID: <81f4c0ec-1d80-4987-b31e-4e9ecd394c63@huaweicloud.com>
Date: Sat, 30 May 2026 16:24:24 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap buffered
 I/O path
To: Zhang Yi <yi.zhang@huaweicloud.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yizhang089@gmail.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <ahcUeq_IA_X988Ca@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <5d2b13b9-d5a0-47ce-876c-ab01070cbe49@huaweicloud.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <5d2b13b9-d5a0-47ce-876c-ab01070cbe49@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAHz1q5nhpqg3yoEA--.61117S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtF4DAw47Zr1kur48ZF13urg_yoW7Cr18pr
	Z5KFnxGw48Xry2krsIqw1IqrySvw1rKr47WrnxG3WDua90yFy2yF1IgF1F9Fyqkr4UGrWj
	qF48Jr9rurn8ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/30/2026 3:22 PM, Zhang Yi wrote:
> Hi, Ojaswin!
> 
> On 5/27/2026 11:58 PM, Ojaswin Mujoo wrote:
>> On Mon, May 11, 2026 at 03:23:38PM +0800, Zhang Yi wrote:
>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> For append writes, wait for ordered I/O to complete before updating
>>> i_disksize. This ensures that zeroed data is flushed to disk before the
>>> metadata update, preventing stale data from being exposed during
>>> unaligned post-EOF append writes.
>>>
>>> Suggested-by: Jan Kara <jack@suse.cz>
>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>> ---
>>>  fs/ext4/ext4.h    | 11 +++++++
>>>  fs/ext4/inode.c   | 80 ++++++++++++++++++++++++++++++++++++++++++-----
>>>  fs/ext4/page-io.c | 60 +++++++++++++++++++++++++++++++++++
>>>  fs/ext4/super.c   | 23 ++++++++++----
>>>  4 files changed, 161 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>> index 078feda47e36..9ce2128eea3e 100644
>>> --- a/fs/ext4/ext4.h
>>> +++ b/fs/ext4/ext4.h
>>> @@ -1195,6 +1195,15 @@ struct ext4_inode_info {
>>>  #ifdef CONFIG_FS_ENCRYPTION
>>>  	struct fscrypt_inode_info *i_crypt_info;
>>>  #endif
>>> +
>>> +	/*
>>> +	 * Track ordered zeroed data during post-EOF append writes, fallocate,
>>> +	 * and truncate-up operations. These parameters are used only in the
>>> +	 * iomap buffered I/O path.
>>> +	 */
>>> +	ext4_lblk_t i_ordered_lblk;
>>> +	ext4_lblk_t i_ordered_len;
>>> +	wait_queue_head_t i_ordered_wq;
>>>  };
>>>  
>>>  /*
>>> @@ -3858,6 +3867,8 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>>>  			     __u64 len, __u64 *moved_len);
>>>  
>>>  /* page-io.c */
>>> +#define EXT4_IOMAP_IOEND_ORDER_IO	1UL	/* This I/O is an ordered one */
>>> +
>>>  extern int __init ext4_init_pageio(void);
>>>  extern void ext4_exit_pageio(void);
>>>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>> index e013aeb03d7b..11fb369efeb1 100644
>>> --- a/fs/ext4/inode.c
>>> +++ b/fs/ext4/inode.c
>>> @@ -4345,6 +4345,7 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>>  {
>>>  	struct iomap_ioend *ioend = wpc->wb_ctx;
>>>  	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
>>> +	ext4_lblk_t start, end, order_lblk, order_len;
>>>  
>>>  	/*
>>>  	 * After I/O completion, a worker needs to be scheduled when:
>>> @@ -4357,6 +4358,30 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>>  	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>>>  		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>>>  
>>> +	/*
>>> +	 * Mark the I/O as ordered. Ordered I/O requires separate endio
>>> +	 * handling and must not be merged with regular I/O operations.
>>> +	 */
>>> +	order_len = READ_ONCE(ei->i_ordered_len);
>>> +	if (order_len) {
>>> +		/*
>>> +		 * Pair with smp_store_release() in ext4_block_zero_eof().
>>> +		 * Ensure we see the updated i_ordered_lblk that was written
>>> +		 * before the release store to i_ordered_len.
>>> +		 */
>>> +		smp_rmb();
>>> +		order_lblk = READ_ONCE(ei->i_ordered_lblk);
>>> +		start = ioend->io_offset >> ioend->io_inode->i_blkbits;
>>> +		end = EXT4_B_TO_LBLK(ioend->io_inode,
>>> +				     ioend->io_offset + ioend->io_size);
>>> +
>>> +		if (start <= order_lblk && end >= order_lblk + order_len) {
>>
>> Hi Zhang,
>>
>> I guess this check is enough cause ordered_lblk and ordered_len will
>> always be  contained in a single block.
> 
> Yeah.
> 
>>
>>> +			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>>> +			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
>>> +			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
>>
>> FWIU, we are wanting the ordered IO to not be merged and submitted asap
>> since we want to wake up the waiters. Is there any other reason?
> 
> My original intention was to prevent the loss of the
> EXT4_IOMAP_IOEND_ORDER_IO flag during worker processing triggered by I/O
> completion, which could be caused by merging an ordered ioend with a
> normal ioend.  In patch 19, we need to determine the flag to update
> i_disksize to the correct position.
> 
>>
>> Adding the boundary in ->writeback_submit() only affects
>> iomap_ioend_can_merge() which happens after we have woken up the waiters
>> and deferred the IO to the wq. We ideally want it affect
>> iomap_can_add_to_ioend() ie we need to add IOMAP_F_BOUNDARY in
>> ->writeback_range().
> 
> IIUC, merging into the same ioend during the submission stage doesn't
> seem to cause any problems.
> 
>>
>> Secondly, I don't think boundary is the right flag here. It ensures
>> that everything before the ordered iomap gets submitted and the ordered
>> iomap starts a new ioend. This can still keep getting merged with the
>> newer ioends untils we decide to submit the IO, which can delay waking
>> up the waiters. If we really want the "no merge" behavior, we'll have to
>> do something like [1] (Check the 2 NOMERGE flag patches).
> 
> Yeah, IOMAP_IOEND_BOUNDARY appears to be just a one-way barrier and
> still cannot prevent merging. I missed this, thank you for pointing this
> out. However, I think perhaps we should change iomap_ioend_can_merge()
> to check the iomap_ioend->io_private. Something like:
> 
> 	if (ioend->io_private || next->io_private)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            ioend->io_private != next->io_private


> 		return false;
> 
> What do you think?
> 
> Thanks,
> Yi.

