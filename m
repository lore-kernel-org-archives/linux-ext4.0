Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED7E3DB31E
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 11:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785153447; cv=none; b=OglA4FIS5VmKK9Xi5tROYVM8buX9kcLAqQAPdFBPzdYoz7WPPQo9jfnhvyT6jeC8Fvby0UyTRaK8KjdNkcLE9PmG5/NXekaO/1KAYItCDOk6z9J9HveYrQZGb2S9r/H4sOAFCK22LT+IUaMTf67mbdzpZUIwuyj+wEpl7l1y2J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785153447; c=relaxed/simple;
	bh=gGxwNEesPpgyOjyT2lyqErSAoX9R3LxZzD5pocHbNYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSRMwtnLGtwOG0N0x0QvW8B5g2lxrZ9T6X54zBCMh1JN83m+osJ6DpgxmflSskHKuUErCzrcQ2jXXWiXaaBsTBQ7dxwFsq2rl1L4iDbK/kZLLLhr/1jOZcr11vY5RyLYYCZCP0I4a6CjPR9lD7XdrHou2r31n7HqpnZOM4pX4xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KSq9UUgm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/PlYbtuC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JAb1PMPk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EQ58l7tS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KSq9UUgm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/PlYbtuC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JAb1PMPk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EQ58l7tS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B58B67DB1D;
	Mon, 27 Jul 2026 11:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785153439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y7fvpN9900rKwCxhIAjQqejvSnqGcss7ZhaVKVeysXA=;
	b=KSq9UUgmgTSLtT6hmDuvFDaimby9M7lkch+P3Nq+gSwFVw+H+uRSzgXL6qSeZzThNiS5hs
	Xhthi9l2qDrz2jxJlHTJOLNijhKiKHwQngw8sWYLC9r2kAHJ+ACxqpK051JhB/gcbbywDW
	b4vBCeV6MVjzTEezgCTav7o+dT2Ce94=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785153439;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y7fvpN9900rKwCxhIAjQqejvSnqGcss7ZhaVKVeysXA=;
	b=/PlYbtuCmDom3CQqYVZ4Zkkmrn2AhjW7SxPpkHceDPr/Jgs+fQVBElNgBBgicdPHWe5M20
	ejehjJ5kikrY/FDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785153435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y7fvpN9900rKwCxhIAjQqejvSnqGcss7ZhaVKVeysXA=;
	b=JAb1PMPklp4nQ7iyvPZONHMqmPmPuRyz293R4BEHGvOklc1d0FYd/ImjhIK5nUz/OEsJYe
	62MbzLOC9lHkvm+6/CsboZnFAHyPAoDX7EgFkCgttbEIhtL0BZj+jtos+2YfCTs+Tpgqpt
	MgWLNtZ45uEMGeI1NJzi6yCsFG5JX8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785153435;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y7fvpN9900rKwCxhIAjQqejvSnqGcss7ZhaVKVeysXA=;
	b=EQ58l7tSrfKSx9NqMHSpyAhTzOYryGbKDHPAJlsosxQS5fSF7fLcKzV8kLWQY1W2FqUiUW
	UGTI0W07FdRR/bDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AADA2779C1;
	Mon, 27 Jul 2026 11:57:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WSO0KZtHZ2r8MAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Jul 2026 11:57:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 567FEA0BA1; Mon, 27 Jul 2026 13:57:11 +0200 (CEST)
Date: Mon, 27 Jul 2026 13:57:11 +0200
From: Jan Kara <jack@suse.cz>
To: rafad900 <rafad900@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: convert pa_count from atomic_t to refcount_t
Message-ID: <2joyziupzemt5vjdvmnic3kcdckt6z5dht6vgusxsxrfbtthhn@uuiexxvvcclv>
References: <20260720034441.3900050-1-rafad900@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720034441.3900050-1-rafad900@gmail.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.989];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Sun 19-07-26 20:44:41, rafad900 wrote:
> The pa_count field in struct ext4_prealloc_space is
> reference counter for preallocation descriptors.
> Converting it from atomic_t to refcount_t provides
> underflow and overflow protection.
> 
> This was found using Coccinelle script
> atomic_as_refcounter.cocci
> 
> Testing was done on a QEMU x86 VM revealing a
> pre-existing race condition leading to a
> use-after-free.
> 
> Signed-off-by: rafad900 <rafad900@gmail.com>

This is a bit problematic as for pa_count 0->1 transition is fine (as long
as pa_deleted isn't set) so this conversion will trigger false warnings as
the 0-day report shows.

								Honza

> ---
>  fs/ext4/mballoc.c | 22 +++++++++++-----------
>  fs/ext4/mballoc.h |  2 +-
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ed1bd00e11cd..59b3d4abaab0 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4823,7 +4823,7 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
>  	ext4_fsblk_t cur_distance, new_distance;
>  
>  	if (cpa == NULL) {
> -		atomic_inc(&pa->pa_count);
> +		refcount_inc(&pa->pa_count);
>  		return pa;
>  	}
>  	cur_distance = abs(goal_block - cpa->pa_pstart);
> @@ -4833,8 +4833,8 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
>  		return cpa;
>  
>  	/* drop the previous reference */
> -	atomic_dec(&cpa->pa_count);
> -	atomic_inc(&pa->pa_count);
> +	refcount_dec(&cpa->pa_count);
> +	refcount_inc(&pa->pa_count);
>  	return pa;
>  }
>  
> @@ -4993,7 +4993,7 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
>  	}
>  
>  	if (tmp_pa->pa_free && likely(ext4_mb_pa_goal_check(ac, tmp_pa))) {
> -		atomic_inc(&tmp_pa->pa_count);
> +		refcount_inc(&tmp_pa->pa_count);
>  		ext4_mb_use_inode_pa(ac, tmp_pa);
>  		spin_unlock(&tmp_pa->pa_lock);
>  		read_unlock(&ei->i_prealloc_lock);
> @@ -5139,7 +5139,7 @@ static void ext4_mb_mark_pa_deleted(struct super_block *sb,
>  static inline void ext4_mb_pa_free(struct ext4_prealloc_space *pa)
>  {
>  	BUG_ON(!pa);
> -	BUG_ON(atomic_read(&pa->pa_count));
> +	BUG_ON(refcount_read(&pa->pa_count));
>  	BUG_ON(pa->pa_deleted == 0);
>  	kmem_cache_free(ext4_pspace_cachep, pa);
>  }
> @@ -5165,7 +5165,7 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
>  
>  	/* in this short window concurrent discard can set pa_deleted */
>  	spin_lock(&pa->pa_lock);
> -	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0) {
> +	if (!refcount_dec_and_test(&pa->pa_count) || pa->pa_free != 0) {
>  		spin_unlock(&pa->pa_lock);
>  		return;
>  	}
> @@ -5535,7 +5535,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
>  	list_for_each_entry_safe(pa, tmp,
>  				&grp->bb_prealloc_list, pa_group_list) {
>  		spin_lock(&pa->pa_lock);
> -		if (atomic_read(&pa->pa_count)) {
> +		if (refcount_read(&pa->pa_count)) {
>  			spin_unlock(&pa->pa_lock);
>  			*busy = 1;
>  			continue;
> @@ -5637,7 +5637,7 @@ void ext4_discard_preallocations(struct inode *inode)
>  		BUG_ON(pa->pa_node_lock.inode_lock != &ei->i_prealloc_lock);
>  
>  		spin_lock(&pa->pa_lock);
> -		if (atomic_read(&pa->pa_count)) {
> +		if (refcount_read(&pa->pa_count)) {
>  			/* this shouldn't happen often - nobody should
>  			 * use preallocation while we're discarding it */
>  			spin_unlock(&pa->pa_lock);
> @@ -5720,7 +5720,7 @@ static int ext4_mb_pa_alloc(struct ext4_allocation_context *ac)
>  	pa = kmem_cache_zalloc(ext4_pspace_cachep, GFP_NOFS);
>  	if (!pa)
>  		return -ENOMEM;
> -	atomic_set(&pa->pa_count, 1);
> +	refcount_set(&pa->pa_count, 1);
>  	ac->ac_pa = pa;
>  	return 0;
>  }
> @@ -5731,7 +5731,7 @@ static void ext4_mb_pa_put_free(struct ext4_allocation_context *ac)
>  
>  	BUG_ON(!pa);
>  	ac->ac_pa = NULL;
> -	WARN_ON(!atomic_dec_and_test(&pa->pa_count));
> +	WARN_ON(!refcount_dec_and_test(&pa->pa_count));
>  	/*
>  	 * current function is only called due to an error or due to
>  	 * len of found blocks < len of requested blocks hence the PA has not
> @@ -5948,7 +5948,7 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
>  				pa_node.lg_list,
>  				lockdep_is_held(&lg->lg_prealloc_lock)) {
>  		spin_lock(&pa->pa_lock);
> -		if (atomic_read(&pa->pa_count)) {
> +		if (refcount_read(&pa->pa_count)) {
>  			/*
>  			 * This is the pa that we just used
>  			 * for block allocation. So don't
> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
> index 39333ce72cbd..f708d303228e 100644
> --- a/fs/ext4/mballoc.h
> +++ b/fs/ext4/mballoc.h
> @@ -126,7 +126,7 @@ struct ext4_prealloc_space {
>  		struct rcu_head	pa_rcu;
>  	} u;
>  	spinlock_t		pa_lock;
> -	atomic_t		pa_count;
> +	refcount_t		pa_count;
>  	unsigned		pa_deleted;
>  	ext4_fsblk_t		pa_pstart;	/* phys. block */
>  	ext4_lblk_t		pa_lstart;	/* log. block */
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
