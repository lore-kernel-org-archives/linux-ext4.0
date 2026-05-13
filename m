Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1343806A7
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2026 09:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778665564; cv=none; b=WsQjwWehtl5v/Er9EsZrPsPUYDuOls+eN13/bznj0DFrT3gq19N5/Oc51YjAIgV+l2xuAyi5Sjw3oZ/p+DHiAa6WVViP1Or0yQEpp6fZd2cOQgUgPOjxQPSjeP3OvzKaXRDJwCzALlqblaaCGVD5Sel6d4ENVSWaDf0qhnCtanc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778665564; c=relaxed/simple;
	bh=xj4MCrceVJW/kgGGPsZ/lySdRPEYOdaN9MtbzV3Nx6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+REdlzr0u1nBTbMllJhFvqA7e0yIFqRPBw3RTpcQtGdfW5WCHFyvxgvv0Dt/POP0c7artYBdG6ZDvTfFjcK2Yr2KoMNpAnTlz/LNI2ESjlZpkGyHaW3yVB6bj5yjwzHBhxym4n0UyJELog6l8Wa8+XeJCqx3stN8E1fzCv7opY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XwJ+9gko; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nyimsMIe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LtscZ29h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bDVpEsmw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XwJ+9gko";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nyimsMIe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LtscZ29h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bDVpEsmw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DD74475D7F;
	Wed, 13 May 2026 09:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778665553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DyJhAIxInWZzgUNFoQ0/UW1FaKgqMWGkRp6pSDyT+DY=;
	b=XwJ+9gkoSeQXyaXD/SXP6/m0btD3U84UnhAnQ/DZrAijfeBXd8B2M5TnMnugnZ2YVh/JQy
	guFl4OwuUM9PJOofewwd985NgiXlpKDOMJ+23AfnmvVBv1Il4ZQKrzZ7V4yWGeZKze1EaR
	4RXET8CWPB5/lmT1feGDALcssCvLH6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778665553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DyJhAIxInWZzgUNFoQ0/UW1FaKgqMWGkRp6pSDyT+DY=;
	b=nyimsMIeOKcrjFcXHgdNt71h2qFf65W6xXqBLkqYwbGvagSUNj0m0z4WYjsNtSeoIDmzXN
	KH74woqsXEB6pHAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778665552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DyJhAIxInWZzgUNFoQ0/UW1FaKgqMWGkRp6pSDyT+DY=;
	b=LtscZ29hMNm3IP2t3BW0jRSMJbV9af3WCOcevQqaoHhXPtog9pBWNqMHthjUovxc+WIZKS
	Rm5Omy3Bl+BrbZ41OvGGcRjQtpeGZclusm5ql011kyhjr1jH1SNrH+epbFLox1ADtgf68x
	yH/9YBvpjNVoMVj1z1HQ271OXrDkGkM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778665552;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DyJhAIxInWZzgUNFoQ0/UW1FaKgqMWGkRp6pSDyT+DY=;
	b=bDVpEsmwHYrgmXL+ZOLgBxO114SDHqtm6uiPkks5MOPtS6pxiGCvl+dH333iTEym04ETBW
	gpPKEdUY63KFKCBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFA09593A9;
	Wed, 13 May 2026 09:45:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 08OuMlBIBGoWewAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 13 May 2026 09:45:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 600C1A0800; Wed, 13 May 2026 11:45:39 +0200 (CEST)
Date: Wed, 13 May 2026 11:45:39 +0200
From: Jan Kara <jack@suse.cz>
To: Li Chen <me@linux.beauty>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sashiko AI review <sashiko-bot@kernel.org>
Subject: Re: [PATCH] ext4: fix fast commit wait/wake bit mapping on 64-bit
Message-ID: <j5hfnd2cwyfhxiy4n6gdxhhdpz53r62vi5tb3fkq6esl5qwmy7@bmcekfs6chta>
References: <20260513085818.552432-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085818.552432-1-me@linux.beauty>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email,chinatelecom.cn:email]
X-Spam-Level: 

On Wed 13-05-26 16:58:17, Li Chen wrote:
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

Nice cleanup and a good spotting. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

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
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
