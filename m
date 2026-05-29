Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65753C0630;
	Fri, 29 May 2026 10:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780051070; cv=none; b=cYX99W/BOTBl4hsDVk7klZP6yk0ANYFPnE1kKJhEhLsEQSXEK/b6HZdsnBqQ3cOUGU/Baw8ToXbT8KjQEzWZXH3Yt/G//FIrdtNiWFeXKz8W34s/eqkz3yIbh+vR8xhehPmWmcRpNwIR2HvtrnrHHsgxfF7eHsfgA7G5Kn/N3pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780051070; c=relaxed/simple;
	bh=laDzvS/8wbpJYnQti0qasxrhBW4Ey0/Zj54mq93FKuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=erZLF7xLYWzlYMp6ZylsH8Wz/hs/IjF/9Zw39xOanEGcuJr58ApFuXYI3+2aELoBOtK3Hkrc5q3HYo3XdnwTLwJyKafXWkMXyPWXcUTkjZg1iGblx9ZDGqHpqN83+Hcl0o2p9+BsjWq0r1XI94I16AHzoc+C/uk089bVodm5trQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gRft42n2czYQvH5;
	Fri, 29 May 2026 18:36:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 00B9340590;
	Fri, 29 May 2026 18:37:43 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgAn71p2bBlquGU5EA--.37693S3;
	Fri, 29 May 2026 18:37:43 +0800 (CST)
Message-ID: <9cf8569a-4f79-400b-ad80-197decec4b15@huaweicloud.com>
Date: Fri, 29 May 2026 18:37:41 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix quota accounting WARN in bigalloc punch hole
To: Qiliang Yuan <realwujing@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com, libaokun@linux.alibaba.com,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, yzjaurora@gmail.com
References: <73e91ebd-27de-4834-af2f-9b4ac19a4100@huaweicloud.com>
 <20260529083445.101050-1-realwujing@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260529083445.101050-1-realwujing@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAn71p2bBlquGU5EA--.37693S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWr1UZw4DJF1kGF13Gr1kAFb_yoW7Gry7pr
	Za9rn5Wa1DJrnrZrZxZw1rXFyruwn2qF45Jrs8JryfZF9xGFySvrn8KFs09Fyj9r4xXFn8
	XF4j9a4Uu34DuaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/29/2026 4:34 PM, Qiliang Yuan wrote:
> Hi Zhang Yi,
> 
> On 5/29/2026 3:32 PM, Zhang Yi wrote:
>> On 5/28/2026 6:21 PM, Qiliang Yuan wrote:
>>> __es_remove_extent() -> get_rsvd() already correctly excludes
>>> boundary clusters that still contain delayed blocks from resv_used.
>>> Adding pending to resv_used double-counts those boundary clusters,
>>> erroneously releasing reservations that are still needed.
>>
>> Hmm, the analysis doesn't seem correct to me. Do you mean the
>> following case?
>>
>> # Assume the cluster size is 16KB.
>> xfs_io -f -c "pwrite 12k 4k" /mnt/foo
>> xfs_io -d -c "pwrite 0 4k" /mnt/foo
>> xfs_io -c "fpunch 0 4k" /mnt/foo
>>
>> During the direct I/O write, quota space will be added in
>> ext4_mb_new_blocks() because the EXT4_MB_DELALLOC_RESERVED flag is
>> not set. Therefore, in ext4_es_insert_extent(), we should release the
>> quota reservations, since this cluster has already been allocated.
>>
>> Then, in the third operation (punch hole), it will reclaim the added
>> dqb_curspace. This should not cause an insufficiency.
>>
>> Am I missing something?
> 
> Thanks for the review!  Let me explain the issue with your specific
> example.

Thanks for the explanation, some comments below.

> 
> After step 1 (delalloc write 4KB@12KB in a 16KB cluster), we have:
> 
>   ES tree: [0,1) hole, [1,3) delayed, [3,4) hole   (blocks 0..3)

             [0,3) hole, [3,4) delayed(blocks 0..3)  ?

>   Quota:   dqb_rsvspace += 16KB (one cluster reserved)

Right.

> 
> Step 2 (DIO write 4KB@0KB, RWF_DSYNC):
> 
>   The DIO allocates one cluster, but the mapped extent from
>   ext4_ext_map_blocks() only covers the written range, e.g. [0,0].
> 
>   In ext4_es_insert_extent():
> 
>     a) __es_remove_extent([0,0]) removes the [0,1) hole entry, but
>        there are no delayed extents within [0,0], so resv_used = 0.
> 
>        This is correct: the DIO extent [0,0] does not overlap the
>        delayed region [1,3).

Right.

> 
>     b) __revise_pending() scans outside the newly inserted extent [0,0]:
> 
>        - Left boundary (block 0): the range starts at cluster
>          boundary, no blocks to scan on the left → no pending insert.
> 
>        - Right boundary (block 3): blocks [1,3] are outside [0,0]
>          and are delayed → __revise_pending() inserts a pending
>          reservation and returns pending = 1.
> 
>        This pending reservation means: "cluster containing block 3
>        still has delayed blocks, keep this cluster reserved."

Right.

> 
>     c) Then comes the bug:
> 
>          resv_used += pending;   // resv_used = 0 + 1 = 1
> 
>        This causes ext4_da_update_reserve_space() to release 16KB
>        of quota reservation (dquot_release_reservation_block()).  But
>        block 3 is still delayed!  Its quota reservation should NOT
>        be released — no blocks within [0,0] actually used the delalloc
>        reservation.

No. Because this cluster has already been allocated, it needs to occupy
actual quota space and can no longer use reserved counts, so the
reserved counts must be released.

For better understanding, please see the implementation of
ext4_insert_delayed_blocks(). When a new extent is delallocated to an
already allocated cluster using the the reserved count is not increased
(ext4_clu_alloc_state() returns 2).

> 
>     So after DIO:
>       dqb_rsvspace: originally 16KB, now 0 (incorrectly released)
>       dqb_curspace: 16KB (from ext4_mb_new_blocks)
> 
> Step 3 (punch 4KB@0KB):
> 
>   ext4_remove_blocks() sees that block 0's cluster has a pending
>   reservation → calls ext4_rereserve_cluster() → dquot_reclaim_block()
>   tries to move 16KB from dqb_curspace to dqb_rsvspace.  But
>   dqb_curspace may already be insufficient (depending on whether
>   other allocs/frees have happened), triggering:
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
How exactly did it happen? All data cluster allocations are precisely
calculated. In addition, the current example cannot reproduce the issue
you encountered.

> 
>     WARNING at dquot_reclaim_space_nodirty
> 
> Step 4 (delalloc writeback of block 3):
> 
>   ext4_da_update_reserve_space() → dquot_claim_block() tries to
>   move 16KB from dqb_rsvspace to dqb_curspace.  Since rsvspace was
>   incorrectly released and not fully restored by the punch hole's
>   rereseve, this triggers:
> 
>     WARNING at dquot_claim_space_nodirty
> 
> The key point is: pending from __revise_pending() indicates clusters
> that *still contain delayed blocks outside the newly inserted extent*.
> These clusters' quota reservations must be preserved — get_rsvd()

Whether to reserve a quota is determined not by whether there are
delalloc extents left, but by whether there are only pure delalloc
extents in this cluster range.

Cheers,
Yi.

> inside __es_remove_extent() already correctly excludes them from
> resv_used.  Adding pending to resv_used double-counts them.
> 
> I also found a pre-existing retry loop issue: if __es_insert_extent()
> fails with -ENOMEM on the first pass, resv_used carries a stale value
> back to retry and could be double-released.  I'll include a fix for
> that in v2.
> 

