Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523299;
	b=oIx34C1w2w+uzxAd5kIkPewuOx5YMbvOrFObkfr6jjKoetBd1qDKiYbpd9RFcprpo2+l
	 Jz43noqypl14voZ/G7gQ/Xf2D/MI3SgwTlT/HOufE9H1Q+/QuTFpaBD42ym2Ht3aHMf9s
	 J5lZnatReIxZ9lIAIBr8uNWQL/sLm9wjTlAKy/rncazSgUGCv+C0ddoh3Amb6V8Ht8bUS
	 ewju52owTU/HOjY/XAls/tQqKA5nR/xJ8QHUxyWdvkz9cUykaftD3XDyjykfnZ2wByhq6
	 n/rmaKv0DGM4su79/y6hnnpRkHcIostNEZs1Y8REQijjAnrSmv933z/ZzzKZrg2ezRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523299;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=8czMz2Fr2f1YRR+L5S5/DZyqr8W8+6nKYt7SK0INH8A=;
	b=2qWd0tzocG62oLGlVRsgQXk6yfbPHONKLrwy0mlWTIvsHHmCXgaN0WfY0p8dVzqtW8ud
	 lqU1pqRCEACDsoDa45basQagwJVa1aP3fLZZfzm7MRURHh6hkNZ6Kp0/X8tXFLB0z2H2G
	 FLiecMRfvXv0iwt2YJvgMujygzs4pwcMFdl/xliLlRHWgruzNI7J0uKpRXsXvjA/yo6En
	 +oroOchAGyXP3ZKscHxOOJixxADCaGq0ArFqnp7V3Q/z7N12oJttSSKGFWCXZh9H7Lhrj
	 e4ZhBUhWqQL/x8Qsys9CASZPEWtwtGH+HZAhoK7ClW0T17rDc0jNP2gpRmcN2GlN5cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zMYfh9Ag;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Dx4l9cfv;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zMYfh9Ag;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Dx4l9cfv;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81913606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 12:28:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81913606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zMYfh9Ag;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Dx4l9cfv;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zMYfh9Ag;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Dx4l9cfv
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F72B1F451;
	Tue, 24 Nov 2026 12:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795523296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8czMz2Fr2f1YRR+L5S5/DZyqr8W8+6nKYt7SK0INH8A=;
	b=zMYfh9AgtuQVismG3lWTPOik/sygy6+LNOGVi4Kt6inmUkYhdw9E27VjmCKPvVO2oKmao8
	YnNSE+lS5CutxtMilh1jk3uR+hgrjt5NLF8ifZNVbgZMVfkZLDhtjnX45JODQq36OPyS1V
	ODND/xa6hIG90ONGIi6mrBr3lbXRTY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795523296;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8czMz2Fr2f1YRR+L5S5/DZyqr8W8+6nKYt7SK0INH8A=;
	b=Dx4l9cfvyUBucpw5L4GgSkoyR9e3OynJ5JObFxAggUWyme9vw2K8A2C/hcXIi3OQcvt2LI
	VzIxAZ3pQkulTiCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zMYfh9Ag;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Dx4l9cfv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795523296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8czMz2Fr2f1YRR+L5S5/DZyqr8W8+6nKYt7SK0INH8A=;
	b=zMYfh9AgtuQVismG3lWTPOik/sygy6+LNOGVi4Kt6inmUkYhdw9E27VjmCKPvVO2oKmao8
	YnNSE+lS5CutxtMilh1jk3uR+hgrjt5NLF8ifZNVbgZMVfkZLDhtjnX45JODQq36OPyS1V
	ODND/xa6hIG90ONGIi6mrBr3lbXRTY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795523296;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8czMz2Fr2f1YRR+L5S5/DZyqr8W8+6nKYt7SK0INH8A=;
	b=Dx4l9cfvyUBucpw5L4GgSkoyR9e3OynJ5JObFxAggUWyme9vw2K8A2C/hcXIi3OQcvt2LI
	VzIxAZ3pQkulTiCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 77EC21339F;
	Tue, 24 Nov 2026 12:28:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AtI+FeCCBWvYAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 12:28:16 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id F23F527867; Tue, 24 Nov 2026 13:28:15 +0100 (CET)
Date: Tue, 24 Nov 2026 13:28:15 +0100
From: Jan Kara <jack@suse.cz>
To: Muhammad Umer <mumer.mobi@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com
Subject: Re: [PATCH 2/2] ext4: fix off-by-one in CR_BEST_AVAIL_LEN min_order
Message-ID: <cddcjsnfzrzboqqjxzim2krcxp6ds6au7xvgmqtyjt4wzs4okj@pr4l6mkyywov>
References: <20261122185630.2112-1-mumer.mobi@gmail.com>
 <20261122185630.2112-3-mumer.mobi@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122185630.2112-3-mumer.mobi@gmail.com>
X-Rspamd-Queue-Id: 9F72B1F451
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.51

On Sun 22-11-26 13:56:30, Muhammad Umer wrote:
> When the original request is longer than 1 << min_order, min_order is
> raised to fls(ac_o_ex.fe_len). For a power-of-two length that is one
> order too high: a 512-cluster request is never trimmed to 512 and falls
> through to CR_GOAL_LEN_SLOW even when 512-cluster free extents exist.
> 
> Use order_base_2() so the trimmed goal is the smallest power of two that
> covers the original request.
> 
> Reproducer: every group has only 512-block free extents. 2 MiB-aligned
> O_DIRECT writes to a file with a 64 MiB i_size; 9 of 12 allocations
> reach CR_BEST_AVAIL_LEN:
> 
>   write size   before                   after
>   511 blocks   9 x CR_BEST_AVAIL_LEN    9 x CR_BEST_AVAIL_LEN
>   512 blocks   9 x CR_GOAL_LEN_SLOW     9 x CR_BEST_AVAIL_LEN
> 
> Fixes: 7e170922f06b ("ext4: Add allocation criteria 1.5 (CR1_5)")
> Signed-off-by: Muhammad Umer <mumer.mobi@gmail.com>

Indeed. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/ext4/mballoc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 37825743f..8743ff5be 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1093,7 +1093,7 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
>  	}
>  
>  	if (1 << min_order < ac->ac_o_ex.fe_len)
> -		min_order = fls(ac->ac_o_ex.fe_len);
> +		min_order = order_base_2(ac->ac_o_ex.fe_len);
>  
>  	start = group;
>  	end = ext4_get_allocation_groups_count(ac);
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
