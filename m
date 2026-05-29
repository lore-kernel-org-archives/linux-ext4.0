Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C0B3BED31;
	Fri, 29 May 2026 09:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780048658; cv=none; b=A9F5HYw/PtnLtvbLvSQNPDwXFOa6LQHjfEkFwrW+FynesG2BJ+jTUgsun8SWsArv0uM4FsoQJ2/TjK65tC2f2z1cY2N86SpcF5P/w1JyqQJ0mo/kFG/KP7cXV00dKHfj/Vi7DjdeS1eKPNIcNvlf/Cm3daNsnZ9EsipICGt9LsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780048658; c=relaxed/simple;
	bh=Isi7qn3sJT9SqEGviSxfjuZAM3s1juSbmZkQHiHxBFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GMsgZhY1bGR1Ptwja7PyjUioE2qqWUFltU2MtDMS+FpfU9cWM3fJM2YFzEcSWqsWrtobhENqCWVM3DKIHLYp2/eRhu4rJMwfCm2kmW2RjfpINlBQm92df3Rd021BVE9MDO9FKJKbv2idJ19NbOjG4vB6QdS1WW4rHUaoSSUkzO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kTBGBZU3; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kTBGBZU3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780048646; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ugYi+uPEVktNs1FvDiRlWULY1/dkTmCor/SYvBkmoEw=;
	b=kTBGBZU3PysxekxH82vBH8UB3bjiabip8him3iSr4Y3iDjR8k9DRWudcgaTaY7RgJ4YKCfEXHeA+zt6lxadzXtnTTluu/7+JejcCP9BuItc0+sy/78mTrsczt5HT3UFu/yJX0KYHN8pkvjfJGcNO3oVNw/YDdNGF3jkfXwFlzMg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X3ozooX_1780048645;
Received: from 30.221.147.25(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X3ozooX_1780048645 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 17:57:25 +0800
Message-ID: <d737bdc8-2eb3-4ea1-a76d-4f8f26b683f7@linux.alibaba.com>
Date: Fri, 29 May 2026 17:57:23 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix fast commit wait/wake bit mapping on 64-bit
To: Li Chen <me@linux.beauty>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sashiko AI review <sashiko-bot@kernel.org>
References: <20260513085818.552432-1-me@linux.beauty>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260513085818.552432-1-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/5/13 16:58, Li Chen wrote:
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

This cleanup looks good! Just two small nits below. Nits aside:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

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

The forward declarations above are only needed for macro-generated functions
that can't be found by name search. These two helpers are spelled out
directly,
so the declarations are unnecessary here.

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

Would it be cleaner to place these inside the existing #if
(BITS_PER_LONG < 64)
/ #else block alongside ext4_clear_state_flags(), the same way the rest
of the
state helpers are organised? That would also avoid repeating the #if guard.


Cheers,
Baokun

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


