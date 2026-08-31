Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3963B14CE;
	Mon, 31 Aug 2026 11:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788177246; cv=none; b=enm5e1RHwOGxe96L8cWtplFntuWd0MfA9gXRxprfm/xb5vXJ7mtv5TgMfGtatDKtmP4yJQrIhku9J1Wmi56qYJOnHKgd8Z9N/0ecUP6Q0NWFr76/AJ3GYUu0s5xm38ieH1QNHWzN2VL/zaEJF3ZyC8AyCrn0qLVuQc8/IjTvM5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788177246; c=relaxed/simple;
	bh=+O8q1PFFVuZ04wk0IQ4Bd37i7S8NTmE+vIVAH0LPoo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tK6yjzrOxSIvH1Zg86WuEjenDPFPhHJ0z6xQQV/78OpFPo53dR53Cg2mTKYGf+FC4nQ3A1EMj9lQ7+5tRmCXWnDRi1aWU2x8/UPpKPiLYKZTCvYAUoqd8oKk2dFiPGr1Z6pTI2YAchnNnJcXGXHe4BACUvsm7Nr0L9dsojZDLeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IMdQX0Rk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vtUsLCXv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=195sPZLp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=k20UFPZ9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IMdQX0Rk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vtUsLCXv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="195sPZLp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="k20UFPZ9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4FDC0224D0;
	Mon, 31 Aug 2026 11:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788177238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+RKXp8acbmEZB92DNdU3vfC31X8afmpyUT6QYHPcLNU=;
	b=IMdQX0Rknx81REbKQMLryWJUlv3le8cvNfq2jsljR3lyYozvKOMjLRhAco4Ho+eVnD/Y0I
	2UhPtxTTF9QOveY9vAjfmoCV9GGK72D6PCtHLmdfNNk7QxT7TJbfqHhOC5+7wL8dx6069b
	eVhrm147WdcP1E6Peqf9t8wtxHFy7X0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788177238;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+RKXp8acbmEZB92DNdU3vfC31X8afmpyUT6QYHPcLNU=;
	b=vtUsLCXv9zDoJW9hr/GXW1I1h3Mjpa53UNOz8J+8lpsTEjad3KmGdaJkNXRYEgURPFrTBZ
	oAI+6OQ0YOsA/cCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788177234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+RKXp8acbmEZB92DNdU3vfC31X8afmpyUT6QYHPcLNU=;
	b=195sPZLp5vxtLk6MPAl7ckwEWrkhoI+V8HAAma0AzFU3PLQZGSDKhWfvB0xWB2L6KPziW6
	7l6nkMzvBCrVzSVEV1kblZv3jIdTbmWs4LX9Sa/xoHxOoiJbbAzaaYzqRekkAN4SiXQ0U6
	n7M4ARNqAqSFFFf5RfET2yNjZSdJdW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788177234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+RKXp8acbmEZB92DNdU3vfC31X8afmpyUT6QYHPcLNU=;
	b=k20UFPZ928t7n4ASR8ntGEhWHQ/ljeHXihrjD0QxYUxk/WN0cZdApli1WA7oHjrEE35vXQ
	p997v4OwWz1hR9DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A42FD13515;
	Mon, 31 Aug 2026 11:53:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id me8PKFFrlWrEYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 11:53:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EC102A13B5; Mon, 31 Aug 2026 13:53:52 +0200 (CEST)
Date: Mon, 31 Aug 2026 13:53:52 +0200
From: Jan Kara <jack@suse.cz>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	bcrl@kvack.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, pmladek@suse.com, rostedt@goodmis.org, 
	andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, senozhatsky@chromium.org, 
	akpm@linux-foundation.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, socketcan@hartkopp.net, mkl@pengutronix.de, 
	kuniyu@google.com, willemb@google.com, jhs@mojatatu.com, jiri@resnulli.us, 
	kees@kernel.org, cyphar@cyphar.com, tglx@kernel.org, liuhangbin@gmail.com, 
	sdf@fomichev.me, nb@tipi-net.de, linux-fsdevel@vger.kernel.org, 
	linux-aio@kvack.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH 07/11] ext4: Convert group-count barrier protocol to
 acquire/release
Message-ID: <vzwmgjfapapzrbwdo6nangrihpk4prlj7rlm3tipmmiumb3l7j@cffw5odvv6g5>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-8-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825095422.3166067-8-ruanjinjie@huawei.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[40];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	R_RATELIMIT(0.00)[to_ip_from(RLmzfjx67n53eyz9asjm8u3pcw)];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[zeniv.linux.org.uk,kernel.org,suse.cz,kvack.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,suse.com,goodmis.org,linux.intel.com,rasmusvillemoes.dk,chromium.org,linux-foundation.org,davemloft.net,google.com,redhat.com,hartkopp.net,pengutronix.de,mojatatu.com,resnulli.us,cyphar.com,fomichev.me,tipi-net.de,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO

On Tue 25-08-26 17:54:18, Jinjie Ruan wrote:
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

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

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
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
