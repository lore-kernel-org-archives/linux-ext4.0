Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED33B28B4FA
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 15:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779723182; cv=none; b=M7Q+OrNsaoi5662NRjpV9B2RGIQkbb330jEmzzEpegctexZrj8LYC5HJVOfQ07DKUUddcv3mjIsKVeZm+oWUAG2L6mNl+TgrtfyE2DFb5BN0HmJ1J79zDPLzSAPUjFpqDC9XAqzOmGgoo7MUQJ9Ci3wA/RXd6upyVfgtIouJHLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779723182; c=relaxed/simple;
	bh=fkKAekZ7OJEqJDGoLV/srkSyL2t7k3LS8WQ+8f/eA/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUbHoWtnofqxy1iUI2X2YpyLbBy8XqCK9+Sd79jPx7iwrFNNqGRF+PEx5F7v3nnpR1CPQmKqMhFH9ze5qsmL/9jW4WOlv+hkGpGkgP+MwuyxfkkuwD+zX/Om3zombwZeJkvJa9HNYXzsqbgeEwFuh1GtcZkARfjvK39iv2RyQJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z+8ayfLX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=B0nj4ysz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZZt1vGOm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ojP1cYC7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z+8ayfLX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="B0nj4ysz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZZt1vGOm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ojP1cYC7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0571167B35;
	Mon, 25 May 2026 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779723179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tglcw2CO1c40dMizXDLXH0Co2RvRnuE5M25POizJtGM=;
	b=Z+8ayfLXQ17oBXbUMLWHdcqiMSAKiH4Q2MmLB461MBv1+M/pIb2BJkQclpDX3YYrXaF7pC
	VD20K/7Zb7zYqHBbs/CGmP8jfQo/++OVrUksbmnct8DqK9BJsPMSiFQOCnBogy2EykOAtH
	u5bfZhP5XdKKKdxiqk6bP9WA+PMQZlI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779723179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tglcw2CO1c40dMizXDLXH0Co2RvRnuE5M25POizJtGM=;
	b=B0nj4yszvsjTa78uM1i3FkbFDElvOWZUJa/5WUe9/YMMT/I9j1HLs0+907IfihQyBcja2J
	dtkH2VpyA0Ppa9Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779723178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tglcw2CO1c40dMizXDLXH0Co2RvRnuE5M25POizJtGM=;
	b=ZZt1vGOm/P09pwOnAR45DPRjbfJMzfKDtj29QqKhzF3fyzpIqJZwUVPBVJKwyZSv+kTEEI
	Zc1MWgFNkNLTzG2wuUCmAiiff5X6Ri8z0D6QCdZRczW9tyehTYD/4GnOSQlm6dc+ABybaU
	vAmlLuZkJl38rSRctypsJKl3K0/M7P4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779723178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tglcw2CO1c40dMizXDLXH0Co2RvRnuE5M25POizJtGM=;
	b=ojP1cYC7VKdgMqqxkVWelKvu6C09BLiiS3nBC2e3XaDgqV+yRFhbr+VmH/6+JKz7gxtjYE
	/9kS/6kZDBVczHCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED11E59CF8;
	Mon, 25 May 2026 15:32:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pJ3ZOalrFGpfcgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 15:32:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9420AA08D7; Mon, 25 May 2026 17:32:53 +0200 (CEST)
Date: Mon, 25 May 2026 17:32:53 +0200
From: Jan Kara <jack@suse.cz>
To: Bohdan Trach <bohdan.trach@huaweicloud.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, mchehab+huawei@kernel.org, lilith.oberhauser@huawei.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: get ext4_group_desc in ext4_mb_prefetch only
 when necessary
Message-ID: <irjiwpcbbeqsebn5fkxfumy3k4scuew5e6c4jmuke6mgn5du3m@li3hjtxoislc>
References: <20260521125931.16474-1-bohdan.trach@huaweicloud.com>
 <20260521125931.16474-3-bohdan.trach@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521125931.16474-3-bohdan.trach@huaweicloud.com>
X-Spam-Score: 1.20
X-Spamd-Result: default: False [1.20 / 50.00];
	SEM_URIBL(3.50)[huaweicloud.com:email];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TAGGED_RCPT(0.00)[huawei];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[]
X-Spam-Level: *
X-Spam-Flag: NO

On Thu 21-05-26 14:59:29, Bohdan Trach wrote:
> Getting ext4_group_desc structure can contribute to the cost of
> ext4_mb_prefetch() without any need, as most groups fail the
> !EXT4_MB_GRP_TEST_AND_SET_READ check.
> 
> Optimize ext4_mb_prefetch by getting the group description only when
> necessary.
> 
> The result is further increase in performance of fallocate() system call
> path that triggers ext4_mb_prefetch() via a linear group scan.
> 
> Signed-off-by: Bohdan Trach <bohdan.trach@huaweicloud.com>

Looks good. Just one nit below:

> @@ -2872,14 +2870,17 @@ ext4_group_t ext4_mb_prefetch(struct super_block *sb, ext4_group_t group,
>  		 * prefetch once, so we avoid getblk() call, which can
>  		 * be expensive.
>  		 */
> -		if (gdp && grp && !EXT4_MB_GRP_TEST_AND_SET_READ(grp) &&
> -		    EXT4_MB_GRP_NEED_INIT(grp) &&
> -		    ext4_free_group_clusters(sb, gdp) > 0 ) {
> -			bh = ext4_read_block_bitmap_nowait(sb, group, true);
> -			if (!IS_ERR_OR_NULL(bh)) {
> -				if (!buffer_uptodate(bh) && cnt)
> -					(*cnt)++;
> -				brelse(bh);
> +		if (group < ngroups && grp && !EXT4_MB_GRP_TEST_AND_SET_READ(grp) &&

The group < ngroup should be always true and is also implicitly contained
in the 'grp != NULL' check. So I'd remove that bit. Otherwise feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

									Honza

> +		    EXT4_MB_GRP_NEED_INIT(grp)) {
> +			struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
> +
> +			if (gdp && ext4_free_group_clusters(sb, gdp) > 0) {
> +				bh = ext4_read_block_bitmap_nowait(sb, group, true);
> +				if (!IS_ERR_OR_NULL(bh)) {
> +					if (!buffer_uptodate(bh) && cnt)
> +						(*cnt)++;
> +					brelse(bh);
> +				}
>  			}
>  		}
>  		if (++group >= ngroups)
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
