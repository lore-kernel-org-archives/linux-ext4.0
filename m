Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560E838758A;
	Thu, 14 May 2026 12:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778760063; cv=none; b=CBwUaRUXM+y8wVvZtZ+9wkH6G4m58Xf/9JHyOUPDTI2KUTAo0TGE6vnspb1KxjWFOCg7YlvoFprXERLbfmelUBNqqbgwEjk6QGKYsCkMR8GltZXhH5o0xYe99wfee5Pz0F79lDeeIg3MubQBLPP3Wo5O5u9OyrlSX2FIIHk8TBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778760063; c=relaxed/simple;
	bh=pac0ja/mqBZS7hPPKym010MPk+gXFWweb5I9OQAzBoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CtNU1Y3EASOXRBhoDQOdzm8xS70eWOnzd3ZKgFpgRU4XePl2WfGKY/JOgQtaUC7crI3sCcWTVneJ7jf1S0sEAwnUib9NCHdT14hlIVjzluFbQ2L6g0UQGkZ5oHHop4E3B5uZKhR8jCcW085mLYQdcVpbYX6uaAS/wZYNVDcysbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gGTRV6h8bzYQth1;
	Thu, 14 May 2026 20:00:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0A92840561;
	Thu, 14 May 2026 20:00:57 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgA3_1p3uQVqf8sTCQ--.48564S3;
	Thu, 14 May 2026 20:00:56 +0800 (CST)
Message-ID: <aa148ef6-f103-4f30-abfe-4c553d394616@huaweicloud.com>
Date: Thu, 14 May 2026 20:00:54 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix fast commit wait/wake bit mapping on 64-bit
To: Li Chen <me@linux.beauty>, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani
 <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sashiko AI review <sashiko-bot@kernel.org>
References: <20260513085818.552432-1-me@linux.beauty>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260513085818.552432-1-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgA3_1p3uQVqf8sTCQ--.48564S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw4UKFyxtF4rtw4kJr4UCFg_yoWxCrWrpr
	s8GF13Jay0qryj9r4SqrWUZrnYk3W8KwsrurZxG3WfAF98JF4rtFn3GF95CFyYkrWkZr42
	vay5CwsrGw47t37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

On 5/13/2026 4:58 PM, Li Chen wrote:
> On 64-bit, ext4 dynamic inode states live in the upper half of i_flags,
> and ext4_test_inode_state() applies the corresponding +32 offset.
> 
> The fast-commit wait and wake paths open-coded the wait key with the raw
> EXT4_STATE_* value. Add small helpers for the state wait word and bit,
> and use them for the FC_COMMITTING and FC_FLUSHING_DATA waits so the wait
> key follows the same mapping as the state helpers.
> 
> Fixes: 857d32f26181 ("ext4: rework fast commit commit path")
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>

Ha, This looks good to me! Thanks.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/ext4.h        | 20 +++++++++++++++++
>  fs/ext4/fast_commit.c | 50 ++++++++++++++++---------------------------
>  2 files changed, 38 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a991e5c..6569d1d575a0 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2000,6 +2000,8 @@ EXT4_INODE_BIT_FNS(flag, flags, 0)
>  static inline int ext4_test_inode_state(struct inode *inode, int bit);
>  static inline void ext4_set_inode_state(struct inode *inode, int bit);
>  static inline void ext4_clear_inode_state(struct inode *inode, int bit);
> +static inline unsigned long *ext4_inode_state_wait_word(struct inode *inode);
> +static inline int ext4_inode_state_wait_bit(int bit);
>  #if (BITS_PER_LONG < 64)
>  EXT4_INODE_BIT_FNS(state, state_flags, 0)
>  
> @@ -2015,6 +2017,24 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>  	/* We depend on the fact that callers will set i_flags */
>  }
>  #endif
> +
> +static inline unsigned long *ext4_inode_state_wait_word(struct inode *inode)
> +{
> +#if (BITS_PER_LONG < 64)
> +	return &EXT4_I(inode)->i_state_flags;
> +#else
> +	return &EXT4_I(inode)->i_flags;
> +#endif
> +}
> +
> +static inline int ext4_inode_state_wait_bit(int bit)
> +{
> +#if (BITS_PER_LONG < 64)
> +	return bit;
> +#else
> +	return bit + 32;
> +#endif
> +}
>  #else
>  /* Assume that user mode programs are passing in an ext4fs superblock, not
>   * a kernel struct super_block.  This will allow us to call the feature-test
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index b3c22636251d..1775bce9649a 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -239,6 +239,8 @@ void ext4_fc_del(struct inode *inode)
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct ext4_fc_dentry_update *fc_dentry;
>  	wait_queue_head_t *wq;
> +	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
> +	int wait_bit = ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
>  	int alloc_ctx;
>  
>  	if (ext4_fc_disabled(inode->i_sb))
> @@ -268,17 +270,9 @@ void ext4_fc_del(struct inode *inode)
>  	WARN_ON(ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)
>  		&& !ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE));
>  	while (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
> -#if (BITS_PER_LONG < 64)
> -		DEFINE_WAIT_BIT(wait, &ei->i_state_flags,
> -				EXT4_STATE_FC_FLUSHING_DATA);
> -		wq = bit_waitqueue(&ei->i_state_flags,
> -				   EXT4_STATE_FC_FLUSHING_DATA);
> -#else
> -		DEFINE_WAIT_BIT(wait, &ei->i_flags,
> -				EXT4_STATE_FC_FLUSHING_DATA);
> -		wq = bit_waitqueue(&ei->i_flags,
> -				   EXT4_STATE_FC_FLUSHING_DATA);
> -#endif
> +		DEFINE_WAIT_BIT(wait, wait_word, wait_bit);
> +
> +		wq = bit_waitqueue(wait_word, wait_bit);
>  		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
>  		if (ext4_test_inode_state(inode, EXT4_STATE_FC_FLUSHING_DATA)) {
>  			ext4_fc_unlock(inode->i_sb, alloc_ctx);
> @@ -542,6 +536,8 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	wait_queue_head_t *wq;
> +	unsigned long *wait_word = ext4_inode_state_wait_word(inode);
> +	int wait_bit = ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
>  	int ret;
>  
>  	if (S_ISDIR(inode->i_mode))
> @@ -564,17 +560,9 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
>  	lockdep_assert_not_held(&ei->i_data_sem);
>  
>  	while (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING)) {
> -#if (BITS_PER_LONG < 64)
> -		DEFINE_WAIT_BIT(wait, &ei->i_state_flags,
> -				EXT4_STATE_FC_COMMITTING);
> -		wq = bit_waitqueue(&ei->i_state_flags,
> -				   EXT4_STATE_FC_COMMITTING);
> -#else
> -		DEFINE_WAIT_BIT(wait, &ei->i_flags,
> -				EXT4_STATE_FC_COMMITTING);
> -		wq = bit_waitqueue(&ei->i_flags,
> -				   EXT4_STATE_FC_COMMITTING);
> -#endif
> +		DEFINE_WAIT_BIT(wait, wait_word, wait_bit);
> +
> +		wq = bit_waitqueue(wait_word, wait_bit);
>  		prepare_to_wait(wq, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
>  		if (ext4_test_inode_state(inode, EXT4_STATE_FC_COMMITTING))
>  			schedule();
> @@ -1034,6 +1022,8 @@ static int ext4_fc_perform_commit(journal_t *journal)
>  	int ret = 0;
>  	u32 crc = 0;
>  	int alloc_ctx;
> +	int flushing_wait_bit =
> +		ext4_inode_state_wait_bit(EXT4_STATE_FC_FLUSHING_DATA);
>  
>  	/*
>  	 * Step 1: Mark all inodes on s_fc_q[MAIN] with
> @@ -1059,11 +1049,8 @@ static int ext4_fc_perform_commit(journal_t *journal)
>  	list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
>  		ext4_clear_inode_state(&iter->vfs_inode,
>  				       EXT4_STATE_FC_FLUSHING_DATA);
> -#if (BITS_PER_LONG < 64)
> -		wake_up_bit(&iter->i_state_flags, EXT4_STATE_FC_FLUSHING_DATA);
> -#else
> -		wake_up_bit(&iter->i_flags, EXT4_STATE_FC_FLUSHING_DATA);
> -#endif
> +		wake_up_bit(ext4_inode_state_wait_word(&iter->vfs_inode),
> +			    flushing_wait_bit);
>  	}
>  
>  	/*
> @@ -1279,6 +1266,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
>  	struct ext4_inode_info *ei;
>  	struct ext4_fc_dentry_update *fc_dentry;
>  	int alloc_ctx;
> +	int committing_wait_bit =
> +		ext4_inode_state_wait_bit(EXT4_STATE_FC_COMMITTING);
>  
>  	if (full && sbi->s_fc_bh)
>  		sbi->s_fc_bh = NULL;
> @@ -1315,11 +1304,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
>  		 * barrier in prepare_to_wait() in ext4_fc_track_inode().
>  		 */
>  		smp_mb();
> -#if (BITS_PER_LONG < 64)
> -		wake_up_bit(&ei->i_state_flags, EXT4_STATE_FC_COMMITTING);
> -#else
> -		wake_up_bit(&ei->i_flags, EXT4_STATE_FC_COMMITTING);
> -#endif
> +		wake_up_bit(ext4_inode_state_wait_word(&ei->vfs_inode),
> +			    committing_wait_bit);
>  	}
>  
>  	while (!list_empty(&sbi->s_fc_dentry_q[FC_Q_MAIN])) {

