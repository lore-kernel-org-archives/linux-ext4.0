Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AA3346AF1;
	Mon, 31 Aug 2026 12:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788178731; cv=none; b=Su2DdH+l0D4sZO51DG28xivm29mUk5Y6XUnJKxL7WF51t6zNzmmPAi6Dda5Pq/K1M9FbdwZ4OFCv7y4CqA6xZ2LWGylH3cQvHaW92kHRCYsiVa3OiljekdvkB6KNQmg4GzRKGIvPEkJpiJRysv7uhlcJNvXX0iv/lJWUIFLdxJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788178731; c=relaxed/simple;
	bh=rMVKG7mQaBVoReB17i9I2MCnyV/Ej6kSAE2S0iKfHzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=pzqBPaVxnB7tfsPmF9oGleNwv5qMZjbgBxZbd4lPsRy/U/nPJ0n7z7171z9I1TxVMrVdo48MdhIO85d1a7LkhmFU/vNzss6W2W4zINV5Gznw/h0+BFCWPR4AqfsedaYe26cO4uIuMFv5JeSDcdX2oc316ghGGMTEKdl9VAvphdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hYSgd6vC7zYQtt0;
	Mon, 31 Aug 2026 20:18:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6518040A3B;
	Mon, 31 Aug 2026 20:18:43 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgAX_gggcZVq1qL1AA--.38183S3;
	Mon, 31 Aug 2026 20:18:42 +0800 (CST)
Message-ID: <49d6df68-dd74-417d-a313-69d15846c2b7@huaweicloud.com>
Date: Mon, 31 Aug 2026 20:18:39 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] ext4: Convert group-count barrier protocol to
 acquire/release
To: Jinjie Ruan <ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-8-ruanjinjie@huawei.com>
Content-Language: en-US
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 bcrl@kvack.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 pmladek@suse.com, rostedt@goodmis.org, andriy.shevchenko@linux.intel.com,
 linux@rasmusvillemoes.dk, senozhatsky@chromium.org,
 akpm@linux-foundation.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 socketcan@hartkopp.net, mkl@pengutronix.de, kuniyu@google.com,
 willemb@google.com, jhs@mojatatu.com, jiri@resnulli.us, kees@kernel.org,
 cyphar@cyphar.com, tglx@kernel.org, liuhangbin@gmail.com, sdf@fomichev.me,
 nb@tipi-net.de, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 netdev@vger.kernel.org, linux-can@vger.kernel.org
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260825095422.3166067-8-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAX_gggcZVq1qL1AA--.38183S3
X-Coremail-Antispam: 1UD129KBjvJXoWxurW5Zr17Gw1fWFy5ur43GFg_yoWrAw4Up3
	9rCF1UAF1kXw1UuF47G348uF1xW3WIka4Yq3s3Kr129Fy3t3W8AFyUtF18AFWvvFZ7Zr18
	Xan093yDurnrCrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26rWY6Fy7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8
	Jr1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j6a0PUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/25/2026 5:54 PM, Jinjie Ruan wrote:
> During an online resize, reading s_groups_count and s_blockfile_groups
> requires strict ordering against subsequent initialized block group
> metadata.
> 
> Replace the historical smp_wmb()/smp_rmb() pairs with smp_store_release()
> and smp_load_acquire(). This formalizes the publish-subscribe pattern
> and allows weakly-ordered architectures (e.g., arm64) to utilize native
> STLR/LDAR instructions instead of full DMB fences.
> 
> Update the documentation in resize.c and ext4.h accordingly.
> 
> Assisted-by: Gemini:Gemini-3.1
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/ext4.h    | 10 +++-------
>  fs/ext4/mballoc.c |  6 ++----
>  fs/ext4/resize.c  | 19 +++++++++++--------
>  3 files changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be61..d70b9cb09155 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3542,16 +3542,12 @@ static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
>  }
>  
>  /*
> - * Reading s_groups_count requires using smp_rmb() afterwards.  See
> - * the locking protocol documented in the comments of ext4_group_add()
> - * in resize.c
> + * Reading s_groups_count uses acquire semantics.
>   */
>  static inline ext4_group_t ext4_get_groups_count(struct super_block *sb)
>  {
> -	ext4_group_t	ngroups = EXT4_SB(sb)->s_groups_count;
> -
> -	smp_rmb();
> -	return ngroups;
> +	/* Pairs with smp_store_release() in ext4_update_super() */
> +	return smp_load_acquire(&EXT4_SB(sb)->s_groups_count);
>  }
>  
>  static inline ext4_group_t ext4_flex_group(struct ext4_sb_info *sbi,
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 06171a11db12..a15285224cdf 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -899,10 +899,8 @@ static ext4_group_t ext4_get_allocation_groups_count(
>  
>  	/* non-extent files are limited to low blocks/groups */
>  	if (!(ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS)))
> -		ngroups = EXT4_SB(ac->ac_sb)->s_blockfile_groups;
> -
> -	/* Pairs with smp_wmb() in ext4_update_super() */
> -	smp_rmb();
> +		/* Pairs with smp_store_release() in ext4_update_super() */
> +		ngroups = smp_load_acquire(&EXT4_SB(ac->ac_sb)->s_blockfile_groups);
>  
>  	return ngroups;
>  }
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 2c5b851c552a..5e3ad8393cf8 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1462,11 +1462,11 @@ static void ext4_update_super(struct super_block *sb,
>  	 *
>  	 * The precise rules we use are:
>  	 *
> -	 * * Writers must perform a smp_wmb() after updating all
> -	 *   dependent data and before modifying the groups count
> +	 * * Writers must use a release store when updating the groups count
> +	 *   after all dependent data has been updated
>  	 *
> -	 * * Readers must perform an smp_rmb() after reading the groups
> -	 *   count and before reading any dependent data.
> +	 * * Readers must use an acquire load when reading the groups
> +	 *   count before reading any dependent data.
>  	 *
>  	 * NB. These rules can be relaxed when checking the group count
>  	 * while freeing data, as we can only allocate from a block
> @@ -1474,12 +1474,15 @@ static void ext4_update_super(struct super_block *sb,
>  	 * only then free after serialising in turn against that
>  	 * allocation.
>  	 */
> -	smp_wmb();
>  
>  	/* Update the global fs size fields */
> -	sbi->s_groups_count += flex_gd->count;
> -	sbi->s_blockfile_groups = min(sbi->s_groups_count,
> -			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
> +	/* Pairs with smp_load_acquire() in ext4_get_groups_count() */
> +	smp_store_release(&sbi->s_groups_count,
> +			  sbi->s_groups_count + flex_gd->count);
> +	/* Pairs with smp_load_acquire() in ext4_get_allocation_groups_count() */
> +	smp_store_release(&sbi->s_blockfile_groups,
> +			  min(sbi->s_groups_count,
> +			      (EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb))));
>  
>  	/* Update the reserved block counts only once the new group is
>  	 * active. */

