Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078C72D0605;
	Fri, 29 May 2026 07:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780039991; cv=none; b=ROR6FXoeSSNsFT1BkqF8JQuZ3+qzjec//1gy4UdhiYSQegvQCWob0LtsxrharZOpdW5vL8rDfGFgfq9tf0RTBGJig+6Gqu4jvc0jaDThIsRFQbrtoUWKFK044ae8O83KL1adXGtvUUNrBozgUE0UZBl+Umfq1wpK1wsMSWTHzxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780039991; c=relaxed/simple;
	bh=7mXu+oAU3O2kxKi7OsFcwS23Dhj769SyNfw5icSvjBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LP2vtkV2nSlXWr+clW8eaUF3WwEQvohYSVmJ2md3HXndv7erHdyt26JTyWrou4zAEEcj+7hS9lLYoPw/RzcxX57bItzoBGNZNPb5wQFcvecSGhz3/3ZZ4YWI1gD///I8l2SUb3gZCx6ZIiXJVkkdWW2qA+8/Rcbi6Y3RAWR3M5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gRZmk2MQ9zYQtpl;
	Fri, 29 May 2026 15:31:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AEF5240574;
	Fri, 29 May 2026 15:32:49 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgAn71oeQRlqEZ8pEA--.34710S3;
	Fri, 29 May 2026 15:32:47 +0800 (CST)
Message-ID: <73e91ebd-27de-4834-af2f-9b4ac19a4100@huaweicloud.com>
Date: Fri, 29 May 2026 15:32:45 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix quota accounting WARN in bigalloc punch hole
To: Qiliang Yuan <realwujing@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zijing Yin <yzjaurora@gmail.com>
References: <20260528-fix-ext4-bigalloc-punch-hole-quota-v2-v1-1-32871356273b@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260528-fix-ext4-bigalloc-punch-hole-quota-v2-v1-1-32871356273b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAn71oeQRlqEZ8pEA--.34710S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXw1UWrykAw4DGr4xJryxKrg_yoWrZryrpr
	ZI9r15J3yDJ3s7GFZ7AF15Wr1F934rXr47ursxG34fZF98JF1fXF1kKF4Y93WFvr48tFn8
	XF4jg34Uuan09aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Hi, Qiliang!

On 5/28/2026 6:21 PM, Qiliang Yuan wrote:
> When doing direct I/O write on a bigalloc filesystem, the allocated
> extent might not cover entire clusters at its boundaries, leaving
> delayed blocks in those boundary clusters.  In ext4_es_insert_extent(),
> __revise_pending() inserts new pending reservations for those boundary
> clusters, and the return value (pending=true) was added to resv_used,
> causing ext4_da_update_reserve_space() to incorrectly release the
> quota reservations for those boundary clusters.
> 
> Later when PUNCH_HOLE removes the DIO-allocated blocks, the
> extent removal path detects the pending reservation via
> ext4_is_pending() and calls ext4_rereserve_cluster().  This tries
> to reclaim quota from dq_dqb.dqb_curspace back to dqb_rsvspace,
> but since the quota was already incorrectly released, dqb_curspace
> is insufficient, triggering:
> 
>   WARNING at dquot_reclaim_space_nodirty+0x77c/0x8c0

Hmm, the analysis doesn't seem correct to me. Do you mean the
following case?

# Assume the cluster size is 16KB.
xfs_io -f -c "pwrite 12k 4k" /mnt/foo
xfs_io -d -c "pwrite 0 4k" /mnt/foo
xfs_io -c "fpunch 0 4k" /mnt/foo

During the direct I/O write, quota space will be added in
ext4_mb_new_blocks() because the EXT4_MB_DELALLOC_RESERVED flag is
not set. Therefore, in ext4_es_insert_extent(), we should release the
quota reservations, since this cluster has already been allocated.

Then, in the third operation (punch hole), it will reclaim the added
dqb_curspace. This should not cause an insufficiency.

Am I missing something?

> 
> The subsequent delalloc writeback then fires a second WARN from
> dquot_claim_space_nodirty() for the same reason: dqb_rsvspace was
> depleted by the earlier incorrect release.
> 
> __es_remove_extent() -> get_rsvd() already correctly excludes
> boundary clusters that still contain delayed blocks from resv_used.
> Adding pending to resv_used double-counts those boundary clusters,
> erroneously releasing reservations that are still needed.
> 
> Remove the pending variable and the resv_used += pending addition.

That's not correct. Assume the following case.

# Assume the cluster size is 16KB.
xfs_io -f -c "pwrite 0 16k" /mnt/foo
xfs_io -c "sync_range -w 0 4k" /mnt/foo

Although only part of the cluster is written back, the cluster has been
allocated. Therefore, the quota needs to be claimed. However, since we
only wrote back a portion of a cluster, __es_remove_extent() will not
return the reserved clusters that need to be consumed (i.e., resv_used
is zero). Therefore, we need to determine whether a new pending
allocation has been created by checking the pending status, so that we
can correctly claim the quota.

Thanks,
Yi

> 
> Fixes: c543e2429640 ("ext4: update delalloc data reserve spcae in ext4_es_insert_extent()")
> Reported-by: Zijing Yin <yzjaurora@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221570
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
>  fs/ext4/extents_status.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..fefe0bb8ac4d1 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -909,7 +909,7 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  	struct extent_status newes;
>  	ext4_lblk_t end = lblk + len - 1;
>  	int err1 = 0, err2 = 0, err3 = 0;
> -	int resv_used = 0, pending = 0;
> +	int resv_used = 0;
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	struct extent_status *es1 = NULL;
>  	struct extent_status *es2 = NULL;
> @@ -977,7 +977,6 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  			__free_pending(pr);
>  			pr = NULL;
>  		}
> -		pending = err3;
>  	}
>  	ext4_es_inc_seq(inode);
>  error:
> @@ -998,7 +997,6 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  	 * any previously delayed allocated clusters instead of claim them
>  	 * again.
>  	 */
> -	resv_used += pending;
>  	if (resv_used)
>  		ext4_da_update_reserve_space(inode, resv_used,
>  					     delalloc_reserve_used);
> 
> ---
> base-commit: eb3f4b7426cfd2b79d65b7d37155480b32259a11
> change-id: 20260528-fix-ext4-bigalloc-punch-hole-quota-v2-2adca315d1ba
> 
> Best regards,

