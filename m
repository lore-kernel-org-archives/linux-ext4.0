Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3170836
	for <linux-ext4@vger.kernel.org>; Tue,  2 Jun 2026 03:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780370559; cv=none; b=AbOXK6OufbCiWImCr4X0WzCSWT6n9qRFflAYAfE+7lsvFjo95GGm7T3VwmQ+oGolri/QXpQQrr37r01nOzu9tO9o6kKZHH2UArUc+Im+7dPZ5yl7pCyGaPeH9YJtjxZN2EmrEmtk1VswaTQj49K9b+rpMuoRZye23WN2XccjTp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780370559; c=relaxed/simple;
	bh=2s9kSqpsNu3ak+QJdLtVLMGO3pHBoFwMp5CG3kVT+qI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a9ey4d8qfC1kpbm8eCxMx2zxlTE6j9RsZj9NcU8L8av7o/dTuKvZfGeNz9mXPw1PCpFk5jzoWuogMV2sKH6IheOYJX7EjTUeocV9cwl65Z4F5acY39ipUc3Q4oy2t3OexmhH39SdOkUDqn7FQ8+iLOtaudrfc5Wwih78oqgOYqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YrxfpQLQ; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YrxfpQLQ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84275887a3fso45700b3a.1
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2026 20:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780370558; x=1780975358; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ifszgGnOJKVlfH1YY/f0K+3tZlKk77uo3HV5kRDcas4=;
        b=YrxfpQLQzj9lNCf4BwginnQUDSn1vA6RKmNL23mRdyd0BHnmn+7rg58EIzjKrUilUk
         UOHUGXKWhUDPra0Te5a9GbRa131Lz9u2M6TQMCvHBx647n2P6MJ/R3yZdcg3sSU1Ksdq
         WztvLoUaxRLdLEcyxr0usxU/O/KjKriIUJz6tq575JBQBNHi2xtdovuFuRjwQgzCCo0C
         hmRk1QazolW8GlofJ2Oe3WKdFV2yJz8xUJSJpjuzz5R2FWSqOhamepgIjXi+vKbrdkm6
         sDDwSnsDOCbRAwixh9+GCULdIvVEp4/byRAo4bmqeEKriQ61usBEEjVu7IkaHjcALxn6
         KAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370558; x=1780975358;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ifszgGnOJKVlfH1YY/f0K+3tZlKk77uo3HV5kRDcas4=;
        b=SFAjKag3sXJVVhnkPag7nMJrJ7Ll3uMrF1vsf2cHD2on3F1cCbZjEtZCVQ61tDo+a5
         iM7R1+UIALocfucsZdNhFkoUNINCg0U9rh3b6Y3Zdp2Rj32dCKN914AgwUA1MjeuvswT
         x7yTX6Od9N1LZCSn2vw73VDbKBbyHsx/jUvrV0vDOQ+YQyg+kRE/Z/gE0g6MJ4jCq0z4
         KyObpbLwa7RuksZUpPyl4oUG04uZyk+4jrJHYs5DppKxSLA2npbA7TC5q4oCS8sq2K+n
         isI7eerxy/Mx/W88oN5Xf3yfy7uznqF/UfadcCIl8T47BHiFVAAHL9legdjBdyz04JDD
         j/zA==
X-Gm-Message-State: AOJu0YzQ5rbrPxJ/oPb2iojMZhdwewJ+pvu1Lw9KetSY/Qobfxuc0JX1
	hX7Oh6qXsGLZWEg7x7NFK/9h9tvxdg2x5duWntAqViKmNcLw0Pc9QdkG
X-Gm-Gg: Acq92OEuHlaWyLfUJl3qErc7MXd22l2ymv6piF15Z9zYE/f8ze7irpFGq9KT0mDbkzR
	oYC7R11elBH7u6ktJYfQrVPq9eCmzF8NwolOUvq+a0QsqhZxHZrHm4Kxnnc6Rog4CO54AnqIGFs
	neVDV/2PI9R8YY/GnA7Z7tGK9zJfs6Tx+SV2HpVHdqUhoR/uKkWIjCjfRYJEJ4+c0gL+4Iqq2h+
	5X0egJaVaKGleQ6czqIPV2GrIY3CzVOQD0VejQ+S2W28mywIiDGgg4p2pqqMhfWGvBQo8FxoCF4
	TVXXnV81mLn87ivu+n6x3bxSQRz5o/cPBK4SxBSjsOKi/KtV2Z5Om2+lv50uwGoS1WhSm95CUef
	70FnR7teEuVFlVV7+yC19jE/BjJaiK4lr63pyV/Eu+iKtIk4SPTlAb4MUW3/I3tc10X4u/k4d6O
	oV6Ckg3Iy/9BgA+6yX5ta0MT/Hjt1rPLC/6kmuqG75yOClfUcy2VxvHA==
X-Received: by 2002:a05:6a00:198e:b0:841:f565:a02c with SMTP id d2e1a72fcca58-8426aa9074emr1511666b3a.24.1780370557546;
        Mon, 01 Jun 2026 20:22:37 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214ce85d2sm11387531b3a.51.2026.06.01.20.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 20:22:37 -0700 (PDT)
Message-ID: <ad963861-4ae3-4753-9415-793bbac00e06@gmail.com>
Date: Tue, 2 Jun 2026 11:22:12 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap buffered
 I/O path
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <ahcUeq_IA_X988Ca@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <5d2b13b9-d5a0-47ce-876c-ab01070cbe49@huaweicloud.com>
 <81f4c0ec-1d80-4987-b31e-4e9ecd394c63@huaweicloud.com>
 <ah3QlCt8V-3kVzW8@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <ah3QlCt8V-3kVzW8@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/2/2026 2:33 AM, Ojaswin Mujoo wrote:
> On Sat, May 30, 2026 at 04:24:24PM +0800, Zhang Yi wrote:
>> On 5/30/2026 3:22 PM, Zhang Yi wrote:
>>> Hi, Ojaswin!
>>>
>>> On 5/27/2026 11:58 PM, Ojaswin Mujoo wrote:
>>>> On Mon, May 11, 2026 at 03:23:38PM +0800, Zhang Yi wrote:
>>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>>
>>>>> For append writes, wait for ordered I/O to complete before updating
>>>>> i_disksize. This ensures that zeroed data is flushed to disk before the
>>>>> metadata update, preventing stale data from being exposed during
>>>>> unaligned post-EOF append writes.
>>>>>
>>>>> Suggested-by: Jan Kara <jack@suse.cz>
>>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>>> ---
>>>>>   fs/ext4/ext4.h    | 11 +++++++
>>>>>   fs/ext4/inode.c   | 80 ++++++++++++++++++++++++++++++++++++++++++-----
>>>>>   fs/ext4/page-io.c | 60 +++++++++++++++++++++++++++++++++++
>>>>>   fs/ext4/super.c   | 23 ++++++++++----
>>>>>   4 files changed, 161 insertions(+), 13 deletions(-)
>>>>>
>>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>>> index 078feda47e36..9ce2128eea3e 100644
>>>>> --- a/fs/ext4/ext4.h
>>>>> +++ b/fs/ext4/ext4.h
>>>>> @@ -1195,6 +1195,15 @@ struct ext4_inode_info {
>>>>>   #ifdef CONFIG_FS_ENCRYPTION
>>>>>   	struct fscrypt_inode_info *i_crypt_info;
>>>>>   #endif
>>>>> +
>>>>> +	/*
>>>>> +	 * Track ordered zeroed data during post-EOF append writes, fallocate,
>>>>> +	 * and truncate-up operations. These parameters are used only in the
>>>>> +	 * iomap buffered I/O path.
>>>>> +	 */
>>>>> +	ext4_lblk_t i_ordered_lblk;
>>>>> +	ext4_lblk_t i_ordered_len;
>>>>> +	wait_queue_head_t i_ordered_wq;
>>>>>   };
>>>>>   
>>>>>   /*
>>>>> @@ -3858,6 +3867,8 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>>>>>   			     __u64 len, __u64 *moved_len);
>>>>>   
>>>>>   /* page-io.c */
>>>>> +#define EXT4_IOMAP_IOEND_ORDER_IO	1UL	/* This I/O is an ordered one */
>>>>> +
>>>>>   extern int __init ext4_init_pageio(void);
>>>>>   extern void ext4_exit_pageio(void);
>>>>>   extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
>>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>>> index e013aeb03d7b..11fb369efeb1 100644
>>>>> --- a/fs/ext4/inode.c
>>>>> +++ b/fs/ext4/inode.c
>>>>> @@ -4345,6 +4345,7 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>>>>   {
>>>>>   	struct iomap_ioend *ioend = wpc->wb_ctx;
>>>>>   	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
>>>>> +	ext4_lblk_t start, end, order_lblk, order_len;
>>>>>   
>>>>>   	/*
>>>>>   	 * After I/O completion, a worker needs to be scheduled when:
>>>>> @@ -4357,6 +4358,30 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>>>>   	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>>>>>   		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>>>>>   
>>>>> +	/*
>>>>> +	 * Mark the I/O as ordered. Ordered I/O requires separate endio
>>>>> +	 * handling and must not be merged with regular I/O operations.
>>>>> +	 */
>>>>> +	order_len = READ_ONCE(ei->i_ordered_len);
>>>>> +	if (order_len) {
>>>>> +		/*
>>>>> +		 * Pair with smp_store_release() in ext4_block_zero_eof().
>>>>> +		 * Ensure we see the updated i_ordered_lblk that was written
>>>>> +		 * before the release store to i_ordered_len.
>>>>> +		 */
>>>>> +		smp_rmb();
>>>>> +		order_lblk = READ_ONCE(ei->i_ordered_lblk);
>>>>> +		start = ioend->io_offset >> ioend->io_inode->i_blkbits;
>>>>> +		end = EXT4_B_TO_LBLK(ioend->io_inode,
>>>>> +				     ioend->io_offset + ioend->io_size);
>>>>> +
>>>>> +		if (start <= order_lblk && end >= order_lblk + order_len) {
>>>>
>>>> Hi Zhang,
>>>>
>>>> I guess this check is enough cause ordered_lblk and ordered_len will
>>>> always be  contained in a single block.
>>>
>>> Yeah.
>>>
>>>>
>>>>> +			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>>>>> +			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
>>>>> +			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
>>>>
>>>> FWIU, we are wanting the ordered IO to not be merged and submitted asap
>>>> since we want to wake up the waiters. Is there any other reason?
>>>
>>> My original intention was to prevent the loss of the
>>> EXT4_IOMAP_IOEND_ORDER_IO flag during worker processing triggered by I/O
>>> completion, which could be caused by merging an ordered ioend with a
>>> normal ioend.  In patch 19, we need to determine the flag to update
>>> i_disksize to the correct position.
> 
> Ahh okay, we don't want the flag to be lost.
> 
>>>
>>>>
>>>> Adding the boundary in ->writeback_submit() only affects
>>>> iomap_ioend_can_merge() which happens after we have woken up the waiters
>>>> and deferred the IO to the wq. We ideally want it affect
>>>> iomap_can_add_to_ioend() ie we need to add IOMAP_F_BOUNDARY in
>>>> ->writeback_range().
>>>
>>> IIUC, merging into the same ioend during the submission stage doesn't
>>> seem to cause any problems.
> 
> Got it since the flag is set later. I was thinking we want to quickly
> issue the ordered IO to wake up the waiters and not waste time trying to
> merge it and hence we wanted to use that flag.
> 
>>>
>>>>
>>>> Secondly, I don't think boundary is the right flag here. It ensures
>>>> that everything before the ordered iomap gets submitted and the ordered
>>>> iomap starts a new ioend. This can still keep getting merged with the
>>>> newer ioends untils we decide to submit the IO, which can delay waking
>>>> up the waiters. If we really want the "no merge" behavior, we'll have to
>>>> do something like [1] (Check the 2 NOMERGE flag patches).
>>>
>>> Yeah, IOMAP_IOEND_BOUNDARY appears to be just a one-way barrier and
>>> still cannot prevent merging. I missed this, thank you for pointing this
>>> out. However, I think perhaps we should change iomap_ioend_can_merge()
>>> to check the iomap_ioend->io_private. Something like:
>>>
>>> 	if (ioend->io_private || next->io_private)
>>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>              ioend->io_private != next->io_private
> 
> I guess if the purpose is to just not lose the flag, then boundary seems
> to work for because we only lose the flag if ordered ioend backward
> merges to a prev one. Flag is retained if we forward merge. Which
> boundary seems to take care of.
> 
Yes, IOMAP_IOEND_BOUNDARY is indeed worked currently as it prevents flag
loss. However, from the perspective of the iomap infrastructure, I
believe it is still necessary to add the ioend->io_private !=
next->io_private check. Because ioends with different io_private values
should not be merged, as this carries the risk of potentially losing
io_private or even memory leaks. With this check in iomap, we would no
longer need IOMAP_IOEND_BOUNDARY.

> However, if we want to avoid merges so we can quickly issue IO and wake
> up the waiters then the above change looks good. Also, if this is the
> reason we'd also want to have this during submission stage so the flag
> setting will probs have to move to ->wirteback_range()

Yes. Issuing ordered I/O as soon as possible is beneficial as it reduces
the latency of sync file range. Suppose when we are syncing data beyond
the ordered range, the background writeback process has already started
committing and bundled the ordered range into a large ioend (up to
IOEND_BATCH_SIZE folios), then this sync operation will indeed
experience significant latency. However, for other non-sync scenarios,
there should be little benefit.

But I'm not sure if this is strictly necessary, because in the existing
implementation, issuing ordered I/O via data=ordered mode works the same
way — it also doesn't issue ordered I/O as soon as possible, and still
has to wait when encountering concurrent background writeback. So I
think we can keep the current implementation for now and see user
feedback to decide whether further optimization is needed.

Cheers,
Yi.
